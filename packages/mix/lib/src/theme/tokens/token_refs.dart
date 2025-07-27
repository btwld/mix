import 'package:flutter/widgets.dart';

import 'mix_token.dart';

abstract class TokenRef<T extends Object> {
  final MixToken<T> token;
  const TokenRef(this.token);
  @override
  Never noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      'This is a Token reference for $T, so it does not implement ${invocation.memberName}.',
    );
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TokenRef && other.token == token;
  }

  @override
  String toString() {
    return 'TokenRef<$T>(${token.name})';
  }

  @override
  int get hashCode => token.hashCode;
}

final class ColorRef extends TokenRef<Color> implements Color {
  const ColorRef(super.token);
}

/// Token reference for [AlignmentGeometry] values
final class AlignmentGeometryRef extends TokenRef<AlignmentGeometry>
    implements AlignmentGeometry {
  const AlignmentGeometryRef(super.token);
}

/// Token reference for [Alignment] values
final class AlignmentRef extends TokenRef<Alignment> implements Alignment {
  const AlignmentRef(super.token);
}

/// Token reference for [AlignmentDirectional] values
final class AlignmentDirectionalRef extends TokenRef<AlignmentDirectional>
    implements AlignmentDirectional {
  const AlignmentDirectionalRef(super.token);
}

/// Token reference for [FontFeature] values
final class FontFeatureRef extends TokenRef<FontFeature>
    implements FontFeature {
  const FontFeatureRef(super.token);
}

/// Token reference for [Duration] values
final class DurationRef extends TokenRef<Duration> implements Duration {
  const DurationRef(super.token);
}

/// Token reference for [FontWeight] values
final class FontWeightRef extends TokenRef<FontWeight> implements FontWeight {
  const FontWeightRef(super.token);
}

/// Token reference for [TextDecoration] values
final class TextDecorationRef extends TokenRef<TextDecoration>
    implements TextDecoration {
  const TextDecorationRef(super.token);
}

/// Token reference for [Offset] values
final class OffsetRef extends TokenRef<Offset> implements Offset {
  const OffsetRef(super.token);
}

/// Token reference for [Radius] values
final class RadiusRef extends TokenRef<Radius> implements Radius {
  const RadiusRef(super.token);
}

/// Token reference for [Rect] values
final class RectRef extends TokenRef<Rect> implements Rect {
  const RectRef(super.token);
}

/// Token reference for [Locale] values
final class LocaleRef extends TokenRef<Locale> implements Locale {
  const LocaleRef(super.token);
}

/// Token reference for [ImageProvider] values
final class ImageProviderRef extends TokenRef<ImageProvider>
    implements ImageProvider {
  const ImageProviderRef(super.token);
}

/// Token reference for [GradientTransform] values
final class GradientTransformRef extends TokenRef<GradientTransform>
    implements GradientTransform {
  const GradientTransformRef(super.token);
}

/// Token reference for [Matrix4] values
final class Matrix4Ref extends TokenRef<Matrix4> implements Matrix4 {
  const Matrix4Ref(super.token);
}

/// Token reference for [TextScaler] values
final class TextScalerRef extends TokenRef<TextScaler> implements TextScaler {
  const TextScalerRef(super.token);
}

/// Token reference for [TableColumnWidth] values
final class TableColumnWidthRef extends TokenRef<TableColumnWidth>
    implements TableColumnWidth {
  const TableColumnWidthRef(super.token);
}

/// Token reference for [TableBorder] values
final class TableBorderRef extends TokenRef<TableBorder>
    implements TableBorder {
  const TableBorderRef(super.token);
}

/// Token reference for [TextStyle] values
final class TextStyleRef extends TokenRef<TextStyle> implements TextStyle {
  const TextStyleRef(super.token);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Token reference for [StrutStyle] values
final class StrutStyleRef extends TokenRef<StrutStyle> implements StrutStyle {
  const StrutStyleRef(super.token);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Token reference for [TextHeightBehavior] values
final class TextHeightBehaviorRef extends TokenRef<TextHeightBehavior>
    implements TextHeightBehavior {
  const TextHeightBehaviorRef(super.token);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Token reference for [BorderRadiusGeometry] values
final class BorderRadiusGeometryRef extends TokenRef<BorderRadiusGeometry>
    implements BorderRadiusGeometry {
  const BorderRadiusGeometryRef(super.token);
}

/// Token reference for [BorderRadius] values
final class BorderRadiusRef extends TokenRef<BorderRadius>
    implements BorderRadius {
  const BorderRadiusRef(super.token);
}

/// Token reference for [BorderRadiusDirectional] values
final class BorderRadiusDirectionalRef extends TokenRef<BorderRadiusDirectional>
    implements BorderRadiusDirectional {
  const BorderRadiusDirectionalRef(super.token);
}

/// Token reference for [Shadow] values
final class ShadowRef extends TokenRef<Shadow> implements Shadow {
  const ShadowRef(super.token);
}

/// Token reference for [Gradient] values
final class GradientRef extends TokenRef<Gradient> implements Gradient {
  const GradientRef(super.token);
}

/// Token reference for [EdgeInsetsGeometry] values
final class EdgeInsetsGeometryRef extends TokenRef<EdgeInsetsGeometry>
    implements EdgeInsetsGeometry {
  const EdgeInsetsGeometryRef(super.token);
}

/// Token reference for [EdgeInsets] values
final class EdgeInsetsRef extends TokenRef<EdgeInsets> implements EdgeInsets {
  const EdgeInsetsRef(super.token);
}

/// Token reference for [EdgeInsetsDirectional] values
final class EdgeInsetsDirectionalRef extends TokenRef<EdgeInsetsDirectional>
    implements EdgeInsetsDirectional {
  const EdgeInsetsDirectionalRef(super.token);
}

/// Token reference for [BoxDecoration] values
final class BoxDecorationRef extends TokenRef<BoxDecoration>
    implements BoxDecoration {
  const BoxDecorationRef(super.token);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Token reference for [ShapeBorder] values
final class ShapeBorderRef extends TokenRef<ShapeBorder>
    implements ShapeBorder {
  const ShapeBorderRef(super.token);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Token reference for [BoxConstraints] values
final class BoxConstraintsRef extends TokenRef<BoxConstraints>
    implements BoxConstraints {
  const BoxConstraintsRef(super.token);
}

/// Token reference for [DecorationImage] values
final class DecorationImageRef extends TokenRef<DecorationImage>
    implements DecorationImage {
  const DecorationImageRef(super.token);
}

/// Token reference for [Curve] values
final class CurveRef extends TokenRef<Curve> implements Curve {
  const CurveRef(super.token);
}
