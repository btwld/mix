# Mix Layout System: Clean-Sheet Exploration

> **Status: spike-validated unbundled direction.** Advanced layout need is
> delivered as independent primitives (`onConstraints`, `WrapBox`, `GridBox`)
> following existing Mix conventions — not as a bundled `MixLayout<Slot>`
> framework. Spike prototypes live under `packages/mix/lib/src/` (Wrap/Grid
> unexported; constraint APIs marked `@internal`) and tests — **not productized**
> (no barrel export of new families, no changelog, no public stabilization).
> `MixLayout<Slot>` remains a considered-and-deferred alternative (see
> [Spike results](#spike-results) and [Decision record](#decision-record)).

**Decision for this change:** retain the existing `FlexBox`, `RowBox`,
`ColumnBox`, and `StackBox` APIs; continue to use Flutter's `Expanded`,
`Flexible`, `Positioned`, and `PositionedDirectional` where needed; leave
`WidgetModifierConfig.flexible` unchanged; and remove the discarded
`FlexItem`/`StackItem` prototype. Productize advanced layout as three
increments — `onConstraints` → `WrapBox` → `GridBox` — not as a single
`MixLayout` host.

## Executive summary

Mix needs better local responsiveness (container queries) and two layout
families that Flex/Stack do not cover: **flow** (Flutter `Wrap`) and **grid**
(tracks + gaps). Spikes showed these can ship as independent, Mix-native
pieces:

```text
onConstraints(Breakpoint, style)   // universal variant — all Stylers
WrapBox + WrapBoxStyler            // Box-family partner over Flutter Wrap
GridBox + GridBoxStyler            // fixed/fr tracks, gaps, auto-place
```

A single `MixLayout<Slot>` host with plan switching remains **deferred**. It
is still documented below as the original clean-sheet model and should be
revisited only if cross-family plan switching (one typed child map switching
between linear/flow/grid/overlay/masonry) becomes a product requirement that
the unbundled pieces cannot express.

Visual styling remains on existing Stylers. Parent-data wrappers stay at the
host-child boundary. Tailwind (`mix_tailwinds`) is the completeness harness:
`@container` / `@max-md:*` → `onConstraints`, `grid-cols-*` / `gap-*` → grid,
`flex-wrap` / `gap-*` → wrap.

## Problem statement

Flutter already provides excellent primitives for common layouts. Mix adds
styling and composition around several of those primitives, but advanced
layouts still require developers to combine:

- nested `Row`, `Column`, `Stack`, `Expanded`, and `Positioned` widgets;
- `LayoutBuilder` branches for locally responsive composition;
- `CustomMultiChildLayout` delegates with important sizing restrictions; or
- custom render objects for child-dependent measurement.

The problem is not to replace Flutter layout. It is to give Mix users one
coherent way to express reusable, token-aware, constraint-responsive layout
geometry when ordinary Flutter composition becomes hard to read or reuse.

The design must answer four questions clearly:

1. Who owns arrangement?
2. How are children identified across different plans?
3. Where do responsive layout decisions run?
4. How can an expert implement child-dependent measurement without escaping
   Mix entirely?

## Goals

- Keep simple layouts simple: `FlexBox` and `StackBox` remain first choices.
- Make advanced layout parent-owned and independent from child internals.
- Preserve child identity when switching between layout plans.
- Support typed, reusable geometry through normal Mix composition.
- Support local responsiveness based on incoming constraints.
- Provide built-in linear, flow, grid, overlay, and finite box-masonry plans.
- Permit child-dependent measurement through a narrow experimental escape
  hatch.
- Share one deterministic computation between live and dry layout.
- Preserve normal Flutter painting, hit testing, semantics, and widget
  lifecycle behavior.
- Produce actionable diagnostics for invalid plans and algorithms.

## Constraints

- Flutter's rule remains fundamental: constraints go down, sizes go up, and
  parents set positions.
- The first implementation targets the `RenderBox` protocol only.
- Layout must work with arbitrary child widgets, including Mix components,
  generated components, pressable components, and third-party widgets.
- Layout geometry must not depend on a visual component exposing its internal
  styled surface.
- Constraint-responsive selection must also be available during dry layout; it
  cannot depend on a layout-time widget rebuild.
- The public model should fit Mix's immutable data, fluent Styler, merging,
  variants, token resolution, and diagnostics conventions.
- A custom algorithm must be reusable and stateless. Per-pass information
  belongs to the layout pass or result, not the algorithm instance.

## Non-goals

The first advanced box-layout API would not attempt to:

- replace `FlexBox`, `StackBox`, or Flutter's ordinary layout widgets;
- reproduce all of CSS Flexbox or CSS Grid;
- place parent-data configuration inside every visual Styler;
- infer a layout from arbitrary widget-tree structure;
- become a general linear or nonlinear constraint solver;
- build or remove widgets during render layout;
- expose arbitrary painting, hit-test, or semantics overrides;
- support slivers or lazy collections;
- animate structural plan changes implicitly.

## Current Mix layout architecture

Mix currently has two useful, explicit parent widgets:

- `FlexBox` combines box styling with Flutter `Flex` arrangement. `RowBox` and
  `ColumnBox` fix the axis.
- `StackBox` combines box styling with Flutter `Stack` arrangement.

Their Stylers configure the parent. For example, `FlexBoxStyler` owns
direction, main-axis alignment, cross-axis alignment, size, and spacing.
`StackBoxStyler` owns alignment, fit, text direction, and clipping. Their
children remain ordinary `List<Widget>` values.

Today, child participation follows Flutter:

```dart
RowBox(
  children: [
    Expanded(child: PrimaryButton()),
    const SizedBox(width: 12),
    Expanded(child: SecondaryButton()),
  ],
);

StackBox(
  children: [
    const Background(),
    PositionedDirectional(
      top: 8,
      end: 8,
      child: const Badge(),
    ),
  ],
);
```

Mix also has the pre-existing `WidgetModifierConfig.flexible`. Its behavior and
compatibility remain unchanged by this exploration.

This architecture is appropriate for ordinary layouts. It does not provide a
reusable representation for a responsive card that changes algorithm, a typed
grid with named areas, or a custom layout where one child's measured size
constrains another.

## Lessons from the discarded boundary-wrapper prototype

The discarded prototype added `FlexItem` and `StackItem` wrappers and a few
CSS-inspired aliases. It produced two useful findings.

### The parent-data boundary finding is valid

Flutter parent-data widgets such as `Flexible` and `Positioned` must be on the
correct path between the matching parent and the complete child component.
Only component widgets may occur between a `ParentDataWidget` and its target
render-object ancestor. Intervening render-object widgets can make the tree
invalid.

A Mix component may put interaction, gesture, focus, semantics, or other
render-object widgets outside its inner visual surface. Therefore, putting flex
or stack participation inside a visual Styler cannot reliably move the whole
component:

```text
Unsafe visual-style interpretation

Flex
  └─ interaction render objects
       └─ Flexible
            └─ visual surface
```

An explicit wrapper in the parent's child list was structurally correct:

```text
Correct parent boundary

Flex
  └─ Flexible
       └─ complete component
            └─ interaction render objects
                 └─ visual surface
```

This remains important evidence. Any future API that relies on Flutter parent
data must install it at the host-child boundary, not inside a visual Styler.

### Correct structure was not enough to justify the product API

The wrappers were safe adapters around existing Flutter widgets, but they did
not establish a distinctive advanced layout model. They also created one item
type per parent, duplicated Flutter constructor semantics, and left grid,
flow, masonry, responsive plan switching, and child-dependent sizing unsolved.
Small aliases improved familiarity but introduced a second vocabulary without
adding capability.

The prototype is therefore discarded as a public direction, not because the
boundary result was wrong. In the recommended model, the advanced parent owns
participation by typed slot, so separate `FlexItem` and `StackItem` wrappers are
unnecessary.

## Research synthesis

### Flutter constraints and `RenderBox`

[Flutter's constraints guide](https://docs.flutter.dev/ui/layout/constraints)
summarizes the protocol as constraints moving down the tree, sizes moving up,
and parents assigning positions. A child must select a size within the
`BoxConstraints` supplied by its parent.

The [`RenderBox` API](https://api.flutter.dev/flutter/rendering/RenderBox-class.html)
turns that model into the render contract. A custom multi-child box lays out
children with chosen constraints, reads a child's size only when it declares
that dependency, constrains its own size, and writes each child's offset into
parent data. Dry layout asks what size the box would choose without mutating
the live render tree.

Implications for Mix:

- The advanced abstraction should be a real box-layout host, not a collection
  of wrappers pretending to be an algorithm.
- Child measurement dependencies must be visible to the host.
- Every returned size must be finite where Flutter requires it and must satisfy
  incoming constraints.
- Dry and live layout cannot use unrelated implementations without risking
  inconsistent answers.

### `CustomMultiChildLayout`

[`MultiChildLayoutDelegate`](https://api.flutter.dev/flutter/rendering/MultiChildLayoutDelegate-class.html)
supports named children, arbitrary layout order, and using one child's measured
size to constrain or place another child. It is a useful conceptual baseline.

It has two decisive restrictions:

- `getSize` cannot depend on child layout information. A layout whose own size
  depends on its children needs a custom render object.
- `performLayout` must lay out every child exactly once.

That is sufficient for leader/follower placement in a parent-sized region, but
not for every shrink-wrapped, child-dependent layout Mix wants to explore.
`MixLayout` should therefore use a dedicated render object rather than merely
wrap `CustomMultiChildLayout`.

### `LayoutBuilder` and dry layout

`LayoutBuilder` is useful when a widget subtree should be rebuilt from incoming
constraints. It is not a suitable foundation for the proposed render contract.

The repository is pinned to Flutter 3.41.7. Inspection of
[that pinned source](https://github.com/flutter/flutter/blob/cc0734ac71/packages/flutter/lib/src/widgets/layout_builder.dart#L421-L430)
confirms that `_RenderLayoutBuilder.computeDryLayout` reports that it cannot
compute dry layout: doing so would require speculatively running the builder
callback, which might mutate the live render-object tree. Its intrinsic methods
have the same fundamental limitation.

Consequences:

- `onConstraints` must not be implemented by inserting a `LayoutBuilder`.
- A resolved layout style must retain its constraint-conditioned plan branches
  as immutable data.
- The render object must select the same branch in live and dry layout from the
  `BoxConstraints` it receives.
- Conditional widgets must be selected during normal build, before layout.

### Boxy

[Boxy](https://pub.dev/packages/boxy) demonstrates the demand for a friendlier
custom-layout layer. Its `CustomBoxy`/`BoxyDelegate` surface supports:

- fetching children by identifier;
- laying out one child and using its result to constrain another;
- choosing the parent size from child measurements;
- positioning children;
- painting behind, between, or in front of children;
- changing paint and hit-test behavior;
- inflating arbitrary widgets during layout; and
- both box and sliver render protocols.

The important lesson is not to clone all of Boxy. Its breadth solves a larger
problem than Mix needs initially. Painting overrides, hit-test customization,
layout-time inflation, and slivers add lifecycle and correctness obligations
that are separable from reusable layout geometry.

The narrower Mix adaptation is:

- preserve named child access and child-dependent measurement;
- make geometry composable through `LayoutStyler`;
- provide first-party plans for common cases;
- keep normal Flutter paint, hit-test, semantics, and build lifecycles; and
- defer layout-time inflation and sliver protocols.

Depending directly on Boxy would expose or wrap a second styling and delegate
model, tie Mix's public behavior to its broad surface, and still require a Mix
layer for tokens, variants, merging, and typed plans. Cloning it would inherit
its maintenance surface. Neither is recommended for the first validation.

### SwiftUI `Layout`, `AnyLayout`, and subview proxies

SwiftUI's [`Layout`](https://developer.apple.com/documentation/swiftui/layout)
protocol separates size calculation from subview placement. Its layout
subviews are proxies rather than the original view values, which lets an
algorithm ask for dimensions without owning or rebuilding those views.

[`AnyLayout`](https://developer.apple.com/documentation/swiftui/anylayout/)
shows another useful property: an application can switch layout algorithms
while preserving the identity and state of the contained subviews.

The Mix adaptation should preserve these ideas:

- algorithms operate on slot-addressed child handles;
- children remain owned by one stable host;
- changing a plan changes geometry, not child identity; and
- algorithms are immutable values rather than stateful delegates.

Mix should not copy SwiftUI's API vocabulary wholesale. Flutter constraints,
dry layout, RenderBox lifecycles, and Dart's type system require a native
contract.

### Jetpack Compose

[Compose custom layouts](https://developer.android.com/develop/ui/compose/layouts/custom)
describe layout as three steps:

1. measure children;
2. decide the parent's size;
3. place children.

Compose also uses scoped measurable/placeable handles and prevents measuring a
child repeatedly in an ordinary pass. This is a strong mental model for a Mix
algorithm even though Flutter's rendering APIs differ.

The proposed `LayoutPass` should make the same phases legible. It should
diagnose missing measurement or placement and should distinguish harmless dry
probes from the final live measurement of a child.

### Grid

A useful grid is much more than dividing width by a column count. It must
define:

- fixed, fractional, and content-sized tracks;
- row and column gaps;
- direction-aware placement;
- named areas and spans;
- how spanning children contribute to track sizes;
- behavior under unbounded axes;
- overflow and clipping behavior; and
- stable dry-layout results.

The first grid plan should be intentionally finite and smaller than CSS Grid.
Typed areas should be rectangular and contiguous, and each present slot should
map to at most one area. Content tracks and spans require a measurement phase;
their exact probe/final-measure rules must be validated before stabilization.

The [`flutter_layout_grid`](https://pub.dev/packages/flutter_layout_grid)
package is useful prior art for track concepts, but dependency reuse should be
decided only after an internal render-contract spike.

### Masonry

Masonry placement depends on measured child extents. A finite box algorithm
can eagerly measure all present children and place each one in the currently
shortest track. That works for dashboards, galleries with bounded item counts,
and design-system compositions.

It does not solve a long, lazily built feed. Lazy masonry needs a sliver
protocol, cache and estimation rules, scroll-offset correction, child
lifecycle management, and performance work. Packages such as
[`flutter_staggered_grid_view`](https://pub.dev/packages/flutter_staggered_grid_view)
illustrate the distinction between finite box layouts and scrollable/lazy
layouts.

The proposed first surface is therefore explicitly **finite box masonry**.

## Approaches considered

| Approach | Boundary safety | Child-dependent parent size | Local responsive plans | Mix fit | Main concern | Decision |
|---|---:|---:|---:|---:|---|---|
| Boundary wrappers | Strong | No | Weak | Moderate | One wrapper vocabulary per parent; little new capability | Discard as the advanced API |
| Visual-Styler layout metadata | Unsafe in general | No | Attractive | Superficial | Cannot reliably wrap the complete component | Reject |
| Boxy dependency | Strong | Yes | Possible | Moderate | Broad external delegate/lifecycle surface | Do not adopt initially |
| Boxy clone | Strong | Yes | Possible | Controllable | Large maintenance and correctness scope | Reject |
| Separate layout widgets | Strong | Varies | Varies | Good | Fragmented APIs and hard plan switching | Keep for simple existing layouts |
| Unified recipe host | Strong | Built-ins only | Strong | Strong | Needs a principled custom escape hatch | Use as the base |
| Recursive blueprint tree | Strong | Yes | Strong | Strong | Duplicates the Flutter widget tree and nesting model | Reject |
| Constraint/anchor graph | Strong | Yes | Strong | Moderate | Cycles, ambiguity, solver diagnostics, and cost | Defer |
| Layout-plan/algorithm model | Strong | Yes | Strong | Strong | Requires a careful render contract | Recommend for validation |

### Boundary wrappers

Wrappers are the right answer when the only goal is installing Flutter parent
data around a complete component. They are not a unified advanced layout
language. Adding more parent types would add more item wrappers, and responsive
switching would often need to switch both parent and wrappers.

The prototype's boundary tests should inform future render tests, but the
wrappers themselves should not ship from this exploration.

### Visual-Styler layout metadata

An API such as `BoxStyler().layout.flex(1)` looks concise but puts parent-owned
geometry on an arbitrary inner visual surface. It is ambiguous under nested
styles and inheritance, cannot reliably surround pressable and interaction
wrappers, and couples a component's internal implementation to its parent.

This approach should not be revisited unless Mix first introduces an explicit
component-host contract capable of safely hoisting layout metadata.

### Boxy dependency or clone

Boxy proves the render model is feasible and offers considerably more than the
initial Mix goal. A dependency would still need a substantial adapter and
would make Boxy's inflation, painting, hit-test, and protocol choices part of
Mix's architectural story. A clone would be an expensive fork of those ideas.

The recommended spike may study Boxy's implementation, tests, and failure
modes, but it should begin with a narrow Mix-owned contract.

### Separate layout widgets

Dedicated `MixGrid`, `MixFlow`, `MixOverlay`, and `MixMasonry` widgets would be
easy to discover independently. They would also create separate constructor,
responsive, identity, custom-algorithm, and styling stories. Switching from a
grid to a linear layout could replace the host widget and disturb state.

Existing `FlexBox` and `StackBox` remain valuable because they are already
simple, direct Flutter adaptations. The advanced layer should not repeat that
fragmentation.

### Unified recipe host

A single host with a sealed set of recipes gives plan switching and identity a
clean home:

```text
same host + same slot map + different plan
```

This is the correct base. On its own, however, a closed recipe set forces every
novel layout into Mix core. The final recommendation adds an experimental
algorithm escape hatch without weakening built-in plan guarantees.

### Recursive blueprint tree

A recursive blueprint could represent rows, columns, overlays, and grids in
one value. It becomes a parallel widget tree: it needs nodes, nesting, keys,
conditionals, diagnostics, identity, and its own composition rules. Developers
would have to reason about both the Flutter tree and the blueprint tree.

Nested `MixLayout` hosts already provide explicit composition when nesting is
needed. A flat plan operating on typed slots is smaller and easier to inspect.

### Constraint or anchor graph

An anchor graph is attractive for relationships such as “badge end equals
avatar end” or “body starts below header.” It quickly introduces under- and
over-constrained graphs, cycles, priorities, solver choices, and difficult
diagnostics. That is a separate product, not a required foundation for grid,
overlay, or child-dependent custom layouts.

The first overlay plan can provide finite host-relative anchors. More involved
relationships can use a custom algorithm while evidence is gathered.

### Layout-plan/algorithm model (historical clean-sheet notes)

The original clean-sheet exploration combined:

- one stable advanced host;
- immutable, mergeable layout geometry;
- typed child slots;
- a finite set of optimized built-in plans; and
- an explicitly experimental custom algorithm.

**Spike evidence superseded that as the primary product path.** The validated
direction is the unbundled increments below; the bundled host is retained only
as a deferred alternative.

## Recommended future model (validated)

### Unbundled primitives are the product path

Ship advanced layout as three independent Mix-native pieces (export order):

1. **`onConstraints`** — universal constraint variant on every Styler
   (container queries; offered `BoxConstraints`, not MediaQuery).
2. **`WrapBox`** — Box-family partner over Flutter `Wrap` (flow).
3. **`GridBox`** — fixed/fr tracks, gaps, row-major auto-place first;
   spans/areas later.

Simple rows and stacks continue to use `RowBox`, `ColumnBox`, `FlexBox`, and
`StackBox`. Parent-data wrappers (`Expanded`, `Positioned`, …) stay at the
host-child boundary. Visual styling stays on existing Stylers.

See [Spike results](#spike-results) for gates and evidence.

### Deferred alternative: `MixLayout<Slot>` (not v1)

`MixLayout<Slot>` remains a **considered-and-deferred** model for
cross-family plan switching with typed child identity. Revisit only if the
unbundled pieces cannot express a product need for one host that switches
among linear / flow / grid / overlay / masonry over one `Map<Slot, Widget>`.

Illustrative (not implemented, not recommended for v1):

```dart
// Deferred alternative — not the product recommendation.
MixLayout<CardSlot>(
  style: cardLayout,
  children: {
    CardSlot.media: const CardMedia(),
    CardSlot.body: const CardBody(),
    CardSlot.actions: const CardActions(),
  },
);
```

If revived, the host would:

- own one multi-child render object;
- resolve `LayoutStyler` with normal Mix theme and contextual inputs;
- retain constraint-conditioned branches for render-time selection;
- associate each child render box with its slot;
- preserve children when the selected plan changes; and
- implement normal Flutter layout, paint, hit-test, and semantics behavior.

The subsections below document that deferred design for completeness; they
are not the recommended product surface.

### `Map<Slot, Widget>` provides child identity

Slots should normally be an enum or another small immutable value:

```dart
enum CardSlot { media, body, actions, badge }
```

A map is preferable to `List<LayoutId>` wrappers because:

- the generic type constrains every identifier;
- the host can receive at most one active widget per slot;
- algorithms address semantic roles rather than list indexes;
- conditional children are natural;
- plan order can differ from source, paint, or semantics order; and
- the same child entries survive plan changes under one host.

The host should snapshot the map's iteration order. That order is the default
paint and semantics order; hit testing visits it in reverse, matching normal
multi-child Flutter behavior. Plan measurement and placement order do not
silently change z-order.

The host should reject a null slot, an unsupported map mutation during build,
or a plan that requires a missing slot. Optional slots must be declared
optional by the plan or algorithm. Map construction itself prevents the host
from receiving duplicate active keys.

Changing children uses an ordinary Flutter rebuild:

```dart
// Proposed API — not implemented.
MixLayout<CardSlot>(
  style: cardLayout,
  children: {
    CardSlot.media: CardMedia(image: image),
    CardSlot.body: CardBody(item: item),
    if (item.isNew) CardSlot.badge: const NewBadge(),
    if (canEdit) CardSlot.actions: EditActions(item: item),
  },
);
```

Keys inside the child widgets retain their normal meaning. The layout
algorithm never creates or removes widgets.

### `LayoutStyler<Slot>` styles geometry only

`LayoutStyler` is not a replacement for `BoxStyler`. It owns:

- the selected layout plan;
- gaps and layout padding;
- alignment and direction-aware geometry;
- tracks, areas, item roles, anchors, and ordering;
- custom algorithm parameters;
- Mix tokens and merge/reset behavior for those values;
- context variants that can be resolved before layout; and
- `onConstraints` branches selected from incoming box constraints.

It does not own:

- colors, decoration, shadows, opacity, or transforms;
- text or icon appearance;
- gesture, focus, hover, or press behavior;
- painting or hit-test overrides; or
- the visual styles of its children.

Visual styling remains explicit:

```dart
// Proposed layout API — not implemented.
Box(
  style: BoxStyler()
      .color(Colors.white)
      .borderRounded(16)
      .shadow(
        BoxShadowMix(
          color: Colors.black12,
          blurRadius: 12,
        ),
      ),
  child: MixLayout<CardSlot>(
    style: cardLayout,
    children: cardChildren,
  ),
);
```

This separation answers “what does the layout Styler style?”: it styles the
parent's geometry, not the rendered appearance of the host or its children.

The fluent shape should follow Mix conventions. A named starter selects a plan
and instance methods refine it:

```dart
// Proposed API — not implemented.
final style = LayoutStyler<CardSlot>.linear(axis: Axis.horizontal)
    .gap(16)
    .padding(const EdgeInsets.all(12))
    .item(CardSlot.media, const LinearItem.basis(112))
    .item(CardSlot.body, const LinearItem.flex(1))
    .item(CardSlot.actions, const LinearItem.content());
```

A bare default constructor is useful only if an explicit default plan can be
documented without surprise. The safer initial surface requires a named plan
factory; a later default could mean `linear(axis: Axis.vertical)` if usage
evidence supports it.

### Built-in plans

The proposed built-ins are:

- `linear`: one axis, explicit slot order, gaps, alignment, content/fixed/flex
  participation;
- `flow`: run-based wrapping with gaps, run alignment, and directionality;
- `grid`: finite tracks, gaps, spans, and typed named areas;
- `overlay`: host-relative alignment, fill, insets, and source-ordered z-order;
  and
- `masonry`: finite eager items placed into measured box tracks.

Built-ins should be immutable `LayoutPlan<Slot>` values owned by
`LayoutStyler<Slot>`. They should share the same internal algorithm contract as
custom layouts, but they may use private optimized implementations and stronger
validation.

Plan replacement must be atomic. When a later style supplies a plan, that plan
replaces the earlier one rather than merging fields from incompatible
algorithms. Host-level geometry and parameter maps may merge by their
documented keys. This lets an `onConstraints` branch switch from grid to linear
without producing a hybrid plan.

### `LayoutParam<T>` configures custom algorithms

Custom layout configuration should remain type-safe without requiring code
generation for every algorithm:

```dart
// Proposed API — not implemented.
const profileAvatarGapParam = LayoutParam<double>(
  'profile.avatarGap',
  defaultValue: 12,
);

const profileOverlapParam = LayoutParam<double>(
  'profile.overlap',
  defaultValue: 24,
);

final profileLayout = LayoutStyler<ProfileSlot>.custom(
  const ProfileHeaderAlgorithm(),
).param(profileAvatarGapParam, 16).param(profileOverlapParam, 28);
```

`LayoutParam<T>` is a typed key. `LayoutStyler.param` stores a Mix-resolvable
value under that key, and `LayoutPass.param` retrieves it as `T`. Identity,
equality, default, merge, reset, diagnostics, and token behavior must be
defined before stabilization.

Domain extensions can recover a fluent, purpose-specific API:

```dart
// Proposed API — not implemented.
extension ProfileLayoutStylerX on LayoutStyler<ProfileSlot> {
  LayoutStyler<ProfileSlot> avatarGap(double value) {
    return param(profileAvatarGapParam, value);
  }

  LayoutStyler<ProfileSlot> overlap(double value) {
    return param(profileOverlapParam, value);
  }
}
```

### `LayoutAlgorithm<Slot>` is an experimental escape hatch

Conceptually:

```dart
// Proposed API — not implemented.
@experimental
abstract interface class LayoutAlgorithm<Slot extends Object> {
  const LayoutAlgorithm();

  LayoutResult<Slot> compute(LayoutPass<Slot> pass);
}
```

`LayoutPass` exposes only layout-safe inputs:

- incoming `BoxConstraints`;
- present typed slots;
- resolved typed parameters;
- text direction and other required geometry inputs;
- a child measurement operation; and
- helpers to constrain the result and create placements.

It does not expose `BuildContext`, widget inflation, a `Canvas`, raw hit-test
state, or mutable delegate state.

An algorithm object must be immutable and stateless. The same instance may be
used by multiple hosts. All measurement results and temporary values belong to
the pass. Equality must describe configuration, or configuration should live
entirely in typed parameters.

This API remains experimental until a corpus of real layouts demonstrates dry
layout parity, good diagnostics, and acceptable performance.

### `onConstraints` replaces the working name `onContainer`

The proposed name is:

```dart
// Proposed API — not implemented.
style.onConstraints(
  const Breakpoint.maxWidth(560),
  compactStyle,
);
```

“Container” is ambiguous: it might refer to Flutter's `Container`, a styled
box, or a CSS container query. `onConstraints` states what the rule actually
observes.

The distinction from existing viewport variants is important:

| API | Input | Meaning |
|---|---|---|
| `onMobile(style)` | `MediaQuery.sizeOf(context)` | The screen/viewport matches Mix's mobile breakpoint |
| `onBreakpoint(breakpoint, style)` | `MediaQuery.sizeOf(context)` | The screen/viewport matches a custom breakpoint |
| proposed `onConstraints(breakpoint, style)` | incoming `BoxConstraints.maxWidth` and `maxHeight` | The space offered to this layout host matches the breakpoint |

A card can therefore use its compact plan in a narrow sidebar on a wide
desktop, while `onMobile` remains false.

The matching rules should be explicit:

- breakpoint bounds are inclusive, as they are today;
- absent width or height bounds are ignored;
- the compared size is formed from the incoming maximum width and height;
- an unbounded maximum remains infinity, so a finite `maxWidth` rule does not
  match an unbounded width;
- base style resolves first, then matching constraint branches merge in
  declaration order; and
- diagnostics show the incoming constraints and selected branch.

`onConstraints` cannot resolve entirely during build because the relevant
constraints do not exist there. Normal context variants and tokens resolve
before the render pass; constraint branches remain immutable data in the
resolved layout specification and are selected inside both live and dry
layout.

## Proposed usage: before and after

Every “after” snippet below is illustrative pseudocode for an unimplemented
API.

### Responsive card

Before, local responsiveness changes widget structure and repeats children:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final media = CardMedia(item: item);
    final body = CardBody(item: item);
    final actions = CardActions(item: item);

    if (constraints.maxWidth <= 560) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          media,
          const SizedBox(height: 12),
          body,
          const SizedBox(height: 12),
          actions,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(width: 112, child: media),
        const SizedBox(width: 16),
        Expanded(child: body),
        const SizedBox(width: 16),
        actions,
      ],
    );
  },
);
```

After, one host keeps one typed child set and changes only its plan:

```dart
// Proposed API — not implemented.
enum CardSlot { media, body, actions }

final cardLayout =
    LayoutStyler<CardSlot>.linear(
      axis: Axis.horizontal,
      order: const [
        CardSlot.media,
        CardSlot.body,
        CardSlot.actions,
      ],
      items: const {
        CardSlot.media: LinearItem.basis(112),
        CardSlot.body: LinearItem.flex(1),
        CardSlot.actions: LinearItem.content(),
      },
    )
    .gap(16)
    .crossAxisAlignment(.stretch)
    .onConstraints(
      const Breakpoint.maxWidth(560),
      LayoutStyler<CardSlot>.linear(
        axis: Axis.vertical,
        order: const [
          CardSlot.media,
          CardSlot.body,
          CardSlot.actions,
        ],
      ).gap(12).crossAxisAlignment(.stretch),
    );

MixLayout<CardSlot>(
  style: cardLayout,
  children: {
    CardSlot.media: CardMedia(item: item),
    CardSlot.body: CardBody(item: item),
    CardSlot.actions: CardActions(item: item),
  },
);
```

Impact: child identity and content are declared once; the responsive concern is
a reusable style value; and the layout decision uses the card's offered width,
not the screen width.

### Typed grid areas

Before, named regions are encoded through nesting and repeated flex math:

```dart
Row(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    const SizedBox(width: 224, child: DashboardNavigation()),
    const SizedBox(width: 16),
    Expanded(
      flex: 2,
      child: Column(
        children: [
          const DashboardSummary(),
          const SizedBox(height: 16),
          Expanded(child: DashboardChart()),
        ],
      ),
    ),
    const SizedBox(width: 16),
    const Expanded(child: DashboardActivity()),
  ],
);
```

After, the area matrix names roles directly:

```dart
// Proposed API — not implemented.
enum DashboardArea { navigation, summary, chart, activity }

final dashboardLayout = LayoutStyler<DashboardArea>.grid(
  columns: const [
    GridTrack.fixed(224),
    GridTrack.fraction(2),
    GridTrack.fraction(1),
  ],
  rows: const [
    GridTrack.content(),
    GridTrack.fraction(1),
  ],
  areas: const [
    [
      DashboardArea.navigation,
      DashboardArea.summary,
      DashboardArea.activity,
    ],
    [
      DashboardArea.navigation,
      DashboardArea.chart,
      DashboardArea.activity,
    ],
  ],
).columnGap(16).rowGap(16);

MixLayout<DashboardArea>(
  style: dashboardLayout,
  children: const {
    DashboardArea.navigation: DashboardNavigation(),
    DashboardArea.summary: DashboardSummary(),
    DashboardArea.chart: DashboardChart(),
    DashboardArea.activity: DashboardActivity(),
  },
);
```

Impact: areas are type-checked, a slot cannot accidentally be represented by
two active children, and the plan can validate rectangular spans and required
areas before layout.

### Overlay placement

Before, placement is expressed through wrappers mixed into the child list:

```dart
Stack(
  children: [
    const Positioned.fill(child: CardImage()),
    PositionedDirectional(
      top: 12,
      end: 12,
      child: const FavoriteButton(),
    ),
    const Align(
      alignment: AlignmentDirectional.bottomStart,
      child: CardCaption(),
    ),
  ],
);
```

After, one overlay plan owns all placement:

```dart
// Proposed API — not implemented.
enum PosterSlot { image, favorite, caption }

final posterLayout = LayoutStyler<PosterSlot>.overlay(
  placements: const {
    PosterSlot.image: OverlayPlacement.fill(),
    PosterSlot.favorite: OverlayPlacement.anchor(
      AlignmentDirectional.topEnd,
      inset: EdgeInsetsDirectional.only(top: 12, end: 12),
    ),
    PosterSlot.caption: OverlayPlacement.anchor(
      AlignmentDirectional.bottomStart,
    ),
  },
);

MixLayout<PosterSlot>(
  style: posterLayout,
  children: const {
    PosterSlot.image: CardImage(),
    PosterSlot.favorite: FavoriteButton(),
    PosterSlot.caption: CardCaption(),
  },
);
```

Impact: parent-owned geometry is reusable and responsive without
`Positioned`/`Align` wrappers. The map's iteration order remains the visual
stacking order.

### Custom child-dependent measurement

Before, `CustomMultiChildLayout` can size and place a follower from a leader,
but the parent's own size cannot depend on those measured children. Supporting
shrink-wrapping requires a custom multi-child render object and its dry-layout
implementation.

After, an experimental algorithm expresses the relationship through typed
handles:

```dart
// Proposed API — not implemented.
enum ProfileSlot { header, avatar, body }

const profileOverlapParam = LayoutParam<double>(
  'profile.overlap',
  defaultValue: 24,
);

@experimental
final class ProfileHeaderAlgorithm
    implements LayoutAlgorithm<ProfileSlot> {
  const ProfileHeaderAlgorithm();

  @override
  LayoutResult<ProfileSlot> compute(LayoutPass<ProfileSlot> pass) {
    final overlap = pass.param(profileOverlapParam);
    final loose = pass.constraints.loosen();

    final headerSize = pass.measure(ProfileSlot.header, loose);
    final avatarSize = pass.measure(ProfileSlot.avatar, loose);
    final bodyTop = headerSize.height + avatarSize.height - overlap;
    final bodySize = pass.measure(
      ProfileSlot.body,
      loose.deflate(
        EdgeInsets.only(top: bodyTop),
      ),
    );

    final size = pass.constrainToChildren(
      widths: [headerSize.width, avatarSize.width, bodySize.width],
      height: bodyTop + bodySize.height,
    );

    return LayoutResult(
      size: size,
      offsets: {
        ProfileSlot.header: Offset.zero,
        ProfileSlot.avatar: Offset(
          (size.width - avatarSize.width) / 2,
          headerSize.height - overlap,
        ),
        ProfileSlot.body: Offset(0, bodyTop),
      },
    );
  }
}

final profileLayout = LayoutStyler<ProfileSlot>.custom(
  const ProfileHeaderAlgorithm(),
).param(profileOverlapParam, 28);

MixLayout<ProfileSlot>(
  style: profileLayout,
  children: const {
    ProfileSlot.header: ProfileHeader(),
    ProfileSlot.avatar: ProfileAvatar(),
    ProfileSlot.body: ProfileBody(),
  },
);
```

The final API would need helpers for bounded widths and missing slots; this
example intentionally shows the measure-size-place model rather than claiming
production-ready signatures. The same `compute` method must run for live and
dry layout.

### Conditional children

Before, list positions or `LayoutId` wrappers make optional roles easy to
misalign with a delegate:

```dart
CustomMultiChildLayout(
  delegate: ProductDelegate(showBadge: product.isNew),
  children: [
    LayoutId(id: 0, child: ProductImage(product)),
    LayoutId(id: 1, child: ProductDetails(product)),
    if (product.isNew) const LayoutId(id: 2, child: NewBadge()),
    if (canBuy) LayoutId(id: 3, child: BuyButton(product)),
  ],
);
```

After, conditions preserve semantic identity:

```dart
// Proposed API — not implemented.
enum ProductSlot { image, details, badge, action }

MixLayout<ProductSlot>(
  style: productLayout,
  children: {
    ProductSlot.image: ProductImage(product),
    ProductSlot.details: ProductDetails(product),
    if (product.isNew) ProductSlot.badge: const NewBadge(),
    if (canBuy) ProductSlot.action: BuyButton(product),
  },
);
```

Impact: algorithms ask `pass.hasChild(ProductSlot.badge)` rather than infer
identity from a shifting index. Plans can separately declare required and
optional slots.

## Proposed render contract

The render contract is the highest-risk part of the design and must be
validated before public API work.

### One deterministic computation

Live and dry layout should call the same plan/algorithm runner:

```text
resolved LayoutSpec + incoming BoxConstraints + child handles
                              │
                              ▼
                     deterministic compute
                              │
                              ▼
                 parent size + child placements
```

Only the measurement backend differs:

- live measurement calls `RenderBox.layout`, then reads `size`;
- dry measurement calls `RenderBox.getDryLayout`; and
- intrinsic queries use a documented adaptation of the same plan or explicitly
  report that a child/plan cannot answer the query.

The branch selection, measurement constraints, size math, validation, and
placement math must be shared. There must not be a simplified dry algorithm
that can disagree with live layout.

The internal pass should distinguish a non-mutating size probe from a child's
single final live layout. Built-ins such as content-sized grids may need dry
probes to calculate tracks before final measurement. The rules and cost need
validation; arbitrary repeated live measurement should not be public behavior.

### Required invariants

For a given resolved specification, incoming constraints, directionality,
typed parameters, and child measurement responses:

- computation produces the same result;
- every returned parent size satisfies the incoming constraints;
- every present child is measured and placed exactly as the plan declares;
- a child receives at most one final live layout per host layout pass;
- offsets and sizes contain no NaN values;
- required infinite dimensions are rejected with context;
- missing required slots fail before unsafe measurement;
- optional absent slots are skipped deterministically; and
- algorithm objects retain no pass state.

### Paint, hit test, and semantics

The first implementation should use normal Flutter multi-child behavior:

- paint children in the map iteration order captured by the host;
- hit test children in reverse paint order;
- visit semantics in normal paint/source order;
- apply each child's layout offset through parent data;
- use standard clipping configured by the host, if clipping is included; and
- do not let an algorithm paint, reorder hit testing, or replace semantics.

Measurement order and visual placement do not alter paint order. For overlays,
developers choose z-order through map entry order. If a future explicit
z-index is justified, it must update paint, hit-test, and semantics contracts
together.

### No layout-time inflation

All children are built during Flutter's build phase and passed in the slot map.
An algorithm cannot inflate, remove, or replace widgets while layout is
running. This keeps:

- widget state and keys in Flutter's normal lifecycle;
- dry layout free from speculative tree mutation;
- build and layout responsibilities separate; and
- conditional content visible in application code.

### Plan changes and child state

Switching from `linear` to `grid` or `overlay` changes the resolved plan inside
the same `MixLayout` host. It should not replace children merely because the
algorithm type changes. Slot association and ordinary widget keys guide
element reuse. A validation test must prove that stateful children retain state
across `onConstraints` plan changes.

## Diagnostics

The API should fail in Mix and Flutter terminology. A useful error includes:

- the `MixLayout<Slot>` and active plan or algorithm type;
- incoming constraints and text direction;
- the slot being measured or placed;
- the slot set supplied by the application;
- required and optional slot sets;
- the measurement constraints already used for the slot;
- the invalid size or offset;
- the relevant `LayoutParam` key and expected type; and
- a concrete correction where one exists.

Debug assertions should detect:

- missing required slots and unknown slots rejected by a closed plan;
- non-rectangular or disconnected grid areas;
- overlapping grid claims that are not the same area;
- zero, negative, NaN, or infinite track values where invalid;
- fractional tracks on an unbounded axis without a defined fallback;
- an absent custom parameter without a default;
- a parameter value with the wrong runtime type;
- measuring an unknown slot;
- a second final live measurement of one child;
- returning a size outside incoming constraints;
- omitting placement for a measured child;
- placing a child that was never measured; and
- custom algorithm state or equality that makes relayout nondeterministic.

Dry-layout failures should add the active slot and plan to Flutter's underlying
diagnostic. They should not silently return a plausible but incorrect size.

## Validation and delivery phases

### Phase 0: exploration and cleanup

This document is Phase 0. It removes the abandoned boundary-wrapper prototype,
records its evidence, and commits no public layout API.

Exit criteria:

- the guide is indexed;
- no shipping `FlexItem`, `StackItem`, or temporary aliases remain;
- existing layout behavior is unchanged; and
- all repository verification passes.

### Phase 1: private render-contract spike

Build an internal, unexported host with:

- typed slots;
- one simple linear algorithm;
- one child-dependent custom algorithm;
- one runner shared by `performLayout` and `computeDryLayout`;
- standard paint, hit-test, and semantics traversal; and
- no Styler or generator integration.

Validation layouts:

- a shrink-wrapped leader/follower layout;
- a profile header whose body depends on avatar size;
- a stateful child moved between two plans; and
- an `IntrinsicWidth`/`IntrinsicHeight` harness.

Do not publish the API from this spike.

### Phase 2: real-layout corpus and alternatives checkpoint

Implement representative designs using both the internal host and direct
Flutter/Boxy-style alternatives:

- responsive product card;
- dashboard grid with areas and spans;
- poster overlay;
- wrapping chip flow;
- finite masonry gallery;
- child-dependent profile header; and
- optional badge/action roles.

Compare code size, readability, diagnostics, dry behavior, layout counts, and
frame timings. Reconsider using an existing package if the Mix-owned render
contract is not materially clearer or smaller.

### Phase 3: built-in plans and `LayoutStyler`

Add internal/experimental linear, flow, grid, overlay, and finite masonry
plans. Integrate immutable layout specs, Mix merge/reset behavior, tokens,
context variants, and render-time `onConstraints` selection.

Run generated-code impact as a separate decision. The preferred first version
uses typed parameters and handwritten extensions for custom algorithms rather
than generator support.

### Phase 4: smallest public experimental API

Export only the surface proven by the corpus. Mark `LayoutAlgorithm` and
possibly advanced grid/masonry features experimental. Publish constraints,
measurement, ordering, and diagnostic contracts rather than only examples.

### Phase 5: stabilization

Remove experimental status only after multiple application layouts, version
migrations, performance profiles, accessibility verification, and dry-layout
tests show that the abstractions are stable.

Slivers and lazy masonry require a separate proposal even after box layout is
stable.

## Test strategy for a future implementation

### Value and Styler tests

- plan, track, placement, and parameter equality/hash behavior;
- immutable copy, merge, reset, and precedence behavior;
- token resolution;
- ordinary context variants;
- `onConstraints` inclusive boundaries and declaration-order precedence;
- distinction between MediaQuery breakpoints and incoming constraints;
- unbounded width and height behavior; and
- diagnostics serialization.

### Algorithm unit tests

Use fake typed child handles with recorded constraints and deterministic sizes:

- every built-in's measurement order and constraints;
- linear fixed/content/flex distribution;
- flow wrapping and run alignment;
- grid fixed/fraction/content tracks, areas, spans, and directionality;
- overlay fill, anchors, insets, and alignment;
- finite masonry shortest-track placement;
- optional slots;
- invalid values and missing slots; and
- custom `LayoutParam<T>` default and override resolution.

### Render tests

- live size equals dry size for the same deterministic children;
- intrinsic wrappers receive supported, stable answers;
- parent size can depend on child sizes;
- each child receives one final live layout;
- state survives a plan switch;
- map additions and removals preserve unaffected child state;
- LTR and RTL placement;
- text scale and baseline-sensitive children where supported;
- bounded and unbounded constraints;
- overflow and clipping;
- map-order paint behavior;
- reverse-order hit testing;
- semantics traversal and bounds; and
- useful Flutter error output in debug mode.

### Widget and golden tests

- every before/after example;
- local narrow card inside a wide-screen `MediaQuery`;
- typed grid areas at multiple constraints;
- overlay z-order and interaction;
- conditional child appearance;
- finite masonry with heterogeneous heights; and
- nested `MixLayout` composition.

### Performance tests

- layout and dry-layout call counts;
- no unnecessary child relayout when immutable inputs are equal;
- constraint branch switching;
- 10, 50, and 200-child finite masonry cases;
- large finite grids with spans;
- allocation pressure from pass/result objects; and
- comparison with direct Flutter implementations.

## Risks and mitigations

| Risk | Why it matters | Mitigation or gate |
|---|---|---|
| Dry layout differs from live layout | Intrinsics and parent negotiation become incorrect | One shared runner; parity tests for every plan |
| A child cannot answer dry layout | Some Flutter render boxes intentionally reject it | Preserve Flutter failure, add slot context, document unsupported combinations |
| Grid scope expands toward CSS | Track sizing becomes a long standards project | Publish a finite documented subset |
| Masonry is mistaken for a lazy feed | Eager measurement can be expensive | Name and document it as finite box masonry; benchmark caps |
| Constraint variants behave like screen variants | Responsive components choose surprising plans | Separate `onConstraints` docs/tests from `onMobile` and `onBreakpoint` |
| Map order becomes accidental z-order | Overlays paint or hit test unexpectedly | Specify, snapshot, test, and diagnose source order |
| Custom algorithms become mutable delegates | Reuse and relayout become nondeterministic | Stateless interface, typed params, equality checks, debug assertions |
| Visual and layout styling blur together | Parent geometry leaks into child components | Keep `LayoutStyler` geometry-only |
| Plan switching loses child state | Responsive layouts feel structurally unstable | One stable host and slot association; state-retention tests |
| Built-ins require repeated measurement | Performance and Flutter contracts suffer | Separate dry probes from one final live measure; instrument call counts |
| API surface grows before evidence | Mix becomes harder to learn and change | Internal spike and corpus gates before export |
| Boxy parity becomes the goal | Painting, inflation, and slivers overwhelm core layout | Keep explicit non-goals and reassess each feature independently |

## Future definition of done

### Unbundled productization (recommended path)

A public advanced layout API is ready for stabilization only when:

1. `onConstraints` is exported (remove `@internal`), documented as offered
   `BoxConstraints` (not MediaQuery), and tested for inclusive bounds, merge
   order, nested detection, `styleSpec` bypass, and dry-layout blast radius.
2. Styles without constraint variants pay zero `LayoutBuilder` cost.
3. `WrapBox` / `WrapBoxStyler` are exported; fluent spacing API parity with
   FlexBox is acceptable (e.g. `WrapStyleMixin`); generator field naming
   (`flow` vs reserved `wrap`) is documented.
4. `GridBox` fixed/fr + gaps + auto-place passes live==dry parity; child layout
   pass counts and gap math are tested; slice remains maintainable.
5. `onConstraints` composes on Flex, Text, Wrap, and Grid hosts.
6. Tailwind mappings (`@container` / `@max-md:*`, `grid-cols-*` / `gap-*`,
   `flex-wrap` / `gap-*`) compile cleanly in `mix_tailwinds`.
7. Changelog, public docs, and export order follow
   `onConstraints` → `WrapBox` → `GridBox`.
8. Full repository generation, test, analysis, and export checks pass.

### Deferred `MixLayout` revival gates (only if product needs plan switching)

If cross-family plan switching later requires a bundled host, additionally:

1. `MixLayout<Slot>` has one documented child identity and ordering contract.
2. `LayoutStyler<Slot>` contains geometry only and composes using Mix merge,
   reset, token, and variant rules.
3. Linear, flow, grid, overlay, and finite masonry plans pass unit, render,
   widget, semantics, and performance tests under one host.
4. Typed slots preserve state across plan switches and conditional child
   updates.
5. `LayoutParam<T>` / `LayoutAlgorithm<Slot>` contracts are defined and gated
   experimental until real application layouts validate them.

## Explicitly deferred

The following require separate proposals:

- sliver layouts;
- lazy or virtualized masonry;
- delegate painting or foreground/background drawing;
- custom child paint order;
- hit-test customization;
- semantics customization;
- layout-time widget inflation;
- widget-state layout variants such as hover-driven structural layout;
- implicit animation between layout plans or placements; and
- a constraint/anchor solver.

Ordinary context inputs such as directionality and theme may resolve layout
geometry. Structural layout changes driven by transient widget state are
deferred because they affect layout frequency, interaction bounds, semantics,
and animation expectations.

## Spike results

Evidence from internal spikes on branch work (see tests under
`packages/mix/test/src/variants/constraint_variant_test.dart`,
`packages/mix/test/src/specs/wrapbox/`, `packages/mix/test/src/layout/`,
and `packages/mix_tailwinds/test/spike/`). Symbols for Wrap/Grid remain
unexported from `mix.dart`.

### Spike 1 — `onConstraints` — **Go**

| Gate criterion | Evidence |
|---|---|
| Zero cost for styles without constraint variants | No `LayoutBuilder` / `ConstraintScope` when `hasConstraintVariants` is false |
| Matching on offered `BoxConstraints.biggest` | Inclusive bounds; unbounded axis = infinity so finite `maxWidth` does not match; `minWidth` can match unbounded; `BreakpointRef` resolves like `BreakpointVariant` |
| Universal (not layout-only) | `TextStyler().fontSize(20).onConstraints(...)` changes font size |
| Independent of viewport variants | Narrow panel on wide desktop: `onConstraints` matches, `onMobile` / `onBreakpoint` do not |
| Merge / precedence | Base first; matching branches in declaration order; coexists with `onBreakpoint` |
| Nested detection | Recursive scan into nested variant styles; depth-20 × 1000 calls &lt; 100 ms — no cache required yet |
| `styleSpec` bypass | Debug assert when `style` has constraint variants and `styleSpec` is also passed; `styleSpec` path never installs `ConstraintScope` |
| Rebuild dedupe | Identical constraints do not re-run the style builder |
| Intrinsics / dry blast radius | Limited to opted-in subtrees. Exact dry-layout error: `_RenderLayoutBuilder class does not support dry layout. Calculating the dry layout would require running the layout callback speculatively…` Styles without constraint variants work under `IntrinsicHeight`. |
| Variant machinery | No structural change — `ConstraintVariant` extends `ContextVariant`; `StyleBuilder` conditionally wraps |

**Mechanism:** `ConstraintVariant` + `ConstraintScope` InheritedWidget; `StyleBuilder` inserts `LayoutBuilder` → `ConstraintScope` only when the style tree contains a constraint variant; `onConstraints` on `VariantStyleMixin`.

**Fallback (not taken):** host-side render-time branch selection without `LayoutBuilder` remains available if a product surface later cannot accept the dry-layout limitation. For v1, the LayoutBuilder cost is accepted and documented for opted-in subtrees only.

**Known limitation — `onBuilder` nesting:** constraint detection
(`hasConstraintVariants`) is static and cannot see inside a
`ContextVariantBuilder` closure, which produces its style at build time. A
`.onConstraints(...)` returned from inside `onBuilder` therefore gets no
`ConstraintScope` and throws at resolution. Detecting it conservatively (treating
every builder variant as constraint-bearing) is rejected: it would impose the
`LayoutBuilder`/dry-layout cost on all existing `onBuilder` users. Resolution is
to attach `onConstraints` directly to the style; the `ConstraintScope` error text
names this cause. Productization should document it alongside the dry-layout note.

### Spike 2 — `WrapBox` — **Go**

| Gate criterion | Evidence |
|---|---|
| Codegen extends to a new family member | `melos`/`build_runner` produces `wrap_spec.g.dart` and `wrapbox_spec.g.dart` without generator code changes |
| Widget behavior | spacing / runSpacing / alignment applied on Flutter `Wrap`; optional `Box` chrome |
| `onConstraints` composition | `WrapBoxStyler(...).onConstraints(...)` flips spacing under narrow offered width |

**Finding:** nested field cannot be named `wrap` — generator reserves `wrap` for modifier chaining. Field is named `flow`. Productization should add a `WrapStyleMixin` for flattened fluent methods (current composite only exposes `box` / `flow` setters, unlike `FlexBoxStyler`).

### Spike 3 — `GridBox` render slice — **Go (build slice; adapt optional later)**

| Gate criterion | Evidence |
|---|---|
| fixed + fr tracks, gaps, row-major auto-place | Unit tests on `computeTrackSizes` / `computeGridLayout`; widget tests on positions |
| Live size == dry size | Shared `computeGridLayout` used by `performLayout` and `computeDryLayout` |
| Single layout pass per child | `childLayoutCount == childCount` per performLayout |
| Modest size | ~565 LOC under `packages/mix/lib/src/layout/` (hand-written Spec/Styler; no codegen) |
| `onConstraints` composition | Dashboard (fixed+2fr+1fr → 1 col) and gallery (3×N → 1 col) demos |

**`flutter_layout_grid` evaluation (v2.0.8, MIT):**

- Full CSS-inspired track sizing including intrinsic tracks; implements `computeDryLayout`.
- Substantial surface area and dependency vs Mix-owned ~0.5k LOC slice.
- **Recommendation:** **build** the Mix-owned fixed/fr + gap + auto-place core for product v1 (proven, small, Mix-native Styler). **Revisit adapt** when product needs content-sized tracks, spans, or named areas where reimplementing CSS grid would dominate — license fits (MIT); dry-layout support is real.

### Spike 4 — Tailwind parity probe — **Pass (with completeness notes)**

Prototype translators in `packages/mix_tailwinds/lib/src/spike/layout_parity_map.dart` (unexported):

| Tailwind | Mix spike |
|---|---|
| `@container` + `@max-md:flex-col` | `onConstraints(Breakpoint(maxWidth: md), FlexBoxStyler().direction(vertical))` |
| `grid-cols-3 gap-4` | `GridBoxStyler(columns: [fr×3], gap 16)` |
| `flex-wrap gap-2` | `WrapBoxStyler(flow: WrapStyler(spacing: 8, runSpacing: 8))` |

**Completeness findings before productization:**

1. Distinguish viewport `md:` (`onBreakpoint`) from container `@max-md:` (`onConstraints`).
2. `@container` need not be a user widget if StyleBuilder auto-scopes on constraint variants.
3. Flatten Wrap fluent API (`WrapStyleMixin`) before public export.
4. Grid spans / areas / content tracks stay post-v1.

### Productization plan (export order)

Spike entry points are currently **`@internal`** (constraint APIs) or
**unexported** (Wrap/Grid). Productization removes those gates in order:

1. **`onConstraints`** — remove `@internal` from `onConstraints`,
   `ConstraintVariant`, `ContextVariant.constraints`, and `ConstraintScope` (or
   keep scope package-private if StyleBuilder is the only publisher); document
   dry-layout limitation and viewport-vs-offered distinction; ship tests
   already written.
2. **`WrapBox`** — export Wrap family from `mix.dart`; add `WrapStyleMixin` for
   FlexBox-parity fluency; document `flow` field naming vs modifier `wrap`.
3. **`GridBox`** — export after render contract solidifies; decide codegen vs
   hand Spec; grow tracks (min/max content, spans) behind feature flags;
   optional later adapt of `flutter_layout_grid` for advanced CSS parity.

Do **not** export `MixLayout<Slot>` unless a product need for cross-family plan
switching appears that these three increments cannot cover.

## Decision record

- Use Flutter's constraint and `RenderBox` model as the foundation.
- Keep existing simple parent widgets and native parent-data widgets.
- Preserve the boundary-wrapper prototype's parent-data evidence.
- Do not ship the prototype wrappers or aliases.
- Do not put parent participation in visual Stylers.
- Do not depend on or clone Boxy initially.
- **Ship advanced layout unbundled:** `onConstraints` + `WrapBox` + `GridBox`,
  not a mandatory `MixLayout<Slot>` host for v1.
- **`MixLayout<Slot>` is considered and deferred** — revisit only for
  cross-family plan switching with typed child identity.
- Keep layout and visual styling separate.
- Prefer built-in family widgets plus optional experimental algorithms over a
  recursive blueprint or solver.
- Use typed parameters and extensions before adding generator complexity.
- Rename the working `onContainer` concept to `onConstraints` (done in spike).
- **`onConstraints` may use conditional `LayoutBuilder`/`ConstraintScope`** for
  universal Styler support; cost is opt-in and dry-layout failure is
  diagnosable. Host-side render selection remains a fallback for hosts that
  must support dry layout on every path.
- Keep normal Flutter paint, hit-test, semantics, and widget lifecycles.
- Productize only after export-order steps above; spike code stays internal
  until then.

## Primary references

- [Flutter: Understanding constraints](https://docs.flutter.dev/ui/layout/constraints)
- [Flutter: `RenderBox`](https://api.flutter.dev/flutter/rendering/RenderBox-class.html)
- [Flutter: `MultiChildLayoutDelegate`](https://api.flutter.dev/flutter/rendering/MultiChildLayoutDelegate-class.html)
- [Boxy package](https://pub.dev/packages/boxy)
- [SwiftUI: `Layout`](https://developer.apple.com/documentation/swiftui/layout)
- [SwiftUI: `AnyLayout`](https://developer.apple.com/documentation/swiftui/anylayout/)
- [SwiftUI: `LayoutSubview`](https://developer.apple.com/documentation/swiftui/layoutsubview)
- [Jetpack Compose: Custom layouts](https://developer.android.com/develop/ui/compose/layouts/custom)

## Secondary implementation references

- [Boxy: `CustomBoxy`](https://pub.dev/documentation/boxy/latest/boxy/CustomBoxy-class.html)
- [Boxy: `BoxyDelegate`](https://pub.dev/documentation/boxy/latest/boxy/BoxyDelegate-class.html)
- [`flutter_layout_grid`](https://pub.dev/packages/flutter_layout_grid)
- [`flutter_staggered_grid_view`](https://pub.dev/packages/flutter_staggered_grid_view)
