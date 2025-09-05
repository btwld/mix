import '../../core/mix_element.dart';
import '../../properties/layout/constraints_mix.dart';

/// Mixin that provides convenient constraint styling methods for styles
mixin ConstraintStyleMixin<T extends Mix<Object?>> {
  /// Must be implemented by the class using this mixin
  T constraints(BoxConstraintsMix value);

  /// Sets both min and max width to create a fixed width
  T width(double value) {
    return constraints(BoxConstraintsMix.width(value));
  }

  /// Sets both min and max height to create a fixed height
  T height(double value) {
    return constraints(BoxConstraintsMix.height(value));
  }

  /// Sets minimum width constraint
  T minWidth(double value) {
    return constraints(BoxConstraintsMix.minWidth(value));
  }

  /// Sets maximum width constraint
  T maxWidth(double value) {
    return constraints(BoxConstraintsMix.maxWidth(value));
  }

  /// Sets minimum height constraint
  T minHeight(double value) {
    return constraints(BoxConstraintsMix.minHeight(value));
  }

  /// Sets maximum height constraint
  T maxHeight(double value) {
    return constraints(BoxConstraintsMix.maxHeight(value));
  }

  /// Sets both width and height to specific values
  T size(double width, double height) {
    return constraints(
      BoxConstraintsMix(
        minWidth: width,
        maxWidth: width,
        minHeight: height,
        maxHeight: height,
      ),
    );
  }

  /// Creates constraints with only specified values, supporting priority resolution
  T constraintsOnly({
    double? width,
    double? height,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    // Width sets both min and max unless overridden
    final resolvedMinWidth = minWidth ?? width;
    final resolvedMaxWidth = maxWidth ?? width;

    // Height sets both min and max unless overridden
    final resolvedMinHeight = minHeight ?? height;
    final resolvedMaxHeight = maxHeight ?? height;

    return constraints(BoxConstraintsMix(
      minWidth: resolvedMinWidth,
      maxWidth: resolvedMaxWidth,
      minHeight: resolvedMinHeight,
      maxHeight: resolvedMaxHeight,
    ));
  }
}