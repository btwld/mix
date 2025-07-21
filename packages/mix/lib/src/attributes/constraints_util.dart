import 'package:flutter/rendering.dart';

import '../core/attribute.dart';
import '../core/prop.dart';
import '../core/utility.dart';
import 'constraints_dto.dart';
import 'scalar_util.dart';

/// Utility class for configuring [BoxConstraints] properties.
///
/// This class provides methods to set individual properties of a [BoxConstraints].
/// Use the methods of this class to configure specific properties of a [BoxConstraints].
final class BoxConstraintsUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, BoxConstraints> {
  /// Utility for defining [BoxConstraintsDto.minWidth]
  late final minWidth = DoubleUtility<T>(
    (prop) => call(BoxConstraintsDto(minWidth: prop)),
  );

  /// Utility for defining [BoxConstraintsDto.maxWidth]
  late final maxWidth = DoubleUtility<T>(
    (prop) => call(BoxConstraintsDto(maxWidth: prop)),
  );

  /// Utility for defining [BoxConstraintsDto.minHeight]
  late final minHeight = DoubleUtility<T>(
    (prop) => call(BoxConstraintsDto(minHeight: prop)),
  );

  /// Utility for defining [BoxConstraintsDto.maxHeight]
  late final maxHeight = DoubleUtility<T>(
    (prop) => call(BoxConstraintsDto(maxHeight: prop)),
  );

  BoxConstraintsUtility(super.builder)
    : super(valueToMix: BoxConstraintsDto.value);

  @override
  T call(BoxConstraintsDto value) => builder(MixProp(value));
}
