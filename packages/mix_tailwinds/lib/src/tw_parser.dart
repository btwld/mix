import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'tw_config.dart';
import 'tw_utils.dart';

typedef Warn = void Function(String token);

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
  'items-baseline': (s) => s.crossAxisAlignment(CrossAxisAlignment.baseline),
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

final Map<String, BoxStyler Function(BoxStyler, TwConfig)> _boxAtomicHandlers = {
  'border': (s, cfg) => s.borderAll(color: _defaultBorderColor(cfg), width: 1),
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
  'truncate': (s) => s.overflow(TextOverflow.ellipsis).maxLines(1),
  // Line height (leading-*)
  'leading-none': (s) => s.height(1.0),
  'leading-tight': (s) => s.height(1.25),
  'leading-snug': (s) => s.height(1.375),
  'leading-normal': (s) => s.height(1.5),
  'leading-relaxed': (s) => s.height(1.625),
  'leading-loose': (s) => s.height(2.0),
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

BoxStyler? _applyDirectionalBorder(
  BoxStyler styler,
  TwConfig config,
  String token,
) {
  final directive = _parseBorderDirective(config, token);
  if (directive == null) {
    return null;
  }

  switch (directive.direction) {
    case 't':
      return styler.borderTop(color: directive.color, width: directive.width);
    case 'b':
      return styler.borderBottom(
        color: directive.color,
        width: directive.width,
      );
    case 'l':
      return styler.borderLeft(color: directive.color, width: directive.width);
    case 'r':
      return styler.borderRight(color: directive.color, width: directive.width);
    case 'x':
      return styler.borderVertical(
        color: directive.color,
        width: directive.width,
      );
    case 'y':
      return styler.borderHorizontal(
        color: directive.color,
        width: directive.width,
      );
    default:
      return null;
  }
}

FlexBoxStyler? _applyFlexDirectionalBorder(
  FlexBoxStyler styler,
  TwConfig config,
  String token,
) {
  final directive = _parseBorderDirective(config, token);
  if (directive == null) {
    return null;
  }

  switch (directive.direction) {
    case 't':
      return styler.borderTop(color: directive.color, width: directive.width);
    case 'b':
      return styler.borderBottom(
        color: directive.color,
        width: directive.width,
      );
    case 'l':
      return styler.borderLeft(color: directive.color, width: directive.width);
    case 'r':
      return styler.borderRight(color: directive.color, width: directive.width);
    case 'x':
      return styler.borderVertical(
        color: directive.color,
        width: directive.width,
      );
    case 'y':
      return styler.borderHorizontal(
        color: directive.color,
        width: directive.width,
      );
    default:
      return null;
  }
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

BoxStyler? _applyDirectionalRadius(
  BoxStyler styler,
  TwConfig config,
  String token,
) {
  final directive = _parseRadiusDirective(config, token);
  if (directive == null) {
    return null;
  }

  switch (directive.direction) {
    case 't':
      return styler.borderRoundedTop(directive.radius);
    case 'b':
      return styler.borderRoundedBottom(directive.radius);
    case 'l':
      return styler.borderRoundedLeft(directive.radius);
    case 'r':
      return styler.borderRoundedRight(directive.radius);
    case 'tl':
      return styler.borderRoundedTopLeft(directive.radius);
    case 'tr':
      return styler.borderRoundedTopRight(directive.radius);
    case 'bl':
      return styler.borderRoundedBottomLeft(directive.radius);
    case 'br':
      return styler.borderRoundedBottomRight(directive.radius);
    default:
      return null;
  }
}

FlexBoxStyler? _applyFlexDirectionalRadius(
  FlexBoxStyler styler,
  TwConfig config,
  String token,
) {
  final directive = _parseRadiusDirective(config, token);
  if (directive == null) {
    return null;
  }

  switch (directive.direction) {
    case 't':
      return styler.borderRoundedTop(directive.radius);
    case 'b':
      return styler.borderRoundedBottom(directive.radius);
    case 'l':
      return styler.borderRoundedLeft(directive.radius);
    case 'r':
      return styler.borderRoundedRight(directive.radius);
    case 'tl':
      return styler.borderRoundedTopLeft(directive.radius);
    case 'tr':
      return styler.borderRoundedTopRight(directive.radius);
    case 'bl':
      return styler.borderRoundedBottomLeft(directive.radius);
    case 'br':
      return styler.borderRoundedBottomRight(directive.radius);
    default:
      return null;
  }
}

/// Parses Tailwind-like class strings into Mix stylers.
class TwParser {
  TwParser({TwConfig? config, this.onUnsupported})
    : config = config ?? TwConfig.standard();

  final TwConfig config;
  final Warn? onUnsupported;

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

    for (final token in tokens) {
      styler = _applyFlexToken(styler, token);
    }
    return styler;
  }

  BoxStyler parseBox(String classNames) {
    var styler = BoxStyler();
    for (final token in listTokens(classNames)) {
      styler = _applyBoxToken(styler, token);
    }
    return styler;
  }

  TextStyler parseText(String classNames) {
    var styler = TextStyler();
    for (final token in listTokens(classNames)) {
      styler = _applyTextToken(styler, token);
    }
    return styler;
  }

  /// Parses animation tokens and returns CurveAnimationConfig or null.
  ///
  /// Returns null if:
  /// - No transition trigger token is present
  /// - transition-none is present (explicitly disables animation)
  ///
  /// When `transition` is present with no explicit modifiers, Tailwind defaults apply:
  /// - Duration: 150ms
  /// - Curve: Curves.easeOut
  /// - Delay: 0ms
  CurveAnimationConfig? parseAnimation(String classNames) {
    final tokens = listTokens(classNames);

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

    return CurveAnimationConfig(
      duration: duration,
      curve: curve,
      delay: delay,
    );
  }

  /// Parses transform tokens and returns a composite Matrix4.
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

  BoxStyler _applyBoxToken(BoxStyler base, String token) =>
      _applyPrefixedToken(
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
    } else if (token == 'min-h-0') {
      result = styler.minHeight(0);
    } else if (token.startsWith('flex-') ||
        token.startsWith('basis-') ||
        token.startsWith('self-') ||
        token.startsWith('shrink')) {
      // Item-level utilities handled at the widget layer.
    } else if (token.startsWith('px-')) {
      result = styler.paddingX(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('py-')) {
      result = styler.paddingY(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('pt-')) {
      result = styler.paddingTop(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('pr-')) {
      result = styler.paddingRight(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('pb-')) {
      result = styler.paddingBottom(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('pl-')) {
      result = styler.paddingLeft(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('p-')) {
      result = styler.paddingAll(config.spaceOf(token.substring(2)));
    } else if (token.startsWith('mx-')) {
      result = styler.marginX(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('my-')) {
      result = styler.marginY(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('mt-')) {
      result = styler.marginTop(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('mr-')) {
      result = styler.marginRight(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('mb-')) {
      result = styler.marginBottom(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('ml-')) {
      result = styler.marginLeft(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('m-')) {
      result = styler.marginAll(config.spaceOf(token.substring(2)));
    } else if (token.startsWith('bg-')) {
      final color = config.colorOf(token.substring(3));
      if (color != null) {
        result = styler.color(color);
      } else {
        handled = false;
      }
    } else if (_applyFlexDirectionalBorder(styler, config, token)
        case final borderResult?) {
      result = borderResult;
    } else if (token == 'border') {
      result = styler.borderAll(color: _defaultBorderColor(config), width: 1);
    } else if (token.startsWith('border-')) {
      final key = token.substring(7);
      final width = config.borderWidthOf(key, fallback: -1);
      if (width > 0) {
        result = styler.borderAll(
          color: _defaultBorderColor(config),
          width: width,
        );
      } else {
        final color = config.colorOf(key);
        if (color != null) {
          result = styler.borderAll(color: color, width: 1);
        } else {
          handled = false;
        }
      }
    } else if (token == 'rounded') {
      result = styler.borderRounded(config.radiusOf(''));
    } else if (_applyFlexDirectionalRadius(styler, config, token)
        case final radiusResult?) {
      result = radiusResult;
    } else if (token.startsWith('rounded-')) {
      final suffix = token.substring(8);
      result = styler.borderRounded(config.radiusOf(suffix));
    } else if (_isAnimationToken(token)) {
      // Animation tokens handled by parseAnimation(), don't report as unsupported
    } else if (_isTransformToken(token)) {
      // Transform tokens handled by parseTransform(), don't report as unsupported
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
    } else if (token == 'min-h-0') {
      result = styler.minHeight(0);
    } else if (token.startsWith('flex-') ||
        token.startsWith('basis-') ||
        token.startsWith('self-') ||
        token.startsWith('shrink')) {
      // Item-level utilities handled at the widget layer.
    } else if (token.startsWith('px-')) {
      result = styler.paddingX(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('py-')) {
      result = styler.paddingY(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('pt-')) {
      result = styler.paddingTop(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('pr-')) {
      result = styler.paddingRight(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('pb-')) {
      result = styler.paddingBottom(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('pl-')) {
      result = styler.paddingLeft(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('p-')) {
      result = styler.paddingAll(config.spaceOf(token.substring(2)));
    } else if (token.startsWith('mx-')) {
      result = styler.marginX(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('my-')) {
      result = styler.marginY(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('mt-')) {
      result = styler.marginTop(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('mr-')) {
      result = styler.marginRight(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('mb-')) {
      result = styler.marginBottom(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('ml-')) {
      result = styler.marginLeft(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('m-')) {
      result = styler.marginAll(config.spaceOf(token.substring(2)));
    } else if (token.startsWith('bg-')) {
      final color = config.colorOf(token.substring(3));
      if (color != null) {
        result = styler.color(color);
      } else {
        handled = false;
      }
    } else if (_applyDirectionalBorder(styler, config, token)
        case final borderResult?) {
      result = borderResult;
    } else if (token.startsWith('border-')) {
      final key = token.substring(7);
      final width = config.borderWidthOf(key, fallback: -1);
      if (width > 0) {
        result = styler.borderAll(
          color: _defaultBorderColor(config),
          width: width,
        );
      } else {
        final color = config.colorOf(key);
        if (color != null) {
          result = styler.borderAll(color: color, width: 1);
        } else {
          handled = false;
        }
      }
    } else if (token == 'rounded') {
      result = styler.borderRounded(config.radiusOf(''));
    } else if (_applyDirectionalRadius(styler, config, token)
        case final radiusResult?) {
      result = radiusResult;
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
      // Transform tokens handled by parseTransform(), don't report as unsupported
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
