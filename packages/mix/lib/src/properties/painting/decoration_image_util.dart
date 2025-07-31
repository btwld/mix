import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/utility.dart';
import 'decoration_image_mix.dart';

/// Utility class for configuring [DecorationImage] properties.
///
/// This class provides methods to set individual properties of a [DecorationImage].
/// Use the methods of this class to configure specific properties of a [DecorationImage].
final class DecorationImageUtility<T extends Style<Object?>>
    extends MixPropUtility<T, DecorationImageMix, DecorationImage> {
  /// Utility for defining [DecorationImageMix.image]
  late final provider = MixUtility<T, ImageProvider>(
    (prop) => only(image: prop),
  );

  /// Utility for defining [DecorationImageMix.fit]
  late final fit = MixUtility<T, BoxFit>((prop) => only(fit: prop));

  /// Utility for defining [DecorationImageMix.alignment]
  late final alignment = MixUtility<T, AlignmentGeometry>(
    (prop) => only(alignment: prop),
  );

  /// Utility for defining [DecorationImageMix.centerSlice]
  late final centerSlice = MixUtility<T, Rect>(
    (prop) => only(centerSlice: prop),
  );

  /// Utility for defining [DecorationImageMix.repeat]
  late final repeat = MixUtility<T, ImageRepeat>((prop) => only(repeat: prop));

  /// Utility for defining [DecorationImageMix.filterQuality]
  late final filterQuality = MixUtility<T, FilterQuality>(
    (prop) => only(filterQuality: prop),
  );

  /// Utility for defining [DecorationImageMix.invertColors]
  late final invertColors = MixUtility<T, bool>(
    (prop) => only(invertColors: prop),
  );

  /// Utility for defining [DecorationImageMix.isAntiAlias]
  late final isAntiAlias = MixUtility<T, bool>(
    (prop) => only(isAntiAlias: prop),
  );

  DecorationImageUtility(super.builder);

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
      DecorationImageMix(
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

  T call({
    ImageProvider? image,
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

  @override
  T as(DecorationImage value) {
    return builder(DecorationImageMix.value(value));
  }
}
