# mix_chart

Mix-styled Flutter line/area, grouped/stacked/floating bar, and pie/donut charts.
Mix owns data models, stable IDs, interactions, semantics and generated stylers;
`fl_chart` is a private renderer, with no raw configuration escape hatch.
See the [decision log](../../ARCHITECTURE.md#keep-chart-serialization-optional).

## Quick start

```dart
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_chart/mix_chart.dart';

LineChart(
  semanticsLabel: 'Weekly revenue',
  series: [
    LineSeries(
      id: 'revenue',
      label: 'Revenue',
      points: [
        ChartPoint(id: 'mon', x: 0, y: 18),
        ChartPoint(id: 'tue', x: 1, y: 31),
        ChartPoint(id: 'wed', x: 2, y: 27),
      ],
      style: .stroke(
        .color(const Color(0xFF6366F1)).width(3),
      ).marker(.show(true).radius(4)),
    ),
  ],
  xAxis: ChartAxis.numeric(
    interval: 1,
    labelFormatter: (value) => ['Mon', 'Tue', 'Wed'][value.round()],
  ),
  yAxis: ChartAxis.numeric(
    min: 0,
    labelFormatter: (value) => '\$${value.toInt()}k',
  ),
  style: .axis(
    .label(
      .fontSize(11).color(const Color(0xFF64748B)),
    ),
  ).grid(
    .showVertical(false).stroke(
      .color(const Color(0xFFE2E8F0)).width(1),
    ),
  ).series(
    .curve(LineCurve.curved).belowArea(
      .show(true).color(const Color(0x226366F1)),
    ),
  ).frame(.showBorder(false).clip(true)),
  onPointTap: (hit) => selectPoint(hit.selectionKey),
);
```

Point IDs are unique within a series, while bar and segment IDs are unique
within their parents. Selection therefore uses hierarchical keys:

```dart
LinePointKey? selectedPoint;
BarSelectionKey? selectedBarItem;

LineChart(
  series: series,
  selectedPoints: {?selectedPoint},
  onPointTap: (hit) => selectedPoint = hit.selectionKey,
);

BarChart(
  groups: groups,
  selectedItems: {?selectedBarItem},
  onBarTap: (hit) => selectedBarItem = hit.selectionKey,
);
```

Use `BarSelectionKey.bar(...)` or `BarSelectionKey.segment(...)` when
constructing selection state without an interaction hit.

## Styling and behavior

Presentation precedence is package defaults → chart common style → per-series,
bar, segment or slice style → selection presentation. Use consumer-owned tokens
and variants when needed; the package does not require a token registry.

- Floating bars set `fromY` and `toY`; stacked bars use `BarSegment`.
- A donut is a pie with positive `centerRadius`; nullable line-point `y` creates a gap.
- Empty charts and all-zero pies render safely.
- Horizontal bar scaling requires `spaceEvenly`, `spaceAround`, or `spaceBetween`.
- `selectedSliceRadiusOffset` adds to the resolved per-slice radius. Unset keeps
  the 8 logical-pixel default; zero disables expansion.
- Axis label builders, badges and tooltips accept Flutter widgets. Hits carry
  public IDs, values, local position and pointer events, not backend indices.

## Animation ownership

Choose one owner: Mix `.animate(...)` for presentation changes, or
`ChartDataTransition` for numeric data updates with a stable styler. Leave the
other transition disabled. Data interpolation requires unchanged ID order and
drawable topology; insertion, deletion, reordering or value↔gap changes snap.
`MediaQuery.disableAnimations` forces immediate output.

## Accessibility and limits

Each chart exposes one root semantics node. Provide `semanticsLabel`; otherwise
an ordered summary is built from labels and formatters. `semanticsValue`
overrides the value, and `excludeFromSemantics` supports decorative charts.
Per-mark spatial semantics and keyboard navigation are not implemented because
the renderer does not expose stable mark geometry.

Scatter, radar, candlestick, heatmap, gauge, treemap, annotations, error bars,
3D and arbitrary mark painters are outside the current model. Put gradient
surrounds on an outer Mix `Box`.

## Integration and releases

The [gallery and playground](example/) contain bar, pie, token, interaction,
label and tooltip examples. JSON consumers opt into
[mix_chart_protocol](../mix_chart_protocol); rendering apps do not need it.

Publishing uses `mix_chart-v<version>` tags and requires maintainer action.
Confirm pub.dev publisher ownership before relying on OIDC. The
[Protocol publishing guide](../../guides/publishing_mix_protocol.md) explains
shared OIDC prerequisites; its package name and tag prefix are Protocol-specific.

BSD 3-Clause. See [LICENSE](LICENSE).
