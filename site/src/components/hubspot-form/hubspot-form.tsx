import { Component, Host, h, Prop, State } from '@stencil/core';
import { Paragraph } from 'ionic-ds-no-fonts';
import { defaults } from 'src/store';
import { href } from '@stencil/router';

declare var window: any;

@Component({
  tag: 'capacitor-hubspot-form',
  styleUrl: 'hubspot-form.scss',
})
export class HubspotForm {
  @Prop() defaults: typeof defaults;

  @State() email: string = '';
  @State() firstName: string = '';
  @State() lastName: string = '';
  @State() phoneNumber: string = '';
  @State() country: string = '';
  @State() jobTitle: string = '';
  @State() message: string = '';
  @State() newsletterCheckbox = true;
  @State() company: string = '';
  @State() isLoading: boolean = false;
  @State() hasSubmitted: boolean = false;
  @State() isValid: boolean = true;
  @State() inlineMessage: string = '';

  componentDidLoad() {}

  handleNewsletterSubmit(e: Event) {
    e.preventDefault();
    if (this.hasSubmitted && !this.isLoading) {
      this.message = '';
      this.newsletterCheckbox = true;
      this.isLoading = false;
      this.hasSubmitted = false;
      this.isValid = true;
      this.inlineMessage = '';
      this.jobTitle = '';
      this.country = '';
      this.phoneNumber = '';
      this.lastName = '';
      this.firstName = '';
      this.email = '';
      return;
    }

    this.isLoading = true;

    const xhr = new XMLHttpRequest();
    const url = this.defaults.emailForm.url;

    xhr.open('POST', url);
    xhr.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');
    xhr.onreadystatechange = () => {
      console.log(xhr);
      if (xhr.readyState === 4) {
        this.isLoading = false;
      }
      if (xhr.readyState === 4 && xhr.status === 200) {
        this.inlineMessage = 'Successfully added ' + this.email;
        this.hasSubmitted = true;
        this.isValid = true;
      } else if (xhr.readyState == 4 && xhr.status === 400) {
        console.error(`Failed to add ${this.email}`, xhr);
        const json = JSON.parse(xhr.responseText);
        this.inlineMessage = json.error;
        this.isValid = false;
        this.hasSubmitted = false;
      } else if (xhr.readyState == 4) {
        const json = JSON.parse(xhr.responseText);
        this.inlineMessage = json.error;
        this.isValid = false;
        this.hasSubmitted = false;
      }
    };
    // Custom fields are optional
    const customFields: any = {};
    if (this.company) {
      customFields.company = this.company;
    }
    if (this.jobTitle) {
      customFields.job_title = this.jobTitle;
    }
    let slug = (url) => new URL(url).pathname.match(/[^\/]+/g);
    const slugs = slug(window.location.href);
    customFields.join_href = window.location.href;
    if (slugs) {
      customFields.join_slug = slugs.pop();
    }
    customFields.join_type = 'enterprise';
    const listIds = [this.defaults.sendGridEnterpriseListId];
    if (this.newsletterCheckbox) {
      listIds.push(this.defaults.sendGridListId);
    }
    xhr.send(
      JSON.stringify({
        list_ids: listIds,
        site: 'install.doctor',
        message: this.message,
        contacts: [
          {
            email: this.email,
            first_name: this.firstName,
            last_name: this.lastName,
            phone_number: this.phoneNumber,
            custom_fields: customFields,
          },
        ],
      })
    );
  }

  handleEmailChange(ev: any) {
    this.email = ev.target.value;
    this.isValid = true;
    this.hasSubmitted = false;
  }

  handleFirstNameChange(ev: any) {
    this.firstName = ev.target.value;
    this.hasSubmitted = false;
  }

  handleLastNameChange(ev: any) {
    this.lastName = ev.target.value;
    this.hasSubmitted = false;
  }

  handlePhoneNumberChange(ev: any) {
    this.phoneNumber = ev.target.value;
    this.hasSubmitted = false;
  }

  handleJobTitleChange(ev: any) {
    this.jobTitle = ev.target.value;
    this.hasSubmitted = false;
  }

  handleCompanyChange(ev: any) {
    this.company = ev.target.value;
    this.hasSubmitted = false;
  }

