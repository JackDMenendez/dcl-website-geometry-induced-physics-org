# DNS and HTTPS runbook

Operational runbook for pointing the working domain at GitHub Pages
and enabling HTTPS. Credentials and registrar account details are
*not* kept here — only the public-facing record state to be set.

## Working domain

`geometry-induced-physics.org` *(confirm at runbook execution time —
inferred from the repository name `dcl-website-geometry-induced-physics-org`)*.

## Pre-cutover checklist

- [ ] Confirm domain ownership (the working domain is registered to
      Jack D. Menendez and the registrar credentials are accessible).
- [ ] Confirm the temporary site's current hosting — note the host,
      any DNS records pointing there, and any analytics/CDN
      integrations that need to be removed before cutover.
- [ ] First successful GitHub Actions deploy of this repository
      (verifies the `gh-pages` branch exists and the rendered site
      is publishable).

## DNS records for GitHub Pages with a custom apex domain

For an **apex domain** (`geometry-induced-physics.org`), point `A`
records at GitHub Pages' published IPs. The canonical list is at
<https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site#configuring-an-apex-domain>;
confirm against that page at cutover time. As of the last check the
addresses were:

```
A    @    185.199.108.153
A    @    185.199.109.153
A    @    185.199.110.153
A    @    185.199.111.153
AAAA @    2606:50c0:8000::153
AAAA @    2606:50c0:8001::153
AAAA @    2606:50c0:8002::153
AAAA @    2606:50c0:8003::153
```

For the **www subdomain**:

```
CNAME www    JackDMenendez.github.io.
```

## CNAME file

Once DNS is set, add a `CNAME` file at the repo root with the apex
domain on a single line:

```
geometry-induced-physics.org
```

Commit; the GitHub Pages deploy will carry this into `_site/` and
GitHub will treat it as the canonical domain.

## HTTPS

After DNS propagates (allow up to 24 hours, usually faster):

1. **Settings → Pages → Custom domain:** confirm the domain shows
   "DNS check successful".
2. Wait for certificate provisioning (typically minutes once the
   DNS check passes).
3. **Settings → Pages → Enforce HTTPS:** enable.

## Post-cutover verification

- [ ] `https://geometry-induced-physics.org` loads the rendered
      site.
- [ ] `https://www.geometry-induced-physics.org` redirects to the
      apex.
- [ ] `http://...` redirects to `https://...` for both.
- [ ] Certificate is valid (no browser warning) and is issued by
      Let's Encrypt via GitHub.
- [ ] All internal links resolve (run the
      [site quality checklist](site_quality_checklist.md) link-rot
      block).

## Rollback

If the cutover causes a regression that needs a fast rollback:

1. Restore the temporary site's DNS records (kept in a copy outside
   this repo, with the registrar's audit log as a secondary
   source).
2. Delete the `CNAME` file on `main`; GitHub Pages will stop
   serving the custom domain on the next deploy.
3. Re-enable any analytics / CDN integrations that the temporary
   site had.
