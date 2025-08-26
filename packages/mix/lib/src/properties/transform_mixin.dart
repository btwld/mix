import 'package:flutter/widgets.dart';

import '../core/mix_element.dart';

/// Mixin that provides convenient transform methods for styles
mixin TransformMixin<T extends Mix<Object?>> {
  /// Must be implemented by the class using this mixin
  T transform(Matrix4 value);

  /// Sets rotation transform
  T rotate(double angle) {
    return transform(Matrix4.rotationZ(angle));
  }

  /// Sets scale transform
  T scale(double scale) {
    return transform(Matrix4.diagonal3Values(scale, scale, 1.0));
  }

  /// Sets translation transform
  T translate(double x, double y, [double z = 0.0]) {
    return transform(Matrix4.translationValues(x, y, z));
  }

  /// Sets skew transform
  T skew(double skewX, double skewY) {
    final matrix = Matrix4.identity();
    matrix.setEntry(0, 1, skewX);
    matrix.setEntry(1, 0, skewY);

    return transform(matrix);
  }

  /// Resets transform to identity (no effect)
  T transformReset() {
    return transform(Matrix4.identity());
  }
}
