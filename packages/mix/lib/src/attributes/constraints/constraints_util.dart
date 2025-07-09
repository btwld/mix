import 'package:flutter/rendering.dart';

import '../../core/mix_element.dart';
import '../../core/mix_property.dart';
import '../../core/utility.dart';
import '../scalars/scalar_util.dart';
import 'constraints_dto.dart';

/// Utility class for configuring [BoxConstraints] properties.
///
/// This class provides methods to set individual properties of a [BoxConstraints].
/// Use the methods of this class to configure specific properties of a [BoxConstraints].
class BoxConstraintsUtility<T extends StyleElement>
    extends DtoUtility<T, BoxConstraintsDto, BoxConstraints> {
  /// Utility for defining [BoxConstraintsDto.minWidth]
  late final minWidth = DoubleUtility((v) => only(minWidth: DoubleMix(v)));

  /// Utility for defining [BoxConstraintsDto.maxWidth]
  late final maxWidth = DoubleUtility((v) => only(maxWidth: DoubleMix(v)));

  /// Utility for defining [BoxConstraintsDto.minHeight]
  late final minHeight = DoubleUtility((v) => only(minHeight: DoubleMix(v)));

  /// Utility for defining [BoxConstraintsDto.maxHeight]
  late final maxHeight = DoubleUtility((v) => only(maxHeight: DoubleMix(v)));

  BoxConstraintsUtility(super.builder)
    : super(valueToDto: (v) => BoxConstraintsDto(
          minWidth: v.minWidth != 0.0 ? DoubleMix(v.minWidth) : null,
          maxWidth: v.maxWidth != double.infinity ? DoubleMix(v.maxWidth) : null,
          minHeight: v.minHeight != 0.0 ? DoubleMix(v.minHeight) : null,
          maxHeight: v.maxHeight != double.infinity ? DoubleMix(v.maxHeight) : null,
        ));

  T call({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return only(
      minWidth: minWidth != null ? DoubleMix(minWidth) : null,
      maxWidth: maxWidth != null ? DoubleMix(maxWidth) : null,
      minHeight: minHeight != null ? DoubleMix(minHeight) : null,
      maxHeight: maxHeight != null ? DoubleMix(maxHeight) : null,
    );
  }

  /// Returns a new [BoxConstraintsDto] with the specified properties.
  @override
  T only({
    Mix<double>? minWidth,
    Mix<double>? maxWidth,
    Mix<double>? minHeight,
    Mix<double>? maxHeight,
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