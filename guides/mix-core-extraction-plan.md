# Plan: Extract `mix_core` (pure-Dart styling engine)

> **Status (2026-08-19): implemented through the styler/widget split.**
> `packages/mix_core` owns the engine (Prop/Mix/Token/Directive/Variant,
> `StyleBase` with the variant fold, `TokenStore`, modifier ordering);
> `mix` binds it via subclasses/typedefs at the original file paths with a
> byte-identical generated surface (golden `.g.dart` zero-diff) and a fully
> green workspace CI. Platform authors start at
> `packages/mix_core/PLATFORM_GUIDE.md` and
> `packages/mix_core/test/reference_binding_test.dart`.
> Deviations from the original sketch: the context is bound by *subclassing*
> (not typedefs) for the generator-critical types; `StyleSpec` stays declared
> in mix with `StyleBase<C, R, Self>` generic over the envelope; the empty-
> Prop resolution error is now `StateError` (was `FlutterError`); DCM could
> not run in the working environment (license), all other gates green.
> Contrary to the "no source changes" expectation below, `mix_protocol`
> needed four one-line token casts and an inventory-scanner patch (it now
> scans mix_core and strips import prefixes).
>
> **Open decision for mix 3.0:** the binding layer (mix subclasses of the
> core types, ~1.6k lines) exists only to keep mix's 2.x API and generated
> code unchanged. A breaking 3.0 could use the core types directly, drop
> the dual hierarchy and the `ensureMixBindings` hook, and update the
> generator for two-arity types. Decide deliberately rather than by inertia.

## Goal

Split the Flutter-free primitives out of `packages/mix` into a new pure-Dart
package `packages/mix_core`, so that non-Flutter renderers — a terminal UI
styling library, Jaspr, and others — can build on the same styling engine
(props, tokens, directives, variants, merge/resolve pipeline).

Constraints:

- `mix` remains the main package. It depends on `mix_core` and re-exports it,
  so **existing users see no import or API changes**.
- `mix_core` must have **zero dependency on Flutter or `dart:ui`** (enforced
  by CI, see Phase 1).
- `mix_annotations` and `mix_generator` keep working; generated code shape is
  unchanged.

## Findings: where the Flutter coupling actually is

A scan of `packages/mix/lib/src` shows almost every file imports Flutter, but
the coupling falls into three very different tiers:

### Tier 1 — Shallow coupling (annotations/helpers only): trivially movable

These only use `@immutable` / `@visibleForTesting` / `@internal` /
`listEquals` / `debugPrint` / `FlutterError`, all replaceable with
`package:meta` and existing hand-rolled utilities:

| File | Notes |
| --- | --- |
| `core/equatable.dart` | Pure logic; already vendors its own deep equality |
| `core/internal/deep_collection_equality.dart` | Pure |
| `core/internal/constants.dart` | Pure |
| `core/converter_registry.dart` | Only `@visibleForTesting` from foundation |
| `core/mix_element.dart` → `Mixable<T>`, `DefaultValue<V>` | Pure (see Tier 2 for `Resolvable`) |
| `core/directive.dart` → `Directive<T>` base class | Base is pure; concrete `Color` directives are Tier 3 |
| `variants/variant.dart` → `Variant`, `NamedVariant`, `EnumVariant`, `hasVariant`/`hasAnyVariant`/`hasAllVariants`, named-variant constants | Pure (see gotcha: `Variant` is `sealed`) |
| `core/breakpoint.dart` | Pure doubles; only `matches(Size)` / `matchesContext(BuildContext)` touch Flutter — core version takes `(width, height)` and mix keeps `Size`/context extensions |
| `core/prop_source.dart` | Pure once `MixToken` base moves |
| `core/spec.dart` → `Spec<T>` | `copyWith`/`lerp` are pure; `SpecTween` (extends Flutter `Tween`) stays in mix |

### Tier 2 — Deep but *singular* coupling: `BuildContext` as the resolution context

This is the one real architectural dependency. Everything resolves through
`BuildContext`:

