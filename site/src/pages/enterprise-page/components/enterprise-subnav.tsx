import { Element, Component, h, Host, State } from '@stencil/core';

declare let window: any;

@Component({
  tag: 'enterprise-subnav',
  styleUrl: 'enterprise-subnav.scss',
  scoped: true,
})
export class EnterpriseSubnav {
  @Element() el: HTMLElement;
  @State() visible: boolean;

  private observer: IntersectionObserver;

  componentWillLoad() {
    let options = {
      rootMargin: '0px',
      threshold: 1.0,
    };

    this.observer = new IntersectionObserver((entries) => {
      this.visible = entries[0].target.getBoundingClientRect().top < 0 ? true : false;
    }, options);

    this.observer.observe(this.el);
  }

  disconnectedCallback() {
    this.observer.unobserve(this.el);
  }

  scrollToForm(ev: any) {
    setTimeout(() => {
      document.getElementById('support').scrollIntoView({ behavior: 'smooth' });
      setTimeout(() => {
        document.getElementById('support').scrollIntoView({ behavior: 'smooth' });
      }, 667);
    }, 667);
  }

  render() {
    return (
      <Host
        class={{
          visible: this.visible,
        }}
      >
        <div class="wrapper heading-container">
          <span class="title">Enterprise</span>
          <div class="cta-row">
            <a href="#support" class="btn-primary" onClick={(ev) => this.scrollToForm(ev)}>
              Talk to sales
            </a>
          </div>
        </div>
      </Host>
    );
  }
}
