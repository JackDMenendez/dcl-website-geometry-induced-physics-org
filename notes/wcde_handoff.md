# Handoff: Centralized convention distribution across the DCL repo family

Audience: A future Claude session (or future-Jack) working in
`c:\dev\wcde` (internally named `dev-shell`) to add a
**capability-driven convention-distribution mechanism** across the
20+ repos that will make up the DCL program.

This document is the design output of a session focused on the
dcl-website-geometry-induced-physics-org repo (2026-05-27) that
surfaced spell-check config sprawl as the visible problem and the
need for centralized convention distribution as the underlying one.
No wcde code was written or modified in that session; the design
work was done here so a fresh wcde session can implement with clean
cross-repo context.

---

## Why this is needed now

- DCL is a **20+ paper program** (Papers I–III deposited or drafted;
  generator-zoo, discrete-probability, Hilbert-Sixth capstone,
  proton-internals, and more queued). Plus code packages
  (`dcl_core`, planned `dcl-formalism`), data deposits, a project-
  tracking repo, this website. Realistic terminal scale: **30+
  repos**.
- Each repo wants 5–8 shared convention files (spell-check,
  `.editorconfig`, `.gitignore` patterns, render config, CI
  workflow, CITATION.cff, etc.). At 30 repos × 7 files = 210
  convention-instances to keep in sync without centralization.
- Conventions evolve mid-program. In the session that produced this
  doc, the *title-length convention* was invented and added to the
  release playbook — every existing repo will eventually want that
  rule. Manually updating 30 repos per convention change is
  unscalable.
- `dev-shell`'s own HANDOFF.md already records the symptom in its
  *Known Follow-ups* section: *"setup-vscode.sh (and the Windows
  equivalent) should also patch the target repo's `.gitignore` to
  add `.vscode/* + !.vscode/extensions.txt` … DCL subprojects
  (dcl-core, dcl-delta-p-min, dcl-paper-03) have this pattern
  applied by hand as of 2026-05-26; future repos initialised by
  `setup-vscode.sh` should inherit it automatically."* That
  follow-up is one instance of the broader pattern this design
  addresses.

---

## What's already in `dev-shell` (state as of 2026-05-27)

Things this design plugs into, not things to re-invent.

| Location | Role | Current state |
| --- | --- | --- |
| `shells/windows/cmd/vscode-*.cmd` | Launchers. Six variants: `cmd`, `miktex`, `mingw64`, `ps`, `sagemath`, `ucrt64`. | Each ~12 lines: source `env/<subsystem>-env.cmd`, then `call <Code.exe> %*`. **Add one line for the repo-update hook.** |
| `shells/bash/lib/repo-setup.sh` | Clone-and-init from GitHub URL → local dir. Creates subsystem venv, installs requirements, writes hardcoded `.vscode/settings.json`. | Mature. **Parallel to `repo-update.sh` — not a base to extend.** |
| `shells/windows/lib/repo-setup.cmd` | Windows-native equivalent. Creates `.venv-win`, writes a Command-Prompt-flavored settings.json. | Mature. Parallel to bash version. |
| `shells/bash/tools/setup-vscode.sh` | Writes `.vscode/settings.json` for the current MSYSTEM subsystem in an existing repo. | **This is the file to evolve into the capability-driven assembler.** Currently hardcoded via here-doc; no spell-check content, no LTeX dictionary, no Spell Right config. |
| `templates/` | Holds HOWTO_REPRODUCE.md, commit-template.txt, container.conf.template. | **No capability-bundle structure yet.** This is where bundles get added. |
| `notes/HANDOFF.md` | The project's design log. | Read on entry. Pay attention to *Known Follow-ups* and the *Note For Future Sessions* about relocatability. |
| `tools/generate_catalog.py` | Auto-generates `catalog.md`. | Working. New scripts get added to this catalog. |

The MSYSTEM-aware detection (`UCRT64` / `MINGW64` / `CLANG64` / `MSYS`)
is consistent across `repo-setup.sh` and `setup-vscode.sh` — the new
update logic should respect the same convention. The Windows side
doesn't use MSYSTEM; it uses `CANONICAL_WIN_PYTHON` from
`env/global-var.cmd`. New code should mirror.

---

## The proposal in one sentence

Add a **`repo-update`** operation symmetric to `repo-setup`, driven
by **capability bundles** in `templates/`, that runs from each
`vscode-*.cmd` launcher and idempotently brings the target repo up
to current conventions — selecting which conventions apply via an
auto-detected, cached, override-able capability set per repo.

---

## Architecture

### Launcher integration

