import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

// =============================================================================
// Value Types (Semantic AST Values)
// =============================================================================

/// Unit for length values.
enum TwUnit {
  /// Pixels (default).
  px,

  /// Relative em units.
  rem,

  /// Percentage.
  percent,

  /// Unitless (for multipliers like line-height).
  none,
}

/// Base sealed class for all Tailwind values.
sealed class TwValue {
  const TwValue();
}

/// A length value with optional unit.
final class TwLengthValue extends TwValue {
  const TwLengthValue(this.value, [this.unit = TwUnit.px]);

  final double value;
  final TwUnit unit;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwLengthValue &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          unit == other.unit;

  @override
  int get hashCode => Object.hash(value, unit);

  @override
  String toString() => 'TwLengthValue($value, $unit)';
}

/// A color value.
final class TwColorValue extends TwValue {
  const TwColorValue(this.color);

  final Color color;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwColorValue &&
          runtimeType == other.runtimeType &&
          color == other.color;

  @override
  int get hashCode => color.hashCode;

  @override
  String toString() => 'TwColorValue($color)';
}

/// An enum value for properties like flexDirection, alignment, etc.
final class TwEnumValue<T> extends TwValue {
  const TwEnumValue(this.value);

  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwEnumValue<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'TwEnumValue($value)';
}

/// A fraction value (e.g., 1/2, 2/3).
final class TwFractionValue extends TwValue {
  const TwFractionValue(this.numerator, this.denominator);

  final int numerator;
  final int denominator;

  double get value => numerator / denominator;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwFractionValue &&
          runtimeType == other.runtimeType &&
          numerator == other.numerator &&
          denominator == other.denominator;

  @override
  int get hashCode => Object.hash(numerator, denominator);

  @override
  String toString() => 'TwFractionValue($numerator/$denominator)';
}

/// A transform matrix value.
final class TwMatrixValue extends TwValue {
  const TwMatrixValue(this.matrix);

  final Matrix4 matrix;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwMatrixValue &&
          runtimeType == other.runtimeType &&
          matrix == other.matrix;

  @override
  int get hashCode => matrix.hashCode;

  @override
  String toString() => 'TwMatrixValue($matrix)';
}

/// A gradient value with direction and colors.
final class TwGradientValue extends TwValue {
  const TwGradientValue({
    required this.begin,
    required this.end,
    required this.colors,
  });

  final Alignment begin;
  final Alignment end;
  final List<Color> colors;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwGradientValue &&
          runtimeType == other.runtimeType &&
          begin == other.begin &&
          end == other.end &&
          _listEquals(colors, other.colors);

  @override
  int get hashCode => Object.hash(begin, end, Object.hashAll(colors));

  @override
  String toString() => 'TwGradientValue(begin: $begin, end: $end, colors: $colors)';
}

/// A duration value in milliseconds.
final class TwDurationValue extends TwValue {
  const TwDurationValue(this.milliseconds);

  final int milliseconds;

  Duration get duration => Duration(milliseconds: milliseconds);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwDurationValue &&
          runtimeType == other.runtimeType &&
          milliseconds == other.milliseconds;

  @override
  int get hashCode => milliseconds.hashCode;

  @override
  String toString() => 'TwDurationValue(${milliseconds}ms)';
}

/// A curve value for animations.
final class TwCurveValue extends TwValue {
  const TwCurveValue(this.curve);

  final Curve curve;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwCurveValue &&
          runtimeType == other.runtimeType &&
          curve == other.curve;

  @override
  int get hashCode => curve.hashCode;

  @override
  String toString() => 'TwCurveValue($curve)';
}

// =============================================================================
// Text Shadow Presets
// =============================================================================

enum TextShadowPreset {
  twoXs,
  xs,
  sm,
  md,
  lg,
}

const Map<TextShadowPreset, List<Shadow>> kTextShadowPresets = {
  TextShadowPreset.twoXs: [
    Shadow(offset: Offset(0, 1), blurRadius: 0, color: Color(0x26000000)),
  ],
  TextShadowPreset.xs: [
    Shadow(offset: Offset(0, 1), blurRadius: 1, color: Color(0x33000000)),
  ],
  TextShadowPreset.sm: [
    Shadow(offset: Offset(0, 1), blurRadius: 0, color: Color(0x13000000)),
    Shadow(offset: Offset(0, 1), blurRadius: 1, color: Color(0x13000000)),
    Shadow(offset: Offset(0, 2), blurRadius: 2, color: Color(0x13000000)),
  ],
  TextShadowPreset.md: [
    Shadow(offset: Offset(0, 1), blurRadius: 1, color: Color(0x1A000000)),
    Shadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0x1A000000)),
    Shadow(offset: Offset(0, 2), blurRadius: 4, color: Color(0x1A000000)),
  ],
  TextShadowPreset.lg: [
    Shadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0x1A000000)),
    Shadow(offset: Offset(0, 3), blurRadius: 2, color: Color(0x1A000000)),
    Shadow(offset: Offset(0, 4), blurRadius: 8, color: Color(0x1A000000)),
  ],
};

