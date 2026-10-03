# Callable pressable builders across Mix

- Status: implemented and reviewed.
- PR: [#1088](https://github.com/btwld/mix/pull/1088)
- Implementation revision: `cc88dcff9a583b539a6c99803c1d02c3e577b1f9`
- Branch: `feat/boxstyler-pressable` → `main`

This is the approved plan for the revision of PR #1088. It supersedes the
initial, unreleased BoxStyler extension implementation.

## Goal

Make **compose → `.pressable()` → call** the standard convention for interactive
surfaces owned by Mix stylers:

```dart
final button = BoxStyler()
    .padding(.all(16))
    .onPressed(.scale(0.96))
    .pressable();
button(onPress: save, child: const Text('Save'));

final heading = TextStyler().fontSize(18).pressable();
heading('Settings', onPress: openSettings);

final row = FlexBoxStyler().direction(.horizontal).pressable();
row(onPress: selectItem, children: [icon, label]);
```

Support Box, Text, Icon, Image, FlexBox, StackBox, WrapBox and GridBox. Every
builder call returns a Pressable containing the corresponding styled widget.

## API decisions

- Add parameterless instance methods through private typed mixins and the
  existing `extraStylerMixins` hook for the seven generated stylers. Add the
  method directly to the handwritten GridBoxStyler.
- Use ordinary immutable callable classes: PressableBoxBuilder,
  PressableTextBuilder, PressableIconBuilder, PressableImageBuilder, and one
  PressableChildrenBuilder shared by the four layouts. Use no extensions or
  extension types.
- Capture the composed style without resolving it. Construct the styled widget
  per invocation so tokens, variants and animation resolve beneath Pressable.
- Preserve native content parameters and defaults: positional text, optional
  Box child, layout children, and existing Icon/Image arguments. Expose every
  other Pressable constructor option with its existing type and default.
- Put the key on the outer Pressable only. Builders expose no style override,
  styling methods, or second `.pressable()`.
- Supply callbacks, focus nodes and controllers per call. Builder reuse must not
  share internal interaction state.
- Preserve released Pressable/PressableBox constructors and ordinary styler
  calls. Do not add pressable methods to layout-only FlexStyler, StackStyler or
  WrapStyler. Ordinary GridBox construction remains explicit.
- Keep `@MixWidget` factories returning styles; callable builder generation is
  outside this revision.

## Implementation and acceptance checklist

- [x] Audit Pressable and its interaction detector before implementation. Fix
      only reproducible defects required for this API; preserve defaults.
- [x] Implement all eight styler methods and five builder classes, export them,
      and regenerate sources without unrelated generated changes.
- [x] Verify pointer activation/cancellation, long press, hover, feedback and
      disabled behavior through focused and existing regression tests.
- [x] Verify keyboard activation/repeats, focus loss, link Space behavior,
      custom actions and focused descendants.
- [x] Verify labels, roles, exclusions, and external checkbox/switch semantics,
      including semantic action dispatch.
- [x] Verify internal/external controller ownership, replacement/disposal,
      independent reuse, outer keys, all target types and style identity.
- [x] Verify context-dependent tokens, animated variants and styled descendants
      resolve inside the surrounding Pressable.
- [x] Add analyzer-based constructor contracts comparing resolved types,
      named/required flags and evaluated defaults. Verify exact compile errors
      for styling, overrides and repeat conversion, plus valid ordinary calls.
- [x] Exercise the generator's private mixin hook from annotated source and
      check public exports and generated hooks.
- [x] Review all 31 showcase interaction sites for hit areas, nested controls,
      keyboard access and semantics; retain the migration mapping.
- [x] Update README, composition guidance, canonical Mix skill and examples.
      Document Box/Text/layout/Icon/Image usage, reuse and version requirements.
- [x] Update installed Mix and local microinteraction skill copies with narrow
      changes preserving unrelated work; validate all five skill directories.
- [x] Run generation, focused tests, full repository CI, formatting, analysis,
      showcase checks and local example web build.
- [x] Obtain independent code/examples/docs/skills review, resolve findings,
      and rerun affected checks before pushing.
- [x] Push the revision and update the existing PR title/body, preserving its
      ready-for-review status and leaving it unmerged.
- [x] Commit and push this plan and the review record alongside the changes.

## Recorded execution adjustment

The dedicated hosted-example CI job deliberately omits Melos overrides and
resolves published Mix. This applies to the entire showcase, not only Snacks.
Immediate runtime migration of getting-started/core examples would therefore
break published-version compatibility.

The revision instead adds version-gated comments to those two examples and a
source-dependent runnable web example under `packages/mix/example`. All 31
hosted runtime call sites retain released constructors until a supporting
version is published. This adjustment preserves the intended teaching and
compatibility requirements without changing CI or adding compatibility APIs.

## Validation and review

See the [review and validation record](2026-10-03-callable-pressable-builders-review.md).
Generation, formatting and full CI passed, including 3,027 core Mix tests and
383 generator tests. Repository analysis passes its Dart/schema stages but
retains four pre-existing DCM findings in unchanged files.

## Release follow-ups

- Publish the callable builders, then raise hosted showcase/DartPad dependencies
  and migrate the 31 surfaces using the
  [release audit](../guides/pressable-builders-release-audit.md).
- Update the separate `btwld/mix-docs` website for the new convention.
- Replace unreleased skill gates with the actual released version.
