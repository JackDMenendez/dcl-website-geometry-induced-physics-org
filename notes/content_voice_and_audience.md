# Content voice and audience

Editorial guidance for the A=1 DCL website. Aim: a register that
matches the paper-text register — formal, sober, methodologically
anchored — without forcing news posts and essays into a
paper-shaped straitjacket.

## Audiences (in priority order)

1. **Readers and reviewers arriving from Zenodo or arXiv.** They
   land on the site because a citation, a search, or an endorsement
   request brought them. They want: *what is the current state of
   the series, is this active work, who is doing it, where do I go
   next?* The home page and papers page serve this audience first.

2. **Prospective collaborators / endorsers.** They want: *is this
   a serious program, is there a clear methodological arc, do
   the open questions look workable, how do I reach in?* The
   about page, essays, and contact page serve this audience.

3. **The principal investigator and future co-authors.** They use
   the site as a news / status board. Posts here should mirror —
   not replace — the project board's audit-row impact and
   release-coordination state.

## Voice

- **Sober, not breezy.** Match the paper-text register. No
  marketing voice. No exclamation points outside literal quotation.
- **First-person plural ("we") for the series; first-person
  singular ("I") only where authorship attribution requires it.**
  Most news posts and essays should be in third-person or
  first-person plural.
- **Cite explicitly.** Every numerical claim or quoted result
  links to its paper-of-record on Zenodo or the working repository.
  News posts cite their own subject by DOI when a DOI exists.
- **Audit-row-aware.** When a post describes a result, name the
  audit row it flipped (PASS / PART / STUB / FAIL) so readers
  can map the post onto the framework's own internal scorecard.

## What goes where

- **News post:** short, paper-drop-shaped. An announcement of
  something a reader can verify against the published record — a
  paper release, a Zenodo deposit, a talk date, an audit-row flip,
  an outreach milestone (endorsement secured, community
  cross-listing approved). May lift relevant chunks from a paper's
  README or release notes. Typical length: 150–400 words.
- **Essay:** mini-paper-shaped. A discovery write-up, methods
  exposition, or framing argument that needs more than a news post
  but less than a peer-reviewed paper. Examples:
    - How birefringence emerged in the lattice during the
      derivation of the Dirac equation (a discovery captured
      partway through the math).
    - How photon emission is set up in a specific experiment
      (a methods exposition tied to an `exp_NN` script).
    - Response-to-reviewer essays that reshape a paper's scope.
    - Retrospectives on framework decisions; survey pieces that
      map the series onto adjacent literature.

  Essays often include figures (lattice diagrams, derivation
  steps, experiment screenshots). Per the staging convention in
  [`drafts/README.md`](../drafts/README.md), essays with images
  use the post-directory layout: each essay is a directory
  containing `index.qmd` plus co-located image files. Typical
  length: 1000–3000 words.
- **Paper card (on the papers page):** the *canonical* abstract
  and current status. Updated when the paper version changes.
- **Research artifact:** an interactive object (3D model,
  animation, viz) with provenance. Not a post; a permanent page
  in `artifacts/` that can be cited.

## Things to keep off the site

- Speculation about results not yet derived. Speculation belongs
  in memory entries (forward-looking design) and `notes/<topic>.md`
  files in the relevant repo — not in public-facing prose.
- Internal disagreements among collaborators. The site is
  attribution-shaped; conflict resolution happens elsewhere.
- Anything that contradicts a Zenodo-deposited paper without an
  explicit retraction or correction post. Public consistency with
  the deposited record matters.
