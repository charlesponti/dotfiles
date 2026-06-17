---
name: kernel-docs
kind: skill
tags:
  - docs
profile: extended
description: "Manages Vitepress documentation workflows: deploys docs via
  Vercel, creates versioned releases, records feature demos, and validates doc
  sites. Use when publishing or updating documentation, cutting a release with
  docs, or when users ask how to deploy or validate a doc site."
license: MIT
compatibility: Vitepress documentation sites deployed via Vercel or GitHub Pages
metadata:
  author: project
  version: "2.0"
  category: Documentation
  tags:
    - docs
    - documentation
    - vitepress
    - vercel
    - deploy
    - release
    - video
when:
  - user needs to publish or deploy documentation
  - a new version release requires documentation updates
  - a feature demo or walkthrough video needs to be created
  - the documentation site needs to be validated or tested
applicability:
  - Use for documentation publishing, versioning, and release workflows
  - Use when documentation must stay synchronized with a software release
termination:
  - Documentation deployed and accessible at the target URL
  - Versioned documentation release created and published
  - Feature demo script or recording completed
outputs:
  - Deployed documentation site
  - Versioned documentation release
  - Feature demo video or script
disableModelInvocation: true
---

Publish documentation, cut versioned releases, and record feature demos.

## Toolchain

| Concern         | Choice        | Notes                                                        |
| --------------- | ------------- | ------------------------------------------------------------ |
| Doc platform    | **Vitepress** | Built-in search, fast builds, Vue-based. Never Docusaurus.   |
| Hosting         | **Vercel**    | Preferred. GitHub Pages acceptable for open-source projects. |
| Link validation | `linkcheck`   | Run against built output before every publish.               |
| Release notes   | `git log`     | Generate from conventional commits between tags.             |

## Building Documentation

```bash
pnpm docs:build        # outputs to docs/.vitepress/dist/
pnpm docs:preview      # serve locally at http://localhost:4173
```

## Validate Before Publishing

Run these checks before every deploy. Any failure is a deploy blocker.

```bash
# Broken links
pnpm docs:check-links  # or: npx linkcheck ./docs/.vitepress/dist

# Heading hierarchy — h1 → h2 → h3, no skips
# Search index is built automatically by Vitepress

# Confirm all images have alt text
# Test navigation on desktop and mobile
```

## Deploy

```bash
# Vercel (preferred)
vercel deploy --prod

# GitHub Pages (via CI only — never deploy manually)
# Trigger via: git push origin main → CI workflow deploys automatically
```

### Verify after deploy

- Confirm the URL is live and content is correct
- Test navigation and search on desktop and mobile
- Confirm all images have alt text

## Versioned Documentation Releases

When a software version ships:

1. Audit docs against the new version — flag outdated content and missing coverage.
2. Write breaking-change notices and migration guides before cutting the version.
3. Copy current docs snapshot:
   ```bash
   cp -r docs/ docs-versions/v1.2.3/
   ```
4. Update the "latest" pointer in the Vitepress config.
5. Generate release notes from git log:
   ```bash
   git log v1.1.0..v1.2.3 --oneline --no-merges
   ```
6. Deploy and confirm the version switcher works.

## Feature Demo Videos

When recording a feature demonstration:

1. **Script** — write a concise script: goal, exact steps, expected outcome. Keep it under 5 minutes.
2. **Prepare** — reset the environment to a clean state; use realistic but non-sensitive data; close unrelated windows.
3. **Record** — 1080p minimum; use a screen recorder with system audio muted.
4. **Edit** — cut dead air and pauses; add captions for accessibility; highlight UI actions with zoom or callouts.
5. **Publish** — upload to the designated platform (Loom for internal, YouTube for public).
6. **Link** — add the video to the relevant docs page or changelog entry immediately after publishing.

## Guardrails

- Never deploy docs from a local machine to production — use CI or the platform CLI with proper credentials.
- Never publish docs for an unreleased version — version snapshots are cut at release time only.
- Every breaking change must have a migration guide before the version is published.
- Broken links are a deploy blocker — run link validation before every publish.
- Never use Docusaurus, MkDocs, or GitBook — Vitepress is the standard.
