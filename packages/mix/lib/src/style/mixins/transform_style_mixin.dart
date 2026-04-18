import 'package:flutter/widgets.dart';

import '../../core/mix_element.dart';
import '../../modifiers/widget_modifier_config.dart';

/// Mixin that provides convenient transform styling methods for styles
mixin TransformStyleMixin<T extends Mix<Object?>> {
  /// Must be implemented by the class using this mixin
  T transform(Matrix4 value, {Alignment alignment = .center});

  /// Must be implemented by the class using this mixin
  T wrap(WidgetModifierConfig value);

  /// Sets rotation transform in radians.
  T rotate(double radians, {Alignment alignment = .center}) {
    return wrap(
      WidgetModifierConfig.rotate(radians: radians, alignment: alignment),
    );
  }

  /// Sets scale transform
  T scale(double scale, {Alignment alignment = .center}) {
    return transform(
      Matrix4.diagonal3Values(scale, scale, 1.0),
      alignment: alignment,
    );
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
