import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'tw_config.dart';
import 'tw_semantic.dart';
import 'tw_utils.dart';

typedef TokenWarningCallback = void Function(String token);

// =============================================================================
// Styler Extensions for DefaultTextStyle
// =============================================================================

extension BoxStylerTextStyleExtension on BoxStyler {
  BoxStyler wrapDefaultTextStyle(TextStyleMix textStyle) {
    return wrap(WidgetModifierConfig.defaultTextStyle(style: textStyle));
  }
}

extension FlexBoxStylerTextStyleExtension on FlexBoxStyler {
  FlexBoxStyler wrapDefaultTextStyle(TextStyleMix textStyle) {
    return wrap(WidgetModifierConfig.defaultTextStyle(style: textStyle));
  }
}

// =============================================================================
// Transform Accumulator
// =============================================================================

class _TransformAccum {
  double? scale;
  double? rotateDeg;
  double? translateX;
  double? translateY;

  /// When true, always produce identity matrix even if no transforms are set.
  /// Used for animation interpolation when variants have transforms but base doesn't.
  bool needsIdentity = false;

  _TransformAccum();

  bool get hasAnyTransform =>
      needsIdentity ||
      scale != null ||
      rotateDeg != null ||
      translateX != null ||
      translateY != null;

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

class _TransformAccumTracker {
  // Identity map avoids sharing accumulators across value-equal stylers.
  final Map<Object, _TransformAccum> _accumulators =
      Map<Object, _TransformAccum>.identity();

  _TransformAccum forStyler<S>(S styler) {
    return _accumulators.putIfAbsent(styler as Object, _TransformAccum.new);
  }

  bool hasTransforms<S>(S styler) {
    final accum = _accumulators[styler as Object];
    return accum != null && accum.hasAnyTransform;
  }

  Matrix4? flush<S>(S styler) {
    final accum = _accumulators.remove(styler as Object);
    if (accum == null || !accum.hasAnyTransform) return null;
    return accum.toMatrix4();
  }

  void transfer<S>(S from, S to) {
    if (identical(from, to)) return;
    final fromKey = from as Object;
    final toKey = to as Object;
    final accum = _accumulators.remove(fromKey);
    if (accum == null) return;
    final existing = _accumulators[toKey];
    if (existing == null) {
      _accumulators[toKey] = accum;
      return;
    }
    existing.scale ??= accum.scale;
    existing.rotateDeg ??= accum.rotateDeg;
    existing.translateX ??= accum.translateX;
    existing.translateY ??= accum.translateY;
  }

  /// Copies transforms from [from] to [to] without removing from source.
  /// Used for variants where base transforms should remain AND be included
  /// in the variant's combined transform.
  void copyTo<S>(S from, S to) {
    if (identical(from, to)) return;
    final fromKey = from as Object;
    final toKey = to as Object;
    final accum = _accumulators[fromKey];
    if (accum == null || !accum.hasAnyTransform) return;
    final target = _accumulators.putIfAbsent(toKey, _TransformAccum.new);
    // Copy base transforms to target (base values act as defaults)
    target.scale ??= accum.scale;
    target.rotateDeg ??= accum.rotateDeg;
    target.translateX ??= accum.translateX;
    target.translateY ??= accum.translateY;
  }

  void clear() => _accumulators.clear();
}

// =============================================================================
// Border Accumulator
// =============================================================================

class _BorderAccum {
  double? topWidth;
  double? bottomWidth;
  double? leftWidth;
  double? rightWidth;
  Color? color;

  _BorderAccum();

  _BorderAccum inheritFrom(_BorderAccum base) {
    return _BorderAccum()
      ..topWidth = topWidth ?? base.topWidth
      ..bottomWidth = bottomWidth ?? base.bottomWidth
      ..leftWidth = leftWidth ?? base.leftWidth
      ..rightWidth = rightWidth ?? base.rightWidth
      ..color = color ?? base.color;
  }

  bool get hasStructure =>
      topWidth != null ||
      bottomWidth != null ||
      leftWidth != null ||
      rightWidth != null;

  void setAll(double width) {
    topWidth = width;
    bottomWidth = width;
    leftWidth = width;
    rightWidth = width;
  }

  void setHorizontal(double width) {
    leftWidth = width;
    rightWidth = width;
  }

  void setVertical(double width) {
    topWidth = width;
    bottomWidth = width;
  }
}

// =============================================================================
// Gradient Accumulator
// =============================================================================

class _GradientAccum {
  String? directionKey;
  (Alignment, Alignment)? direction;
  Color? fromColor;
  Color? viaColor;
  Color? toColor;

  _GradientAccum();

  bool get hasGradient => direction != null && fromColor != null;

  LinearGradientMix? toGradientMix(TwGradientStrategy strategy) {
    if (!hasGradient) return null;
    final colors = <Color>[
      fromColor!,
      if (viaColor != null) viaColor!,
      toColor ?? fromColor!,
    ];
    // Tailwind anchors via-* at 50% by default; without explicit stops
    // Flutter interpolates linearly which doesn't match Tailwind's behavior
    final stops = viaColor != null ? const [0.0, 0.5, 1.0] : const [0.0, 1.0];

    if (strategy == TwGradientStrategy.angle && directionKey != null) {
      final angle = _tailwindGradientAngles[directionKey!];
      if (angle != null) {
        return LinearGradientMix(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          transform: angle == 0.0 ? null : GradientRotation(angle),
          colors: colors,
          stops: stops,
        );
      }
    }

    final useCssAngleRect =
        strategy == TwGradientStrategy.cssAngleRect ||
        strategy.name == 'adaptive';
    if (useCssAngleRect &&
        directionKey != null &&
        _tailwindCornerDirections.contains(directionKey)) {
      return LinearGradientMix(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        transform: TwCssKeywordLinearTransform(directionKey!),
        colors: colors,
        stops: stops,
      );
    }

    final (begin, end) = direction!;
    return LinearGradientMix(
      begin: begin,
      end: end,
      colors: colors,
      stops: stops,
    );
  }
}

/// Tailwind directional gradient angles (CSS-like "to-*" directions).
///
/// Flutter gradients run left->right by default; rotating that axis gives us
/// an alternative parity strategy for directional gradients.
const Map<String, double> _tailwindGradientAngles = {
  'to-r': 0.0,
  'to-br': math.pi / 4,
  'to-b': math.pi / 2,
  'to-bl': 3 * math.pi / 4,
  'to-l': math.pi,
  'to-tl': -3 * math.pi / 4,
  'to-t': -math.pi / 2,
  'to-tr': -math.pi / 4,
};

const Set<String> _tailwindCornerDirections = {
  'to-br',
  'to-bl',
  'to-tr',
  'to-tl',
};

/// A [GradientTransform] that maps Tailwind/CSS `to-*` keyword directions
/// using bounds-aware geometry.
///
/// The transform keeps a base left-to-right gradient but rotates/scales it
/// per-rect so corner keywords follow CSS "magic corners" behavior.
@immutable
class TwCssKeywordLinearTransform extends GradientTransform {
  const TwCssKeywordLinearTransform(this.directionKey);

  final String directionKey;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    final w = bounds.width;
    final h = bounds.height;
    if (w <= 0 || h <= 0) return Matrix4.identity();

