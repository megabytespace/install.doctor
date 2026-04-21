# install.doctor-site

## Purpose

Marketing/docs website for install.doctor (product site separate from provisioning project).

## Scope

This skill contains **site-specific/domain-specific logic only**.

It is automatically composed with the shared base layer:
- `.agentskills/base-layer/SKILL.md` (folder)
- base skill slug: `cloudflare-angular-saas`

Do **not** duplicate generic process rules here (TDD loop, Playwright discipline, Semgrep, deploy verification, docs gates). Those belong to the base layer.

## Auto-Inclusion (Repository Detection)

Claude Code / Emdash should auto-select this overlay when repository evidence points to **install.doctor-site**:
- git remote / repo name / workspace name
- package or app names
- Cloudflare routes / deployment URLs / domains
- README / docs / branding references

If multiple overlays appear possible, choose the closest one, state the assumption, and continue.

## Site-Specific Focus Areas

- Product messaging, onboarding docs, and install guidance UX
- Conversion paths, CTA flows, and trust/safety explanation content
- Docs publishing, examples, and visual walkthroughs
- SEO/performance and deployment documentation
