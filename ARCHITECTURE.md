# Mix decision log

Dates below identify implementation or the original decision record; pending
status is explicit. Current behavior was checked on 2026-10-30. The
[README](README.md#core-concepts) introduces the model, and the portable
[architecture reference](skills/mix/references/architecture.md) maps resolution.
Contracts, API guides and runbooks remain separate and are linked from entries.

## Immutable style values

**2026-04-16 · Implemented · [#901](https://github.com/btwld/mix/pull/901)**

Fluent methods return new merged stylers so shared bases can be reused without
setters changing other call sites. Specs are immutable resolved data, but Props
defer resolution and Mix values accumulate fields, so a later partial setter
need not erase an earlier field and caller-owned collections are not promised
to be deeply immutable.

## Explicit scope inheritance

**2026-05-19 · Implemented · [#914](https://github.com/btwld/mix/pull/914)**

A plain nested `MixScope` shadows its ancestor; use `MixScope.inherit` for
partial overrides so feature themes can preserve surrounding values. Callers
must choose the composition boundary explicitly or omitted ordinary tokens
become unresolvable; see [scope and theming](packages/mix/doc/mix-scope-and-theming.md).

## Context-backed token defaults

**2026-06-17 · Implemented · [#938](https://github.com/btwld/mix/pull/938)**

`ContextToken` computes a default without a scope, with an explicit scope value
taking precedence, so context-derived styling can work without theme setup.
Ordinary tokens still require values, and ergonomic `call()` references support
only known shapes: arbitrary custom types need explicit resolution or
`Prop.token`, as described in [token migration](packages/mix/doc/token-migration-guide.md).

## Variant priority follows declared state dependencies

**2026-08-10 · Implemented · [#1016](https://github.com/btwld/mix/pull/1016)**

Merge active patches without declared widget-state dependencies first, then
state-dependent patches, preserving declaration order within each group so
interaction overrides remain predictable. This replaces class sorting but
requires custom variants to declare dependencies correctly, including delegated
reads such as `NotVariant`. `StyleVariation` results skip recursive variant
merging; see [variants](skills/mix/references/variants.md).

## Modifier ordering can be inherited

**2026-10-14 · Implemented · [#963](https://github.com/btwld/mix/pull/963)**

Choose style-local ordering, then the nearest scope's order, then the package
default, appending remaining configured types stably so applications can set
shared wrapper behavior while styles retain control. Order changes semantics
such as clipping versus padding; the resolved list is outermost to innermost,
and rendering wraps it in reverse. See the
[modifier reference](skills/mix/references/widget-modifiers-directives.md).

## Keep the unnamed MixWidget constructor

**2026-07-11 · Implemented · [#968](https://github.com/btwld/mix/pull/968)**

Keep the unnamed constructor alongside enum-named constructors so runtime
selection can stay on the generated wrapper and existing calls remain valid.
This retains a larger public surface; revisit it only if the constructor's
existence causes a concrete problem, rather than a preference for named-only
widgets. Generation rules remain in the [constructor guide](guides/mix-widget-variant-constructors.md).

## Select one recipe style rather than registering every variant

**2026-07-28 · Recorded, implemented · [#1000](https://github.com/btwld/mix/pull/1000)**

Pass the variant into a recipe that builds one style and uses an exhaustive enum
switch; the rejected registration API built N styles and discarded N−1 per
parent rebuild, replacing compile-time exhaustiveness with runtime failure.
Recipes therefore own selection, and their plain enums need no runtime Mix
mixin; widget-state resolution does not rerun the recipe. Both versions of
[#999](https://github.com/btwld/mix/pull/999) were closed unmerged.

## Discover constructors from the explicit variant parameter

**2026-07-28 · Recorded, implemented · [#1000](https://github.com/btwld/mix/pull/1000)**

Use the named, nonnullable enum parameter literally called `variant`, rather
than convention lookup that could silently alter existing APIs; other enums
stay parameters, avoiding size×variant constructor multiplication. This leaves
a magic name: a marker override is deferred until a consumer needs a different
name, and per-value filtering until shared enums need different subsets.
Accessible constants, copied docs/deprecations and collision suppression are
specified in the [constructor guide](guides/mix-widget-variant-constructors.md).

## Remove recipe parameter curation

**2026-07-28 · Decided, unimplemented · [#1000](https://github.com/btwld/mix/pull/1000)**

The proposal removes `factoryParameters` and renames `widgetParameters` to
`targetParameters` because authors own recipe signatures but not target APIs,
removing silent constructor loss when curation omits `variant`. It costs a
breaking API change and removes hidden optional inputs and the recipe-side
collision escape hatch; authors would rename or split recipes, with Remix Avatar's hidden
`fallbackLength` input still the recorded outstanding input that could alter the
proposal. Both old knobs remain in source as of 2026-10-30, and the expired beta
target does not establish implementation or cancellation.

## Grid patches change geometry only

**2026-08-19 · Implemented · [#1031](https://github.com/btwld/mix/pull/1031)**

Limit local-constraint patches to geometry, require bounded fractional axes,
and support content sizing for rows rather than columns, keeping arbitrary
style effects out of layout measurement. Auto rows may measure short siblings
twice; fixed cells avoid speculative measurement, so callers choose tracks
with these costs in mind. Keep the full [Grid contract](packages/mix/doc/grid-layout.md)
for validation, interpolation and unsupported features.

## Protocol composition is explicit and immutable

**2026-08-17 · Implemented · [#1027](https://github.com/btwld/mix/pull/1027)**

Keep the singleton core-only and extend it with explicit immutable vocabulary
composition, avoiding import side effects and mutable global registration.
Consumers must select a composition and handle unsupported values: encoding
fails loudly, with strict decoding by default and bounded lenient recovery.
The [wire contract](packages/mix_protocol/WIRE_CONTRACT.md) and
[integration guide](packages/mix_protocol/GUIDE.md) own the detailed rules.

## Derive schemas from field codecs

**2026-09-09 · Implemented · [#1037](https://github.com/btwld/mix/pull/1037), [#1040](https://github.com/btwld/mix/pull/1040)**

Field codecs own runtime and schema semantics, and JSON Schema is derived,
avoiding a second semantic model that could disagree with decoding.
Checked-in schemas and boundary fixtures receive independent Ajv validation,
at the cost of a generation and validation step; commands remain in the
[Protocol README](packages/mix_protocol/README.md).

## Keep the chart renderer private

**2026-07-23 · Implemented · [56654fd3](https://github.com/btwld/mix/commit/56654fd3)**

Mix owns chart models, callbacks, semantics and stylers, with `fl_chart` private
and no raw renderer-config escape hatch, isolating consumers from backend APIs.
The cost is a smaller supported feature surface, including root-only semantics
without per-mark geometry; current limits remain in the
[chart README](packages/mix_chart/README.md).

## Keep chart serialization optional

**2026-08-17 · Implemented · [#1027](https://github.com/btwld/mix/pull/1027)**

Put chart serialization in `mix_chart_protocol` because Dart has no optional
package dependencies, so rendering apps avoid codecs. Apps crossing JSON must
add the sidecar and choose a composition; the
[sidecar README](packages/mix_chart_protocol/README.md) records usage and its
independent unpublished status.

## Winds compiles both style and runtime layout

**2026-09-09 · Implemented · [#1037](https://github.com/btwld/mix/pull/1037)**

The compiler owns Mix styler output and a typed layout plan that widgets
evaluate against live constraints, avoiding a second class-string interpreter.
JSON remains a consumer boundary rather than an internal representation, and
encoding a styler alone loses behavior requiring widget runtime. Flutter's
layout limits CSS parity; the [adaptation guide](packages/mix_winds/FLUTTER_ADAPTATIONS.md)
preserves the accepted gaps and measurement costs.
