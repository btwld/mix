import 'package:flutter/widgets.dart';

import '../../../core/attribute.dart';
import '../../../core/utility.dart';
import '../../enum/enum_util.dart';
import '../../scalars/scalar_util.dart';
import 'decoration_image_dto.dart';

/// Utility class for configuring [DecorationImage] properties.
///
/// This class provides methods to set individual properties of a [DecorationImage].
/// Use the methods of this class to configure specific properties of a [DecorationImage].
class DecorationImageUtility<T extends Attribute>
    extends DtoUtility<T, DecorationImageDto, DecorationImage> {
  /// Utility for defining [DecorationImageDto.image]
  late final provider = ImageProviderUtility((v) => only(image: v));

  /// Utility for defining [DecorationImageDto.fit]
  late final fit = BoxFitUtility((v) => only(fit: v));

  /// Utility for defining [DecorationImageDto.alignment]
  late final alignment = AlignmentUtility((v) => only(alignment: v));

  /// Utility for defining [DecorationImageDto.centerSlice]
  late final centerSlice = RectUtility((v) => only(centerSlice: v));

  /// Utility for defining [DecorationImageDto.repeat]
  late final repeat = ImageRepeatUtility((v) => only(repeat: v));

  /// Utility for defining [DecorationImageDto.filterQuality]
  late final filterQuality = FilterQualityUtility(
    (v) => only(filterQuality: v),
  );

  /// Utility for defining [DecorationImageDto.invertColors]
  late final invertColors = BoolUtility(
    (prop) => builder(DecorationImageDto.props(invertColors: prop)),
  );

  /// Utility for defining [DecorationImageDto.isAntiAlias]
  late final isAntiAlias = BoolUtility(
    (prop) => builder(DecorationImageDto.props(isAntiAlias: prop)),
  );

  DecorationImageUtility(super.builder)
    : super(valueToDto: DecorationImageDto.value);

  T call({
    ImageProvider<Object>? image,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Rect? centerSlice,
    ImageRepeat? repeat,
    FilterQuality? filterQuality,
    bool? invertColors,
    bool? isAntiAlias,
  }) {
    return only(
      image: image,
      fit: fit,
      alignment: alignment,
      centerSlice: centerSlice,
      repeat: repeat,
      filterQuality: filterQuality,
      invertColors: invertColors,
      isAntiAlias: isAntiAlias,
    );
  }

  /// Returns a new [DecorationImageDto] with the specified properties.
  @override
  T only({
    ImageProvider? image,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Rect? centerSlice,
    ImageRepeat? repeat,
    FilterQuality? filterQuality,
    bool? invertColors,
    bool? isAntiAlias,
  }) {
    return builder(
      DecorationImageDto(
        image: image,
        fit: fit,
        alignment: alignment,
        centerSlice: centerSlice,
        repeat: repeat,
        filterQuality: filterQuality,
        invertColors: invertColors,
        isAntiAlias: isAntiAlias,
      ),
    );
  }
}

// Helper function
DecorationImageDto _decorationImageToDto(DecorationImage decorationImage) {
  return DecorationImageDto(
    image: decorationImage.image,
    fit: decorationImage.fit,
    alignment: decorationImage.alignment != Alignment.center
        ? decorationImage.alignment
        : null,
    centerSlice: decorationImage.centerSlice,
    repeat: decorationImage.repeat != ImageRepeat.noRepeat
        ? decorationImage.repeat
        : null,
    filterQuality: decorationImage.filterQuality != FilterQuality.low
        ? decorationImage.filterQuality
        : null,
    invertColors: decorationImage.invertColors ? true : null,
    isAntiAlias: !decorationImage.isAntiAlias ? false : null,
  );
}