- `Resolvable<V>.resolve(BuildContext)` (`core/mix_element.dart`) — the linchpin
- `Prop<V>.resolveProp(BuildContext)` and `TokenSource` resolution (`core/prop.dart`)
- `MixToken<T>.resolve(BuildContext)` → `MixScope.tokenOf` (`theme/tokens/mix_token.dart`)
- `ContextVariant`'s `bool Function(BuildContext)` (`variants/variant.dart`)
- `Style.build(BuildContext)` / `Style.resolve(BuildContext)` (`core/style.dart`)
- `PropOps.mergeMixes(BuildContext, …)` (`core/helpers.dart`)

If we abstract the context (see decision below), this whole engine becomes
platform-neutral.

### Tier 3 — Inherently Flutter: stays in `mix`

- All `dart:ui` value types and everything built on them: `Color`, `Radius`,
  `Shadow`, `TextStyle`, `Size`… so all of `properties/`, `specs/`,
  `modifiers/`, concrete color/text directives.
- Token ref sentinels (`theme/tokens/token_refs.dart`, `core/prop_refs.dart`):
  `ColorRef extends Prop<Color> implements Color` etc. — by definition
  implement Flutter interfaces. (The *pattern* — `Prop` subclass +
  `ValueRef` mixin — can live in core so terminal/Jaspr can build their own
  refs over their own value types.)
- `StyleSpec`, `WidgetModifier`, `WidgetModifierConfig`, `AnimationConfig`
  (Curves, `Duration`+`Curve` pairs, springs), `StyleBuilder`, all widgets,
  all `providers/` (InheritedWidgets), `MixScope`/theme, Material
  integration, `decoration_merge.dart`, `shape_border_merge.dart`, and the
  Flutter-typed halves of `MixOps` (lerp helpers).
- Concrete context variants (`WidgetStateVariant`, `BrightnessVariant`,
  `OrientationVariant`, `BreakpointVariant`, …) — they read MediaQuery /
  widget-state providers. Core keeps the *base* context-variant type; each
  platform ships its own concrete variants (a terminal lib might have
  `onFocused`, a width breakpoint against terminal columns, etc.).

## The one big design decision: how to abstract `BuildContext`

Two viable strategies:

### Option A (recommended): generic context type parameter, bound per platform

Core types take a context type parameter `C`:

```dart
// mix_core
mixin Resolvable<C, V> { V resolve(C context); }
abstract class Mix<C, T> extends Mixable<T> with Resolvable<C, T>, Equatable {}
class Prop<C, V> { V resolveProp(C context) {…} }
abstract class MixToken<C, T> { final String name; T resolve(C context); }
class ContextVariant<C> extends Variant { final bool Function(C) shouldApply; }
```

`mix` binds `C = BuildContext` under the **same public names**, via typedefs
where possible and thin subclasses where a typedef can't carry the extras:

```dart
// mix (Flutter)
typedef Prop<V> = core.Prop<BuildContext, V>;           // statics/ctors work through aliases
abstract class Mix<T> extends core.Mix<BuildContext, T> {}
abstract class MixToken<T> extends core.MixToken<BuildContext, T> {
  T resolve(BuildContext context) => MixScope.tokenOf(this, context);
  T call() => getReferenceValue(this); // ref sentinels stay Flutter-side
}
```

A terminal library binds `C = TermContext` (its own context carrying theme
tokens, terminal size, focus state); Jaspr binds its build context.

- **Pros:** zero user-facing churn in `mix` (signatures still say
  `BuildContext`); no adapter object allocated per resolve pass; each platform
  gets a fully typed context with no casts.
- **Cons:** an extra type parameter threads through core internals; a few
  places (e.g. `ContextVariantBuilder`, `StyleVariation`) need care so the
  parameter doesn't leak into generated code.

### Option B: abstract `StyleContext` interface in core, adapter in mix

Core defines `abstract interface class StyleContext { T resolveToken<T>(MixToken<T>); bool matchVariant(…); }`;
mix wraps `BuildContext` in a `MixBuildContext` adapter at the widget
boundary.

