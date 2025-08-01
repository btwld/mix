import 'package:flutter/rendering.dart';

import '../../core/style.dart';
import '../../core/utility.dart';
import 'constraints_mix.dart';

/// Utility class for configuring [BoxConstraints] properties.
///
/// This class provides methods to set individual properties of a [BoxConstraints].
/// Use the methods of this class to configure specific properties of a [BoxConstraints].
final class BoxConstraintsUtility<T extends Style<Object?>>
    extends MixUtility<T, BoxConstraintsMix> {
  @Deprecated('Use call(...) instead')
  late final only = call;

  BoxConstraintsUtility(super.builder);

  /// Utility for defining [BoxConstraintsMix.minWidth]
  T minWidth(double v) => call(minWidth: v);

  /// Utility for defining [BoxConstraintsMix.maxWidth]
  T maxWidth(double v) => call(maxWidth: v);

  /// Utility for defining [BoxConstraintsMix.minHeight]
  T minHeight(double v) => call(minHeight: v);

  /// Utility for defining [BoxConstraintsMix.maxHeight]
  T maxHeight(double v) => call(maxHeight: v);

  T height(double v) => call(minHeight: v, maxHeight: v);

  T width(double v) => call(minWidth: v, maxWidth: v);

  T call({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return builder(
      BoxConstraintsMix(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      ),
    );
  }

  T as(BoxConstraints value) {
    return builder(BoxConstraintsMix.value(value));
  }
}
