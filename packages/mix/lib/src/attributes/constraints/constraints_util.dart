import 'package:flutter/rendering.dart';

import '../../core/spec.dart';
import '../../core/utility.dart';
import 'constraints_dto.dart';

/// Utility class for configuring [BoxConstraints] properties.
///
/// This class provides methods to set individual properties of a [BoxConstraints].
/// Use the methods of this class to configure specific properties of a [BoxConstraints].
class BoxConstraintsUtility<T extends SpecAttribute>
    extends DtoUtility<T, BoxConstraintsDto, BoxConstraints> {
  /// Utility for defining [BoxConstraintsDto.minWidth]
  late final minWidth = DoubleUtility(
    (prop) => builder(BoxConstraintsDto.props(minWidth: prop)),
  );

  /// Utility for defining [BoxConstraintsDto.maxWidth]
  late final maxWidth = DoubleUtility(
    (prop) => builder(BoxConstraintsDto.props(maxWidth: prop)),
  );

  /// Utility for defining [BoxConstraintsDto.minHeight]
  late final minHeight = DoubleUtility(
    (prop) => builder(BoxConstraintsDto.props(minHeight: prop)),
  );

  /// Utility for defining [BoxConstraintsDto.maxHeight]
  late final maxHeight = DoubleUtility(
    (prop) => builder(BoxConstraintsDto.props(maxHeight: prop)),
  );

  BoxConstraintsUtility(super.builder)
    : super(valueToDto: BoxConstraintsDto.value);
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

  /// Returns a new [BoxConstraintsDto] with the specified properties.
  @override
  T only({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return builder(
      BoxConstraintsDto(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      ),
    );
  }
}
