import 'package:flutter/widgets.dart';

import '../theme/tokens/mix_token.dart';
import 'prop.dart';

mixin ValueRef<T> on Prop<T> {
  @override
  Never noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      'This is a Token reference for $T, so it does not implement ${invocation.memberName}.',
    );
  }
}

final class ColorProp extends Prop<Color>
    with ValueRef<Color>
    implements Color {
  ColorProp(super.prop) : super.fromProp();
}

/// Token reference for [AlignmentGeometry] values
final class AlignmentGeometryProp extends Prop<AlignmentGeometry>
    with ValueRef<AlignmentGeometry>
    implements AlignmentGeometry {
  AlignmentGeometryProp(super.prop) : super.fromProp();
}

/// Token reference for [Alignment] values
final class AlignmentProp extends Prop<Alignment>
    with ValueRef<Alignment>
    implements Alignment {
  AlignmentProp(super.prop) : super.fromProp();
}

/// Token reference for [AlignmentDirectional] values
final class AlignmentDirectionalProp extends Prop<AlignmentDirectional>
    with ValueRef<AlignmentDirectional>
    implements AlignmentDirectional {
  AlignmentDirectionalProp(super.prop) : super.fromProp();
}

/// Token reference for [FontFeature] values
final class FontFeatureProp extends Prop<FontFeature>
    with ValueRef<FontFeature>
    implements FontFeature {
  FontFeatureProp(super.prop) : super.fromProp();
}

/// Token reference for [Duration] values
final class DurationProp extends Prop<Duration>
    with ValueRef<Duration>
    implements Duration {
  DurationProp(super.prop) : super.fromProp();
}

/// Token reference for [FontWeight] values
final class FontWeightProp extends Prop<FontWeight>
    with ValueRef<FontWeight>
    implements FontWeight {
  FontWeightProp(super.prop) : super.fromProp();
}

/// Token reference for [TextDecoration] values
final class TextDecorationProp extends Prop<TextDecoration>
    with ValueRef<TextDecoration>
    implements TextDecoration {
  TextDecorationProp(super.prop) : super.fromProp();
}

/// Token reference for [Offset] values
final class OffsetProp extends Prop<Offset>
    with ValueRef<Offset>
    implements Offset {
  OffsetProp(super.prop) : super.fromProp();
}

/// Token reference for [Radius] values
final class RadiusProp extends Prop<Radius>
    with ValueRef<Radius>
    implements Radius {
  RadiusProp(super.prop) : super.fromProp();
}

/// Token reference for [Rect] values
final class RectProp extends Prop<Rect> with ValueRef<Rect> implements Rect {
  RectProp(super.prop) : super.fromProp();
}

/// Token reference for [Locale] values
final class LocaleProp extends Prop<Locale>
    with ValueRef<Locale>
    implements Locale {
  LocaleProp(super.prop) : super.fromProp();
}

/// Token reference for [ImageProvider] values
final class ImageProviderProp extends Prop<ImageProvider>
    with ValueRef<ImageProvider>
    implements ImageProvider {
  ImageProviderProp(super.prop) : super.fromProp();
}

/// Token reference for [GradientTransform] values
final class GradientTransformProp extends Prop<GradientTransform>
    with ValueRef<GradientTransform>
    implements GradientTransform {
  GradientTransformProp(super.prop) : super.fromProp();
}

/// Token reference for [Matrix4] values
final class Matrix4Prop extends Prop<Matrix4>
    with ValueRef<Matrix4>
    implements Matrix4 {
  Matrix4Prop(super.prop) : super.fromProp();
}

/// Token reference for [TextScaler] values
final class TextScalerProp extends Prop<TextScaler>
    with ValueRef<TextScaler>
    implements TextScaler {
  TextScalerProp(super.prop) : super.fromProp();
}

/// Token reference for [TableColumnWidth] values
final class TableColumnWidthProp extends Prop<TableColumnWidth>
    with ValueRef<TableColumnWidth>
    implements TableColumnWidth {
  TableColumnWidthProp(super.prop) : super.fromProp();
}

/// Token reference for [TableBorder] values
final class TableBorderProp extends Prop<TableBorder>
    with ValueRef<TableBorder>
    implements TableBorder {
  TableBorderProp(super.prop) : super.fromProp();
}

