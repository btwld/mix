import 'package:flutter/material.dart';

import '../../core/spec.dart';
import '../../core/style.dart';

/// Mixin that provides transform convenience methods for styling
mixin TransformMixin<T extends StyleAttribute<S>, S extends Spec<S>>
    on StyleAttribute<S> {
  
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
  T translate(double x, double y) {
    return transform(Matrix4.translationValues(x, y, 0.0));
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