- **Pros:** no generics; core signatures are concrete.
- **Cons:** public `resolve(BuildContext)` methods change type or need
  shadowing extensions; concrete Flutter variants/tokens must downcast the
  adapter to reach `BuildContext`; one adapter allocation per build (minor).

**Recommendation: Option A.** It preserves the `mix` public API exactly and
gives downstream platforms first-class typed contexts. Prototype it on
`Prop` + `MixToken` first (Phase 3 spike) before committing everywhere.

### Verdict from the BuildContext API inventory (spike, DONE)

Do we need a `BuildContext` *abstraction* — an interface enumerating the APIs
the engine needs? **No.** A full inventory of every context dereference in the
engine files (`prop.dart`, `style.dart`, `mix_element.dart`, `mix_token.dart`,
`helpers.dart`) shows the engine only ever does four things with the context:

1. `token.resolve(context)` — delegated to `MixToken` (platform implements)
2. `variant.when(context)` / `variant.build(context)` — delegated to
   `ContextVariant` (platform implements)
3. `mix.resolve(context)` / `style.build(context)` — recursion, pure
   pass-through
4. `context.getInheritedWidgetOfExactType<StyleProvider>()` — only in
   `Style.of`/`Style.maybeOf`, a widget-tree feature that stays Flutter-side

So the context is *opaque to the engine*: no interface is needed, just an
uninterpreted type parameter `C` plus the two platform-implemented hooks
(token resolve, variant predicate). The "which APIs do we need" question
dissolves — the answer is "none; the platforms own all context APIs".

This is validated in code: `packages/mix_core` exists as a working spike —
the genericized engine (`Prop<C,V>`, `PropSource`, `MixToken<C,T>`,
`Directive`, `ContextVariant<C>`, converter registry, `PropOps`, `Equatable`,
`Spec`, `Breakpoint`) with a fake terminal platform bound in
`test/terminal_poc_test.dart` (13 tests: merge order, token resolution, Mix
accumulation, converters, directives, nested `Buildable`, variants) and a
purity gate in `test/purity_test.dart`. `dart analyze` clean, all tests pass,
zero Flutter in the dependency graph.

Spike learnings to carry into Phase 3:

- **Two new core interfaces replace hardcoded couplings**: `Buildable<C,V>`
  (replaces the `mergedMix is Style` check in `Prop.resolveProp`; mix's
  `Style` will implement it) and `ContextMergeable<C,T>` (replaces the
  hardcoded `DecorationMix`/`ShapeBorderMix` cases in `PropOps.mergeMixes`;
  those types opt in).
- **Static-method inference through the alias**: `TermProp.value(x)` infers
  `C` from downward inference (declared/expected type) but not from arguments
  alone; bare call sites may need explicit type arguments. Mitigation for
  mix: bind via a thin subclass (`class Prop<V> extends core.Prop<BuildContext, V>`)
  or keep single-type-param static facades in mix — which mix needs anyway
  for token-ref sentinel detection (next point).
- **Token-ref sentinel detection moved out of core `Prop.value`**:
  `getTokenFromValue` inspects sentinel types that implement Flutter value
  interfaces, so detection belongs in mix's `Prop.value` facade before
  delegating to core.
- **Converter registry became per-context-type**
  (`MixConverterRegistry.instanceOf<C>()`) with a settable lazy `initializer`
  replacing the hardcoded `initializeMixConverters()` call.

## Target layout

```
packages/
  mix_core/          # NEW — pure Dart. deps: meta (nothing else)
    lib/src/
      equatable/     # Equatable, deep collection equality
      prop/          # Prop<C,V>, PropSource, ValueRef mixin, converter registry
      directive/     # Directive<T> base
      token/         # MixToken<C,T> base
      variant/       # Variant, NamedVariant, EnumVariant, ContextVariant<C>, helpers
      spec/          # Spec<T> base (no SpecTween)
      style/         # StyleBase<C,S>: variants + merge/resolve pipeline
      breakpoint.dart
  mix/               # depends on mix_core; binds C=BuildContext; re-exports
  mix_annotations/   # unchanged (already pure Dart)
  mix_generator/     # checker URL updates only (see gotchas)
  ...
```

