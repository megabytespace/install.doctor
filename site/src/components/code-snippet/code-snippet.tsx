import { Component, Host, h, Prop, Element, Build } from '@stencil/core';
import { importResource } from 'src/utils/common';

declare let window: any;

@Component({
  tag: 'code-snippet',
  styleUrl: 'code-snippet.scss',
  shadow: true,
})
export class CodeSnippet {
  @Element() elm: HTMLElement;
  @Prop() language: string;
  @Prop() code!: string;

  // use an exact version so the cdn response is heavily cached
  private static prismCdn = `/assets/js`;
  private codeEl: HTMLElement;

  componentWillLoad() {
    if (Build.isServer) return;
    if (!window.prismLoaded) {
      window.prismLoaded = true;
      importResource({ propertyName: 'Prism', link: `${CodeSnippet.prismCdn}/prism.min.js` }, () => {
        this.loadInPrismLanguage();
      });
    } else {
      const prismInterval = setInterval(() => {
        if (window.Prism) {
          clearInterval(prismInterval);
          this.loadInPrismLanguage();
        }
      }, 50);
    }
  }

  loadInPrismLanguage = () => {
    if (!window.prismLanguageLoaded) {
      window.prismLanguageLoaded = {};
    }
    if (!window.prismLanguageLoaded[`Prism.languages.${this.language}`]) {
      window.prismLanguageLoaded[`Prism.languages.${this.language}`] = true;
      if (this.language) {
        importResource(
          {
            propertyName: `Prism.languages.${this.language}`,
            link: `${CodeSnippet.prismCdn}/prism-${this.language}.min.js`,
          },
          () => {
            this.highlightCode();
          }
        );
      }
    } else {
      if (this.language) {
        this.highlightCode();
      }
    }
  };

  highlightCode = async () => {
    const prismInterval = setInterval(async () => {
      if (window.Prism && window.Prism.languages && window.Prism.languages[this.language]) {
        clearInterval(prismInterval);
        await customElements.whenDefined('code-snippet');

        window.Prism.hooks.add('before-insert', (env) => {
          switch (env.language) {
            case 'shell-session':
              const lines = env.code.split('\n');

              const code = lines.map((line) => {
                return line.trim() === '' || line.trim()[0] === '#'
                  ? `<span class="token output">${line}</span>\n`
                  : `<span class="dollar-sign token output">${line}</span>\n`;
              });
              env.highlightedCode = code.join('');
              break;
            default:
          }
        });

        window.Prism.highlightElement(this.codeEl, false);
      }
    }, 50);
  };

  render() {
    if (!this.code) {
      return null;
    }
    return (
      <Host>
        <pre class={`language-${this.language}`}>
          <code ref={(e) => (this.codeEl = e)}>{this.code.trim()}</code>
        </pre>
      </Host>
    );
  }
}
