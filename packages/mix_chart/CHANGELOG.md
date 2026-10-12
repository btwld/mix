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