    final (rawX, rawY) = _directionVector(directionKey, w, h);
    final magnitude = math.sqrt((rawX * rawX) + (rawY * rawY));
    if (magnitude == 0) return Matrix4.identity();

    final ux = rawX / magnitude;
    final uy = rawY / magnitude;

    // CSS-equivalent gradient line length for direction vector `u`.
    // Base Flutter segment (centerLeft -> centerRight) has length = w.
    final gradientLength = (w * ux.abs()) + (h * uy.abs());
    final scale = gradientLength / w;
    final angle = math.atan2(uy, ux);

    return Matrix4.identity()
      ..translateByDouble(bounds.center.dx, bounds.center.dy, 0, 1)
      ..rotateZ(angle)
      ..scaleByDouble(scale, scale, 1, 1)
      ..translateByDouble(-bounds.center.dx, -bounds.center.dy, 0, 1);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwCssKeywordLinearTransform &&
          directionKey == other.directionKey;

  @override
  int get hashCode => directionKey.hashCode;

  static (double, double) _directionVector(
    String directionKey,
    double width,
    double height,
  ) {
    return switch (directionKey) {
      'to-r' => (1, 0),
      'to-l' => (-1, 0),
      'to-b' => (0, 1),
      'to-t' => (0, -1),
      // Corner vectors are aspect-ratio aware.
      'to-br' => (height, width),
      'to-tr' => (height, -width),
      'to-bl' => (-height, width),
      'to-tl' => (-height, -width),
      _ => (0, 1),
    };
  }
}

// =============================================================================
// Resolver - Parses tokens to semantic AST
// =============================================================================

class TwResolver {
  const TwResolver(this.config, {this.onUnknownVariant});

  /// Pre-compiled regex for parsing arbitrary length values (e.g., 123px, 1.5rem, 50%).
  static final _arbitraryLengthRegex = RegExp(r'^(-?\d+\.?\d*)(px|rem|em|%)?$');

  final TwConfig config;
  final TokenWarningCallback? onUnknownVariant;

  /// Finds the last colon that's not inside square brackets.
  /// Delegates to shared utility to avoid duplicate logic.
  int _findLastPrefixColon(String token) => findLastColonOutsideBrackets(token);

  /// Resolves a single token to parsed classes.
  List<TwParsedClass>? resolveToken(String token) {
    // 1. Parse prefix:base structure (bracket-aware)
    final colonIdx = _findLastPrefixColon(token);
    final prefix = colonIdx > 0 ? token.substring(0, colonIdx) : '';
    var base = colonIdx > 0 ? token.substring(colonIdx + 1) : token;

    // 2. Parse important (!)
    var important = false;
    if (base.startsWith('!')) {
      important = true;
      base = base.substring(1);
    }

    // 3. Parse negative (-)
    var negative = false;
    if (base.startsWith('-')) {
      negative = true;
      base = base.substring(1);
    }

    // 4. Parse variants
    final variants = _parseVariants(prefix);

    // 5. Check named plugins first
    final namedPlugin = namedPlugins[base];
    if (namedPlugin != null) {
      return [
        TwParsedClass(
          property: namedPlugin.property,
          value: namedPlugin.value,
          variants: variants,
          important: important,
        ),
      ];
    }

    // 6. Find root for functional plugins
    final root = findRoot(base);
    if (root == null) return null;

    final (rootPrefix, valueKey) = root;
    final plugin = functionalPlugins[rootPrefix];
    if (plugin == null) return null;

    // 7. Resolve value
    final value = _resolveValue(plugin, valueKey, negative);
    if (value == null) return null;

    return [
      TwParsedClass(
        property: plugin.property,
        value: value,
        variants: variants,
        important: important,
        negative: negative,
        arbitrary: _isArbitrary(valueKey),
      ),
    ];
  }

  List<TwVariantType> _parseVariants(String prefix) {
    if (prefix.isEmpty) return const [];

    final parts = prefix.split(':');
    final variants = <TwVariantType>[];

    for (final part in parts) {
      // Check interaction variants
      final interaction = interactionVariants[part];
      if (interaction != null) {
        variants.add(TwInteractionVariant(interaction));
        continue;
      }

      // Check theme variants
      final theme = themeVariants[part];
      if (theme != null) {
        variants.add(TwThemeVariant(theme));
        continue;
      }

      // Check breakpoints
      final breakpoint = config.breakpoints[part];
      if (breakpoint != null) {
        variants.add(TwBreakpointVariant(part, breakpoint));
        continue;
      }

      // Unknown variant - warn user about potential typo
      onUnknownVariant?.call(part);
    }

    return variants;
  }

  TwValue? _resolveValue(
    TwFunctionalPlugin plugin,
    String? valueKey,
    bool negative,
  ) {
    if (valueKey == null) {
      return _getDefaultValue(plugin);
    }

    // Handle arbitrary values [123px]
    if (_isArbitrary(valueKey)) {
      return _parseArbitrary(valueKey, plugin.type);
    }

    // Resolve from config scale
    final resolved = _resolveFromScale(plugin.scale, valueKey, plugin.type);
    if (resolved == null) return null;

    // Apply negative (only if plugin supports it)
    if (negative) {
      if (!plugin.supportsNegative) {
        return null; // Reject negative for unsupported properties
      }
      if (resolved is TwLengthValue) {
        return TwLengthValue(-resolved.value, resolved.unit);
      }
    }

    return resolved;
  }

  TwValue? _getDefaultValue(TwFunctionalPlugin plugin) {
    return switch (plugin.property) {
      TwProperty.borderWidth => const TwLengthValue(1),
      TwProperty.borderTopWidth => const TwLengthValue(1),
      TwProperty.borderRightWidth => const TwLengthValue(1),
      TwProperty.borderBottomWidth => const TwLengthValue(1),
      TwProperty.borderLeftWidth => const TwLengthValue(1),
      TwProperty.borderXWidth => const TwLengthValue(1),
      TwProperty.borderYWidth => const TwLengthValue(1),
      TwProperty.borderRadius => TwLengthValue(config.radiusOf('')),
      TwProperty.blur => TwLengthValue(config.blurOf('') ?? 0.0),
      _ => null,
    };
  }

  TwValue? _resolveFromScale(String? scale, String key, TwPluginType type) {
    if (scale == null) return null;

    // Use hasKey checks to return null for unknown keys (triggers onUnsupported)
    return switch (scale) {
      'space' =>
        config.hasSpace(key) ? TwLengthValue(config.spaceOf(key)) : null,
      'radii' =>
        config.hasRadius(key) ? TwLengthValue(config.radiusOf(key)) : null,
      'borderWidths' =>
        config.hasBorderWidth(key)
            ? TwLengthValue(config.borderWidthOf(key))
            : null,
      'fontSizes' =>
        config.hasFontSize(key) ? TwLengthValue(config.fontSizeOf(key)) : null,
      'colors' => _resolveColor(key),
      'durations' => _resolveDuration(key),
      'delays' => _resolveDelay(key),
      'scales' => _resolveScale(key),
      'rotations' => _resolveRotation(key),
      'blurs' =>
        config.hasBlur(key) ? TwLengthValue(config.blurOf(key)!) : null,
      _ => null,
    };
  }

  TwColorValue? _resolveColor(String key) {
    final color = config.colorOf(key);
    return color != null ? TwColorValue(color) : null;
  }

