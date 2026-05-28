# Release playbooks

Step-by-step playbooks for shipping a release on this site. Aimed at
AI coding agents (and future-me) handling routine release-coordination
edits. Pairs with [`content_voice_and_audience.md`](content_voice_and_audience.md)
for prose register; this file owns the *mechanics*.

Four workflows are templated:

- **Paper release** — v1.0 (first stable) or v1.n (revision).
- **Code release** — `dcl_core`, `dcl-formalism`, and similar
  packages that ship to Zenodo.
- **Data release** — Zenodo data deposits referenced by an
  experiment or paper.
- **Landing-page publish** — taking a per-paper or per-package
  on-site landing page (`papers/<slug>.qmd`, `artifacts/<slug>.qmd`)
  from `draft: true` to live, and wiring it into the index. Often
  co-occurs with a release but can also stand alone.

---

## Conventions that apply across all release types

- **DOI policy.** Papers carry a DOI only at **v1.n**. Drafts at v0.x
  are repository-only and live under *In progress* on
  [`papers/index.qmd`](../papers/index.qmd). Code and data get a DOI
  from the **first Zenodo deposit** (v0.1.0 is fine — see `dcl_core`).
- **Date discipline.** The news post's `date:` field is the **Zenodo
  deposit date** (YYYY-MM-DD), and the post filename matches:
  `news/posts/YYYY-MM-DD-<slug>.qmd`. Slug is lowercase-kebab-case.
- **Single source of truth for a DOI.** A DOI appears in two places
  and two places only: the entry on [`papers/index.qmd`](../papers/index.qmd)
  and the news announcement post. Do not paste DOIs into
  `index.qmd`, `about.qmd`, or the footer.
- **Front-matter `description:`.** Required on every news post —
  ~150 chars, mirrors the registered voice, becomes the Google /
  Open Graph / Twitter snippet (see
  [`seo_next_steps.md`](seo_next_steps.md)).
- **Title length.** Quarto auto-appends " – A=1 Discrete Causal
  Lattice" (~30 chars) to the page `title:` to form the HTML
  `<title>` element. Aim for the rendered `<title>` to stay
  **under ~65 chars** so it doesn't get truncated in search
  results or trigger Bing Webmaster Tools' "title too long"
  warning. Concretely: page `title:` should be **≤35 chars**. For
  posts whose substantive headline needs more room, use Quarto's
  `subtitle:` field — it renders directly below the H1 on the
  page but does NOT feed `<title>` or `og:title`. Setting
  `pagetitle:` instead of using `subtitle:` only fixes `og:title`,
  not `<title>` (Quarto appends the site suffix to `<title>`
  unconditionally); confirmed by experiment 2026-05-27.
- **Link style.** Markdown links throughout, never bare URLs. House
  style uses `doi.org/10.5281/zenodo.<id>` as the display text for
  DOI links and `github.com/JackDMenendez/<repo>` for repository
  links.
- **Voice.** Sober, no marketing register, audit-row-aware. Read
  [`content_voice_and_audience.md`](content_voice_and_audience.md)
  before writing prose.
- **Cross-links to maintain.** Every release post ends with a
  *Pointers* section linking back to
  [`papers/index.qmd`](../papers/index.qmd). The papers card links
  forward to the repository and Zenodo. The news listing surfaces
  the post automatically — no manual entry needed there.
- **CITATION.cff** at the project root describes the **website
  itself**, not per-paper. Releases do not touch it. Per-paper /
  per-code citation lives on Zenodo.

---

## Paper release playbook

### When to use

A new paper version has been deposited to Zenodo with a v1.n tag. If
the version is still v0.x (draft), stop — the paper does not yet
have a DOI and belongs under *In progress* on the papers page with no
DOI line.

### Preconditions

1. Zenodo deposit exists; the DOI (concept and version) is known.
2. GitHub release tag `v1.n` exists on the paper repository.
3. The new version's title, framing paragraph, and abstract are
   final.

