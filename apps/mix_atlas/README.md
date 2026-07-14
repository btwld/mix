# Mix Atlas standalone app

Mix Atlas is a macOS developer-preview application for reading validated design
system captures. It opens committed data from a local folder or public GitHub
repository and never imports, compiles, reflects over, or executes the producer
design system.

The phased implementation receipt and verification gates are recorded in
[`DELIVERY_PLAN.md`](DELIVERY_PLAN.md).

## Product flow

The app preserves one immutable review context while moving through:

1. **Catalog** — search captured components and open either an exact portable
   recipe/state/theme cell or a validated rendered contact sheet.
2. **Changes** — review added, removed, and modified declared evidence between
   `main` and a current revision.
3. **Compare** — view bounded baseline/current reconstructions side by side and
   select a changed property.
4. **Inspect** — for components with portable documents, trace declared values,
   selectors, token references, captured theme values, diagnostics, source
   files, and JSON pointers.
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
repository: btwld/remix
baseline:   main
current:    #68
manifest:   atlas/fortal/capture.json
```

`btwld/remix` `main` contains the committed Button baseline. Draft PR #68
expands the Fortal capture to all 21 component families, so the sample opens as
a real baseline/current comparison. Returning to source selection keeps the
last entered values. A load can also be cancelled from the header, and choosing
a listed PR automatically selects that PR's actual base branch.

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
results, source locations, or visual impact. An unsupported portable slot
remains visible with its structured diagnostic. A catalog component without a
portable document is labeled `Rendered evidence`; Atlas displays its verified
contact sheet and does not invent recipes, states, slots, or properties.

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

Its capture contains 21 component families, 42 light/dark contact sheets, and
150 indexed artifacts plus `capture.json`. Button retains its full portable
recipe/state/slot evidence: 200 non-loading cells have exact producer-side
screenshot comparisons, while 40 loading cells carry an explicit unsupported
spinner diagnostic. The other 20 families are deliberately labeled
rendered-only until their portable projection adapters exist.

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

Validate a freshly generated producer bundle through the same local loading
path used by the app:

```sh
MIX_ATLAS_LIVE_LOCAL_ROOT=/path/to/remix \
fvm flutter test test/live_local_capture_test.dart
```

After a producer branch has been pushed, validate the real public-GitHub path
by mutable ref and immutable commit SHA. Repository and manifest default to the
Fortal reference capture, but can be overridden for any public producer. For
the Fortal demo PR:

```sh
MIX_ATLAS_LIVE_REPOSITORY=btwld/remix \
MIX_ATLAS_LIVE_REF='#68' \
MIX_ATLAS_LIVE_SHA=<full-pr-head-sha> \
MIX_ATLAS_LIVE_MANIFEST=atlas/fortal/capture.json \
fvm flutter test test/live_github_test.dart
```

For a same-repository branch, omit `MIX_ATLAS_LIVE_REPOSITORY` and
`MIX_ATLAS_LIVE_MANIFEST` when using the Fortal defaults. To exercise the
current-only fallback separately, set `MIX_ATLAS_LIVE_MISSING_BASELINE_REF` to
a revision that does not contain the selected manifest.

The live test is deliberately opt-in so ordinary CI remains deterministic and
does not consume unauthenticated GitHub API quota.

The release build is an unsigned developer preview. There is no installer,
signing, notarization, persistent cache, approval workflow, or deep-link
contract in this phase.
