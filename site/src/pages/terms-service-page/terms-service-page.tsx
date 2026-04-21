import { Component, Host, h, Prop } from '@stencil/core';
import { href } from '@stencil/router';
import { ResponsiveContainer, Heading, Paragraph } from 'ionic-ds-no-fonts';
import { defaults } from 'src/store';

@Component({
  tag: 'terms-service-page',
  styleUrl: 'terms-service-page.scss',
  scoped: true,
})
export class TermsServicePage {
  @Prop() defaults: typeof defaults;

  render() {
    const { TermsService } = this;

    return (
      <Host>
        <meta-tags
          defaults={this.defaults}
          pageTitle="Terms of Service"
          image={this.defaults.homepage + '/assets/img/og/terms.png'}
          description={
            this.defaults.brandName +
            ' is owned by ' +
            this.defaults.companyLegalName +
            ' and, as a requirement of many web services it integrates with, provides this Terms of Service agreement to its users to keep them well informed.'
          }
        />
        <site-header defaults={this.defaults} class="heading-container" sticky={true} />
        <TermsService />
        <pre-footer defaults={this.defaults} />
        <capacitor-site-footer defaults={this.defaults} />
      </Host>
    );
  }

  CompanyLink = (linkText?: string) => {
    if (this.defaults.homepage === this.defaults.companyUrl) {
      return (
        <a {...href('/')} class="underline-hover link" target="_blank" rel="noopener">
          {linkText ? linkText : this.defaults.companyLegalName}
        </a>
      );
    } else {
      return (
        <a href={this.defaults.companyUrl} class="underline-hover link" target="_blank" rel="noopener">
          {linkText ? linkText : this.defaults.companyLegalName}
        </a>
      );
    }
  };

