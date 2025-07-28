import 'package:flutter/rendering.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'constraints_mix.dart';

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