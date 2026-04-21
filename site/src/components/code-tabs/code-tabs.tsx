import { Component, Host, h, Prop, State, Element, Build } from '@stencil/core';
import { pixelize } from 'src/utils/common';
import ResizeObserver from 'resize-observer-polyfill';

interface tabsProps {
  [key: string]: HTMLElement;
}

@Component({
  tag: 'code-tabs',
  styleUrl: 'code-tabs.scss',
  scoped: true,
})
export class CodeTabs {
  private tabsHandler = {
    set: (obj: tabsProps, prop: string, value: HTMLElement) => {
      if (prop === '0') {
        value.offsetWidth === 0 ? this.setResizeObserver(value) : this.setActive(value);
      }
      obj[prop] = value;
      return true;
    },
  };
  private tabs: tabsProps = new Proxy({}, this.tabsHandler);

  @Element() elm: HTMLElement;
  @Prop() data: {
    tabs: string[];
    languages: string[];
    code: string[];
  };
  @State() activeTab = {
    index: 0,
    left: '0px',
    width: '0px',
  };
  @State() codeLeft;

  setResizeObserver(el: HTMLElement) {
    const resizeObserver = new ResizeObserver((entries) => {
      for (const entry of entries) {
        if (entry.contentRect.width > 0) {
          this.setActive(el);
          resizeObserver.disconnect();
        }
      }
    });

    resizeObserver.observe(el);
  }

  handleTabSelect(ev: Event) {
    const target = ev.target as HTMLElement;
    this.setActive(target);
  }

  async setActive(target: HTMLElement) {
    if (Build.isServer) return;

    await customElements.whenDefined('code-tabs');

    this.activeTab = {
      ...this.activeTab,
      left: pixelize(target.offsetLeft),
      width: pixelize(target.offsetWidth),
    };

    this.codeLeft = `-${pixelize(this.elm.offsetWidth * this.activeTab.index)}`;
  }

  render() {
    return (
      <Host
        style={{
          '--tab-left': this.activeTab.left,
          '--tab-width': this.activeTab.width,
          '--code-left': this.codeLeft,
        }}
      >
        <nav>
          <div class="tabs-wrapper">
            {this.data.tabs.map((tab, i) => (
              <button
                class={{
                  active: this.activeTab.index === i,
                }}
                ref={(el) => !this.tabs.hasOwnProperty(i) && (this.tabs[i] = el)}
                onClick={(ev) => {
                  this.activeTab.index = i;
                  this.handleTabSelect(ev);
                }}
              >
                {tab}
              </button>
            ))}
          </div>
        </nav>
        <div class="background">
          <div class="code-wrapper">
            {this.data.code.map((code, i) => (
              <article>
                <code-snippet
                  language={this.data.languages.length === 1 ? this.data.languages[0] : this.data.languages[i]}
                  code={code}
                />
              </article>
            ))}
          </div>
        </div>
      </Host>
    );
  }
}
