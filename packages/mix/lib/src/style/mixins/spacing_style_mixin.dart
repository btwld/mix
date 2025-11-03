import '../../core/mix_element.dart';
import '../../properties/layout/edge_insets_geometry_mix.dart';

/// Mixin that provides convenient spacing styling methods for styles
mixin SpacingStyleMixin<T extends Mix<Object?>> {
  /// Must be implemented by the class using this mixin
  T padding(EdgeInsetsGeometryMix value);

  /// Must be implemented by the class using this mixin
  T margin(EdgeInsetsGeometryMix value);

  // Padding convenience methods
  /// Sets the top padding.
  T paddingTop(double value) => padding(EdgeInsetsGeometryMix.top(value));
  /// Sets the bottom padding.
  T paddingBottom(double value) => padding(EdgeInsetsGeometryMix.bottom(value));
  /// Sets the left padding.
  T paddingLeft(double value) => padding(EdgeInsetsGeometryMix.left(value));
  /// Sets the right padding.
  T paddingRight(double value) => padding(EdgeInsetsGeometryMix.right(value));
  /// Sets horizontal (left and right) padding.
  T paddingX(double value) => padding(EdgeInsetsGeometryMix.horizontal(value));
  /// Sets vertical (top and bottom) padding.
  T paddingY(double value) => padding(EdgeInsetsGeometryMix.vertical(value));
  /// Sets padding on all sides.
  T paddingAll(double value) => padding(EdgeInsetsGeometryMix.all(value));
  /// Sets the start (leading) padding.
  T paddingStart(double value) => padding(EdgeInsetsGeometryMix.start(value));
  /// Sets the end (trailing) padding.
  T paddingEnd(double value) => padding(EdgeInsetsGeometryMix.end(value));

  /// Sets custom padding for each side with priority resolution.
  T paddingOnly({
    double? horizontal,
    double? vertical,
    double? start,
    double? end,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    // Priority resolution (most specific wins)
    final resolvedLeft = left ?? horizontal;
    final resolvedRight = right ?? horizontal;
    final resolvedTop = top ?? vertical;
    final resolvedBottom = bottom ?? vertical;

    // Use directional if start/end provided
    if (start != null || end != null) {
      return padding(
        EdgeInsetsGeometryMix.directional(
          start: start ?? resolvedLeft,
          end: end ?? resolvedRight,
          top: resolvedTop,
          bottom: resolvedBottom,
        ),
      );
    }

    // Otherwise use regular EdgeInsets
    return padding(
      EdgeInsetsGeometryMix.only(
        left: resolvedLeft,
        right: resolvedRight,
        top: resolvedTop,
        bottom: resolvedBottom,
      ),
    );
  }

  // Margin convenience methods

  /// Sets the top margin.
  T marginTop(double value) => margin(EdgeInsetsGeometryMix.top(value));
  /// Sets the bottom margin.
  T marginBottom(double value) => margin(EdgeInsetsGeometryMix.bottom(value));
  /// Sets the left margin.
  T marginLeft(double value) => margin(EdgeInsetsGeometryMix.left(value));
  /// Sets the right margin.
  T marginRight(double value) => margin(EdgeInsetsGeometryMix.right(value));
  /// Sets horizontal (left and right) margin.
  T marginX(double value) => margin(EdgeInsetsGeometryMix.horizontal(value));
  /// Sets vertical (top and bottom) margin.
  T marginY(double value) => margin(EdgeInsetsGeometryMix.vertical(value));
  /// Sets margin on all sides.
  T marginAll(double value) => margin(EdgeInsetsGeometryMix.all(value));
  /// Sets the start (leading) margin.
  T marginStart(double value) => margin(EdgeInsetsGeometryMix.start(value));
  /// Sets the end (trailing) margin.
  T marginEnd(double value) => margin(EdgeInsetsGeometryMix.end(value));

  /// Sets custom margin for each side with priority resolution.
  T marginOnly({
    double? horizontal,
    double? vertical,
    double? start,
    double? end,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    // Priority resolution (most specific wins)
    final resolvedLeft = left ?? horizontal;
    final resolvedRight = right ?? horizontal;
    final resolvedTop = top ?? vertical;
    final resolvedBottom = bottom ?? vertical;

    // Use directional if start/end provided
    if (start != null || end != null) {
      return margin(
        EdgeInsetsGeometryMix.directional(
          start: start ?? resolvedLeft,
          end: end ?? resolvedRight,
          top: resolvedTop,
          bottom: resolvedBottom,
        ),
      );
    }

    // Otherwise use regular EdgeInsets
    return margin(
      EdgeInsetsGeometryMix.only(
        left: resolvedLeft,
        right: resolvedRight,
        top: resolvedTop,
        bottom: resolvedBottom,
      ),
    );
  }
}
