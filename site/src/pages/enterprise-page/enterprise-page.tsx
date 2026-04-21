import { Component, h, Host, Prop } from '@stencil/core';
import { ResponsiveContainer, Heading, Button, PrismicRichText, Paragraph } from 'ionic-ds-no-fonts';
import { State } from '@stencil/core/internal';
import { EnterprisePageData } from 'src/store';

@Component({
  tag: 'enterprise-page',
  styleUrl: 'enterprise-page.scss',
  scoped: true,
})
export class EnterprisePage {
  @Prop() data: typeof EnterprisePageData;
  @State() ebookModalOpen = false;

  render() {
    const {
      Top,
      Native,
      // Ebook,
      MicroFrontends,
      Plugins,
      Security,
      Delivery,
      SupportGuidance,
      Features,
      Demo,
      Editions,
    } = this;

    return (
      <Host>
        <meta-tags
          defaults={this.data.defaults}
          pageTitle={this.data.defaults.enterprisePage.meta.pageTitle}
          description={this.data.defaults.enterprisePage.meta.description}
          image={this.data.defaults.homepage + '/assets/img/og/enterprise.png'}
        />
        <site-header defaults={this.data.defaults} class="heading-container" sticky={true} />
        <enterprise-subnav />
        <Top />
        <Native />
        {/* <Ebook /> */}
        {/* <Approach /> */}
        <MicroFrontends />
        <Plugins />
        <Security />
        <Delivery />
        <SupportGuidance />
        <Features />
        <Editions />
        <Demo />
        <pre-footer defaults={this.data.defaults} />
        <capacitor-site-footer defaults={this.data.defaults} />
        <site-modal open={this.ebookModalOpen} onModalClose={() => (this.ebookModalOpen = false)}>
          <Heading level={2}>{this.data.defaults.eBookSiteModal.title}</Heading>
          <Paragraph>
            Fill out and submit the form below to get your free copy of{' '}
            <b>{this.data.defaults.eBookSiteModal.eBookTitle}</b> sent to your e-mail.
          </Paragraph>
          <capacitor-hubspot-form defaults={this.data.defaults} />
        </site-modal>
      </Host>
    );
  }

  talkToSales() {
    setTimeout(() => {
      document.getElementById('support').scrollIntoView({ behavior: 'smooth' });
      setTimeout(() => {
        document.getElementById('support').scrollIntoView({ behavior: 'smooth' });
      }, 667);
    }, 667);
  }

  Top = () => {
    const { top } = this.data;
    const { title, text, cta_1, background } = top[0];

    return (
      <section id="top">
        <prismic-image defaults={this.data.defaults} image={background} class="background" loading="eager" />
        <ResponsiveContainer>
          <div class="heading-group">
            <Heading level={1}>{title}</Heading>
            <Paragraph level={2}>{text}</Paragraph>
            <div class="cta-row">
              <Button anchor href="#support" kind="round" onClick={() => this.talkToSales()}>
                {cta_1}
                <span class="arrow"> -&gt;</span>
              </Button>
              <a href={this.data.defaults.enterprisePage.topCTA2.href} class="link btn-link">
                {this.data.defaults.enterprisePage.topCTA2.text}
                <span class="arrow"> -&gt;</span>
              </a>
            </div>
          </div>
        </ResponsiveContainer>
      </section>
    );
  };

  Native = () => {
    const { native, native__list } = this.data;
    const { supertext, title, subtext } = native[0];

    const icons = [
      ['Three blocks with up arrow', '64x64'],
      ['Clock icon with up arrow', '64x64'],
      ['Fingerprint icon with lock symbol', '64x64'],
    ];

    return (
      <ResponsiveContainer id="native" as="section">
        <div class="heading-group">
          <p class="ui-heading-6">
            <sup>{supertext}</sup>
          </p>
          <PrismicRichText richText={title} />
          <Paragraph level={2}>{subtext}</Paragraph>
        </div>
        <ul class="list">
          {native__list.map(({ title, text }, i) => (
            <li key={icons[i][0]}>
              <webp-image
                class="icon-height-fix"
                width={icons[i][1].split('x')[0]}
                height={icons[i][1].split('x')[1]}
                src={`/assets/img/enterprise/enterprise-overview-${i}.png`}
                loading="eager"
              />
              <Heading level={4} as="h3">
                {title}
              </Heading>
              <Paragraph leading="prose">{text}</Paragraph>
            </li>
          ))}
        </ul>
      </ResponsiveContainer>
    );
  };

