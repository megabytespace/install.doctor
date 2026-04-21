import { State, Component, ComponentInterface, Element, Prop, Host, h, Listen } from '@stencil/core';
import { defaults } from 'src/store';
import Router from '../../router';
import { importResource } from '../../utils/common';
import { SiteHeader } from '../capacitor-site-header/capacitor-site-header';

declare global {
  interface Window {
    docsearch: (opts?: {}) => any;
  }
}

@Component({
  tag: 'docs-search',
  styleUrl: 'docs-search.scss',
})
export class DocsSearch implements ComponentInterface {
  private siteContent: HTMLElement;
  private contentWidth = 736;
  @Prop() uniqueId = Math.random().toString().replace('.', '');

  @Prop() theme: SiteHeader['theme'] = 'light';
  @Prop() placeholder = 'Search';
  @Prop() defaults: typeof defaults;

  @Element() el: HTMLElement;
  @State() input: {
    el?: HTMLInputElement;
    isPristine: boolean;
    isEmpty: boolean;
  } = {
    isPristine: true,
    isEmpty: true,
  };
  @State() searchStats: {
    width?: string;
    left?: string;
  } = {};

  componentDidLoad() {
    if (!(window as any).algoliaLoaded) {
      (window as any).algoliaLoaded = true;
      const algolia = `/assets/js/docsearch.min.js`;
      importResource({ propertyName: 'docsearch', link: algolia, async: true }, () => this.setupSearch());
    }

    this.el.addEventListener(
      'focus',
      () => {
        console.log(`Focus: ${this.el}`);
        this.siteContent = document.querySelector('section.ui-container') || document.querySelector('div.ui-container');
        this.getContentStats();
      },
      true
    );
  }

  @Listen('resize', { target: 'window' })
  getContentStats() {
    requestAnimationFrame(() => {
      if (!this.siteContent) return;

      let left = this.siteContent.getBoundingClientRect().left - this.el.getBoundingClientRect().left;
      let width = this.siteContent.offsetWidth;

      if (width > this.contentWidth) {
        left -= (this.contentWidth - width) / 2;

        this.searchStats = {
          width: this.contentWidth.toString().concat('px'),
          left: left.toString().concat('px'),
        };
      } else {
        this.searchStats = {
          width: width.toString().concat('px'),
          left: left.toString().concat('px'),
        };
      }
    });
  }

  setupSearch() {
    setTimeout(() => {
      window.docsearch({
        appId: this.defaults.algolia.appId,
        apiKey: this.defaults.algolia.apiKey,
        indexName: this.defaults.algolia.indexName,
        contextualSearch: true,
        inputSelector: `#input-${this.uniqueId}`,
        debug: false, // Set debug to true if you want to inspect the dropdown
        queryHook: (e, t) => {
          console.log(`Query: ${t}`);
          console.log(`Event: ${e}`);
          if (this.input.isPristine) {
            this.input.isPristine = false;

            this.input.el = this.el.querySelector(`#id-${this.uniqueId} input[name="search"]`) as HTMLInputElement;

            this.input.el.oninput = () => this.handleInput();

            this.handleInput();
            this.getContentStats();
          }
        },
        handleSelected: (_, __, suggestion) => {
          console.log(`Selected: ${suggestion}`);
          console.log(_);
          console.log(__);
          const url = suggestion.url.replace(defaults.homepage, '');
          this.clearSearch();
          if (url.substring(0, 5) === '/docs' || url.substring(0, 5) === '/auth' || url.substring(0, 5) === '/app/') {
            window.location.pathname = url;
          } else {
            Router.push(url);
          }
        },
      });
    }, 1000);
  }

  clearSearch = () => {
    this.input.el.value = '';
    this.input = {
      ...this.input,
      isEmpty: true,
    };
  };

  handleInput() {
    if (this.input.el.value === '') {
      this.input = { ...this.input, isEmpty: true };
    } else {
      this.input = { ...this.input, isEmpty: false };
    }
  }

  render() {
    const { placeholder } = this;

    return (
      <Host
        id={`id-${this.uniqueId}`}
        style={{
          '--search-left': this.searchStats.left,
          '--search-width': this.searchStats.width,
        }}
        class={`theme--${this.theme}`}
      >
        <svg class="search-icon" width="14" height="14" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path
            d="M13.7854 12.5947L10.6117 9.421a5.8626 5.8626 0 001.1752-3.5276C11.7869 2.6438 9.1431 0 5.8934 0 2.6438 0 0 2.6438 0 5.8934c0 3.2497 2.6438 5.8935 5.8934 5.8935a5.8626 5.8626 0 003.5276-1.1752l3.1737 3.1737a.8436.8436 0 001.1583-.0324.8436.8436 0 00.0324-1.1583zM1.6838 5.8934a4.2096 4.2096 0 114.2096 4.2096 4.2145 4.2145 0 01-4.2096-4.2096z"
            fill="#B2BECD"
          />
        </svg>
        <span class="algolia-autocomplete">
          <input
            id={`input-${this.uniqueId}`}
            name="search"
            type="search"
            autocomplete="off"
            placeholder={placeholder}
            aria-label={placeholder}
            required
            style={{
              visibility: 'hidden',
            }}
          />
        </span>
        <ion-icon
          style={{
            display: this.input.isEmpty ? 'none' : 'block',
          }}
          class="close"
          icon="close"
          onClick={() => this.clearSearch()}
        />
        <site-backdrop mobileOnly visible={!this.input.isEmpty} onClick={() => this.clearSearch()} />
      </Host>
    );
  }
}
