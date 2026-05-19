# Site quality checklist

Periodic check-list run in lieu of an audit table. Run before any
domain-cutover milestone, before each Phase boundary, and at least
once per quarter once the site is live.

## Link rot

- [ ] Every Zenodo DOI on the papers page resolves.
- [ ] Every GitHub repo link on the papers page resolves.
- [ ] Every external citation in news posts and essays resolves.
- [ ] Navbar links all 200.

## Accessibility

- [ ] Every image has meaningful `alt` text (not just filename).
- [ ] Every `<model-viewer>` has a poster image fallback for
      no-WebGL clients.
- [ ] Headings nest correctly (no `<h1>` → `<h3>` skips).
- [ ] Site renders usably with Tab-key navigation only.
- [ ] Site renders usably at 320px width (mobile).

## Math rendering

- [ ] At least one formula from each shipped paper renders
      correctly in the page where it appears.
- [ ] No `\(`/`\)` raw delimiters leak into rendered HTML.
- [ ] KaTeX vs MathJax method (set in `_quarto.yml`) renders
      consistently across browsers.

## Content freshness

- [ ] Papers page reflects current Zenodo / arXiv state of every
      paper.
- [ ] Collaborators page lists everyone who has consented.
- [ ] Funding page lists current partners with their approved
      attribution form.
- [ ] News post cadence has not gone dormant for more than 90 days
      without intent.

## Build and deploy

- [ ] GitHub Actions `Publish` workflow green on the latest commit
      to `main`.
- [ ] `_site/` reflects the latest content (verify via `View
      Source` on a known-recent post).
- [ ] HTTPS certificate not expired.
