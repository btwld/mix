import 'package:flutter/rendering.dart';

import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import 'constraints_mix.dart';
import 'scalar_util.dart';

/// Utility class for configuring [BoxConstraints] properties.
///
/// This class provides methods to set individual properties of a [BoxConstraints].
/// Use the methods of this class to configure specific properties of a [BoxConstraints].
final class BoxConstraintsUtility<T extends SpecStyle<Object?>>
    extends MixPropUtility<T, BoxConstraints> {
  /// Utility for defining [BoxConstraintsMix.minWidth]
  late final minWidth = DoubleUtility<T>(
    (prop) => call(BoxConstraintsMix(minWidth: prop)),
  );

  /// Utility for defining [BoxConstraintsMix.maxWidth]
  late final maxWidth = DoubleUtility<T>(
    (prop) => call(BoxConstraintsMix(maxWidth: prop)),
  );

  /// Utility for defining [BoxConstraintsMix.minHeight]
  late final minHeight = DoubleUtility<T>(
    (prop) => call(BoxConstraintsMix(minHeight: prop)),
  );

  /// Utility for defining [BoxConstraintsMix.maxHeight]
  late final maxHeight = DoubleUtility<T>(
    (prop) => call(BoxConstraintsMix(maxHeight: prop)),
  );

  late final height = DoubleUtility<T>(
    (prop) => call(BoxConstraintsMix(minHeight: prop, maxHeight: prop)),
  );

  late final width = DoubleUtility<T>(
    (prop) => call(BoxConstraintsMix(minWidth: prop, maxWidth: prop)),
  );

  BoxConstraintsUtility(super.builder)
    : super(convertToMix: BoxConstraintsMix.value);

  @override
  T call(BoxConstraintsMix value) => builder(MixProp(value));
}
