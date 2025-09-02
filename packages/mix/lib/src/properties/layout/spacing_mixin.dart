import '../../core/mix_element.dart';
import 'edge_insets_geometry_mix.dart';

/// Mixin that provides convenient spacing methods for styles
mixin SpacingMixin<T extends Mix<Object?>> {
  /// Must be implemented by the class using this mixin
  T padding(EdgeInsetsGeometryMix value);

  /// Must be implemented by the class using this mixin
  T margin(EdgeInsetsGeometryMix value);

  // Padding convenience methods
  T paddingTop(double value) => padding(EdgeInsetsGeometryMix.top(value));
  T paddingBottom(double value) => padding(EdgeInsetsGeometryMix.bottom(value));
  T paddingLeft(double value) => padding(EdgeInsetsGeometryMix.left(value));
  T paddingRight(double value) => padding(EdgeInsetsGeometryMix.right(value));
  T paddingHorizontal(double value) => padding(EdgeInsetsGeometryMix.horizontal(value));
  T paddingVertical(double value) => padding(EdgeInsetsGeometryMix.vertical(value));
  T paddingAll(double value) => padding(EdgeInsetsGeometryMix.all(value));
  T paddingStart(double value) => padding(EdgeInsetsGeometryMix.start(value));
  T paddingEnd(double value) => padding(EdgeInsetsGeometryMix.end(value));

  // Margin convenience methods
  T marginTop(double value) => margin(EdgeInsetsGeometryMix.top(value));
  T marginBottom(double value) => margin(EdgeInsetsGeometryMix.bottom(value));
  T marginLeft(double value) => margin(EdgeInsetsGeometryMix.left(value));
  T marginRight(double value) => margin(EdgeInsetsGeometryMix.right(value));
  T marginHorizontal(double value) => margin(EdgeInsetsGeometryMix.horizontal(value));
  T marginVertical(double value) => margin(EdgeInsetsGeometryMix.vertical(value));
  T marginAll(double value) => margin(EdgeInsetsGeometryMix.all(value));
  T marginStart(double value) => margin(EdgeInsetsGeometryMix.start(value));
  T marginEnd(double value) => margin(EdgeInsetsGeometryMix.end(value));
}
