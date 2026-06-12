# Ordered `onBuilder` — Engineering Recommendation

Status: investigation complete, no implementation. Target: `mix` 2.0.0-rc.x.

All file references are to `packages/mix/...`.

---

## Problem

Mix has no defined ordering model for context-built styles. The general mechanism is
`onBuilder((context) => Style)`. Users reasonably expect a fluent chain to behave by
source order — later calls win — exactly as same-field prop calls do
(`.color(blue).color(red)` → red wins, because `Prop` resolves last-source-wins).

Two expectations to satisfy:

```dart
// A — explicit AFTER builder: user expects red to win
BoxStyler().onBuilder((c) => BoxStyler().color(resolve(c))).color(Colors.red);

// B — explicit BEFORE builder: user expects the builder color to win
BoxStyler().color(Colors.red).onBuilder((c) => BoxStyler().color(resolve(c)));
```

**Finding (provable): the current model cannot honor source order, and cannot even
distinguish A from B.** Both expressions compile to byte-identical internal state, so any
fixed rule returns the same answer for both. Today that answer is **the builder always
wins** (A is therefore surprising; B happens to match).

---

## Current Pipeline

Resolution (`core/style.dart:176` `build` → `core/style.dart:87` `mergeActiveVariants` →
generated `resolve`):

1. **Storage split.** `Style<S>` holds props on the concrete styler as typed
   `Prop<V>?` fields (`$decoration`, `$alignment`, …, `box_spec.g.dart:154`) and holds
   variants separately in `Style.$variants` (`core/style.dart:24`). Props and variants are
   **different buckets**.
2. **Fluent calls coalesce.** Every setter is `merge(BoxStyler(field: value))`
   (`box_spec.g.dart:395-455`). `merge` folds props with `MixOps.merge` →
   `Prop.mergeProp` → `sources: [...this, ...other]` (`core/prop.dart:189`, `helpers.dart:47`)
   and folds variants with `MixOps.mergeVariants` (keyed by `mergeKey`, insertion-order
   preserved, `helpers.dart:68`). A field set before *and* after an `onBuilder` lands in the
   **same** `Prop`, with no record of where the `onBuilder` sat in the chain.
3. **`onBuilder` is a variant.** `variant_style_mixin.dart:67` wraps the closure in
   `ContextVariantBuilder` (`variants/variant.dart:156`) inside a `VariantStyle`, with the
   *current* style passed as a placeholder that is **never read at resolution**.
4. **Variant merge always applies after base.** `mergeActiveVariants`
   (`core/style.dart:141-156`) seeds `mergedStyle = this` (all explicit props), then for each
   active variant does `mergedStyle = mergedStyle.merge(variantStyle)`. `ContextVariantBuilder`
   is always active (`core/style.dart:98`), evaluated via `variant.build(context)` =
   `fn(context)` (`core/style.dart:115`, `variant.dart:174`); its produced props are appended
   **after** the base sources → builder wins. The placeholder style is discarded.
5. **Priority sort.** Only `WidgetStateVariant` is lifted to apply last
   (`core/style.dart:103`). `ContextVariant`, `NamedVariant`, and `ContextVariantBuilder` share
   priority 0 and keep insertion order (stable sort).
6. **Resolve.** `Prop.resolveProp` (`core/prop.dart:212`): plain values → last source wins;
   Mix values → accumulate then resolve (per-subfield last wins). `.color()` is a Mix source
   inside `$decoration` (`decoration_style_mixin.dart:18`), so "builder color beats base color"
   happens via accumulation, but the deciding factor is still **source order in the list**.

Net: builder-produced props are always appended after base props, so **`onBuilder` output
unconditionally overrides explicit props regardless of chain position.**

### The impossibility (why no single-bag fix works)

- Example A final state: `{$decoration: red, $variants:[CVB(fn)]}`.
- Example B final state: `{$decoration: red, $variants:[CVB(fn)]}` (placeholder differs but is
  ignored at resolve).

They are identical. "Builder over base" → builder wins for both. "Builder under base" → base
wins for both. Source order requires **different** answers for A and B. Therefore **true source
order is unachievable without recording call position** — i.e. it needs ordered layers. This is
the proof that smaller-than-rearchitecture options are insufficient *if* source order is the goal.

### Behavior table (current)

