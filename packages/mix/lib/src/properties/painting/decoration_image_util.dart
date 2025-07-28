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
    (prop) => call(DecorationImageMix.raw(image: prop)),
  );

  /// Utility for defining [DecorationImageMix.fit]
  late final fit = PropUtility<T, BoxFit>(
    (prop) => call(DecorationImageMix.raw(fit: prop)),
  );

  /// Utility for defining [DecorationImageMix.alignment]
  late final alignment = PropUtility<T, AlignmentGeometry>(
    (prop) => call(DecorationImageMix.raw(alignment: prop)),
  );

  /// Utility for defining [DecorationImageMix.centerSlice]
  late final centerSlice = PropUtility<T, Rect>(
    (prop) => call(DecorationImageMix.raw(centerSlice: prop)),
  );

  /// Utility for defining [DecorationImageMix.repeat]
  late final repeat = PropUtility<T, ImageRepeat>(
    (prop) => call(DecorationImageMix.raw(repeat: prop)),
  );

  /// Utility for defining [DecorationImageMix.filterQuality]
  late final filterQuality = PropUtility<T, FilterQuality>(
    (prop) => call(DecorationImageMix.raw(filterQuality: prop)),
  );

  /// Utility for defining [DecorationImageMix.invertColors]
  late final invertColors = PropUtility<T, bool>(
    (prop) => call(DecorationImageMix.raw(invertColors: prop)),
  );

  /// Utility for defining [DecorationImageMix.isAntiAlias]
  late final isAntiAlias = PropUtility<T, bool>(
    (prop) => call(DecorationImageMix.raw(isAntiAlias: prop)),
  );

  DecorationImageUtility(super.builder)
    : super(convertToMix: DecorationImageMix.value);

  @override
  T call(DecorationImageMix value) => builder(MixProp(value));
}
