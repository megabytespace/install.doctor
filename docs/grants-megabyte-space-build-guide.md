# grants.megabyte.space — Converged Build Guide Reference

## Repository
https://github.com/HeyMegabyte/grants.megabyte.space

## Architecture Summary

Cloudflare-native grant writing SaaS with:
- **API**: Cloudflare Workers + Hono (passwordless auth, Stripe billing, Grant CRM)
- **Web**: Cloudflare Pages + React + AG Grid (dark theme, Command-K search)
- **DB**: Cloudflare D1 (26 tables, FTS5 search)
- **Cache**: Cloudflare KV
- **Storage**: Cloudflare R2 (documents, RFP snapshots, screenshots)
- **Orchestration**: Cloudflare Workflows + Queues (10-stage grant run pipeline)
- **Browser**: Cloudflare Browser Rendering (portal automation)

## Cloudflare Resources (Production)

| Resource | Name | ID |
|----------|------|----|
| D1 Database | grants-db | 8e5294b0-5dcf-475a-8cf4-afd9db714038 |
| KV Namespace | GRANTS_KV | 0e7ee51479fa4081b65e8fcba2f91cfb |
| R2 Bucket | grants-bucket | (default) |

## Key Design Decisions

1. **Compliance-first**: Parse RFP into Compliance Contract before any drafting
2. **Citation strictness**: Every factual claim must cite an approved source
3. **Human approval gates**: No irreversible actions without explicit confirmation
4. **Two inputs only**: nonprofitPlaceId + grantTarget (email/URL/phrase)
5. **$50/mo subscription**: Locks exactly one Google Place ID per org

## Monorepo Structure

```
apps/grants-api/     - Cloudflare Worker (Hono) + Workflows
apps/grants-web/     - Cloudflare Pages (React + AG Grid)
packages/shared/     - Zod schemas, constants, utilities, RBAC
prompts/             - .prompt.md prompt-as-code files
scripts/             - Seed data, CI runner
```

## Pipeline Stages

1. Classify grantTarget
2. Capture RFP (snapshot)
3. Parse Compliance Contract
4. NEEDS_HUMAN_INPUT gate
5. Generate rubric-mapped outline
6. Generate draft with citations
7. Compliance check (pass/fail)
8. Ready for approval
9. Send/submit
10. Archive artifacts