| Chain | Today | Source-order expectation |
|---|---|---|
| `onBuilder(X)` then `.color(red)` (A) | builder X wins | red wins ✗ |
| `.color(red)` then `onBuilder(X)` (B) | builder X wins | builder X wins ✓ |
| `onBuilder(A)` then `onBuilder(B)` | B wins | B wins ✓ |
| `onBuilder(X)` + `onDark(Y)` (dark) | insertion order among priority-0; later wins | later wins ✓ |
| `onBuilder(X)` + `onHovered(Y)` (hovered) | hovered wins (priority) | ambiguous |

Tests today only assert that `onBuilder` *creates* a `ContextVariantBuilder` and receives
context (`test/src/variants/variant_mixin_test.dart:185-211`). **No test pins precedence vs an
explicit prop.** The semantics are de-facto undocumented.

---

## Design Options

### 1. Keep `onBuilder` as a variant; document variant precedence
- **Summary:** No behavior change. Define officially: "`onBuilder` is an unconditional dynamic
  variant; it applies after base props and merges last among priority-0 variants. To let an
  explicit value win, put it inside the builder or after via another builder." Add tests + docs.
- **Affected:** docs; `test/src/variants/variant_mixin_test.dart`; doc-comment at
  `variant_style_mixin.dart:67`.
- **Benefits:** zero risk; keeps the `on*` family coherent (same as `onDark`/`onHovered`);
  smallest possible change.
- **Risks:** Example A stays surprising; "later explicit call wins" intuition unmet for whole-style builders.
- **Compatibility:** fully compatible (formalizes current behavior).
- **Verdict:** **Recommend** (for `onBuilder` itself).

### 2. Ordering metadata so `onBuilder` merges by fluent call order
- **Summary:** Stamp a monotonic sequence index on each setter and each builder; interleave at merge.
- **Affected:** `Style` core, every setter in every generated styler, `merge`, generator.
- **Benefits:** true source order.
- **Risks:** props are coalesced into typed fields — there is no per-call slot to attach an index
  to without also de-coalescing props. Collapses into Option 4 in practice. High churn, fragile.
- **Compatibility:** behavior-changing; large generated diff.
- **Verdict:** **Reject** (degenerates into Option 4).

### 3. Represent `onBuilder` as a deferred, source-ordered style layer (not a variant)
- **Summary:** Give `Style` an internal ordered list that interleaves *eagerly-resolved prop
  segments* and *context builders*. `onBuilder` seals the current segment and starts a new one;
  later setters accumulate into the new top segment. Build = fold left in order, evaluating
  builders against context inline. Conditional variants (`onDark`, state) stay as today.
- **Affected:** `core/style.dart` (new layer list + `build`/`mergeActiveVariants`), generated
  `merge` (must carry/merge the segment list), `variant_style_mixin.dart`.
- **Benefits:** satisfies A *and* B; honors source order for whole-style builders; conditional
  variants unchanged.
- **Risks:** real (if contained) core change; generator update; introduces a second composition
  axis (ordered segments vs keyed variants) that must be explained.
- **Compatibility:** behavior-changing for chains mixing `onBuilder` with later explicit props
  (A flips from builder→red). Public `onBuilder` signature unchanged.
- **Verdict:** **Recommend as fallback** (only if maintainers require source order for
  whole-style builders).

### 4. General internal style-layer model (replace prop-bag + variant-list with ordered deltas)
- **Summary:** Model a styler as an ordered list of typed deltas; variants and builders are
  first-class ordered entries; fold left at build.
- **Affected:** `Style`, `Prop` interplay, all generated stylers, generator, large test surface.
- **Benefits:** one uniform ordering model for everything.
- **Risks:** broad rearchitecture; high regression surface; explicitly disfavored by constraints.
- **Compatibility:** widely behavior-changing.
- **Verdict:** **Reject** (over-engineering for this problem).

### 5. Mapped token/property sources for token-derived *values* (no style-producing `useToken`)
- **Summary:** Add a `Prop` source that maps a resolved token (or context) through a function to a
  **single field value**, e.g. `.color(context($primary, (c) => c.withOpacity(.5)))`. It lives in
  that field's `Prop.sources` at call position, so it obeys the existing last-source-wins order
  for free.
- **Affected:** `core/prop_source.dart` (+1 source type), `core/prop.dart` `resolveProp`
  (`:212`), small surface; **no `onBuilder`/variant change**.
- **Benefits:** smallest change that gives *real* source order for the token use case;
  `.useToken(...).color(red)` → red wins **by construction**; no new ordering axis.
