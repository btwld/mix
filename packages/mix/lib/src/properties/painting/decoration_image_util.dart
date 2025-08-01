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
  @Deprecated('Use call(image: value) instead')
  late final provider = MixUtility<T, ImageProvider>(
    (prop) => call(image: prop),
  );

  /// Utility for defining [DecorationImageMix.fit]
  @Deprecated('Use call(fit: value) instead')
  late final fit = MixUtility<T, BoxFit>((prop) => call(fit: prop));

  /// Utility for defining [DecorationImageMix.alignment]
  @Deprecated('Use call(alignment: value) instead')
  late final alignment = MixUtility<T, AlignmentGeometry>(
    (prop) => call(alignment: prop),
  );

  /// Utility for defining [DecorationImageMix.centerSlice]
  @Deprecated('Use call(centerSlice: value) instead')
  late final centerSlice = MixUtility<T, Rect>(
    (prop) => call(centerSlice: prop),
  );

  /// Utility for defining [DecorationImageMix.repeat]
  @Deprecated('Use call(repeat: value) instead')
  late final repeat = MixUtility<T, ImageRepeat>((prop) => call(repeat: prop));

  /// Utility for defining [DecorationImageMix.filterQuality]
  @Deprecated('Use call(filterQuality: value) instead')
  late final filterQuality = MixUtility<T, FilterQuality>(
    (prop) => call(filterQuality: prop),
  );

  @Deprecated('Use call(...) instead')
  late final only = call;

  DecorationImageUtility(super.builder);

  /// Utility for defining [DecorationImageMix.isAntiAlias]
  @Deprecated('Use call(isAntiAlias: value) instead')
  T isAntiAlias(bool v) => call(isAntiAlias: v);

  /// Utility for defining [DecorationImageMix.invertColors]
  @Deprecated('Use call(invertColors: value) instead')
  T invertColors(bool value) => call(invertColors: value);

  T call({
    DecorationImage? as,
    ImageProvider? image,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Rect? centerSlice,
    ImageRepeat? repeat,
    FilterQuality? filterQuality,
    bool? invertColors,
    bool? isAntiAlias,
  }) {
    if (as != null) {
      return builder(DecorationImageMix.value(as));
    }
    
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


  @override
  @Deprecated('Use call(as: value) instead')
  T as(DecorationImage value) {
    return builder(DecorationImageMix.value(value));
  }
}
