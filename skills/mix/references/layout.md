# Layout with Mix

Choose and compose Mix-owned layout primitives without falling back to raw
Flutter layout widgets for styling concerns.

## Table of Contents

- [Verify API availability](#verify-api-availability)
- [Select a primitive](#select-the-primitive)
- [Understand composites](#understand-composite-layouts)
- [One-dimensional layouts](#build-one-dimensional-layouts)
- [Wrapping layouts](#build-wrapping-layouts)
- [Grid layouts](#build-two-dimensional-grid-layouts)
- [Overlays](#build-overlays)
- [Verification](#verify-layout-work)

## Verify API Availability

Check the consuming package's `pubspec.yaml` and resolved dependency before
using a layout API. This repository's `main` branch includes `WrapBox` and
`GridBox`, both first shipped in the `mix 2.2.0-beta.2` release. When working in
the Mix repository, prefer local source. When working downstream, confirm the
installed version exposes the referenced classes.

## Select the Primitive

| Layout need | Mix primitive | Why |
|---|---|---|
| One child with size, padding, constraints, or decoration | `Box` + `BoxStyler` | Owns single-child box styling |
| One non-wrapping horizontal or vertical sequence | `RowBox`, `ColumnBox`, or `FlexBox` + `FlexBoxStyler` | Combines Flex geometry with outer Box styling |
| Intrinsic items that should flow onto additional runs | `WrapBox` + `WrapBoxStyler` | Models tags, chips, and button groups without fixed tracks |
| Explicit two-dimensional rows and columns | `GridBox` + `GridBoxStyler` | Models dashboards, card catalogs, and galleries with fixed/`fr` columns and fixed, `fr`, or auto rows |
| Overlapping or positioned children | `StackBox` + `StackBoxStyler` | Combines Stack geometry with outer Box styling |

Prefer the simplest primitive that represents the layout semantics. Do not use
Grid merely to place a single row, and do not use Wrap when columns must align
across runs.

## Understand Composite Layouts

`FlexBox`, `WrapBox`, and `StackBox` resolve a layout sub-spec and optionally an
outer `BoxSpec`. Their Stylers therefore expose both layout and Box methods.
Keep decoration, padding, margin, transforms, and constraints on the composite
Styler instead of nesting a raw `Container`.

`GridBox` is different: it owns Grid geometry, clipping, Mix variants,
modifiers, and animation, but it does not contain an outer `BoxSpec`. Wrap it
in `Box` when the grid itself needs padding or decoration:

```dart
Box(
  style: BoxStyler().padding(.all(16)).color(Colors.white),
  child: GridBox(style: gridStyle, children: cards),
);
```

Use the layout-only `FlexStyler`, `WrapStyler`, and `StackStyler` when composing
the nested sub-style directly. For ordinary widget code, start from the
corresponding `*BoxStyler`.

## Build One-Dimensional Layouts

Use `RowBox` or `ColumnBox` when direction is fixed by the widget:

```dart
final toolbarStyle = FlexBoxStyler()
    .mainAxisAlignment(.spaceBetween)
    .crossAxisAlignment(.center)
    .spacing(12)
    .padding(.all(16));

RowBox(style: toolbarStyle, children: actions);
```

Do not set a conflicting direction on a `RowBox` or `ColumnBox` style. Use
`FlexBox` when direction itself is dynamic:

```dart
final contentStyle = FlexBoxStyler()
    .direction(isCompact ? .vertical : .horizontal)
    .spacing(16);

FlexBox(style: contentStyle, children: sections);
```

Use `.wrap(WidgetModifierConfig.flexible(...))` on a child Styler when that
child needs Flutter `Flexible` behavior inside a Flex layout. Keep parent
alignment and spacing on `FlexBoxStyler`.

## Build Wrapping Layouts

Use `WrapBox` for items whose intrinsic widths determine where runs break:

```dart
final tagCloudStyle = WrapBoxStyler()
    .padding(.all(16))
    .spacing(8)
    .runSpacing(10)
    .wrapAlignment(.center);

WrapBox(style: tagCloudStyle, children: tags);
```

Distinguish the collision-safe composite names:

- `.alignment(...)` and `.clipBehavior(...)` configure the outer Box.
- `.wrapAlignment(...)` and `.wrapClipBehavior(...)` configure the inner Wrap.
- `.flow(WrapStyler(...))` replaces or merges the nested Wrap style directly.
- `.wrap(...)` remains Mix's widget-modifier API, so the nested Wrap field is
  intentionally named `flow`.

Choose Wrap over Grid for tags, filters, and button groups that have varying
intrinsic widths. Choose Grid when cells need shared column boundaries or
explicit row heights.

## Build Two-Dimensional Grid Layouts

### Start with explicit tracks

Give a Grid declaration an explicit `GridBoxStyler` type, then use factory
shorthand to make its topology visible:

```dart
final GridBoxStyler cardGridStyle = .equalColumns(3)
    .gap(16)
    .autoRows(.auto());

GridBox(style: cardGridStyle, children: cards);
```

Use `.equalColumns(count)` for equal `fr(1)` columns. Use `.columns([...])` for
mixed geometry:

```dart
final GridBoxStyler reportGridStyle = .columns([
  .fixed(240),
  .fr(2),
  .fr(1),
]).columnGap(16).autoRows(.fixed(280));
```

Interpret tracks as follows:

- `.fixed(240)` consumes 240 logical pixels and does not shrink. On a row it
  is a hard height: children stretch or clip to that cell.
- `.fr(2)` receives twice the remaining space of `.fr(1)` after fixed tracks,
  auto tracks, and gaps.
- `.auto()` is vertical-only and sizes the row to its tallest child's natural
  height at the resolved column width. Auto-row children are measured at that
  width; only a child shorter than the resolved row is laid out again to
  stretch it. That extra pass is only for children in auto rows, and nesting
  auto Grids does not compound it.
- Fractional columns require bounded width.
- Fractional rows and fractional `autoRows` require bounded height.

### Provide row geometry

Children fill columns left to right, then advance row by row. Provide enough
explicit `.rows([...])` tracks for every required row or set `.autoRows(...)`
for the remaining rows. Omitted `autoRows` defaults to `.auto()`, so a
non-empty Grid with columns and no row declaration sizes implicit rows to
content.

```dart
final GridBoxStyler galleryStyle = .equalColumns(2)
    .rows([.fixed(180)])
    .autoRows(.auto())
    .columnGap(12)
    .rowGap(12);
```

With five children and two columns, this Grid needs three rows. The first uses
the explicit track and the next two repeat `autoRows`. In a vertical
`SingleChildScrollView`, omit `autoRows` or use `.autoRows(.auto())`. Keep
`.fixed(...)` only when clipping or constraining height is intentional. Auto
rows require finite-height children; do not put `Expanded` or `Spacer` in an
auto row inside a scroll view.

### Respond to the offered container

Use `.onConstraints(...)` when a Grid should adapt to the maximum size offered
by its own parent:

```dart
final GridBoxStyler responsiveCards = .equalColumns(3)
    .gap(16)
    .onConstraints(
      .maxWidth(760),
      .equalColumns(2).gap(12),
    )
    .onConstraints(
      .maxWidth(520),
      .equalColumns(1).gap(10),
    );
```

Apply matching branches in declaration order. In the example, both maximum
width branches match below 520, so the later one-column patch refines the
earlier two-column patch.

Keep `onConstraints` patches geometry-only. They may set columns, rows,
`autoRows`, `columnGap`, and `rowGap`. They may not set clipping, modifiers,
animations, ordinary variants, or nested constraint branches. Put those values
on the base `GridBoxStyler`.

Use `.onBreakpoint(...)` instead when the decision should observe viewport
size through `MediaQuery`. Two Grids in the same viewport can select different
`onConstraints` branches because their parents offer different widths.

### Pick Grid for concrete use cases

Use responsive `GridBox` for:

- metric dashboards whose panels collapse from four to two to one column;
- product catalogs with equal card widths and content-sized or fixed rows;
- media galleries with aligned tracks and controlled clipping;
- asymmetric report layouts using fixed sidebar tracks plus fractional content;
- nested components that should respond to their container rather than the
  whole device viewport.

Avoid the current Grid API when the design requires content-sized columns,
spans, named areas, masonry packing, direction-aware placement, or baseline
alignment. Those features are intentionally outside the current contract. Use
a more suitable Flutter layout or redesign the track model rather than
pretending the API supports them.

### Animate compatible geometry

Use the standard Mix `.animate(...)` API when state changes Grid geometry:

```dart
final GridBoxStyler animatedGrid = .columns([
  .fr(focused ? 2 : 1),
  .fr(1),
])
    .autoRows(.fixed(focused ? 148 : 112))
    .gap(focused ? 20 : 12)
    .animate(.easeInOut(const Duration(milliseconds: 400)));
```

Keep track lists the same length and keep each positional track kind compatible
(`fixed` with `fixed`, `fr` with `fr`, `auto` with `auto`) for continuous
interpolation. Compatible rows, `autoRows`, and gaps interpolate too.
Track-count or track-kind changes, clipping, and constraint-patch lists
switch at the midpoint. A live
`onConstraints` branch change remains immediate because selection happens
during layout rather than creating a new animation target.

### Handle overflow deliberately

Expect fixed tracks to preserve their requested size even when they exceed the
available extent. Leave `clipBehavior` at `.none` when overflow should remain
visible with diagnostics, or set it on the base style when painting must be
contained:

```dart
final GridBoxStyler clippedGallery = .equalColumns(4)
    .autoRows(.fixed(160))
    .gap(12)
    .clipBehavior(.hardEdge);
```

## Build Overlays

Use `StackBox` for badges, overlays, and positioned content:

```dart
final overlayStyle = StackBoxStyler()
    .padding(.all(12))
    .borderRadius(.circular(16))
    .stackAlignment(.bottomCenter)
    .stackClipBehavior(.none);

StackBox(style: overlayStyle, children: layers);
```

Distinguish `.alignment(...)` and `.clipBehavior(...)` for the outer Box from
`.stackAlignment(...)` and `.stackClipBehavior(...)` for the inner Stack. Use
`.stack(StackStyler(...))` for direct nested-style composition.

## Verify Layout Work

Check the smallest source and test surface that owns the behavior:

- Grid guide: `packages/mix/doc/grid-layout.md`
- Grid runnable use cases: `examples/showcase/lib/layouts/grid/grid_example.dart`
- Grid contract tests: `packages/mix/test/src/layout/`
- Wrap runnable use case: `examples/showcase/lib/layouts/wrap/main.dart`
- Flex, Wrap, and Stack composites: `packages/mix/lib/src/specs/`

Run focused widget tests while iterating. Before handing off changes to Mix
layout internals, run the repository-required generation, test, and analysis
commands from the main skill.
