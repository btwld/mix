import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'tw_config.dart';
import 'tw_utils.dart';

typedef TokenWarningCallback = void Function(String token);

/// Extension to provide convenience method for wrapping default text styles.
extension BoxStylerTextStyleExtension on BoxStyler {
  /// Wraps this box styler with a default text style modifier.
  BoxStyler wrapDefaultTextStyle(TextStyleMix textStyle) {
    return wrap(WidgetModifierConfig.defaultTextStyle(style: textStyle));
  }
}

/// Extension to provide convenience method for wrapping default text styles on FlexBox.
extension FlexBoxStylerTextStyleExtension on FlexBoxStyler {
  /// Wraps this flex box styler with a default text style modifier.
  FlexBoxStyler wrapDefaultTextStyle(TextStyleMix textStyle) {
    return wrap(WidgetModifierConfig.defaultTextStyle(style: textStyle));
  }
}

const Map<String, ElevationShadow> _shadowElevationTokens = {
  'shadow-sm': ElevationShadow.one,
  'shadow': ElevationShadow.two,
  'shadow-md': ElevationShadow.three,
  'shadow-lg': ElevationShadow.six,
  'shadow-xl': ElevationShadow.nine,
  'shadow-2xl': ElevationShadow.twelve,
};

/// Tailwind Preflight default line-height (1.5).
/// Applied to all text unless overridden by text-* or leading-* classes.
const double _preflightLineHeight = 1.5;

