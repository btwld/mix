## 0.0.1

### Compatibility

- Require Flutter 3.44 / Dart 3.12, Mix ^2.2.0, and mix_annotations ^2.2.0.
- Axis endpoints are labelled only when they fall on a tick by default. The
  `minIncluded` and `maxIncluded` getters now report false when unset; pass
  true explicitly to retain off-tick endpoint labels.

### Features and defaults

- Add `valueFormatter` to line and bar charts. Tooltips, labels, and semantics
  use concise values without trailing `.0` or floating-point noise.
- Choose round 1/2/5 axis steps from the plot size, keep whole-number data on
  whole-number steps, and round data-derived value-axis bounds outward.
- Align grid intervals with axis ticks, grow default value-label space to fit,
  and thin crowded default bar category labels. Explicit settings still win.
- Use the selected series marker and a thin guide for line hover indicators.
- Fit default pies and donuts inside compact layouts, and fit in-slice labels
  to their available space and text scale. Tooltips and semantics retain the
  full information when a label must be shortened or hidden.

### Fixes

- Preserve intrinsic sizing for line and bar charts while measuring their plot.
- Handle constant, zero, single-value, and very small chart layouts safely.

## 0.0.1-beta.3

- Fix axis labels ignoring supported text settings.
- Fix pie tooltip text styling and line/bar tooltip alignment and direction.
- Honor pie tooltip fitting flags; disabling fitting allows overflow.
- Preserve shared label typography when individual items override text styles.

Corrected text settings may require more label space; clipping is not generally
resolved. Dependency and SDK minimums are unchanged.

## 0.0.1-beta.2

- Add source-field metadata to generated Stylers; require Mix 2.2.0-beta.5.

## 0.0.1-beta.1

- Add `PieChartStyler.selectedSliceRadiusOffset` to control selection expansion
  (default: 8 pixels).

## 0.0.1-beta.0

- Introduce Mix-styled line/area, grouped/stacked/floating bar, and pie/donut charts.
- Add axes, tooltips, selection, animation, and accessibility support.
- Add a gallery, interactive playground, and dashboard example.
