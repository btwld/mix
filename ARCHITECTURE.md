# Mix architecture and decisions

The [README](README.md#core-concepts) introduces the public concepts. This page
records current boundaries and the reasons a maintainer might otherwise lose.
Keep entries titled and short: status, date or PR, choice, rationale, and cost.
Update status and link the replacement when a decision changes. API walkthroughs
belong in package guides; routine reversible edits do not need an entry.

## Current map

- `packages/mix/lib/src/core/`: `Style`, `Spec`, `Prop`, resolution and rendering.
  Stylers return new merged values; `StyleBuilder` resolves active variants and
  properties into a `StyleSpec`, then animation and modifiers wrap rendering.
- `packages/mix/lib/src/theme/`: token identity, context defaults and `MixScope`.
- `packages/mix/lib/src/layout/`: owned layout primitives, including Grid.
- `mix_annotations` and `mix_generator`: typed spec/styler/modifier plumbing and
  recipe widgets. Generated files are outputs, not the authoring surface.
- `mix_protocol`: optional JSON boundary; `mix_chart_protocol`: chart vocabulary.
- `mix_winds`: Tailwind compiler producing stylers and typed Flutter layout plans.
- `mix_chart`: public chart models and styling, with a private renderer.

## Immutable style values

**Implemented — [#901](https://github.com/btwld/mix/pull/901).** Fluent methods
return new merged stylers, so a shared base can be reused without a setter
changing another call site. Specs are immutable resolved data; plain property
values replace while Mix values accumulate fieldwise, which costs deferred
resolution and means a later partial setter need not erase an earlier field.
This does not promise deep immutability of caller-owned collections.

## Variant and modifier ordering

**Implemented — [#1016](https://github.com/btwld/mix/pull/1016),
[#963](https://github.com/btwld/mix/pull/963).** Active variants are grouped by
declared widget-state dependencies, with state-dependent patches last and
stable declaration order within each group. This keeps interaction overrides
above context patches without a class-name priority table; custom variants must
declare their dependencies correctly, and `StyleVariation` results are resolved
without recursively merging their own variants.

Modifier order is style-local, then the nearest `MixScope`, then the package
default, with remaining configured types appended stably. The resolved list is
outermost to innermost and rendering wraps in reverse; changing order changes
semantics such as clipping versus padding. See the portable
[modifier reference](skills/mix/references/widget-modifiers-directives.md).

## MixWidget variant constructors

**Implemented — 2026-07-11, [#968](https://github.com/btwld/mix/pull/968);
rationale recorded in [#1000](https://github.com/btwld/mix/pull/1000).** Keep the
unnamed constructor alongside enum-named constructors so runtime selection can
stay on the generated wrapper. A recipe parameter selects and builds one style;
the rejected registration API built N styles and discarded N−1 per parent
rebuild, and replaced an exhaustive enum switch with runtime failure.

Only the named, nonnullable enum parameter `variant` drives discovery; no Mix
enum mixin is needed. Convention lookup and named-only widgets from
[#998](https://github.com/btwld/mix/issues/998) risked silent API changes or lost
dynamic selection. Both versions of [#999](https://github.com/btwld/mix/pull/999)
were closed unmerged. There is no size×variant constructor cross-product.
A marker override is deferred until a consumer needs another parameter name;
per-value filtering is deferred until a shared enum with differing subsets is
needed. See the [generation rules](guides/mix-widget-variant-constructors.md).

## Recipe parameter curation

**Decided, unimplemented — [#1000](https://github.com/btwld/mix/pull/1000);
status checked 2026-10-30.** The proposal removes `factoryParameters` and renames
`widgetParameters` to `targetParameters`: recipe authors own their signatures,
while curation is useful for the target API they do not own. It would eliminate
the silent loss of constructors when curation omits `variant`, at the cost of a
breaking API change and the loss of hidden optional inputs and the recipe-side
collision escape hatch; authors would rename or split recipes instead.

Both existing knobs remain in `mix_annotations`; do not use the proposed name
in examples. The recorded blocker is Remix Avatar's hidden `fallbackLength`
input, whose resolution could alter the proposal. The original beta release
target has passed; it is not evidence that this shipped or was canceled.

## Grid layout boundaries

**Implemented — [#1031](https://github.com/btwld/mix/pull/1031).** Local-constraint
patches change geometry only, and fractional tracks require bounded axes.
Rows can size to content; columns cannot. These constraints avoid mixing layout
measurement with arbitrary style effects or speculative measurement of fixed
cells. Auto rows may measure short siblings twice; callers choose fixed tracks
when that cost matters. Keep the detailed [Grid guide](packages/mix/doc/grid-layout.md)
for tracks, unsupported features, animation, and validation rules.

## Protocol composition and schema ownership

**Implemented — [#1037](https://github.com/btwld/mix/pull/1037),
[#1040](https://github.com/btwld/mix/pull/1040), 2026-09-09.** The singleton is
core-only; extensions use explicit immutable vocabulary composition rather than
import side effects or a mutable global registry. Field codecs own runtime and
schema semantics; JSON Schema is derived from them, avoiding a second semantic
model that could disagree with decoding.

Encoding fails on unsupported values; decoding is strict by default with
bounded lenient recovery. Checked-in schemas and boundary fixtures are validated
independently with Ajv, costing a generation and validation step. Detailed
compatibility rules stay in the [wire contract](packages/mix_protocol/WIRE_CONTRACT.md),
with examples in the [guide](packages/mix_protocol/GUIDE.md).

## Chart renderer and optional serialization

**Implemented — [56654fd3](https://github.com/btwld/mix/commit/56654fd3),
[#1027](https://github.com/btwld/mix/pull/1027).** Mix owns chart models, callbacks,
semantics and stylers; `fl_chart` stays private, with no raw renderer config
escape hatch. This isolates consumer APIs from backend changes but limits
features to what the Mix model exposes, including root-only chart semantics.

Serialization lives in `mix_chart_protocol` because Dart has no optional package
dependencies. Rendering apps avoid codec dependencies; apps crossing JSON must
add the sidecar and choose vocabulary composition explicitly. See the
[chart README](packages/mix_chart/README.md) and
[sidecar README](packages/mix_chart_protocol/README.md).

## Winds compiler and Flutter runtime

**Implemented — [#1037](https://github.com/btwld/mix/pull/1037).** The compiler
owns both Mix styler output and the typed layout plan; widgets evaluate that
plan against live Flutter constraints. JSON is an optional consumer boundary,
not an internal representation, and encoding a styler alone cannot preserve
behavior that requires widget runtime. CSS parity remains bounded by Flutter
layout; preserve documented adaptations rather than adding a second interpreter
in widgets. See [adaptations](packages/mix_winds/FLUTTER_ADAPTATIONS.md).