/// Token reference for [TextStyle] values
final class TextStyleProp extends Prop<TextStyle>
    with ValueRef<TextStyle>
    implements TextStyle {
  TextStyleProp(super.prop) : super.fromProp();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Token reference for [StrutStyle] values
final class StrutStyleProp extends Prop<StrutStyle>
    with ValueRef<StrutStyle>
    implements StrutStyle {
  StrutStyleProp(super.prop) : super.fromProp();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Token reference for [TextHeightBehavior] values
final class TextHeightBehaviorProp extends Prop<TextHeightBehavior>
    with ValueRef<TextHeightBehavior>
    implements TextHeightBehavior {
  TextHeightBehaviorProp(super.prop) : super.fromProp();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Token reference for [BoxBorder] values
final class BoxBorderProp extends Prop<BoxBorder>
    with ValueRef<BoxBorder>
    implements BoxBorder {
  BoxBorderProp(super.prop) : super.fromProp();
}

/// Token reference for [BorderRadiusGeometry] values
final class BorderRadiusGeometryProp extends Prop<BorderRadiusGeometry>
    with ValueRef<BorderRadiusGeometry>
    implements BorderRadiusGeometry {
  BorderRadiusGeometryProp(super.prop) : super.fromProp();
}

/// Token reference for [BorderRadius] values
final class BorderRadiusProp extends Prop<BorderRadius>
    with ValueRef<BorderRadius>
    implements BorderRadius {
  BorderRadiusProp(super.prop) : super.fromProp();
}

/// Token reference for [BorderRadiusDirectional] values
final class BorderRadiusDirectionalProp extends Prop<BorderRadiusDirectional>
    with ValueRef<BorderRadiusDirectional>
    implements BorderRadiusDirectional {
  BorderRadiusDirectionalProp(super.prop) : super.fromProp();
}

/// Token reference for [Shadow] values
final class ShadowProp extends Prop<Shadow>
    with ValueRef<Shadow>
    implements Shadow {
  ShadowProp(super.prop) : super.fromProp();
}

/// Token reference for [BoxShadow] values
final class BoxShadowProp extends Prop<BoxShadow>
    with ValueRef<BoxShadow>
    implements BoxShadow {
  BoxShadowProp(super.prop) : super.fromProp();
}

/// Token reference for [Gradient] values
final class GradientProp extends Prop<Gradient>
    with ValueRef<Gradient>
    implements Gradient {
  GradientProp(super.prop) : super.fromProp();
}

final class LinearGradientProp extends Prop<LinearGradient>
    with ValueRef<LinearGradient>
    implements LinearGradient {
  LinearGradientProp(super.prop) : super.fromProp();
}

final class RadialGradientProp extends Prop<RadialGradient>
    with ValueRef<RadialGradient>
    implements RadialGradient {
  RadialGradientProp(super.prop) : super.fromProp();
}

final class SweepGradientProp extends Prop<SweepGradient>
    with ValueRef<SweepGradient>
    implements SweepGradient {
  SweepGradientProp(super.prop) : super.fromProp();
}

/// Token reference for [EdgeInsetsGeometry] values
final class EdgeInsetsGeometryProp extends Prop<EdgeInsetsGeometry>
    with ValueRef<EdgeInsetsGeometry>
    implements EdgeInsetsGeometry {
  EdgeInsetsGeometryProp(super.prop) : super.fromProp();
}

/// Token reference for [EdgeInsets] values
final class EdgeInsetsProp extends Prop<EdgeInsets>
    with ValueRef<EdgeInsets>
    implements EdgeInsets {
  EdgeInsetsProp(super.prop) : super.fromProp();
}

/// Token reference for [EdgeInsetsDirectional] values
final class EdgeInsetsDirectionalProp extends Prop<EdgeInsetsDirectional>
    with ValueRef<EdgeInsetsDirectional>
    implements EdgeInsetsDirectional {
  EdgeInsetsDirectionalProp(super.prop) : super.fromProp();
}

/// Token reference for [BoxDecoration] values
final class BoxDecorationProp extends Prop<BoxDecoration>
    with ValueRef<BoxDecoration>
    implements BoxDecoration {
  BoxDecorationProp(super.prop) : super.fromProp();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

final class BorderSideProp extends Prop<BorderSide>
    with ValueRef<BorderSide>
    implements BorderSide {
  BorderSideProp(super.prop) : super.fromProp();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Token reference for [ShapeBorder] values
final class ShapeBorderProp extends Prop<ShapeBorder>
    with ValueRef<ShapeBorder>
    implements ShapeBorder {
  ShapeBorderProp(super.prop) : super.fromProp();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Token reference for [BoxConstraints] values
final class BoxConstraintsProp extends Prop<BoxConstraints>
    with ValueRef<BoxConstraints>
    implements BoxConstraints {
  BoxConstraintsProp(super.prop) : super.fromProp();
}

/// Token reference for [DecorationImage] values
final class DecorationImageProp extends Prop<DecorationImage>
    with ValueRef<DecorationImage>
    implements DecorationImage {
  DecorationImageProp(super.prop) : super.fromProp();
}

/// Token reference for [Curve] values
final class CurveProp extends Prop<Curve>
    with ValueRef<Curve>
    implements Curve {
  CurveProp(super.prop) : super.fromProp();
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
}

/// Extension type for [int] values with token tracking
extension type const IntRef(int _value) implements int {
  /// Creates an IntRef using token hashCode and registers it with a token
  static IntRef token(MixToken<int> token) {
    final ref = IntRef(token.hashCode);
    _tokenRegistry[ref] = token;

    return ref;
  }
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
}

/// Utility to clean up token registry (for memory management)
@visibleForTesting
void clearTokenRegistry() {
  _tokenRegistry.clear();
}

@visibleForTesting
void assertIsRealType(Type value) {
  // Only check if the value is a TokenRef type that should be replaced
  final Type? realType = switch (value) {
    // Color types
    == ColorProp => Color,

    // Border types
    == BorderSideProp => BorderSide,
    == BoxBorderProp => BoxBorder,
    == BorderRadiusProp => BorderRadius,
    == BorderRadiusDirectionalProp => BorderRadiusDirectional,
    == BorderRadiusGeometryProp => BorderRadiusGeometry,

    // Gradient types
    == GradientProp => Gradient,
    == LinearGradientProp => LinearGradient,
    == RadialGradientProp => RadialGradient,
    == SweepGradientProp => SweepGradient,
    == GradientTransformProp => GradientTransform,

    // Geometry types
    == AlignmentGeometryProp => AlignmentGeometry,
    == AlignmentProp => Alignment,
    == AlignmentDirectionalProp => AlignmentDirectional,
    == EdgeInsetsGeometryProp => EdgeInsetsGeometry,
    == EdgeInsetsProp => EdgeInsets,
    == EdgeInsetsDirectionalProp => EdgeInsetsDirectional,

    // Shape and decoration types
    == RadiusProp => Radius,
    == OffsetProp => Offset,
    == RectProp => Rect,
    == ShadowProp => Shadow,
    == BoxShadowProp => BoxShadow,
    == BoxDecorationProp => BoxDecoration,
    == DecorationImageProp => DecorationImage,
    == ShapeBorderProp => ShapeBorder,
    == BoxConstraintsProp => BoxConstraints,

    // Text types
    == TextStyleProp => TextStyle,
    == TextDecorationProp => TextDecoration,
    == StrutStyleProp => StrutStyle,
    == TextHeightBehaviorProp => TextHeightBehavior,
    == TextScalerProp => TextScaler,
    == FontFeatureProp => FontFeature,
    == FontWeightProp => FontWeight,

    // Other types
    == LocaleProp => Locale,
    == ImageProviderProp => ImageProvider,
    == Matrix4Prop => Matrix4,
    == TableColumnWidthProp => TableColumnWidth,
    == TableBorderProp => TableBorder,
    == DurationProp => Duration,
    == CurveProp => Curve,

    // All other types are valid - not TokenRef types
    _ => null,
  };

  assert(
    realType == null,
    'Cannot use $value for generic, use $realType instead.',
  );
}

MixToken<T>? getTokenFromValue<T>(Object value) {
  return _tokenRegistry[value] as MixToken<T>?;
}

/// Checks if a value is any type of token reference (class-based or extension type)
bool isAnyTokenRef(Object value) {
  // Check if it's a class-based token reference (extends Prop with ValueRef mixin)
  // We can check if it has the ValueRef mixin by checking if it has a token
  if (value is Prop && value.$token != null) {
    // Additional check to ensure it's actually a token reference class
    final typeName = value.runtimeType.toString();
    if (typeName.endsWith('Ref') || typeName.endsWith('Prop')) {
      return true;
    }
  }

  // Check if it's an extension type token reference by looking in the registry
  return _tokenRegistry.containsKey(value);
}

T getRefernceValue<T>(MixToken<T> token) {
  final prop = Prop.token(token);
  if (T == Color) {
    return ColorProp(prop as Prop<Color>) as T;
  } else if (T == double) {
    return DoubleRef.token(token as MixToken<double>) as T;
  } else if (T == int) {
    return IntRef.token(token as MixToken<int>) as T;
  } else if (T == String) {
    return StringRef.token(token as MixToken<String>) as T;
  } else if (T == Radius) {
    return RadiusProp(prop as Prop<Radius>) as T;
  } else if (T == Offset) {
    return OffsetProp(prop as Prop<Offset>) as T;
  } else if (T == Rect) {
    return RectProp(prop as Prop<Rect>) as T;
  } else if (T == Shadow) {
    return ShadowProp(prop as Prop<Shadow>) as T;
  } else if (T == BoxShadow) {
    return BoxShadowProp(prop as Prop<BoxShadow>) as T;
  } else if (T == BoxDecoration) {
    return BoxDecorationProp(prop as Prop<BoxDecoration>) as T;
  } else if (T == DecorationImage) {
    return DecorationImageProp(prop as Prop<DecorationImage>) as T;
  } else if (T == ShapeBorder) {
    return ShapeBorderProp(prop as Prop<ShapeBorder>) as T;
  } else if (T == BoxConstraints) {
    return BoxConstraintsProp(prop as Prop<BoxConstraints>) as T;
  } else if (T == Gradient) {
    return GradientProp(prop as Prop<Gradient>) as T;
  } else if (T == LinearGradient) {
    return LinearGradientProp(prop as Prop<LinearGradient>) as T;
  } else if (T == RadialGradient) {
    return RadialGradientProp(prop as Prop<RadialGradient>) as T;
  } else if (T == SweepGradient) {
    return SweepGradientProp(prop as Prop<SweepGradient>) as T;
  } else if (T == GradientTransform) {
    return GradientTransformProp(prop as Prop<GradientTransform>) as T;
  } else if (T == AlignmentGeometry) {
    return AlignmentGeometryProp(prop as Prop<AlignmentGeometry>) as T;
  } else if (T == Alignment) {
    return AlignmentProp(prop as Prop<Alignment>) as T;
  } else if (T == AlignmentDirectional) {
    return AlignmentDirectionalProp(prop as Prop<AlignmentDirectional>) as T;
  } else if (T == EdgeInsetsGeometry) {
    return EdgeInsetsGeometryProp(prop as Prop<EdgeInsetsGeometry>) as T;
  } else if (T == EdgeInsets) {
    return EdgeInsetsProp(prop as Prop<EdgeInsets>) as T;
  } else if (T == EdgeInsetsDirectional) {
    return EdgeInsetsDirectionalProp(prop as Prop<EdgeInsetsDirectional>) as T;
  } else if (T == BorderSide) {
    return BorderSideProp(prop as Prop<BorderSide>) as T;
  } else if (T == BoxBorder) {
    return BoxBorderProp(prop as Prop<BoxBorder>) as T;
  } else if (T == BorderRadius) {
    return BorderRadiusProp(prop as Prop<BorderRadius>) as T;
  } else if (T == BorderRadiusDirectional) {
    return BorderRadiusDirectionalProp(prop as Prop<BorderRadiusDirectional>)
        as T;
  } else if (T == BorderRadiusGeometry) {
    return BorderRadiusGeometryProp(prop as Prop<BorderRadiusGeometry>) as T;
  } else if (T == TextStyle) {
    return TextStyleProp(prop as Prop<TextStyle>) as T;
  } else if (T == TextDecoration) {
    return TextDecorationProp(prop as Prop<TextDecoration>) as T;
  } else if (T == StrutStyle) {
    return StrutStyleProp(prop as Prop<StrutStyle>) as T;
  } else if (T == TextHeightBehavior) {
    return TextHeightBehaviorProp(prop as Prop<TextHeightBehavior>) as T;
  } else if (T == TextScaler) {
    return TextScalerProp(prop as Prop<TextScaler>) as T;
  } else if (T == FontFeature) {
    return FontFeatureProp(prop as Prop<FontFeature>) as T;
  } else if (T == FontWeight) {
    return FontWeightProp(prop as Prop<FontWeight>) as T;
  } else if (T == Locale) {
    return LocaleProp(prop as Prop<Locale>) as T;
  } else if (T == ImageProvider) {
    return ImageProviderProp(prop as Prop<ImageProvider>) as T;
  } else if (T == Matrix4) {
    return Matrix4Prop(prop as Prop<Matrix4>) as T;
  } else if (T == TableColumnWidth) {
    return TableColumnWidthProp(prop as Prop<TableColumnWidth>) as T;
  } else if (T == TableBorder) {
    return TableBorderProp(prop as Prop<TableBorder>) as T;
  } else if (T == Duration) {
    return DurationProp(prop as Prop<Duration>) as T;
  } else if (T == Curve) {
    return CurveProp(prop as Prop<Curve>) as T;
  }

  return prop as T;
}
