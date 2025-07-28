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

/// Token reference for [BoxBorder] values
final class BoxBorderRef extends TokenRef<BoxBorder> implements BoxBorder {
  const BoxBorderRef(super.token);
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

/// Token reference for [BoxShadow] values
final class BoxShadowRef extends TokenRef<BoxShadow> implements BoxShadow {
  const BoxShadowRef(super.token);
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

// =============================================================================
// EXTENSION TYPE TOKEN REFERENCES FOR PRIMITIVES
// =============================================================================
// Extension types for primitive values (double, int, string) that implement their
// respective interfaces while being trackable through a token registry.
// Each token gets a unique representation value based on token.hashCode to ensure
// reliable registry lookups without collisions.

/// Global registry to associate extension type values with their tokens
final Map<Object, MixToken> _tokenRegistry = <Object, MixToken>{};

/// Extension type for [double] values with token tracking
extension type const DoubleRef(double _value) implements double {
  /// Creates a DoubleRef using token hashCode and registers it with a token
  static DoubleRef token(MixToken<double> token) {
    final ref = DoubleRef(token.hashCode.toDouble());
    _tokenRegistry[ref] = token;

    return ref;
  }

  /// Gets the associated token for this reference
  MixToken<double> get mixToken => _tokenRegistry[this]! as MixToken<double>;
}

/// Extension type for [int] values with token tracking
extension type const IntRef(int _value) implements int {
  /// Creates an IntRef using token hashCode and registers it with a token
  static IntRef token(MixToken<int> token) {
    final ref = IntRef(token.hashCode);
    _tokenRegistry[ref] = token;

    return ref;
  }

  /// Gets the associated token for this reference
  MixToken<int> get mixToken => _tokenRegistry[this]! as MixToken<int>;
}

/// Extension type for [String] values with token tracking
extension type const StringRef(String _value) implements String {
  /// Creates a StringRef using token hashCode and registers it with a token
  static StringRef token(MixToken<String> token) {
    final uniqueValue = '_tk_${token.hashCode.toRadixString(36)}';
    final ref = StringRef(uniqueValue);
    _tokenRegistry[ref] = token;

    return ref;
  }

  /// Gets the associated token for this reference
  MixToken<String> get mixToken => _tokenRegistry[this]! as MixToken<String>;
}

/// Utility to clean up token registry (for memory management)
@visibleForTesting
void clearTokenRegistry() {
  _tokenRegistry.clear();
}
