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

const Map<String, ElevationShadow> _shadowElevationTokens = {
  'shadow-sm': ElevationShadow.one,
  'shadow': ElevationShadow.two,
  'shadow-md': ElevationShadow.three,
  'shadow-lg': ElevationShadow.six,
  'shadow-xl': ElevationShadow.nine,
  'shadow-2xl': ElevationShadow.twelve,
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

/// Valid Tailwind duration keys (matches TwConfig._standard.durations).
const Set<String> _validDurationKeys = {
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

/// Valid Tailwind delay keys (matches TwConfig._standard.delays).
const Set<String> _validDelayKeys = {
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

/// Groups transform tokens by their prefix chain.
class _PrefixedTransforms {
  final _TransformAccum base = _TransformAccum();
  final Map<String, _TransformAccum> variants = {};

  _TransformAccum forPrefix(String prefix) {
    if (prefix.isEmpty) return base;
    return variants.putIfAbsent(prefix, _TransformAccum.new);
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

/// Groups border tokens by their prefix chain.
class _PrefixedBorders {
  final _BorderAccum base = _BorderAccum();
  final Map<String, _BorderAccum> variants = {};

  _BorderAccum forPrefix(String prefix) {
    if (prefix.isEmpty) return base;
    return variants.putIfAbsent(prefix, _BorderAccum.new);
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

/// Parsed spacing token with kind and value.
class _SpacingToken {
  const _SpacingToken(this.kind, this.value);
  final _SpacingKind kind;
  final double value;
}

/// Parses padding/margin tokens, returns null if not a spacing token.
_SpacingToken? _parseSpacingToken(String token, TwConfig config) {
  if (token.startsWith('px-')) {
    return _SpacingToken(
      _SpacingKind.paddingX,
      config.spaceOf(token.substring(3)),
    );
  }
  if (token.startsWith('py-')) {
    return _SpacingToken(
      _SpacingKind.paddingY,
      config.spaceOf(token.substring(3)),
    );
  }
  if (token.startsWith('pt-')) {
    return _SpacingToken(
      _SpacingKind.paddingTop,
      config.spaceOf(token.substring(3)),
    );
  }
  if (token.startsWith('pr-')) {
    return _SpacingToken(
      _SpacingKind.paddingRight,
      config.spaceOf(token.substring(3)),
    );
  }
  if (token.startsWith('pb-')) {
    return _SpacingToken(
      _SpacingKind.paddingBottom,
      config.spaceOf(token.substring(3)),
    );
  }
  if (token.startsWith('pl-')) {
    return _SpacingToken(
      _SpacingKind.paddingLeft,
      config.spaceOf(token.substring(3)),
    );
  }
  if (token.startsWith('p-')) {
    return _SpacingToken(
      _SpacingKind.paddingAll,
      config.spaceOf(token.substring(2)),
    );
  }
  if (token.startsWith('mx-')) {
    return _SpacingToken(
      _SpacingKind.marginX,
      config.spaceOf(token.substring(3)),
    );
  }
  if (token.startsWith('my-')) {
    return _SpacingToken(
      _SpacingKind.marginY,
      config.spaceOf(token.substring(3)),
    );
  }
  if (token.startsWith('mt-')) {
    return _SpacingToken(
      _SpacingKind.marginTop,
      config.spaceOf(token.substring(3)),
    );
  }
  if (token.startsWith('mr-')) {
    return _SpacingToken(
      _SpacingKind.marginRight,
      config.spaceOf(token.substring(3)),
    );
  }
  if (token.startsWith('mb-')) {
    return _SpacingToken(
      _SpacingKind.marginBottom,
      config.spaceOf(token.substring(3)),
    );
  }
  if (token.startsWith('ml-')) {
    return _SpacingToken(
      _SpacingKind.marginLeft,
      config.spaceOf(token.substring(3)),
    );
  }
  if (token.startsWith('m-')) {
    return _SpacingToken(
      _SpacingKind.marginAll,
      config.spaceOf(token.substring(2)),
    );
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
    return _validDurationKeys.contains(token.substring(9));
  }
  if (token.startsWith('delay-')) {
    return _validDelayKeys.contains(token.substring(6));
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
  // Use CrossAxisAlignment.start to achieve left-aligned content visually matching CSS.
  // Note: CSS default is stretch, but Flutter's stretch requires bounded constraints
  // and causes infinite height errors in unbounded contexts. Using start provides
  // consistent left-aligned content without layout errors.
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
      'border': (s, cfg) =>
          s.borderAll(color: _defaultBorderColor(cfg), width: 1),
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
      'font-thin': (s, _) =>
          s.wrapDefaultTextStyle(TextStyleMix().fontWeight(FontWeight.w100)),
      'font-extralight': (s, _) =>
          s.wrapDefaultTextStyle(TextStyleMix().fontWeight(FontWeight.w200)),
      'font-light': (s, _) =>
          s.wrapDefaultTextStyle(TextStyleMix().fontWeight(FontWeight.w300)),
      'font-normal': (s, _) =>
          s.wrapDefaultTextStyle(TextStyleMix().fontWeight(FontWeight.w400)),
      'font-medium': (s, _) =>
          s.wrapDefaultTextStyle(TextStyleMix().fontWeight(FontWeight.w500)),
      'font-semibold': (s, _) =>
          s.wrapDefaultTextStyle(TextStyleMix().fontWeight(FontWeight.w600)),
      'font-bold': (s, _) =>
          s.wrapDefaultTextStyle(TextStyleMix().fontWeight(FontWeight.w700)),
      'font-extrabold': (s, _) =>
          s.wrapDefaultTextStyle(TextStyleMix().fontWeight(FontWeight.w800)),
      'font-black': (s, _) =>
          s.wrapDefaultTextStyle(TextStyleMix().fontWeight(FontWeight.w900)),
    };

final Map<String, TextStyler Function(TextStyler)> _textAtomicHandlers = {
  'uppercase': (s) => s.uppercase(),
  'lowercase': (s) => s.lowercase(),
  'capitalize': (s) => s.capitalize(),
  // Font weights (complete Tailwind set)
  'font-thin': (s) => s.fontWeight(FontWeight.w100),
  'font-extralight': (s) => s.fontWeight(FontWeight.w200),
  'font-light': (s) => s.fontWeight(FontWeight.w300),
  'font-normal': (s) => s.fontWeight(FontWeight.w400),
  'font-medium': (s) => s.fontWeight(FontWeight.w500),
  'font-semibold': (s) => s.fontWeight(FontWeight.w600),
  'font-bold': (s) => s.fontWeight(FontWeight.w700),
  'font-extrabold': (s) => s.fontWeight(FontWeight.w800),
  'font-black': (s) => s.fontWeight(FontWeight.w900),
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
        TextHeightBehaviorMix(
          leadingDistribution: TextLeadingDistribution.even,
        ),
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

/// Variant maps for each styler type - single source of truth for prefix handling.
final _flexVariants = <String, _VariantApplier<FlexBoxStyler>>{
  'hover': (base, variant) => base.onHovered(variant),
  'focus': (base, variant) => base.onFocused(variant),
  'active': (base, variant) => base.onPressed(variant),
  'pressed': (base, variant) => base.onPressed(variant),
  'disabled': (base, variant) => base.onDisabled(variant),
  'enabled': (base, variant) => base.onEnabled(variant),
  'dark': (base, variant) => base.onDark(variant),
  'light': (base, variant) => base.onLight(variant),
};

final _boxVariants = <String, _VariantApplier<BoxStyler>>{
  'hover': (base, variant) => base.onHovered(variant),
  'focus': (base, variant) => base.onFocused(variant),
  'active': (base, variant) => base.onPressed(variant),
  'pressed': (base, variant) => base.onPressed(variant),
  'disabled': (base, variant) => base.onDisabled(variant),
  'enabled': (base, variant) => base.onEnabled(variant),
  'dark': (base, variant) => base.onDark(variant),
  'light': (base, variant) => base.onLight(variant),
};

final _textVariants = <String, _VariantApplier<TextStyler>>{
  'hover': (base, variant) => base.onHovered(variant),
  'focus': (base, variant) => base.onFocused(variant),
  'active': (base, variant) => base.onPressed(variant),
  'pressed': (base, variant) => base.onPressed(variant),
  'disabled': (base, variant) => base.onDisabled(variant),
  'enabled': (base, variant) => base.onEnabled(variant),
  'dark': (base, variant) => base.onDark(variant),
  'light': (base, variant) => base.onLight(variant),
};

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

  bool _hasOnlyKnownPrefixParts(String prefix, Set<String> allowedVariants) {
    if (prefix.isEmpty) return true;
    for (final part in prefix.split(':')) {
      if (_isBreakpoint(part)) continue;
      if (allowedVariants.contains(part)) continue;
      return false;
    }
    return true;
  }

  /// Groups transform tokens by prefix for variant-aware application.
  _PrefixedTransforms _groupTransformsByPrefix(
    List<String> tokens,
    Set<String> allowedVariants,
  ) {
    final result = _PrefixedTransforms();

    for (final token in tokens) {
      final colonIndex = token.lastIndexOf(':');
      final prefix = colonIndex > 0 ? token.substring(0, colonIndex) : '';
      final base = colonIndex > 0 ? token.substring(colonIndex + 1) : token;

      if (!_isTransformToken(base)) continue;
      if (!_hasOnlyKnownPrefixParts(prefix, allowedVariants)) {
        onUnsupported?.call(token);
        continue;
      }

      final accum = result.forPrefix(prefix);

      if (base.startsWith('scale-')) {
        accum.scale = config.scaleOf(base.substring(6));
      } else if (base.startsWith('-rotate-')) {
        final deg = config.rotationOf(base.substring(8));
        if (deg != null) accum.rotateDeg = -deg;
      } else if (base.startsWith('rotate-')) {
        accum.rotateDeg = config.rotationOf(base.substring(7));
      } else if (base.startsWith('-translate-x-')) {
        accum.translateX = -config.spaceOf(base.substring(13));
      } else if (base.startsWith('translate-x-')) {
        accum.translateX = config.spaceOf(base.substring(12));
      } else if (base.startsWith('-translate-y-')) {
        accum.translateY = -config.spaceOf(base.substring(13));
      } else if (base.startsWith('translate-y-')) {
        accum.translateY = config.spaceOf(base.substring(12));
      }
    }

    return result;
  }

  /// Applies a transform via variant chain (e.g., 'md:hover' -> onBreakpoint(md, onHovered(...))).
  BoxStyler _applyTransformWithVariant(
    BoxStyler base,
    String prefix,
    Matrix4 matrix,
  ) {
    if (prefix.isEmpty) {
      return base.transform(matrix);
    }

    final parts = prefix.split(':');
    BoxStyler variantStyle = BoxStyler().transform(matrix);

    for (var i = parts.length - 1; i >= 0; i--) {
      final part = parts[i];
      if (_isBreakpoint(part)) {
        final min = config.breakpointOf(part);
        variantStyle = BoxStyler().onBreakpoint(
          Breakpoint(minWidth: min),
          variantStyle,
        );
      } else if (_boxVariants.containsKey(part)) {
        variantStyle = _boxVariants[part]!(BoxStyler(), variantStyle);
      }
    }

    return base.merge(variantStyle);
  }

  /// Applies grouped transforms to BoxStyler with variant awareness.
  BoxStyler _applyTransformsToStyler(
    BoxStyler styler,
    _PrefixedTransforms transforms,
  ) {
    var result = styler;

    if (transforms.base.hasAnyTransform) {
      result = result.transform(transforms.base.toMatrix4());
    } else if (transforms.variants.isNotEmpty) {
      // Provide identity so animations can interpolate from a non-null matrix.
      result = result.transform(Matrix4.identity());
    }

    for (final entry in transforms.variants.entries) {
      final inherited = entry.value.inheritFrom(transforms.base);
      if (!inherited.hasAnyTransform) continue;
      result = _applyTransformWithVariant(
        result,
        entry.key,
        inherited.toMatrix4(),
      );
    }

    return result;
  }

  /// Applies a transform with variant handling for FlexBoxStyler.
  FlexBoxStyler _applyFlexTransformWithVariant(
    FlexBoxStyler base,
    String prefix,
    Matrix4 matrix,
  ) {
    if (prefix.isEmpty) {
      return base.transform(matrix);
    }

    final parts = prefix.split(':');
    FlexBoxStyler variantStyle = FlexBoxStyler().transform(matrix);

    for (var i = parts.length - 1; i >= 0; i--) {
      final part = parts[i];
      if (_isBreakpoint(part)) {
        final min = config.breakpointOf(part);
        variantStyle = FlexBoxStyler().onBreakpoint(
          Breakpoint(minWidth: min),
          variantStyle,
        );
      } else if (_flexVariants.containsKey(part)) {
        variantStyle = _flexVariants[part]!(FlexBoxStyler(), variantStyle);
      }
    }

    return base.merge(variantStyle);
  }

  /// Applies grouped transforms to FlexBoxStyler with variant awareness.
  FlexBoxStyler _applyTransformsToFlexStyler(
    FlexBoxStyler styler,
    _PrefixedTransforms transforms,
  ) {
    var result = styler;

    if (transforms.base.hasAnyTransform) {
      result = result.transform(transforms.base.toMatrix4());
    } else if (transforms.variants.isNotEmpty) {
      result = result.transform(Matrix4.identity());
    }

    for (final entry in transforms.variants.entries) {
      final inherited = entry.value.inheritFrom(transforms.base);
      if (!inherited.hasAnyTransform) continue;
      result = _applyFlexTransformWithVariant(
        result,
        entry.key,
        inherited.toMatrix4(),
      );
    }

    return result;
  }

  // ---------------------------------------------------------------------------
  // Border accumulation helpers
  // ---------------------------------------------------------------------------

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

  /// Groups border tokens by prefix for variant-aware application.
  _PrefixedBorders _groupBordersByPrefix(
    List<String> tokens,
    Set<String> allowedVariants,
  ) {
    final result = _PrefixedBorders();

    for (final token in tokens) {
      final colonIndex = token.lastIndexOf(':');
      final prefix = colonIndex > 0 ? token.substring(0, colonIndex) : '';
      final base = colonIndex > 0 ? token.substring(colonIndex + 1) : token;

      if (!_isBorderToken(base)) continue;
      if (!_hasOnlyKnownPrefixParts(prefix, allowedVariants)) {
        onUnsupported?.call(token);
        continue;
      }

      final accum = result.forPrefix(prefix);

      // Handle color-only tokens
      if (_isBorderColorOnlyToken(base)) {
        final key = base.substring(7);
        accum.color = config.colorOf(key);
        continue;
      }

      // Handle 'border' (all sides, width 1)
      if (base == 'border') {
        accum.setAll(1.0);
        continue;
      }

      // Handle width-only tokens (border-2, border-4, etc.)
      final widthKey = base.substring(7);
      final widthOnly = config.borderWidthOf(widthKey, fallback: -1);
      if (widthOnly > 0) {
        accum.setAll(widthOnly);
        continue;
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

    return result;
  }

  /// Applies accumulated borders to FlexBoxStyler.
  FlexBoxStyler _applyBordersToFlexStyler(
    FlexBoxStyler styler,
    _PrefixedBorders borders,
  ) {
    var result = styler;

    // Apply base borders
    if (borders.base.hasStructure) {
      final color = borders.base.color ?? _defaultBorderColor(config);
      if (borders.base.topWidth != null) {
        result = result.borderTop(color: color, width: borders.base.topWidth!);
      }
      if (borders.base.bottomWidth != null) {
        result =
            result.borderBottom(color: color, width: borders.base.bottomWidth!);
      }
      if (borders.base.leftWidth != null) {
        result =
            result.borderLeft(color: color, width: borders.base.leftWidth!);
      }
      if (borders.base.rightWidth != null) {
        result =
            result.borderRight(color: color, width: borders.base.rightWidth!);
      }
    }

    // Apply variant borders
    for (final entry in borders.variants.entries) {
      final inherited = entry.value.inheritFrom(borders.base);
      if (!inherited.hasStructure) continue;
      result = _applyFlexBorderWithVariant(result, entry.key, inherited);
    }

    return result;
  }

  /// Applies a border with variant handling for FlexBoxStyler.
  FlexBoxStyler _applyFlexBorderWithVariant(
    FlexBoxStyler base,
    String prefix,
    _BorderAccum border,
  ) {
    final color = border.color ?? _defaultBorderColor(config);
    var variantStyle = FlexBoxStyler();

    if (border.topWidth != null) {
      variantStyle = variantStyle.borderTop(color: color, width: border.topWidth!);
    }
    if (border.bottomWidth != null) {
      variantStyle = variantStyle.borderBottom(color: color, width: border.bottomWidth!);
    }
    if (border.leftWidth != null) {
      variantStyle = variantStyle.borderLeft(color: color, width: border.leftWidth!);
    }
    if (border.rightWidth != null) {
      variantStyle = variantStyle.borderRight(color: color, width: border.rightWidth!);
    }

    if (prefix.isEmpty) {
      return base.merge(variantStyle);
    }

    final parts = prefix.split(':');
    for (var i = parts.length - 1; i >= 0; i--) {
      final part = parts[i];
      if (_isBreakpoint(part)) {
        final min = config.breakpointOf(part);
        variantStyle = FlexBoxStyler().onBreakpoint(
          Breakpoint(minWidth: min),
          variantStyle,
        );
      } else if (_flexVariants.containsKey(part)) {
        variantStyle = _flexVariants[part]!(FlexBoxStyler(), variantStyle);
      }
    }

    return base.merge(variantStyle);
  }

  /// Applies accumulated borders to BoxStyler.
  BoxStyler _applyBordersToBoxStyler(
    BoxStyler styler,
    _PrefixedBorders borders,
  ) {
    var result = styler;

    // Apply base borders
    if (borders.base.hasStructure) {
      final color = borders.base.color ?? _defaultBorderColor(config);
      if (borders.base.topWidth != null) {
        result = result.borderTop(color: color, width: borders.base.topWidth!);
      }
      if (borders.base.bottomWidth != null) {
        result =
            result.borderBottom(color: color, width: borders.base.bottomWidth!);
      }
      if (borders.base.leftWidth != null) {
        result =
            result.borderLeft(color: color, width: borders.base.leftWidth!);
      }
      if (borders.base.rightWidth != null) {
        result =
            result.borderRight(color: color, width: borders.base.rightWidth!);
      }
    }

    // Apply variant borders
    for (final entry in borders.variants.entries) {
      final inherited = entry.value.inheritFrom(borders.base);
      if (!inherited.hasStructure) continue;
      result = _applyBoxBorderWithVariant(result, entry.key, inherited);
    }

    return result;
  }

  /// Applies a border with variant handling for BoxStyler.
  BoxStyler _applyBoxBorderWithVariant(
    BoxStyler base,
    String prefix,
    _BorderAccum border,
  ) {
    final color = border.color ?? _defaultBorderColor(config);
    var variantStyle = BoxStyler();

    if (border.topWidth != null) {
      variantStyle = variantStyle.borderTop(color: color, width: border.topWidth!);
    }
    if (border.bottomWidth != null) {
      variantStyle = variantStyle.borderBottom(color: color, width: border.bottomWidth!);
    }
    if (border.leftWidth != null) {
      variantStyle = variantStyle.borderLeft(color: color, width: border.leftWidth!);
    }
    if (border.rightWidth != null) {
      variantStyle = variantStyle.borderRight(color: color, width: border.rightWidth!);
    }

    if (prefix.isEmpty) {
      return base.merge(variantStyle);
    }

    final parts = prefix.split(':');
    for (var i = parts.length - 1; i >= 0; i--) {
      final part = parts[i];
      if (_isBreakpoint(part)) {
        final min = config.breakpointOf(part);
        variantStyle = BoxStyler().onBreakpoint(
          Breakpoint(minWidth: min),
          variantStyle,
        );
      } else if (_boxVariants.containsKey(part)) {
        variantStyle = _boxVariants[part]!(BoxStyler(), variantStyle);
      }
    }

    return base.merge(variantStyle);
  }

  FlexBoxStyler parseFlex(String classNames) {
    final tokens = listTokens(classNames);

    // Check for base (non-prefixed) flex direction tokens
    // If only prefixed tokens (md:flex), default to column (block-like)
    final hasBaseFlex = tokens.any((t) {
      if (t.contains(':')) return false;
      return t == 'flex' || t == 'flex-row' || t == 'flex-col';
    });

    // Default to column (vertical, block-like) when only prefixed flex
    // This matches Tailwind: below breakpoint = block, at breakpoint = flex
    var styler = hasBaseFlex ? FlexBoxStyler() : FlexBoxStyler().column();

    final allowedVariants = _flexVariants.keys.toSet();

    final transformGroups = _groupTransformsByPrefix(tokens, allowedVariants);
    final borderGroups = _groupBordersByPrefix(tokens, allowedVariants);

    for (final token in tokens) {
      final base = token.substring(token.lastIndexOf(':') + 1);
      // Skip tokens handled by grouped application
      if (_isTransformToken(base)) continue;
      if (_isBorderToken(base)) continue;
      styler = _applyFlexToken(styler, token);
    }

    styler = _applyBordersToFlexStyler(styler, borderGroups);
    return _applyTransformsToFlexStyler(styler, transformGroups);
  }

  BoxStyler parseBox(String classNames) {
    final tokens = listTokens(classNames);
    var styler = BoxStyler();

    final allowedVariants = _boxVariants.keys.toSet();

    final transformGroups = _groupTransformsByPrefix(tokens, allowedVariants);
    final borderGroups = _groupBordersByPrefix(tokens, allowedVariants);

    for (final token in tokens) {
      final base = token.substring(token.lastIndexOf(':') + 1);
      // Skip tokens handled by grouped application
      if (_isTransformToken(base)) continue;
      if (_isBorderToken(base)) continue;
      styler = _applyBoxToken(styler, token);
    }

    styler = _applyBordersToBoxStyler(styler, borderGroups);
    return _applyTransformsToStyler(styler, transformGroups);
  }

  TextStyler parseText(String classNames) {
    var styler = TextStyler();
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

  /// Parses animation tokens and returns CurveAnimationConfig or null.
  ///
  /// @deprecated Use [parseAnimationFromTokens] with pre-tokenized input to
  /// avoid redundant parsing when tokens are already available.
  @Deprecated('Use parseAnimationFromTokens with pre-tokenized list')
  CurveAnimationConfig? parseAnimation(String classNames) =>
      parseAnimationFromTokens(listTokens(classNames));

  /// Parses transform tokens and returns a composite Matrix4.
  ///
  /// @deprecated Use [parseBox] or [parseFlex] which now handle transforms with
  /// full variant support.
  @Deprecated(
    'Transforms are now handled by parseBox/parseFlex with variant support',
  )
  ///
  /// Tailwind CSS applies transforms in a fixed order regardless of class order:
  /// translate → rotate → scale
  ///
  /// This method extracts all transform values and builds a single matrix
  /// following that order to match Tailwind's behavior exactly.
  ///
  /// Returns null if no transform tokens are present.
  Matrix4? parseTransform(String classNames) {
    final tokens = listTokens(classNames);

    double? scale;
    double? rotateDeg;
    double? translateX;
    double? translateY;

    for (final token in tokens) {
      // Strip any prefix (hover:, md:, etc.) to get base token
      final base = token.substring(token.lastIndexOf(':') + 1);

      if (base.startsWith('scale-')) {
        scale = config.scaleOf(base.substring(6));
      } else if (base.startsWith('-rotate-')) {
        final deg = config.rotationOf(base.substring(8));
        if (deg != null) rotateDeg = -deg;
      } else if (base.startsWith('rotate-')) {
        rotateDeg = config.rotationOf(base.substring(7));
      } else if (base.startsWith('-translate-x-')) {
        final px = config.spaceOf(base.substring(13));
        translateX = -px;
      } else if (base.startsWith('translate-x-')) {
        translateX = config.spaceOf(base.substring(12));
      } else if (base.startsWith('-translate-y-')) {
        final px = config.spaceOf(base.substring(13));
        translateY = -px;
      } else if (base.startsWith('translate-y-')) {
        translateY = config.spaceOf(base.substring(12));
      }
    }

    // No transform tokens found
    if (scale == null &&
        rotateDeg == null &&
        translateX == null &&
        translateY == null) {
      return null;
    }

    // Build matrix in Tailwind's fixed order: translate → rotate → scale
    var matrix = Matrix4.identity();

    if (translateX != null || translateY != null) {
      matrix = matrix.multiplied(
        Matrix4.translationValues(translateX ?? 0.0, translateY ?? 0.0, 0.0),
      );
    }

    if (rotateDeg != null) {
      matrix = matrix.multiplied(Matrix4.rotationZ(rotateDeg * math.pi / 180));
    }

    if (scale != null) {
      matrix = matrix.multiplied(Matrix4.diagonal3Values(scale, scale, 1.0));
    }

    return matrix;
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
    } else if (_isAnimationToken(token)) {
      // Animation tokens handled by parseAnimation(), don't report as unsupported
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
      // Animation tokens handled by parseAnimation(), don't report as unsupported
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
          // Note: Line height is not auto-applied with text-* because Flutter and
          // browser text rendering differ fundamentally. Even with TextLeadingDistribution.even,
          // the visual positioning differs. Use leading-* tokens explicitly when needed.
        } else {
          handled = false;
        }
      }
    } else if (_isAnimationToken(token)) {
      // Animation tokens handled by parseAnimation(), don't report as unsupported
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
