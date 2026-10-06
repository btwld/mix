# Callable pressable builders: review and validation

- PR: [#1088](https://github.com/btwld/mix/pull/1088)
- Reviewed implementation: `cc88dcff9a583b539a6c99803c1d02c3e577b1f9`
- Base: `40898888f63a01df9f8dadfb2ed325d0eed81926`
- Plan: [callable pressable builders](2026-10-03-callable-pressable-builders.md)

## Review outcome

Independent review found no remaining correctness or compatibility blockers in
the API, tests, examples, documentation, skill updates or 31-site migration audit.
Review findings were resolved before delivery:

- Corrected missing generated styler hooks and preserved the distinct Icon
  `semanticLabel` and outer Pressable `semanticsLabel` arguments.
- Added full forwarding/default/content coverage for all eight surfaces,
  cancellation/feedback tests, independent reuse, semantic action dispatch,
  representative builder keyboard coverage and deferred token/animation tests.
- Replaced name-only contract checks with resolved analyzer types/defaults and
  exact diagnostics for terminal-builder misuse, with positive compatibility cases.
- Corrected documentation that implied ordinary GridBoxStyler was callable and
  removed nested callback-less pressables from the demonstration.
- Added a minimal web entry point and reproducible run/build instructions to
  the local example; verified its web build.

The private mixins' narrowly documented unused-generic exceptions are required
because the existing generation hook always supplies the owning styler type.
The generator implementation was not changed.

## Scope audit

The implementation revision changed 38 files. Of its 1,627 added lines, 933
(57%) were tests. The current plan/review records and repository instruction
are a subsequent documentation-only addition requested for PR traceability.

Existing Pressable/PressableBox implementations, the interaction detector,
animation engine, generator implementation, dependency versions and CI
configuration are unchanged. Generated changes only apply the seven mixins.
All Snack runtime code is unchanged; the two hosted teaching examples gained
seven comment lines total. The new runnable example uses the local Mix source.

The [migration audit](../guides/pressable-builders-release-audit.md) covers all
22 PressableBox and 9 Pressable call sites, including hit areas, nested controls,
keyboard access and checkbox/switch semantics. Hosted migration and the separate
website update remain explicit release follow-ups.

Installed skill updates were limited to six intended Mix files and two
microinteraction files per copy, preserving unrelated pre-existing differences.
Those installed copies are local artifacts; the canonical Mix guidance is
committed under `skills/mix`.

## Validation observed

| Check | Result |
| --- | --- |
| `melos run gen:build` and generated exports | Passed |
| `melos run ci` | Passed: Mix 3,027; generator 383; all dependent suites |
| `melos run format:check` | Passed |
| Resolved signature/default and exact terminal-error contracts | 3 tests passed |
| Generation from an annotated private extra mixin | Passed |
| Pressable and interaction-detector focused run | 103 tests passed |
| Final deferred-resolution/lifecycle test file | 8 tests passed |
| Published-dependency showcase | Analysis clean; 129 tests passed; web build passed |
| Local source-dependent example | Analysis and web build passed |
| Canonical/installed Mix and microinteraction skill validation | All 5 directories passed |
| `melos run analyze` | Dart/schema stages passed; DCM baseline findings below |

The focused run preceded the final additional deferred-resolution test; the
final full CI includes that test. Existing Dart informational notices remain.

## Unchanged DCM findings

Full analysis remains non-green because these four findings also exist in the
unchanged base files:

- `style_animation_builder.dart:81`: member ordering.
- `style_animation_builder.dart:90`: wildcard case with sealed classes.
- `decoration_style_mixin.dart:273`: named argument ordering.
- `decoration_style_mixin.dart:359`: named argument ordering.

New findings introduced while implementing the builders were fixed. These four
baseline findings were neither hidden nor treated as regressions.
