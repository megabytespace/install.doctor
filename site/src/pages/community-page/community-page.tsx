import { Component, Host, h, Prop } from '@stencil/core';
import { ResponsiveContainer, PrismicRichText, Paragraph, Heading } from 'ionic-ds-no-fonts';

@Component({
  tag: 'community-page',
  styleUrl: 'community-page.scss',
  scoped: true,
})
export class CommunityPage {
  @Prop() data: any;

  render() {
    const { Top, WhyJoin } = this;

    return (
      <Host>
        <meta-tags
          defaults={this.data.defaults}
          pageTitle={this.data.defaults.communityPage.meta.pageTitle}
          description={this.data.defaults.communityPage.meta.description}
          image={this.data.defaults.homepage + '/assets/img/og/community.png'}
        />
        <site-header defaults={this.data.defaults} class="heading-container" sticky={true} />
        <Top />
        <WhyJoin />
        <pre-footer defaults={this.data.defaults} />
        <capacitor-site-footer defaults={this.data.defaults} />
      </Host>
    );
  }

  Top = () => {
    const { top, community_list_1, community_list_2, community_list_3 } = this.data;

    return (
      <ResponsiveContainer id="top" as="section">
        <div class="heading-group">
          <PrismicRichText richText={top} paragraphLevel={2} />
        </div>
        <div class="cards">
          {community_list_1.map(({ image, text, link: { target, url } }) => (
            <a target={target} href={url} class="underline-heading card">
              <div class="image-wrapper">
                <prismic-image defaults={this.data.defaults} image={image} loading="eager" />
              </div>
              <PrismicRichText richText={text} />
            </a>
          ))}
        </div>
        <div class="cards">
          {community_list_2.map(({ image, text, link: { target, url } }) => (
            <a target={target} href={url} class="underline-heading card">
              <div class="image-wrapper">
                <prismic-image defaults={this.data.defaults} image={image} loading="eager" />
              </div>
              <PrismicRichText richText={text} />
            </a>
          ))}
        </div>
        <div class="cards">
          {community_list_3.map(({ image, text, link: { target, url } }) => (
            <a target={target} href={url} class="underline-heading card">
              <div class="image-wrapper">
                <prismic-image defaults={this.data.defaults} image={image} loading="eager" />
              </div>
              <PrismicRichText richText={text} />
            </a>
          ))}
        </div>
      </ResponsiveContainer>
    );
  };

  WhyJoin = () => {
    return (
      <ResponsiveContainer id="what-is" as="section">
        <div class="ui-container">
          <ion-icon class="what-is-info-icon" name="information-circle-outline"></ion-icon>
          <Heading class="quote-summary" level={2}>
            <b>{this.data.defaults.communityPage.whyJoin.title}</b>
          </Heading>
          <Paragraph class="quote-summary">{this.data.defaults.communityPage.whyJoin.paragraph1}</Paragraph>
          <Paragraph class="quote-summary">{this.data.defaults.communityPage.whyJoin.paragraph2}</Paragraph>
          <Paragraph class="quote-summary">{this.data.defaults.communityPage.whyJoin.paragraph3}</Paragraph>
        </div>
      </ResponsiveContainer>
    );
  };
}