One new line in each of the six `vscode-*.cmd` launchers. For
`vscode-ucrt64.cmd`:

```cmd
:: vscode-ucrt64.cmd
@echo off
setlocal

call "%~dp0env\ucrt64-env.cmd"
call "%~dp0..\lib\repo-update.cmd" %*   :: <-- NEW: pre-VSCode hook
call "%USERPROFILE%\AppData\Local\Programs\Microsoft VS Code\Code.exe" %*
set EXITCODE=%ERRORLEVEL%

endlocal & exit /b %EXITCODE%
```

Identical line in `vscode-mingw64.cmd`, `vscode-miktex.cmd`,
`vscode-sagemath.cmd`, `vscode-ps.cmd`, `vscode-cmd.cmd`. The env
script differs; the hook is the same. Could be factored into a
shared *pre-vscode hook* helper if desired, but six identical lines
is also fine.

The hook receives the same `%*` the launcher receives — typically a
single quoted absolute path (`"C:\dev\dcl-website-…"`). If the
launcher is invoked without args (workspace re-open), the hook
no-ops.

### `repo-update.cmd` / `repo-update.sh` — the engine

Lives in `shells/windows/lib/` and `shells/bash/lib/`, parallel to
`repo-setup`. Recommendation: **cmd version is a thin wrapper that
delegates to bash for the actual file work**, because:

- File comparison / merge / JSON manipulation is much cleaner in
  bash than in cmd.
- The bash environment is already set up by the env script that ran
  before the hook (see `repo-setup.sh` for the pattern).
- Single source of truth for the update logic.

Behavior on each invocation:

1. **No-op if target is `dev-shell` itself.** Avoid recursion.
2. **No-op if target has no `.git`.** Don't apply to non-repos.
3. **No-op if launcher arg is empty** (workspace re-open with no
   folder switch).
4. **Read or create `.wcde-repo` cache file** at target root (see
   schema below). If missing, run detection and write it.
5. **For each capability in cache**, apply the matching bundle
   from `templates/<capability>/`:
   - Files without `.fragment` suffix → whole-file copy, diffing
     first to skip no-op writes.
   - Files with `.fragment` suffix → sectioned merge into a managed
     block of the target file (between `# wcde-managed: begin` and
     `# wcde-managed: end` markers).
6. **Respect `overrides:` list** in `.wcde-repo` — if a file is
   listed there, skip it with a printed warning so the user can
   reconcile by hand.
7. **Write updated `.wcde-repo`** with current wcde commit SHA and
   timestamp.
8. **Print a summary** of which files were updated, skipped (no
   change), or warned (in overrides list).
9. **Exit 0** unless something catastrophic happened. Never block
   VSCode from launching.

### `.wcde-repo` cache file (committed in each target repo)

```yaml
# .wcde-repo — managed by wcde repo-update; committed to git
wcde-version: <commit SHA of wcde at last sync>
last-synced: 2026-05-28T12:34:56Z
capabilities:
  - spell-check          # baseline; every repo
  - editor-config        # baseline
  - python-code
  - latex-paper
  - audit-rows
  - quarto-site
  - citeable-artifact
  - program-notes
overrides:
  # files repo-update will NOT touch — this repo has diverged
  - .vscode/settings.json
  - .gitignore
```

Three roles in one file: version anchor, capability declaration,
opt-out list. Committed so it travels with the repo, collaborators
can read it, and the next update knows the state.

### Capability bundles under `templates/`

```
templates/
├── _baseline/                          # always applied
│   ├── cspell.json
│   ├── .editorconfig
│   └── .vscode-settings/
│       ├── spell-check.fragment.json   # LTeX dictionary + Spell Right docTypes
│       └── files-eol.fragment.json
├── python-code/
│   ├── .gitignore.fragment             # *.pyc, __pycache__, .venv-*, etc.
│   ├── .pre-commit-config.yaml
│   └── .github-workflows/python-tests.yml
├── latex-paper/
│   ├── .gitignore.fragment             # *.aux, *.log, *.synctex.gz, etc.
│   ├── .github-workflows/latex-build.yml
│   └── spell-extras-latex.txt          # extra wordlist for math/Greek
├── quarto-site/
│   ├── .gitignore.fragment             # _site, .quarto, site_libs
│   └── .github-workflows/quarto-publish.yml
├── audit-rows/
│   └── notes/audit-rows-template.md
├── citeable-artifact/
│   └── CITATION.cff.fragment
└── program-notes/
    ├── release_playbooks.md            # propagated from dcl-website's notes/
    ├── content_voice_and_audience.md
    └── seo_next_steps.md
```

