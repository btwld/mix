# Ordered `onBuilder` — Investigation Report

Investigation of ordered context-built styles in Mix 2.x, centered on `onBuilder`, with `useToken` as a downstream consumer. All findings verified against the current workspace (post-#923 generator, mix-v2.0.3 released).

## Problem

Mix has two precedence systems, and `onBuilder` is in the wrong one.

1. **Prop-source order (fluent order).** Every fluent call merges a new styler; `Prop.mergeProp` concatenates source lists (`prop.dart:189-197`), and resolution is last-value-wins per property (`prop.dart:212-293`). Token refs are deferred (`TokenSource` resolves against `MixScope` at resolve time) but keep their list position — **tokens already obey source order**. Verified empirically: `.color($token()).color(red)` → red; `.color(red).color($token())` → token.

2. **Variant priority (build order).** `Style.build` → `mergeActiveVariants` (`style.dart:87-159`) starts from the base style and merges every active variant **on top**, widget-state variants last. Position in the fluent chain is irrelevant; only activity and category matter.

`onBuilder` is implemented as variant #2: `VariantStyleMixin.onBuilder` (`variant_style_mixin.dart:67-71`) wraps the fn in a `ContextVariantBuilder` that is *always active* (`style.dart:97`). Verified empirically (scratch test, since deleted):

- `.onBuilder((c) => color(green)).color(red)` → **green** (builder silently overrides the later explicit call)
- `.color(red).onBuilder((c) => color(green))` → green (matches source order only by coincidence)
- two builders → later wins (variant-list insertion order)

For `onDark`/`onHovered` the override model is right: they are *conditional* overrides, and "hovered beats base regardless of declaration position" is the intended mental model. `onBuilder` has no condition — it is an unconditional "compute part of my style from context" — so variant priority buys nothing and silently breaks the fluent-order intuition. No existing test pins the surprising precedence (`context_variant_builder_test.dart` and `variant_mixin_test.dart` cover construction mechanics only).

## Current Pipeline

- A styler (e.g. generated `BoxStyler`, `box_spec.g.dart`) holds `Prop<V>?` per field plus `$variants` / `$modifier` / `$animation` from base `Style`. Every fluent setter is `merge(BoxStyler(field: value))`; generated `merge` does field-wise `MixOps.merge` (source-list concat) and `MixOps.mergeVariants` (dedupe by `variant.key`, first-occurrence position).
- `StyleBuilder` merges inherited style + widget style, reads `style.widgetStates` *before* build to decide interaction tracking, then calls `style.build(context)`.
- `build` = `mergeActiveVariants` (filter active → sort widget-state-last → fold variant styles onto base, recursing into nested variants; `ContextVariantBuilder` is invoked with context here, result also recursed) → `resolve(context)` (per-prop resolution incl. tokens/directives; nested styles are `build()`-ed per #926).
- `ContextVariantBuilder.key` is `fn.hashCode`; the `VariantStyle` placeholder value (`this` at call time) is ignored at build. Footnote: the widget-state sort uses `List.sort`, which is only insertion-sort-stable for <32 entries — an implementation-detail dependency.

## Prior art in the repo (load-bearing finding)

1. **`origin/claude/onbuilder-inline-resolution-1EmYz`** (`a1a9d2a0d`, Apr 2026): full implementation of source-ordered `onBuilder`. Adds `$inlineBuilder: InlineStyleBuilder<S>?` (fn + `tail` style) to `Style`. `.onBuilder` sets it; the generated merge gets a branch: if `this.$inlineBuilder != null`, the incoming styler is **appended to the tail** instead of merged flat — multiple builders form a linked list of segments naturally. `Style.build` first runs `resolveInlineBuilders(context)`: `base-without-builder ⊕ fn(context) ⊕ tail` (recursive), then variants run unchanged. `widgetStates` unions tail states. Generator emits `inlineBuilder()` setter, append-branch `merge`, `copyWithoutInlineBuilder()` per styler. Comes with a 167-line widget test suite covering both orderings, multiple builders, widget-state variants after builders, modifiers, and animation propagation. Stale vs. current main (pre-#923 layout) but the modified generator file `styler_mixin_builder.dart` still exists and still emits `merge` — porting is a rebase, not a redesign.
2. **`origin/feat/mapped-token-source`** (`ba5a2bcee`, Leo, Feb 2026): `useToken` with **no deferred building at all**:
   ```dart
   ST useToken<U>(MixToken<U> token, ST Function(U value) builder) {
     return merge(builder(token())) as ST;
   }
   ```
   `token()` returns a token *ref* (`ColorRef extends Prop<Color> implements Color`, etc.); the callback runs eagerly, the ref flows into the typed setter, `Prop.value` detects it (`isAnyTokenRef`) and stores a `TokenSource` at the current chain position. Ordering is exact source order by construction. Tests on that branch prove both orderings.

## Design Options

### A. Keep `onBuilder` as a variant; document variant precedence
- **Files:** docs only.
- **Benefits:** zero code risk.
- **Risks:** the misleading example in the problem statement stays misleading; any style-producing `useToken` built on it inherits the surprise.
- **Verdict:** reject as the end state; acceptable as the fallback (see below).

### B. Ordering metadata / per-prop snapshot interleave
Record the pre-call snapshot (already captured today as the `VariantStyle` placeholder) and at build time splice builder sources between snapshot-prefix and suffix per prop.
- **Benefits:** sound in principle (snapshot sources are an exact list-prefix of final sources).
- **Risks:** needs generated per-field interleave on every styler; depends on a fragile "merges only append" invariant; strictly more machinery than C for the same result.
- **Verdict:** reject.

### C. Source-ordered inline builder (port of `onbuilder-inline-resolution`) — recommended
`.onBuilder` becomes a first-class deferred *segment* of the fluent chain rather than a variant.
- **Files:** `core/style.dart` (field, `InlineStyleBuilder`, `resolveInlineBuilders`, `widgetStates`), `style/mixins/variant_style_mixin.dart`, `mix_generator/.../styler_mixin_builder.dart` (+ regenerate all `*_spec.g.dart`), exports, tests.
- **Benefits:** exact source-order semantics; one model lifted from `Prop.sources` to style level; variants/modifiers/animation untouched; multiple builders compose via tail recursion; merging two fragments that each carry builders stays order-correct.
- **Risks:** (1) behavior change for released `onBuilder` users; (2) the prior branch adds *abstract* members (`copyWithoutInlineBuilder`, `inlineBuilder`) — breaking for hand-written `Style`/`MixStyler` subclasses; fix by shipping **default implementations that degrade to today's variant semantics** so non-regenerated stylers keep compiling and behaving as before; (3) `applyVariants` (and any `$variants` introspection) must traverse tails — a gap in the prior branch; (4) `$inlineBuilder` in `props` means closure-identity equality, same as today's `ContextVariantBuilder`.
- **Compatibility:** additive API surface; semantics of `.onBuilder` change (the point). `ContextVariantBuilder` remains as the explicit variant-priority escape hatch.
- **Verdict:** **recommend.**

### D. General internal style-layer model
Re-architect `Style` as a segment list.
- **Verdict:** reject — C *is* the minimal encoding of this (linked list through `tail`); nothing else needs layers today.

### E. Mapped token/prop sources for `useToken` (eager ref passthrough) — recommended for tokens
Leo's branch. Sugar over the existing token-ref pipeline.
- **Benefits:** 17 lines, zero new ordering machinery, exact source order, works regardless of what happens to `onBuilder`. Transform-by-directive already works for colors (`ColorRef.withOpacity` → directive, still deferred and ordered).
- **Risks / sharp edges:** callback must pass the ref through, not inspect it (`ValueRef.noSuchMethod` throws a good error); `U` limited to the 12 ref-supported types (`getReferenceValue`, falls through to a runtime cast error otherwise); **`DoubleRef` arithmetic silently corrupts** (sentinel-double registry — `space * 2` produces an unregistered garbage literal).
- **Verdict:** **recommend** as the `useToken` implementation, shipped independently of C.

### F. Narrow `useToken` via `onBuilder`, no other change
- **Verdict:** reject — inherits variant precedence, contradicting the stated expectation that `.useToken(...).color(red)` lets red win.

## Recommendation

**Source order should win for `onBuilder`; variant priority stays for `on*` conditionals.** The principle: *position in the fluent chain decides precedence among unconditional styling; variants are conditional overrides applied at build, widget-state highest.* Tokens already follow it at the Prop level; C extends it to whole-style context building; `onDark`/`onHovered` keep their model.

Two decoupled tracks:
1. **Ship `useToken` as eager ref passthrough (E)** — low-risk, no dependency on the `onBuilder` decision.
2. **Port C** with: tail traversal for `applyVariants`/`widgetStates`/introspection; non-abstract defaults that degrade to legacy semantics for non-regenerated stylers; regenerate via `melos run gen:build`.

**Fallback** if C is judged too heavy for 2.x: A + E — document `onBuilder` variant precedence loudly in dartdoc and the website, ship `useToken` (E), and add a `mix_lint` rule flagging fluent setters chained *after* `.onBuilder` on overlapping intent.

## `useToken` Implications

- `useToken` should **not** be built on `onBuilder`. Eager ref passthrough gives it exact Prop-level source order today; if C lands, both mechanisms agree with the same user-facing rule, so nothing is re-litigated later.
- The ordered-`onBuilder` semantics still matter for `useToken`'s documentation contract: "token-derived style participates in chain order like any other call" holds under E, and remains true for the multi-prop/value-inspecting cases that fall back to `onBuilder` once C lands.
- Document the ref boundary: pass-through and curated transforms (color directives) are fine; branching on the value or double arithmetic requires `onBuilder` (post-C) or `token.resolve(context)` inside it.

## Migration Plan

- **E (`useToken`)**: purely additive; minor release.
- **C (`onBuilder`)**: API-additive, **behavior-changing** for released `.onBuilder` users whose chains put explicit props after the builder (today builder wins; after C the later call wins). No test pins the old precedence and the old behavior is undocumented, so it is defensible as a bug-class fix — but mix-v2.0.3 is released, so:
  - Option 1 (preferred): change in place in a minor (2.1.0) with a prominent changelog/migration note; keep `ContextVariantBuilder` + `.variants([VariantStyle(ContextVariantBuilder(fn), …)])` as the documented escape hatch for anyone wanting override semantics.
  - Option 2 (more conservative): introduce the new semantics under a new name (e.g. `.builder(...)` — note #736 renamed `builder`→`onBuilder`, so this reverses that) and `@Deprecated` `onBuilder`; one release later, remove. Compile-time visibility of the change, at the cost of name churn.
  - Hand-written stylers: default implementations keep them compiling with legacy behavior until regenerated/updated; changelog instructs `melos run gen:build`.

## Test Plan

Port/extend the prior branch's `on_builder_inline_test.dart` plus Leo's `use_token_test.dart`:

1. `onBuilder` before explicit prop → explicit wins (`color(green).onBuilder(red).color(blue)` → blue).
2. `onBuilder` after explicit props → builder wins.
3. Multiple `onBuilder` calls interleaved with props → strict chain order.
4. `onBuilder` + widget-state variant declared after it → variant overrides on interaction; `MixInteractionDetector` still mounts (tail `widgetStates`).
5. Builder *returning* a style containing `onHovered` → nested variants resolve (and document that pre-context state discovery can't see them — pre-existing limitation).
6. `applyVariants` on a chain where the named variant was declared after `.onBuilder` (the gap found in the prior branch).
7. Inherited style (`StyleProvider`) merged with a widget style carrying a builder, and vice versa.
8. Fragment composition: `a.merge(b)` where either/both carry builders.
9. Modifiers and animation set before/inside/after a builder.
10. `useToken` then explicit (explicit wins); explicit then `useToken` (token wins); tear-off form; transform-by-directive (`withOpacity`); error path for value inspection.
11. `useToken` combined with `onBuilder` in one chain (post-C).
12. Generated-styler parity: every spec styler regenerates with the append branch (generator golden/unit coverage in `mix_generator`).

## Open Questions

1. In-place semantic change of `onBuilder` in 2.1.0 vs. deprecate-and-rename (reversing #736)?
2. Keep `ContextVariantBuilder` public as the variant-priority escape hatch, or deprecate it once `.onBuilder` is ordered?
3. Should `useToken` debug-assert when `U` has no ref support (today: opaque cast error)?
4. `DoubleRef` arithmetic hazard: accept + document, or add a `mix_lint` rule?
5. Is the "legacy degradation" default for non-regenerated hand-written stylers acceptable, or should the new members be abstract (hard break, simpler invariants)?
6. Where should ordered-`onBuilder` docs live on the website (variants page vs. a new "context-built styles" page)?
