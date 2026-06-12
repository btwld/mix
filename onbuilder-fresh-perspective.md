# Fresh Perspective: Defer Values, Not Structure

Status: current branch recommendation. This document supersedes `onbuilder-ordering-report.md` and `onbuilder-previous-analysis.md`, which are retained as historical analyses.

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

**(a) Resolvable tokens — context values ride the existing token pipeline. *(Implemented.)*** An earlier draft of this piece proposed a new `BuilderSource` `PropSource` plus `contextColor()`-family helpers. Reviewing the prior report's findings against the codebase produced a strictly leaner shape that needs **no new `PropSource`, no helper family, and no new public call pattern** — it reuses the token-ref approach users already know:

- The prior report proved tokens already obey exact chain order at the Prop level (`TokenSource` keeps its list position; option E's validation).
- `BreakpointToken.resolve` (`value_tokens.dart:55-71`) is existing in-repo precedent for a token that *computes* its value — but `Prop.resolveProp` bypassed that virtual hook by calling `MixScope.tokenOf` directly (`prop.dart:222`), while `variant.dart:73` already used the virtual path. A latent inconsistency, and the fix *is* the feature.
- `MixScope.getToken` already received a `BuildContext` it never used — the seam was sitting there.

Three small changes:

1. `prop.dart`: `TokenSource` resolution routes through the virtual `token.resolve(context)` (one line; also fixes the `BreakpointToken` inconsistency).
2. `ContextToken<T>` (`mix_token.dart`): a token carrying a `T Function(BuildContext)` resolver. Needs no `MixScope` entry; providing one *overrides* the resolver, so it degrades gracefully into a normal themeable token. Inherits `call()` → typed refs via `getReferenceValue`.
3. `MixScope.getToken` accepts `T Function(BuildContext)` map values — `MixScope(tokens: {$primary: (c) => Theme.of(c).colorScheme.primary}, ...)` makes every existing `$primary()` call site context-derived with zero style-side changes.

```dart
final primary = ContextToken((c) => Theme.of(c).colorScheme.primary);

BoxStyler().color(primary()).color(Colors.red);  // red wins — later in the chain
BoxStyler().color(Colors.red).color(primary());  // primary wins
```

`primary()` returns exactly what `$token()` returns today — a typed ref carrying a `TokenSource` — so there is no new mechanism to explain: the value is deferred, the chain position is exact, and the resolver receives a **real** `BuildContext` and returns a **real** value at resolve time. The crucial difference from the failed eager-`useToken` branch holds: there, the *user's callback received a fake value* and ran arbitrary logic on it; here the ref is an inert carrier and user code never touches a fake.

**(b) Honest tiers for structural builders — wrapper first, no generator.** Split the ambiguous `onBuilder` into two named tiers:

- *Defaults tier*: `style.withDefaults((context) => style)` returning a hand-written `StyleWithDefaults<S> extends Style<S>` wrapper (IdentityStyle precedent) whose `build` is `defaultsFn(context).merge(inner).build(context)` with `widgetStates`/`variants` delegation. Chain-terminal (returns `Style<S>`, not `BoxStyler`) — which is semantically honest: defaults wrap the *whole* style. Zero generated-code impact; works with every widget already.
- *Override tier*: today's `onBuilder`, unchanged behavior, renamed docs (and possibly renamed API later) to say what it is: an always-active context override that beats the chain and loses to widget-state variants.

Both tiers are priority-based and *named for it*. The chain itself stays purely source-ordered for unconditional values via (a).

**(c) `useToken` dissolves.** Passthrough already exists: `.color($primary())`. Derived values: ref transform methods (`$primary().withOpacity(.5)` is already a deferred directive) or a small `token.map(fn)` producing a ref + lambda directive. The style-producing `useToken(token, (v) => Style)` shape is rejected as wrong-shaped — multi-prop token styling is just multiple single-prop uses, each independently and exactly ordered. No new ordering rules to define, document, or test.

## What this model gives up (honest limits)

- No interleaved structural builders. If a real sandwich use case emerges, the tail design remains the known (costly) answer — nothing here forecloses it.
- Animation/modifier-from-context stays tier-based (defaults or override), not chain-positioned. Rare enough to accept.
- Closure equality: `ContextToken` and defaults wrappers compare by resolver identity across rebuilds — declare context tokens as top-level/static finals (the existing convention for all tokens); an inline closure mints a new token every rebuild. Same profile as today's `ContextVariantBuilder`, no regression.
- `double` works through the existing `DoubleRef` sentinel because the registry is keyed per *token* (a hoisted `ContextToken<double>` overwrites its single entry per call). Inline-created double tokens would grow the registry per rebuild — covered by the hoisting rule above, not a new hazard class.
- The ref hazard window is inherited from tokens: between `primary()` and the setter, the value is a ref, not a real `Color`. Through Mix setters (the supported path) it unwraps; embedded in a raw Flutter object (`BoxDecoration(color: primary())`) it never unwraps and reaches paint as a fake — exactly like `$primary()` today.
- `T` is limited to the ref-supported types (`getReferenceValue`'s dispatch) — same boundary all tokens have; an unsupported `T` fails on a cast at the `call()` site (prior report's open question 3 still stands).

## Recommendation

1. **(a) is implemented** as resolvable tokens (see status below) — the one true ordering mechanism, with the token-call UX users already have.
2. Ship **(b)** `withDefaults` as a wrapper — covers the dominant "theme-derived base" need with trivially explainable semantics.
3. Keep `onBuilder` as-is, documented as the override tier; consider renaming only after (a)+(b) absorb most usage.
4. Drop the style-producing `useToken` API entirely — `ContextToken` also covers the "derive a value from theme/tokens with real logic" case (`ContextToken((c) => $primary.resolve(c).withValues(alpha: .5))` runs full Dart on real values).

Net: zero behavior changes (one latent-bug fix), zero generator changes, zero merge-algebra changes — and the ordering story becomes a sentence: *"values are ordered by the chain; conditions and builders are layers."*

## Implementation status (a)

| Change | File |
|---|---|
| `TokenSource` resolves via virtual `token.resolve(context)` | `packages/mix/lib/src/core/prop.dart` (1 line + import cleanup) |
| `ContextToken<T>` with resolver, scope-override, identity equality | `packages/mix/lib/src/theme/tokens/mix_token.dart` |
| `MixScope.getToken` accepts `T Function(BuildContext)` values | `packages/mix/lib/src/theme/mix_theme.dart` |
| 12 integration tests: chain order both directions (Color + double), no-scope resolution, scope override, theme-change reactivity via dependency, ref directives, scope resolvers, equality | `packages/mix/test/src/theme/tokens/context_token_integration_test.dart` |

Verified: new tests pass, full mix suite green (2731 tests), `dart analyze` and DCM clean. Test shapes reuse the prior report's plan (items 1–3, 7, 10 adapted from option E's validation).