`Style` splits: core `StyleBase` owns `$variants` + the merge/resolve
pipeline; mix's `Style` extends it and adds the Flutter-only `$modifier`
(`WidgetModifierConfig`) and `$animation` (`AnimationConfig`) and
`build(BuildContext)` → `StyleSpec`. A terminal package defines its own
equivalents on top of `StyleBase`.

## Phases

Each phase lands independently with `melos run gen:build && melos run ci &&
melos run analyze` green, so this can ship incrementally without a
long-lived branch.

### Phase 0 — Decisions (this document)
- Confirm package name (`mix_core` vs `mix_foundation`).
- Confirm Option A vs B.
- Confirm scope: does the terminal library need the full Prop/token/directive
  engine, or a subset? (Plan assumes full engine.)

### Phase 1 — Scaffold `packages/mix_core`
- Pure-Dart pubspec (`sdk >=3.11.0`, dep: `meta`; dev: `test`,
  `dart_code_metrics_presets`). Add to root workspace `pubspec.yaml` and
  melos (it should be picked up by `test:dart`).
- **Purity gate in CI**: a check that fails if `package:flutter` or `dart:ui`
  appears in `mix_core` imports or its resolved dependency graph
  (`dart pub deps --json`). This is what keeps the split honest forever.

### Phase 2 — Move the Tier-1 leaves (mechanical, no design churn)
- Move: equatable + deep equality + pure internal extensions, constants,
  `Mixable`/`DefaultValue`, `Directive<T>` base, converter registry,
  `Variant`/`NamedVariant`/`EnumVariant` + helpers, `Breakpoint` (context
  helper stays in mix as an extension), `Spec<T>` base (`SpecTween` stays).
- Swap Flutter annotation imports for `package:meta`,
  `FlutterError` → `StateError`, `listEquals` → core equality helpers,
  `debugPrint` → assert-based hook.
- `mix` re-exports each moved symbol from its old library path so nothing
  downstream changes; regenerate `mix.dart` (`melos run exports`).
- Update `mix_generator` checker URLs for moved types (see gotchas).
- Move the corresponding unit tests to `mix_core/test`.

### Phase 3 — Genericize the context (the design-heavy phase)
- **Spike first**: convert only `Prop`/`PropSource`/`MixToken` to
  `Prop<C,V>` in core with `typedef Prop<V> = core.Prop<BuildContext, V>` in
  mix; run the full mix test suite + a generator smoke build. This validates
  Option A cheaply (alias statics, covariance, generated-code compatibility)
  before touching `Style`.
- Then extend to `Resolvable<C,V>`, `Mix<C,T>`, `ContextVariant<C>`, and
  `PropOps.mergeMixes`.
- Split `Style`: core `StyleBase<C,S>` (variants, props, merge, resolve
  pipeline); mix `Style<S>` keeps `$modifier`/`$animation`/`build()` and its
  exact current public surface.

### Phase 4 — Split the ops helpers
- `PropOps` (directive merge/apply, mix merge) → core.
- `MixOps` stays in mix (lerp and Flutter-typed helpers), delegating to core
  where logic is shared. Generated `.g.dart` files only reference `MixOps`
  via mix, so no generator output changes.

### Phase 5 — Packaging & release
- `mix` gets `mix_core: ^<version>` (workspace resolves by path during dev).
- README/CHANGELOG for `mix_core`; note in mix's CHANGELOG that the split is
  non-breaking.
- Publish order: `mix_core` → `mix` (→ `mix_winds`, `mix_protocol` untouched).
- Decide version: since `mix` API is unchanged, this can ship in a 2.x minor.

### Phase 6 — Proof-of-concept consumer (validation)
- A tiny pure-Dart example/test package (can live in `mix_core/example`):
  define a `FakeContext`, a `TermTextSpec` with a couple of props, a token
  resolved from a fake theme, a named variant and a context variant — prove
  merge → variant application → token resolution → directive application all
  run with **no Flutter in the dependency graph**.