  handleMessageChange(ev: any) {
    this.message = ev.target.value;
    this.hasSubmitted = false;
  }

  handleNewsletterCheckbox(ev: any) {
    this.newsletterCheckbox = ev.target.checked;
    this.hasSubmitted = false;
  }

  render() {
    return (
      <Host>
        <div class="form-group">
          <form class="hs-form" onSubmit={(e) => this.handleNewsletterSubmit(e)}>
            <fieldset class="form-columns-2">
              <div class="hs-firstname hs-fieldtype-text field hs-form-field">
                <div class="input">
                  <label htmlFor="hubspot-form-first-name">
                    <span>First name</span>
                    <span class="hs-form-required">*</span>
                  </label>
                  <input
                    name="first_name"
                    type="text"
                    id="hubspot-form-first-name"
                    autocomplete="given-name"
                    spellcheck="false"
                    maxlength="50"
                    pattern="[A-Za-z ]{1,50}"
                    autocapitalize="off"
                    autocorrect="off"
                    inputmode="text"
                    value={this.firstName}
                    onInput={(ev) => this.handleFirstNameChange(ev)}
                    disabled={this.isLoading || this.hasSubmitted}
                    placeholder="First name"
                    class={{ 'ui-paragraph-4': true, 'hs-input': true }}
                    aria-label="First name"
                    required
                  />
                </div>
              </div>
              <div class="hs-lastname hs-fieldtype-text field hs-form-field">
                <div class="input">
                  <label htmlFor="hubspot-form-last-name">
                    <span>Last name</span>
                    <span class="hs-form-required">*</span>
                  </label>
                  <input
                    name="last_name"
                    type="text"
                    id="hubspot-form-last-name"
                    autocomplete="family-name"
                    spellcheck="false"
                    pattern="[A-Za-z ]{1,50}"
                    maxlength="50"
                    autocapitalize="off"
                    autocorrect="off"
                    inputmode="text"
                    value={this.lastName}
                    onInput={(ev) => this.handleLastNameChange(ev)}
                    disabled={this.isLoading || this.hasSubmitted}
                    placeholder="Last name"
                    class={{ 'ui-paragraph-4': true, 'hs-input': true }}
                    aria-label="Last name"
                    required
                  />
                </div>
              </div>
            </fieldset>
            <fieldset class="form-columns-2">
              <div class="hs-email-address hs-fieldtype-email field hs-form-field">
                <div class="input">
                  <label htmlFor="hubspot-form-email">
                    <span>E-mail address</span>
                    <span class="hs-form-required">*</span>
                  </label>
                  <input
                    name="email"
                    type="email"
                    id="hubspot-form-email"
                    autocomplete="email"
                    maxlength="254"
                    inputmode="email"
                    spellcheck="false"
                    autocapitalize="off"
                    autocorrect="off"
                    value={this.email}
                    onInput={(ev) => this.handleEmailChange(ev)}
                    disabled={this.isLoading || this.hasSubmitted}
                    placeholder="E-mail address (work)"
                    class={{ error: !this.isValid, 'ui-paragraph-4': true, 'hs-input': true }}
                    aria-label="E-mail"
                    required
                  />
                </div>
              </div>
              <div class="hs-phone-number hs-fieldtype-tel field hs-form-field">
                <div class="input">
                  <label htmlFor="hubspot-form-phone-number">
                    <span>Phone number</span>
                    <span class="hs-form-required">*</span>
                  </label>
                  <input
                    name="phone_number"
                    type="tel"
                    id="hubspot-form-phone-number"
                    autocomplete="tel"
                    inputmode="tel"
                    spellcheck="false"
                    autocapitalize="off"
                    autocorrect="off"
                    value={this.phoneNumber}
                    onInput={(ev) => this.handlePhoneNumberChange(ev)}
                    disabled={this.isLoading || this.hasSubmitted}
                    placeholder="Phone number (e.g. +1 202-888-5432)"
                    class={{ 'ui-paragraph-4': true, 'hs-input': true }}
                    aria-label="Phone number"
                    required
                  />
                </div>
              </div>
            </fieldset>
            <fieldset class="form-columns-2">
              <div class="hs-job-title hs-fieldtype-text field hs-form-field">
                <div class="input">
                  <label htmlFor="hubspot-form-job-title">
                    <span>Job title</span>
                    <span class="hs-form-required">*</span>
                  </label>
                  <input
                    name="job_title"
                    type="text"
                    id="hubspot-form-job-title"
                    autocomplete="organization-title"
                    inputmode="text"
                    maxlength="50"
                    pattern="([^\s][A-z0-9À-ž\s]+)"
                    value={this.jobTitle}
                    onInput={(ev) => this.handleJobTitleChange(ev)}
                    disabled={this.isLoading || this.hasSubmitted}
                    placeholder="Job title (e.g. Lead Software Developer)"
                    class={{ 'ui-paragraph-4': true, 'hs-input': true }}
                    aria-label="Job title"
                    required
                  />
                </div>
              </div>
              <div class="hs-company hs-fieldtype-text field hs-form-field">
                <div class="input">
                  <label htmlFor="hubspot-form-company">
                    <span>Company</span>
                    <span class="hs-form-required">*</span>
                  </label>
                  <input
                    name="company"
                    type="text"
                    id="hubspot-form-company"
                    autocomplete="organization"
                    inputmode="text"
                    maxlength="50"
                    pattern="([^\s][A-z0-9À-ž\s]+)"
                    value={this.company}
                    onInput={(ev) => this.handleCompanyChange(ev)}
                    disabled={this.isLoading || this.hasSubmitted}
                    placeholder="Company name"
                    class={{ 'ui-paragraph-4': true, 'hs-input': true }}
                    aria-label="Company"
                    required
                  />
                </div>
              </div>
            </fieldset>
            <fieldset class="no-padding">
              <div class="hs-message hs-fieldtype-textarea hs-form-field">
                <div class="input">
                  <label htmlFor="hubspot-form-message">
                    <span>Message</span>
                    <span class="hs-form-required">*</span>
                  </label>
                  <textarea
                    name="message"
                    id="hubspot-form-message"
                    class="hs-input"
                    maxlength="1000"
                    value={this.message}
                    onInput={(ev) => this.handleMessageChange(ev)}
                    disabled={this.isLoading || this.hasSubmitted}
                    placeholder="Enter message.. (optional)"
                    aria-label="Message"
                  />
                </div>
              </div>
            </fieldset>
            <Paragraph level={5} class="error-message privacy-message">
              We value your privacy and will never share or sell your data. For more details, read our{' '}
              <span>
                <a class="underline-hover link" {...href('/privacy')}>
                  Privacy Policy
                </a>
                .
              </span>
            </Paragraph>
            <fieldset>
              <div class="hs-privacy-policy hs-form-booleancheckbox-display">
                <label htmlFor="hubspot-form-privacy-checkbox">
                  Subscribe to newsletter for updates on trending open-source projects and cloud services
                </label>
                <input
                  name="newsletter"
                  type="checkbox"
                  onInput={(ev) => this.handleNewsletterCheckbox(ev)}
                  class="hs-form-checkbox-display"
                  disabled={this.isLoading || this.hasSubmitted}
                  id="hubspot-form-privacy-checkbox"
                  checked={this.newsletterCheckbox}
                />
              </div>
            </fieldset>
            <div class="hs-submit-container">
              <div class="hs_submit hs-submit">
                <div class="actions">
                  <input
                    type="submit"
                    class="hs-button primary large enterprise-submit-btn"
                    disabled={this.isLoading || !this.isValid}
                    value={this.hasSubmitted && !this.isLoading ? 'Reset Form' : 'Submit Inquiry'}
                  />
                </div>
              </div>
              {}
              {!this.isValid ? (
                <div class="form-message">
                  <ion-icon name="alert-circle-outline" class="footer-check-style danger-color"></ion-icon>
                  <Paragraph class="footer-para-style footer-invalid-style">{this.inlineMessage}</Paragraph>
                </div>
              ) : (
                this.hasSubmitted &&
                !this.isLoading && (
                  <div class="form-message">
                    <ion-icon name="checkmark-circle" class="footer-check-style success-color"></ion-icon>
                    <Paragraph class="footer-para-style">{this.inlineMessage}</Paragraph>
                  </div>
                )
              )}
            </div>
          </form>
        </div>
      </Host>
    );
  }
}
