import { Component, Host, Element, Prop, h } from '@stencil/core';

@Component({
  tag: 'webp-image',
})
export class WebpImg {
  @Prop() src = '';
  @Prop() alt = '';
  @Prop() width: string | number;
  @Prop() height: string | number;
  @Prop() srcset = '';

  @Prop() class = '';
  @Prop() loading: 'lazy' | 'auto' | 'eager' = 'lazy';

  @Element() el;

  render() {
    const webpSrc = this.src.replace(/.png/gi, '.webp');
    return (
      <Host>
        <picture>
          <source type="image/webp" src={webpSrc} />
          <source type="image/png" src={this.src} />
          <img
            data-webp-image="true"
            src={this.src}
            alt={this.alt}
            width={this.width}
            height={this.height}
            class={this.class}
            loading={this.loading}
          />
        </picture>
      </Host>
    );
  }
}
