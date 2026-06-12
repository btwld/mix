# Fresh Perspective: Defer Values, Not Structure

Premise: both prior branches failed, and the earlier report's "port the tail design + eager useToken" recommendation inherits their shared mistake. This document sets prior art aside and re-derives the design from first principles.

## Why prior art failed (diagnosis)

Both attempts — and the problem statement itself — share one assumption: **a style-producing builder must be made to participate in chain order**. Each then bent a different layer to fake it:

- **Inline-builder tail**: bent the *merge algebra*. `a.merge(b)` stops meaning "combine fields" and becomes "if I secretly hold a builder, swallow you into my tail." Merge becomes conditional on hidden state; equality, `applyVariants`, `widgetStates`, debugging, and DevTools all see a style whose real content is invisible until a context arrives. Every styler grows generated machinery to maintain a parallel sequential representation inside a flat one.
- **Eager useToken refs**: bent the *value system*. It passes fake values (refs) through real user code. `ColorRef` throws on most members, `DoubleRef` silently corrupts under arithmetic, unsupported token types die on a cast. It invites users to write `(color) => ...` callbacks that look like they can inspect/transform a value precisely when they can't.

Failure mode in one sentence: **they made structure lazy (or values fake) instead of making lazy values real.**

## The thesis

Mix already has a complete, exact, source-ordered deferral mechanism: `Prop.sources`. A token is just a context-dependent *leaf value* that keeps its chain position. The principled model:

- **Values from context** → Prop sources (source-ordered, exact, last-wins per prop)
- **Structure from context** → declared conditions: `ContextVariant` / `onDark` / `onBreakpoint` (variant-ordered, analyzable)
- **Arbitrary imperative styles** → escape hatch, honestly tiered (defaults layer or override layer), *not* chain-positioned

Under this model the `onBuilder` ordering question dissolves rather than gets solved: nothing structural is ever sandwiched into the chain, so there is no sandwich to order.

## Evidence not previously considered

1. **Ecosystem precedent.** Flutter's own answer to context-dependent styling is `WidgetStateProperty<T>` — per-*field* resolvers, never "a builder that returns a whole ButtonStyle." CSS likewise: custom properties + `calc()` (value indirection) and media queries (declared conditions); there is deliberately no "rule that generates rules inline" because it breaks the cascade's static analyzability. Two mature systems independently converged on: defer leaves, declare conditions, never lazy-structure.
2. **Static shape is a Mix asset the tail design destroys.** `StyleBuilder` reads `style.widgetStates` *before* build to decide whether to mount `MixInteractionDetector` (`style_builder.dart:129-148`). Any structure-level lazy style makes that discovery, plus style equality, diagnostics, lint, and future DevTools, blind. Value-level deferral keeps the style graph fully static — only leaves are lazy — so every existing introspection keeps working.
3. **The tail design only half-orders anyway.** Variants declared after a builder still apply after expansion (conditional tier survives). So `.onBuilder(f).color(red)` becomes ordered, while `.onDark(x).color(red)` stays priority-based — a *new* asymmetry between two adjacent `on*` calls in the same chain. The "fix" deepens the very inconsistency it targets.
4. **The bug class is wider than props — and narrower than claimed.** Today `.onBuilder((c) => s.animate(spring)).animate(linear)` resolves to spring: the builder's `AnimationConfig` beats the later explicit call (`mergeAnimation` last-wins, variants merge last). Same for modifiers. Per-prop ordering fixes none of that; the tail design fixes it incidentally. But under the bimodal model the question disappears: a defaults-tier builder loses to all explicit calls, an override-tier builder beats them — both by honest definition rather than by position.
5. **The sandwich requirement is synthetic.** Zero `onBuilder` usages exist in-repo outside tests. The motivating examples are bimodal: "derive a base from theme/tokens, override explicitly" (defaults-shaped) or "force a context value over whatever's set" (override-shaped). Nobody has demonstrated a real `.color(a).onBuilder(f).color(b)` use case where both orderings around the builder matter simultaneously. Designing merge machinery for the sandwich optimizes a case with no demonstrated demand.
6. **Rebuild-subscription semantics are unowned.** Whatever the builder reads (`MediaQuery.sizeOf`, `Theme.of`) subscribes the inner `Builder` element in `StyleBuilder`. A style-level builder makes the *whole style* rebuild-coupled invisibly; prop-level deferral scopes the subscription to a leaf and keeps it auditable. Neither prior branch addressed this.
7. **The widget boundary is already typed for wrappers.** `StyleWidget.style` is `Style<S>` (`style_widget.dart:17`) and `IdentityStyle` is an existing hand-written wrapper `Style` subclass (`style.dart:205`). A defaults-tier wrapper needs no generator changes at all.

## The concrete proposal

Three small, independent pieces — none touches `merge`, the generator's merge emission, or variant resolution:

**(a) `BuilderSource<V>` — the missing 4th `PropSource`.** `prop_source.dart` gains `BuilderSource<V>(V Function(BuildContext) fn)`; `Prop.resolveProp`'s switch (`prop.dart:220-224`) gains one case: `BuilderSource(:final fn) => fn(context)`. `PropSource` is switched in exactly one place, so the change is ~20 lines. Public surface: typed helpers that reuse the existing ref wrappers — refs already wrap *any* `Prop<V>`, not just token props: `Color contextColor(Color Function(BuildContext) fn) => ColorRef(Prop.builder(fn))`, same for the other ref-supported types. Usage:

```dart
BoxStyler()
    .color(contextColor((c) => Theme.of(c).colorScheme.primary))
    .color(Colors.red)   // red wins — it's later in the chain. Exact, today’s Prop semantics.
```

How this typechecks (it is the existing ref mechanism, deliberately): `contextColor` does **not** return a real `Color`. It returns a `ColorRef` — `ColorRef extends Prop<Color> ... implements Color` (`token_refs.dart`) — carrying the closure as a `BuilderSource` in its sources list; refs already wrap *any* `Prop<Color>`, not just token props. The setter path then rides the same hop tokens use today: `Prop.value` returns any incoming `Prop` unchanged (`prop.dart:84`), `mergeProp` concatenates its source at chain position, and the closure runs only in `resolveProp`'s new `BuilderSource(:final fn) => fn(context)` case.

The crucial difference from the failed eager-`useToken` branch: there, the *user's callback received a fake value* and ran arbitrary logic on it (DoubleRef arithmetic silently corrupts). Here the fake is an inert carrier traveling one hop from helper to setter; the user's closure receives a **real** `BuildContext` and returns a **real** value — full Dart, no fake-value lies. Ordering is exact because it's literally the existing source-list ordering.

**(b) Honest tiers for structural builders — wrapper first, no generator.** Split the ambiguous `onBuilder` into two named tiers:

- *Defaults tier*: `style.withDefaults((context) => style)` returning a hand-written `StyleWithDefaults<S> extends Style<S>` wrapper (IdentityStyle precedent) whose `build` is `defaultsFn(context).merge(inner).build(context)` with `widgetStates`/`variants` delegation. Chain-terminal (returns `Style<S>`, not `BoxStyler`) — which is semantically honest: defaults wrap the *whole* style. Zero generated-code impact; works with every widget already.
- *Override tier*: today's `onBuilder`, unchanged behavior, renamed docs (and possibly renamed API later) to say what it is: an always-active context override that beats the chain and loses to widget-state variants.

Both tiers are priority-based and *named for it*. The chain itself stays purely source-ordered for unconditional values via (a).

**(c) `useToken` dissolves.** Passthrough already exists: `.color($primary())`. Derived values: ref transform methods (`$primary().withOpacity(.5)` is already a deferred directive) or a small `token.map(fn)` producing a ref + lambda directive. The style-producing `useToken(token, (v) => Style)` shape is rejected as wrong-shaped — multi-prop token styling is just multiple single-prop uses, each independently and exactly ordered. No new ordering rules to define, document, or test.

## What this model gives up (honest limits)

- No interleaved structural builders. If a real sandwich use case emerges, the tail design remains the known (costly) answer — nothing here forecloses it.
- Animation/modifier-from-context stays tier-based (defaults or override), not chain-positioned. Rare enough to accept.
- Closure equality: `BuilderSource` and defaults wrappers compare by closure identity across rebuilds — exactly like today's `ContextVariantBuilder`, no regression.
- Primitive-typed setters (`double`) can't carry a `BuilderSource` through the public API — Dart forbids `implements double`, and the `DoubleRef` sentinel-registry hack would be *worse* here than for tokens: token sentinels are bounded by declared tokens, but closure sentinels would grow the global registry on every rebuild. Do not extend the sentinel pattern; primitives are out of (a)'s v1 scope.
- The ref hazard window is inherited from tokens: between `contextColor(fn)` and the setter, the value is a ref, not a real `Color`. Through Mix setters (the supported path) it unwraps; embedded in a raw Flutter object (`BoxDecoration(color: contextColor(...))`) it never unwraps and reaches paint as a fake — exactly like `$primary()` today.

## Recommendation

1. Ship **(a)** `BuilderSource` + `contextColor`-family helpers — the one true ordering mechanism, ~1 file of core change.
2. Ship **(b)** `withDefaults` as a wrapper — covers the dominant "theme-derived base" need with trivially explainable semantics.
3. Keep `onBuilder` as-is, documented as the override tier; consider renaming only after (a)+(b) absorb most usage.
4. Drop the style-producing `useToken` API entirely.

Net: zero behavior changes, zero generator changes, zero merge-algebra changes — and the ordering story becomes a sentence: *"values are ordered by the chain; conditions and builders are layers."*
