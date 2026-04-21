import { Component, Element, Prop, h } from '@stencil/core';
import Helmet from '@stencil/helmet';
import { defaults } from 'src/store';

@Component({
  tag: 'meta-tags',
})
export class MetaTags {
  site;
  @Prop() pageTitle?;
  @Prop() defaults: typeof defaults;
  @Prop() description?;
  @Prop() image?;
  @Prop() authorTwitter?;
  @Prop() ogType?;
  @Prop() canonicalUrl?;
  @Prop() rssTitle?;

  @Element() el;

  render() {
    this.site = this.defaults.homepage;
    if (!this.canonicalUrl) this.canonicalUrl = `${this.site}${location.pathname}`;
    if (!this.pageTitle) this.pageTitle = this.defaults.pageTitle;
    if (!this.description) this.description = this.defaults.description;
    if (!this.image) this.image = this.defaults.image;
    if (!this.authorTwitter) this.authorTwitter = this.defaults.authorTwitter;
    if (!this.ogType) this.ogType = this.defaults.ogType;
    const prettyTitle =
      this.pageTitle === defaults.pageTitle ? this.pageTitle : `${this.pageTitle} | ${this.defaults.brandName}`;

    //if (!this.el.isConnected || Build.isServer) {
    //  return <Host></Host>
    //}
    if (this.rssTitle) {
      return (
        <Helmet>
          <title>{prettyTitle}</title>
          <meta name="description" content={this.description} />
          <meta itemprop="image" content={this.image}></meta>
          <meta property="al:web:url" content={this.canonicalUrl}></meta>
          <meta property="og:type" content={this.ogType} />
          <meta property="og:title" content={prettyTitle} />
          <meta property="og:description" content={this.description} />
          <meta property="og:image" content={this.image} />
          {/* Fixed domain and strip out hashtags and query strings */}
          <meta property="og:url" content={`${this.site}${location.pathname}`} />
          <meta name="twitter:title" content={prettyTitle} />
          <meta name="twitter:description" content={this.description} />
          <meta name="twitter:image" content={this.image} />
          <meta name="twitter:creator" content={this.authorTwitter} />
          <meta name="rss:title" content={this.rssTitle} />
          <link rel="canonical" href={this.canonicalUrl} />
          <link
            rel="alternate"
            type="application/rss+xml"
            title={this.rssTitle}
            href={this.canonicalUrl + '/rss.xml'}
          />
        </Helmet>
      );
    } else {
      return (
        <Helmet>
          <title>{prettyTitle}</title>
          <meta name="description" content={this.description} />
          <meta itemprop="image" content={this.image}></meta>
          <meta property="al:web:url" content={this.canonicalUrl}></meta>
          <meta property="og:type" content={this.ogType} />
          <meta property="og:title" content={prettyTitle} />
          <meta property="og:description" content={this.description} />
          <meta property="og:image" content={this.image} />
          {/* Fixed domain and strip out hashtags and query strings */}
          <meta property="og:url" content={`${this.site}${location.pathname}`} />
          <meta name="twitter:title" content={prettyTitle} />
          <meta name="twitter:description" content={this.description} />
          <meta name="twitter:image" content={this.image} />
          <meta name="twitter:creator" content={this.authorTwitter} />
          <link rel="canonical" href={this.canonicalUrl} />
        </Helmet>
      );
    }
  }
}
