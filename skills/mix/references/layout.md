# Layout with Mix

Confirm the consuming package's resolved API before using newer primitives.
Local source takes priority in the Mix repository; downstream releases may
lack WrapBox or GridBox.

## Select the primitive

| Need | Use |
|---|---|
| One styled child | `Box` / `BoxStyler` |
| Non-wrapping row or column | `RowBox`, `ColumnBox`, `FlexBox` / `FlexBoxStyler` |
| Intrinsic items flowing across runs | `WrapBox` / `WrapBoxStyler` |
| Explicit two-dimensional tracks | `GridBox` / `GridBoxStyler` |
| Overlays | `StackBox` / `StackBoxStyler` |

FlexBox, WrapBox and StackBox combine layout with an optional outer BoxSpec.
Keep chrome on the composite styler. Grid owns geometry, clipping, variants,
modifiers and animation, but **has no outer Box**; wrap it in Box for padding
or decoration. Use raw Flutter layout when its semantics are needed.

## Flex and Wrap

```dart
final toolbar = FlexBoxStyler().spacing(12).padding(.all(16));
RowBox(style: toolbar, children: actions);

final tags = WrapBoxStyler().spacing(8).runSpacing(10).wrapAlignment(.center);
WrapBox(style: tags, children: chips);
```

Do not set a direction conflicting with RowBox/ColumnBox. Use FlexBox when
direction is dynamic. Put alignment/gaps on the parent; child
`.wrap(WidgetModifierConfig.flexible(...))` supplies Flexible behavior.

Wrap chooses line breaks from intrinsic item widths. Grid shares column
boundaries across rows. For WrapBox, `alignment`/`clipBehavior` affect the outer
Box; `wrapAlignment`/`wrapClipBehavior` affect the inner Wrap. `.flow(...)`
composes a nested WrapStyler; `.wrap(...)` still means widget modifiers.

## Grid tracks

```dart
final GridBoxStyler cards = .equalColumns(3).gap(16).autoRows(.auto());
GridBox(style: cards, children: panels);

final GridBoxStyler report = .columns([
  .fixed(240),
  .fr(2),
  .fr(1),
]).columnGap(16).autoRows(.fixed(280));
```

- Fixed tracks preserve their logical-pixel size, even if they overflow.
- Fractional tracks divide remaining space after fixed tracks, auto rows and gaps.
  Fractional columns need bounded width; fractional rows need bounded height.
- Auto is vertical-only, sizing a row to the tallest natural child at its
  resolved column width. Shorter siblings may be laid out again to stretch;
  fixed cells are not speculatively measured.
- Children fill left to right, row by row. Explicit `rows` cover their positions;
  remaining rows repeat `autoRows`, which defaults to auto when omitted.
- In vertical scrolling, use auto rows or deliberate fixed heights, not fractional
  rows on an unbounded axis. Auto-row children need finite natural height;
  avoid Expanded/Spacer in an auto row under unbounded height.

Use Grid for aligned dashboards, catalogs and galleries. There are no auto
columns, spans, named areas, masonry packing, direction-aware placement or
baseline alignment in the current contract.

## Local constraints versus viewport

```dart
final GridBoxStyler responsive = .equalColumns(3).gap(16)
    .onConstraints(.maxWidth(760), .equalColumns(2).gap(12))
    .onConstraints(.maxWidth(520), .equalColumns(1).gap(10));
```

All matching branches apply in declaration order. Below 520 both match, and
the last refines the prior patch. `onConstraints` observes the Grid parent's
offered constraints. `onBreakpoint` observes the viewport through MediaQuery.
Two grids in the same viewport can therefore choose different local branches.

Constraint patches may set columns, rows, autoRows, columnGap and rowGap only.
Put clipping, modifiers, animation and ordinary variants on the base style;
nested constraint branches are rejected.

## Animation and overflow

```dart
final GridBoxStyler animated = .columns([
  .fr(focused ? 2 : 1),
  .fr(1),
]).autoRows(.fixed(120)).gap(16).animate(.easeInOut(400.ms));
```

Continuous interpolation needs equal-length track lists with compatible kinds
at each position. Compatible rows, autoRows and gaps interpolate; track count
or kind changes, clipping and constraint-patch lists switch at the midpoint.
Live constraint-branch selection remains immediate during layout rather than
creating an animation target.

Overflow stays visible with diagnostics under `clipBehavior: .none`; set
`.clipBehavior(.hardEdge)` on the base style when paint must be contained.

## Stack and nested styles

```dart
final overlay = StackBoxStyler()
    .padding(.all(12))
    .stackAlignment(.bottomCenter)
    .stackClipBehavior(.none);
StackBox(style: overlay, children: layers);
```

`alignment` and `clipBehavior` configure the outer Box. `.stack(...)` supplies
a nested StackStyler. Layout-only Flex/Wrap/Stack stylers compose substyles;
ordinary widgets use their composite Box stylers.

## Inspect and verify

The [Grid contract](https://github.com/btwld/mix/blob/main/packages/mix/doc/grid-layout.md)
contains full measurement and validation rules. The
[runnable layout guide](https://github.com/btwld/mix/blob/main/examples/showcase/docs/layouts.md)
links source examples. In a checkout inspect `packages/mix/lib/src/layout/`,
`specs/`, and focused tests under `packages/mix/test/src/layout/`.
Test bounds at responsive transitions and exercise overflow/unbounded cases
when changing layout behavior. Follow the project's required checks for changes
to internals; see [development workflow](development-workflow.md).
