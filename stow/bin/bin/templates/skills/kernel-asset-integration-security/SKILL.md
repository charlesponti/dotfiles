---
name: kernel-asset-integration-security
kind: skill
tags:
  - frontend
  - security
profile: extended
description: Enforces security requirements for third-party assets and external
  integrations. Use when adding scripts, fonts, analytics, embeds, CDN
  resources, or any external dependency to a frontend.
license: MIT
compatibility: Any web frontend project.
metadata:
  author: project
  version: "1.0"
  category: Security
  tags:
    - security
    - csp
    - cors
    - cdn
    - third-party
    - integrity
    - sri
    - assets
    - integrations
when:
  - user is adding a third-party script, font, or stylesheet from a CDN
  - user is integrating an analytics, tracking, or marketing tool
  - user is embedding an iframe or external widget
  - user is configuring a Content Security Policy
  - user is adding an API key or integration credential to the frontend
  - user is loading any external resource not self-hosted
applicability:
  - Use before adding any external dependency to a frontend bundle or HTML page
  - Use when reviewing CSP headers or CORS configuration
  - Use when evaluating whether a third-party tool is safe to integrate
termination:
  - External resource includes SRI hash or is self-hosted
  - CSP header configured and tested
  - No secret API keys embedded in the frontend bundle
outputs:
  - CSP header configuration
  - SRI hash for CDN-loaded resource
  - Security checklist result for the integration
---

# Asset Integration Security

Every external resource is untrusted. A compromised CDN or third-party vendor can inject arbitrary code into your users' sessions. Apply these controls before adding any external dependency.

## Threat Model

| Threat              | Vector                                                           |
| ------------------- | ---------------------------------------------------------------- |
| Supply-chain attack | CDN resource replaced with malicious version                     |
| Credential theft    | Secret API key embedded in the frontend bundle                   |
| XSS via embed       | Malicious iframe or widget executes in your origin               |
| Data exfiltration   | Third-party script reads cookies or localStorage and phones home |

## Subresource Integrity (SRI)

Add `integrity` and `crossorigin` to every CDN-loaded script and stylesheet.

```html
<script
  src="https://cdn.example.com/lib@1.2.3/dist/lib.min.js"
  integrity="sha384-<base64-hash>"
  crossorigin="anonymous"
></script>

<link
  rel="stylesheet"
  href="https://cdn.example.com/lib@1.2.3/dist/lib.min.css"
  integrity="sha384-<base64-hash>"
  crossorigin="anonymous"
/>
```

Generate the hash:

```bash
curl -s https://cdn.example.com/lib@1.2.3/dist/lib.min.js \
  | openssl dgst -sha384 -binary | openssl base64 -A
```

Prefer self-hosting the asset over CDN loading when SRI is not available.

## Content Security Policy

Start from `default-src 'none'` and add only what is required.

```
Content-Security-Policy:
  default-src 'none';
  script-src 'self' https://cdn.example.com;
  style-src 'self' https://fonts.googleapis.com;
  font-src 'self' https://fonts.gstatic.com;
  img-src 'self' data: https:;
  connect-src 'self' https://api.example.com;
  frame-src https://trusted-embed.example.com;
  report-uri /csp-report;
```

Never use:

- `unsafe-inline` (use a nonce if inline scripts are absolutely required)
- `unsafe-eval`
- Wildcard `*` in any directive

Test your CSP with the browser console and the `report-uri` endpoint before deploying.

## Third-Party Script Checklist

Before adding any script:

- [ ] Is this integration necessary? (prefer fewer integrations)
- [ ] Is a specific version pinned (not `@latest`)?
- [ ] Does it load `async` or `defer`?
- [ ] Is its DOM access scoped to a container element?
- [ ] Does the vendor have a published security program or bug bounty?
- [ ] Is SRI available for this resource?

## API Keys in the Frontend

| Rule                            | Rationale                                          |
| ------------------------------- | -------------------------------------------------- |
| Never embed server secrets      | Any key in the bundle is public                    |
| Restrict public keys by domain  | Configure in the provider dashboard                |
| Rotate exposed keys immediately | Treat an exposed key as compromised                |
| Prefer server-side proxies      | Keep secrets server-side; proxy calls from the API |

```typescript
// ✅ public key, restricted in provider dashboard by origin
const stripe = new Stripe(process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY);

// ❌ never — secret key in the browser
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);
```

## CORS

- CORS is a server-side control — configure it on the API, not in the browser
- Never use wildcard (`*`) on authenticated or credentialed endpoints
- `credentials: 'include'` only for explicitly trusted origins
- Allowlist is maintained in the API config — not in frontend code

## iFrames and Embeds

```html
<iframe
  src="https://trusted-embed.example.com/widget"
  sandbox="allow-scripts allow-same-origin"
  allow="payment"
  loading="lazy"
  title="Payment widget"
></iframe>
```

- Always use the `sandbox` attribute; add permissions one by one
- Add `X-Frame-Options: DENY` to your own pages unless embedding is required
- Never embed `srcdoc` with user-supplied content

## Pre-Ship Checklist

- [ ] SRI hash added for every CDN resource
- [ ] CSP header configured, tested, and enforced (not report-only)
- [ ] No secret keys in the frontend bundle (`NEXT_PUBLIC_` or equivalent only)
- [ ] Public keys restricted by domain in the provider dashboard
- [ ] Third-party scripts load `async` or `defer`
- [ ] iFrames use `sandbox` with minimal permissions
- [ ] CORS allowlist reviewed and does not include `*` for credentialed requests
- [ ] `report-uri` endpoint exists and is monitored