- This is the acceptance test for the terminal/Jaspr use case before any real
  terminal package is started.

## Gotchas & risks (found during review)

1. **`mix_generator` resolves types by declaring library URI.**
   `packages/mix_generator/lib/src/core/checkers.dart` uses
   `TypeChecker.fromUrl('package:mix/src/core/prop.dart#Prop')` etc. Re-exports
   do NOT satisfy these — the analyzer reports the *declaring* library, which
   becomes `package:mix_core/...`. Every checker for a moved type must be
   updated (or accept both URLs during transition). Same risk anywhere
   `known_mix_symbol_resolver.dart` hardcodes `package:mix/` URIs.
2. **`Variant` is `sealed`.** Sealed classes can't be extended outside their
   library. With `NamedVariant` in core and `ContextVariant` needing
   platform subclasses, the base must become non-sealed (or core keeps a
   sealed private hierarchy and exposes `base`/`abstract` extension points).
   Check for exhaustive `switch`es over `Variant` before changing.
3. **Typedef binding edge cases** (Option A): statics and constructors work
   through type aliases, but `extension type`s, `on` clauses of mixins, and
   `implements Prop<V>` sites (e.g. `token_refs.dart` refs extend `Prop`)
   need verification in the Phase 3 spike.
4. **`mix.dart` is generated** (`melos run exports`) — the exports tool must
   handle symbols that now originate in `mix_core` (re-export from mix's own
   shim libraries so the generated entrypoint stays stable).
5. **DCM rule `avoid-importing-entrypoint-exports`** already shaped
   `spec.dart`'s re-exports; keep the same pattern when shimming moved files.
6. **`dart:ui` is Flutter-only** — no `Color`/`Size` anywhere in core, ever.
   Terminal colors will be a different type; that's why `Directive<T>`,
   `Prop<C,V>` and the `ValueRef` pattern move but no concrete color code does.
7. **`mix_lint`** is outside the workspace (analyzer ^7) — if any lint rule
   pattern-matches on mix core types by URI, it needs the same URL updates as
   the generator.
8. **`equatable.dart`'s** `flutter/widgets` import is vestigial
   (only `@visibleForTesting`) — confirms Tier-1 classification, but re-run
   the analyzer after the swap in case of transitive surprises.

## What explicitly does NOT change

- Public API of `mix`: imports, class names, `resolve(BuildContext)`
  signatures, fluent styler API, generated spec shape.
- `mix_annotations` (already pure Dart).
- `mix_protocol`, `mix_winds`, `mix_lint` — no source changes expected
  (they depend on `mix`, which keeps its surface).
- The Spec/Style/Widget architecture and the merge/resolve semantics.

## Open questions

1. Package name: `mix_core`? (`mix_foundation` is the other candidate;
   `mix_core` matches the request.)
2. Should core also own a platform-neutral `Size`-like record
   (`({double width, double height})`) so `Breakpoint.matches` moves intact?
3. Do the shared named-variant constants (`primary`, `secondary`, …) belong
   in core or in each platform package?
4. Version target: ship the split inside 2.x (non-breaking, recommended) or
   batch with other breaking work for 3.0?
5. For the terminal library: is animation part of the core contract (lerp is
   already pure in `Spec.lerp`) or fully platform-side? Affects whether a
   minimal `AnimationConfig`-like type belongs in core.

## Deferred follow-ups (raised during implementation)

Every item below was **considered and consciously excluded** from the
extraction branch — none of them is unfinished work. They are recorded here so
the decisions survive outside the conversation that produced them, and so a
reviewer opening the branch cold does not have to re-derive why an obvious
cleanup was left in place.

Distinct from **Open questions** above: those are design questions still
awaiting an answer, these are answers already given.

1. **The last unchecked cast in the engine: `variant.build(context) as Self`**
   — `packages/mix_core/lib/src/style.dart`, in `mergeActiveVariants`, where a
   `ContextVariantBuilder` result is adopted as the enclosing `Self` type.
   Behavior is byte-identical to `origin/main`; the cast tracks a real gap
   (`ContextVariantBuilder` does not carry the style type it builds), not a
   porting shortcut. Fixing it means reshaping `VariantStyle` /
   `ContextVariantBuilder` to carry that type — a public API change, out of
   scope for a branch that deliberately holds mix's API fixed.

