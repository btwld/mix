import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/encode.dart'
    show
        payloadAlignment,
        payloadBreakpointCondition,
        payloadBrightnessCondition,
        payloadColor,
        payloadEnabledCondition,
        payloadOffset,
        payloadRadius,
        payloadWidgetStateCondition;
import 'package:mix_schema/mix_schema.dart';

import 'tw_config.dart';
import 'tw_semantic.dart';
import 'tw_utils.dart';

typedef TokenWarningCallback = void Function(String token);

const _boxType = 'box';
const _textType = 'text';
const _flexBoxType = 'flex_box';
const _boxDecorationType = 'box_decoration';
const _borderType = 'border';
const _borderRadiusType = 'border_radius';
const _linearGradientType = 'linear_gradient';
const _gradientRotationType = 'gradient_rotation';
const _cssLinearKeywordGradientType = 'css_linear_keyword_transform';
const _contextAllOfType = 'context_all_of';
const _blurModifierType = 'blur';
const _defaultTextStyleModifierType = 'default_text_style';

enum TwDiagnosticCode {
  unknownToken,
  unknownVariant,
  schemaDecodeFailure,
  schemaTypeMismatch,
}

final class TwDiagnostic {
  const TwDiagnostic({
    required this.code,
    required this.message,
    this.token,
    this.path,
    this.value,
  });

  final TwDiagnosticCode code;
  final String message;
  final String? token;
  final String? path;
  final Object? value;
}

final class TwParseResult<T extends Object> {
  const TwParseResult({
    required this.payload,
    required this.diagnostics,
    required this.errors,
    this.styler,
  });

  final JsonMap payload;
  final T? styler;
  final List<TwDiagnostic> diagnostics;
  final List<MixSchemaError> errors;

  bool get ok => styler != null && errors.isEmpty;
}

class _TransformAccum {
  double? scale;
  double? rotateDeg;
  double? translateX;
  double? translateY;

  _TransformAccum();

  bool get hasAnyTransform =>
      scale != null ||
      rotateDeg != null ||
      translateX != null ||
      translateY != null;

  _TransformAccum mergedWith(_TransformAccum base) {
    return _TransformAccum()
      ..scale = scale ?? base.scale
      ..rotateDeg = rotateDeg ?? base.rotateDeg
      ..translateX = translateX ?? base.translateX
      ..translateY = translateY ?? base.translateY;
  }

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