- **Risks:** only covers single-field derivations, not arbitrary multi-field styles; needs a
  context-aware source variant if non-token context is wanted.
- **Compatibility:** purely additive.
- **Verdict:** **Recommend** (this is the right home for `useToken`).

### 6. Narrow `useToken` as sugar over `onBuilder`, no `onBuilder` change
- **Summary:** `useToken(token, (v) => Style)` = `onBuilder((c) => fn(resolve(token,c)))`.
- **Affected:** one mixin method.
- **Benefits:** trivial.
- **Risks:** inherits `onBuilder`'s variant precedence → fails the `.useToken(...).color(red)` →
  red-wins expectation; ships the surprise into the token API.
- **Compatibility:** additive.
- **Verdict:** **Reject** as the primary `useToken`; acceptable only as an explicit
  *variant-precedence* convenience clearly named as such.

---

## Recommendation

**Primary (hybrid): Option 1 for `onBuilder` + Option 5 for token-derived values.**

1. **`onBuilder` = unconditional variant precedence.** Formalize, test, and document that a
   whole-style context builder applies **after** base props and merges **last among priority-0
   variants** (before `WidgetStateVariant`). Do **not** make it source-ordered. Rationale:
   - It is impossible to honor source order for whole-style builders without ordered layers
     (proof above); the constraints disfavor that rearchitecture unless the need is proven.
   - `onBuilder` belongs to the `on*` family (`onDark`, `onHovered`): all are dynamic overrides
     applied after base. Making *only* `onBuilder* source-ordered fractures that mental model.
   - The dominant real pattern is "compute from context, override base" (Example B), which
     variant precedence already gets right.

2. **Route the genuine source-order need to where it is cheap and correct — values, via
   `useToken`/mapped sources (Option 5).** Token-derived single values participate in the
   existing `Prop` last-source-wins model, so they "just work" with fluent order, including
   `.useToken(...).color(red)` → red wins.

This is the smallest coherent change, preserves all public API behavior, keeps the variant family
consistent, and still delivers ordered semantics where users actually feel them (tokens).

**Fallback: Option 3 (deferred source-ordered layer for `onBuilder`).** Adopt only if maintainers
decide whole-style context builders MUST honor source order (Example A must yield red). It is the
*only* viable way to get there; keep the public `onBuilder` signature, deprecate its
variant-bucket placement internally, and ship behavior-change notes (A flips).

---

## `useToken` Implications

The `onBuilder` decision defines `useToken`:

- Because `onBuilder` is **variant precedence**, `useToken` must **not** be plain sugar over it
  (Option 6) if we want token-derived values to obey fluent order. Use the **value/mapped-source**
  form (Option 5):

  ```dart
  // value form — source-ordered, last fluent call wins
  BoxStyler()
    .color(useToken($primary))                 // injects token-derived Color source
    .color(Colors.red);                        // later → red wins (Prop last-source-wins)

  BoxStyler()
    .color(Colors.red)
    .color(useToken($primary, (c) => c));      // later → token wins
  ```

  Here `useToken(...)` yields a field value (a `Color`/`Prop<Color>`), not a `Style`, so it slots
  into `$decoration`'s `Prop.sources` at call position and inherits ordering for free.

- If a **whole-style** token-derived form is also wanted
  (`useToken($primary, (c) => BoxStyler()...)` returning a `Style`), define it explicitly as
  variant-precedence sugar over `onBuilder` and **name/document it as such**, so users are not
  surprised that a later explicit prop does *not* beat it. Prefer steering users to the value form.

- Under the **fallback (Option 3)**, both forms can be source-ordered, and `useToken` can simply be
  sugar over the deferred-layer `onBuilder` uniformly.

---

## Migration Plan

- **Primary path is additive / non-breaking.**
  - Option 1: documentation + new tests only; no runtime change.
  - Option 5/`useToken`: new API surface; nothing removed.
- **Fallback (Option 3) is behavior-changing** for chains that place explicit props *after* an
  `onBuilder` (Example A flips builder→explicit). Migration:
  1. Land the ordered-layer engine behind the existing `onBuilder` signature.
  2. Add a CHANGELOG "behavior change" entry + a `mix_lint` advisory for
     `onBuilder(...).<setter>(...)` chains whose result changes.
  3. Optionally gate with a transitional flag or a `onBuilderVariant(...)` escape hatch preserving
     old precedence for one minor cycle.
- Either way: no public signatures change; generated-styler API is untouched under Primary.

---

## Test Plan

Concrete cases (add to `test/src/variants/` and `test/src/core/`, using `resolvesTo` +
`MockBuildContext`):

1. **`onBuilder` before explicit prop** — `onBuilder(blue).color(red)`: assert the *documented*
   winner (Primary: builder/blue; Fallback: red). This is the case that pins the decision.
2. **`onBuilder` after explicit prop** — `.color(red).onBuilder(blue)`: builder/blue wins (both
   models agree).
3. **Multiple `onBuilder` calls** — `onBuilder(A).onBuilder(B)`: B wins; assert insertion order
   preserved across `merge`.
4. **`onBuilder` + context variant** — `onBuilder(X).onDark(Y)` in dark + light: verify relative
   precedence and that priority-0 insertion order holds.
5. **`onBuilder` + `WidgetStateVariant`** — `onBuilder(X).onHovered(Y)` hovered/!hovered: confirm
   state variant still applies last (priority), independent of chain position.
6. **Nested styles containing `onBuilder`** — a builder that itself returns a style with
   `.onHovered(...)`/`.onBuilder(...)`: confirm recursion via
   `mergeActiveVariants` (`core/style.dart:151`) resolves nested variants.
7. **Builder context access** — builder reads `MediaQuery`/token and produces values; assert
   resolved output (guards the always-active evaluation at `core/style.dart:98`).
8. **`useToken` value form ordering** — `.color(useToken($primary)).color(red)` → red;
   `.color(red).color(useToken($primary))` → token. (Option 5.)
9. **`useToken` token resolution** — token resolves from `MixScope`; changing scope changes output.
10. **Generated styler coverage** — repeat 1/2/3 for `TextStyler`, `IconStyler`, `FlexBoxStyler`
    to prove the rule is generator-wide, not Box-special.
11. **Merge associativity** — `(a.merge(b)).merge(c)` vs `a.merge(b.merge(c))` for chains with
    `onBuilder` produce equal resolved specs.
12. **Equality/identity** — two `onBuilder`s with distinct closures stay distinct variants
    (`mergeKey` = `fn.hashCode`, `variant.dart:171`); same closure instance collapses (document).

---

## Open Questions (maintainer decisions)

1. **The core call:** should whole-style `onBuilder` honor source order (adopt Fallback/Option 3),
   or stay variant-precedence (Primary/Option 1)? Everything else follows from this.
2. **`useToken` shape:** value/mapped-source form (recommended), whole-style form, or both? If
   both, what are the precedence guarantees of each, and how are they named to avoid surprise?
3. **`onBuilder` vs `WidgetStateVariant`:** keep state variants strictly highest priority even when
   `onBuilder` is later in the chain? (Current: yes.)
4. **Naming for explicit precedence:** if both ordered and variant-precedence builders exist, what
   are they called (`onBuilder` vs `onBuilderVariant`/`buildStyle`)?
5. **`ContextVariantBuilder` keying:** `fn.hashCode` collapses identical closures and never merges
   distinct ones — acceptable, or move to identity/explicit keys?
6. **Dead placeholder:** the `this` style stored in `onBuilder`'s `VariantStyle`
   (`variant_style_mixin.dart:70`) is ignored at resolve but affects `VariantStyle` equality —
   clean it up or repurpose it (it already captures the pre-builder prefix, useful for Option 3)?

---

## Success-criteria answers

- **Where `onBuilder` sits in merge order:** today, always after base props, last among priority-0
  variants, before `WidgetStateVariant`. Recommended to keep (Primary) and document.
- **Source order vs variant priority:** for whole-style builders → **variant priority** (Primary),
  because source order is unachievable without ordered layers; for token-derived **values** →
  **source order** via mapped `Prop` sources.
- **Is `useToken` implemented through `onBuilder`?** No (Primary). Implement it as a value-level
  mapped source so it inherits fluent ordering. A whole-style variant-precedence sugar over
  `onBuilder` may exist but should be named/documented distinctly.
- **Is a narrow fix enough?** Yes — Primary (docs+tests for `onBuilder`, value-level `useToken`) is
  additive and non-breaking. A broad change is only needed if source order for whole-style builders
  is mandated (Fallback).
- **What could break:** nothing under Primary; under Fallback, chains with explicit props placed
  after `onBuilder` change winner (Example A).
- **What tests prove it:** the table-driven cases above, especially #1/#2 (the deciding pair),
  #5 (state-variant priority), #8 (`useToken` ordering), and #10 (generator-wide).