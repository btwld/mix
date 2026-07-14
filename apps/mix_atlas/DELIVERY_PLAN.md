# Mix Atlas standalone app delivery plan

This document is the durable implementation receipt for the seven-phase Mix
Atlas standalone-app plan. The product contract and operating guide live in
[`README.md`](README.md).

## Outcome

Mix Atlas is an unsigned macOS developer preview that reads validated captures
from a local folder or public GitHub repository. It never compiles, imports, or
executes the producer design system.

The complete review flow is:

```text
Open capture
  -> Catalog
  -> Changes
  -> Compare
  -> Inspect
  -> Token Usage
```

Every UI value is backed by a capture file and, where applicable, a canonical
JSON pointer. Declared evidence is never presented as a runtime winner, visual
regression, predicted impact, approval, or release decision.

## Phase receipt

### Phase 1 — Capture foundation

- `mix_atlas_capture` owns strict loading, capture models, portable rendering,
  source contracts, and producer packaging.
- Capture v1 and v2 remain readable; producers write canonical v2 plus an
  optional component-v1 portable-document subset.
- Safe paths, collection limits, byte limits, strict fields, SHA-256 hashes,
  and protocol validation remain mandatory.
- Baseline and changed Button fixtures cover the standalone reader.

### Phase 2 — Protocol inspection and diffable evidence

- `mix_protocol` exposes style and theme document inspection.
- Evidence records retain selector, ordered merge source, literal or token
  value, capture file, and canonical JSON pointer.
- Theme inspection retains direct/alias declarations, alias chains, and the
  captured theme value.
- Canonical semantic comparison reports additions, removals, and changes
  without inventing an effective runtime winner.

### Phase 3 — Producer kit and Fortal workflow

- `AtlasCapturePackager.build` writes sorted canonical files and removes stale
  generated files.
- `AtlasCapturePackager.check` reports exact drift without rewriting files.
- The Fortal reference bundle contains 21 catalog components and 150 indexed
  artifacts plus `capture.json`.
- Its 200 supported cells remain pixel-exact and its 40 loading cells remain
  explicitly unsupported.
- Forty-two light/dark contact sheets keep all 21 component families
  reviewable; the 20 families without portable adapters are explicitly marked
  rendered-only.

The Remix producer draft PR expands the committed Button baseline on `main` to
all 21 Fortal component families, so the public sample exercises a real
baseline/current comparison.

### Phase 4 — Sources, session, and navigation

- Local folders and public GitHub repositories are supported.
- Repository URLs, branches, tags, full SHAs, PR numbers, and PR URLs resolve to
  immutable commit SHAs before child files are read.
- `main` is the default baseline; fork PRs read from their head repository.
- The source form can override the baseline with another branch or immutable
  SHA, and PR listing exposes remaining/reset API evidence.
- Stale capture and PR-list responses cannot overwrite a newer source request.
- A valid current capture remains reviewable when `main` has no capture yet;
  Catalog and Inspect stay available while Changes and Compare are guarded.
- PR and rate-limit responses are cached in memory.
- A typed immutable review context preserves the exact selection while routing.

### Phase 5 — Catalog and Inspect

- Catalog shows every captured component. Components with portable documents
  expose their recipe/state/theme matrix; rendered-only components expose their
  hash-verified light/dark contact sheets without fabricated portable data.
- Inspect shows the portable reconstruction, anatomy slots, declared
  properties, selectors, token references, captured theme values, diagnostics,
  source files, and JSON pointers when the producer supplied that evidence.
- Runtime evidence is always labeled `Not captured`.
- The Fortal spinner remains an explicit unsupported slot.

### Phase 6 — Changes, Compare, and Token Usage

- Changes aggregates declared and captured evidence only.
- Compare keeps baseline/current reconstruction and contact-sheet oracle
  availability separate.
- Token Usage counts exact references and identifies Direct and Alias in text.
- Navigation preserves component, recipe, state, theme, slot, property, and
  token context.

### Phase 7 — Hardening and developer preview

- Workspace-shaped loading skeletons, retry, offline, missing-capture,
  malformed, incompatible,
  rate-limited, partial, unsupported, and no-change states are represented.
- Copy utilities cover property details, token usages, and change summaries.
- Desktop widget tests and 1440 x 900 goldens cover every product screen.
- CI tests the app, verifies goldens, builds the unsigned macOS `.app`, and
  uploads it as a workflow artifact.

## Figma receipt

The editable product flow is maintained in the
[validated Mix Atlas section](https://www.figma.com/design/MNn6Yt0CIBlqjD1ztJJiQm/Fortal-Sheets-Viewer-%E2%80%94-Desktop-Audit?node-id=128-42).
Section `128:42` contains eight capture-backed scenes: Open Capture, Open PRs
loaded, Catalog, Changes, Compare, Inspect, Token Usage, and Catalog with a
missing `main` baseline. The Open scenes cover independent baseline selection
and visible GitHub quota/reset evidence. The final Catalog scene keeps Inspect
available and represents Compare as disabled, matching application behavior.

## Verification gates

Run the repository gates from the workspace root:

```sh
fvm dart pub get
melos run gen:build
melos run ci
melos run analyze
melos run format:check

(cd packages/mix_protocol && fvm flutter test)
(cd packages/mix_atlas && fvm flutter test)
(cd packages/mix_atlas_capture && fvm flutter test)
(cd apps/mix_atlas && fvm flutter test)
(cd apps/mix_atlas && fvm flutter build macos --release --no-tree-shake-icons)
```

Once the producer capture exists on a public branch, run the opt-in live source
gate with that branch and its immutable head SHA:

```sh
MIX_ATLAS_LIVE_REF='#68' \
MIX_ATLAS_LIVE_SHA=<full-commit-sha> \
fvm flutter test test/live_github_test.dart
```

Set `MIX_ATLAS_LIVE_MISSING_BASELINE_REF` to a revision without the manifest to
exercise the current-only review state against the real network source.

Run producer verification from the Remix repository with its pinned Flutter
toolchain:

```sh
fvm dart pub global run melos run atlas:fortal:check
fvm dart pub global run melos run ci
```

The Remix spike's aggregate `ci` command can only pass from a clean producer
worktree because its `generate:check` gate intentionally rejects uncommitted
generated or producer-source changes. The independently runnable producer
check, analyzer, generation, and Flutter test gates have been validated.

## Release boundaries

- Public repositories only; no GitHub login or private repository access.
- Captures must be committed; workflow-archive download is out of scope.
- The preview is unsigned and has no installer, signing, or notarization.
- No audit, approval, assignment, request-fix, release-gate, source-navigation,
  runtime observer, accessibility analysis, or predicted-impact workflow.
- Integrity checks and unsupported evidence are never weakened or hidden.