  Ebook = () => {
    const { ebook } = this.data;
    const { text, cta, background, book } = ebook[0];
    return (
      <section id="ebook">
        <ResponsiveContainer>
          <div class="wrapper">
            <prismic-image defaults={this.data.defaults} image={background} class="background" />
            <div class="content">
              <div class="image-wrapper">
                <prismic-image defaults={this.data.defaults} image={book} />
              </div>
              <div class="heading-group">
                <PrismicRichText paragraphLevel={1} richText={text} />
                <Button kind="round" size="md" onClick={() => (this.ebookModalOpen = true)}>
                  {cta} <span class="arrow"> -&gt;</span>
                </Button>
              </div>
            </div>
          </div>
        </ResponsiveContainer>
      </section>
    );
  };

  // Approach = () => {
  //   const {
  //     approach,
  //     approach_traditional,
  //     approach_traditional__list,
  //     approach_web,
  //     approach_web__list,
  //   } = this.data;
  //   const { supertext, title } = approach[0];

  //   return (
  //     <section id="approach">
  //       <ResponsiveContainer>
  //         <div class="heading-group">
  //           <p class="ui-heading-6">
  //             <sup>{supertext}</sup>
  //           </p>
  //           <PrismicRichText richText={title} />
  //         </div>
  //         <div class="split">
  //           <article class="traditional column">
  //             <Heading>{approach_traditional[0]['title']}</Heading>
  //             <Paragraph>{approach_traditional[0]['text']}</Paragraph>
  //             <PrismicResponsiveImage
  //               image={approach_traditional[0]['image']}
  //             />
  //             <div class="list">
  //               <Heading level={4}>
  //                 {approach_traditional[0]['subtitle']}
  //               </Heading>
  //               <ul>
  //                 {approach_traditional__list.map(({ text, icon }) => (
  //                   <li>
  //                     <PrismicResponsiveImage image={icon} />
  //                     <Paragraph>{text}</Paragraph>
  //                   </li>
  //                 ))}
  //               </ul>
  //             </div>
  //           </article>
  //           <article class="web column">
  //             <Heading>{approach_web[0]['title']}</Heading>
  //             <Paragraph>{approach_web[0]['text']}</Paragraph>
  //             <PrismicResponsiveImage image={approach_web[0]['image']} />
  //             <div class="list">
  //               <Heading level={4}>{approach_web[0]['subtitle']}</Heading>
  //               <ul>
  //                 {approach_web__list.map(({ text, icon }) => (
  //                   <li>
  //                     <PrismicResponsiveImage image={icon} />
  //                     <Paragraph>{text}</Paragraph>
  //                   </li>
  //                 ))}
  //               </ul>
  //             </div>
  //           </article>
  //         </div>
  //       </ResponsiveContainer>
  //     </section>
  //   );
  // };

  MicroFrontends = () => {
    const { micro_frontends } = this.data;
    const { supertext, title, subtext, image } = micro_frontends[0];

    return (
      <section id="micro-frontends">
        <ResponsiveContainer>
          <div class="wrapper">
            <div class="image-wrapper">
              <prismic-image defaults={this.data.defaults} image={image} />
            </div>
            <div class="heading-group">
              <p class="ui-heading-6">
                <sup>{supertext}</sup>
              </p>
              <PrismicRichText richText={title} />
              <PrismicRichText richText={subtext} paragraphLevel={2} />
            </div>
          </div>
        </ResponsiveContainer>
      </section>
    );
  };

  Plugins = () => {
    const { plugins } = this.data;
    const { supertext, title, subtext, image } = plugins[0];

    return (
      <section id="plugins">
        <ResponsiveContainer>
          <div class="wrapper">
            <div class="heading-group">
              <p class="ui-heading-6">
                <sup>{supertext}</sup>
              </p>
              <PrismicRichText richText={title} />
              <Paragraph level={2}>{subtext}</Paragraph>
            </div>
            <div class="image-wrapper">
              <prismic-image defaults={this.data.defaults} image={image} />
            </div>
          </div>
        </ResponsiveContainer>
      </section>
    );
  };

  Security = () => {
    const { security } = this.data;
    const { supertext, title, subtext, image } = security[0];

    return (
      <section id="security">
        <ResponsiveContainer>
          <div class="wrapper">
            <div class="image-wrapper">
              <prismic-image defaults={this.data.defaults} image={image} />
            </div>
            <div class="heading-group">
              <p class="ui-heading-6">
                <sup>{supertext}</sup>
              </p>
              <PrismicRichText richText={title} />
              <PrismicRichText richText={subtext} paragraphLevel={2} />
            </div>
          </div>
        </ResponsiveContainer>
      </section>
    );
  };

