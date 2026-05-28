# SEO — what's done, what's outstanding

Captured 2026-05-27 after the first pass of SEO config landed.

## What's now in the built site

**`_quarto.yml`** — enabled `open-graph: true`,
`twitter-card: summary_large_image`, and set
`/assets/bipartite-lattice.png` as the default social card image.

**Per-page `description:` front matter** on all nine top-level pages:
`index.qmd`, `papers/index.qmd`, `about.qmd`, `news/index.qmd`,
`essays/index.qmd`, `artifacts/index.qmd`, `collaborators.qmd`,
`funding.qmd`, `contact.qmd`.

**Verified in `_site/`:** every page now emits
`<meta name="description">`, the full
`og:title`/`og:description`/`og:image`/`og:site_name` set, and
`twitter:card="summary_large_image"` with matching title / description
/ image. Image URL resolves absolute against `site-url`
(`https://geometryinducedphysics.org/assets/bipartite-lattice.png`) —
correct for crawlers.

## Caveat: social card image dimensions

The bipartite-lattice PNG is **571 × 491**. Twitter / LinkedIn
large-image cards prefer **1200 × 630** (≈1.91:1). The current image
renders but will be letterboxed / cropped in previews. A
purpose-made 1200 × 630 card (lattice diagram + site title +
tagline) would visibly improve link previews. Non-blocking.

## Why I did NOT add Quarto `citation:` blocks for Google Scholar

The original plan included `citation:` blocks on the papers page for
Scholar indexing. On closer look this would have been wrong:

- Quarto's `citation:` field describes **one paper per page**.
  `papers/index.qmd` lists many — a single citation block would
  misrepresent the page.
- Google Scholar's `citation_*` meta tags also expect the **PDF to be
  hosted on that page**. The PDFs live on Zenodo and arXiv, which
  already feed Scholar with the correct metadata. Adding rival tags
  here risks duplicate Scholar records pointing to a page that isn't
  the canonical source.

The correct route, if we want this site to be on-Scholar, is
**per-paper landing pages** (e.g.
`papers/paper-01-geometry-first.qmd`) — each with its own
`citation:` block, abstract, and a link or mirror of the PDF. Small
architecture change, not a config tweak. Needs an upstream decision:
**do we want this site or Zenodo to be the Scholar canonical for the
series?** Going on-site competes with Zenodo; staying off-site
concedes Scholar to Zenodo's record. **Decision: Zenodo is
canonical.**

### Placeholder workaround for the Zenodo indexing lag

Google is slow to index Zenodo records, so the PI has **manually
added placeholder Scholar entries** for the series to bridge the
gap. These are transitional — once Scholar re-crawls Zenodo, its
authoritative `citation_*` meta tags will supersede the manual
entries and the records become permanent without further action.

Implications for this site:

- **Keep the outbound DOI links on `papers/index.qmd` stable.**
  Every change resets Google's freshness signal on those URLs and
  delays the Zenodo crawl that ends the placeholder period.
- Submitting `sitemap.xml` to Search Console (item 1 below) gives
  Google a fresh crawl signal on this site, and the prominent
  outbound DOI links act as discovery hints toward the Zenodo
  records. Small effect, but cheap.
- **If the placeholder URLs point at this site rather than at
  Zenodo DOIs**, we owe per-paper landing pages eventually — so
  Scholar's final cached URL doesn't 404. Confirm placeholder
  destinations before they become a problem.

## Where the leverage is from here

Rough order of impact. None of these are code I can do unilaterally.

1. **Google Search Console + Bing Webmaster Tools** — verify the
   domain, submit `https://geometryinducedphysics.org/sitemap.xml`.
   Without this, first indexing is slow and blind.
2. **Inbound links** — ORCID record linkage (now that ORCID
   `0009-0003-1166-307X` is on the contact page), a Google Scholar
   profile, blog / forum mentions, and **paper-type-specific
   preprint-venue deposits** (see *Preprint situation* below —
   arXiv is gated by endorsement and currently unavailable; the
   right bridge differs for the physics derivation papers vs the
   upcoming philosophical-foundations paper). Domain authority is
   the single biggest lever for a new domain.
3. **Per-paper landing pages** (the proper version of the Scholar
   item above) — only if we decide this site is the Scholar canonical
   for the series.
4. **Essays cadence** — fresh, indexable, real-keyword-bearing
   content. The two essay drafts already point the right way.
5. **Vocabulary bridging** — "A=1 Discrete Causal Lattice" and
   "geometry-induced physics" are zero-competition coinages. Pages
   (especially essays) need to naturally use what researchers
   actually type: *discrete spacetime, causal set theory, emergent
   Lorentz invariance, lattice quantum gravity, Standard Model gauge
   group from geometry, quantum Roche limit*.

