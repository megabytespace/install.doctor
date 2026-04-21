import { Component, Host, h, Prop } from '@stencil/core';
import { ResponsiveContainer, Heading, Paragraph } from 'ionic-ds-no-fonts';
import { href } from '@stencil/router';
import { defaults } from 'src/store';

declare let RS_MODULES: any;
declare let window: any;
declare let revapi4: any;
declare let jQuery: any;
declare let revslider_showDoubleJqueryError: any;

@Component({
  tag: 'not-found-page',
  styleUrl: 'not-found-page.scss',
  scoped: true,
})
export class NotFoundPage {
  @Prop() defaults: typeof defaults;

  render() {
    const { NotFoundSimple } = this;

    return (
      <Host>
        <meta-tags
          defaults={this.defaults}
          pageTitle="Not Found: 404 Error"
          description={
            'This is a link to a page that does not exist. You should still visit this page to see how awesome our 404 page is though.'
          }
          image={this.defaults.homepage + '/assets/img/og/404.png'}
        />
        <site-header defaults={this.defaults} class="heading-container" sticky={true} />
        <NotFoundSimple />
        <pre-footer defaults={this.defaults} />
        <capacitor-site-footer defaults={this.defaults} />
      </Host>
    );
  }

  NotFoundAnimated = () => (
    <ResponsiveContainer id="not-found" as="section">
      <iframe></iframe>
    </ResponsiveContainer>
  );

  NotFoundSimple = () => (
    <ResponsiveContainer id="not-found" as="section">
      <Heading class="top-text" level={1}>
        404: Not Found
      </Heading>
      <Paragraph class="top-text">
        Houston, we have a problem! This URL does not link to an existing page. You might want to start with the{' '}
        <a class="underline-hover link" {...href('/')}>
          home page
        </a>{' '}
        or go to the{' '}
        <a class="underline-hover link" href="/docs">
          documentation portal
        </a>{' '}
        welcome page.
      </Paragraph>
      <webp-image alt="404 not found graphic" src="/assets/img/404.png" loading="eager"></webp-image>
    </ResponsiveContainer>
  );
}