// =============================================================================
// Property Enum
// =============================================================================

/// All supported Tailwind properties.
enum TwProperty {
  // Spacing
  padding,
  paddingX,
  paddingY,
  paddingTop,
  paddingRight,
  paddingBottom,
  paddingLeft,
  margin,
  marginX,
  marginY,
  marginTop,
  marginRight,
  marginBottom,
  marginLeft,
  gap,
  gapX,
  gapY,

  // Sizing
  width,
  height,
  minWidth,
  minHeight,
  maxWidth,
  maxHeight,

  // Layout
  display,
  flexDirection,
  flexWrap,
  alignItems,
  justifyContent,
  alignSelf,
  flexGrow,
  flexShrink,
  flexBasis,

  // Background
  backgroundColor,
  backgroundGradient,

  // Border width
  borderWidth,
  borderTopWidth,
  borderRightWidth,
  borderBottomWidth,
  borderLeftWidth,
  borderXWidth,
  borderYWidth,

  // Border color
  borderColor,

  // Border radius
  borderRadius,
  borderRadiusTop,
  borderRadiusBottom,
  borderRadiusLeft,
  borderRadiusRight,
  borderRadiusTopLeft,
  borderRadiusTopRight,
  borderRadiusBottomLeft,
  borderRadiusBottomRight,

  // Typography
  fontSize,
  fontWeight,
  textColor,
  textAlign,
  lineHeight,
  letterSpacing,
  textTransform,
  textOverflow,
  textDecoration,
  textShadow,

  // Effects
  boxShadow,
  opacity,
  blur,

  // Transform (individual components)
  scale,
  rotate,
  translateX,
  translateY,

  // Animation
  transition,
  transitionDuration,
  transitionCurve,
  transitionDelay,

  // Misc
  clipBehavior,
}

// =============================================================================
// Variant Types
// =============================================================================

/// Base sealed class for all variant types.
sealed class TwVariantType {
  const TwVariantType();
}

/// Interaction variant (hover, focus, pressed, disabled, enabled).
final class TwInteractionVariant extends TwVariantType {
  const TwInteractionVariant(this.state);

  final String state;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwInteractionVariant &&
          runtimeType == other.runtimeType &&
          state == other.state;

  @override
  int get hashCode => state.hashCode;

  @override
  String toString() => 'TwInteractionVariant($state)';
}

/// Breakpoint variant (sm, md, lg, xl, 2xl).
final class TwBreakpointVariant extends TwVariantType {
  const TwBreakpointVariant(this.name, this.minWidth);

  final String name;
  final double minWidth;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwBreakpointVariant &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          minWidth == other.minWidth;

  @override
  int get hashCode => Object.hash(name, minWidth);

  @override
  String toString() => 'TwBreakpointVariant($name, minWidth: $minWidth)';
}

/// Theme variant (dark, light).
final class TwThemeVariant extends TwVariantType {
  const TwThemeVariant(this.mode);

  final String mode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwThemeVariant &&
          runtimeType == other.runtimeType &&
          mode == other.mode;

  @override
  int get hashCode => mode.hashCode;

  @override
  String toString() => 'TwThemeVariant($mode)';
}

// =============================================================================
// Parsed Class
// =============================================================================

/// Represents a fully parsed Tailwind class with resolved values.
final class TwParsedClass {
  const TwParsedClass({
    required this.property,
    required this.value,
    this.variants = const [],
    this.important = false,
    this.negative = false,
    this.arbitrary = false,
  });

  final TwProperty property;
  final TwValue value;
  final List<TwVariantType> variants;
  final bool important;
  final bool negative;
  final bool arbitrary;

  /// Returns a unique key for this variant combination.
  String get variantKey =>
      variants.isEmpty ? '' : variants.map(_variantToKey).join(':');

  static String _variantToKey(TwVariantType v) => switch (v) {
        TwInteractionVariant(:final state) => state,
        TwBreakpointVariant(:final name) => name,
        TwThemeVariant(:final mode) => mode,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwParsedClass &&
          runtimeType == other.runtimeType &&
          property == other.property &&
          value == other.value &&
          _listEquals(variants, other.variants) &&
          important == other.important &&
          negative == other.negative &&
          arbitrary == other.arbitrary;

  @override
  int get hashCode => Object.hash(
        property,
        value,
        Object.hashAll(variants),
        important,
        negative,
        arbitrary,
      );

  @override
  String toString() =>
      'TwParsedClass(property: $property, value: $value, variants: $variants, important: $important, negative: $negative, arbitrary: $arbitrary)';
}

// =============================================================================
// Plugin Types
// =============================================================================

/// Type of value a functional plugin expects.
enum TwPluginType {
  /// Length value from space/radii/borderWidths scale.
  length,

