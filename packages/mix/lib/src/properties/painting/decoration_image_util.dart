import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/utility.dart';
import 'decoration_image_mix.dart';

/// Utility class for configuring [DecorationImage] properties.
///
/// This class provides methods to set individual properties of a [DecorationImage].
/// Use the methods of this class to configure specific properties of a [DecorationImage].
final class DecorationImageUtility<T extends Style<Object?>>
    extends MixUtility<T, DecorationImageMix> {
  /// Utility for defining [DecorationImageMix.image]
  late final provider = MixUtility<T, ImageProvider>(
    (prop) => call(image: prop),
  );

  /// Utility for defining [DecorationImageMix.fit]
  late final fit = MixUtility<T, BoxFit>((prop) => call(fit: prop));

  /// Utility for defining [DecorationImageMix.alignment]
  late final alignment = MixUtility<T, AlignmentGeometry>(
    (prop) => call(alignment: prop),
  );

  /// Utility for defining [DecorationImageMix.centerSlice]
  late final centerSlice = MixUtility<T, Rect>(
    (prop) => call(centerSlice: prop),
  );

  /// Utility for defining [DecorationImageMix.repeat]
  late final repeat = MixUtility<T, ImageRepeat>((prop) => call(repeat: prop));

  /// Utility for defining [DecorationImageMix.filterQuality]
  late final filterQuality = MixUtility<T, FilterQuality>(
    (prop) => call(filterQuality: prop),
  );

  DecorationImageUtility(super.utilityBuilder);

  /// Utility for defining [DecorationImageMix.isAntiAlias]
  T isAntiAlias(bool v) => call(isAntiAlias: v);

  /// Utility for defining [DecorationImageMix.invertColors]
  T invertColors(bool value) => call(invertColors: value);

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
    return utilityBuilder(
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

  T as(DecorationImage value) {
    return utilityBuilder(DecorationImageMix.value(value));
  }
}