  TwDurationValue? _resolveDuration(String key) {
    final ms = config.durationOf(key);
    return ms != null ? TwDurationValue(ms) : null;
  }

  TwDurationValue? _resolveDelay(String key) {
    final ms = config.delayOf(key);
    return ms != null ? TwDurationValue(ms) : null;
  }

  TwLengthValue? _resolveScale(String key) {
    if (!config.hasScale(key)) return null;
    return TwLengthValue(config.scaleOf(key)!, TwUnit.none);
  }

  TwLengthValue? _resolveRotation(String key) {
    if (!config.hasRotation(key)) return null;
    return TwLengthValue(config.rotationOf(key)!, TwUnit.none);
  }

  bool _isArbitrary(String? value) =>
      value != null && value.startsWith('[') && value.endsWith(']');

  TwValue? _parseArbitrary(String value, TwPluginType type) {
    final inner = value.substring(1, value.length - 1);

    return switch (type) {
      TwPluginType.length => _parseArbitraryLength(inner),
      TwPluginType.color => _parseArbitraryColor(inner),
      _ => null,
    };
  }

  TwLengthValue? _parseArbitraryLength(String value) {
    final match = _arbitraryLengthRegex.firstMatch(value);
    if (match == null) return null;

    var num = double.parse(match.group(1)!);
    final unitStr = match.group(2) ?? 'px';

    // Convert rem/em to px using 16px base
    if (unitStr == 'rem' || unitStr == 'em') {
      num = num * 16;
      return TwLengthValue(num, TwUnit.px);
    }

    // Keep % as percent for constraint-based handling in appliers
    if (unitStr == '%') {
      return TwLengthValue(num, TwUnit.percent);
    }

    // Default to px
    return TwLengthValue(num, TwUnit.px);
  }

