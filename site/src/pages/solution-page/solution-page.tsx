import { Component, Host, h, Prop, ComponentInterface } from '@stencil/core';

import { ResponsiveContainer, Heading, Paragraph, Button } from 'ionic-ds-no-fonts';

import { SolutionUbuntu } from './solution-ubuntu';
import { SolutionFedora } from './solution-fedora';
import { SolutionCentOS } from './solution-centos';
import { SolutionDebian } from './solution-debian';
import { SolutionMacOS } from './solution-macos';
import { SolutionArchlinux } from './solution-archlinux';
import { SolutionQubes } from './solution-qubes';
import { SolutionWindows } from './solution-windows';
import { defaults } from 'src/store';

@Component({
  tag: 'solution-page',
  styleUrl: 'solution-page.scss',
  scoped: true,
})
export class SolutionPage implements ComponentInterface {
  @Prop() solutionId: string;
  @Prop() defaults: typeof defaults;

  framework: {
    id: string;
    name: string;
    theme: string;
    logo: string;
    dimensions: string;
  };
  componentWillLoad() {
    this.framework = this.defaults.solutionPage.solutions.find((entry) => entry.id === this.solutionId);
  }
  getComponent() {
    switch (this.solutionId) {
      case 'archlinux':
        return <SolutionArchlinux />;
      case 'centos':
        return <SolutionCentOS />;
      case 'debian':
        return <SolutionDebian />;
      case 'fedora':
        return <SolutionFedora />;
      case 'macos':
        return <SolutionMacOS />;
      case 'qubes':
        return <SolutionQubes />;
      case 'ubuntu':
        return <SolutionUbuntu />;
      case 'windows':
        return <SolutionWindows />;
    }
  }

  Demo = () => {
    return (
      <section id="demo">
        <ResponsiveContainer>
          <div class="heading-group">
            <Heading id="demo-heading" level={2}>
              {this.defaults.solutionPage.enterpriseSupport.title}
            </Heading>
            <Paragraph>
              Get it done the easy way by leveraging our team of <b>{this.framework.name} experts</b>.
            </Paragraph>
            <Paragraph>{this.defaults.solutionPage.enterpriseSupport.paragraph1}</Paragraph>
            <Paragraph>{this.defaults.solutionPage.enterpriseSupport.paragraph2}</Paragraph>
            <Paragraph>
              <b class="noshow-noscript">
                Use the form below to send us a message or ask questions about how {this.defaults.brandName} can help
                you with your specific needs.
              </b>
              <noscript>
                <b>
                  Send an e-mail to <a href={'mailto:' + this.defaults.brandEmail}>{this.defaults.brandEmail}</a> with
                  details on how we can help and we will respond to you in a timely fashion.
                </b>
              </noscript>
            </Paragraph>
          </div>
          <capacitor-hubspot-form defaults={this.defaults} />
        </ResponsiveContainer>
      </section>
    );
  };

  render() {
    return (
      <Host>
        <meta-tags
          defaults={this.defaults}
          pageTitle={this.defaults.solutionPage.meta.pageTitle(this.framework.name)}
          description={this.defaults.solutionPage.meta.pageTitle(this.framework.name)}
          image={this.defaults.homepage + '/assets/img/og/' + this.framework.name + '.png'}
        />
        <site-header defaults={this.defaults} class="heading-container" sticky={true} />
        <ResponsiveContainer id="top" as="section">
          <div class="heading-group">
            <webp-image
              width="301"
              height="167"
              loading="eager"
              src={this.framework.logo}
              alt={this.framework.name}
              class="react"
            />
            <Heading level={2} as="h1">
              {this.framework.name} &amp; {this.defaults.brandName}
            </Heading>
            <Paragraph level={2}>
              {this.defaults.solutionPage.subHeader.text1} {this.framework.name}{' '}
              {this.defaults.solutionPage.subHeader.text2}
            </Paragraph>
            <Button anchor href="#install" id="get-started" style={{ '--button-background': this.framework.theme }}>
              Get Started
            </Button>
          </div>
        </ResponsiveContainer>
        {this.getComponent()}
        <section id="continue">
          <ResponsiveContainer>
            <Heading level={3}>Continue your {this.defaults.brandName} journey.</Heading>
            <Paragraph>
              This is only the beginning. Browse through the {this.defaults.brandName}{' '}
              <a class="underline-hover link" href={this.defaults.social.github} target="_blank" rel="noopener">
                GitHub repository
              </a>{' '}
              or dive deeper by going through the{' '}
              <a class="underline-hover link" href="/docs">
                documentation
              </a>{' '}
              .
            </Paragraph>
          </ResponsiveContainer>
        </section>
        {this.Demo()}
        <pre-footer defaults={this.defaults} />
        <capacitor-site-footer defaults={this.defaults} />
      </Host>
    );
  }
}
