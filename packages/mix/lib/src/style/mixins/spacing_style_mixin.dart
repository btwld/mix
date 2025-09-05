import '../../core/mix_element.dart';
import '../../properties/layout/edge_insets_geometry_mix.dart';

/// Mixin that provides convenient spacing styling methods for styles
mixin SpacingStyleMixin<T extends Mix<Object?>> {
  /// Must be implemented by the class using this mixin
  T padding(EdgeInsetsGeometryMix value);

  /// Must be implemented by the class using this mixin
  T margin(EdgeInsetsGeometryMix value);

  // Padding convenience methods
  T paddingTop(double value) => padding(EdgeInsetsGeometryMix.top(value));
  T paddingBottom(double value) => padding(EdgeInsetsGeometryMix.bottom(value));
  T paddingLeft(double value) => padding(EdgeInsetsGeometryMix.left(value));
  T paddingRight(double value) => padding(EdgeInsetsGeometryMix.right(value));
  T paddingX(double value) => padding(EdgeInsetsGeometryMix.horizontal(value));
  T paddingY(double value) => padding(EdgeInsetsGeometryMix.vertical(value));
  T paddingAll(double value) => padding(EdgeInsetsGeometryMix.all(value));
  T paddingStart(double value) => padding(EdgeInsetsGeometryMix.start(value));
  T paddingEnd(double value) => padding(EdgeInsetsGeometryMix.end(value));

  /// Creates padding with only specified values, supporting priority resolution
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
      return padding(EdgeInsetsGeometryMix.directional(
        start: start ?? resolvedLeft,
        end: end ?? resolvedRight,
        top: resolvedTop,
        bottom: resolvedBottom,
      ));
    }

    // Otherwise use regular EdgeInsets
    return padding(EdgeInsetsGeometryMix.only(
      left: resolvedLeft,
      right: resolvedRight,
      top: resolvedTop,
      bottom: resolvedBottom,
    ));
  }

  // Margin convenience methods
  T marginTop(double value) => margin(EdgeInsetsGeometryMix.top(value));
  T marginBottom(double value) => margin(EdgeInsetsGeometryMix.bottom(value));
  T marginLeft(double value) => margin(EdgeInsetsGeometryMix.left(value));
  T marginRight(double value) => margin(EdgeInsetsGeometryMix.right(value));
  T marginX(double value) => margin(EdgeInsetsGeometryMix.horizontal(value));
  T marginY(double value) => margin(EdgeInsetsGeometryMix.vertical(value));
  T marginAll(double value) => margin(EdgeInsetsGeometryMix.all(value));
  T marginStart(double value) => margin(EdgeInsetsGeometryMix.start(value));
  T marginEnd(double value) => margin(EdgeInsetsGeometryMix.end(value));

  /// Creates margin with only specified values, supporting priority resolution
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
      return margin(EdgeInsetsGeometryMix.directional(
        start: start ?? resolvedLeft,
        end: end ?? resolvedRight,
        top: resolvedTop,
        bottom: resolvedBottom,
      ));
    }

    // Otherwise use regular EdgeInsets
    return margin(EdgeInsetsGeometryMix.only(
      left: resolvedLeft,
      right: resolvedRight,
      top: resolvedTop,
      bottom: resolvedBottom,
    ));
  }
}