Files with `.fragment` suffix are **sectioned** — merged into a
managed block of an existing file. Files without are **whole-file
copies**. The convention is determined by extension at template
authoring time; the engine reads it.

`spell-check.fragment.json` lives under `.vscode-settings/` (not
`.vscode/`) so it isn't confused with wcde's own `.vscode/` config.

### Detection rules — data, not code

`templates/detection.yml`:

```yaml
python-code:
  any-of: [pyproject.toml, setup.py, "**/*.py"]
latex-paper:
  any-of: ["*.tex", "paper/*.tex"]
audit-rows:
  any-of:
    - "**/audit-rows.md"
    - { in: "*.tex", contains: "audit-row" }
quarto-site:
  any-of: [_quarto.yml]
citeable-artifact:
  any-of: [CITATION.cff]
github-pages:
  any-of: [".github/workflows/publish.yml", ".github/workflows/pages.yml"]
program-notes:
  # opt-in only; not auto-detected. Repos with notes/ directories opt in via
  # explicit .wcde-repo edit. Avoids cluttering pure-code repos.
  detect: false
```

Detection runs once when `.wcde-repo` doesn't exist. After that the
file is the source of truth; capabilities can be edited by hand.

Adding a new capability later is "add `templates/<name>/` + add
detection rule" — no engine changes.

---

## Six design questions, with resolutions

These came up in the design session. Recording resolutions so the
implementation session doesn't re-derive.

1. **Source of truth location for shared files.** → Explicit
   `templates/` directory, not "wcde's own dotfiles." Cleaner
   separation between wcde-as-tool and wcde-as-source.
2. **What's in scope for distribution.** → Spell-check, editor
   config, gitignore patterns, render configs, CI workflow
   templates, citation.cff, *and the program-shared notes* (see
   *Seed material* below).
3. **Sectioned vs. whole-file overwrite.** → Decided by file
   extension at template-authoring time. `.fragment` means
   sectioned merge into a managed block; no suffix means
   whole-file copy.
4. **Conflict policy when target has hand-edits.** → Three
   policies stacked: (a) sectioned fragments only touch the managed
   block, so most hand-edits coexist; (b) explicit `overrides:`
   list in `.wcde-repo` opts a file out entirely with a printed
   warning each run; (c) for whole-file copies with no override
   set, diff first and skip if unchanged.
5. **Versioning.** → `.wcde-repo` records the wcde commit SHA at
   last sync. Makes "why is paper-03 different from paper-05"
   debuggable.
6. **Idempotency.** → Read template, read target, diff, write only
   on diff. Two consecutive runs are a no-op the second time.

---

## Seed material from this repo

Three notes that are program-shared, not website-specific. The
website hosted them initially because that's where the design
discussion happened, but they describe series-wide conventions and
should propagate via the `program-notes` capability:

- [`notes/release_playbooks.md`](release_playbooks.md) — paper /
  code / data release playbooks plus landing-page publish playbook,
  cross-cutting conventions (title length, description length, DOI
  policy, etc.).
- [`notes/content_voice_and_audience.md`](content_voice_and_audience.md)
  — editorial register for the series. Sober tone, audit-row
  awareness, what goes where (news vs. essay vs. paper card).
- [`notes/seo_next_steps.md`](seo_next_steps.md) — organic-search
  strategy, the Zenodo-canonical decision for Google Scholar with
  manual-placeholder workaround, preprint situation (arXiv blocked,
  PhilSci-Archive for the philosophical-foundations paper only).

The wcde-session agent should read all three, decide whether each
is *fully* program-shared or has website-specific sections, and
either copy verbatim into `templates/program-notes/` or extract the
shared parts.

