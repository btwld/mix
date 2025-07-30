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
  /// Utility for defining [BoxConstraintsMix.minWidth]
  late final minWidth = PropUtility<T, double>((prop) => only(minWidth: prop));

  /// Utility for defining [BoxConstraintsMix.maxWidth]
  late final maxWidth = PropUtility<T, double>((prop) => only(maxWidth: prop));

  /// Utility for defining [BoxConstraintsMix.minHeight]
  late final minHeight = PropUtility<T, double>(
    (prop) => only(minHeight: prop),
  );

  /// Utility for defining [BoxConstraintsMix.maxHeight]
  late final maxHeight = PropUtility<T, double>(
    (prop) => only(maxHeight: prop),
  );

  late final height = PropUtility<T, double>(
    (prop) => only(minHeight: prop, maxHeight: prop),
  );

  late final width = PropUtility<T, double>(
    (prop) => only(minWidth: prop, maxWidth: prop),
  );

  BoxConstraintsUtility(super.builder)
    : super(convertToMix: BoxConstraintsMix.value);

  T only({
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

  T call({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return only(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }
}
