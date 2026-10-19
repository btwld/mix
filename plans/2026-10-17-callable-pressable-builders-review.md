# Callable pressable builders: review and simplification

- PR: [#1088](https://github.com/btwld/mix/pull/1088)
- Input revision: `3a2557d0aad42c5ed234598e39765ae99e2ead49`
- PR base: `40898888f63a01df9f8dadfb2ed325d0eed81926`
- Scope: complete PR diff, surrounding interaction/style resolution code,
  examples, documentation, canonical and installed skill guidance.
- The cleanup and this record are committed together. The
  [October 3 review](2026-10-03-callable-pressable-builders-review.md) retains
  its original implementation snapshot and validation results.

The later [October 19 CI follow-up](2026-10-19-callable-pressable-ci-followup.md)
records an analyzer compatibility error found when GitHub tested this revision
merged with newer `main`. The validation below describes the local October 17
dependency resolution.

## Findings and changes

- **P2 — duplicated accessible label in the new example**
  (`packages/mix/example/lib/main.dart:31` at the input revision). Save supplied both
  `semanticsLabel: 'Save'` and visible child text. A Flutter semantics probe of
  the actual example reproduced `Save\nSave`. Removed the redundant label from
  the example, README and both local microinteraction skill copies; the same
  probe then observed exactly `Save`. The pre-existing hosted core example has
  similar repetition, now explicitly recorded in the release migration audit.
- **P3 — redundant tests and unused generic suppressions.** Removed four
  overlapping tests from `box_styler_pressable_test.dart` and
  `callable_pressable_builders_test.dart`. Shared all-styler parameter, native-content,
  type/style identity and animated-resolution tests retain their assertions;
  the live reuse test now verifies separate callbacks and widget instances as
  well as independent interaction state. Constraining the private mixins on
  `MixStyler<ST, Spec>` uses the existing owner type and removes all seven
  unused-generic suppressions. Public method documentation now lives on
  `pressable()` itself.
- Completed the README's interactive layout, Icon, Image and builder-reuse
  examples. Explained Icon's two label parameters, visible-text labels and hit
  areas; clarified that either API must preserve nested controls' focus and
  semantics. Corrected two wrapper descriptions in the 31-site migration map.
- Added the example's missing `flutter_lints` development dependency after its
  inherited lint configuration produced a standalone formatter resolution
  warning. Runtime dependencies are unchanged.

No remaining correctness, parameter-completeness or compatibility findings were
identified. Independent source review agreed that the simplifications preserve
behavior and meaningful coverage, and checked the complete documentation/skills
and 31-site inventory audit.

The five callable builder classes and explicit parameter forwarding remain:
each class owns a native content signature and the terminal construction
boundary. An options wrapper or generic dispatcher would add another public
concept without simplifying this contract. Pressable, PressableBox, the
interaction detector and generator implementation remain unchanged.

## Fresh validation

| Check | Result |
| --- | --- |
| `melos run gen:build` | Passed; checked-in generated output unchanged |
| `melos run ci` | Passed: Mix 3,023, generator 383, all dependent suites, including 129 showcase tests |
| Focused Pressable/detector and example semantics check | 101 checks passed; includes one temporary probe of the actual example, preserved locally rather than added to the suite |
| Resolved signature/default parity, terminal diagnostics and generation hook | Passed in the full generator suite |
| `melos run format:check` and `git diff --check` | Passed |
| Standalone example `flutter analyze` and `flutter build web` | Passed |
| Canonical/installed Mix and microinteraction skill validation | All five directories passed |
| `melos run analyze` | Schema and Dart stages passed; four unchanged DCM findings below |

The first analysis attempt ran before local package resolution existed for
two unchanged packages. `melos bootstrap` restored it; the full rerun passed
Dart analysis without source changes to those packages. Existing informational
notices remain.

Full analysis remains non-green because DCM reports the same four findings as
the October 3 baseline, in files unchanged from the PR base:

- `style_animation_builder.dart:81`: member ordering.
- `style_animation_builder.dart:90`: wildcard case with a sealed class.
- `decoration_style_mixin.dart:273,359`: named argument ordering.

No new DCM findings remain. The four-test reduction from 3,027 to 3,023 core tests
is the deliberate removal of duplicate coverage described above.

## Release boundaries

The hosted showcase still resolves published Mix in its dedicated CI job.
Its 31 runtime constructors and the separate website migration remain release
follow-ups in the [migration audit](../guides/pressable-builders-release-audit.md).
The new source-dependent example demonstrates the unreleased API now.

Installed skill edits were narrow replacements with backups, preserving
unrelated local content. The canonical Mix guidance is committed under
`skills/mix`; the original checkout's microinteraction skill remains local.
