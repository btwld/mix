import 'package:flutter/widgets.dart';

import '../../../core/factory/mix_context.dart';
import '../../../core/mix_element.dart';
import '../../../core/mix_property.dart';
import '../../../core/utility.dart';
import '../../enum/enum_util.dart';
import '../../scalars/scalar_util.dart';
import 'decoration_image_dto.dart';

/// Utility class for configuring [DecorationImage] properties.
///
/// This class provides methods to set individual properties of a [DecorationImage].
/// Use the methods of this class to configure specific properties of a [DecorationImage].
class DecorationImageUtility<T extends StyleElement>
    extends DtoUtility<T, DecorationImageDto, DecorationImage> {
  /// Utility for defining [DecorationImageDto.image]
  late final provider = ImageProviderUtility((v) => only(image: ImageProviderMix(v)));

  /// Utility for defining [DecorationImageDto.fit]
  late final fit = BoxFitUtility((v) => only(fit: EnumMix(v)));

  /// Utility for defining [DecorationImageDto.alignment]
  late final alignment = AlignmentUtility(
    (v) => only(alignment: _AlignmentGeometryMix(v)),
  );

  /// Utility for defining [DecorationImageDto.centerSlice]
  late final centerSlice = RectUtility((v) => only(centerSlice: RectMix(v)));

  /// Utility for defining [DecorationImageDto.repeat]
  late final repeat = ImageRepeatUtility((v) => only(repeat: EnumMix(v)));

  /// Utility for defining [DecorationImageDto.filterQuality]
  late final filterQuality = FilterQualityUtility(
    (v) => only(filterQuality: EnumMix(v)),
  );

  /// Utility for defining [DecorationImageDto.invertColors]
  late final invertColors = BoolUtility(
    (v) => only(invertColors: BoolMix(v)),
  );

  /// Utility for defining [DecorationImageDto.isAntiAlias]
  late final isAntiAlias = BoolUtility((v) => only(isAntiAlias: BoolMix(v)));

  DecorationImageUtility(super.builder)
    : super(valueToDto: (v) => _decorationImageToDto(v));

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
      image: image != null ? ImageProviderMix(image) : null,
      fit: fit != null ? EnumMix(fit) : null,
      alignment: alignment != null ? _AlignmentGeometryMix(alignment) : null,
      centerSlice: centerSlice != null ? RectMix(centerSlice) : null,
      repeat: repeat != null ? EnumMix(repeat) : null,
      filterQuality: filterQuality != null ? EnumMix(filterQuality) : null,
      invertColors: invertColors != null ? BoolMix(invertColors) : null,
      isAntiAlias: isAntiAlias != null ? BoolMix(isAntiAlias) : null,
    );
  }

  /// Returns a new [DecorationImageDto] with the specified properties.
  @override
  T only({
    Mix<ImageProvider>? image,
    Mix<BoxFit>? fit,
    Mix<AlignmentGeometry>? alignment,
    Mix<Rect>? centerSlice,
    Mix<ImageRepeat>? repeat,
    Mix<FilterQuality>? filterQuality,
    Mix<bool>? invertColors,
    Mix<bool>? isAntiAlias,
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
    image: ImageProviderMix(decorationImage.image),
    fit: decorationImage.fit != null ? EnumMix(decorationImage.fit!) : null,
    alignment: decorationImage.alignment != Alignment.center 
        ? _AlignmentGeometryMix(decorationImage.alignment) 
        : null,
    centerSlice: decorationImage.centerSlice != null 
        ? RectMix(decorationImage.centerSlice!) 
        : null,
    repeat: decorationImage.repeat != ImageRepeat.noRepeat 
        ? EnumMix(decorationImage.repeat) 
        : null,
    filterQuality: decorationImage.filterQuality != FilterQuality.low 
        ? EnumMix(decorationImage.filterQuality) 
        : null,
    invertColors: decorationImage.invertColors ? const BoolMix(true) : null,
    isAntiAlias: !decorationImage.isAntiAlias ? const BoolMix(false) : null,
  );
}

// Helper class for AlignmentGeometry
class _AlignmentGeometryMix extends Mix<AlignmentGeometry> {
  final AlignmentGeometry value;
  const _AlignmentGeometryMix(this.value);

  @override
  AlignmentGeometry resolve(MixContext mix) => value;

  @override
  Mix<AlignmentGeometry> merge(Mix<AlignmentGeometry>? other) {
    return other ?? this;
  }

  @override
  get props => [value];
}