  List<double> toSchemaValues() => toMatrix4().storage.toList(growable: false);
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

const Map<String, String> _schemaCssLinearDirections = {
  'to-r': 'to_right',
  'to-l': 'to_left',
  'to-t': 'to_top',
  'to-b': 'to_bottom',
  'to-tr': 'to_top_right',
  'to-tl': 'to_top_left',
  'to-br': 'to_bottom_right',
  'to-bl': 'to_bottom_left',
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
    if (prefix.isNotEmpty && variants.length != prefix.split(':').length) {
      return null;
    }

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

  List<TwVariantType> parseVariantPrefix(String prefix) {
    return _parseVariants(prefix);
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
      final arbitrary = _parseArbitrary(valueKey, plugin.type);
      if (arbitrary == null) return null;
      if (!negative) return arbitrary;
      if (!plugin.supportsNegative) return null;
      if (arbitrary is TwLengthValue) {
        return TwLengthValue(-arbitrary.value, arbitrary.unit);
      }
      return null;
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

      // CSS hex is #RRGGBB or #RRGGBBAA — alpha is the trailing byte. Flutter
      // Color is 0xAARRGGBB, so 8-digit input needs the alpha byte moved into
      // the high bits.
      if (hex.length == 6) {
        return TwColorValue(Color(0xFF000000 | intVal));
      }
      final rgb = intVal >> 8;
      final alpha = intVal & 0xFF;
      return TwColorValue(Color((alpha << 24) | rgb));
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

bool _hasOnlyKnownPrefixParts(String prefix, TwConfig config) {
  if (prefix.isEmpty) return true;

  for (final part in prefix.split(':')) {
    if (config.breakpoints.containsKey(part)) continue;
    if (interactionVariants.containsKey(part)) continue;
    if (themeVariants.containsKey(part)) continue;
    return false;
  }

  return true;
}

String _variantKey(List<TwVariantType> variants) {
  if (variants.isEmpty) return '';

  return variants
      .map((variant) {
        return switch (variant) {
          TwInteractionVariant(:final state) => state,
          TwBreakpointVariant(:final name) => name,
          TwThemeVariant(:final mode) => mode,
        };
      })
      .join(':');
}

String _fontWeightWireName(FontWeight value) {
  return switch (value) {
    FontWeight.w100 => 'w100',
    FontWeight.w200 => 'w200',
    FontWeight.w300 => 'w300',
    FontWeight.w400 => 'w400',
    FontWeight.w500 => 'w500',
    FontWeight.w600 => 'w600',
    FontWeight.w700 => 'w700',
    FontWeight.w800 => 'w800',
    FontWeight.w900 => 'w900',
    _ => throw StateError('Unsupported font weight: $value'),
  };
}

JsonMap _variantConditionPayload(TwVariantType variant) {
  return switch (variant) {
    TwInteractionVariant(state: 'hover') => payloadWidgetStateCondition(
      WidgetState.hovered,
    ),
    TwInteractionVariant(state: 'focus') => payloadWidgetStateCondition(
      WidgetState.focused,
    ),
    TwInteractionVariant(state: 'pressed') => payloadWidgetStateCondition(
      WidgetState.pressed,
    ),
    TwInteractionVariant(state: 'disabled') => payloadWidgetStateCondition(
      WidgetState.disabled,
    ),
    TwInteractionVariant(state: 'enabled') => payloadEnabledCondition(),
    TwBreakpointVariant(:final minWidth) => payloadBreakpointCondition(
      minWidth: minWidth,
    ),
    TwThemeVariant(mode: 'dark') => payloadBrightnessCondition(Brightness.dark),
    TwThemeVariant(mode: 'light') => payloadBrightnessCondition(
      Brightness.light,
    ),
    _ => throw StateError('Unsupported variant payload: $variant'),
  };
}

List<Shadow>? _resolveTextShadowMixes(TwValue value) {
  if (value is TwEnumValue<TextShadowPreset?>) {
    final preset = value.value;
    if (preset == null) {
      return const <Shadow>[];
    }

    return List<Shadow>.unmodifiable(kTextShadowPresets[preset]!);
  }

  return null;
}

final class _TwSchemaDecoderAdapter {
  static final MixSchemaContract _contract = MixSchemaContract.builtIn();

  static TwParseResult<BoxStyler> tryDecodeBox(
    JsonMap payload, {
    List<TwDiagnostic> diagnostics = const [],
  }) => _decodeTyped<BoxStyler>(payload, diagnostics);

  static TwParseResult<FlexBoxStyler> tryDecodeFlexBox(
    JsonMap payload, {
    List<TwDiagnostic> diagnostics = const [],
  }) => _decodeTyped<FlexBoxStyler>(payload, diagnostics);

  static TwParseResult<TextStyler> tryDecodeText(
    JsonMap payload, {
    List<TwDiagnostic> diagnostics = const [],
  }) => _decodeTyped<TextStyler>(payload, diagnostics);

  static TwParseResult<T> _decodeTyped<T extends Object>(
    JsonMap payload,
    List<TwDiagnostic> diagnostics,
  ) {
    final result = _contract.decode(payload);
    if (!result.ok) {
      return TwParseResult<T>(
        payload: payload,
        diagnostics: List<TwDiagnostic>.unmodifiable([
          ...diagnostics,
          ..._schemaFailureDiagnostics(result.errors),
        ]),
        errors: result.errors,
      );
    }

    final value = result.value;
    if (value is T) {
      return _encodeTyped(value, payload, diagnostics);
    }

    return TwParseResult<T>(
      payload: payload,
      diagnostics: List<TwDiagnostic>.unmodifiable([
        ...diagnostics,
        TwDiagnostic(
          code: TwDiagnosticCode.schemaTypeMismatch,
          message:
              'Decoded ${value.runtimeType} for payload type ${payload['type']}.',
          value: payload['type'],
        ),
      ]),
      errors: const [],
    );
  }

  static TwParseResult<T> _encodeTyped<T extends Object>(
    T value,
    JsonMap payload,
    List<TwDiagnostic> diagnostics,
  ) {
    final encoded = _contract.encode(value);
    if (!encoded.ok) {
      return TwParseResult<T>(
        payload: payload,
        diagnostics: List<TwDiagnostic>.unmodifiable([
          ...diagnostics,
          ..._schemaFailureDiagnostics(encoded.errors),
        ]),
        errors: encoded.errors,
      );
    }

    return TwParseResult<T>(
      payload: encoded.value!,
      styler: value,
      diagnostics: List<TwDiagnostic>.unmodifiable(diagnostics),
      errors: const [],
    );
  }

  static Iterable<TwDiagnostic> _schemaFailureDiagnostics(
    List<MixSchemaError> errors,
  ) sync* {
    for (final error in errors) {
      yield TwDiagnostic(
        code: TwDiagnosticCode.schemaDecodeFailure,
        message: error.message,
        path: error.path,
        value: error.value,
      );
    }
  }
}

final class _BuiltSchemaStyle {
  final JsonMap payload;
  final bool hasTransform;

  const _BuiltSchemaStyle({required this.payload, required this.hasTransform});
}

final class _TextStylePayloadBuilder {
  String? color;
  double? fontSize;
  String? fontWeight;
  double? height;
  double? letterSpacing;
  List<JsonMap>? shadows;
  bool _shadowsSet = false;

  bool get hasAny =>
      color != null ||
      fontSize != null ||
      fontWeight != null ||
      height != null ||
      letterSpacing != null ||
      _shadowsSet;

  void setColor(Color value) => color = payloadColor(value);

  void setFontSize(double value) => fontSize = value;

  void setFontWeight(FontWeight value) =>
      fontWeight = _fontWeightWireName(value);

  void setHeight(double value) => height = value;

  void setLetterSpacing(double value) => letterSpacing = value;

  void setShadows(List<Shadow> value) {
    _shadowsSet = true;
    shadows = [
      for (final shadow in value)
        {
          'color': payloadColor(shadow.color),
          'offset': payloadOffset(shadow.offset),
          'blurRadius': shadow.blurRadius,
        },
    ];
  }

  JsonMap build() {
    return {
      if (color != null) 'color': color,
      if (fontSize != null) 'fontSize': fontSize,
      if (fontWeight != null) 'fontWeight': fontWeight,
      if (height != null) 'height': height,
      if (letterSpacing != null) 'letterSpacing': letterSpacing,
      if (_shadowsSet) 'shadows': shadows ?? const <JsonMap>[],
    };
  }
}

final class _ModifierPayloadBuilder {
  double? blurSigma;
  bool _blurSet = false;
  final _TextStylePayloadBuilder defaultTextStyle = _TextStylePayloadBuilder();
  final List<String> _order = <String>[];

  bool get hasAny => _blurSet || defaultTextStyle.hasAny;

  void setBlur(double sigma) {
    _blurSet = true;
    blurSigma = sigma;
    _touch(_blurModifierType);
  }

  void touchDefaultTextStyle() {
    _touch(_defaultTextStyleModifierType);
  }

  void _touch(String type) {
    if (_order.contains(type)) return;
    _order.add(type);
  }

  void applyTo(JsonMap payload) {
    final modifiers = <JsonMap>[];

    for (final type in _order) {
      if (type == _blurModifierType && _blurSet) {
        modifiers.add({'type': _blurModifierType, 'sigma': blurSigma});
      }

      if (type == _defaultTextStyleModifierType && defaultTextStyle.hasAny) {
        modifiers.add({
          'type': _defaultTextStyleModifierType,
          'style': defaultTextStyle.build(),
        });
      }
    }

    if (modifiers.isEmpty) return;

    payload['modifiers'] = modifiers;
    payload['modifierOrder'] = [for (final type in _order) type];
  }
}

final class _BoxDecorationPayloadBuilder {
  String? color;
  JsonMap? gradient;
  final _BorderAccum border = _BorderAccum();
  Radius? topLeft;
  Radius? topRight;
  Radius? bottomLeft;
  Radius? bottomRight;
  bool _boxShadowSet = false;
  List<JsonMap>? boxShadow;

  bool get hasAny =>
      color != null ||
      gradient != null ||
      border.hasStructure ||
      topLeft != null ||
      topRight != null ||
      bottomLeft != null ||
      bottomRight != null ||
      _boxShadowSet;

  void setAllRadius(double value) {
    final radius = Radius.circular(value);
    topLeft = radius;
    topRight = radius;
    bottomLeft = radius;
    bottomRight = radius;
  }

  void setTopRadius(double value) {
    final radius = Radius.circular(value);
    topLeft = radius;
    topRight = radius;
  }

  void setBottomRadius(double value) {
    final radius = Radius.circular(value);
    bottomLeft = radius;
    bottomRight = radius;
  }

  void setLeftRadius(double value) {
    final radius = Radius.circular(value);
    topLeft = radius;
    bottomLeft = radius;
  }

  void setRightRadius(double value) {
    final radius = Radius.circular(value);
    topRight = radius;
    bottomRight = radius;
  }

  void setTopLeftRadius(double value) => topLeft = Radius.circular(value);

  void setTopRightRadius(double value) => topRight = Radius.circular(value);

  void setBottomLeftRadius(double value) => bottomLeft = Radius.circular(value);

  void setBottomRightRadius(double value) =>
      bottomRight = Radius.circular(value);

  void setBoxShadows(List<BoxShadow> shadows) {
    _boxShadowSet = true;
    boxShadow = [
      for (final shadow in shadows)
        {
          'color': payloadColor(shadow.color),
          'offset': payloadOffset(shadow.offset),
          'blurRadius': shadow.blurRadius,
          'spreadRadius': shadow.spreadRadius,
        },
    ];
  }

  JsonMap? build(TwConfig config, {_BorderAccum? inheritedBorder}) {
    final effectiveBorder = inheritedBorder == null
        ? border
        : border.inheritFrom(inheritedBorder);
    final hasEffectiveBorder = effectiveBorder.hasStructure;
    if (!hasAny && !hasEffectiveBorder) return null;

    return {
      'type': _boxDecorationType,
      if (color != null) 'color': color,
      if (gradient != null) 'gradient': gradient,
      if (hasEffectiveBorder)
        'border': _buildBorderPayload(effectiveBorder, config),
      if (topLeft != null ||
          topRight != null ||
          bottomLeft != null ||
          bottomRight != null)
        'borderRadius': {
          'type': _borderRadiusType,
          if (topLeft != null) 'topLeft': payloadRadius(topLeft!),
          if (topRight != null) 'topRight': payloadRadius(topRight!),
          if (bottomLeft != null) 'bottomLeft': payloadRadius(bottomLeft!),
          if (bottomRight != null) 'bottomRight': payloadRadius(bottomRight!),
        },
      if (_boxShadowSet) 'boxShadow': boxShadow ?? const <JsonMap>[],
    };
  }
}

JsonMap _buildBorderPayload(_BorderAccum border, TwConfig config) {
  final color = border.color ?? _defaultBorderColor(config);
  return {
    'type': _borderType,
    if (border.topWidth != null)
      'top': {'color': payloadColor(color), 'width': border.topWidth},
    if (border.bottomWidth != null)
      'bottom': {'color': payloadColor(color), 'width': border.bottomWidth},
    if (border.leftWidth != null)
      'left': {'color': payloadColor(color), 'width': border.leftWidth},
    if (border.rightWidth != null)
      'right': {'color': payloadColor(color), 'width': border.rightWidth},
  };
}

JsonMap? _buildGradientPayload(
  _GradientAccum gradient,
  TwGradientStrategy strategy,
) {
  if (!gradient.hasGradient) return null;

  final colors = <String>[
    payloadColor(gradient.fromColor!),
    if (gradient.viaColor != null) payloadColor(gradient.viaColor!),
    payloadColor(gradient.toColor ?? gradient.fromColor!),
  ];
  final stops = gradient.viaColor != null
      ? const [0.0, 0.5, 1.0]
      : const [0.0, 1.0];

  if (strategy == TwGradientStrategy.angle && gradient.directionKey != null) {
    final angle = _tailwindGradientAngles[gradient.directionKey!];
    if (angle != null) {
      return {
        'type': _linearGradientType,
        'colors': colors,
        'stops': stops,
        'begin': payloadAlignment(Alignment.centerLeft),
        'end': payloadAlignment(Alignment.centerRight),
        if (angle != 0.0)
          'transform': {'type': _gradientRotationType, 'radians': angle},
      };
    }
  }

  if (strategy == TwGradientStrategy.cssAngleRect &&
      gradient.directionKey != null &&
      _tailwindCornerDirections.contains(gradient.directionKey)) {
    final schemaDirection = _schemaCssLinearDirections[gradient.directionKey!];
    if (schemaDirection == null) return null;

    return {
      'type': _linearGradientType,
      'colors': colors,
      'stops': stops,
      'begin': payloadAlignment(Alignment.centerLeft),
      'end': payloadAlignment(Alignment.centerRight),
      'transform': {
        'type': _cssLinearKeywordGradientType,
        'direction': schemaDirection,
      },
    };
  }

  final (begin, end) = gradient.direction!;
  return {
    'type': _linearGradientType,
    'colors': colors,
    'stops': stops,
    'begin': payloadAlignment(begin),
    'end': payloadAlignment(end),
  };
}

final class _BoxLikeSchemaState {
  _BoxLikeSchemaState({required this.isFlex});

  final bool isFlex;
  final Map<String, Object?> padding = <String, Object?>{};
  final Map<String, Object?> margin = <String, Object?>{};
  final Map<String, Object?> constraints = <String, Object?>{};
  final _BoxDecorationPayloadBuilder decoration =
      _BoxDecorationPayloadBuilder();
  final _ModifierPayloadBuilder modifiers = _ModifierPayloadBuilder();
  final _TransformAccum transform = _TransformAccum();
  final _GradientAccum gradient = _GradientAccum();
  final Map<String, _BoxLikeSchemaState> variants =
      <String, _BoxLikeSchemaState>{};
  final Map<String, List<TwVariantType>> variantTypes =
      <String, List<TwVariantType>>{};
  String? direction;
  String? mainAxisAlignment;
  String? crossAxisAlignment;
  String? textBaseline;
  double? spacing;
  String? clipBehavior;

  _BoxLikeSchemaState stateFor(List<TwVariantType> tokenVariants) {
    if (tokenVariants.isEmpty) return this;

    final key = _variantKey(tokenVariants);
    variantTypes.putIfAbsent(key, () => List.unmodifiable(tokenVariants));
    return variants.putIfAbsent(key, () => _BoxLikeSchemaState(isFlex: isFlex));
  }

  void applyResolvedProperty(
    TwProperty property,
    TwValue value,
    TwConfig config,
  ) {
    switch (property) {
      case TwProperty.padding:
        _setAllEdges(padding, (value as TwLengthValue).value);
        break;
      case TwProperty.paddingX:
        _setHorizontalEdges(padding, (value as TwLengthValue).value);
        break;
      case TwProperty.paddingY:
        _setVerticalEdges(padding, (value as TwLengthValue).value);
        break;
      case TwProperty.paddingTop:
        padding['top'] = (value as TwLengthValue).value;
        break;
      case TwProperty.paddingRight:
        padding['right'] = (value as TwLengthValue).value;
        break;
      case TwProperty.paddingBottom:
        padding['bottom'] = (value as TwLengthValue).value;
        break;
      case TwProperty.paddingLeft:
        padding['left'] = (value as TwLengthValue).value;
        break;
      case TwProperty.margin:
        _setAllEdges(margin, (value as TwLengthValue).value);
        break;
      case TwProperty.marginX:
        _setHorizontalEdges(margin, (value as TwLengthValue).value);
        break;
      case TwProperty.marginY:
        _setVerticalEdges(margin, (value as TwLengthValue).value);
        break;
      case TwProperty.marginTop:
        margin['top'] = (value as TwLengthValue).value;
        break;
      case TwProperty.marginRight:
        margin['right'] = (value as TwLengthValue).value;
        break;
      case TwProperty.marginBottom:
        margin['bottom'] = (value as TwLengthValue).value;
        break;
      case TwProperty.marginLeft:
        margin['left'] = (value as TwLengthValue).value;
        break;
      case TwProperty.gap:
        if (isFlex) {
          spacing = (value as TwLengthValue).value;
        }
        break;
      case TwProperty.width:
        final length = value;
        if (length is TwLengthValue && length.unit == TwUnit.px) {
          constraints['minWidth'] = length.value;
          constraints['maxWidth'] = length.value;
        }
        break;
      case TwProperty.height:
        final length = value;
        if (length is TwLengthValue && length.unit == TwUnit.px) {
          constraints['minHeight'] = length.value;
          constraints['maxHeight'] = length.value;
        }
        break;
      case TwProperty.minWidth:
        final length = value;
        if (length is TwLengthValue && length.unit == TwUnit.px) {
          constraints['minWidth'] = length.value;
        }
        break;
      case TwProperty.minHeight:
        final length = value;
        if (length is TwLengthValue && length.unit == TwUnit.px) {
          constraints['minHeight'] = length.value;
        }
        break;
      case TwProperty.maxWidth:
        final length = value;
        if (length is TwLengthValue && length.unit == TwUnit.px) {
          constraints['maxWidth'] = length.value;
        }
        break;
      case TwProperty.maxHeight:
        final length = value;
        if (length is TwLengthValue && length.unit == TwUnit.px) {
          constraints['maxHeight'] = length.value;
        }
        break;
      case TwProperty.display:
        if (isFlex && value is TwEnumValue && value.value == 'flex') {
          direction = Axis.horizontal.name;
        }
        break;
      case TwProperty.flexDirection:
        if (isFlex && value is TwEnumValue<Axis>) {
          direction = value.value.name;
        }
        break;
      case TwProperty.alignItems:
        if (isFlex && value is TwEnumValue<CrossAxisAlignment>) {
          crossAxisAlignment = value.value.name;
          if (value.value == CrossAxisAlignment.baseline) {
            textBaseline = TextBaseline.alphabetic.name;
          }
        }
        break;
      case TwProperty.justifyContent:
        if (isFlex) {
          mainAxisAlignment =
              (value as TwEnumValue<MainAxisAlignment>).value.name;
        }
        break;
      case TwProperty.backgroundColor:
        decoration.color = payloadColor((value as TwColorValue).color);
        break;
      case TwProperty.borderRadius:
        decoration.setAllRadius((value as TwLengthValue).value);
        break;
      case TwProperty.borderRadiusTop:
        decoration.setTopRadius((value as TwLengthValue).value);
        break;
      case TwProperty.borderRadiusBottom:
        decoration.setBottomRadius((value as TwLengthValue).value);
        break;
      case TwProperty.borderRadiusLeft:
        decoration.setLeftRadius((value as TwLengthValue).value);
        break;
      case TwProperty.borderRadiusRight:
        decoration.setRightRadius((value as TwLengthValue).value);
        break;
      case TwProperty.borderRadiusTopLeft:
        decoration.setTopLeftRadius((value as TwLengthValue).value);
        break;
      case TwProperty.borderRadiusTopRight:
        decoration.setTopRightRadius((value as TwLengthValue).value);
        break;
      case TwProperty.borderRadiusBottomLeft:
        decoration.setBottomLeftRadius((value as TwLengthValue).value);
        break;
      case TwProperty.borderRadiusBottomRight:
        decoration.setBottomRightRadius((value as TwLengthValue).value);
        break;
      case TwProperty.scale:
        transform.scale = (value as TwLengthValue).value;
        break;
      case TwProperty.rotate:
        transform.rotateDeg = (value as TwLengthValue).value;
        break;
      case TwProperty.translateX:
        transform.translateX = (value as TwLengthValue).value;
        break;
      case TwProperty.translateY:
        transform.translateY = (value as TwLengthValue).value;
        break;
      case TwProperty.blur:
        modifiers.setBlur((value as TwLengthValue).value);
        break;
      case TwProperty.boxShadow:
        if (value is TwEnumValue<List<BoxShadow>?>) {
          decoration.setBoxShadows(value.value ?? const <BoxShadow>[]);
        }
        break;
      case TwProperty.clipBehavior:
        clipBehavior = (value as TwEnumValue<Clip>).value.name;
        break;
      case TwProperty.textColor:
        modifiers.touchDefaultTextStyle();
        modifiers.defaultTextStyle.setColor((value as TwColorValue).color);
        break;
      case TwProperty.fontSize:
        modifiers.touchDefaultTextStyle();
        modifiers.defaultTextStyle.setFontSize((value as TwLengthValue).value);
        break;
      case TwProperty.fontWeight:
        modifiers.touchDefaultTextStyle();
        modifiers.defaultTextStyle.setFontWeight(
          (value as TwEnumValue<FontWeight>).value,
        );
        break;
      case TwProperty.textShadow:
        final shadows = _resolveTextShadowMixes(value);
        if (shadows != null) {
          modifiers.touchDefaultTextStyle();
          modifiers.defaultTextStyle.setShadows(shadows);
        }
        break;
      default:
        break;
    }
  }

  bool applyFallbackToken(
    String token,
    TwConfig config,
    TokenWarningCallback? onUnsupported, {
    required bool allowFlexSizingNoops,
  }) {
    if (isFlex && (token.startsWith('gap-x-') || token.startsWith('gap-y-'))) {
      return true;
    }

    if (token.startsWith('w-')) {
      final key = token.substring(2);
      if (parseFractionToken(key) != null || _isFullOrScreenKey(key)) {
        return true;
      }

      final size = config.spaceOf(key, fallback: double.nan);
      if (!size.isNaN) {
        constraints['minWidth'] = size;
        constraints['maxWidth'] = size;
        return true;
      }
      onUnsupported?.call(token);
      return false;
    }

    if (token.startsWith('h-')) {
      final key = token.substring(2);
      if (parseFractionToken(key) != null || _isFullOrScreenKey(key)) {
        return true;
      }

      final size = config.spaceOf(key, fallback: double.nan);
      if (!size.isNaN) {
        constraints['minHeight'] = size;
        constraints['maxHeight'] = size;
        return true;
      }
      onUnsupported?.call(token);
      return false;
    }

    if (allowFlexSizingNoops &&
        (token.startsWith('flex-') ||
            token.startsWith('basis-') ||
            token.startsWith('self-') ||
            token.startsWith('shrink'))) {
      return true;
    }

    if (token.startsWith('text-')) {
      final key = token.substring(5);
      final color = config.colorOf(key);
      if (color != null) {
        modifiers.touchDefaultTextStyle();
        modifiers.defaultTextStyle.setColor(color);
        return true;
      }

      final size = config.fontSizeOf(key, fallback: -1);
      if (size > 0) {
        modifiers.touchDefaultTextStyle();
        modifiers.defaultTextStyle.setFontSize(size);
        final lineHeight = tailwindLineHeights[key];
        if (lineHeight != null) {
          modifiers.defaultTextStyle.setHeight(lineHeight);
        }
        return true;
      }

      onUnsupported?.call(token);
      return false;
    }

    if (_isAnimationToken(token) || _isBorderToken(token, config)) {
      return true;
    }

    onUnsupported?.call(token);
    return false;
  }

  _BuiltSchemaStyle buildStylePayload({
    required TwConfig config,
    required _TransformAccum inheritedTransform,
    _BorderAccum? inheritedBorder,
  }) {
    final payload = <String, Object?>{};
    final effectiveTransform = transform.mergedWith(inheritedTransform);
    var hasTransform = effectiveTransform.hasAnyTransform;
    final builtVariants = <JsonMap>[];
    final effectiveBorder = inheritedBorder == null
        ? decoration.border
        : decoration.border.inheritFrom(inheritedBorder);

    for (final entry in variants.entries) {
      final built = entry.value.buildStylePayload(
        config: config,
        inheritedTransform: effectiveTransform,
        inheritedBorder: effectiveBorder,
      );
      if (built.hasTransform && !effectiveTransform.hasAnyTransform) {
        hasTransform = true;
      }

      builtVariants.add(
        _wrapVariantStyle(variantTypes[entry.key]!, built.payload),
      );
    }

    if (padding.isNotEmpty)
      payload['padding'] = Map<String, Object?>.from(padding);
    if (margin.isNotEmpty)
      payload['margin'] = Map<String, Object?>.from(margin);
    if (constraints.isNotEmpty) {
      payload['constraints'] = Map<String, Object?>.from(constraints);
    }

    final decorationPayload = decoration.build(
      config,
      inheritedBorder: inheritedBorder,
    );
    if (decorationPayload != null) {
      payload['decoration'] = decorationPayload;
    }

    if (clipBehavior != null) payload['clipBehavior'] = clipBehavior;

    if (isFlex) {
      if (direction != null) payload['direction'] = direction;
      if (mainAxisAlignment != null) {
        payload['mainAxisAlignment'] = mainAxisAlignment;
      }
      if (crossAxisAlignment != null) {
        payload['crossAxisAlignment'] = crossAxisAlignment;
      }
      if (textBaseline != null) payload['textBaseline'] = textBaseline;
      if (spacing != null) payload['spacing'] = spacing;
    }

    if (effectiveTransform.hasAnyTransform) {
      payload['transform'] = effectiveTransform.toSchemaValues();
      payload['transformAlignment'] = payloadAlignment(Alignment.center);
    } else if (hasTransform) {
      payload['transform'] = Matrix4.identity().storage.toList(growable: false);
      payload['transformAlignment'] = payloadAlignment(Alignment.center);
    }

    modifiers.applyTo(payload);

    if (builtVariants.isNotEmpty) payload['variants'] = builtVariants;

    return _BuiltSchemaStyle(payload: payload, hasTransform: hasTransform);
  }
}

final class _TextSchemaState {
  _TextSchemaState();

  final _TextStylePayloadBuilder style = _TextStylePayloadBuilder();
  final Map<String, _TextSchemaState> variants = <String, _TextSchemaState>{};
  final Map<String, List<TwVariantType>> variantTypes =
      <String, List<TwVariantType>>{};
  String? overflow;
  int? maxLines;
  bool? softWrap;
  String? textAlign;
  JsonMap? textHeightBehavior;
  String? textTransform;

  _TextSchemaState stateFor(List<TwVariantType> tokenVariants) {
    if (tokenVariants.isEmpty) return this;

    final key = _variantKey(tokenVariants);
    variantTypes.putIfAbsent(key, () => List.unmodifiable(tokenVariants));
    return variants.putIfAbsent(key, _TextSchemaState.new);
  }

  void applyResolvedProperty(TwProperty property, TwValue value) {
    switch (property) {
      case TwProperty.textColor:
        style.setColor((value as TwColorValue).color);
        break;
      case TwProperty.fontSize:
        style.setFontSize((value as TwLengthValue).value);
        break;
      case TwProperty.fontWeight:
        style.setFontWeight((value as TwEnumValue<FontWeight>).value);
        break;
      case TwProperty.textShadow:
        final shadows = _resolveTextShadowMixes(value);
        if (shadows != null) {
          style.setShadows(shadows);
        }
        break;
      case TwProperty.lineHeight:
        style.setHeight((value as TwLengthValue).value);
        break;
      case TwProperty.letterSpacing:
        style.setLetterSpacing((value as TwLengthValue).value);
        break;
      case TwProperty.textTransform:
        textTransform = (value as TwEnumValue<String>).value;
        break;
      case TwProperty.textAlign:
        textAlign = (value as TwEnumValue<TextAlign>).value.name;
        break;
      case TwProperty.textOverflow:
        overflow = TextOverflow.ellipsis.name;
        maxLines = 1;
        softWrap = false;
        break;
      default:
        break;
    }
  }

  bool applyFallbackToken(
    String token,
    TwConfig config,
    TokenWarningCallback? onUnsupported,
  ) {
    if (token == 'leading-even') {
      textHeightBehavior = {'leadingDistribution': 'even'};
      return true;
    }
    if (token == 'leading-trim') {
      textHeightBehavior = {
        'leadingDistribution': 'even',
        'applyHeightToFirstAscent': false,
        'applyHeightToLastDescent': false,
      };
      return true;
    }
    if (_isAnimationToken(token)) {
      return true;
    }

    if (token.startsWith('text-')) {
      final key = token.substring(5);
      final size = config.fontSizeOf(key, fallback: -1);
      if (size > 0) {
        style.setFontSize(size);
        final lineHeight = tailwindLineHeights[key];
        if (lineHeight != null) {
          style.setHeight(lineHeight);
        }
        return true;
      }

      final color = config.colorOf(key);
      if (color != null) {
        style.setColor(color);
        return true;
      }
    }

    onUnsupported?.call(token);
    return false;
  }

  JsonMap buildStylePayload() {
    final payload = <String, Object?>{};
    final builtVariants = <JsonMap>[];

    if (style.hasAny) payload['style'] = style.build();
    if (overflow != null) payload['overflow'] = overflow;
    if (textAlign != null) payload['textAlign'] = textAlign;
    if (maxLines != null) payload['maxLines'] = maxLines;
    if (softWrap != null) payload['softWrap'] = softWrap;
    if (textHeightBehavior != null) {
      payload['textHeightBehavior'] = Map<String, Object?>.from(
        textHeightBehavior!,
      );
    }
    if (textTransform != null) payload['textTransform'] = textTransform;

    for (final entry in variants.entries) {
      builtVariants.add(
        _wrapVariantStyle(
          variantTypes[entry.key]!,
          entry.value.buildStylePayload(),
        ),
      );
    }

    if (builtVariants.isNotEmpty) payload['variants'] = builtVariants;

    return payload;
  }
}

JsonMap _wrapVariantStyle(List<TwVariantType> variants, JsonMap style) {
  if (variants.length == 1) {
    return {..._variantConditionPayload(variants.single), 'style': style};
  }

  return {
    'type': _contextAllOfType,
    'conditions': [
      for (final variant in variants) _variantConditionPayload(variant),
    ],
    'style': style,
  };
}

void _setAllEdges(Map<String, Object?> target, double value) {
  target['top'] = value;
  target['right'] = value;
  target['bottom'] = value;
  target['left'] = value;
}

void _setHorizontalEdges(Map<String, Object?> target, double value) {
  target['left'] = value;
  target['right'] = value;
}

void _setVerticalEdges(Map<String, Object?> target, double value) {
  target['top'] = value;
  target['bottom'] = value;
}

final class _TwSchemaEmitter {
  _TwSchemaEmitter({
    required this.config,
    required this.resolver,
    required this.onUnsupported,
  });

  final TwConfig config;
  final TwResolver resolver;
  final TokenWarningCallback? onUnsupported;

  FlexBoxStyler parseFlex(List<String> tokens) =>
      parseFlexResult(tokens).styler ?? FlexBoxStyler();

  TwParseResult<FlexBoxStyler> parseFlexResult(
    List<String> tokens, {
    List<TwDiagnostic> diagnostics = const [],
  }) {
    var hasBaseFlex = false;
    final root = _BoxLikeSchemaState(isFlex: true);

    for (final token in tokens) {
      final colonIndex = findLastColonOutsideBrackets(token);
      final prefix = colonIndex > 0 ? token.substring(0, colonIndex) : '';
      final baseToken = colonIndex > 0
          ? token.substring(colonIndex + 1)
          : token;

      if (prefix.isEmpty &&
          (baseToken == 'flex' ||
              baseToken == 'flex-row' ||
              baseToken == 'flex-col')) {
        hasBaseFlex = true;
      }

      if (_isGradientToken(baseToken)) {
        if (prefix.isEmpty) {
          _accumulateGradient(root.gradient, baseToken, config);
        } else {
          onUnsupported?.call(token);
        }
        continue;
      }

      if (_isBorderToken(baseToken, config)) {
        if (!_hasOnlyKnownPrefixParts(prefix, config)) {
          onUnsupported?.call(token);
          continue;
        }
        final target = root.stateFor(resolver.parseVariantPrefix(prefix));
        _accumulateBorder(target.decoration.border, baseToken, config);
        continue;
      }

      final parsed = resolver.resolveToken(token);
      if (parsed != null && parsed.isNotEmpty) {
        for (final entry in parsed) {
          final target = root.stateFor(entry.variants);
          target.applyResolvedProperty(entry.property, entry.value, config);
        }
        continue;
      }

      if (!_hasOnlyKnownPrefixParts(prefix, config)) {
        onUnsupported?.call(token);
        continue;
      }

      final target = root.stateFor(resolver.parseVariantPrefix(prefix));
      target.applyFallbackToken(
        baseToken,
        config,
        onUnsupported,
        allowFlexSizingNoops: true,
      );
    }

    if (!hasBaseFlex) {
      root.direction = Axis.vertical.name;
    }

    root.decoration.gradient = _buildGradientPayload(
      root.gradient,
      config.gradientStrategy,
    );

    final built = root.buildStylePayload(
      config: config,
      inheritedTransform: _TransformAccum(),
    );
    return _TwSchemaDecoderAdapter.tryDecodeFlexBox({
      'type': _flexBoxType,
      ...built.payload,
    }, diagnostics: diagnostics);
  }

  BoxStyler parseBox(List<String> tokens) =>
      parseBoxResult(tokens).styler ?? BoxStyler();

  TwParseResult<BoxStyler> parseBoxResult(
    List<String> tokens, {
    List<TwDiagnostic> diagnostics = const [],
  }) {
    final root = _BoxLikeSchemaState(isFlex: false);

    for (final token in tokens) {
      final colonIndex = findLastColonOutsideBrackets(token);
      final prefix = colonIndex > 0 ? token.substring(0, colonIndex) : '';
      final baseToken = colonIndex > 0
          ? token.substring(colonIndex + 1)
          : token;

      if (_isGradientToken(baseToken)) {
        if (prefix.isEmpty) {
          _accumulateGradient(root.gradient, baseToken, config);
        } else {
          onUnsupported?.call(token);
        }
        continue;
      }

      if (_isBorderToken(baseToken, config)) {
        if (!_hasOnlyKnownPrefixParts(prefix, config)) {
          onUnsupported?.call(token);
          continue;
        }
        final target = root.stateFor(resolver.parseVariantPrefix(prefix));
        _accumulateBorder(target.decoration.border, baseToken, config);
        continue;
      }

      final parsed = resolver.resolveToken(token);
      if (parsed != null && parsed.isNotEmpty) {
        for (final entry in parsed) {
          final target = root.stateFor(entry.variants);
          target.applyResolvedProperty(entry.property, entry.value, config);
        }
        continue;
      }

      if (!_hasOnlyKnownPrefixParts(prefix, config)) {
        onUnsupported?.call(token);
        continue;
      }

      final target = root.stateFor(resolver.parseVariantPrefix(prefix));
      target.applyFallbackToken(
        baseToken,
        config,
        onUnsupported,
        allowFlexSizingNoops: false,
      );
    }

    root.decoration.gradient = _buildGradientPayload(
      root.gradient,
      config.gradientStrategy,
    );

    final built = root.buildStylePayload(
      config: config,
      inheritedTransform: _TransformAccum(),
    );
    return _TwSchemaDecoderAdapter.tryDecodeBox({
      'type': _boxType,
      ...built.payload,
    }, diagnostics: diagnostics);
  }

  TextStyler parseText(List<String> tokens) =>
      parseTextResult(tokens).styler ?? TextStyler();

  TwParseResult<TextStyler> parseTextResult(
    List<String> tokens, {
    List<TwDiagnostic> diagnostics = const [],
  }) {
    final root = _TextSchemaState();
    root.style.setHeight(config.textDefaults.lineHeight);

    for (final token in tokens) {
      final parsed = resolver.resolveToken(token);
      if (parsed != null && parsed.isNotEmpty) {
        for (final entry in parsed) {
          final target = root.stateFor(entry.variants);
          target.applyResolvedProperty(entry.property, entry.value);
        }
        continue;
      }

      final colonIndex = findLastColonOutsideBrackets(token);
      final prefix = colonIndex > 0 ? token.substring(0, colonIndex) : '';
      final baseToken = colonIndex > 0
          ? token.substring(colonIndex + 1)
          : token;

      if (!_hasOnlyKnownPrefixParts(prefix, config)) {
        onUnsupported?.call(token);
        continue;
      }

      final target = root.stateFor(resolver.parseVariantPrefix(prefix));
      target.applyFallbackToken(baseToken, config, onUnsupported);
    }

    return _TwSchemaDecoderAdapter.tryDecodeText({
      'type': _textType,
      ...root.buildStylePayload(),
    }, diagnostics: diagnostics);
  }
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
    : _resolver = TwResolver(config, onUnknownVariant: (_) {});

  /// Pre-compiled regex for splitting class names by whitespace.
  static final _whitespaceRegex = RegExp(r'\s+');

  final TwConfig config;
  final TokenWarningCallback? onUnsupported;
  final TwResolver _resolver;

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

  /// Parses Tailwind class names into a [FlexBoxStyler].
  ///
  /// Convenience method: swallows schema validation errors and returns an
  /// empty styler on failure. Call [parseFlexResult] instead if you need to
  /// surface diagnostics, schema errors, or the underlying schema payload.
  FlexBoxStyler parseFlex(String classNames) {
    return _TwSchemaEmitter(
      config: config,
      resolver: _resolver,
      onUnsupported: onUnsupported,
    ).parseFlex(listTokens(classNames));
  }

  TwParseResult<FlexBoxStyler> parseFlexResult(String classNames) {
    final diagnostics = <TwDiagnostic>[];
    final emitter = _diagnosticEmitter(diagnostics);

    return emitter.parseFlexResult(
      listTokens(classNames),
      diagnostics: diagnostics,
    );
  }

  /// Parses Tailwind class names into a [BoxStyler].
  ///
  /// Convenience method: swallows schema validation errors and returns an
  /// empty styler on failure. Call [parseBoxResult] instead if you need to
  /// surface diagnostics, schema errors, or the underlying schema payload.
  BoxStyler parseBox(String classNames) {
    return _TwSchemaEmitter(
      config: config,
      resolver: _resolver,
      onUnsupported: onUnsupported,
    ).parseBox(listTokens(classNames));
  }

  TwParseResult<BoxStyler> parseBoxResult(String classNames) {
    final diagnostics = <TwDiagnostic>[];
    final emitter = _diagnosticEmitter(diagnostics);

    return emitter.parseBoxResult(
      listTokens(classNames),
      diagnostics: diagnostics,
    );
  }

  /// Parses Tailwind class names into a [TextStyler].
  ///
  /// Convenience method: swallows schema validation errors and returns an
  /// empty styler on failure. Call [parseTextResult] instead if you need to
  /// surface diagnostics, schema errors, or the underlying schema payload.
  TextStyler parseText(String classNames) {
    return _TwSchemaEmitter(
      config: config,
      resolver: _resolver,
      onUnsupported: onUnsupported,
    ).parseText(listTokens(classNames));
  }

  TwParseResult<TextStyler> parseTextResult(String classNames) {
    final diagnostics = <TwDiagnostic>[];
    final emitter = _diagnosticEmitter(diagnostics);

    return emitter.parseTextResult(
      listTokens(classNames),
      diagnostics: diagnostics,
    );
  }

  _TwSchemaEmitter _diagnosticEmitter(List<TwDiagnostic> diagnostics) {
    final callback = (String token) {
      final colonIndex = findLastColonOutsideBrackets(token);
      final prefix = colonIndex > 0 ? token.substring(0, colonIndex) : '';
      final hasUnknownVariant =
          prefix.isNotEmpty && !_hasOnlyKnownPrefixParts(prefix, config);
      diagnostics.add(
        TwDiagnostic(
          code: hasUnknownVariant
              ? TwDiagnosticCode.unknownVariant
              : TwDiagnosticCode.unknownToken,
          token: token,
          message: hasUnknownVariant
              ? 'Unknown variant prefix in "$token".'
              : 'Unsupported Tailwind token "$token".',
        ),
      );
      onUnsupported?.call(token);
    };

    return _TwSchemaEmitter(
      config: config,
      resolver: TwResolver(config, onUnknownVariant: (_) {}),
      onUnsupported: callback,
    );
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
}

bool _isFullOrScreenKey(String key) => key == 'full' || key == 'screen';