There's also a smaller seed: this repo's [`cspell.json`](../cspell.json)
and the LTeX/Spell-Right sections of [`.vscode/settings.json`](../.vscode/settings.json#L25-L64)
are the **first proof of the spell-check capability bundle**. Copy
these verbatim into `templates/_baseline/`.

---

## Suggested first PR in `dev-shell`

Smallest-valuable-step. Land this, prove the loop works, then
iterate.

1. **Add `templates/_baseline/cspell.json`** — verbatim copy of
   this repo's `cspell.json`.
2. **Add `templates/_baseline/.vscode-settings/spell-check.fragment.json`**
   — the LTeX dictionary block + Spell Right documentTypes block
   from this repo's `.vscode/settings.json`.
3. **Add `shells/bash/lib/repo-update.sh`** at first scope:
   - Read `.wcde-repo` if present, write it if absent.
   - Apply *only* `templates/_baseline/` files.
   - No detection logic yet — `.wcde-repo.capabilities` starts as
     just `[spell-check, editor-config]` for every repo.
   - Print a summary; exit 0 always.
4. **Add `shells/windows/lib/repo-update.cmd`** — thin cmd wrapper
   that calls the bash version under the current MSYSTEM
   environment.
5. **Modify ONE launcher** — `vscode-ucrt64.cmd` — to add the hook
   line. Leave the other five alone for now.
6. **Test on this DCL website repo.** Run `vscode-ucrt64.cmd
   "C:\dev\dcl-website-geometry-induced-physics-org"`. The local
   cspell.json should match the wcde version; the LTeX/Spell Right
   sections of settings.json should be replaced from the fragment.
   A `.wcde-repo` should appear. Re-running should be a no-op.
7. **Once that works**: roll the launcher line out to the other
   five `vscode-*.cmd` files.

This delivers the spell-check distribution that was the original
itch, while exercising every piece of the architecture (cache file,
fragment merging, whole-file copy, idempotency, launcher hook) at
small scale.

**Subsequent PRs** in rough order:

- Detection rules (`templates/detection.yml`) + the detection logic
  in `repo-update.sh`.
- Capability bundles: `python-code`, `latex-paper`, `quarto-site`.
- `program-notes` capability — propagate the three notes from the
  website repo.
- `audit-rows`, `citeable-artifact` capabilities.
- The `.gitignore`-patching follow-up from `dev-shell`'s own
  HANDOFF.md, now framed as part of the `_baseline` bundle.

---

## Open questions for the wcde session

Items that need decisions but weren't reached in this session:

1. **Should `repo-update.cmd` block the launcher on failure?**
   Recommendation in this design is *never block* (exit 0 always),
   but if the user wants warnings to be hard errors, the engine
   needs a `--strict` mode. Decide based on whether failing to
   sync is operationally tolerable.
2. **Cross-platform.** This design assumes Windows + msys2 (the
   `dev-shell` audience). If collaborators on Mac/Linux are
   expected to clone these repos, they'd need a non-launcher way
   to invoke repo-update (e.g., a `make sync` target, or a git
   hook). Not urgent given the current single-author program but
   worth flagging.
3. **Versioning model for `dev-shell` itself.** Currently the SHA
   in `.wcde-repo` is whatever wcde commit was current at sync.
   Should `dev-shell` be tagged (e.g., v0.1.0) and `.wcde-repo`
   record tags instead of SHAs? Tags are more human-readable and
   imply intentional release points. SHAs are unambiguous and need
   no release ceremony. Start with SHAs; tag later if useful.
4. **The HANDOFF.md note about relocatability.** dev-shell's
   `notes/HANDOFF.md` is firm that the repo must not assume it
   lives at `C:\dev-shell`. New code must use `%~dp0`-relative
   paths (cmd) and script-location-relative resolution (bash).
   The `vscode-*.cmd` files already do this correctly with
   `"%~dp0env\…"` and `"%~dp0..\lib\…"`. Mirror the pattern.

---

## What this session deliberately did NOT do

For clarity to the next session:

- Did not write any wcde code or modify any wcde file.
- Did not commit anything in wcde.
- Did not move any notes from this website repo to wcde.
- Did not start the per-repo `.wcde-repo` cache file in this repo
  or any other.

All of that is the implementation session's work.

---

## Read-list for entering the wcde session

In order, before writing any code:

1. **`c:\dev\wcde\README.md`** — purpose, scope, current state.
2. **`c:\dev\wcde\notes\HANDOFF.md`** — the project's design log;
   note in particular the *Known Follow-ups* and *Note For Future
   Sessions* sections.
3. **`c:\dev\wcde\catalog.md`** — generated index of what exists.
4. **One of the launchers** —
   `c:\dev\wcde\shells\windows\cmd\vscode-ucrt64.cmd`. 12 lines.
   Gives you the integration point in concrete form.
5. **`c:\dev\wcde\shells\bash\lib\repo-setup.sh`** — the idiom you
   should mirror for `repo-update.sh`.
6. **`c:\dev\wcde\shells\bash\tools\setup-vscode.sh`** — the file
   that currently writes settings.json, which this design either
   absorbs into repo-update or evolves to call into the capability
   assembler.
7. **`c:\dev\wcde\templates\`** — what's there currently, so you
   know what to add vs. preserve.
8. **This document.**
9. **The three notes named in *Seed material* above**, in this
   repo. They are the program-shared conventions that the new
   `program-notes` capability bundle is meant to propagate.

Then start with the suggested first PR.
