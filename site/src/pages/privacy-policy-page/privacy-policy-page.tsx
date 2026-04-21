import { Component, Host, h, Prop } from '@stencil/core';
import { href } from '@stencil/router';
import { ResponsiveContainer, Heading, Paragraph } from 'ionic-ds-no-fonts';
import { defaults } from 'src/store';

@Component({
  tag: 'privacy-policy-page',
  styleUrl: 'privacy-policy-page.scss',
  scoped: true,
})
export class PrivacyPolicyPage {
  @Prop() defaults: typeof defaults;

  render() {
    const { PrivacyPolicy } = this;

    return (
      <Host>
        <meta-tags
          defaults={this.defaults}
          pageTitle="Privacy Policy"
          description={
            'Learn about what we do to protect our users privacy. Our privacy policy can answer your privacy-related issues.'
          }
          image={this.defaults.homepage + '/assets/img/og/privacy.png'}
        />
        <site-header defaults={this.defaults} class="heading-container" sticky={true} />
        <PrivacyPolicy />
        <pre-footer defaults={this.defaults} />
        <capacitor-site-footer defaults={this.defaults} />
      </Host>
    );
  }

  CompanyLink = (linkText?: string) => {
    if (this.defaults.homepage === this.defaults.companyUrl) {
      return (
        <a {...href('/')} target="_blank" class="underline-hover link" rel="noopener">
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

  PrivacyPolicy = () => (
    <ResponsiveContainer id="privacy-policy" class="legal-page" as="section">
      <Heading level={1} class="legal-heading">
        Privacy Policy
      </Heading>
      <Paragraph level={4}>
        This privacy policy has been compiled to better serve those who are concerned with how their 'Personally
        Identifiable Information' (PII) is being used online. PII, as described in US privacy law and information
        security, is information that can be used on its own or with other information to identify, contact, or locate a
        single person, or to identify an individual in context. Please read our privacy policy carefully to get a clear
        understanding of how we collect, use, protect or otherwise handle your Personally Identifiable Information in
        accordance with our website.
      </Paragraph>
      <Heading level={3}>What personal information do we collect from the people that visit our app?</Heading>
      <Paragraph level={4}>
        When registering on our site, as appropriate, you may be asked to enter your name, email address, or other
        details to help you with your experience. This data transfer is handled automatically when signing up using
        social network logins. Behind the scenes, we also log IP addresses and device identifiers for push
        notifications.
      </Paragraph>
      <Heading level={3}>When do we collect information?</Heading>
      <Paragraph level={4}>
        We collect information from you when you register on any of our affiliated web properties, sign up for
        notifications, or enter information on our site. In the case of some of our web properties, third-party
        analytics services are sometimes leveraged to help us create a better product.
      </Paragraph>
      <Heading level={3}>How do we use your information?</Heading>
      <Paragraph level={4}>
        We may use the information we collect from you when you register, make a purchase, sign up for our newsletter,
        respond to a survey or marketing communication, surf the website, or use certain other site features in the
        following ways:
      </Paragraph>
      <ul>
        <li>
          To personalize your experience and to allow us to deliver the type of content and product offerings in which
          you are most interested.
        </li>
        <li>To improve our website in order to better serve you.</li>
      </ul>
      <Heading level={3}>How do we protect your information?</Heading>
      <ul>
        <li>We do not use vulnerability scanning and/or scanning to PCI standards.</li>
        <li>An external PCI compliant payment gateway handles all CC transactions.</li>
        <li>We use regular malware scanning.</li>
        <li>We use HTTPS encryption for data transfer whenever possible.</li>
        <li>We host our static site and some proxy endpoints via CloudFlare, keeping API keys secure.</li>
      </ul>
      <Paragraph level={4}>
        Your personal information is contained behind secured networks and is only accessible by a limited number of
        persons who have special access rights to such systems, and are required to keep the information confidential.
        In addition, all sensitive/credit information you supply is encrypted via Secure Socket Layer (SSL) technology.
      </Paragraph>
      <Paragraph level={4}>
        We implement a variety of security measures when a user enters, submits, or accesses their information to
        maintain the safety of your personal information.
      </Paragraph>
      <Paragraph level={4}>
        All financial transactions are processed through a gateway provider and are not stored or processed on our
        servers.
      </Paragraph>
      <Heading level={3}>Do we use cookies?</Heading>
      <Paragraph level={4}>
        Yes. Cookies are small files that a site or its service provider transfers to your computer's hard drive through
        your Web browser (if you allow) that enables the site's or service provider's systems to recognize your browser
        and capture and remember certain information. For instance, we use cookies to help us remember and process the
        items in your shopping cart. They are also used to help us understand your preferences based on previous or
        current site activity, which enables us to provide you with improved services. We also use cookies to help us
        compile aggregate data about site traffic and site interaction so that we can offer better site experiences and
        tools in the future.
      </Paragraph>
      <Paragraph level={4}>We use cookies to:</Paragraph>
      <ul>
        <li>Understand and save user's preferences for future visits.</li>
        <li>Keep track of advertisements.</li>
        <li>
          Compile aggregate data about site traffic and site interactions in order to offer better site experiences and
          tools in the future. We may also use trusted third-party services that track this information on our behalf.
        </li>
      </ul>
      <Paragraph level={4}>
        You can choose to have your computer warn you each time a cookie is being sent, or you can choose to turn off
        all cookies. You do this through your browser settings. Since browser is a little different, look at your
        browser's Help Menu to learn the correct way to modify your cookies.
      </Paragraph>
      <Paragraph level={4}>
        If you turn cookies off, Some of the features that make your site experience more efficient may not function
        properly.It won't affect the user's experience that make your site experience more efficient and may not
        function properly.
      </Paragraph>
      <Heading level={3}>Third-Party Disclosure</Heading>
      <Paragraph level={4}>
        We do not sell, trade, or otherwise transfer to outside parties your Personally Identifiable Information unless
        we provide users with advance notice. This does not include website hosting partners and other parties who
        assist us in operating our website, conducting our business, or serving our users, so long as those parties
        agree to keep this information confidential. We may also release information when it's release is appropriate to
        comply with the law, enforce our site policies, or protect ours or others' rights, property or safety. However,
        non-personally identifiable visitor information may be provided to other parties for marketing, advertising, or
        other uses.
      </Paragraph>
      <Heading level={3}>Third-Party Links</Heading>
      <Paragraph level={4}>
        Occasionally, at our discretion, we may include or offer third-party products or services on our website. These
        third-party sites have separate and independent privacy policies. We therefore have no responsibility or
        liability for the content and activities of these linked sites. Nonetheless, we seek to protect the integrity of
        our site and welcome any feedback about these sites.
      </Paragraph>
      <Heading level={3}>Google</Heading>
      <Paragraph level={4}>
        Google's advertising requirements can be summed up by Google's Advertising Principles. They are put in place to
        provide a positive experience for users. See{' '}
        <a
          class="underline-hover"
          href="https://support.google.com/adwordspolicy/answer/1316548?hl=en"
          target="_blank"
          rel="noopener"
        >
          Google Ads Policies
        </a>
        .
      </Paragraph>
      <Paragraph level={4}>We use Google AdSense Advertising on our website.</Paragraph>
      <Paragraph level={4}>
        Google, as a third-party vendor, uses cookies to serve ads on our site. Google's use of the DART cookie enables
        it to serve ads to our users based on previous visits to our site and other sites on the Internet. Users may
        opt-out of the use of the DART cookie by visiting the Google Ad and Content Network privacy policy.
      </Paragraph>
      <Paragraph level={4}>We have implemented the following:</Paragraph>
      <ul>
        <li>Remarketing with Google AdSense</li>
        <li>Google Display Network Impression Reporting</li>
        <li>Demographics and Interests Reporting</li>
        <li>DoubleClick Platform Integration</li>
      </ul>
      <Paragraph level={4}>
        We, along with third-party vendors such as Google use first-party cookies (such as the Google Analytics cookies)
        and third-party cookies (such as the DoubleClick cookie) or other third-party identifiers together to compile
        data regarding user interactions with ad impressions and other ad service functions as they relate to our
        website.
      </Paragraph>
      <Paragraph level={4}>
        <b>Opting Out:</b>
      </Paragraph>
      <Paragraph level={4}>
        Users can set preferences for how Google advertises to you using the Google Ad Settings page. Alternatively, you
        can opt out by visiting the Network Advertising Initiative Opt Out page or by using the Google Analytics Opt Out
        Browser add on.
      </Paragraph>
      <Heading level={3}>California Online Privacy Protection Act</Heading>
      <Paragraph level={4}>
        CalOPPA is the first state law in the nation to require commercial websites and online services to post a
        privacy policy. The law's reach stretches well beyond California to require any person or company in the United
        States (and conceivably the world) that operates websites collecting Personally Identifiable Information from
        California consumers to post a conspicuous privacy policy on its website stating exactly the information being
        collected and those individuals or companies with whom it is being shared. See{' '}
        <a
          class="underline-hover"
          href="http://consumercal.org/california-online-privacy-protection-act-caloppa/#sthash.0FdRbT51.dpuf"
          target="_blank"
          rel="noopener"
        >
          ConsumerCal.org's article on CalOPPA
        </a>
        .
      </Paragraph>
      <Paragraph level={4}>
        <b>According to CalOPPA, we agree to the following:</b>
      </Paragraph>
      <ul>
        <li>Users can visit our site anonymously.</li>
        <li>
          Once this privacy policy is created, we will add a link to it on our home page or as a minimum, on the first
          significant page after entering our website.
        </li>
        <li>
          Our Privacy Policy link includes the word 'Privacy' and can easily be found in the footer navigation menu.
        </li>
        <li>You will be notified of any Privacy Policy changes on our Privacy Policy page.</li>
        <li>You can change your personal information by logging in to your account and managing your settings.</li>
      </ul>
      <Heading level={3}>How does our site handle Do Not Track signals?</Heading>
      <Paragraph level={4}>
        We don't honor Do Not Track signals and Do Not Track, plant cookies, or use advertising when a Do Not Track
        (DNT) browser mechanism is in place. We don't honor them because for security reasons we collect IP addresses to
        prevent malicious attacks. Malicious attackers are blocked from impacting our sites algorithm.
      </Paragraph>
      <Heading level={3}>Does our site allow third-party behavioral tracking?</Heading>
      <Paragraph level={4}>It's also important to note that we allow third-party behavioral tracking.</Paragraph>
      <Heading level={3}>COPPA (Children Online Privacy Protection Act)</Heading>
      <Paragraph level={4}>
        When it comes to the collection of personal information from children under the age of 13 years old, the
        Children's Online Privacy Protection Act (COPPA) puts parents in control. The Federal Trade Commission, United
        States' consumer protection agency, enforces the COPPA Rule, which spells out what operators of websites and
        online services must do to protect children's privacy and safety online.
      </Paragraph>
      <ul>
        <li>We do not specifically market to children under the age of 13 years old.</li>
        <li>
          We do not collect age data so third-parties are responsible for limiting the collection of PII from children
          under 13.
        </li>
      </ul>
      <Heading level={3}>Fair Information Practices</Heading>
      <Paragraph level={4}>
        The Fair Information Practices Principles form the backbone of privacy law in the United States and the concepts
        they include have played a significant role in the development of data protection laws around the globe.
        Understanding the Fair Information Practice Principles and how they should be implemented is critical to comply
        with the various privacy laws that protect personal information.
      </Paragraph>
      <Paragraph level={4}>
        In order to be in line with Fair Information Practices we will take the following responsive action, should a
        data breach occur:
      </Paragraph>
      <ul>
        <li>We will notify you via email within 7 business days.</li>
        <li>We will notify the users via in-site notification within 7 business days.</li>
      </ul>
      <Paragraph level={4}>
        We also agree to the Individual Redress Principle which requires that individuals have the right to legally
        pursue enforceable rights against data collectors and processors who fail to adhere to the law. This principle
        requires not only that individuals have enforceable rights against data users, but also that individuals have
        recourse to courts or government agencies to investigate and/or prosecute non-compliance by data processors.
      </Paragraph>
      <Heading level={3}>CAN SPAM Act</Heading>
      <Paragraph level={4}>
        The CAN-SPAM Act is a law that sets the rules for commercial email, establishes requirements for commercial
        messages, gives recipients the right to have emails stopped from being sent to them, and spells out tough
        penalties for violations.
      </Paragraph>
      <Paragraph level={4}>We collect your email address in order to:</Paragraph>
      <ul>
        <li>Send information, respond to inquiries, and/or other requests or questions</li>
        <li>
          Market to our mailing list or continue to send emails to our clients after the original transaction has
          occurred.
        </li>
      </ul>
      <Paragraph level={4}>To be in accordance with CANSPAM, we agree to the following:</Paragraph>
      <ul>
        <li>Not use false or misleading subjects or email addresses.</li>
        <li>Identify the message as an advertisement in some reasonable way.</li>
        <li>Include the physical address of our business or site headquarters.</li>
        <li>Monitor third-party email marketing services for compliance, if one is used.</li>
        <li>Honor opt-out/unsubscribe requests quickly.</li>
        <li>Allow users to unsubscribe by using the link at the bottom of each email.</li>
      </ul>
      <Paragraph level={4}>
        If at any time you would like to unsubscribe from receiving future emails, you can email us at{' '}
        <a class="underline-hover" href={'mailto:' + this.defaults.companyEmail}>
          {this.defaults.companyEmail}
        </a>{' '}
        or you can follow the instructions at the bottom of each email and we will promptly remove you from all
        correspondence.
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
            <a class="underline-hover link" href={'mailto:' + this.defaults.companyEmail}>
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
            {this.defaults.companyAddress.line1}
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
