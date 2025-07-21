import 'package:flutter/widgets.dart';

import '../../../core/attribute.dart';
import '../../../core/prop.dart';
import '../../../core/utility.dart';
import '../../enum/enum_util.dart';
import '../../scalars/scalar_util.dart';
import 'decoration_image_dto.dart';

/// Utility class for configuring [DecorationImage] properties.
///
/// This class provides methods to set individual properties of a [DecorationImage].
/// Use the methods of this class to configure specific properties of a [DecorationImage].
final class DecorationImageUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, DecorationImage> {
  /// Utility for defining [DecorationImageDto.image]
  late final provider = ImageProviderUtility<T>(
    (prop) => call(DecorationImageDto(image: prop)),
  );

  /// Utility for defining [DecorationImageDto.fit]
  late final fit = BoxFitUtility<T>(
    (prop) => call(DecorationImageDto(fit: prop)),
  );

  /// Utility for defining [DecorationImageDto.alignment]
  late final alignment = AlignmentUtility<T>(
    (prop) => call(DecorationImageDto(alignment: prop)),
  );

  /// Utility for defining [DecorationImageDto.centerSlice]
  late final centerSlice = RectUtility<T>(
    (prop) => call(DecorationImageDto(centerSlice: prop)),
  );

  /// Utility for defining [DecorationImageDto.repeat]
  late final repeat = ImageRepeatUtility<T>(
    (prop) => call(DecorationImageDto(repeat: prop)),
  );

  /// Utility for defining [DecorationImageDto.filterQuality]
  late final filterQuality = FilterQualityUtility<T>(
    (prop) => call(DecorationImageDto(filterQuality: prop)),
  );

  /// Utility for defining [DecorationImageDto.invertColors]
  late final invertColors = BoolUtility<T>(
    (prop) => call(DecorationImageDto(invertColors: prop)),
  );

  /// Utility for defining [DecorationImageDto.isAntiAlias]
  late final isAntiAlias = BoolUtility<T>(
    (prop) => call(DecorationImageDto(isAntiAlias: prop)),
  );

  DecorationImageUtility(super.builder)
    : super(valueToMix: DecorationImageDto.value);

  @override
  T call(DecorationImageDto value) => builder(MixProp(value));
}
