# dcl-website-geometry-induced-physics-org

Source for the public website of the **A=1 Discrete Causal Lattice
(DCL) series**.

- **Production URL (planned):** <https://geometryinducedphysics.org>
- **Framework:** [Quarto](https://quarto.org/) (markdown-in-git, KaTeX
  math, built-in publication and blog listings).
- **Hosting:** GitHub Pages, built and deployed by GitHub Actions on
  push to `main`.
- **Subproject issue:** see `issue-drafts/003-new-subproject-dcl-website.md`
  in the [project-tracking repository](https://github.com/JackDMenendez/discrete-causal-lattice-project).

## Local preview

Install Quarto from <https://quarto.org/docs/get-started/>, then:

```sh
quarto preview          # live-reload local server
quarto render           # one-shot build into _site/
```

## Site structure

```
index.qmd              Home (hero + latest news teaser)
about.qmd              About the programme (placeholder)
collaborators.qmd      Public collaborator roster
funding.qmd            Public funding-partner attribution
contact.qmd            How to reach in (review, endorsement, collab)
news/                  Project news (chronological listing)
  index.qmd
  posts/
papers/                Series papers with DOIs and repo links
  index.qmd
artefacts/             3D models, animations, interactive viz
  index.qmd
  lattice-unit-cell.qmd
essays/                Methodological essays and reviews
  index.qmd
  posts/
notes/                 Working notes (not rendered into the site;
                       excluded by _quarto.yml `render:` rule)
styles.css             Scaffold-level CSS (visual polish: Phase 5)
_quarto.yml            Site config: navbar, theme, math, etc.
```

## Deploy

The deploy pipeline is `.github/workflows/publish.yml` — a single
job that installs Quarto, renders the site, and publishes to the
`gh-pages` branch. After the first successful run, enable GitHub
Pages in repository settings:

1. **Settings → Pages → Build and deployment → Source:** *Deploy
   from a branch*.
2. **Branch:** `gh-pages`, folder `/ (root)`.
3. **Custom domain:** `geometryinducedphysics.org` (confirm and
   add the `CNAME` file when DNS is ready — see
   `notes/dns_and_https_runbook.md`).
4. **Enforce HTTPS:** enable once the certificate provisioning
   completes.

## Licensing

This repository uses a **dual license**:

- **Source code** (`_quarto.yml`, JavaScript, CSS, GitHub Actions
  workflow): [MIT](LICENSE-CODE).
- **Prose, articles, essays, image content**:
  [CC BY 4.0](LICENSE-PROSE.md).

This matches the series' default licensing convention.

## Contributing

External contributions are not currently solicited. Reviewers and
prospective collaborators should see the [contact page](contact.qmd).
Site bugs (broken links, math-render glitches, accessibility issues)
are tracked via the [project-tracking
repository](https://github.com/JackDMenendez/discrete-causal-lattice-project)
under the `bug` template, with this repo selected as the affected
repo.
