import { Component, h, Element, State, Host, Prop } from '@stencil/core';
import { IntersectionHelper, Breadcrumbs } from 'ionic-ds-no-fonts';

@Component({
  tag: 'blog-subnav',
  styleUrl: 'blog-subnav.scss',
  scoped: true,
})
export class BlogSubnav {
  @Element() el?: HTMLElement;
  @State() sticky = false;
  @State() open = false;
  @Prop() breadcrumbs: [string, string][] = [];
  @Prop() socialActions: boolean = false;
  @Prop() pagination: boolean = false;

  componentDidLoad() {
    IntersectionHelper.addListener(({ entries }) => {
      const e = entries.find((e) => (e.target as HTMLElement) === this.el);
      if (!e) {
        return;
      }

      if (e.intersectionRatio < 1) {
        this.sticky = true;
      } else {
        this.sticky = false;
      }
    });
    IntersectionHelper.observe(this.el!);
  }

  render = () => (
    <Host
      class={{
        sticky: this.sticky,
        'ui-container': true,
      }}
    >
      <div class="subnav-wrapper">
        <div class="content">
          <Breadcrumbs onClick={() => window.scrollTo(0, 0)}>
            {this.breadcrumbs.map((crumb, i) => (
              <li>
                {i !== this.breadcrumbs.length - 1 ? (
                  <a class="ui-heading-5" href={`${crumb[1]}`}>
                    <span class="arrow">&lt;-</span>
                    {crumb[0]}
                  </a>
                ) : (
                  crumb[0]
                )}
              </li>
            ))}
          </Breadcrumbs>
          <div class="blog-search-wrapper">
            {/* <Breakpoint class="mobile" xs={true} md={false} display="flex">
              {this.open
              ? <ion-icon
                  onClick={() => this.open = false}
                  class="drawer-button"
                  role="button" aria-label="close drawer"
                  name="chevron-up-outline"
                ></ion-icon>
              : <ion-icon
                  onClick={() => this.open = true}
                  class="drawer-button"
                  role="button" aria-label="open drawer"
                  name="chevron-down-outline"
                ></ion-icon> }
            </Breakpoint> */}
          </div>
          {/* <div
            class={{
              'subnav-dropdown': true,
              'open': this.open
            }}
          >
            <ResponsiveContainer>
              {this.socialActions
              ? <blog-social-actions /> : ''}
              {this.pagination
              ? <blog-pagination defaults={this.defaults} linkText={['Older', 'Newer']}/> : ''}
            </ResponsiveContainer>
          </div> */}
        </div>
      </div>
    </Host>
  );
}