2. **`StyleVariation` covariance** — same file, a few lines below (1), the
   pattern match carrying `// ignore: avoid-unrelated-type-assertions`. Same
   root cause and the same API-reshape blocker; (1) and (2) should be designed
   and landed together, not separately.

3. **`mix_generator` is bound to `package:mix` and Flutter throughout** — so
   non-Flutter codegen is a workstream, not a flag. An earlier revision of this
   entry understated this: it named the unconditional `Diagnosticable` emission
   as the one remaining blocker and proposed an opt-out generator option as the
   fix. That is only one of three layers:
   - **Type resolution.** `packages/mix_generator/lib/src/core/checkers.dart`
     resolves `Style`, `StyleSpec`, `Prop` and `WidgetModifier` at
     `package:mix/...` URLs, and `Widget` / `Key` at `package:flutter/...`.
     Only `Mix`, `Mixable` and `DefaultValue` resolve at `package:mix_core`. A
     terminal or Jaspr package's types match none of the other checkers.
   - **Vocabulary.** `packages/mix_generator/lib/src/core/curated/` maps
     Flutter value types (`EdgeInsetsGeometry`, `TextStyle`, `BoxBorder`, …)
     to mix's `*Mix` counterparts and styler mixins (`SpacingStyleMixin`,
     `DecorationStyleMixin`, …).
   - **Emitted contract.** Generated spec and modifier mixins implement
     `Diagnosticable` (from `package:flutter/foundation.dart`), whose surface
     is emitted by `buildDiagnosticableSurface` in
     `core/helpers/generated_contract_emitter.dart`.

   Today a non-Flutter package gets the engine but **cannot use the generator
   at all** — it must hand-write every spec and styler. Of the items in this
   list this is the highest-value one, but it is a generator redesign, not a
   small change on this branch.

4. **`MixScope.orderOfModifiers` is dead wiring** — threaded through
   `packages/mix/lib/src/theme/mix_theme.dart` and
   `theme/material/material_theme.dart`: constructed, merged, forwarded, and
   readable via `MixScope.of(context).orderOfModifiers`, but never consumed
   when modifiers are actually ordered. Note this is a *separate field* from
   `WidgetModifierConfig.$orderOfModifiers`, which is very much live — that one
   feeds `typeOrder:` in `packages/mix/lib/src/modifiers/widget_modifier_config.dart`
   and is what real ordering uses. Only the theme/scope-level copy is inert.
   Pre-existing on `main` and unrelated to the extraction; removing it is a
   public API change and belongs with other breaking work.

5. *(Resolved — `strict-raw-types` is now `true`.)* It was deferred on the
   assumption that enabling it would flag declarations across the package;
   measuring it showed only 8 warnings in 2 files, all raw `Map`/`Set`/
   `Iterable`/`List` in private helper signatures, so it was fixed and turned
   on rather than deferred. `mix_core/analysis_options.yaml` now enables all
   three of `strict-casts`, `strict-inference` and `strict-raw-types`. This is
   the flag that guards the raw-generic contravariance trap described above.

6. **Issue [#1036](https://github.com/conceptadev/mix/issues/1036), second
   finding** — `_iterablesEqual` in
   `packages/mix_core/lib/src/deep_collection_equality.dart` returns `false` for
   two equal-length non-`List` iterables, contradicting its own doc comment.
   The behavior is pre-existing — verified against `origin/main` before any fix
   landed here — and currently latent: no spec or prop in `mix`, `mix_winds`, or
   `mix_chart` is typed as a non-`List` `Iterable`. Left unfixed because correcting it changes equality —
   and therefore rebuild behavior — for any `Iterable`-typed prop library-wide,
   which the current tests do not cover. The *first* finding in that issue (a
   blind cast that threw on mismatched collection shapes) **is** fixed in this
   branch.
