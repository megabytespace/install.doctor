import { Component, Host, h, Prop } from '@stencil/core';

import { Heading, Paragraph, ResponsiveContainer } from 'ionic-ds-no-fonts';
import { BlogData } from 'src/data.server/blog';
import { href } from '@stencil/router';
import { defaults } from 'src/store';

@Component({
  tag: 'blog-page',
  styleUrl: 'blog-page.scss',
  scoped: true,
})
export class BlogPage {
  @Prop() data: BlogData[];
  @Prop() defaults: typeof defaults;

  render() {
    if (!this.data) console.error('No blog posts received');
    return (
      <Host>
        <meta-tags
          defaults={this.defaults}
          pageTitle={this.defaults.blogPage.meta.pageTitle}
          description={this.defaults.blogPage.meta.description}
          rssTitle={this.defaults.blogRssTitle}
          image={this.defaults.homepage + '/assets/img/og/blog.png'}
        />
        <site-header defaults={this.defaults} class="heading-container" sticky={true} />
        <ResponsiveContainer>
          <div class="heading-group">
            <Heading level={2} as="h1">
              {this.defaults.blogPage.title}
            </Heading>
            <Paragraph level={2}>{this.defaults.blogPage.subheader}</Paragraph>
          </div>
          <div class="content">
            {this.data?.map((d, i) => (
              <article key={i}>
                <blog-post defaults={this.defaults} data={d} preview={true} />
              </article>
            ))}
            <blog-pagination defaults={this.defaults} rssIcon />
          </div>
        </ResponsiveContainer>
        <ResponsiveContainer class="blog-info-wrapper">
          <div class="blog-info what-is">
            <ion-icon class="what-is-info-icon" name="information-circle-outline"></ion-icon>
            <h4>About the {this.defaults.brandName} Blog</h4>
            <p class="underline-hover-p">
              Our articles are written by the {this.defaults.brandName} team and community. If you would like to post on
              our blog, you can do so by opening up a pull request against{' '}
              <a
                href={this.defaults.social.github + '-site/tree/master/pages/blog'}
                target="_blank"
                rel="noopener"
                class="underline-hover"
              >
                our website's repository
              </a>{' '}
              on GitHub. There, you can also browse through our site's source code which is a modified version of the{' '}
              <a
                href="https://github.com/ionic-team/capacitor-site"
                target="_blank"
                rel="noopener"
                class="underline-hover"
              >
                Capacitor's open-source website
              </a>{' '}
              project. If you would like to base your next website off of this modified version of the Capacitor website
              that removes the Prismic dependency (among a few other features), then please{' '}
              <a {...href('/community')} class="underline-hover">
                join our community
              </a>{' '}
              and ask for help.
            </p>
          </div>
        </ResponsiveContainer>
        <capacitor-site-footer defaults={this.defaults} />
      </Host>
    );
  }
}
