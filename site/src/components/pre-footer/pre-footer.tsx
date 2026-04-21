import { Component, Host, h, Prop } from '@stencil/core';
import { ResponsiveContainer, Heading, Paragraph } from 'ionic-ds-no-fonts';
import { defaults } from 'src/store';

@Component({
  tag: 'pre-footer',
  styleUrl: 'pre-footer.scss',
  scoped: true,
})
export class PreFooter {
  @Prop() defaults: typeof defaults;
  render() {
    return (
      <Host>
        <div class="squares"></div>
        <ResponsiveContainer>
          <a href={this.defaults.prefooter.left.href} class="underline-heading">
            <svg width="56" height="50" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path
                d="M1 1h16.2c2.86 0 5.61 1.12 7.64 3.12A10.6 10.6 0 0128 11.67V49c0-2.12-.85-4.16-2.37-5.66A8.15 8.15 0 0019.9 41H1V1zM55 1H38.8c-2.86 0-5.61 1.12-7.64 3.12A10.6 10.6 0 0028 11.67V49c0-2.12.85-4.16 2.37-5.66A8.15 8.15 0 0136.1 41H55V1z"
                stroke="#46B1FF"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
            </svg>
            <div class="heading-wrap">
              <Heading level={4}>
                {this.defaults.prefooter.left.title} <span class="arrow">-&gt;</span>
              </Heading>
            </div>
            <Paragraph>{this.defaults.prefooter.left.text}</Paragraph>
          </a>
          <a href={this.defaults.prefooter.right.href} class="underline-heading">
            <svg width="48" height="50" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path
                d="M47 34.85v-19.7c0-.65-.18-1.28-.51-1.84a3.77 3.77 0 00-1.4-1.35L26.9 1.76a5.91 5.91 0 00-5.78 0L2.9 11.95c-.58.32-1.07.79-1.4 1.35-.33.56-.5 1.19-.51 1.84v19.7c0 .65.18 1.28.51 1.84s.81 1.02 1.4 1.35l18.2 10.2a5.92 5.92 0 005.78 0l18.2-10.2c.59-.33 1.07-.8 1.4-1.35.33-.56.51-1.2.51-1.84z"
                stroke="#46B1FF"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
              <path
                d="M1.6 13.23L24 25.93l22.4-12.7M24 49V25.92"
                stroke="#46B1FF"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
            </svg>
            <div class="heading-wrap">
              <Heading level={4}>
                {this.defaults.prefooter.right.title} <span class="arrow">-&gt;</span>
              </Heading>
            </div>
            <Paragraph>{this.defaults.prefooter.right.text}</Paragraph>
          </a>
        </ResponsiveContainer>
      </Host>
    );
  }
}
