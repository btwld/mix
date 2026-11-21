/// Built-in marker shapes supported without exposing renderer painters.
enum ChartMarkerShape { circle, square, cross }

/// Line interpolation modes.
enum LineCurve { straight, curved, stepBefore, stepMiddle, stepAfter }

/// Distribution of bar groups across the available width.
///
/// Horizontal scaling requires a space-based alignment.
enum BarAlignment { start, end, center, spaceEvenly, spaceAround, spaceBetween }

/// Placement of axis labels relative to the plot.
enum ChartAxisLabelAlignment { outside, inside }
