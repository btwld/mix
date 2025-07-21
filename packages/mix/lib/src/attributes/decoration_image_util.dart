import 'package:flutter/widgets.dart';

import '../core/attribute.dart';
import '../core/prop.dart';
import '../core/utility.dart';
import 'decoration_image_mix.dart';
import 'scalar_util.dart';

/// Utility class for configuring [DecorationImage] properties.
///
/// This class provides methods to set individual properties of a [DecorationImage].
/// Use the methods of this class to configure specific properties of a [DecorationImage].
final class DecorationImageUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, DecorationImage> {
  /// Utility for defining [DecorationImageMix.image]
  late final provider = ImageProviderUtility<T>(
    (prop) => call(DecorationImageMix(image: prop)),
  );

  /// Utility for defining [DecorationImageMix.fit]
  late final fit = BoxFitUtility<T>(
    (prop) => call(DecorationImageMix(fit: prop)),
  );

  /// Utility for defining [DecorationImageMix.alignment]
  late final alignment = AlignmentUtility<T>(
    (prop) => call(DecorationImageMix(alignment: prop)),
  );

  /// Utility for defining [DecorationImageMix.centerSlice]
  late final centerSlice = RectUtility<T>(
    (prop) => call(DecorationImageMix(centerSlice: prop)),
  );

  /// Utility for defining [DecorationImageMix.repeat]
  late final repeat = ImageRepeatUtility<T>(
    (prop) => call(DecorationImageMix(repeat: prop)),
  );

  /// Utility for defining [DecorationImageMix.filterQuality]
  late final filterQuality = FilterQualityUtility<T>(
    (prop) => call(DecorationImageMix(filterQuality: prop)),
  );

  /// Utility for defining [DecorationImageMix.invertColors]
  late final invertColors = BoolUtility<T>(
    (prop) => call(DecorationImageMix(invertColors: prop)),
  );

  /// Utility for defining [DecorationImageMix.isAntiAlias]
  late final isAntiAlias = BoolUtility<T>(
    (prop) => call(DecorationImageMix(isAntiAlias: prop)),
  );

  DecorationImageUtility(super.builder)
    : super(convertToMix: DecorationImageMix.value);

  @override
  T call(DecorationImageMix value) => builder(MixProp(value));
}
