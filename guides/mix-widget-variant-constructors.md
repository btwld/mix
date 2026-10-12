# `@MixWidget` variant constructors — design decisions

Status of record: §1–§4 are settled and describe shipped behavior. §5 is decided
but not yet implemented — one input from the Remix team is outstanding.

This document exists so a future simplification pass does not re-derive — and
re-litigate — choices that were made deliberately. Each rejected alternative
lists *why* it was rejected, not just *that* it was.

## 1. The shipped behavior

Introduced by PR #968 (`2524b74ad`, 2026-07-11). Published in
**`mix_generator 2.2.0-beta.2`**.

A recipe **function** that declares an enum parameter named `variant` generates
one named constructor per enum value, **in addition to** the unnamed
constructor.

```dart
enum FortalButtonVariant { solid, soft, outline }

@MixWidget(target: RemixButton.new)
ButtonStyler fortalButtonStyle({
  FortalButtonVariant variant = .solid,
  FortalButtonSize size = .size2,
}) => switch (variant) { .solid => ..., .soft => ..., .outline => ... };
```

Generates all of:

```dart
FortalButton.solid(size: .size3, label: 'Save')   // one per enum value
FortalButton.soft(label: 'Save')
FortalButton(variant: someKnob, label: 'Save')    // dynamic selection
FortalButton(label: 'Save')                       // recipe default (.solid)
```

### Conditions for generation

All five must hold:

1. The recipe is a **function** — a top-level variable has no parameters, so it
   generates no variant constructors.
2. The parameter is named **exactly `variant`**.
3. The parameter is **named**, not positional.
4. The parameter type is a **non-nullable enum**.
5. The parameter survives `factoryParameters` curation (see §5 — this condition
   is proposed for removal).

Explicitly **not** required:

- The parameter need **not** be `required`. Optional and defaulted both work,
  and detection does not branch on it.
- The enum need **not** mix in `EnumVariant`, `NamedVariant`, or anything else.
  A plain Dart enum is correct. **Do not add an `EnumVariant` check here.** On
  this path the enum is only a `switch` key inside the recipe; the value never
  enters Mix's variant system. The `EnumVariant` requirement in the rejected
  design (§3) existed solely because that design applied the value through
  `applyVariant`, which needs a `NamedVariant`.

### Which enum values become constructors

Every constant that is public, or declared in the same library as the recipe.
There is no per-value opt-in — **the enum's membership is the selection list**.
Additionally:

- `///` doc comments on constants are copied onto the matching constructor.
- `@Deprecated('...')` is copied onto the constructor (still generated, marked).
- If any value's name collides with a generated widget type parameter, **all**
  variant constructors are suppressed. This silent degradation is deliberate:
  emitting them would produce invalid Dart, and failing would break a
  previously-working build.

Only the parameter named `variant` drives constructors. Other enum parameters
(`size`, etc.) stay ordinary parameters. There is no cross-product
(`.solidSize2()`) — six variants times three sizes is eighteen constructors.

## 2. Decision: the unnamed constructor stays

Issue #998 asked for named-*only* widgets — no unnamed constructor, no public
`variant:` argument, no public `variant` field. **Declined.**

Reasons:

- PR #968 preserved the unnamed constructor as an explicit non-breaking
  guarantee. That reason still holds.
- **Dynamic selection needs it.** When the variant comes from state, config, or
  a UI control, no named constructor can be chosen at compile time. Without the
  unnamed constructor the caller must abandon the generated wrapper and drop to
  the raw target widget with a hand-built style. Remix measured this at **16
  call sites** in their own migration report — it is not hypothetical.
- Both spellings coexist without cost. Nothing forces a call site to use the
  unnamed form.

What would reopen this: a concrete case where the unnamed constructor's
*existence* causes a real problem, rather than a preference for a smaller
public surface.

## 3. Decision: no runtime variant API in `packages/mix`

PR #999's first implementation added `@MixWidget(variants:)`, plus
`variantsFromEnum` and `applyVariant` in `packages/mix`. **Rejected.** Neither
was ever published; `packages/mix` requires no change for variant constructors.

The defect was an inverted data flow:

- **Parameter form (kept):** variant goes *in* → one style comes *out*. Builds 1.
- **Registration form (rejected):** a style comes out carrying *all N* variants
  → the widget narrows to one. Builds N, discards N−1.

A six-variant button rebuilt six stylers and discarded five. The proposed fix
was a lazy, memoizing `VariantStyle`, which required a determinism contract on
the builder and a documented caveat for `inheritable: true` styles. That is a
patch on the inversion, not a fix for it — and unnecessary, since the parameter
form already builds exactly one.

Two secondary advantages of the parameter form:

- **Exhaustiveness is compile-time.** `switch (variant)` over an enum with no
  `default` is analyzer-enforced. `applyVariant`'s runtime `StateError` is
  strictly weaker.
- The enum needs no mixin (see §1).

### Frequency, for the record

The rebuild cost above is **per parent rebuild, not per frame**. Widget-state
changes (hover, press) rebuild *inside* `StyleBuilder` via `WidgetStateProvider`
and re-run `style.build(context)` on the existing style object; they do not
re-invoke the recipe. The recipe re-runs only when the generated widget's own
`build()` runs.

