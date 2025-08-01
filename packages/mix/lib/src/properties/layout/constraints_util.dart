import 'package:flutter/rendering.dart';

import '../../core/style.dart';
import '../../core/utility.dart';
import 'constraints_mix.dart';

/// Utility class for configuring [BoxConstraints] properties.
///
/// This class provides methods to set individual properties of a [BoxConstraints].
/// Use the methods of this class to configure specific properties of a [BoxConstraints].
final class BoxConstraintsUtility<T extends Style<Object?>>
    extends MixPropUtility<T, BoxConstraintsMix, BoxConstraints> {
  const BoxConstraintsUtility(super.builder);

  /// Utility for defining [BoxConstraintsMix.minWidth]
  @Deprecated('Use call(minWidth: value) instead')
  T minWidth(double v) => call(minWidth: v);

  /// Utility for defining [BoxConstraintsMix.maxWidth]
  @Deprecated('Use call(maxWidth: value) instead')
  T maxWidth(double v) => call(maxWidth: v);

  /// Utility for defining [BoxConstraintsMix.minHeight]
  @Deprecated('Use call(minHeight: value) instead')
  T minHeight(double v) => call(minHeight: v);

  /// Utility for defining [BoxConstraintsMix.maxHeight]
  @Deprecated('Use call(maxHeight: value) instead')
  T maxHeight(double v) => call(maxHeight: v);

  @Deprecated('Use call(minHeight: value, maxHeight: value) instead')
  T height(double v) => call(minHeight: v, maxHeight: v);

  @Deprecated('Use call(minWidth: value, maxWidth: value) instead')
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

  @Deprecated('Use call(...) instead')
  T only({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return call(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }

  @override
  T as(BoxConstraints value) {
    return builder(BoxConstraintsMix.value(value));
  }
}