### Steps

1. **Update [`papers/index.qmd`](../papers/index.qmd).** Locate the
   paper's card. If this is v1.0, move the card from *In progress*
   to *Published* and replace its lines with the v1.0 template
   below. If this is v1.n (n ≥ 1), update Version and DOI in place
   and add a Prior-version DOI line.
2. **Write the news post** at `news/posts/<YYYY-MM-DD>-paper-<NN>-v1-<n>.qmd`
   using the news template below. The framing paragraph is repeated
   for v1.0 (introducing the paper) and replaced with a *what
   changed since v1.<n-1>* paragraph for revisions.
3. **Render and verify.** Run `quarto render`, then verify the meta
   tags landed (see *Verification checklist* at the bottom).
4. **Do not** rewrite the paper card's framing paragraph during a
   revision unless the paper's scope changed. The framing is the
   canonical abstract; revisions update version + DOI, not framing.

### Template — papers/index.qmd card, v1.0 (first stable)

```markdown
### Paper <N> — *<Title>*

<One framing paragraph: what the paper establishes, what it derives
from what, and the key audit-row that flipped to PASS. Match the
register of the existing entries.>

- **Version:** v1.0
- **DOI:** [10.5281/zenodo.<ZENODO_ID>](https://doi.org/10.5281/zenodo.<ZENODO_ID>)
- **Repository:** [`<repo-slug>`](https://github.com/JackDMenendez/<repo-slug>)
```

### Template — papers/index.qmd card, v1.n (revision; n ≥ 1)

```markdown
### Paper <N> — *<Title>*

<Existing framing paragraph; unchanged unless scope changed.>

- **Version:** v1.<n>
- **DOI:** [10.5281/zenodo.<NEW_ZENODO_ID>](https://doi.org/10.5281/zenodo.<NEW_ZENODO_ID>)
- **Prior-version DOI:** [10.5281/zenodo.<PRIOR_ZENODO_ID>](https://doi.org/10.5281/zenodo.<PRIOR_ZENODO_ID>) (v1.<n-1>)
- **Repository:** [`<repo-slug>`](https://github.com/JackDMenendez/<repo-slug>)
```

Only the immediately prior version's DOI is listed inline; Zenodo's
concept-DOI mechanism preserves the full chain. Do not grow this
into a per-revision list.

### Template — news post, paper v1.0 (first stable)

```markdown
---
title: "Paper <N> — <Title> — v1.0 deposited"
description: >-
  <1–2 sentences naming what the paper establishes and the headline
  derivation it delivers. Mirrors the description style of existing
  news posts; becomes the Google / OG / Twitter snippet.>
author: "Jack D. Menendez"
date: "<YYYY-MM-DD>"
categories: [release, paper]
---

Paper <N> (*<Title>*) is now on Zenodo with DOI
[10.5281/zenodo.<ZENODO_ID>](https://doi.org/10.5281/zenodo.<ZENODO_ID>).

<2–5 paragraphs of substantive content: what the paper derives, the
audit row(s) it flips, where it sits in the methodological arc, what
open questions it leaves for downstream papers. Cite related papers
in the series by DOI.>

Pointers:

- Zenodo deposit: [doi.org/10.5281/zenodo.<ZENODO_ID>](https://doi.org/10.5281/zenodo.<ZENODO_ID>)
- GitHub release: [github.com/JackDMenendez/<repo-slug>/releases/tag/v1.0](https://github.com/JackDMenendez/<repo-slug>/releases/tag/v1.0)
- Repository: [github.com/JackDMenendez/<repo-slug>](https://github.com/JackDMenendez/<repo-slug>)
- Series papers: see the [papers page](../../papers/index.qmd).
```

### Template — news post, paper v1.n (revision; n ≥ 1)