Style equality — which would force materialization of a lazy variant — is
reached from exactly one place in `packages/mix/lib/src`:
`StyleProvider.updateShouldNotify`, and only for `inheritable: true`.

## 4. Rejected: convention-based and marker-based discovery

- **Discover the enum by naming convention** (`<WidgetName>Variant` in the same
  library), as #998 proposed: rejected. It is not opt-in — an existing user with
  a matching enum beside their recipe would silently lose the unnamed
  constructor on upgrade, with no source change on their side.
- **An explicit `@MixWidgetVariant` marker** on the parameter: deferred, not
  refused. It would close a real gap — the name `variant` is magic, so `kind`,
  `appearance`, or a typo produces no constructors and no diagnostic. Deferred
  because no consumer needs a different name today, and adding it now means two
  discovery paths for one mechanism. If added later, it should be a *discovery
  override on the same mechanism* (like `MixWidget.name` overrides the derived
  class name), never a parallel path.
- **Per-value constructor selection** (`.only({'solid', 'soft'})`): rejected as
  premature. If a value should not be constructible, the question is why it is
  in this widget's variant enum — the recipe's `switch` must handle it anyway.
  One enum per widget's variant domain is the intended shape. Revisit only if a
  single enum is genuinely shared across widgets with differing subsets, and
  validate names against the enum so a typo fails loudly.

## 5. DECIDED, not yet implemented: remove `factoryParameters`

Breaking changes are acceptable on the 2.2.0-beta line. Target release:
`mix_generator 2.2.0-beta.3` / `mix_annotations 2.2.0-beta.2`.

One input outstanding before implementing — see "Outstanding input" below.

### The decision

`@MixWidget` currently has two curation knobs:

| Knob | Curates | Introduced |
|---|---|---|
| `widgetParameters` | the styler `call()` / target constructor parameters | PR #974 (`8c26ad6ce`) |
| `factoryParameters` | the **recipe function's own** parameters | PR #997 (`726d85e84`) |

**Remove `factoryParameters`**, and **rename `widgetParameters` to
`targetParameters`**.

The rationale: a recipe function's parameters *are* the recipe's API, authored by
the same person writing the annotation. If a parameter should not reach the
widget, it should not be a parameter. Curation earns its place on the surface the
author does **not** own — the target widget's constructor. That was the original
design intent; `factoryParameters` arrived later, bundled into a different
feature.

The rename follows from the removal. While two knobs exist, `widgetParameters` is
a reasonable name. Once it is the only one, it is misleading — recipe parameters
also become widget parameters yet are not curated by it. `targetParameters` names
the surface it actually curates and pairs with the `target:` field.

Resulting rules:

- All recipe function parameters are always exposed on the generated widget.
- `variant` is always handled automatically: pinned by (and omitted from) each
  named constructor, exposed on the unnamed constructor. It never needs to be
  listed anywhere, and condition 5 in §1 disappears.
- Only target-constructor / `call()` parameters can be curated.

### What it fixes

The silent-failure gotcha: today, `factoryParameters: .only({'size'})` that
omits `'variant'` produces **zero variant constructors with no error**. Remix hit
exactly this on one component. Removing the knob removes the failure mode by
construction rather than by documentation.

### What it costs — accepted knowingly

- **A breaking change** to an API published in `mix_generator 2.2.0-beta.2`.
  Accepted: the 2.2.0-beta line is opt-in and pre-stable.
- **It removes one escape hatch for name collisions.** When a recipe parameter
  and a target parameter share a name with incompatible types, the generator
  today says *"exclude the parameter from either `factoryParameters` or
  `widgetParameters`"*. Afterwards only the target side can be excluded.
  Accepted deliberately: the author controls the recipe's parameter names and can
  rename to resolve the collision; they do not control the target widget's. The
  remaining hatch is on the surface that needs one.
- Recipes that legitimately take more parameters when called directly than they
  want to expose as widget fields lose that flexibility. Accepted: split the
  recipe, or compute the extra input internally.

Note that the generator **already refuses** to curate away a *required* factory
parameter. Only optional ones can be hidden today, so this removes less than it
appears to.

### Outstanding input

**Remix's Avatar** uses `factoryParameters: .only({...})` to keep an internal
`fallbackLength` parameter off the widget. Removing the knob forces it onto the
public widget surface, or forces a recipe-signature change. Their answer is the
one input that could still alter this design — implement after it arrives.

### Recorded reading of "always omit the variant"

*The named constructors omit `variant` because they pin it; the unnamed
constructor still exposes it; it is never subject to curation.* That is
consistent with §2. It does **not** mean removing `variant` from the widget's
public surface — that is the named-only design declined in §2.

## 6. History

| Ref | What |
|---|---|
| #968 `2524b74ad` | Variant constructors from a `variant` enum parameter. Unnamed constructor preserved. |
| #974 `8c26ad6ce` | `widgetParameters` curation. |
| #997 `726d85e84` | Direct `target:` support; added `factoryParameters`. |
| #998 | Requested named-only widgets + convention discovery. Closed; core ask declined (§2). |
| #999 | Two implementations, neither merged: first the registration design (§3), then, after a force-push, a named-only parameter-based design (§2). Closed unmerged. |
