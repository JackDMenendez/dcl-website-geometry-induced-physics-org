# Drafts

Staging area for articles in progress. **Nothing in this directory
is rendered into the live site** — `_quarto.yml` excludes `drafts/`
from the render rule, so files here stay private until they're
moved out.

Use this directory for two kinds of work:

1. **Pieces with no committed destination yet** — you're not sure
   if it'll end up as a news post, essay, or something else. Drop
   the `.qmd` here while it takes shape.
2. **Pieces that need a long polish pass before going live** —
   especially essays (which are mini-paper-shaped and benefit from
   multiple drafts).

## How to stage a new article

Just create a `.qmd` file here with whatever frontmatter the
eventual destination will need. For essays, copy the structure
from an existing essay (or use the template below). For news
posts, copy from
[`news/posts/2026-05-19-site-launch.qmd`](../news/posts/2026-05-19-site-launch.qmd).

## How to publish a draft

Move the file out of `drafts/` into the live location:

- **News post (text-only)** → `news/posts/YYYY-MM-DD-<slug>.qmd`
- **Essay (text-only)** → `essays/posts/YYYY-MM-DD-<slug>.qmd`
- **Essay with images / figures** → `essays/posts/YYYY-MM-DD-<slug>/index.qmd`
  with image files (PNG, SVG, etc.) co-located in the same directory.
  This is Quarto's "post directory" convention; the published URL is
  the same (`/essays/posts/<slug>/`) and image paths in the `.qmd`
  are simple filenames (e.g. `fig-birefringence.png`).
- **Paper card / artifact page** → the appropriate section directory

Push to `main`; the workflow renders and deploys.

### Image layout convention

Two patterns to choose from:

1. **Co-located with the post** (recommended for essay-specific
   figures). Each post is a directory; images live inside it. Image
   paths in markdown are bare filenames.

   ```
   essays/posts/2026-06-01-birefringence/
     index.qmd
     fig-birefringence-pattern.png
     fig-dirac-arrows.png
   ```

2. **Shared in `assets/`** (recommended for site-wide / cross-cutting
   images like the home-page hero). Image paths are
   `assets/<filename>`.

Use (1) for figures that only make sense inside one essay, (2) for
reusable artwork. Don't pile every essay's figures into `assets/` —
the directory becomes a junk drawer.

### Image markdown syntax

```markdown
![Caption text rendered below the image](fig-birefringence-pattern.png){fig-alt="Alt text for screen readers — describe the image content, not the caption."}
```

The `fig-alt` field is for accessibility (screen readers and
no-image fallback). Use it for every image. The caption text is
the visible caption rendered below.

For side-by-side or grid layouts, Quarto's `layout` syntax handles
it:

```markdown
::: {layout-ncol=2}
![Left image caption](fig-1.png){fig-alt="..."}

![Right image caption](fig-2.png){fig-alt="..."}
:::
```

## Alternative: in-place drafts via `draft: true`

If a piece already has its destination decided and you just need
to keep it from publishing while you polish:

```yaml
---
title: "Birefringence emerges from the Dirac derivation"
draft: true        # set to false (or remove) to publish
date: "2026-05-22"
categories: [essay, dirac, birefringence]
---
```

Quarto's `draft: true` frontmatter excludes the doc from
rendering and from listing pages. Drop it when ready. This is
better than `drafts/` for pieces that already know where they're
going.

## Genre quick-reference

See [`notes/content_voice_and_audience.md`](../notes/content_voice_and_audience.md)
for the full editorial guidance. Short form:

| Genre | Length | Shape | Examples |
|---|---|---|---|
| **News post** | Short (~150-400 words) | Announcement / report | Paper drop, Zenodo deposit, audit-row flip, milestone |
| **Essay** | Mini-paper (~1000-3000 words) | Discovery / methods write-up | Birefringence emerging from the Dirac derivation; how photon emission is set up in an experiment; framing pieces; response-to-reviewer essays |

## Starter template for an essay

```markdown
---
title: "<short, claim-shaped title>"
description: >-
  <one-sentence summary that surfaces in listings>
author: "Jack D. Menendez"
date: "YYYY-MM-DD"
categories: [<tag1>, <tag2>]
---

## The result in one paragraph

<state the finding or claim up front>

## How it came up

<the path that led here — which experiment / derivation / paper section>

## What it looks like

<the math, the figure, the code excerpt — concrete>

## Why it matters

<connection back to the framework's claims, audit rows, or open questions>

## Open / next

<what's unresolved, what's the next step, what would falsify it>
```

Starter for a news post:

```markdown
---
title: "<concrete event being announced>"
description: >-
  <one-sentence summary>
author: "Jack D. Menendez"
date: "YYYY-MM-DD"
categories: [<tag1>, <tag2>]
---

<one paragraph stating the event and its verifiable record (DOI,
release tag, repo URL).>

<one paragraph on what it changes — which audit row flipped, which
open question moved, which downstream subproject is now unblocked.>
```