```markdown
---
title: "Paper <N> — <Title> — v1.<n> deposited"
description: >-
  <1–2 sentences naming what changed in this revision and why.
  Becomes the Google / OG / Twitter snippet — do not bury the
  delta.>
author: "Jack D. Menendez"
date: "<YYYY-MM-DD>"
categories: [release, paper, revision]
---

Paper <N> (*<Title>*) is now at v1.<n> on Zenodo with DOI
[10.5281/zenodo.<NEW_ZENODO_ID>](https://doi.org/10.5281/zenodo.<NEW_ZENODO_ID>).
The prior version (v1.<n-1>) remains citable at
[10.5281/zenodo.<PRIOR_ZENODO_ID>](https://doi.org/10.5281/zenodo.<PRIOR_ZENODO_ID>).

<1–3 paragraphs on what changed since v1.<n-1>: corrections, new
derivations, scope adjustments, audit-row flips. Be specific —
"clarified §3" is too vague to be a verifiable record.>

Pointers:

- Zenodo deposit (v1.<n>): [doi.org/10.5281/zenodo.<NEW_ZENODO_ID>](https://doi.org/10.5281/zenodo.<NEW_ZENODO_ID>)
- Zenodo deposit (v1.<n-1>): [doi.org/10.5281/zenodo.<PRIOR_ZENODO_ID>](https://doi.org/10.5281/zenodo.<PRIOR_ZENODO_ID>)
- GitHub release: [github.com/JackDMenendez/<repo-slug>/releases/tag/v1.<n>](https://github.com/JackDMenendez/<repo-slug>/releases/tag/v1.<n>)
- Repository: [github.com/JackDMenendez/<repo-slug>](https://github.com/JackDMenendez/<repo-slug>)
- Series papers: see the [papers page](../../papers/index.qmd).
```

---

## Code release playbook

### When to use

A package (`dcl_core`, `dcl-formalism`, etc.) has been deposited to
Zenodo with a tagged GitHub release. Unlike papers, code can carry a
DOI from any v0.n.0 onward — the first deposit is the first DOI.

### Preconditions

1. Zenodo deposit exists; DOI is known.
2. GitHub release tag `v<X>.<Y>.<Z>` exists with release notes.
3. Test status at the release tag is known and can be quoted.
4. If downstream papers will pin to this release, the pin string is
   ready.

### Steps

1. **Update [`papers/index.qmd`](../papers/index.qmd)** if the
   package warrants a card there (consult: does it underwrite a
   paper? `dcl_core` does and has a card; one-off utilities may not).
   Place under *Published* if it has a DOI.
2. **Write the news post** at
   `news/posts/<YYYY-MM-DD>-<package>-v<X>-<Y>-<Z>.qmd`.
3. **Render and verify.**

### Template — papers/index.qmd card, code package

```markdown
### `<package-name>` — <one-line role>

<One framing paragraph: what the package is for, what's distinctive
about its design, which paper(s) it underwrites or is referenced by.>

- **Version:** v<X>.<Y>.<Z>
- **DOI:** [10.5281/zenodo.<ZENODO_ID>](https://doi.org/10.5281/zenodo.<ZENODO_ID>)
- **Repository:** [`<repo-slug>`](https://github.com/JackDMenendez/<repo-slug>)
- **Pinning syntax for downstream papers:**
  `<package_import> @ git+https://github.com/JackDMenendez/<repo-slug>@v<X>.<Y>.<Z>`
```

### Template — news post, code release

```markdown
---
title: "<package-name> v<X>.<Y>.<Z> deposited"
description: >-
  <1–2 sentence framing of what's in this release, with the
  distinctive design choice surfaced. ~150 chars.>
author: "Jack D. Menendez"
date: "<YYYY-MM-DD>"
categories: [release, software]
---