  Delivery = () => {
    const { delivery } = this.data;
    const { supertext, title, subtext, image } = delivery[0];

    return (
      <section id="delivery">
        <ResponsiveContainer>
          <div class="wrapper">
            <div class="heading-group">
              <p class="ui-heading-6">
                <sup>{supertext}</sup>
              </p>
              <PrismicRichText richText={title} />
              <PrismicRichText richText={subtext} paragraphLevel={2} />
            </div>
            <div class="image-wrapper">
              <prismic-image defaults={this.data.defaults} image={image} />
            </div>
          </div>
        </ResponsiveContainer>
      </section>
    );
  };

  SupportGuidance = () => {
    const { support_guidance } = this.data;

    return (
      <section id="support-guidance">
        <ResponsiveContainer>
          <div class="wrapper">
            {support_guidance.map(({ image, title, text }) => (
              <article>
                <prismic-image defaults={this.data.defaults} image={image} />
                <Heading level={3}>{title}</Heading>
                <Paragraph level={2}>{text}</Paragraph>
              </article>
            ))}
          </div>
        </ResponsiveContainer>
      </section>
    );
  };

  Features = () => {
    const { features, features__list } = this.data;
    const { supertext, title, subtext } = features[0];

    return (
      <section id="features">
        <ResponsiveContainer>
          <div class="wrapper">
            <div class="heading-group">
              <p class="ui-heading-6">
                <sup>{supertext}</sup>
              </p>
              <PrismicRichText richText={title} />
              <PrismicRichText richText={subtext} paragraphLevel={2} />
            </div>
            <ul>
              {features__list.map(({ icon, title, text }) => (
                <li>
                  <div class="image-wrapper">
                    <prismic-image defaults={this.data.defaults} image={icon} />
                  </div>
                  <div>
                    <Heading level={4} as="h3">
                      {title}
                    </Heading>
                    <Paragraph>{text}</Paragraph>
                  </div>
                </li>
              ))}
            </ul>
          </div>
        </ResponsiveContainer>
      </section>
    );
  };

  Editions = () => {
    const { editions } = this.data;
    const { supertext, title, paragraph_1, paragraph_2, cta_1, image } = editions[0];

    return (
      <section id="editions">
        <ResponsiveContainer>
          <div class="wrapper">
            <div class="heading-group">
              <p class="ui-heading-6">
                <sup>{supertext}</sup>
              </p>
              <PrismicRichText richText={title} />
              <PrismicRichText richText={paragraph_1} paragraphLevel={2} />
              <PrismicRichText richText={paragraph_2} paragraphLevel={2} />
              <div class="cta-row">
                <Button href="#support" anchor kind="round" onClick={() => this.talkToSales()}>
                  {cta_1}
                  <span class="arrow"> -&gt;</span>
                </Button>
                <a href={this.data.defaults.enterprisePage.bottomCTA2.href} class="link btn-link">
                  {this.data.defaults.enterprisePage.bottomCTA2.text}
                  <span class="arrow"> -&gt;</span>
                </a>
              </div>
            </div>
            <div class="image-wrapper">
              <prismic-image defaults={this.data.defaults} image={image} />
            </div>
          </div>
        </ResponsiveContainer>
      </section>
    );
  };

  Demo = () => {
    const { demo } = this.data;
    const { supertext, title } = demo[0];

    return (
      <section id="inquiry">
        <ResponsiveContainer>
          <div class="heading-group">
            <p class="ui-heading-6">
              <sup>{supertext}</sup>
            </p>
            <Heading level={2} id="support" name="support">
              {title}
            </Heading>
            <Paragraph>{this.data.defaults.enterprisePage.inquiryParagraph1}</Paragraph>
            <Paragraph>{this.data.defaults.enterprisePage.inquiryParagraph2}</Paragraph>
            <Paragraph class="bold-instructions">
              <b class="noshow-noscript">Submit your inquiry below and we will respond to you in a timely fashion.</b>
              <noscript>
                <b>
                  Send an e-mail to{' '}
                  <a href={'mailto:' + this.data.defaults.brandEmail}>{this.data.defaults.brandEmail}</a> and we will
                  respond to you in a timely fashion.
                </b>
              </noscript>
            </Paragraph>
          </div>
          <capacitor-hubspot-form defaults={this.data.defaults} />
        </ResponsiveContainer>
      </section>
    );
  };
}
