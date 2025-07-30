import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'decoration_image_mix.dart';

/// Utility class for configuring [DecorationImage] properties.
///
/// This class provides methods to set individual properties of a [DecorationImage].
/// Use the methods of this class to configure specific properties of a [DecorationImage].
final class DecorationImageUtility<T extends Style<Object?>>
    extends MixPropUtility<T, DecorationImage> {
  /// Utility for defining [DecorationImageMix.image]
  late final provider = PropUtility<T, ImageProvider>(
    (prop) => onlyProps(image: prop),
  );

  /// Utility for defining [DecorationImageMix.fit]
  late final fit = PropUtility<T, BoxFit>(
    (prop) => onlyProps(fit: prop),
  );

  /// Utility for defining [DecorationImageMix.alignment]
  late final alignment = PropUtility<T, AlignmentGeometry>(
    (prop) => onlyProps(alignment: prop),
  );

  /// Utility for defining [DecorationImageMix.centerSlice]
  late final centerSlice = PropUtility<T, Rect>(
    (prop) => onlyProps(centerSlice: prop),
  );

  /// Utility for defining [DecorationImageMix.repeat]
  late final repeat = PropUtility<T, ImageRepeat>(
    (prop) => onlyProps(repeat: prop),
  );

  /// Utility for defining [DecorationImageMix.filterQuality]
  late final filterQuality = PropUtility<T, FilterQuality>(
    (prop) => onlyProps(filterQuality: prop),
  );

  /// Utility for defining [DecorationImageMix.invertColors]
  late final invertColors = PropUtility<T, bool>(
    (prop) => onlyProps(invertColors: prop),
  );

  /// Utility for defining [DecorationImageMix.isAntiAlias]
  late final isAntiAlias = PropUtility<T, bool>(
    (prop) => onlyProps(isAntiAlias: prop),
  );

  DecorationImageUtility(super.builder)
    : super(convertToMix: DecorationImageMix.value);

  @protected
  T onlyProps({
    Prop<ImageProvider>? image,
    Prop<BoxFit>? fit,
    Prop<AlignmentGeometry>? alignment,
    Prop<Rect>? centerSlice,
    Prop<ImageRepeat>? repeat,
    Prop<FilterQuality>? filterQuality,
    Prop<bool>? invertColors,
    Prop<bool>? isAntiAlias,
  }) {
    return builder(
      MixProp(
        DecorationImageMix.raw(
          image: image,
          fit: fit,
          alignment: alignment,
          centerSlice: centerSlice,
          repeat: repeat,
          filterQuality: filterQuality,
          invertColors: invertColors,
          isAntiAlias: isAntiAlias,
        ),
      ),
    );
  }

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
    return onlyProps(
      image: Prop.maybe(image),
      fit: Prop.maybe(fit),
      alignment: Prop.maybe(alignment),
      centerSlice: Prop.maybe(centerSlice),
      repeat: Prop.maybe(repeat),
      filterQuality: Prop.maybe(filterQuality),
      invertColors: Prop.maybe(invertColors),
      isAntiAlias: Prop.maybe(isAntiAlias),
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
}