`<package-name>` v<X>.<Y>.<Z> is now on Zenodo with DOI
[10.5281/zenodo.<ZENODO_ID>](https://doi.org/10.5281/zenodo.<ZENODO_ID>).

<Body — adapt the sections that apply:

- **What's in this release.** The major components or engines that
  ship, with one-paragraph framing of each.
- **What's distinctive.** The design choice or invariant that this
  release establishes.
- **Test status at release.** Concrete numbers: passed / skipped /
  xfailed, with one-line rationale for any skip or xfail bucket.
- **What is deliberately NOT in this release.** The list that
  belongs on the next milestone. Honesty here is what makes the
  post a verifiable record.>

Pinning notation for downstream consumers:

\`\`\` text
<package_import> @ git+https://github.com/JackDMenendez/<repo-slug>@v<X>.<Y>.<Z>
\`\`\`

Pointers:

- Zenodo deposit: [doi.org/10.5281/zenodo.<ZENODO_ID>](https://doi.org/10.5281/zenodo.<ZENODO_ID>)
- GitHub release: [github.com/JackDMenendez/<repo-slug>/releases/tag/v<X>.<Y>.<Z>](https://github.com/JackDMenendez/<repo-slug>/releases/tag/v<X>.<Y>.<Z>)
- Repository: [github.com/JackDMenendez/<repo-slug>](https://github.com/JackDMenendez/<repo-slug>)
- Series papers: see the [papers page](../../papers/index.qmd).
```

(Note: replace the literal backticks in the pinning fence with three
backticks when pasting; the template fences itself to preserve them.)

---

## Data release playbook

### When to use

A dataset (experiment output, simulation corpus, audit-row evidence)
has been deposited to Zenodo. Data deposits get a DOI from the first
upload, like code.

### Preconditions

1. Zenodo data deposit exists with a clear license (CC0 or CC BY 4.0
   preferred for research data — confirm with the PI before posting
   if it's not one of these).
2. The dataset's schema, units, and generation provenance are
   documented (typically in the deposit's README, in the producing
   experiment script, or in a paper's methods section).
3. The experiment script or paper that *produced* the data is
   identifiable.

### Steps

1. **Determine surface.** A pure data deposit usually lives on
   [`artifacts/index.qmd`](../artifacts/index.qmd), not on
   [`papers/index.qmd`](../papers/index.qmd) — *unless* the dataset
   is itself a citeable scholarly contribution (a catalogue paper,
   for example), in which case it gets a papers card. Default:
   artifacts.
2. **Add the artifact page** at `artifacts/<dataset-slug>.qmd`
   following the existing artifact template (see
   [`artifacts/lattice-unit-cell.qmd`](../artifacts/lattice-unit-cell.qmd)).
3. **Write the news post** at
   `news/posts/<YYYY-MM-DD>-<dataset-slug>-deposited.qmd`.
4. **Render and verify.**

### Template — news post, data release

```markdown
---
title: "<Dataset name> deposited"
description: >-
  <1–2 sentence framing: what the dataset contains, which
  experiment / paper produced it, and what one would do with it.>
author: "Jack D. Menendez"
date: "<YYYY-MM-DD>"
categories: [release, data]
---

The *<Dataset name>* dataset is now on Zenodo with DOI
[10.5281/zenodo.<ZENODO_ID>](https://doi.org/10.5281/zenodo.<ZENODO_ID>),
under <license — e.g. CC0 1.0 or CC BY 4.0>.

<Body:

- **What it contains.** Schema, units, file count, total size,
  format (.npy + JSON sidecar, HDF5, CSV, etc.). One paragraph.
- **How it was produced.** The experiment script and code version
  (e.g. `experiments/exp_NN_<name>.py` from `dcl_core` v0.1.0), the
  hardware / OS / library versions if relevant, the seed if
  deterministic. Link the producing script.
- **What it supports.** The paper or audit-row the data
  underwrites. If the dataset is referenced by a paper in the
  series, name the paper and DOI.
- **How to load it.** One short code block (Python or shell) showing
  the canonical load pattern, so a reviewer can verify in under a
  minute.>

Pointers:

- Zenodo deposit: [doi.org/10.5281/zenodo.<ZENODO_ID>](https://doi.org/10.5281/zenodo.<ZENODO_ID>)
- Producing script: [`<path/to/script>`](https://github.com/JackDMenendez/<repo-slug>/blob/v<X>.<Y>.<Z>/<path/to/script>)
- Repository: [github.com/JackDMenendez/<repo-slug>](https://github.com/JackDMenendez/<repo-slug>)
- Artifact page: [<dataset-slug>](../../artifacts/<dataset-slug>.qmd)
- Series papers: see the [papers page](../../papers/index.qmd).
```

---

## Landing-page publish playbook

### Context

Each paper and code package has a draft on-site landing page at
[`papers/<slug>.qmd`](../papers/); data deposits land at
[`artifacts/<slug>.qmd`](../artifacts/). While `draft: true` is in
the front matter, the page is invisible to the live site. Publishing
means removing `draft: true` and adding a discoverability link from
the index card.

**Drafts currently in place** (as of 2026-05-27, all `draft: true`):

- `papers/paper-01-geometry-first.qmd`
- `papers/paper-02-geometry-forces-physics.qmd`
- `papers/paper-03-tidal-ionization.qmd` (also pre-v1.0 — landing
  page is forward-looking)
- `papers/dcl-core.qmd`

These were scaffolded with front matter, citation/version blocks
populated from existing Zenodo data, and section headers. The body
prose is the publisher's responsibility before `draft: true` comes
off.

### When to use

Three independent triggers:

1. **Drafting work has reached publishable quality** — independent
   of any release event. A landing page can publish whenever its
   prose is ready.
2. **A release happens** (paper / code / data) **and** the landing
   page is ready to go live alongside. This playbook then runs
   *in addition to* the matching release playbook above.
3. **The Scholar-canonical decision flips.** Project default is
   Zenodo-canonical (see
   [`seo_next_steps.md`](seo_next_steps.md)); flipping that
   decision means adding `citation:` blocks to landing pages — a
   deliberate, separate choice. See *Sub-decision: citation:
   blocks* below.

### Preconditions

1. The landing page exists at its destination path with
   `draft: true`.
2. Body prose is filled in; placeholder comments
   (`<!-- ... -->`) and angle-bracket placeholders are removed.
3. The citation block (DOI, version, repo, release tag) **agrees
   with** the matching card on
   [`papers/index.qmd`](../papers/index.qmd) and with the Zenodo
   deposit. Cross-check before publishing.
4. The Scholar-canonical decision for *this page* is known and
   matches project default unless a flip has been recorded in
   [`seo_next_steps.md`](seo_next_steps.md).

### Steps

1. **Decide on `citation:` block.** Default is **no** — Zenodo
   remains canonical. Only add a `citation:` block if explicitly
   flipping the decision recorded in
   [`seo_next_steps.md`](seo_next_steps.md). That flip is an
   architectural choice, not a per-page tweak; if flipping, do it
   consistently across all published landing pages, not one at a
   time.
2. **Remove `draft: true`** from the front matter (cleaner than
   setting it to `false`).
3. **Add a landing-page link** to the matching card on
   [`papers/index.qmd`](../papers/index.qmd). Two equivalent
   patterns — **pick one and use it consistently** across all
   cards once chosen:

   *Pattern A* — extra bullet line (matches the existing bullet
   structure of each card):

   ```markdown
   - **Landing page:** [Paper <N> — <Title>](paper-<NN>-<slug>.qmd)
   ```

   *Pattern B* — heading itself is a link:

   ```markdown
   ### [Paper <N> — *<Title>*](paper-<NN>-<slug>.qmd)
   ```

4. **Do not reduce the index card's framing paragraph.** The
   synopsis on the index serves triage readers; the landing page's
   abstract serves paper-canonical readers. Both are kept on
   purpose — the architectural rationale is in the conversation
   transcript that produced the scaffolds, summarised in *What
   this playbook does not cover* below.
5. **Render and verify** — see *Verification checklist (any
   release)* below, plus the landing-page-specific extras at the
   end of this section.

### Sub-decision: `citation:` blocks

A Quarto `citation:` block emits `citation_*` meta tags that Google
Scholar reads. Adding one makes the landing page Scholar-canonical
for that paper, *competing with the Zenodo record*. Project default
is **no citation block** because:

- Zenodo's PDF hosting and DOI infrastructure are the citation
  surfaces of record.
- Manual Scholar placeholders bridge the Zenodo indexing lag (see
  [`seo_next_steps.md`](seo_next_steps.md)).
- Adding rival citation tags risks duplicate or split Scholar
  records.

**Do not add `citation:` blocks without an explicit flip decision
recorded in [`seo_next_steps.md`](seo_next_steps.md).** A mixed
state (some landing pages with citation tags, others without) is
the worst-of-both-worlds outcome — if flipping, do all of them.

### Landing-page-specific verification extras

After running the *Verification checklist (any release)* below,
also confirm:

- `_site/papers/<slug>.html` exists and renders the prose, not
  just placeholder comments.
- The new link from [`papers/index.qmd`](../papers/index.qmd)
  resolves in `_site/papers/index.html`.
- The landing page appears in `_site/sitemap.xml`.
- The Scholar-canonical decision is reflected: search the rendered
  HTML for `citation_title` — it should be **absent** unless a
  flip was recorded.
- No leftover `<!-- ... -->` scaffolding comments in the rendered
  HTML.

### What this playbook does not cover

- **Listing-page conversion of `papers/index.qmd`.** Do *not*
  convert it into a Quarto `listing:` page that auto-generates from
  landing-page front matter. The *Planned* section has no
  underlying landing pages, and Quarto listings respect
  `draft: true` (so any not-yet-published landing pages disappear).
  The index stays handcrafted, with one link added per landing
  page as each publishes.
- **Linking from the index to a draft landing page.** Draft pages
  do not render to the deployed site; links to them 404 in
  production even when the local preview shows them resolving.
  Add the index link **only after** removing `draft: true` and
  confirming the landing page renders.

## Verification checklist (any release)

After rendering, before committing:

1. **`quarto render` succeeded with no errors.**
2. **News post appears** on `news/index.html` listing and (if a
   paper or code release) on the home page's *Latest news* listing.
3. **Meta tags landed.** Spot-check the new post's `_site/.../*.html`
   for `<meta name="description">`, `og:title`, `og:description`,
   `og:image`, `twitter:card` (see
   [`seo_next_steps.md`](seo_next_steps.md) for what good looks
   like).
4. **Sitemap updated.** Open `_site/sitemap.xml` and confirm the new
   post URL is present.
5. **Links resolve.** All `doi.org/10.5281/zenodo.<id>` links 200
   when followed. (External, but a one-pass check.)
6. **Papers card matches the post.** Version, DOI, and prior-version
   DOI agree between [`papers/index.qmd`](../papers/index.qmd) and
   the post body.
7. **Front-matter `description:` is present** and within ~150 chars.
8. **`categories:` follows house style.** First category is always
   `release`; second category is the type (`paper`, `software`,
   `data`); third (optional) is `revision` for paper v1.n with n ≥ 1.
9. **No bare URLs** — every link uses markdown syntax.
10. **No DOI leak into other pages.** `grep` the project for the new
    DOI; it should appear only in `papers/index.qmd` and the post.

## Things this playbook intentionally does not cover

- **Zenodo deposit mechanics.** The DOI must already exist before
  this playbook starts. Zenodo's UI is the canonical place for that
  step.
- **arXiv submission.** Separate from website edits; handled in the
  paper repository. arXiv endorsement is also currently a blocker —
  see [`seo_next_steps.md`](seo_next_steps.md) for the preprint
  situation and the PhilSci-Archive bridge for the upcoming
  philosophical-foundations paper.
