// ignore_for_file: unused_element, prefer_relative_imports, avoid-importing-entrypoint-exports

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'scalar_util.g.dart';

// Note: MixableDirective and private implementations are now in core/element.dart

@MixableUtility(referenceType: Alignment)
final class AlignmentUtility<T extends StyleElement>
    extends MixUtility<T, AlignmentGeometry> with _$AlignmentUtility {
  const AlignmentUtility(super.builder);

  /// Creates an [StyleElement] instance with a custom [Alignment] or [AlignmentDirectional] value.
  ///
  /// If [start] is provided, an [AlignmentDirectional] is created. Otherwise, an [Alignment] is created.
  /// Throws an [AssertionError] if both [x] and [start] are provided.
  T only({double? x, double? y, double? start}) {
    assert(x == null || start == null,
        'Cannot provide both an x and a start parameter.');

    return start == null
        ? builder(Alignment(x ?? 0, y ?? 0))
        : builder(AlignmentDirectional(start, y ?? 0));
  }
}

final class AlignmentGeometryUtility<T extends StyleElement>
    extends AlignmentUtility<T> {
  late final directional = AlignmentDirectionalUtility(builder);
  AlignmentGeometryUtility(super.builder);
}

@MixableUtility()
final class AlignmentDirectionalUtility<T extends StyleElement>
    extends MixUtility<T, AlignmentDirectional>
    with _$AlignmentDirectionalUtility {
  const AlignmentDirectionalUtility(super.builder);
  T only({double? y, double? start}) {
    return builder(AlignmentDirectional(start ?? 0, y ?? 0));
  }
}

@MixableUtility()
final class FontFeatureUtility<T extends StyleElement>
    extends MixUtility<T, FontFeature> with _$FontFeatureUtility {
  const FontFeatureUtility(super.builder);
}

@MixableUtility()
final class DurationUtility<T extends StyleElement>
    extends MixUtility<T, Duration> with _$DurationUtility {
  const DurationUtility(super.builder);

  T microseconds(int microseconds) =>
      builder(Duration(microseconds: microseconds));

  T milliseconds(int milliseconds) =>
      builder(Duration(milliseconds: milliseconds));

  T seconds(int seconds) => builder(Duration(seconds: seconds));

  T minutes(int minutes) => builder(Duration(minutes: minutes));
}

final class FontSizeUtility<T extends StyleElement> extends SizingUtility<T> {
  const FontSizeUtility(super.builder);
}

@MixableUtility()
final class FontWeightUtility<T extends StyleElement>
    extends MixUtility<T, FontWeight> with _$FontWeightUtility {
  const FontWeightUtility(super.builder);
}

@MixableUtility()
final class TextDecorationUtility<T extends StyleElement>
    extends MixUtility<T, TextDecoration> with _$TextDecorationUtility {
  const TextDecorationUtility(super.builder);
}

@MixableUtility(referenceType: Curves)
final class CurveUtility<T extends StyleElement> extends MixUtility<T, Curve>
    with _$CurveUtility {
  const CurveUtility(super.builder);

  T as(Curve curve) => builder(curve);

  T spring({
    double stiffness = 3.5,
    double dampingRatio = 1.0,
    double mass = 1.0,
  }) =>
      builder(
        SpringCurve(
          stiffness: stiffness,
          dampingRatio: dampingRatio,
          mass: mass,
        ),
      );
}

@MixableUtility(methods: GeneratedUtilityMethods.skipCallMethod)
final class OffsetUtility<T extends StyleElement> extends MixUtility<T, Offset>
    with _$OffsetUtility {
  const OffsetUtility(super.builder);

  T as(Offset offset) => builder(offset);
}

@MixableUtility(methods: GeneratedUtilityMethods.skipCallMethod)
final class RadiusUtility<T extends StyleElement> extends MixUtility<T, Radius>
    with _$RadiusUtility {
  const RadiusUtility(super.builder);

  T call(double radius) => builder(Radius.circular(radius));

  // TODO: Update to use MixableToken<Radius> when RadiusDto integration is complete
  T ref(Radius ref) => builder(ref);
}

@MixableUtility()
final class RectUtility<T extends StyleElement> extends MixUtility<T, Rect>
    with _$RectUtility {
  const RectUtility(super.builder);
}

final class PaintUtility<T extends StyleElement>
    extends ScalarUtility<T, Paint> {
  const PaintUtility(super.builder);
}

final class LocaleUtility<T extends StyleElement>
    extends ScalarUtility<T, Locale> {
  const LocaleUtility(super.builder);
}

@MixableUtility()
final class ImageProviderUtility<T extends StyleElement>
    extends MixUtility<T, ImageProvider> with _$ImageProviderUtility {
  const ImageProviderUtility(super.builder);

  /// Creates an [StyleElement] instance with [ImageProvider.network].
  /// @param url The URL of the image.
  T network(String url) => builder(NetworkImage(url));
  T file(File file) => builder(FileImage(file));
  T asset(String asset) => builder(AssetImage(asset));
  T memory(Uint8List bytes) => builder(MemoryImage(bytes));
}

@MixableUtility()
final class GradientTransformUtility<T extends StyleElement>
    extends MixUtility<T, GradientTransform> with _$GradientTransformUtility {
  const GradientTransformUtility(super.builder);

  /// Creates an [StyleElement] instance with a [GradientRotation] value.
  T rotate(double radians) => builder(GradientRotation(radians));
}

@MixableUtility()
final class Matrix4Utility<T extends StyleElement>
    extends MixUtility<T, Matrix4> with _$Matrix4Utility {
  const Matrix4Utility(super.builder);
}

@MixableUtility()
final class FontFamilyUtility<T extends StyleElement>
    extends MixUtility<T, String> with _$FontFamilyUtility {
  const FontFamilyUtility(super.builder);
}

@MixableUtility()
final class TextScalerUtility<T extends StyleElement>
    extends MixUtility<T, TextScaler> with _$TextScalerUtility {
  const TextScalerUtility(super.builder);
}

@MixableUtility()
final class TableColumnWidthUtility<T extends StyleElement>
    extends MixUtility<T, TableColumnWidth> with _$TableColumnWidthUtility {
  const TableColumnWidthUtility(super.builder);
}

@MixableUtility()
class TableBorderUtility<T extends StyleElement>
    extends MixUtility<T, TableBorder> with _$TableBorderUtility<T> {
  const TableBorderUtility(super.builder);
}

final class StrokeAlignUtility<T extends StyleElement>
    extends ScalarUtility<T, double> {
  const StrokeAlignUtility(super.builder);

  T center() => builder(0);
  T inside() => builder(-1);
  T outside() => builder(1);
}

// Extension removed - token() method is now built into RadiusUtility