/// Tailwind default line heights for text-* sizes (as multipliers).
/// These match the default line-height values in Tailwind CSS.
const Map<String, double> _tailwindLineHeights = {
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

/// Tailwind ease token mapping to Flutter curves.
const Map<String, Curve> _easeTokens = {
  'ease-linear': Curves.linear,
  'ease-in': Curves.easeIn,
  'ease-out': Curves.easeOut,
  'ease-in-out': Curves.easeInOut,
};

/// Transition trigger tokens that enable animation.
const Set<String> _transitionTriggerTokens = {
  'transition',
  'transition-all',
  'transition-colors',
  'transition-opacity',
  'transition-shadow',
  'transition-transform',
};

/// Valid Tailwind duration/delay keys (matches TwConfig._standard.durations/delays).
const Set<String> _validTimeKeys = {
  '0',
  '75',
  '100',
  '150',
  '200',
  '300',
  '500',
  '700',
  '1000',
};

/// Valid Tailwind scale keys (matches TwConfig._standard.scales).
const Set<String> _validScaleKeys = {
  '0',
  '50',
  '75',
  '90',
  '95',
  '100',
  '105',
  '110',
  '125',
  '150',
};

/// Valid Tailwind rotation keys (matches TwConfig._standard.rotations).
const Set<String> _validRotationKeys = {
  '0',
  '1',
  '2',
  '3',
  '6',
  '12',
  '45',
  '90',
  '180',
};

/// Tailwind font weight token mapping.
const Map<String, FontWeight> _fontWeightTokens = {
  'font-thin': FontWeight.w100,
  'font-extralight': FontWeight.w200,
  'font-light': FontWeight.w300,
  'font-normal': FontWeight.w400,
  'font-medium': FontWeight.w500,
  'font-semibold': FontWeight.w600,
  'font-bold': FontWeight.w700,
  'font-extrabold': FontWeight.w800,
  'font-black': FontWeight.w900,
};

/// Accumulates individual transform components before building Matrix4.
/// Supports component-wise inheritance from base to variant transforms.
class _TransformAccum {
  double? scale;
  double? rotateDeg;
  double? translateX;
  double? translateY;

  _TransformAccum();

  /// Creates copy inheriting from [base], then overlaying [this].
  _TransformAccum inheritFrom(_TransformAccum base) {
    return _TransformAccum()
      ..scale = scale ?? base.scale
      ..rotateDeg = rotateDeg ?? base.rotateDeg
      ..translateX = translateX ?? base.translateX
      ..translateY = translateY ?? base.translateY;
  }

  bool get hasAnyTransform =>
      scale != null ||
      rotateDeg != null ||
      translateX != null ||
      translateY != null;

  /// Builds Matrix4 in Tailwind's fixed order: translate -> rotate -> scale.
  Matrix4 toMatrix4() {
    var matrix = Matrix4.identity();
    if (translateX != null || translateY != null) {
      matrix = matrix.multiplied(
        Matrix4.translationValues(translateX ?? 0.0, translateY ?? 0.0, 0.0),
      );
    }
    if (rotateDeg != null) {
      matrix = matrix.multiplied(Matrix4.rotationZ(rotateDeg! * math.pi / 180));
    }
    if (scale != null) {
      matrix = matrix.multiplied(Matrix4.diagonal3Values(scale!, scale!, 1.0));
    }
    return matrix;
  }
}

/// Gradient direction alignments for Tailwind gradient tokens.
const Map<String, (Alignment, Alignment)> _gradientDirections = {
  'to-t': (Alignment.bottomCenter, Alignment.topCenter),
  'to-tr': (Alignment.bottomLeft, Alignment.topRight),
  'to-r': (Alignment.centerLeft, Alignment.centerRight),
  'to-br': (Alignment.topLeft, Alignment.bottomRight),
  'to-b': (Alignment.topCenter, Alignment.bottomCenter),
  'to-bl': (Alignment.topRight, Alignment.bottomLeft),
  'to-l': (Alignment.centerRight, Alignment.centerLeft),
  'to-tl': (Alignment.bottomRight, Alignment.topLeft),
};

/// Accumulates gradient properties before final application.
class _GradientAccum {
  (Alignment, Alignment)? direction;
  Color? fromColor;
  Color? viaColor;
  Color? toColor;

  _GradientAccum();

  bool get hasGradient => direction != null && fromColor != null;

  LinearGradientMix? toGradientMix() {
    if (!hasGradient) return null;
    final (begin, end) = direction!;
    final colors = <Color>[
      fromColor!,
      if (viaColor != null) viaColor!,
      toColor ?? fromColor!,
    ];
    return LinearGradientMix(begin: begin, end: end, colors: colors);
  }
}

/// Accumulates border properties before final application.
/// Separates "structure" tokens (width/direction) from "color" tokens.
/// Color is only applied to borders that have structure.
class _BorderAccum {
  double? topWidth;
  double? bottomWidth;
  double? leftWidth;
  double? rightWidth;
  Color? color;

  _BorderAccum();

  /// Creates copy inheriting all properties from [base], then overlaying [this].
  /// Follows same pattern as [_TransformAccum.inheritFrom].
  _BorderAccum inheritFrom(_BorderAccum base) {
    return _BorderAccum()
      ..topWidth = topWidth ?? base.topWidth
      ..bottomWidth = bottomWidth ?? base.bottomWidth
      ..leftWidth = leftWidth ?? base.leftWidth
      ..rightWidth = rightWidth ?? base.rightWidth
      ..color = color ?? base.color;
  }

  /// Whether any border structure (width/direction) was specified.
  bool get hasStructure =>
      topWidth != null ||
      bottomWidth != null ||
      leftWidth != null ||
      rightWidth != null;

  /// Sets all sides to the given width.
  void setAll(double width) {
    topWidth = width;
    bottomWidth = width;
    leftWidth = width;
    rightWidth = width;
  }

  /// Sets horizontal sides (left/right) to the given width.
  void setHorizontal(double width) {
    leftWidth = width;
    rightWidth = width;
  }

  /// Sets vertical sides (top/bottom) to the given width.
  void setVertical(double width) {
    topWidth = width;
    bottomWidth = width;
  }
}

/// Returns true if the token is a gradient-related token.
bool _isGradientToken(String token) {
  if (token.startsWith('bg-gradient-')) return true;
  if (token.startsWith('bg-linear-')) return true; // Tailwind v4 canonical
  if (token.startsWith('from-')) return true;
  if (token.startsWith('via-')) return true;
  if (token.startsWith('to-') && _gradientDirections.containsKey(token)) {
    return false; // 'to-*' alone is a direction, handled by bg-gradient-to-*
  }
  // Check for gradient color tokens (to-{color})
  if (token.startsWith('to-') && !_gradientDirections.containsKey(token)) {
    return true;
  }
  return false;
}

/// Accumulates a gradient token into [accum].
void _accumulateGradient(_GradientAccum accum, String base, TwConfig config) {
  if (base.startsWith('bg-gradient-')) {
    final dirKey = base.substring(12); // Remove 'bg-gradient-'
    final dir = _gradientDirections[dirKey];
    if (dir != null) {
      accum.direction = dir;
    }
  } else if (base.startsWith('bg-linear-')) {
    // Tailwind v4 canonical syntax (bg-linear-to-* instead of bg-gradient-to-*)
    final dirKey = base.substring(10); // Remove 'bg-linear-'
    final dir = _gradientDirections[dirKey];
    if (dir != null) {
      accum.direction = dir;
    }
  } else if (base.startsWith('from-')) {
    final colorKey = base.substring(5);
    accum.fromColor = config.colorOf(colorKey);
  } else if (base.startsWith('via-')) {
    final colorKey = base.substring(4);
    accum.viaColor = config.colorOf(colorKey);
  } else if (base.startsWith('to-') && !_gradientDirections.containsKey(base)) {
    final colorKey = base.substring(3);
    accum.toColor = config.colorOf(colorKey);
  }
}

/// Accumulates a transform token into [accum].
///
/// IMPORTANT: Negative prefixes must be checked before their positive counterparts.
/// For example, '-rotate-45' must not match 'rotate-', so we check '-rotate-' first.
/// Same for '-translate-x-' before 'translate-x-', and '-translate-y-' before 'translate-y-'.
void _accumulateTransform(_TransformAccum accum, String base, TwConfig config) {
  if (base.startsWith('scale-')) {
    accum.scale = config.scaleOf(base.substring(6));
  } else if (base.startsWith('-rotate-')) {
    // Check negative rotation before positive
    final deg = config.rotationOf(base.substring(8));
    if (deg != null) accum.rotateDeg = -deg;
  } else if (base.startsWith('rotate-')) {
    accum.rotateDeg = config.rotationOf(base.substring(7));
  } else if (base.startsWith('-translate-x-')) {
    // Check negative translation before positive
    accum.translateX = -config.spaceOf(base.substring(13));
  } else if (base.startsWith('translate-x-')) {
    accum.translateX = config.spaceOf(base.substring(12));
  } else if (base.startsWith('-translate-y-')) {
    // Check negative translation before positive
    accum.translateY = -config.spaceOf(base.substring(13));
  } else if (base.startsWith('translate-y-')) {
    accum.translateY = config.spaceOf(base.substring(12));
  }
}

/// Accumulates a border token into [accum].
/// Uses [_parseBorderDirective] and [_defaultBorderColor] for parsing.
void _accumulateBorder(_BorderAccum accum, String base, TwConfig config) {
  if (!base.startsWith('border')) return;

  // Handle color-only tokens (border-red-500)
  if (base.startsWith('border-')) {
    final key = base.substring(7);
    final color = config.colorOf(key);
    if (color != null &&
        config.borderWidthOf(key, fallback: -1) <= 0 &&
        _parseBorderDirective(config, base) == null) {
      accum.color = color;
      return;
    }
  }

  // Handle 'border' (all sides, width 1)
  if (base == 'border') {
    accum.setAll(1.0);
    return;
  }

  // Handle width-only tokens (border-2, border-4, etc.)
  if (base.startsWith('border-')) {
    final widthKey = base.substring(7);
    final widthOnly = config.borderWidthOf(widthKey, fallback: -1);
    if (widthOnly > 0) {
      accum.setAll(widthOnly);
      return;
    }
  }

  // Handle direction tokens (border-t, border-x-2, border-t-red-500, etc.)
  if (_parseBorderDirective(config, base) case final directive?) {
    final width = directive.width;
    // If directive has a non-default color, set it
    if (directive.color != _defaultBorderColor(config)) {
      accum.color = directive.color;
    }

    switch (directive.direction) {
      case 't':
        accum.topWidth = width;
      case 'b':
        accum.bottomWidth = width;
      case 'l':
        accum.leftWidth = width;
      case 'r':
        accum.rightWidth = width;
      case 'x':
        accum.setHorizontal(width);
      case 'y':
        accum.setVertical(width);
    }
  }
}

/// Shared spacing token types for padding/margin parsing.
enum _SpacingKind {
  paddingX,
  paddingY,
  paddingTop,
  paddingRight,
  paddingBottom,
  paddingLeft,
  paddingAll,
  marginX,
  marginY,
  marginTop,
  marginRight,
  marginBottom,
  marginLeft,
  marginAll,
}

/// Table-driven spacing prefix mapping.
/// Order matters: more specific prefixes (px-, py-) must come before less specific (p-).
const Map<String, _SpacingKind> _spacingPrefixes = {
  'px-': _SpacingKind.paddingX,
  'py-': _SpacingKind.paddingY,
  'pt-': _SpacingKind.paddingTop,
  'pr-': _SpacingKind.paddingRight,
  'pb-': _SpacingKind.paddingBottom,
  'pl-': _SpacingKind.paddingLeft,
  'p-': _SpacingKind.paddingAll,
  'mx-': _SpacingKind.marginX,
  'my-': _SpacingKind.marginY,
  'mt-': _SpacingKind.marginTop,
  'mr-': _SpacingKind.marginRight,
  'mb-': _SpacingKind.marginBottom,
  'ml-': _SpacingKind.marginLeft,
  'm-': _SpacingKind.marginAll,
};

/// Parsed spacing token with kind and value.
class _SpacingToken {
  const _SpacingToken(this.kind, this.value);
  final _SpacingKind kind;
  final double value;
}

/// Parses padding/margin tokens using table-driven lookup.
/// Returns null if not a spacing token.
_SpacingToken? _parseSpacingToken(String token, TwConfig config) {
  for (final entry in _spacingPrefixes.entries) {
    if (token.startsWith(entry.key)) {
      return _SpacingToken(
        entry.value,
        config.spaceOf(token.substring(entry.key.length)),
      );
    }
  }
  return null;
}

/// Applies spacing token to FlexBoxStyler.
FlexBoxStyler _applySpacingToFlex(FlexBoxStyler s, _SpacingToken t) =>
    switch (t.kind) {
      _SpacingKind.paddingX => s.paddingX(t.value),
      _SpacingKind.paddingY => s.paddingY(t.value),
      _SpacingKind.paddingTop => s.paddingTop(t.value),
      _SpacingKind.paddingRight => s.paddingRight(t.value),
      _SpacingKind.paddingBottom => s.paddingBottom(t.value),
      _SpacingKind.paddingLeft => s.paddingLeft(t.value),
      _SpacingKind.paddingAll => s.paddingAll(t.value),
      _SpacingKind.marginX => s.marginX(t.value),
      _SpacingKind.marginY => s.marginY(t.value),
      _SpacingKind.marginTop => s.marginTop(t.value),
      _SpacingKind.marginRight => s.marginRight(t.value),
      _SpacingKind.marginBottom => s.marginBottom(t.value),
      _SpacingKind.marginLeft => s.marginLeft(t.value),
      _SpacingKind.marginAll => s.marginAll(t.value),
    };

/// Applies spacing token to BoxStyler.
BoxStyler _applySpacingToBox(BoxStyler s, _SpacingToken t) => switch (t.kind) {
  _SpacingKind.paddingX => s.paddingX(t.value),
  _SpacingKind.paddingY => s.paddingY(t.value),
  _SpacingKind.paddingTop => s.paddingTop(t.value),
  _SpacingKind.paddingRight => s.paddingRight(t.value),
  _SpacingKind.paddingBottom => s.paddingBottom(t.value),
  _SpacingKind.paddingLeft => s.paddingLeft(t.value),
  _SpacingKind.paddingAll => s.paddingAll(t.value),
  _SpacingKind.marginX => s.marginX(t.value),
  _SpacingKind.marginY => s.marginY(t.value),
  _SpacingKind.marginTop => s.marginTop(t.value),
  _SpacingKind.marginRight => s.marginRight(t.value),
  _SpacingKind.marginBottom => s.marginBottom(t.value),
  _SpacingKind.marginLeft => s.marginLeft(t.value),
  _SpacingKind.marginAll => s.marginAll(t.value),
};

/// Directional radius variations (8 directions including corners).
enum _RadiusKind {
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

/// Parsed directional radius token.
class _RadiusToken {
  const _RadiusToken(this.kind, this.radius);
  final _RadiusKind kind;
  final double radius;
}

/// Parses directional radius tokens (rounded-t-*, rounded-tl-*, etc.).
_RadiusToken? _parseRadiusToken(String token, TwConfig config) {
  final directive = _parseRadiusDirective(config, token);
  if (directive == null) return null;

  final kind = switch (directive.direction) {
    't' => _RadiusKind.top,
    'b' => _RadiusKind.bottom,
    'l' => _RadiusKind.left,
    'r' => _RadiusKind.right,
    'tl' => _RadiusKind.topLeft,
    'tr' => _RadiusKind.topRight,
    'bl' => _RadiusKind.bottomLeft,
    'br' => _RadiusKind.bottomRight,
    _ => null,
  };
  if (kind == null) return null;
  return _RadiusToken(kind, directive.radius);
}

/// Applies radius token to FlexBoxStyler.
FlexBoxStyler _applyRadiusToFlex(FlexBoxStyler s, _RadiusToken t) =>
    switch (t.kind) {
      _RadiusKind.top => s.borderRoundedTop(t.radius),
      _RadiusKind.bottom => s.borderRoundedBottom(t.radius),
      _RadiusKind.left => s.borderRoundedLeft(t.radius),
      _RadiusKind.right => s.borderRoundedRight(t.radius),
      _RadiusKind.topLeft => s.borderRoundedTopLeft(t.radius),
      _RadiusKind.topRight => s.borderRoundedTopRight(t.radius),
      _RadiusKind.bottomLeft => s.borderRoundedBottomLeft(t.radius),
      _RadiusKind.bottomRight => s.borderRoundedBottomRight(t.radius),
    };

/// Applies radius token to BoxStyler.
BoxStyler _applyRadiusToBox(BoxStyler s, _RadiusToken t) => switch (t.kind) {
  _RadiusKind.top => s.borderRoundedTop(t.radius),
  _RadiusKind.bottom => s.borderRoundedBottom(t.radius),
  _RadiusKind.left => s.borderRoundedLeft(t.radius),
  _RadiusKind.right => s.borderRoundedRight(t.radius),
  _RadiusKind.topLeft => s.borderRoundedTopLeft(t.radius),
  _RadiusKind.topRight => s.borderRoundedTopRight(t.radius),
  _RadiusKind.bottomLeft => s.borderRoundedBottomLeft(t.radius),
  _RadiusKind.bottomRight => s.borderRoundedBottomRight(t.radius),
};

/// Returns true if the token is an animation-related token.
bool _isAnimationToken(String token) {
  if (_transitionTriggerTokens.contains(token)) return true;
  if (token == 'transition-none') return true;
  if (_easeTokens.containsKey(token)) return true;

  // Only match valid Tailwind duration/delay values
  if (token.startsWith('duration-')) {
    return _validTimeKeys.contains(token.substring(9));
  }
  if (token.startsWith('delay-')) {
    return _validTimeKeys.contains(token.substring(6));
  }
  return false;
}

/// Returns true if the token is a valid transform-related token.
/// Validates the value portion against known valid keys.
bool _isTransformToken(String token) {
  if (token.startsWith('scale-')) {
    return _validScaleKeys.contains(token.substring(6));
  }
  if (token.startsWith('-rotate-')) {
    return _validRotationKeys.contains(token.substring(8));
  }
  if (token.startsWith('rotate-')) {
    return _validRotationKeys.contains(token.substring(7));
  }
  // Translate tokens use spacing scale - allow any spacing value (validated elsewhere)
  if (token.startsWith('translate-x-')) return true;
  if (token.startsWith('translate-y-')) return true;
  if (token.startsWith('-translate-x-')) return true;
  if (token.startsWith('-translate-y-')) return true;
  return false;
}

final Map<String, FlexBoxStyler Function(FlexBoxStyler)> _flexAtomicHandlers = {
  // Use CrossAxisAlignment.start for better visual parity with CSS.
  // CSS default is `align-items: stretch`, but Flutter's constraint model differs:
  // - CSS: Container sizes to content first, then children stretch to match
  // - Flutter: Parent provides bounds, children stretch to fill those bounds
  // Using .start produces better visual parity because children size to intrinsic
  // height, matching CSS behavior where items don't stretch beyond content needs.
  // Users can explicitly add `items-stretch` where full stretch behavior is needed.
  'flex': (s) => s.row().crossAxisAlignment(CrossAxisAlignment.start),
  'flex-row': (s) => s.row().crossAxisAlignment(CrossAxisAlignment.start),
  'flex-col': (s) => s.column().crossAxisAlignment(CrossAxisAlignment.start),
  'items-start': (s) => s.crossAxisAlignment(CrossAxisAlignment.start),
  'items-center': (s) => s.crossAxisAlignment(CrossAxisAlignment.center),
  'items-end': (s) => s.crossAxisAlignment(CrossAxisAlignment.end),
  'items-stretch': (s) => s.crossAxisAlignment(CrossAxisAlignment.stretch),
  'items-baseline': (s) => s
      .crossAxisAlignment(CrossAxisAlignment.baseline)
      .textBaseline(TextBaseline.alphabetic),
  'justify-start': (s) => s.mainAxisAlignment(MainAxisAlignment.start),
  'justify-center': (s) => s.mainAxisAlignment(MainAxisAlignment.center),
  'justify-end': (s) => s.mainAxisAlignment(MainAxisAlignment.end),
  'justify-between': (s) => s.mainAxisAlignment(MainAxisAlignment.spaceBetween),
  'justify-around': (s) => s.mainAxisAlignment(MainAxisAlignment.spaceAround),
  'justify-evenly': (s) => s.mainAxisAlignment(MainAxisAlignment.spaceEvenly),
  // Overflow clipping
  'overflow-hidden': (s) => s.clipBehavior(Clip.hardEdge),
  'overflow-visible': (s) => s.clipBehavior(Clip.none),
  'overflow-clip': (s) => s.clipBehavior(Clip.hardEdge),
  'shadow-none': (s) => s.boxShadows(const <BoxShadowMix>[]),
  ..._shadowElevationTokens.map(
    (token, elevation) =>
        MapEntry(token, (FlexBoxStyler s) => s.elevation(elevation)),
  ),
};

final Map<String, BoxStyler Function(BoxStyler, TwConfig)> _boxAtomicHandlers =
    {
      // Overflow clipping
      'overflow-hidden': (s, _) => s.clipBehavior(Clip.hardEdge),
      'overflow-visible': (s, _) => s.clipBehavior(Clip.none),
      'overflow-clip': (s, _) => s.clipBehavior(Clip.hardEdge),
      'shadow-none': (s, _) => s.boxShadows(const <BoxShadowMix>[]),
      ..._shadowElevationTokens.map(
        (token, elevation) =>
            MapEntry(token, (BoxStyler s, _) => s.elevation(elevation)),
      ),
      // Font weights (complete Tailwind set)
      ..._fontWeightTokens.map(
        (token, weight) => MapEntry(
          token,
          (BoxStyler s, _) =>
              s.wrapDefaultTextStyle(TextStyleMix().fontWeight(weight)),
        ),
      ),
    };

final Map<String, TextStyler Function(TextStyler)> _textAtomicHandlers = {
  'uppercase': (s) => s.uppercase(),
  'lowercase': (s) => s.lowercase(),
  'capitalize': (s) => s.capitalize(),
  // Font weights (complete Tailwind set)
  ..._fontWeightTokens.map(
    (token, weight) => MapEntry(token, (TextStyler s) => s.fontWeight(weight)),
  ),
  // Text truncation: overflow ellipsis + single line
  'truncate': (s) =>
      s.overflow(TextOverflow.ellipsis).maxLines(1).softWrap(false),
  // Line height (leading-*)
  'leading-none': (s) => s.height(1.0),
  'leading-tight': (s) => s.height(1.25),
  'leading-snug': (s) => s.height(1.375),
  'leading-normal': (s) => s.height(1.5),
  'leading-relaxed': (s) => s.height(1.625),
  'leading-loose': (s) => s.height(2.0),
  // Leading distribution (text centering behavior)
  // leading-even: distributes leading space evenly above/below text
  'leading-even': (s) => s.textHeightBehavior(
    TextHeightBehaviorMix(leadingDistribution: TextLeadingDistribution.even),
  ),
  // leading-trim: removes extra leading for tighter vertical centering (avatars)
  'leading-trim': (s) => s.textHeightBehavior(
    TextHeightBehaviorMix(
      leadingDistribution: TextLeadingDistribution.even,
      applyHeightToFirstAscent: false,
      applyHeightToLastDescent: false,
    ),
  ),
  // Letter spacing (tracking-*)
  'tracking-tighter': (s) => s.letterSpacing(-0.8),
  'tracking-tight': (s) => s.letterSpacing(-0.4),
  'tracking-normal': (s) => s.letterSpacing(0),
  'tracking-wide': (s) => s.letterSpacing(0.4),
  'tracking-wider': (s) => s.letterSpacing(0.8),
  'tracking-widest': (s) => s.letterSpacing(1.6),
};

// =============================================================================
// Generic Prefix Handling
// =============================================================================

/// Applies a variant modifier (e.g., hover, focus) to a base styler.
typedef _VariantApplier<S> = S Function(S base, S variant);

typedef _StylerMerge<S> = S Function(S base, S other);
typedef _BreakpointApplier<S> = S Function(S base, Breakpoint bp, S child);
typedef _TransformApplier<S> = S Function(S styler, Matrix4 matrix);
typedef _BorderSideApplier<S> =
    S Function(S styler, {required Color color, required double width});

Map<String, _VariantApplier<S>> _buildStandardVariants<S>({
  required _VariantApplier<S> hover,
  required _VariantApplier<S> focus,
  required _VariantApplier<S> pressed,
  required _VariantApplier<S> disabled,
  required _VariantApplier<S> enabled,
  required _VariantApplier<S> dark,
  required _VariantApplier<S> light,
}) {
  return {
    'hover': hover,
    'focus': focus,
    'active': pressed, // Tailwind alias
    'pressed': pressed,
    'disabled': disabled,
    'enabled': enabled,
    'dark': dark,
    'light': light,
  };
}

/// Variant maps for each styler type - single source of truth for prefix handling.
final _flexVariants = _buildStandardVariants<FlexBoxStyler>(
  hover: (b, v) => b.onHovered(v),
  focus: (b, v) => b.onFocused(v),
  pressed: (b, v) => b.onPressed(v),
  disabled: (b, v) => b.onDisabled(v),
  enabled: (b, v) => b.onEnabled(v),
  dark: (b, v) => b.onDark(v),
  light: (b, v) => b.onLight(v),
);

final _boxVariants = _buildStandardVariants<BoxStyler>(
  hover: (b, v) => b.onHovered(v),
  focus: (b, v) => b.onFocused(v),
  pressed: (b, v) => b.onPressed(v),
  disabled: (b, v) => b.onDisabled(v),
  enabled: (b, v) => b.onEnabled(v),
  dark: (b, v) => b.onDark(v),
  light: (b, v) => b.onLight(v),
);

final _textVariants = _buildStandardVariants<TextStyler>(
  hover: (b, v) => b.onHovered(v),
  focus: (b, v) => b.onFocused(v),
  pressed: (b, v) => b.onPressed(v),
  disabled: (b, v) => b.onDisabled(v),
  enabled: (b, v) => b.onEnabled(v),
  dark: (b, v) => b.onDark(v),
  light: (b, v) => b.onLight(v),
);

Color _defaultBorderColor(TwConfig config) =>
    config.colorOf('gray-200') ?? const Color(0xFFE5E7EB);

class _BorderDirective {
  const _BorderDirective(this.direction, this.color, this.width);

  final String direction;
  final Color color;
  final double width;
}

_BorderDirective? _parseBorderDirective(TwConfig config, String token) {
  if (!token.startsWith('border-')) {
    return null;
  }

  final body = token.substring(7);
  final dashIndex = body.indexOf('-');
  final direction = dashIndex == -1 ? body : body.substring(0, dashIndex);

  if (direction.isEmpty) {
    return null;
  }

  const supported = {'t', 'b', 'l', 'r', 'x', 'y'};
  if (!supported.contains(direction)) {
    return null;
  }

  final remainder = dashIndex == -1 ? '' : body.substring(dashIndex + 1);

  var width = 1.0;
  var color = _defaultBorderColor(config);

  if (remainder.isNotEmpty) {
    final widthCandidate = config.borderWidthOf(remainder, fallback: -1);
    if (widthCandidate > 0) {
      width = widthCandidate;
      color = _defaultBorderColor(config);
    } else {
      final colorCandidate = config.colorOf(remainder);
      if (colorCandidate != null) {
        color = colorCandidate;
      } else {
        return null;
      }
    }
  }

  return _BorderDirective(direction, color, width);
}

class _RadiusDirective {
  const _RadiusDirective(this.direction, this.radius);

  final String direction;
  final double radius;
}

_RadiusDirective? _parseRadiusDirective(TwConfig config, String token) {
  if (!token.startsWith('rounded-')) {
    return null;
  }

  final directive = token.substring(8);
  if (directive.isEmpty) {
    return null;
  }

  final dashIndex = directive.indexOf('-');
  final key = dashIndex == -1 ? directive : directive.substring(0, dashIndex);

  const supported = {'t', 'b', 'l', 'r', 'tl', 'tr', 'bl', 'br'};
  if (!supported.contains(key)) {
    return null;
  }

  final sizeKey = dashIndex == -1 ? '' : directive.substring(dashIndex + 1);
  final radius = config.radiusOf(sizeKey);
  return _RadiusDirective(key, radius);
}

/// Parses Tailwind-like class strings into Mix stylers.
class TwParser {
  TwParser({TwConfig? config, this.onUnsupported})
    : config = config ?? TwConfig.standard();

  final TwConfig config;
  final TokenWarningCallback? onUnsupported;

  List<String> listTokens(String classNames) {
    final trimmed = classNames.trim();
    if (trimmed.isEmpty) {
      return const [];
    }
    return trimmed.split(RegExp(r'\s+'));
  }

  Set<String> setTokens(String classNames) => listTokens(classNames).toSet();

  bool wantsFlex(Set<String> tokens) {
    for (final token in tokens) {
      final base = token.substring(token.lastIndexOf(':') + 1);
      // Explicit flex tokens
      if (base == 'flex' || base == 'flex-row' || base == 'flex-col') {
        return true;
      }
      // Flex-only properties that imply flex intent
      if (base.startsWith('items-') ||
          base.startsWith('justify-') ||
          base.startsWith('gap-') ||
          base == 'gap') {
        return true;
      }
    }
    return false;
  }

  bool _hasOnlyKnownPrefixParts<T>(String prefix, Map<String, T> variants) {
    if (prefix.isEmpty) return true;
    for (final part in prefix.split(':')) {
      if (_isBreakpoint(part)) continue;
      if (variants.containsKey(part)) continue;
      return false;
    }
    return true;
  }

  // ---------------------------------------------------------------------------
  // Border accumulation helpers
  // ---------------------------------------------------------------------------

  S _wrapStyleWithPrefix<S>(
    String prefix,
    S style, {
    required Map<String, _VariantApplier<S>> variants,
    required S Function() newStyler,
    required _BreakpointApplier<S> applyBreakpoint,
  }) {
    if (prefix.isEmpty) return style;

    return _applyPrefixedToken<S>(
      newStyler(),
      '$prefix:__tw_internal__',
      variants,
      newStyler,
      (base, _) => style,
      applyBreakpoint,
    );
  }

  S _applyBorderSides<S>(
    S styler,
    _BorderAccum border, {
    required Color color,
    required _BorderSideApplier<S> top,
    required _BorderSideApplier<S> bottom,
    required _BorderSideApplier<S> left,
    required _BorderSideApplier<S> right,
  }) {
    var result = styler;

    if (border.topWidth != null) {
      result = top(result, color: color, width: border.topWidth!);
    }
    if (border.bottomWidth != null) {
      result = bottom(result, color: color, width: border.bottomWidth!);
    }
    if (border.leftWidth != null) {
      result = left(result, color: color, width: border.leftWidth!);
    }
    if (border.rightWidth != null) {
      result = right(result, color: color, width: border.rightWidth!);
    }

    return result;
  }

  S _applyAccumulatedBorders<S>(
    S styler,
    _BorderAccum baseBorder,
    Map<String, _BorderAccum> variantBorders, {
    required Map<String, _VariantApplier<S>> variants,
    required S Function() newStyler,
    required _StylerMerge<S> merge,
    required _BreakpointApplier<S> applyBreakpoint,
    required _BorderSideApplier<S> top,
    required _BorderSideApplier<S> bottom,
    required _BorderSideApplier<S> left,
    required _BorderSideApplier<S> right,
  }) {
    var result = styler;

    // Base borders
    if (baseBorder.hasStructure) {
      final color = baseBorder.color ?? _defaultBorderColor(config);
      result = _applyBorderSides(
        result,
        baseBorder,
        color: color,
        top: top,
        bottom: bottom,
        left: left,
        right: right,
      );
    }

    // Variant borders
    for (final entry in variantBorders.entries) {
      final inherited = entry.value.inheritFrom(baseBorder);
      if (!inherited.hasStructure) continue;

      final color = inherited.color ?? _defaultBorderColor(config);
      final variantStyle = _applyBorderSides(
        newStyler(),
        inherited,
        color: color,
        top: top,
        bottom: bottom,
        left: left,
        right: right,
      );

      final wrapped = _wrapStyleWithPrefix(
        entry.key,
        variantStyle,
        variants: variants,
        newStyler: newStyler,
        applyBreakpoint: applyBreakpoint,
      );
      result = merge(result, wrapped);
    }

    return result;
  }

  S _applyAccumulatedTransforms<S>(
    S styler,
    _TransformAccum baseTransform,
    Map<String, _TransformAccum> variantTransforms, {
    required Map<String, _VariantApplier<S>> variants,
    required S Function() newStyler,
    required _StylerMerge<S> merge,
    required _BreakpointApplier<S> applyBreakpoint,
    required _TransformApplier<S> setTransform,
  }) {
    var result = styler;

    // Base transform or identity for animation interpolation.
    if (baseTransform.hasAnyTransform) {
      result = setTransform(result, baseTransform.toMatrix4());
    } else if (variantTransforms.isNotEmpty) {
      result = setTransform(result, Matrix4.identity());
    }

    // Variant transforms
    for (final entry in variantTransforms.entries) {
      final inherited = entry.value.inheritFrom(baseTransform);
      if (!inherited.hasAnyTransform) continue;

      final variantStyle = setTransform(newStyler(), inherited.toMatrix4());
      final wrapped = _wrapStyleWithPrefix(
        entry.key,
        variantStyle,
        variants: variants,
        newStyler: newStyler,
        applyBreakpoint: applyBreakpoint,
      );
      result = merge(result, wrapped);
    }

    return result;
  }

  /// Returns true if token establishes border structure (width/direction).
  bool _isBorderStructureToken(String token) {
    if (token == 'border') return true;
    if (!token.startsWith('border-')) return false;

    final key = token.substring(7);

    // Direction tokens with optional width/color (e.g., border-t, border-t-2)
    if (_parseBorderDirective(config, token) != null) return true;

    // Width-only tokens (e.g., border-2, border-4)
    if (config.borderWidthOf(key, fallback: -1) > 0) return true;

    return false;
  }

  /// Returns true if token is a color-only border token (e.g., border-gray-200).
  bool _isBorderColorOnlyToken(String token) {
    if (!token.startsWith('border-')) return false;
    final key = token.substring(7);

    // Must be a valid color
    if (config.colorOf(key) == null) return false;

    // Must NOT be a width
    if (config.borderWidthOf(key, fallback: -1) > 0) return false;

    // Must NOT be a direction token
    if (_parseBorderDirective(config, token) != null) return false;

    return true;
  }

  /// Returns true if token is any border-related token.
  bool _isBorderToken(String token) {
    return _isBorderStructureToken(token) || _isBorderColorOnlyToken(token);
  }

  FlexBoxStyler parseFlex(String classNames) {
    final tokens = listTokens(classNames);

    // Single pass: track hasBaseFlex and accumulate transforms/borders/gradients
    var hasBaseFlex = false;
    final baseTransform = _TransformAccum();
    final baseBorder = _BorderAccum();
    final baseGradient = _GradientAccum();
    final variantTransforms = <String, _TransformAccum>{};
    final variantBorders = <String, _BorderAccum>{};

    // Pre-allocate styler - will be set correctly after loop based on hasBaseFlex
    var styler = FlexBoxStyler();

    for (final token in tokens) {
      final colonIndex = token.lastIndexOf(':');
      final prefix = colonIndex > 0 ? token.substring(0, colonIndex) : '';
      final base = colonIndex > 0 ? token.substring(colonIndex + 1) : token;

      // Track base flex during iteration (replaces separate pass)
      if (prefix.isEmpty &&
          (base == 'flex' || base == 'flex-row' || base == 'flex-col')) {
        hasBaseFlex = true;
      }

      // Accumulate gradient tokens (base only - variants not supported yet)
      if (_isGradientToken(base)) {
        if (prefix.isEmpty) {
          _accumulateGradient(baseGradient, base, config);
        }
        continue;
      }

      // Accumulate transform tokens
      if (_isTransformToken(base)) {
        if (!_hasOnlyKnownPrefixParts(prefix, _flexVariants)) {
          onUnsupported?.call(token);
          continue;
        }
        final accum = prefix.isEmpty
            ? baseTransform
            : variantTransforms.putIfAbsent(prefix, _TransformAccum.new);
        _accumulateTransform(accum, base, config);
        continue;
      }

      // Accumulate border tokens
      if (_isBorderToken(base)) {
        if (!_hasOnlyKnownPrefixParts(prefix, _flexVariants)) {
          onUnsupported?.call(token);
          continue;
        }
        final accum = prefix.isEmpty
            ? baseBorder
            : variantBorders.putIfAbsent(prefix, _BorderAccum.new);
        _accumulateBorder(accum, base, config);
        continue;
      }

      // Apply atomic token
      styler = _applyFlexToken(styler, token);
    }

    // Default to column (vertical, block-like) when only prefixed flex
    // This matches Tailwind: below breakpoint = block, at breakpoint = flex
    if (!hasBaseFlex) {
      styler = styler.column();
    }

    // Apply accumulated gradient
    final gradientMix = baseGradient.toGradientMix();
    if (gradientMix != null) {
      styler = styler.gradient(gradientMix);
    }

    // Apply accumulated borders
    styler = _applyAccumulatedBorders(
      styler,
      baseBorder,
      variantBorders,
      variants: _flexVariants,
      newStyler: FlexBoxStyler.new,
      merge: (a, b) => a.merge(b),
      applyBreakpoint: (b, bp, s) => b.onBreakpoint(bp, s),
      top: (s, {required color, required width}) =>
          s.borderTop(color: color, width: width),
      bottom: (s, {required color, required width}) =>
          s.borderBottom(color: color, width: width),
      left: (s, {required color, required width}) =>
          s.borderLeft(color: color, width: width),
      right: (s, {required color, required width}) =>
          s.borderRight(color: color, width: width),
    );

    // Apply accumulated transforms with identity-matrix rule
    return _applyAccumulatedTransforms(
      styler,
      baseTransform,
      variantTransforms,
      variants: _flexVariants,
      newStyler: FlexBoxStyler.new,
      merge: (a, b) => a.merge(b),
      applyBreakpoint: (b, bp, s) => b.onBreakpoint(bp, s),
      setTransform: (s, m) => s.transform(m),
    );
  }

  BoxStyler parseBox(String classNames) {
    final tokens = listTokens(classNames);

    // Single pass: accumulate transforms/borders/gradients while applying atomic tokens
    final baseTransform = _TransformAccum();
    final baseBorder = _BorderAccum();
    final baseGradient = _GradientAccum();
    final variantTransforms = <String, _TransformAccum>{};
    final variantBorders = <String, _BorderAccum>{};

    var styler = BoxStyler();

    for (final token in tokens) {
      final colonIndex = token.lastIndexOf(':');
      final prefix = colonIndex > 0 ? token.substring(0, colonIndex) : '';
      final base = colonIndex > 0 ? token.substring(colonIndex + 1) : token;

      // Accumulate gradient tokens (base only - variants not supported yet)
      if (_isGradientToken(base)) {
        if (prefix.isEmpty) {
          _accumulateGradient(baseGradient, base, config);
        }
        continue;
      }

      // Accumulate transform tokens
      if (_isTransformToken(base)) {
        if (!_hasOnlyKnownPrefixParts(prefix, _boxVariants)) {
          onUnsupported?.call(token);
          continue;
        }
        final accum = prefix.isEmpty
            ? baseTransform
            : variantTransforms.putIfAbsent(prefix, _TransformAccum.new);
        _accumulateTransform(accum, base, config);
        continue;
      }

      // Accumulate border tokens
      if (_isBorderToken(base)) {
        if (!_hasOnlyKnownPrefixParts(prefix, _boxVariants)) {
          onUnsupported?.call(token);
          continue;
        }
        final accum = prefix.isEmpty
            ? baseBorder
            : variantBorders.putIfAbsent(prefix, _BorderAccum.new);
        _accumulateBorder(accum, base, config);
        continue;
      }

      // Apply atomic token
      styler = _applyBoxToken(styler, token);
    }

    // Apply accumulated gradient
    final gradientMix = baseGradient.toGradientMix();
    if (gradientMix != null) {
      styler = styler.gradient(gradientMix);
    }

    // Apply accumulated borders
    styler = _applyAccumulatedBorders(
      styler,
      baseBorder,
      variantBorders,
      variants: _boxVariants,
      newStyler: BoxStyler.new,
      merge: (a, b) => a.merge(b),
      applyBreakpoint: (b, bp, s) => b.onBreakpoint(bp, s),
      top: (s, {required color, required width}) =>
          s.borderTop(color: color, width: width),
      bottom: (s, {required color, required width}) =>
          s.borderBottom(color: color, width: width),
      left: (s, {required color, required width}) =>
          s.borderLeft(color: color, width: width),
      right: (s, {required color, required width}) =>
          s.borderRight(color: color, width: width),
    );

    // Apply accumulated transforms with identity-matrix rule
    return _applyAccumulatedTransforms(
      styler,
      baseTransform,
      variantTransforms,
      variants: _boxVariants,
      newStyler: BoxStyler.new,
      merge: (a, b) => a.merge(b),
      applyBreakpoint: (b, bp, s) => b.onBreakpoint(bp, s),
      setTransform: (s, m) => s.transform(m),
    );
  }

  TextStyler parseText(String classNames) {
    // Start with Tailwind Preflight default line-height of 1.5
    // This will be overridden by any text-* or leading-* classes
    var styler = TextStyler().height(_preflightLineHeight);
    for (final token in listTokens(classNames)) {
      styler = _applyTextToken(styler, token);
    }
    return styler;
  }

  /// Parses animation tokens from a pre-tokenized list.
  ///
  /// Returns null if:
  /// - No transition trigger token is present
  /// - transition-none is present (explicitly disables animation)
  ///
  /// When `transition` is present with no explicit modifiers, Tailwind defaults apply:
  /// - Duration: 150ms
  /// - Curve: Curves.easeOut
  /// - Delay: 0ms
  ///
  /// Use this method when you've already tokenized the class names to avoid
  /// redundant parsing.
  CurveAnimationConfig? parseAnimationFromTokens(List<String> tokens) {
    var hasTransition = false;
    var hasTransitionNone = false;
    var duration = const Duration(milliseconds: 150); // Tailwind default
    Curve curve = Curves.easeOut; // Tailwind default
    var delay = Duration.zero;

    for (final token in tokens) {
      final base = token.substring(token.lastIndexOf(':') + 1);

      // Transition triggers (all aliases map to same behavior)
      if (_transitionTriggerTokens.contains(base)) {
        hasTransition = true;
      }
      // Explicit disable
      else if (base == 'transition-none') {
        hasTransitionNone = true;
      }
      // Duration (last-wins via reassignment)
      else if (base.startsWith('duration-')) {
        final key = base.substring(9);
        final ms = config.durationOf(key);
        if (ms != null) {
          duration = Duration(milliseconds: ms);
        } else {
          onUnsupported?.call(token);
        }
      }
      // Ease (last-wins via reassignment)
      else if (_easeTokens.containsKey(base)) {
        curve = _easeTokens[base]!;
      }
      // Delay (last-wins via reassignment)
      else if (base.startsWith('delay-')) {
        final key = base.substring(6);
        final ms = config.delayOf(key);
        if (ms != null) {
          delay = Duration(milliseconds: ms);
        } else {
          onUnsupported?.call(token);
        }
      }
    }

    // transition-none disables everything
    if (hasTransitionNone) return null;

    // No trigger = no animation
    if (!hasTransition) return null;

    return CurveAnimationConfig(duration: duration, curve: curve, delay: delay);
  }

  /// Generic prefix handler that applies variant modifiers and breakpoints.
  /// This is the single source of truth for prefix handling logic.
  S _applyPrefixedToken<S>(
    S base,
    String token,
    Map<String, _VariantApplier<S>> variants,
    S Function() newStyler,
    S Function(S, String) applyAtomic,
    S Function(S, Breakpoint, S) applyBreakpoint,
  ) {
    final prefixIndex = token.indexOf(':');
    if (prefixIndex <= 0) {
      return applyAtomic(base, token);
    }

    final head = token.substring(0, prefixIndex);
    final tail = token.substring(prefixIndex + 1);

    // Handle breakpoints
    if (_isBreakpoint(head)) {
      final min = config.breakpointOf(head);
      final childStyler = _applyPrefixedToken(
        newStyler(),
        tail,
        variants,
        newStyler,
        applyAtomic,
        applyBreakpoint,
      );
      return applyBreakpoint(base, Breakpoint(minWidth: min), childStyler);
    }

    // Handle variant prefixes (hover, focus, dark, etc.)
    final variantFn = variants[head];
    if (variantFn != null) {
      final childStyler = _applyPrefixedToken(
        newStyler(),
        tail,
        variants,
        newStyler,
        applyAtomic,
        applyBreakpoint,
      );
      return variantFn(base, childStyler);
    }

    // Unknown prefix - pass through to atomic handler
    return applyAtomic(base, token);
  }

  FlexBoxStyler _applyFlexToken(FlexBoxStyler base, String token) =>
      _applyPrefixedToken(
        base,
        token,
        _flexVariants,
        FlexBoxStyler.new,
        _applyFlexAtomic,
        (b, bp, s) => b.onBreakpoint(bp, s),
      );

  BoxStyler _applyBoxToken(BoxStyler base, String token) => _applyPrefixedToken(
    base,
    token,
    _boxVariants,
    BoxStyler.new,
    _applyBoxAtomic,
    (b, bp, s) => b.onBreakpoint(bp, s),
  );

  TextStyler _applyTextToken(TextStyler base, String token) =>
      _applyPrefixedToken(
        base,
        token,
        _textVariants,
        TextStyler.new,
        _applyTextAtomic,
        (b, bp, s) => b.onBreakpoint(bp, s),
      );

  bool _isBreakpoint(String prefix) => config.breakpoints.containsKey(prefix);

  FlexBoxStyler _applyFlexAtomic(FlexBoxStyler styler, String token) {
    var result = styler;
    var handled = true;

    final atomicHandler = _flexAtomicHandlers[token];
    if (atomicHandler != null) {
      result = atomicHandler(styler);
    } else if (token.startsWith('gap-x-') || token.startsWith('gap-y-')) {
      // Directional gaps handled in widget layer.
    } else if (token.startsWith('gap-')) {
      result = styler.spacing(config.spaceOf(token.substring(4)));
    } else if (token.startsWith('w-')) {
      final key = token.substring(2);
      final fraction = parseFractionToken(key);
      if (fraction != null) {
        // Fractional sizing handled by widget layer.
      } else {
        final size = _sizeFrom(key);
        if (size != null) {
          result = styler.width(size);
        } else if (_isFullOrScreenKey(key)) {
          // Full and screen sizing handled by widget layer to avoid infinities.
        } else {
          handled = false;
        }
      }
    } else if (token.startsWith('h-')) {
      final key = token.substring(2);
      final fraction = parseFractionToken(key);
      if (fraction != null) {
        // Fractional sizing handled by widget layer.
      } else {
        final size = _sizeFrom(key);
        if (size != null) {
          result = styler.height(size);
        } else if (_isFullOrScreenKey(key)) {
          // Full and screen sizing handled by widget layer.
        } else {
          handled = false;
        }
      }
    } else if (token == 'min-w-0') {
      result = styler.minWidth(0);
    } else if (token == 'min-w-auto') {
      // Escape hatch for flex-1 auto min constraint - handled at widget layer
      result = styler;
    } else if (token == 'min-h-0') {
      result = styler.minHeight(0);
    } else if (token.startsWith('flex-') ||
        token.startsWith('basis-') ||
        token.startsWith('self-') ||
        token.startsWith('shrink')) {
      // Item-level utilities handled at the widget layer.
    } else if (_parseSpacingToken(token, config) case final spacing?) {
      result = _applySpacingToFlex(result, spacing);
    } else if (token.startsWith('bg-')) {
      final color = config.colorOf(token.substring(3));
      if (color != null) {
        result = styler.color(color);
      } else {
        handled = false;
      }
    } else if (_isBorderToken(token)) {
      // Border tokens are handled via grouped borders in parseFlex/parseBox.
      // We skip them here to avoid double-handling.
    } else if (token == 'rounded') {
      result = styler.borderRounded(config.radiusOf(''));
    } else if (_parseRadiusToken(token, config) case final radius?) {
      result = _applyRadiusToFlex(result, radius);
    } else if (token.startsWith('rounded-')) {
      final suffix = token.substring(8);
      result = styler.borderRounded(config.radiusOf(suffix));
    } else if (token.startsWith('text-')) {
      // Text color/size on FlexBox - propagates to child text widgets via DefaultTextStyle
      final color = config.colorOf(token.substring(5));
      if (color != null) {
        result = styler.wrapDefaultTextStyle(TextStyleMix().color(color));
      } else {
        final size = config.fontSizeOf(token.substring(5), fallback: -1);
        if (size > 0) {
          result = styler.wrapDefaultTextStyle(TextStyleMix().fontSize(size));
        } else {
          handled = false;
        }
      }
    } else if (_fontWeightTokens.containsKey(token)) {
      // Font weight on FlexBox - propagates to child text widgets via DefaultTextStyle
      result =
          styler.wrapDefaultTextStyle(TextStyleMix().fontWeight(_fontWeightTokens[token]!));
    } else if (_isAnimationToken(token)) {
      // Animation tokens handled by parseAnimationFromTokens(), don't report as unsupported
    } else if (_isTransformToken(token)) {
      // Transform tokens are applied via grouped transforms in parseBox/parseFlex.
      // We skip them here to avoid double-handling.
    } else {
      handled = false;
    }

    if (!handled) {
      onUnsupported?.call(token);
    }

    return result;
  }

  BoxStyler _applyBoxAtomic(BoxStyler styler, String token) {
    var result = styler;
    var handled = true;

    final exactHandler = _boxAtomicHandlers[token];

    if (exactHandler != null) {
      result = exactHandler(styler, config);
    } else if (token.startsWith('w-')) {
      final key = token.substring(2);
      final fraction = parseFractionToken(key);
      if (fraction != null) {
        // Fractional sizing handled by widget layer.
      } else {
        final size = _sizeFrom(key);
        if (size != null) {
          result = styler.width(size);
        } else if (_isFullOrScreenKey(key)) {
          // Full and screen sizing handled by widget layer.
        } else {
          handled = false;
        }
      }
    } else if (token.startsWith('h-')) {
      final key = token.substring(2);
      final fraction = parseFractionToken(key);
      if (fraction != null) {
        // Fractional sizing handled by widget layer.
      } else {
        final size = _sizeFrom(key);
        if (size != null) {
          result = styler.height(size);
        } else if (_isFullOrScreenKey(key)) {
          // Full and screen sizing handled by widget layer.
        } else {
          handled = false;
        }
      }
    } else if (token == 'min-w-0') {
      result = styler.minWidth(0);
    } else if (token == 'min-w-auto') {
      // Escape hatch for flex-1 auto min constraint - handled at widget layer
      result = styler;
    } else if (token == 'min-h-0') {
      result = styler.minHeight(0);
    } else if (token.startsWith('flex-') ||
        token.startsWith('basis-') ||
        token.startsWith('self-') ||
        token.startsWith('shrink')) {
      // Item-level utilities handled at the widget layer.
    } else if (_parseSpacingToken(token, config) case final spacing?) {
      result = _applySpacingToBox(result, spacing);
    } else if (token.startsWith('bg-')) {
      final color = config.colorOf(token.substring(3));
      if (color != null) {
        result = styler.color(color);
      } else {
        handled = false;
      }
    } else if (_isBorderToken(token)) {
      // Border tokens are handled via grouped borders in parseFlex/parseBox.
      // We skip them here to avoid double-handling.
    } else if (token == 'rounded') {
      result = styler.borderRounded(config.radiusOf(''));
    } else if (_parseRadiusToken(token, config) case final radius?) {
      result = _applyRadiusToBox(result, radius);
    } else if (token.startsWith('rounded-')) {
      final suffix = token.substring(8);
      result = styler.borderRounded(config.radiusOf(suffix));
    } else if (token.startsWith('text-')) {
      final color = config.colorOf(token.substring(5));
      if (color != null) {
        result = styler.wrapDefaultTextStyle(TextStyleMix().color(color));
      } else {
        final size = config.fontSizeOf(token.substring(5), fallback: -1);
        if (size > 0) {
          result = styler.wrapDefaultTextStyle(TextStyleMix().fontSize(size));
        } else {
          handled = false;
        }
      }
    } else if (_isAnimationToken(token)) {
      // Animation tokens handled by parseAnimationFromTokens(), don't report as unsupported
    } else if (_isTransformToken(token)) {
      // Transform tokens are applied via grouped transforms in parseBox/parseFlex.
      // We skip them here to avoid double-handling.
    } else {
      handled = false;
    }

    if (!handled) {
      onUnsupported?.call(token);
    }

    return result;
  }

  TextStyler _applyTextAtomic(TextStyler styler, String token) {
    var result = styler;
    var handled = true;

    final exactHandler = _textAtomicHandlers[token];

    if (exactHandler != null) {
      result = exactHandler(styler);
    } else if (token.startsWith('text-')) {
      final key = token.substring(5);
      final color = config.colorOf(key);
      if (color != null) {
        result = styler.color(color);
      } else {
        final size = config.fontSizeOf(key, fallback: -1);
        if (size > 0) {
          result = styler.fontSize(size);
          // Apply Tailwind's default line heights for text-* sizes
          final lineHeight = _tailwindLineHeights[key];
          if (lineHeight != null) {
            result = result.height(lineHeight);
          }
        } else {
          handled = false;
        }
      }
    } else if (_isAnimationToken(token)) {
      // Animation tokens handled by parseAnimationFromTokens(), don't report as unsupported
    } else {
      handled = false;
    }

    if (!handled) {
      onUnsupported?.call(token);
    }

    return result;
  }

  double? _sizeFrom(String key) {
    final value = config.spaceOf(key, fallback: double.nan);
    return value.isNaN ? null : value;
  }
}

bool _isFullOrScreenKey(String key) => key == 'full' || key == 'screen';