  TermsService = () => (
    <ResponsiveContainer id="terms-service" class="legal-page" as="section">
      <Heading level={1} class="legal-heading">
        Terms of Service
      </Heading>
      <Paragraph level={4}>
        This website is owned and operated by {this.CompanyLink()} (also referred to as {this.defaults.companyAlias}).
        By visiting our website and accessing the information, resources, services, products, and tools we provide, you
        understand and agree to accept and adhere to the following terms and conditions as stated in this policy
        (hereafter referred to as 'User Agreement'), along with the terms and conditions as stated in our Privacy Policy
        (please refer to the Privacy Policy section below for more information).
      </Paragraph>
      <Paragraph level={4}>
        We reserve the right to change this User Agreement from time to time without notice. You acknowledge and agree
        that it is your responsibility to review this User Agreement periodically to familiarize yourself with any
        modifications. Your continued use of this site after such modifications will constitute acknowledgment and
        agreement of the modified terms and conditions.
      </Paragraph>
      <Heading level={3}>Responsible Use and Conduct</Heading>
      <Paragraph level={4}>
        By visiting our website and accessing the information, resources, services, products, and tools we provide for
        you, either directly or indirectly (hereafter referred to as 'Resources'), you agree to use these Resources only
        for the purposes intended as permitted by (a) the terms of this User Agreement, and (b) applicable laws,
        regulations and generally accepted online practices or guidelines.
      </Paragraph>
      <Paragraph level={4}>Wherein, you understand that:</Paragraph>
      <ul>
        <li>
          In order to access our Resources, you may be required to provide certain information about yourself (such as
          identification, contact details, etc.) as part of the registration process, or as part of your ability to use
          the Resources. You agree that any information you provide will always be accurate, correct, and up to date.
        </li>
        <li>
          You are responsible for maintaining the confidentiality of any login information associated with any account
          you use to access our Resources. Accordingly, you are responsible for all activities that occur under your
          account(s).
        </li>
        <li>
          Accessing (or attempting to access) any of our Resources by any means other than through the means we provide,
          is strictly prohibited. You specifically agree not to access (or attempt to access) any of our Resources
          through any automated, unethical or unconventional means.
        </li>
        <li>
          Engaging in any activity that disrupts or interferes with our Resources, including the servers and/or networks
          to which our Resources are located or connected, is strictly prohibited.
        </li>
        <li>Attempting to copy, duplicate, reproduce, sell, trade, or resell our Resources is strictly prohibited.</li>
        <li>
          You are solely responsible any consequences, losses, or damages that we may directly or indirectly incur or
          suffer due to any unauthorized activities conducted by you, as explained above, and may incur criminal or
          civil liability.
        </li>
        <li>
          We may provide various open communication tools on our website, such as blog comments, blog posts, public
          chat, forums, message boards, newsgroups, product ratings and reviews, various social media services, etc. You
          understand that generally we do not pre-screen or monitor the content posted by users of these various
          communication tools, which means that if you choose to use these tools to submit any type of content to our
          website, then it is your personal responsibility to use these tools in a responsible and ethical manner. By
          posting information or otherwise using any open communication tools as mentioned, you agree that you will not
          upload, post, share, or otherwise distribute any content that:
          <ul>
            <li>
              Is illegal, threatening, defamatory, abusive, harassing, degrading, intimidating, fraudulent, deceptive,
              invasive, racist, or contains any type of suggestive, inappropriate, or explicit language;
            </li>
            <li>
              Infringes on any trademark, patent, trade secret, copyright, or other proprietary right of any party;
            </li>
            <li>Contains any type of unauthorized or unsolicited advertising;</li>
            <li>Impersonates any person or entity, including any {this.CompanyLink()} employees or representatives.</li>
          </ul>
        </li>
      </ul>
      <Paragraph level={4}>
        We have the right at our sole discretion to remove any content that, we feel in our judgment does not comply
        with this User Agreement, along with any content that we feel is otherwise offensive, harmful, objectionable,
        inaccurate, or violates any 3rd party copyrights or trademarks. We are not responsible for any delay or failure
        in removing such content. If you post content that we choose to remove, you hereby consent to such removal, and
        consent to waive any claim against us.
      </Paragraph>
      <ul>
        <li>
          We do not assume any liability for any content posted by you or any other 3rd party users of our website.
          However, any content posted by you using any open communication tools on our website, provided that it doesn't
          violate or infringe on any 3rd party copyrights or trademarks, becomes the property of{' '}
          {this.defaults.companyLegalName}, and as such, gives us a perpetual, irrevocable, worldwide, royalty-free,
          exclusive license to reproduce, modify, adapt, translate, publish, publicly display and/or distribute as we
          see fit. This only refers and applies to content posted via open communication tools as described, and does
          not refer to information that is provided as part of the registration process, necessary in order to use our
          Resources. All information provided as part of our registration process is covered by our{' '}
          <a class="underline-hover" {...href('/privacy')}>
            privacy policy
          </a>
          .
        </li>
        <li>
          You agree to indemnify and hold harmless {this.defaults.companyLegalName} and its parent company and
          affiliates, and their directors, officers, managers, employees, donors, agents, and licensors, from and
          against all losses, expenses, damages and costs, including reasonable attorneys' fees, resulting from any
          violation of this User Agreement or the failure to fulfill any obligations relating to your account incurred
          by you or any other person using your account. We reserve the right to take over the exclusive defense of any
          claim for which we are entitled to indemnification under this User Agreement. In such event, you shall provide
          us with such cooperation as is reasonably requested by us.
        </li>
      </ul>
      <Heading level={3}>Privacy</Heading>
      <Paragraph level={4}>
        Your privacy is very important to us, which is why we've created a separate Privacy Policy in order to explain
        in detail how we collect, manage, process, secure, and store your private information. Our privacy policy is
        included under the scope of this User Agreement. To read our privacy policy in its entirety,{' '}
        <span>
          <a class="underline-hover" {...href('/privacy')}>
            click here
          </a>
          .
        </span>
      </Paragraph>
      <Heading level={3}>Limitation of Warranties</Heading>
      <Paragraph level={4}>
        By using our website, you understand and agree that all Resources we provide are "as is" and "as available".
        This means that we do not represent or warrant to you that:
      </Paragraph>
      <ul>
        <li>The use of our Resources will meet your needs or requirements.</li>
        <li>The use of our Resources will be uninterrupted, timely, secure or free from errors.</li>
        <li>The information obtained by using our Resources will be accurate or reliable, and</li>
        <li>
          Any defects in the operation or functionality of any Resources we provide will be repaired or corrected.
        </li>
      </ul>
      <Paragraph level={4}>Furthermore, you understand and agree that:</Paragraph>
      <ul>
        <li>
          Any content downloaded or otherwise obtained through the use of our Resources is done at your own discretion
          and risk, and that you are solely responsible for any damage to your computer or other devices for any loss of
          data that may result from the download of such content.
        </li>
        <li>
          No information or advice, whether expressed, implied, oral or written, obtained by you from{' '}
          {this.defaults.companyLegalName}
          or through any Resources we provide shall create any warranty, guarantee, or conditions of any kind, except
          for those expressly outlined in this User Agreement.
        </li>
      </ul>
      <Heading level={3}>Limitation of Liability</Heading>
      <Paragraph level={4}>
        In conjunction with the Limitation of Warranties as explained above, you expressly understand and agree that any
        claim against us shall be limited to the amount you paid, if any, for use of products and/or services.{' '}
        {this.defaults.companyLegalName} will not be liable for any direct, indirect, incidental, consequential or
        exemplary loss or damages which may be incurred by you as a result of using our Resources, or as a result of any
        changes, data loss or corruption, cancellation, loss of access, or downtime to the full extent that applicable
        limitation of liability laws apply.
      </Paragraph>
      <Heading level={3}>Copyrights/Trademarks</Heading>
      <Paragraph level={4}>
        All content and materials available on{' '}
        <span>
          <a {...href('/')} class="underline-hover">
            {this.defaults.homepage}
          </a>
          ,
        </span>{' '}
        including but not limited to text, graphics, website name, code, images and logos are the intellectual property
        of {this.defaults.companyLegalName}, and are protected by applicable copyright and trademark law. Any
        inappropriate use, including but not limited to the reproduction, distribution, display or transmission of any
        content on this site is strictly prohibited, unless specifically authorized by {this.defaults.companyLegalName}.
      </Paragraph>
      <Heading level={3}>Termination of Use</Heading>
      <Paragraph level={4}>
        You agree that we may, at our sole discretion, suspend or terminate your access to all or part of our website
        and Resources with or without notice and for any reason, including, without limitation, breach of this User
        Agreement. Any suspected illegal, fraudulent or abusive activity may be grounds for terminating your
        relationship and may be referred to appropriate law enforcement authorities. Upon suspension or termination,
        your right to use the Resources we provide will immediately cease, and we reserve the right to remove or delete
        any information that you may have on file with us, including any account or login information.
      </Paragraph>
      <Heading level={3}>Governing Law</Heading>
      <Paragraph level={4}>
        This website is controlled by {this.defaults.companyLegalName} from our offices located in the state of New
        Jersey, USA. It can be accessed by most countries around the world. As each country has laws that may differ
        from those of New Jersey, by accessing our website, you agree that the statutes and laws of New Jersey, without
        regard to the conflict of laws and the United Nations Convention on the International Sales of Goods, will apply
        to all matters relating to the use of this website and the purchase of any products or services through this
        site.
      </Paragraph>
      <Paragraph level={4}>
        Furthermore, any action to enforce this User Agreement shall be brought in the federal or state courts located
        in USA, New Jersey You hereby agree to personal jurisdiction by such courts, and waive any jurisdictional,
        venue, or inconvenient forum objections to such courts.
      </Paragraph>
      <Heading level={3}>Guarantee</Heading>
      <Paragraph level={4}>
        UNLESS OTHERWISE EXPRESSED, {this.defaults.companyLegalName.toUpperCase()} EXPRESSLY DISCLAIMS ALL WARRANTIES
        AND CONDITIONS OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO THE IMPLIED WARRANTIES AND
        CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT.
      </Paragraph>
      <Heading level={3}>Contact Information</Heading>
      <Paragraph level={4}>
        If you have any questions or comments about these our Terms of Service as outlined above, you can contact us at:
      </Paragraph>
      <div class="contact-info">
        <div class="contact-detail">
          <div class="contact-icon">
            <ion-icon name="link"></ion-icon>
          </div>
          <div class="contact-text">{this.CompanyLink(this.defaults.companyUrl)}</div>
        </div>
        <div class="contact-detail">
          <div class="contact-icon">
            <ion-icon name="mail"></ion-icon>
          </div>
          <div class="contact-text">
            <a href={'mailto:' + this.defaults.companyEmail} class="underline-hover link">
              {this.defaults.companyEmail}
            </a>
          </div>
        </div>
        <div class="contact-detail">
          <div class="contact-icon contact-navigate">
            <ion-icon name="navigate"></ion-icon>
          </div>
          <div class="contact-text">
            {this.defaults.companyLegalName}
            <br />
            {this.defaults.companyAddress.line1},
            <br />
            {this.defaults.companyAddress.line2}
            <br />
            {this.defaults.companyAddress.line3}
          </div>
        </div>
      </div>
    </ResponsiveContainer>
  );
}
