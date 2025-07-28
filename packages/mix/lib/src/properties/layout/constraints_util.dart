import 'package:flutter/rendering.dart';

import '../../core/prop.dart';
import '../../core/spec.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'constraints_mix.dart';

/// Mixin that provides convenient constraints methods for spec attributes.
///
/// This mixin follows the same pattern as BorderRadiusMixin and ModifierMixin,
/// providing a fluent API for applying constraints to spec attributes.
mixin ConstraintsMixin<T extends StyleAttribute<S>, S extends Spec<S>>
    on StyleAttribute<S> {
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
    return constraints(BoxConstraintsMix(
      minWidth: width,
      maxWidth: width,
      minHeight: height,
      maxHeight: height,
    ));
  }
}

/// Utility class for configuring [BoxConstraints] properties.
///
/// This class provides methods to set individual properties of a [BoxConstraints].
/// Use the methods of this class to configure specific properties of a [BoxConstraints].
final class BoxConstraintsUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, BoxConstraints> {
  /// Utility for defining [BoxConstraintsMix.minWidth]
  late final minWidth = PropUtility<T, double>(
    (prop) => call(BoxConstraintsMix.raw(minWidth: prop)),
  );

  /// Utility for defining [BoxConstraintsMix.maxWidth]
  late final maxWidth = PropUtility<T, double>(
    (prop) => call(BoxConstraintsMix.raw(maxWidth: prop)),
  );

  /// Utility for defining [BoxConstraintsMix.minHeight]
  late final minHeight = PropUtility<T, double>(
    (prop) => call(BoxConstraintsMix.raw(minHeight: prop)),
  );

  /// Utility for defining [BoxConstraintsMix.maxHeight]
  late final maxHeight = PropUtility<T, double>(
    (prop) => call(BoxConstraintsMix.raw(maxHeight: prop)),
  );

  late final height = PropUtility<T, double>(
    (prop) => call(BoxConstraintsMix.raw(minHeight: prop, maxHeight: prop)),
  );

  late final width = PropUtility<T, double>(
    (prop) => call(BoxConstraintsMix.raw(minWidth: prop, maxWidth: prop)),
  );

  BoxConstraintsUtility(super.builder)
    : super(convertToMix: BoxConstraintsMix.value);

  @override
  T call(BoxConstraintsMix value) => builder(MixProp(value));
}
