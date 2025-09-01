import '../../core/mix_element.dart';
import 'edge_insets_geometry_mix.dart';

/// Mixin that provides convenient spacing methods for styles
mixin SpacingMixin<T extends Mix<Object?>> {
  /// Must be implemented by the class using this mixin
  T padding(EdgeInsetsGeometryMix value);

  /// Must be implemented by the class using this mixin
  T margin(EdgeInsetsGeometryMix value);

  T paddingHorizontal(double value) {
    return padding(EdgeInsetsGeometryMix.symmetric(horizontal: value));
  }

  /// Helper method for vertical padding (top and bottom)
  T paddingVertical(double value) {
    return padding(EdgeInsetsGeometryMix.symmetric(vertical: value));
  }

  /// Helper method for symmetric padding (horizontal and vertical)
  T paddingSymmetric({double horizontal = 0.0, double vertical = 0.0}) {
    return padding(
      EdgeInsetsGeometryMix.symmetric(
        vertical: vertical,
        horizontal: horizontal,
      ),
    );
  }

  /// Helper method for only specific sides
  T paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    return padding(
      EdgeInsetsGeometryMix.only(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
    );
  }

  /// Helper method for all sides
  T paddingAll(double value) {
    return padding(EdgeInsetsGeometryMix.all(value));
  }

  /// Helper method for horizontal margin (left and right)
  T marginHorizontal(double value) {
    return margin(EdgeInsetsGeometryMix.symmetric(horizontal: value));
  }

  /// Helper method for vertical margin (top and bottom)
  T marginVertical(double value) {
    return margin(EdgeInsetsGeometryMix.symmetric(vertical: value));
  }

  /// Helper method for symmetric margin (horizontal and vertical)
  T marginSymmetric({double horizontal = 0.0, double vertical = 0.0}) {
    return margin(
      EdgeInsetsGeometryMix.symmetric(
        vertical: vertical,
        horizontal: horizontal,
      ),
    );
  }

  /// Helper method for only specific sides
  T marginOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    return margin(
      EdgeInsetsGeometryMix.only(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
    );
  }

  /// Helper method for all sides
  T marginAll(double value) {
    return margin(EdgeInsetsGeometryMix.all(value));
  }
}
