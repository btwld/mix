import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'constraints_mix.dart';

/// Utility class for configuring [BoxConstraints] properties.
///
/// This class provides methods to set individual properties of a [BoxConstraints].
/// Use the methods of this class to configure specific properties of a [BoxConstraints].
final class BoxConstraintsUtility<T extends Style<Object?>>
    extends MixPropUtility<T, BoxConstraints> {
  /// Utility for defining [BoxConstraintsMix.minWidth]
  late final minWidth = PropUtility<T, double>(
    (prop) => onlyProps(minWidth: prop),
  );

  /// Utility for defining [BoxConstraintsMix.maxWidth]
  late final maxWidth = PropUtility<T, double>(
    (prop) => onlyProps(maxWidth: prop),
  );

  /// Utility for defining [BoxConstraintsMix.minHeight]
  late final minHeight = PropUtility<T, double>(
    (prop) => onlyProps(minHeight: prop),
  );

  /// Utility for defining [BoxConstraintsMix.maxHeight]
  late final maxHeight = PropUtility<T, double>(
    (prop) => onlyProps(maxHeight: prop),
  );

  late final height = PropUtility<T, double>(
    (prop) => onlyProps(minHeight: prop, maxHeight: prop),
  );

  late final width = PropUtility<T, double>(
    (prop) => onlyProps(minWidth: prop, maxWidth: prop),
  );

  BoxConstraintsUtility(super.builder)
    : super(convertToMix: BoxConstraintsMix.value);

  @protected
  T onlyProps({
    Prop<double>? minWidth,
    Prop<double>? maxWidth,
    Prop<double>? minHeight,
    Prop<double>? maxHeight,
  }) {
    return builder(
      MixProp(
        BoxConstraintsMix.raw(
          minWidth: minWidth,
          maxWidth: maxWidth,
          minHeight: minHeight,
          maxHeight: maxHeight,
        ),
      ),
    );
  }

  T only({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return onlyProps(
      minWidth: Prop.maybe(minWidth),
      maxWidth: Prop.maybe(maxWidth),
      minHeight: Prop.maybe(minHeight),
      maxHeight: Prop.maybe(maxHeight),
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