  /// Color value from colors scale.
  color,

  /// Fraction value (e.g., 1/2, 2/3).
  fraction,

  /// Enum value (no scale lookup).
  enumValue,
}

/// A functional plugin that takes a value (e.g., p-4, bg-red-500).
final class TwFunctionalPlugin {
  const TwFunctionalPlugin({
    required this.property,
    required this.type,
    this.scale,
    this.supportsNegative = false,
  });

  final TwProperty property;
  final TwPluginType type;

  /// The config scale to look up values from ('space', 'colors', 'radii', etc.).
  final String? scale;

  /// Whether this property supports negative values (e.g., -m-4).
  final bool supportsNegative;
}

/// A named plugin that produces a fixed value (e.g., flex-row, items-center).
final class TwNamedPlugin {
  const TwNamedPlugin({
    required this.property,
    required this.value,
  });

  final TwProperty property;
  final TwValue value;
}

// =============================================================================
// Plugin Registry
// =============================================================================

/// Functional plugins - properties that take a value.
const Map<String, TwFunctionalPlugin> functionalPlugins = {
  // Spacing - Padding
  'p': TwFunctionalPlugin(
    property: TwProperty.padding,
    type: TwPluginType.length,
    scale: 'space',
  ),
  'px': TwFunctionalPlugin(
    property: TwProperty.paddingX,
    type: TwPluginType.length,
    scale: 'space',
  ),
  'py': TwFunctionalPlugin(
    property: TwProperty.paddingY,
    type: TwPluginType.length,
    scale: 'space',
  ),
  'pt': TwFunctionalPlugin(
    property: TwProperty.paddingTop,
    type: TwPluginType.length,
    scale: 'space',
  ),
  'pr': TwFunctionalPlugin(
    property: TwProperty.paddingRight,
    type: TwPluginType.length,
    scale: 'space',
  ),
  'pb': TwFunctionalPlugin(
    property: TwProperty.paddingBottom,
    type: TwPluginType.length,
    scale: 'space',
  ),
  'pl': TwFunctionalPlugin(
    property: TwProperty.paddingLeft,
    type: TwPluginType.length,
    scale: 'space',
  ),

  // Spacing - Margin
  'm': TwFunctionalPlugin(
    property: TwProperty.margin,
    type: TwPluginType.length,
    scale: 'space',
    supportsNegative: true,
  ),
  'mx': TwFunctionalPlugin(
    property: TwProperty.marginX,
    type: TwPluginType.length,
    scale: 'space',
    supportsNegative: true,
  ),
  'my': TwFunctionalPlugin(
    property: TwProperty.marginY,
    type: TwPluginType.length,
    scale: 'space',
    supportsNegative: true,
  ),
  'mt': TwFunctionalPlugin(
    property: TwProperty.marginTop,
    type: TwPluginType.length,
    scale: 'space',
    supportsNegative: true,
  ),
  'mr': TwFunctionalPlugin(
    property: TwProperty.marginRight,
    type: TwPluginType.length,
    scale: 'space',
    supportsNegative: true,
  ),
  'mb': TwFunctionalPlugin(
    property: TwProperty.marginBottom,
    type: TwPluginType.length,
    scale: 'space',
    supportsNegative: true,
  ),
  'ml': TwFunctionalPlugin(
    property: TwProperty.marginLeft,
    type: TwPluginType.length,
    scale: 'space',
    supportsNegative: true,
  ),

  // Spacing - Gap
  'gap': TwFunctionalPlugin(
    property: TwProperty.gap,
    type: TwPluginType.length,
    scale: 'space',
  ),
  'gap-x': TwFunctionalPlugin(
    property: TwProperty.gapX,
    type: TwPluginType.length,
    scale: 'space',
  ),
  'gap-y': TwFunctionalPlugin(
    property: TwProperty.gapY,
    type: TwPluginType.length,
    scale: 'space',
  ),

  // Sizing
  'w': TwFunctionalPlugin(
    property: TwProperty.width,
    type: TwPluginType.length,
    scale: 'space',
  ),
  'h': TwFunctionalPlugin(
    property: TwProperty.height,
    type: TwPluginType.length,
    scale: 'space',
  ),
  'min-w': TwFunctionalPlugin(
    property: TwProperty.minWidth,
    type: TwPluginType.length,
    scale: 'space',
  ),
  'min-h': TwFunctionalPlugin(
    property: TwProperty.minHeight,
    type: TwPluginType.length,
    scale: 'space',
  ),
  'max-w': TwFunctionalPlugin(
    property: TwProperty.maxWidth,
    type: TwPluginType.length,
    scale: 'space',
  ),
  'max-h': TwFunctionalPlugin(
    property: TwProperty.maxHeight,
    type: TwPluginType.length,
    scale: 'space',
  ),

  // Background
  'bg': TwFunctionalPlugin(
    property: TwProperty.backgroundColor,
    type: TwPluginType.color,
    scale: 'colors',
  ),

  // Text color (text-{color})
  'text': TwFunctionalPlugin(
    property: TwProperty.textColor,
    type: TwPluginType.color,
    scale: 'colors',
  ),

  // Border width
  'border': TwFunctionalPlugin(
    property: TwProperty.borderWidth,
    type: TwPluginType.length,
    scale: 'borderWidths',
  ),
  'border-t': TwFunctionalPlugin(
    property: TwProperty.borderTopWidth,
    type: TwPluginType.length,
    scale: 'borderWidths',
  ),
  'border-r': TwFunctionalPlugin(
    property: TwProperty.borderRightWidth,
    type: TwPluginType.length,
    scale: 'borderWidths',
  ),
  'border-b': TwFunctionalPlugin(
    property: TwProperty.borderBottomWidth,
    type: TwPluginType.length,
    scale: 'borderWidths',
  ),
  'border-l': TwFunctionalPlugin(
    property: TwProperty.borderLeftWidth,
    type: TwPluginType.length,
    scale: 'borderWidths',
  ),
  'border-x': TwFunctionalPlugin(
    property: TwProperty.borderXWidth,
    type: TwPluginType.length,
    scale: 'borderWidths',
  ),
  'border-y': TwFunctionalPlugin(
    property: TwProperty.borderYWidth,
    type: TwPluginType.length,
    scale: 'borderWidths',
  ),

  // Border radius
  'rounded': TwFunctionalPlugin(
    property: TwProperty.borderRadius,
    type: TwPluginType.length,
    scale: 'radii',
  ),
  'rounded-t': TwFunctionalPlugin(
    property: TwProperty.borderRadiusTop,
    type: TwPluginType.length,
    scale: 'radii',
  ),
  'rounded-b': TwFunctionalPlugin(
    property: TwProperty.borderRadiusBottom,
    type: TwPluginType.length,
    scale: 'radii',
  ),
  'rounded-l': TwFunctionalPlugin(
    property: TwProperty.borderRadiusLeft,
    type: TwPluginType.length,
    scale: 'radii',
  ),
  'rounded-r': TwFunctionalPlugin(
    property: TwProperty.borderRadiusRight,
    type: TwPluginType.length,
    scale: 'radii',
  ),
  'rounded-tl': TwFunctionalPlugin(
    property: TwProperty.borderRadiusTopLeft,
    type: TwPluginType.length,
    scale: 'radii',
  ),
  'rounded-tr': TwFunctionalPlugin(
    property: TwProperty.borderRadiusTopRight,
    type: TwPluginType.length,
    scale: 'radii',
  ),
  'rounded-bl': TwFunctionalPlugin(
    property: TwProperty.borderRadiusBottomLeft,
    type: TwPluginType.length,
    scale: 'radii',
  ),
  'rounded-br': TwFunctionalPlugin(
    property: TwProperty.borderRadiusBottomRight,
    type: TwPluginType.length,
    scale: 'radii',
  ),

  // Transform
  'scale': TwFunctionalPlugin(
    property: TwProperty.scale,
    type: TwPluginType.length,
    scale: 'scales',
  ),
  'rotate': TwFunctionalPlugin(
    property: TwProperty.rotate,
    type: TwPluginType.length,
    scale: 'rotations',
    supportsNegative: true,
  ),
  'translate-x': TwFunctionalPlugin(
    property: TwProperty.translateX,
    type: TwPluginType.length,
    scale: 'space',
    supportsNegative: true,
  ),
  'translate-y': TwFunctionalPlugin(
    property: TwProperty.translateY,
    type: TwPluginType.length,
    scale: 'space',
    supportsNegative: true,
  ),

  // Effects
  'blur': TwFunctionalPlugin(
    property: TwProperty.blur,
    type: TwPluginType.length,
    scale: 'blurs',
    supportsNegative: false,
  ),

  // Animation
  'duration': TwFunctionalPlugin(
    property: TwProperty.transitionDuration,
    type: TwPluginType.length,
    scale: 'durations',
  ),
  'delay': TwFunctionalPlugin(
    property: TwProperty.transitionDelay,
    type: TwPluginType.length,
    scale: 'delays',
  ),

  // Typography - Font size (size-lg, size-[24px], size-[1.5rem])
  'size': TwFunctionalPlugin(
    property: TwProperty.fontSize,
    type: TwPluginType.length,
    scale: 'fontSizes',
  ),
};

/// Named plugins - properties with fixed values.
final Map<String, TwNamedPlugin> namedPlugins = {
  // Display
  'flex': TwNamedPlugin(
    property: TwProperty.display,
    value: const TwEnumValue('flex'),
  ),
  'hidden': TwNamedPlugin(
    property: TwProperty.display,
    value: const TwEnumValue('none'),
  ),
  'block': TwNamedPlugin(
    property: TwProperty.display,
    value: const TwEnumValue('block'),
  ),
  'flex-row': TwNamedPlugin(
    property: TwProperty.flexDirection,
    value: const TwEnumValue(Axis.horizontal),
  ),
  'flex-col': TwNamedPlugin(
    property: TwProperty.flexDirection,
    value: const TwEnumValue(Axis.vertical),
  ),

  // Flex wrap
  'flex-wrap': TwNamedPlugin(
    property: TwProperty.flexWrap,
    value: const TwEnumValue(true),
  ),
  'flex-nowrap': TwNamedPlugin(
    property: TwProperty.flexWrap,
    value: const TwEnumValue(false),
  ),
  'flex-wrap-reverse': TwNamedPlugin(
    property: TwProperty.flexWrap,
    value: const TwEnumValue('reverse'),
  ),

  // Flex item properties
  'flex-1': TwNamedPlugin(
    property: TwProperty.flexGrow,
    value: const TwLengthValue(1),
  ),
  'flex-auto': TwNamedPlugin(
    property: TwProperty.flexGrow,
    value: const TwEnumValue('auto'),
  ),
  'flex-initial': TwNamedPlugin(
    property: TwProperty.flexGrow,
    value: const TwEnumValue('initial'),
  ),
  'flex-none': TwNamedPlugin(
    property: TwProperty.flexGrow,
    value: const TwEnumValue('none'),
  ),
  'grow': TwNamedPlugin(
    property: TwProperty.flexGrow,
    value: const TwLengthValue(1),
  ),
  'grow-0': TwNamedPlugin(
    property: TwProperty.flexGrow,
    value: const TwLengthValue(0),
  ),
  'shrink': TwNamedPlugin(
    property: TwProperty.flexShrink,
    value: const TwLengthValue(1),
  ),
  'shrink-0': TwNamedPlugin(
    property: TwProperty.flexShrink,
    value: const TwLengthValue(0),
  ),

  // Alignment - Cross axis
  'items-start': TwNamedPlugin(
    property: TwProperty.alignItems,
    value: const TwEnumValue(CrossAxisAlignment.start),
  ),
  'items-center': TwNamedPlugin(
    property: TwProperty.alignItems,
    value: const TwEnumValue(CrossAxisAlignment.center),
  ),
  'items-end': TwNamedPlugin(
    property: TwProperty.alignItems,
    value: const TwEnumValue(CrossAxisAlignment.end),
  ),
  'items-stretch': TwNamedPlugin(
    property: TwProperty.alignItems,
    value: const TwEnumValue(CrossAxisAlignment.stretch),
  ),
  'items-baseline': TwNamedPlugin(
    property: TwProperty.alignItems,
    value: const TwEnumValue(CrossAxisAlignment.baseline),
  ),

  // Alignment - Main axis
  'justify-start': TwNamedPlugin(
    property: TwProperty.justifyContent,
    value: const TwEnumValue(MainAxisAlignment.start),
  ),
  'justify-center': TwNamedPlugin(
    property: TwProperty.justifyContent,
    value: const TwEnumValue(MainAxisAlignment.center),
  ),
  'justify-end': TwNamedPlugin(
    property: TwProperty.justifyContent,
    value: const TwEnumValue(MainAxisAlignment.end),
  ),
  'justify-between': TwNamedPlugin(
    property: TwProperty.justifyContent,
    value: const TwEnumValue(MainAxisAlignment.spaceBetween),
  ),
  'justify-around': TwNamedPlugin(
    property: TwProperty.justifyContent,
    value: const TwEnumValue(MainAxisAlignment.spaceAround),
  ),
  'justify-evenly': TwNamedPlugin(
    property: TwProperty.justifyContent,
    value: const TwEnumValue(MainAxisAlignment.spaceEvenly),
  ),

  // Self alignment
  'self-auto': TwNamedPlugin(
    property: TwProperty.alignSelf,
    value: const TwEnumValue('auto'),
  ),
  'self-start': TwNamedPlugin(
    property: TwProperty.alignSelf,
    value: const TwEnumValue(CrossAxisAlignment.start),
  ),
  'self-center': TwNamedPlugin(
    property: TwProperty.alignSelf,
    value: const TwEnumValue(CrossAxisAlignment.center),
  ),
  'self-end': TwNamedPlugin(
    property: TwProperty.alignSelf,
    value: const TwEnumValue(CrossAxisAlignment.end),
  ),
  'self-stretch': TwNamedPlugin(
    property: TwProperty.alignSelf,
    value: const TwEnumValue(CrossAxisAlignment.stretch),
  ),

  // Overflow clipping
  'overflow-hidden': TwNamedPlugin(
    property: TwProperty.clipBehavior,
    value: const TwEnumValue(Clip.hardEdge),
  ),
  'overflow-visible': TwNamedPlugin(
    property: TwProperty.clipBehavior,
    value: const TwEnumValue(Clip.none),
  ),
  'overflow-clip': TwNamedPlugin(
    property: TwProperty.clipBehavior,
    value: const TwEnumValue(Clip.hardEdge),
  ),

  // Blur
  'blur-none': TwNamedPlugin(
    property: TwProperty.blur,
    value: const TwLengthValue(0.0),
  ),

  // Shadows
  'shadow-none': TwNamedPlugin(
    property: TwProperty.boxShadow,
    value: const TwEnumValue<ElevationShadow?>(null),
  ),
  'shadow-sm': TwNamedPlugin(
    property: TwProperty.boxShadow,
    value: const TwEnumValue(ElevationShadow.one),
  ),
  'shadow': TwNamedPlugin(
    property: TwProperty.boxShadow,
    value: const TwEnumValue(ElevationShadow.two),
  ),
  'shadow-md': TwNamedPlugin(
    property: TwProperty.boxShadow,
    value: const TwEnumValue(ElevationShadow.three),
  ),
  'shadow-lg': TwNamedPlugin(
    property: TwProperty.boxShadow,
    value: const TwEnumValue(ElevationShadow.six),
  ),
  'shadow-xl': TwNamedPlugin(
    property: TwProperty.boxShadow,
    value: const TwEnumValue(ElevationShadow.nine),
  ),
  'shadow-2xl': TwNamedPlugin(
    property: TwProperty.boxShadow,
    value: const TwEnumValue(ElevationShadow.twelve),
  ),

  // Text shadows
  'text-shadow-none': TwNamedPlugin(
    property: TwProperty.textShadow,
    value: const TwEnumValue<TextShadowPreset?>(null),
  ),
  'text-shadow-2xs': TwNamedPlugin(
    property: TwProperty.textShadow,
    value: const TwEnumValue(TextShadowPreset.twoXs),
  ),
  'text-shadow-xs': TwNamedPlugin(
    property: TwProperty.textShadow,
    value: const TwEnumValue(TextShadowPreset.xs),
  ),
  'text-shadow-sm': TwNamedPlugin(
    property: TwProperty.textShadow,
    value: const TwEnumValue(TextShadowPreset.sm),
  ),
  'text-shadow-md': TwNamedPlugin(
    property: TwProperty.textShadow,
    value: const TwEnumValue(TextShadowPreset.md),
  ),
  'text-shadow-lg': TwNamedPlugin(
    property: TwProperty.textShadow,
    value: const TwEnumValue(TextShadowPreset.lg),
  ),

  // Font weights
  'font-thin': TwNamedPlugin(
    property: TwProperty.fontWeight,
    value: const TwEnumValue(FontWeight.w100),
  ),
  'font-extralight': TwNamedPlugin(
    property: TwProperty.fontWeight,
    value: const TwEnumValue(FontWeight.w200),
  ),
  'font-light': TwNamedPlugin(
    property: TwProperty.fontWeight,
    value: const TwEnumValue(FontWeight.w300),
  ),
  'font-normal': TwNamedPlugin(
    property: TwProperty.fontWeight,
    value: const TwEnumValue(FontWeight.w400),
  ),
  'font-medium': TwNamedPlugin(
    property: TwProperty.fontWeight,
    value: const TwEnumValue(FontWeight.w500),
  ),
  'font-semibold': TwNamedPlugin(
    property: TwProperty.fontWeight,
    value: const TwEnumValue(FontWeight.w600),
  ),
  'font-bold': TwNamedPlugin(
    property: TwProperty.fontWeight,
    value: const TwEnumValue(FontWeight.w700),
  ),
  'font-extrabold': TwNamedPlugin(
    property: TwProperty.fontWeight,
    value: const TwEnumValue(FontWeight.w800),
  ),
  'font-black': TwNamedPlugin(
    property: TwProperty.fontWeight,
    value: const TwEnumValue(FontWeight.w900),
  ),

  // Text alignment
  'text-left': TwNamedPlugin(
    property: TwProperty.textAlign,
    value: const TwEnumValue(TextAlign.left),
  ),
  'text-center': TwNamedPlugin(
    property: TwProperty.textAlign,
    value: const TwEnumValue(TextAlign.center),
  ),
  'text-right': TwNamedPlugin(
    property: TwProperty.textAlign,
    value: const TwEnumValue(TextAlign.right),
  ),
  'text-justify': TwNamedPlugin(
    property: TwProperty.textAlign,
    value: const TwEnumValue(TextAlign.justify),
  ),
  'text-start': TwNamedPlugin(
    property: TwProperty.textAlign,
    value: const TwEnumValue(TextAlign.start),
  ),
  'text-end': TwNamedPlugin(
    property: TwProperty.textAlign,
    value: const TwEnumValue(TextAlign.end),
  ),

  // Text transform
  'uppercase': TwNamedPlugin(
    property: TwProperty.textTransform,
    value: const TwEnumValue('uppercase'),
  ),
  'lowercase': TwNamedPlugin(
    property: TwProperty.textTransform,
    value: const TwEnumValue('lowercase'),
  ),
  'capitalize': TwNamedPlugin(
    property: TwProperty.textTransform,
    value: const TwEnumValue('capitalize'),
  ),
  'truncate': TwNamedPlugin(
    property: TwProperty.textOverflow,
    value: const TwEnumValue(TextOverflow.ellipsis),
  ),

  // Line height
  'leading-none': TwNamedPlugin(
    property: TwProperty.lineHeight,
    value: const TwLengthValue(1.0, TwUnit.none),
  ),
  'leading-tight': TwNamedPlugin(
    property: TwProperty.lineHeight,
    value: const TwLengthValue(1.25, TwUnit.none),
  ),
  'leading-snug': TwNamedPlugin(
    property: TwProperty.lineHeight,
    value: const TwLengthValue(1.375, TwUnit.none),
  ),
  'leading-normal': TwNamedPlugin(
    property: TwProperty.lineHeight,
    value: const TwLengthValue(1.5, TwUnit.none),
  ),
  'leading-relaxed': TwNamedPlugin(
    property: TwProperty.lineHeight,
    value: const TwLengthValue(1.625, TwUnit.none),
  ),
  'leading-loose': TwNamedPlugin(
    property: TwProperty.lineHeight,
    value: const TwLengthValue(2.0, TwUnit.none),
  ),

  // Letter spacing
  'tracking-tighter': TwNamedPlugin(
    property: TwProperty.letterSpacing,
    value: const TwLengthValue(-0.8),
  ),
  'tracking-tight': TwNamedPlugin(
    property: TwProperty.letterSpacing,
    value: const TwLengthValue(-0.4),
  ),
  'tracking-normal': TwNamedPlugin(
    property: TwProperty.letterSpacing,
    value: const TwLengthValue(0),
  ),
  'tracking-wide': TwNamedPlugin(
    property: TwProperty.letterSpacing,
    value: const TwLengthValue(0.4),
  ),
  'tracking-wider': TwNamedPlugin(
    property: TwProperty.letterSpacing,
    value: const TwLengthValue(0.8),
  ),
  'tracking-widest': TwNamedPlugin(
    property: TwProperty.letterSpacing,
    value: const TwLengthValue(1.6),
  ),

  // Transitions
  'transition': TwNamedPlugin(
    property: TwProperty.transition,
    value: const TwEnumValue(true),
  ),
  'transition-all': TwNamedPlugin(
    property: TwProperty.transition,
    value: const TwEnumValue(true),
  ),
  'transition-colors': TwNamedPlugin(
    property: TwProperty.transition,
    value: const TwEnumValue(true),
  ),
  'transition-opacity': TwNamedPlugin(
    property: TwProperty.transition,
    value: const TwEnumValue(true),
  ),
  'transition-shadow': TwNamedPlugin(
    property: TwProperty.transition,
    value: const TwEnumValue(true),
  ),
  'transition-transform': TwNamedPlugin(
    property: TwProperty.transition,
    value: const TwEnumValue(true),
  ),
  'transition-none': TwNamedPlugin(
    property: TwProperty.transition,
    value: const TwEnumValue(false),
  ),

  // Easing curves
  'ease-linear': TwNamedPlugin(
    property: TwProperty.transitionCurve,
    value: TwCurveValue(Curves.linear),
  ),
  'ease-in': TwNamedPlugin(
    property: TwProperty.transitionCurve,
    value: TwCurveValue(Curves.easeIn),
  ),
  'ease-out': TwNamedPlugin(
    property: TwProperty.transitionCurve,
    value: TwCurveValue(Curves.easeOut),
  ),
  'ease-in-out': TwNamedPlugin(
    property: TwProperty.transitionCurve,
    value: TwCurveValue(Curves.easeInOut),
  ),

  // Sizing special values
  'w-full': TwNamedPlugin(
    property: TwProperty.width,
    value: const TwEnumValue('full'),
  ),
  'w-screen': TwNamedPlugin(
    property: TwProperty.width,
    value: const TwEnumValue('screen'),
  ),
  'w-auto': TwNamedPlugin(
    property: TwProperty.width,
    value: const TwEnumValue('auto'),
  ),
  'h-full': TwNamedPlugin(
    property: TwProperty.height,
    value: const TwEnumValue('full'),
  ),
  'h-screen': TwNamedPlugin(
    property: TwProperty.height,
    value: const TwEnumValue('screen'),
  ),
  'h-auto': TwNamedPlugin(
    property: TwProperty.height,
    value: const TwEnumValue('auto'),
  ),
  'min-w-0': TwNamedPlugin(
    property: TwProperty.minWidth,
    value: const TwLengthValue(0),
  ),
  'min-w-auto': TwNamedPlugin(
    property: TwProperty.minWidth,
    value: const TwEnumValue('auto'),
  ),
  'min-h-0': TwNamedPlugin(
    property: TwProperty.minHeight,
    value: const TwLengthValue(0),
  ),
};

// =============================================================================
// Variant Definitions
// =============================================================================

/// Interaction variant names mapping to normalized state names.
const Map<String, String> interactionVariants = {
  'hover': 'hover',
  'focus': 'focus',
  'active': 'pressed',
  'pressed': 'pressed',
  'disabled': 'disabled',
  'enabled': 'enabled',
};

/// Theme variant names.
const Map<String, String> themeVariants = {
  'dark': 'dark',
  'light': 'light',
};

// =============================================================================
// findRoot Algorithm
// =============================================================================

/// Set of all known plugin prefixes for fast lookup.
final Set<String> _allPluginPrefixes = {
  ...functionalPlugins.keys,
  ...namedPlugins.keys,
};

/// Finds the root prefix by iteratively stripping dashes.
///
/// Example: 'bg-red-500' -> ('bg', 'red-500')
/// Example: 'p-4' -> ('p', '4')
/// Example: 'flex-row' -> ('flex-row', null) (exact match in namedPlugins)
///
/// Returns null if no matching prefix is found.
(String, String?)? findRoot(String token) {
  // Check exact match first (for namedPlugins like 'flex-row', 'items-center')
  if (_allPluginPrefixes.contains(token)) {
    return (token, null);
  }

  // Iteratively strip from last dash to find functional plugin prefix
  var current = token;
  while (current.isNotEmpty) {
    final lastDash = current.lastIndexOf('-');
    if (lastDash == -1) break;

    current = current.substring(0, lastDash);
    if (functionalPlugins.containsKey(current)) {
      return (current, token.substring(lastDash + 1));
    }
  }

  return null;
}

// =============================================================================
// Gradient Direction Map
// =============================================================================

/// Gradient direction alignments for Tailwind gradient tokens.
const Map<String, (Alignment, Alignment)> gradientDirections = {
  'to-t': (Alignment.bottomCenter, Alignment.topCenter),
  'to-tr': (Alignment.bottomLeft, Alignment.topRight),
  'to-r': (Alignment.centerLeft, Alignment.centerRight),
  'to-br': (Alignment.topLeft, Alignment.bottomRight),
  'to-b': (Alignment.topCenter, Alignment.bottomCenter),
  'to-bl': (Alignment.topRight, Alignment.bottomLeft),
  'to-l': (Alignment.centerRight, Alignment.centerLeft),
  'to-tl': (Alignment.bottomRight, Alignment.topLeft),
};

// =============================================================================
// Tailwind Default Line Heights
// =============================================================================

/// Tailwind default line heights for text-* sizes (as multipliers).
const Map<String, double> tailwindLineHeights = {
  'xs': 1.333, // 12px / 16px
  'sm': 1.429, // 14px / 20px
  'base': 1.5, // 16px / 24px
  'lg': 1.556, // 18px / 28px
  'xl': 1.4, // 20px / 28px
  '2xl': 1.333, // 24px / 32px
  '3xl': 1.2, // 30px / 36px
  '4xl': 1.111, // 36px / 40px
  '5xl': 1.0, // 48px / 48px (leading-none)
  '6xl': 1.0, // 60px / 60px
  '7xl': 1.0, // 72px / 72px
  '8xl': 1.0, // 96px / 96px
  '9xl': 1.0, // 128px / 128px
};

/// Tailwind Preflight default line-height (1.5).
const double preflightLineHeight = 1.5;

// =============================================================================
// Helpers
// =============================================================================

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