  TwColorValue? _parseArbitraryColor(String value) {
    if (value.startsWith('#')) {
      final hex = value.substring(1);
      if (hex.length != 6 && hex.length != 8) return null;

      final intVal = int.tryParse(hex, radix: 16);
      if (intVal == null) return null;

      final color = hex.length == 6
          ? Color(0xFF000000 | intVal)
          : Color(intVal);
      return TwColorValue(color);
    }
    return null;
  }
}

// =============================================================================
// Token Classification Helpers
// =============================================================================

bool _isGradientToken(String token) {
  if (token.startsWith('bg-gradient-')) return true;
  if (token.startsWith('bg-linear-')) return true;
  if (token.startsWith('from-')) return true;
  if (token.startsWith('via-')) return true;
  if (token.startsWith('to-') && !gradientDirections.containsKey(token)) {
    return true;
  }
  return false;
}

void _accumulateGradient(_GradientAccum accum, String base, TwConfig config) {
  if (base.startsWith('bg-gradient-')) {
    final dirKey = base.substring(12);
    final dir = gradientDirections[dirKey];
    if (dir != null) {
      accum.directionKey = dirKey;
      accum.direction = dir;
    }
  } else if (base.startsWith('bg-linear-')) {
    final dirKey = base.substring(10);
    final dir = gradientDirections[dirKey];
    if (dir != null) {
      accum.directionKey = dirKey;
      accum.direction = dir;
    }
  } else if (base.startsWith('from-')) {
    accum.fromColor = config.colorOf(base.substring(5));
  } else if (base.startsWith('via-')) {
    accum.viaColor = config.colorOf(base.substring(4));
  } else if (base.startsWith('to-') && !gradientDirections.containsKey(base)) {
    accum.toColor = config.colorOf(base.substring(3));
  }
}

Color _defaultBorderColor(TwConfig config) =>
    config.colorOf('gray-200') ?? const Color(0xFFE5E7EB);

bool _isBorderToken(String token, TwConfig config) {
  if (token == 'border') return true;
  if (!token.startsWith('border-')) return false;

  final key = token.substring(7);

  // Direction tokens
  const directions = {'t', 'b', 'l', 'r', 'x', 'y'};
  final dashIdx = key.indexOf('-');
  final dir = dashIdx == -1 ? key : key.substring(0, dashIdx);
  if (directions.contains(dir)) return true;

  // Width tokens (>= 0 to include border-0)
  if (config.borderWidthOf(key, fallback: -1) >= 0) return true;

  // Color tokens
  if (config.colorOf(key) != null) return true;

  return false;
}

void _accumulateBorder(_BorderAccum accum, String base, TwConfig config) {
  if (!base.startsWith('border')) return;

  // Handle color-only tokens
  if (base.startsWith('border-')) {
    final key = base.substring(7);
    final color = config.colorOf(key);
    if (color != null &&
        config.borderWidthOf(key, fallback: -1) <= 0 &&
        !_isDirectionBorder(base)) {
      accum.color = color;
      return;
    }
  }

  // Handle 'border' (all sides, width 1)
  if (base == 'border') {
    accum.setAll(1.0);
    return;
  }

  // Handle width-only tokens (>= 0 to include border-0)
  if (base.startsWith('border-')) {
    final widthKey = base.substring(7);
    final widthOnly = config.borderWidthOf(widthKey, fallback: -1);
    if (widthOnly >= 0) {
      accum.setAll(widthOnly);
      return;
    }
  }

  // Handle direction tokens
  final directive = _parseBorderDirective(config, base);
  if (directive != null) {
    if (directive.color != _defaultBorderColor(config)) {
      accum.color = directive.color;
    }

    switch (directive.direction) {
      case 't':
        accum.topWidth = directive.width;
      case 'b':
        accum.bottomWidth = directive.width;
      case 'l':
        accum.leftWidth = directive.width;
      case 'r':
        accum.rightWidth = directive.width;
      case 'x':
        accum.setHorizontal(directive.width);
      case 'y':
        accum.setVertical(directive.width);
    }
  }
}

bool _isDirectionBorder(String token) {
  if (!token.startsWith('border-')) return false;
  final body = token.substring(7);
  final dashIdx = body.indexOf('-');
  final dir = dashIdx == -1 ? body : body.substring(0, dashIdx);
  return {'t', 'b', 'l', 'r', 'x', 'y'}.contains(dir);
}

class _BorderDirective {
  const _BorderDirective(this.direction, this.color, this.width);
  final String direction;
  final Color color;
  final double width;
}

_BorderDirective? _parseBorderDirective(TwConfig config, String token) {
  if (!token.startsWith('border-')) return null;

  final body = token.substring(7);
  final dashIndex = body.indexOf('-');
  final direction = dashIndex == -1 ? body : body.substring(0, dashIndex);

  if (direction.isEmpty) return null;

  const supported = {'t', 'b', 'l', 'r', 'x', 'y'};
  if (!supported.contains(direction)) return null;

  final remainder = dashIndex == -1 ? '' : body.substring(dashIndex + 1);

  var width = 1.0;
  var color = _defaultBorderColor(config);

  if (remainder.isNotEmpty) {
    final widthCandidate = config.borderWidthOf(remainder, fallback: -1);
    if (widthCandidate >= 0) {
      // >= 0 to include border-t-0, border-b-0, etc.
      width = widthCandidate;
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

const Set<String> _transitionTriggerTokens = {
  'transition',
  'transition-all',
  'transition-colors',
  'transition-opacity',
  'transition-shadow',
  'transition-transform',
};

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

const Map<String, Curve> _easeTokens = {
  'ease-linear': Curves.linear,
  'ease-in': Curves.easeIn,
  'ease-out': Curves.easeOut,
  'ease-in-out': Curves.easeInOut,
};

bool _isAnimationToken(String token) {
  if (_transitionTriggerTokens.contains(token)) return true;
  if (token == 'transition-none') return true;
  if (_easeTokens.containsKey(token)) return true;
  if (token.startsWith('duration-')) {
    return _validTimeKeys.contains(token.substring(9));
  }
  if (token.startsWith('delay-')) {
    return _validTimeKeys.contains(token.substring(6));
  }
  return false;
}

// =============================================================================
// Variant Appliers
// =============================================================================

typedef _VariantApplier<S> = S Function(S base, S variant);
typedef _BreakpointApplier<S> = S Function(S base, Breakpoint bp, S child);
typedef _StylerMerge<S> = S Function(S base, S other);
typedef _BorderSideApplier<S> =
    S Function(S styler, {required Color color, required double width});

Map<String, _VariantApplier<S>> _buildVariants<S>({
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
    'active': pressed,
    'pressed': pressed,
    'disabled': disabled,
    'enabled': enabled,
    'dark': dark,
    'light': light,
  };
}

final _flexVariants = _buildVariants<FlexBoxStyler>(
  hover: (b, v) => b.onHovered(v),
  focus: (b, v) => b.onFocused(v),
  pressed: (b, v) => b.onPressed(v),
  disabled: (b, v) => b.onDisabled(v),
  enabled: (b, v) => b.onEnabled(v),
  dark: (b, v) => b.onDark(v),
  light: (b, v) => b.onLight(v),
);

final _boxVariants = _buildVariants<BoxStyler>(
  hover: (b, v) => b.onHovered(v),
  focus: (b, v) => b.onFocused(v),
  pressed: (b, v) => b.onPressed(v),
  disabled: (b, v) => b.onDisabled(v),
  enabled: (b, v) => b.onEnabled(v),
  dark: (b, v) => b.onDark(v),
  light: (b, v) => b.onLight(v),
);

final _textVariants = _buildVariants<TextStyler>(
  hover: (b, v) => b.onHovered(v),
  focus: (b, v) => b.onFocused(v),
  pressed: (b, v) => b.onPressed(v),
  disabled: (b, v) => b.onDisabled(v),
  enabled: (b, v) => b.onEnabled(v),
  dark: (b, v) => b.onDark(v),
  light: (b, v) => b.onLight(v),
);

// =============================================================================
// Unified Property Appliers
// =============================================================================

S _accumulateScale<S>(S styler, double value, _TransformAccumTracker tracker) {
  tracker.forStyler(styler).scale = value;
  return styler;
}

S _accumulateRotate<S>(S styler, double value, _TransformAccumTracker tracker) {
  tracker.forStyler(styler).rotateDeg = value;
  return styler;
}

S _accumulateTranslateX<S>(
  S styler,
  double value,
  _TransformAccumTracker tracker,
) {
  tracker.forStyler(styler).translateX = value;
  return styler;
}

S _accumulateTranslateY<S>(
  S styler,
  double value,
  _TransformAccumTracker tracker,
) {
  tracker.forStyler(styler).translateY = value;
  return styler;
}

FlexBoxStyler _applyPropertyToFlex(
  FlexBoxStyler styler,
  TwProperty property,
  TwValue value,
  TwConfig config,
  _TransformAccumTracker transformTracker,
) {
  return switch (property) {
    // Spacing
    TwProperty.padding => styler.paddingAll((value as TwLengthValue).value),
    TwProperty.paddingX => styler.paddingX((value as TwLengthValue).value),
    TwProperty.paddingY => styler.paddingY((value as TwLengthValue).value),
    TwProperty.paddingTop => styler.paddingTop((value as TwLengthValue).value),
    TwProperty.paddingRight => styler.paddingRight(
      (value as TwLengthValue).value,
    ),
    TwProperty.paddingBottom => styler.paddingBottom(
      (value as TwLengthValue).value,
    ),
    TwProperty.paddingLeft => styler.paddingLeft(
      (value as TwLengthValue).value,
    ),
    TwProperty.margin => styler.marginAll((value as TwLengthValue).value),
    TwProperty.marginX => styler.marginX((value as TwLengthValue).value),
    TwProperty.marginY => styler.marginY((value as TwLengthValue).value),
    TwProperty.marginTop => styler.marginTop((value as TwLengthValue).value),
    TwProperty.marginRight => styler.marginRight(
      (value as TwLengthValue).value,
    ),
    TwProperty.marginBottom => styler.marginBottom(
      (value as TwLengthValue).value,
    ),
    TwProperty.marginLeft => styler.marginLeft((value as TwLengthValue).value),
    TwProperty.gap => styler.spacing((value as TwLengthValue).value),

    // Sizing (only apply length values with px unit; enum values and % handled by widget layer)
    TwProperty.width =>
      value is TwLengthValue && value.unit == TwUnit.px
          ? styler.width(value.value)
          : styler,
    TwProperty.height =>
      value is TwLengthValue && value.unit == TwUnit.px
          ? styler.height(value.value)
          : styler,
    TwProperty.minWidth =>
      value is TwLengthValue && value.unit == TwUnit.px
          ? styler.minWidth(value.value)
          : styler,
    TwProperty.minHeight =>
      value is TwLengthValue && value.unit == TwUnit.px
          ? styler.minHeight(value.value)
          : styler,
    TwProperty.maxWidth =>
      value is TwLengthValue && value.unit == TwUnit.px
          ? styler.maxWidth(value.value)
          : styler,
    TwProperty.maxHeight =>
      value is TwLengthValue && value.unit == TwUnit.px
          ? styler.maxHeight(value.value)
          : styler,

    // Layout
    TwProperty.display => _applyFlexDisplay(styler, value),
    TwProperty.flexDirection => _applyFlexDirection(styler, value),
    TwProperty.alignItems => _applyAlignItems(styler, value),
    TwProperty.justifyContent => styler.mainAxisAlignment(
      (value as TwEnumValue<MainAxisAlignment>).value,
    ),

    // Background
    TwProperty.backgroundColor => styler.color((value as TwColorValue).color),

    // Border radius
    TwProperty.borderRadius => styler.borderRounded(
      (value as TwLengthValue).value,
    ),
    TwProperty.borderRadiusTop => styler.borderRoundedTop(
      (value as TwLengthValue).value,
    ),
    TwProperty.borderRadiusBottom => styler.borderRoundedBottom(
      (value as TwLengthValue).value,
    ),
    TwProperty.borderRadiusLeft => styler.borderRoundedLeft(
      (value as TwLengthValue).value,
    ),
    TwProperty.borderRadiusRight => styler.borderRoundedRight(
      (value as TwLengthValue).value,
    ),
    TwProperty.borderRadiusTopLeft => styler.borderRoundedTopLeft(
      (value as TwLengthValue).value,
    ),
    TwProperty.borderRadiusTopRight => styler.borderRoundedTopRight(
      (value as TwLengthValue).value,
    ),
    TwProperty.borderRadiusBottomLeft => styler.borderRoundedBottomLeft(
      (value as TwLengthValue).value,
    ),
    TwProperty.borderRadiusBottomRight => styler.borderRoundedBottomRight(
      (value as TwLengthValue).value,
    ),

    // Transform
    TwProperty.scale => _accumulateScale(
      styler,
      (value as TwLengthValue).value,
      transformTracker,
    ),
    TwProperty.rotate => _accumulateRotate(
      styler,
      (value as TwLengthValue).value,
      transformTracker,
    ),
    TwProperty.translateX => _accumulateTranslateX(
      styler,
      (value as TwLengthValue).value,
      transformTracker,
    ),
    TwProperty.translateY => _accumulateTranslateY(
      styler,
      (value as TwLengthValue).value,
      transformTracker,
    ),

    // Effects
    TwProperty.blur => styler.wrap(
      WidgetModifierConfig.blur((value as TwLengthValue).value),
    ),
    TwProperty.boxShadow => _applyFlexShadow(styler, value),
    TwProperty.clipBehavior => styler.clipBehavior(
      (value as TwEnumValue<Clip>).value,
    ),

    // Typography (propagates via DefaultTextStyle)
    TwProperty.textColor => styler.wrapDefaultTextStyle(
      TextStyleMix().color((value as TwColorValue).color),
    ),
    TwProperty.fontSize => styler.wrapDefaultTextStyle(
      TextStyleMix().fontSize((value as TwLengthValue).value),
    ),
    TwProperty.fontWeight => styler.wrapDefaultTextStyle(
      TextStyleMix().fontWeight((value as TwEnumValue<FontWeight>).value),
    ),
    TwProperty.textShadow => _applyFlexTextShadow(styler, value),

    _ => styler,
  };
}

FlexBoxStyler _applyFlexDisplay(FlexBoxStyler styler, TwValue value) {
  if (value is TwEnumValue && value.value == 'flex') {
    return styler.row();
  }
  return styler;
}

FlexBoxStyler _applyFlexDirection(FlexBoxStyler styler, TwValue value) {
  if (value is TwEnumValue<Axis>) {
    final result = value.value == Axis.horizontal
        ? styler.row()
        : styler.column();
    return result;
  }
  return styler;
}

FlexBoxStyler _applyAlignItems(FlexBoxStyler styler, TwValue value) {
  if (value is TwEnumValue<CrossAxisAlignment>) {
    final alignment = value.value;
    var result = styler.crossAxisAlignment(alignment);
    // CrossAxisAlignment.baseline requires textBaseline to be set
    if (alignment == CrossAxisAlignment.baseline) {
      result = result.textBaseline(TextBaseline.alphabetic);
    }
    return result;
  }
  return styler;
}

FlexBoxStyler _applyFlexShadow(FlexBoxStyler styler, TwValue value) {
  return _applyShadowValue(
    styler,
    value,
    applyElevation: (style, elevation) => style.elevation(elevation),
    applyBoxShadows: (style, shadows) => style.boxShadows(shadows),
  );
}

BoxStyler _applyPropertyToBox(
  BoxStyler styler,
  TwProperty property,
  TwValue value,
  TwConfig config,
  _TransformAccumTracker transformTracker,
) {
  return switch (property) {
    // Spacing
    TwProperty.padding => styler.paddingAll((value as TwLengthValue).value),
    TwProperty.paddingX => styler.paddingX((value as TwLengthValue).value),
    TwProperty.paddingY => styler.paddingY((value as TwLengthValue).value),
    TwProperty.paddingTop => styler.paddingTop((value as TwLengthValue).value),
    TwProperty.paddingRight => styler.paddingRight(
      (value as TwLengthValue).value,
    ),
    TwProperty.paddingBottom => styler.paddingBottom(
      (value as TwLengthValue).value,
    ),
    TwProperty.paddingLeft => styler.paddingLeft(
      (value as TwLengthValue).value,
    ),
    TwProperty.margin => styler.marginAll((value as TwLengthValue).value),
    TwProperty.marginX => styler.marginX((value as TwLengthValue).value),
    TwProperty.marginY => styler.marginY((value as TwLengthValue).value),
    TwProperty.marginTop => styler.marginTop((value as TwLengthValue).value),
    TwProperty.marginRight => styler.marginRight(
      (value as TwLengthValue).value,
    ),
    TwProperty.marginBottom => styler.marginBottom(
      (value as TwLengthValue).value,
    ),
    TwProperty.marginLeft => styler.marginLeft((value as TwLengthValue).value),

    // Sizing (only apply length values with px unit; enum values and % handled by widget layer)
    TwProperty.width =>
      value is TwLengthValue && value.unit == TwUnit.px
          ? styler.width(value.value)
          : styler,
    TwProperty.height =>
      value is TwLengthValue && value.unit == TwUnit.px
          ? styler.height(value.value)
          : styler,
    TwProperty.minWidth =>
      value is TwLengthValue && value.unit == TwUnit.px
          ? styler.minWidth(value.value)
          : styler,
    TwProperty.minHeight =>
      value is TwLengthValue && value.unit == TwUnit.px
          ? styler.minHeight(value.value)
          : styler,
    TwProperty.maxWidth =>
      value is TwLengthValue && value.unit == TwUnit.px
          ? styler.maxWidth(value.value)
          : styler,
    TwProperty.maxHeight =>
      value is TwLengthValue && value.unit == TwUnit.px
          ? styler.maxHeight(value.value)
          : styler,

    // Background
    TwProperty.backgroundColor => styler.color((value as TwColorValue).color),

    // Border radius
    TwProperty.borderRadius => styler.borderRounded(
      (value as TwLengthValue).value,
    ),
    TwProperty.borderRadiusTop => styler.borderRoundedTop(
      (value as TwLengthValue).value,
    ),
    TwProperty.borderRadiusBottom => styler.borderRoundedBottom(
      (value as TwLengthValue).value,
    ),
    TwProperty.borderRadiusLeft => styler.borderRoundedLeft(
      (value as TwLengthValue).value,
    ),
    TwProperty.borderRadiusRight => styler.borderRoundedRight(
      (value as TwLengthValue).value,
    ),
    TwProperty.borderRadiusTopLeft => styler.borderRoundedTopLeft(
      (value as TwLengthValue).value,
    ),
    TwProperty.borderRadiusTopRight => styler.borderRoundedTopRight(
      (value as TwLengthValue).value,
    ),
    TwProperty.borderRadiusBottomLeft => styler.borderRoundedBottomLeft(
      (value as TwLengthValue).value,
    ),
    TwProperty.borderRadiusBottomRight => styler.borderRoundedBottomRight(
      (value as TwLengthValue).value,
    ),

    // Transform
    TwProperty.scale => _accumulateScale(
      styler,
      (value as TwLengthValue).value,
      transformTracker,
    ),
    TwProperty.rotate => _accumulateRotate(
      styler,
      (value as TwLengthValue).value,
      transformTracker,
    ),
    TwProperty.translateX => _accumulateTranslateX(
      styler,
      (value as TwLengthValue).value,
      transformTracker,
    ),
    TwProperty.translateY => _accumulateTranslateY(
      styler,
      (value as TwLengthValue).value,
      transformTracker,
    ),

    // Effects
    TwProperty.blur => styler.wrap(
      WidgetModifierConfig.blur((value as TwLengthValue).value),
    ),
    TwProperty.boxShadow => _applyBoxShadow(styler, value),
    TwProperty.clipBehavior => styler.clipBehavior(
      (value as TwEnumValue<Clip>).value,
    ),

    // Typography (propagates via DefaultTextStyle)
    TwProperty.textColor => styler.wrapDefaultTextStyle(
      TextStyleMix().color((value as TwColorValue).color),
    ),
    TwProperty.fontSize => styler.wrapDefaultTextStyle(
      TextStyleMix().fontSize((value as TwLengthValue).value),
    ),
    TwProperty.fontWeight => styler.wrapDefaultTextStyle(
      TextStyleMix().fontWeight((value as TwEnumValue<FontWeight>).value),
    ),
    TwProperty.textShadow => _applyBoxTextShadow(styler, value),

    _ => styler,
  };
}

BoxStyler _applyBoxShadow(BoxStyler styler, TwValue value) {
  return _applyShadowValue(
    styler,
    value,
    applyElevation: (style, elevation) => style.elevation(elevation),
    applyBoxShadows: (style, shadows) => style.boxShadows(shadows),
  );
}

S _applyShadowValue<S>(
  S styler,
  TwValue value, {
  required S Function(S styler, ElevationShadow elevation) applyElevation,
  required S Function(S styler, List<BoxShadowMix> shadows) applyBoxShadows,
}) {
  if (value is TwEnumValue) {
    final shadowValue = value.value;
    if (shadowValue is ElevationShadow?) {
      return shadowValue == null
          ? applyBoxShadows(styler, const <BoxShadowMix>[])
          : applyElevation(styler, shadowValue);
    }
    if (shadowValue is List<BoxShadowMix>?) {
      return applyBoxShadows(styler, shadowValue ?? const <BoxShadowMix>[]);
    }
  }
  return styler;
}

S _applyResolvedProperties<S>(
  S styler,
  List<TwParsedClass>? parsed,
  S Function(S styler, TwProperty property, TwValue value) applyProperty,
) {
  if (parsed == null || parsed.isEmpty) return styler;

  var result = styler;
  for (final p in parsed) {
    result = applyProperty(result, p.property, p.value);
  }
  return result;
}

S _applySharedBoxLikeFallback<S>(
  S styler,
  String token, {
  required TwConfig config,
  required TokenWarningCallback? onUnsupported,
  required S Function(S styler, double value) setWidth,
  required S Function(S styler, double value) setHeight,
  required S Function(S styler, TextStyleMix style) applyDefaultTextStyle,
  S Function(S styler)? applyItemsBaseline,
}) {
  var handled = true;

  if (token.startsWith('w-')) {
    final key = token.substring(2);
    final fraction = parseFractionToken(key);
    if (fraction != null) {
      return styler; // Handled by widget layer
    }
    if (_isFullOrScreenKey(key)) {
      return styler; // Handled by widget layer
    }
    final size = config.spaceOf(key, fallback: double.nan);
    if (!size.isNaN) {
      return setWidth(styler, size);
    }
    handled = false;
  } else if (token.startsWith('h-')) {
    final key = token.substring(2);
    final fraction = parseFractionToken(key);
    if (fraction != null) {
      return styler; // Handled by widget layer
    }
    if (_isFullOrScreenKey(key)) {
      return styler; // Handled by widget layer
    }
    final size = config.spaceOf(key, fallback: double.nan);
    if (!size.isNaN) {
      return setHeight(styler, size);
    }
    handled = false;
  } else if (token.startsWith('flex-') ||
      token.startsWith('basis-') ||
      token.startsWith('self-') ||
      token.startsWith('shrink')) {
    // Item-level utilities handled at widget layer
    return styler;
  } else if (token.startsWith('text-')) {
    final key = token.substring(5);
    final color = config.colorOf(key);
    if (color != null) {
      return applyDefaultTextStyle(styler, TextStyleMix().color(color));
    }
    final size = config.fontSizeOf(key, fallback: -1);
    if (size > 0) {
      var textStyle = TextStyleMix().fontSize(size);
      final lineHeight = tailwindLineHeights[key];
      if (lineHeight != null) {
        textStyle = textStyle.height(lineHeight);
      }
      return applyDefaultTextStyle(styler, textStyle);
    }
    handled = false;
  } else if (_isAnimationToken(token)) {
    return styler;
  } else if (_isBorderToken(token, config)) {
    return styler;
  } else if (token == 'items-baseline' && applyItemsBaseline != null) {
    return applyItemsBaseline(styler);
  } else {
    handled = false;
  }

  if (!handled) {
    onUnsupported?.call(token);
  }

  return styler;
}

List<ShadowMix>? _resolveTextShadowMixes(TwValue value) {
  if (value is TwEnumValue<TextShadowPreset?>) {
    final preset = value.value;
    if (preset == null) {
      return const <ShadowMix>[];
    }
    final shadows = kTextShadowPresets[preset]!
        .map(
          (s) => ShadowMix(
            color: s.color,
            offset: s.offset,
            blurRadius: s.blurRadius,
          ),
        )
        .toList();
    return shadows;
  }
  return null;
}

FlexBoxStyler _applyFlexTextShadow(FlexBoxStyler styler, TwValue value) {
  final shadows = _resolveTextShadowMixes(value);
  if (shadows == null) return styler;
  return styler.wrapDefaultTextStyle(TextStyleMix().shadows(shadows));
}

BoxStyler _applyBoxTextShadow(BoxStyler styler, TwValue value) {
  final shadows = _resolveTextShadowMixes(value);
  if (shadows == null) return styler;
  return styler.wrapDefaultTextStyle(TextStyleMix().shadows(shadows));
}

TextStyler _applyTextShadow(TextStyler styler, TwValue value) {
  final shadows = _resolveTextShadowMixes(value);
  if (shadows == null) return styler;
  return styler.shadows(shadows);
}

TextStyler _applyPropertyToText(
  TextStyler styler,
  TwProperty property,
  TwValue value,
  TwConfig config,
) {
  return switch (property) {
    TwProperty.textColor => styler.color((value as TwColorValue).color),
    TwProperty.fontSize => styler.fontSize((value as TwLengthValue).value),
    TwProperty.fontWeight => styler.fontWeight(
      (value as TwEnumValue<FontWeight>).value,
    ),
    TwProperty.textShadow => _applyTextShadow(styler, value),
    TwProperty.lineHeight => styler.height((value as TwLengthValue).value),
    TwProperty.letterSpacing => styler.letterSpacing(
      (value as TwLengthValue).value,
    ),
    TwProperty.textTransform => _applyTextTransform(styler, value),
    TwProperty.textOverflow =>
      styler.overflow(TextOverflow.ellipsis).maxLines(1).softWrap(false),
    _ => styler,
  };
}

TextStyler _applyTextTransform(TextStyler styler, TwValue value) {
  if (value is TwEnumValue<String>) {
    return switch (value.value) {
      'uppercase' => styler.uppercase(),
      'lowercase' => styler.lowercase(),
      'capitalize' => styler.capitalize(),
      _ => styler,
    };
  }
  return styler;
}

// =============================================================================
// Main Parser Class
// =============================================================================

class TwParser {
  factory TwParser({TwConfig? config, TokenWarningCallback? onUnsupported}) {
    final resolvedConfig = config ?? TwConfig.standard();
    return TwParser._(config: resolvedConfig, onUnsupported: onUnsupported);
  }

  TwParser._({required this.config, this.onUnsupported})
    : _resolver = TwResolver(config, onUnknownVariant: onUnsupported);

  /// Pre-compiled regex for splitting class names by whitespace.
  static final _whitespaceRegex = RegExp(r'\s+');

  final TwConfig config;
  final TokenWarningCallback? onUnsupported;
  final TwResolver _resolver;
  final _TransformAccumTracker _transformTracker = _TransformAccumTracker();

  List<String> listTokens(String classNames) {
    final trimmed = classNames.trim();
    if (trimmed.isEmpty) return const [];
    return trimmed.split(_whitespaceRegex);
  }

  Set<String> setTokens(String classNames) => listTokens(classNames).toSet();

  bool wantsFlex(Set<String> tokens) {
    for (final token in tokens) {
      // Use bracket-aware colon finding to handle arbitrary values like bg-[color:red]
      final colonIdx = findLastColonOutsideBrackets(token);
      final base = colonIdx >= 0 ? token.substring(colonIdx + 1) : token;
      if (base == 'flex' || base == 'flex-row' || base == 'flex-col') {
        return true;
      }
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

    _transformTracker.clear();

    var hasBaseFlex = false;
    final baseBorder = _BorderAccum();
    final baseGradient = _GradientAccum();
    final variantBorders = <String, _BorderAccum>{};

    var styler = FlexBoxStyler();

    for (final token in tokens) {
      // Use bracket-aware colon finding to handle arbitrary values like bg-[color:red]
      final colonIndex = _findFirstPrefixColon(token);
      final prefix = colonIndex > 0 ? token.substring(0, colonIndex) : '';
      final base = colonIndex > 0 ? token.substring(colonIndex + 1) : token;

      // Track base flex
      if (prefix.isEmpty &&
          (base == 'flex' || base == 'flex-row' || base == 'flex-col')) {
        hasBaseFlex = true;
      }

      // Accumulate gradient tokens
      if (_isGradientToken(base)) {
        if (prefix.isEmpty) {
          _accumulateGradient(baseGradient, base, config);
        }
        continue;
      }

      // Accumulate border tokens
      if (_isBorderToken(base, config)) {
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

      // Apply via resolver + applier
      styler = _applyFlexToken(styler, token);
    }

    // Default to column when only prefixed flex
    if (!hasBaseFlex) {
      styler = _carryTransforms(styler, styler.column());
    }

    // Apply accumulated gradient
    final gradientMix = baseGradient.toGradientMix(config.gradientStrategy);
    if (gradientMix != null) {
      styler = _carryTransforms(styler, styler.gradient(gradientMix));
    }

    // Apply accumulated borders
    styler = _carryTransforms(
      styler,
      _applyAccumulatedBorders(
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
      ),
    );

    final baseMatrix = _transformTracker.flush(styler);
    if (baseMatrix != null) {
      styler = _applyTransformMatrix(styler, baseMatrix);
    }
    _transformTracker.clear();

    return styler;
  }

  BoxStyler parseBox(String classNames) {
    final tokens = listTokens(classNames);

    _transformTracker.clear();

    final baseBorder = _BorderAccum();
    final baseGradient = _GradientAccum();
    final variantBorders = <String, _BorderAccum>{};

    var styler = BoxStyler();

    for (final token in tokens) {
      // Use bracket-aware colon finding to handle arbitrary values like bg-[color:red]
      final colonIndex = _findFirstPrefixColon(token);
      final prefix = colonIndex > 0 ? token.substring(0, colonIndex) : '';
      final base = colonIndex > 0 ? token.substring(colonIndex + 1) : token;

      // Accumulate gradient tokens
      if (_isGradientToken(base)) {
        if (prefix.isEmpty) {
          _accumulateGradient(baseGradient, base, config);
        }
        continue;
      }

      // Accumulate border tokens
      if (_isBorderToken(base, config)) {
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

      // Apply via resolver + applier
      styler = _applyBoxToken(styler, token);
    }

    // Apply accumulated gradient
    final gradientMix = baseGradient.toGradientMix(config.gradientStrategy);
    if (gradientMix != null) {
      styler = _carryTransforms(styler, styler.gradient(gradientMix));
    }

    // Apply accumulated borders
    styler = _carryTransforms(
      styler,
      _applyAccumulatedBorders(
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
      ),
    );

    final baseMatrix = _transformTracker.flush(styler);
    if (baseMatrix != null) {
      styler = _applyTransformMatrix(styler, baseMatrix);
    }
    _transformTracker.clear();

    return styler;
  }

  TextStyler parseText(String classNames) {
    var styler = TextStyler().height(config.textDefaults.lineHeight);
    for (final token in listTokens(classNames)) {
      styler = _applyTextToken(styler, token);
    }
    return styler;
  }

  CurveAnimationConfig? parseAnimationFromTokens(List<String> tokens) {
    var hasTransition = false;
    var hasTransitionNone = false;
    var duration = const Duration(milliseconds: 150);
    Curve curve = Curves.easeOut;
    var delay = Duration.zero;

    for (final token in tokens) {
      // Use bracket-aware colon finding to handle arbitrary values like bg-[color:red]
      final colonIdx = findLastColonOutsideBrackets(token);
      final base = colonIdx >= 0 ? token.substring(colonIdx + 1) : token;

      if (_transitionTriggerTokens.contains(base)) {
        hasTransition = true;
      } else if (base == 'transition-none') {
        hasTransitionNone = true;
      } else if (base.startsWith('duration-')) {
        final key = base.substring(9);
        final ms = config.durationOf(key);
        if (ms != null) {
          duration = Duration(milliseconds: ms);
        } else {
          onUnsupported?.call(token);
        }
      } else if (_easeTokens.containsKey(base)) {
        curve = _easeTokens[base]!;
      } else if (base.startsWith('delay-')) {
        final key = base.substring(6);
        final ms = config.delayOf(key);
        if (ms != null) {
          delay = Duration(milliseconds: ms);
        } else {
          onUnsupported?.call(token);
        }
      }
    }

    if (hasTransitionNone) return null;
    if (!hasTransition) return null;

    return CurveAnimationConfig(duration: duration, curve: curve, delay: delay);
  }

  // ===========================================================================
  // Private Token Application
  // ===========================================================================

  bool _hasOnlyKnownPrefixParts<T>(String prefix, Map<String, T> variants) {
    if (prefix.isEmpty) return true;
    for (final part in prefix.split(':')) {
      if (_isBreakpoint(part)) continue;
      if (variants.containsKey(part)) continue;
      return false;
    }
    return true;
  }

  bool _isBreakpoint(String prefix) => config.breakpoints.containsKey(prefix);

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

  /// Finds the first colon that's not inside square brackets.
  /// Delegates to the shared utility in tw_utils.dart.
  int _findFirstPrefixColon(String token) =>
      findFirstColonOutsideBrackets(token);

  S _carryTransforms<S>(S from, S to) {
    _transformTracker.transfer(from, to);
    return to;
  }

  S _applyTransformMatrix<S>(S styler, Matrix4 matrix) {
    if (styler is BoxStyler) {
      return styler.transform(matrix) as S;
    }
    if (styler is FlexBoxStyler) {
      return styler.transform(matrix) as S;
    }
    return styler;
  }

  S _flushTransforms<S>(S styler) {
    if (!_transformTracker.hasTransforms(styler)) return styler;
    final matrix = _transformTracker.flush(styler);
    if (matrix == null) return styler;
    return _applyTransformMatrix(styler, matrix);
  }

  S _applyPrefixedToken<S>(
    S base,
    String token,
    Map<String, _VariantApplier<S>> variants,
    S Function() newStyler,
    S Function(S, String) applyAtomic,
    S Function(S, Breakpoint, S) applyBreakpoint,
  ) {
    final prefixIndex = _findFirstPrefixColon(token);
    if (prefixIndex <= 0) {
      final result = applyAtomic(base, token);
      return _carryTransforms(base, result);
    }

    final head = token.substring(0, prefixIndex);
    final tail = token.substring(prefixIndex + 1);

    if (_isBreakpoint(head)) {
      final min = config.breakpointOf(head);
      var childStyler = _applyPrefixedToken(
        newStyler(),
        tail,
        variants,
        newStyler,
        applyAtomic,
        applyBreakpoint,
      );
      // Copy base transforms to child BEFORE flushing so variant gets both
      // Use copyTo (not transfer) to preserve base transforms for final flush
      _transformTracker.copyTo(base, childStyler);
      // If child has transforms but base doesn't, mark base as needing identity for animation
      final childHasTransforms = _transformTracker.hasTransforms(childStyler);
      final baseHasTransforms = _transformTracker.hasTransforms(base);
      if (childHasTransforms && !baseHasTransforms) {
        _transformTracker.forStyler(base).needsIdentity = true;
      }
      childStyler = _flushTransforms(childStyler);
      final result = applyBreakpoint(
        base,
        Breakpoint(minWidth: min),
        childStyler,
      );
      return _carryTransforms(base, result);
    }

    final variantFn = variants[head];
    if (variantFn != null) {
      var childStyler = _applyPrefixedToken(
        newStyler(),
        tail,
        variants,
        newStyler,
        applyAtomic,
        applyBreakpoint,
      );
      // Copy base transforms to child BEFORE flushing so variant gets both
      // Use copyTo (not transfer) to preserve base transforms for final flush
      _transformTracker.copyTo(base, childStyler);
      // If child has transforms but base doesn't, mark base as needing identity for animation
      final childHasTransforms = _transformTracker.hasTransforms(childStyler);
      final baseHasTransforms = _transformTracker.hasTransforms(base);
      if (childHasTransforms && !baseHasTransforms) {
        _transformTracker.forStyler(base).needsIdentity = true;
      }
      childStyler = _flushTransforms(childStyler);
      final result = variantFn(base, childStyler);
      return _carryTransforms(base, result);
    }

    final result = applyAtomic(base, token);
    return _carryTransforms(base, result);
  }

  FlexBoxStyler _applyFlexAtomic(FlexBoxStyler styler, String token) {
    // Try resolver first
    if (token.startsWith('gap-x-') || token.startsWith('gap-y-')) {
      return styler;
    }

    final parsed = _resolver.resolveToken(token);
    if (parsed != null && parsed.isNotEmpty) {
      return _applyResolvedProperties(
        styler,
        parsed,
        (current, property, value) => _applyPropertyToFlex(
          current,
          property,
          value,
          config,
          _transformTracker,
        ),
      );
    }

    return _applySharedBoxLikeFallback(
      styler,
      token,
      config: config,
      onUnsupported: onUnsupported,
      setWidth: (current, value) => current.width(value),
      setHeight: (current, value) => current.height(value),
      applyDefaultTextStyle: (current, textStyle) =>
          current.wrapDefaultTextStyle(textStyle),
      applyItemsBaseline: (current) => current
          .crossAxisAlignment(CrossAxisAlignment.baseline)
          .textBaseline(TextBaseline.alphabetic),
    );
  }

  BoxStyler _applyBoxAtomic(BoxStyler styler, String token) {
    // Try resolver first
    final parsed = _resolver.resolveToken(token);
    if (parsed != null && parsed.isNotEmpty) {
      return _applyResolvedProperties(
        styler,
        parsed,
        (current, property, value) => _applyPropertyToBox(
          current,
          property,
          value,
          config,
          _transformTracker,
        ),
      );
    }

    return _applySharedBoxLikeFallback(
      styler,
      token,
      config: config,
      onUnsupported: onUnsupported,
      setWidth: (current, value) => current.width(value),
      setHeight: (current, value) => current.height(value),
      applyDefaultTextStyle: (current, textStyle) =>
          current.wrapDefaultTextStyle(textStyle),
    );
  }

  TextStyler _applyTextAtomic(TextStyler styler, String token) {
    // Try resolver first
    final parsed = _resolver.resolveToken(token);
    if (parsed != null && parsed.isNotEmpty) {
      var result = styler;
      for (final p in parsed) {
        result = _applyPropertyToText(result, p.property, p.value, config);
        // Apply Tailwind's default line heights for text-* sizes
        if (p.property == TwProperty.fontSize && p.value is TwLengthValue) {
          // Find the original key to look up line height
          final key = _findTextSizeKey(token);
          if (key != null) {
            final lineHeight = tailwindLineHeights[key];
            if (lineHeight != null) {
              result = result.height(lineHeight);
            }
          }
        }
      }
      return result;
    }

    // Fallback handling
    var handled = true;

    // leading-even and leading-trim special cases
    if (token == 'leading-even') {
      return styler.textHeightBehavior(
        TextHeightBehaviorMix(
          leadingDistribution: TextLeadingDistribution.even,
        ),
      );
    }
    if (token == 'leading-trim') {
      return styler.textHeightBehavior(
        TextHeightBehaviorMix(
          leadingDistribution: TextLeadingDistribution.even,
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
      );
    }

    if (_isAnimationToken(token)) {
      return styler;
    }

    // Text size tokens (text-lg, text-sm, etc.)
    // The resolver treats 'text-*' as color tokens, but these are font sizes
    if (token.startsWith('text-')) {
      final key = token.substring(5);
      // First check if it's a font size
      final size = config.fontSizeOf(key, fallback: -1);
      if (size > 0) {
        var result = styler.fontSize(size);
        final lineHeight = tailwindLineHeights[key];
        if (lineHeight != null) {
          result = result.height(lineHeight);
        }
        return result;
      }
      // Then check if it's a color
      final color = config.colorOf(key);
      if (color != null) {
        return styler.color(color);
      }
      handled = false;
    } else {
      handled = false;
    }

    if (!handled) {
      onUnsupported?.call(token);
    }

    return styler;
  }

  String? _findTextSizeKey(String token) {
    if (token.startsWith('text-')) {
      return token.substring(5);
    }
    return null;
  }

  // ===========================================================================
  // Accumulator Application
  // ===========================================================================

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

      final wrapped = _applyPrefixedToken<S>(
        newStyler(),
        '${entry.key}:__tw_internal__',
        variants,
        newStyler,
        (base, _) => variantStyle,
        applyBreakpoint,
      );
      result = merge(result, wrapped);
    }

    return result;
  }
}

bool _isFullOrScreenKey(String key) => key == 'full' || key == 'screen';
