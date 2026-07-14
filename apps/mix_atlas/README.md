# Mix Atlas standalone app

Mix Atlas is a macOS developer-preview application for reading validated design
system captures. It opens committed data from a local folder or public GitHub
repository and never imports, compiles, reflects over, or executes the producer
design system.

The phased implementation receipt and verification gates are recorded in
[`DELIVERY_PLAN.md`](DELIVERY_PLAN.md).

## Product flow

The app preserves one immutable review context while moving through:

1. **Catalog** — search captured components and select an exact recipe, state,
   and theme cell.
2. **Changes** — review added, removed, and modified declared evidence between
   `main` and a current revision.
3. **Compare** — view bounded baseline/current reconstructions side by side and
   select a changed property.
4. **Inspect** — trace declared values, selectors, token references, captured
   theme values, diagnostics, source files, and JSON pointers.
5. **Token Usage** — filter every exact captured reference by component,
   selector, theme, slot, property, and Direct/Alias classification.

Changes are never labeled regressions or predicted visual impact. Compare does
not treat a portable reconstruction as a screenshot oracle.

## Opening a capture

### Local folder

Choose the directory containing `capture.json`. This is the fastest producer
feedback loop and works before artifacts are committed. The reader rejects
symlink escapes, unsafe paths, unindexed files, hash/byte mismatches, malformed
JSON, unsupported schemas, and invalid protocol documents.

### Public GitHub repository

Enter `owner/repository` or a GitHub repository URL. Baseline and current
revisions can be selected independently: the baseline defaults to `main`, and
either revision may be a branch, tag, or full SHA. The current revision also
accepts a PR number or PR URL. Atlas resolves mutable refs once and reads all
files from the resulting immutable commit SHA. Fork PRs read the capture from
the PR head repository and SHA.

If the selected current revision has a valid capture but the default `main`
baseline does not, Atlas keeps the current capture open. Catalog and Inspect
remain available, a `Baseline unavailable` receipt explains the limitation,
and Changes and Compare stay disabled until a compatible baseline loads.

Open public PRs are cached in memory. Stale responses from a previously entered
repository cannot replace the latest list. Atlas shows the API requests
remaining and reset time whenever GitHub provides them. Authentication and
private repositories are out of scope for this preview. After a rate-limit
response, Atlas shows the failure and does not retry until the reset time.

The default sample fields point to:

```text
repository: tilucasoli/hero_ui
baseline:   main
current:    #21
manifest:   atlas/hero_ui/capture.json
```

The repository is `tilucasoli/hero_ui`. Draft PR #21 is sourced from the
`leoafarias/hero_ui` fork and contains the generated Hero Button capture.
Upstream `main` does not have `atlas/hero_ui/capture.json` yet, so this sample
intentionally opens in current-only mode: Catalog and Inspect are available,
while Changes and Compare remain disabled until the first baseline is merged.
Returning to source selection keeps the last entered values. A load can also
be cancelled from the header, and choosing a listed PR automatically selects
that PR's actual base branch.

Release builds can choose a different initial source without editing Dart by
passing `MIX_ATLAS_DEFAULT_REPOSITORY`, `MIX_ATLAS_DEFAULT_BASELINE_REF`,
`MIX_ATLAS_DEFAULT_CURRENT_REF`, and `MIX_ATLAS_DEFAULT_MANIFEST` through
Flutter's `--dart-define` option.

## Evidence levels

- **Declared**: protocol-backed data authored by the producer and its bounded
  selectors/merge sources.
- **Captured theme value**: the theme value stored in the capture for a token.
- **Rendered oracle**: a producer-generated contact sheet and metadata file.
- **Runtime**: always shown as `Not captured` in this preview.

Atlas does not infer runtime winners, resolved widget styles, accessibility
results, source locations, or visual impact. An unsupported slot remains visible
with its structured diagnostic. Fortal's spinner is intentionally unsupported;
the app never substitutes a made-up primitive.

## Producer setup

Producer repositories keep component-specific projection adapters next to the
design system. Shared envelope, hashing, stale-file removal, and drift checking
come from `mix_atlas_capture`:

```dart
import 'package:mix_atlas_capture/producer.dart';
```

The producer stages canonical catalog, theme, style, component, diagnostic, and
oracle files, then calls `AtlasCapturePackager.build`. CI calls
`AtlasCapturePackager.check`; it reports exact stale paths and never rewrites or
commits artifacts. See
[`packages/mix_atlas_capture/README.md`](../../packages/mix_atlas_capture/README.md)
for the generic CLI contract.

The Fortal reference workflow is:

```sh
melos run atlas:fortal
melos run atlas:fortal:check
```

Its capture contains 70 indexed artifacts plus `capture.json`. The 200
non-loading Button cells have exact producer-side screenshot comparisons; the
40 loading cells carry an explicit unsupported spinner diagnostic.

## Develop and verify

From this directory:

```sh
fvm flutter pub get
fvm dart analyze .
fvm flutter test
fvm flutter build macos --release --no-tree-shake-icons
```

Canonical desktop goldens live in `test/goldens`. Regenerate them only after a
deliberate visual review:

```sh
fvm flutter test test/golden_test.dart --update-goldens
```

After a producer branch has been pushed, validate the real public-GitHub path
by mutable ref and immutable commit SHA. Repository and manifest default to the
Fortal reference capture, but can be overridden for any public producer. For
the Hero UI fork PR:

```sh
MIX_ATLAS_LIVE_REPOSITORY=tilucasoli/hero_ui \
MIX_ATLAS_LIVE_REF='#21' \
MIX_ATLAS_LIVE_SHA=a1cf6b3377db0301cce21e399c1815698d47bd67 \
MIX_ATLAS_LIVE_MANIFEST=atlas/hero_ui/capture.json \
MIX_ATLAS_LIVE_MISSING_BASELINE_REF=main \
fvm flutter test test/live_github_test.dart
```

For a same-repository branch, omit `MIX_ATLAS_LIVE_REPOSITORY` and
`MIX_ATLAS_LIVE_MANIFEST` when using the Fortal defaults. Before the first
producer capture reaches its baseline branch, set
`MIX_ATLAS_LIVE_MISSING_BASELINE_REF` as above. That also proves the current
capture remains usable while Changes and Compare are unavailable.

The live test is deliberately opt-in so ordinary CI remains deterministic and
does not consume unauthenticated GitHub API quota.

The release build is an unsigned developer preview. There is no installer,
signing, notarization, persistent cache, approval workflow, or deep-link
contract in this phase.