## Preprint situation (affects item 2 above)

**Status as of 2026-05-27: arXiv endorsement is not yet secured.**
arXiv requires a vouch from an already-publishing author in the
target category (`gr-qc`, `hep-th`, `math-ph`, `physics.hist-ph` are
the relevant ones for the series). Endorsement attests to *fit*,
not *correctness* — but it is a relational gate, and the program is
operating without an institutional network into those categories.
This is a structural outsider-vs-institution problem, not a content
quality issue.

**The right bridge depends on the paper's genre.** The series has
two distinct paper types and they need different handling.

### Physics derivation papers (Papers I, II, III, …)

These derive results inside physics — Lorentz invariance, the
Standard Model gauge group, the quantum Roche limit, etc. Their
canonical preprint venue is arXiv (gated). **There is no clean
substitute.** Do not route these to PhilSci-Archive (out of scope —
see below) or to OSF / Preprints.org / SSRN (low prestige in
physics; net-negative for credibility in this audience).

The bridge for the derivation papers, while arXiv stays blocked, is
the stack already in place:

- **Zenodo deposit + concept DOI** — the canonical record.
- **Manual Scholar placeholder** — bridges the Zenodo indexing lag
  (see *Placeholder workaround* above).
- **Direct journal submission** — *Foundations of Physics*
  (Springer), *International Journal of Theoretical Physics*,
  *Annales Henri Poincaré*, and *Studies in History and Philosophy
  of Modern Physics* accept submissions without an arXiv preprint.
  Peer-reviewed publication is the signal that dwarfs any preprint
  placement.
- **FQXi essay contest** — independent reviewer track, real CV
  line, fits the *geometry first* framing exactly.

This is a real bridge, not a fallback. A Zenodo record plus a
journal acceptance carries more weight than an arXiv preprint that
has not been independently reviewed.

### Philosophical-foundations paper (in preparation)

A separate paper genre is in preparation — the philosophical /
methodological foundations of the series. This paper has a clean
preprint home that the derivation papers don't.

**PhilSci-Archive** ([philsci-archive.pitt.edu](https://philsci-archive.pitt.edu))
— University of Pittsburgh's preprint server for **philosophy of
science**, with philosophy of physics as its largest subject area.
No endorsement, moderation queue measured in days, indexed by
Google Scholar.

The philosophical paper is also load-bearing for the broader
strategy in a way the derivation papers aren't:

- **It is the natural front door.** A sympathetic reader is more
  likely to engage with the *geometry first* methodological framing
  than to cold-read a Standard Model derivation. Once engaged, they
  follow the citations into Papers I and II.
- **It establishes presence in the philosophy-of-physics community**,
  which overlaps with foundations-of-physics journal editors,
  reviewers, and potential arXiv `physics.hist-ph` endorsers.
- **It adds a citable record on a university-hosted academic
  domain** — a stronger inbound-link signal than typical web
  citations.

Deposit it on PhilSci-Archive in parallel with Zenodo (or in place
of Zenodo, if a Zenodo deposit doesn't make sense for the genre).

### Endorsement strategy when reattempted

If arXiv endorsement is pursued, the ask should be:

- **Directed** to active publishers in the closest subfield
  (discrete-spacetime / causal-set theorists, lattice gauge with a
  foundations bent, philosophy-of-physics on emergent spacetime).
- **Specific and time-boxed**: "Would you read the abstracts of
  these Zenodo deposits and consider endorsing me for `gr-qc`?" —
  not "would you read my framework."
- **Carrying a CV signal that grew while arXiv was blocked.** The
  philosophical paper on PhilSci-Archive is the strongest of these
  signals because it shares vocabulary with the endorser's own
  literature; an FQXi essay entry, a journal submission in flight,
  or a workshop / conference acceptance also count. Endorsers are
  looking for fit cues; the philosophical paper specifically is
  most likely to produce them.

### Venues to avoid

- **viXra.** Widely associated with crackpot work; listing there
  actively damages credibility with the reviewers and endorsers
  most likely to be helpful. Do not deposit anything there under
  any circumstance.
- **PhilSci-Archive for the physics derivation papers.** PhilSci's
  scope is philosophy of science; depositing a technical derivation
  paper there will at best be bounced as out of scope and at worst
  read as a category-error signal to philosophy-of-physics readers.
  Only the philosophical-foundations paper belongs there.
- **OSF Preprints, Preprints.org (MDPI), and SSRN's physics
  section** for the derivation papers. Each carries reputational
  costs in the foundations-of-physics audience that outweigh the
  inbound-link benefit. Adding more low-prestige preprint surfaces
  is net-negative.
