import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../ast/schema_node.dart';
import '../../ast/schema_values.dart';
import '../../validate/diagnostics.dart';
import '../render_context.dart';

/// Apply container-level style properties to a BoxStyler.
///
/// FlexHandler and StackHandler use their own typed versions since
/// FlexBoxStyler and StackBoxStyler are siblings (not subtypes of BoxStyler),
/// but share the same method names via mixins.
BoxStyler applyContainerStyle(
  BoxStyler styler,
  Map<String, SchemaValue>? style,
  RenderContext ctx,
  BuildContext context,
) {
  if (style == null) return styler;

  for (final entry in style.entries) {
    final resolved = ctx.resolveValue<dynamic>(entry.value, context);
    if (resolved == null) continue;

    styler = switch (entry.key) {
      // Colors
      'backgroundColor' => _applyColor(styler, resolved),

      // Spacing
      'padding' => styler.paddingAll(_toDouble(resolved)),
      'paddingX' => styler.paddingX(_toDouble(resolved)),
      'paddingY' => styler.paddingY(_toDouble(resolved)),
      'paddingTop' => styler.paddingTop(_toDouble(resolved)),
      'paddingBottom' => styler.paddingBottom(_toDouble(resolved)),
      'paddingLeft' => styler.paddingLeft(_toDouble(resolved)),
      'paddingRight' => styler.paddingRight(_toDouble(resolved)),
      'margin' => styler.marginAll(_toDouble(resolved)),
      'marginX' => styler.marginX(_toDouble(resolved)),
      'marginY' => styler.marginY(_toDouble(resolved)),

      // Sizing
      'width' => styler.width(_toDouble(resolved)),
      'height' => styler.height(_toDouble(resolved)),
      'minWidth' => styler.minWidth(_toDouble(resolved)),
      'maxWidth' => styler.maxWidth(_toDouble(resolved)),
      'minHeight' => styler.minHeight(_toDouble(resolved)),
      'maxHeight' => styler.maxHeight(_toDouble(resolved)),

      // Border
      'borderRadius' => styler.borderRounded(_toDouble(resolved)),

      // Clip
      'clipBehavior' =>
        styler.clipBehavior(parseClip(resolved as String)),

      // Unknown: skip with diagnostic
      _ => skipUnknown(styler, entry.key, ctx),
    };
  }
  return styler;
}

/// Apply container-level style properties to a FlexBoxStyler.
FlexBoxStyler applyFlexContainerStyle(
  FlexBoxStyler styler,
  Map<String, SchemaValue>? style,
  RenderContext ctx,
  BuildContext context,
) {
  if (style == null) return styler;

  for (final entry in style.entries) {
    final resolved = ctx.resolveValue<dynamic>(entry.value, context);
    if (resolved == null) continue;

    styler = switch (entry.key) {
      'backgroundColor' => _applyColorFlex(styler, resolved),
      'padding' => styler.paddingAll(_toDouble(resolved)),
      'paddingX' => styler.paddingX(_toDouble(resolved)),
      'paddingY' => styler.paddingY(_toDouble(resolved)),
      'margin' => styler.marginAll(_toDouble(resolved)),
      'width' => styler.width(_toDouble(resolved)),
      'height' => styler.height(_toDouble(resolved)),
      'minWidth' => styler.minWidth(_toDouble(resolved)),
      'maxWidth' => styler.maxWidth(_toDouble(resolved)),
      'minHeight' => styler.minHeight(_toDouble(resolved)),
      'maxHeight' => styler.maxHeight(_toDouble(resolved)),
      'borderRadius' => styler.borderRounded(_toDouble(resolved)),
      _ => skipUnknown(styler, entry.key, ctx),
    };
  }
  return styler;
}

/// Apply container-level style properties to a StackBoxStyler.
StackBoxStyler applyStackContainerStyle(
  StackBoxStyler styler,
  Map<String, SchemaValue>? style,
  RenderContext ctx,
  BuildContext context,
) {
  if (style == null) return styler;

  for (final entry in style.entries) {
    final resolved = ctx.resolveValue<dynamic>(entry.value, context);
    if (resolved == null) continue;

    styler = switch (entry.key) {
      'backgroundColor' => _applyColorStack(styler, resolved),
      'padding' => styler.paddingAll(_toDouble(resolved)),
      'paddingX' => styler.paddingX(_toDouble(resolved)),
      'paddingY' => styler.paddingY(_toDouble(resolved)),
      'margin' => styler.marginAll(_toDouble(resolved)),
      'width' => styler.width(_toDouble(resolved)),
      'height' => styler.height(_toDouble(resolved)),
      'minWidth' => styler.minWidth(_toDouble(resolved)),
      'maxWidth' => styler.maxWidth(_toDouble(resolved)),
      'minHeight' => styler.minHeight(_toDouble(resolved)),
      'maxHeight' => styler.maxHeight(_toDouble(resolved)),
      'borderRadius' => styler.borderRounded(_toDouble(resolved)),
      _ => skipUnknown(styler, entry.key, ctx),
    };
  }
  return styler;
}

/// Apply text-level style properties to a TextStyler.
TextStyler applyTextStyle(
  TextStyler styler,
  Map<String, SchemaValue>? style,
  RenderContext ctx,
  BuildContext context,
) {
  if (style == null) return styler;

  for (final entry in style.entries) {
    final resolved = ctx.resolveValue<dynamic>(entry.value, context);
    if (resolved == null) continue;

    styler = switch (entry.key) {
      'color' => _applyTextColor(styler, resolved),
      'fontSize' => styler.fontSize(_toDouble(resolved)),
      'fontWeight' => styler.fontWeight(parseFontWeight(resolved)),
      'lineHeight' => styler.height(_toDouble(resolved)),
      'letterSpacing' => styler.letterSpacing(_toDouble(resolved)),
      'overflow' =>
        styler.overflow(parseTextOverflow(resolved as String)),
      'maxLines' => styler.maxLines(_toInt(resolved)),
      _ => skipUnknown(styler, entry.key, ctx),
    };
  }
  return styler;
}

/// Apply icon-level style properties to an IconStyler.
IconStyler applyIconStyle(
  IconStyler styler,
  Map<String, SchemaValue>? style,
  RenderContext ctx,
  BuildContext context,
) {
  if (style == null) return styler;

  for (final entry in style.entries) {
    final resolved = ctx.resolveValue<dynamic>(entry.value, context);
    if (resolved == null) continue;

    styler = switch (entry.key) {
      'color' => _applyIconColor(styler, resolved),
      'size' => styler.size(_toDouble(resolved)),
      _ => skipUnknown(styler, entry.key, ctx),
    };
  }
  return styler;
}

// --- Concrete variant + animation helpers per Styler type ---
// MixStyler is package-private in Mix, so generic helpers can't access
// onHovered/onDark/animate. Instead we provide concrete typed versions.

Map<String, SchemaValue>? _extractVariantStyle(SchemaValue value) {
  return switch (value) {
    DirectValue<Map<String, SchemaValue>>(value: final v) => v,
    _ => null,
  };
}

CurveAnimationConfig? _buildAnimConfig(SchemaAnimation? anim) {
  if (anim == null) return null;
  return CurveAnimationConfig(
    duration: Duration(milliseconds: anim.durationMs),
    curve: parseCurve(anim.curve),
    delay: anim.delayMs != null
        ? Duration(milliseconds: anim.delayMs!)
        : Duration.zero,
  );
}

// -- BoxStyler variants + animation --

BoxStyler applyBoxVariants(
  BoxStyler styler,
  Map<String, SchemaValue>? variants,
  RenderContext ctx,
  BuildContext context,
) {
  if (variants == null) return styler;
  for (final entry in variants.entries) {
    final vs = _extractVariantStyle(entry.value);
    if (vs == null) continue;
    final v = applyContainerStyle(BoxStyler(), vs, ctx, context);
    styler = _applyVariantByName(styler, entry.key, v);
  }
  return styler;
}

BoxStyler applyBoxAnimation(BoxStyler styler, SchemaAnimation? anim) {
  final config = _buildAnimConfig(anim);
  return config != null ? styler.animate(config) : styler;
}

// -- TextStyler variants + animation --

TextStyler applyTextVariants(
  TextStyler styler,
  Map<String, SchemaValue>? variants,
  RenderContext ctx,
  BuildContext context,
) {
  if (variants == null) return styler;
  for (final entry in variants.entries) {
    final vs = _extractVariantStyle(entry.value);
    if (vs == null) continue;
    final v = applyTextStyle(TextStyler(), vs, ctx, context);
    styler = _applyVariantByName(styler, entry.key, v);
  }
  return styler;
}

TextStyler applyTextAnimation(TextStyler styler, SchemaAnimation? anim) {
  final config = _buildAnimConfig(anim);
  return config != null ? styler.animate(config) : styler;
}

// -- FlexBoxStyler variants + animation --

FlexBoxStyler applyFlexVariants(
  FlexBoxStyler styler,
  Map<String, SchemaValue>? variants,
  RenderContext ctx,
  BuildContext context,
) {
  if (variants == null) return styler;
  for (final entry in variants.entries) {
    final vs = _extractVariantStyle(entry.value);
    if (vs == null) continue;
    final v = applyFlexContainerStyle(FlexBoxStyler(), vs, ctx, context);
    styler = _applyVariantByName(styler, entry.key, v);
  }
  return styler;
}

FlexBoxStyler applyFlexAnimation(
    FlexBoxStyler styler, SchemaAnimation? anim) {
  final config = _buildAnimConfig(anim);
  return config != null ? styler.animate(config) : styler;
}

// -- StackBoxStyler variants + animation --

StackBoxStyler applyStackVariants(
  StackBoxStyler styler,
  Map<String, SchemaValue>? variants,
  RenderContext ctx,
  BuildContext context,
) {
  if (variants == null) return styler;
  for (final entry in variants.entries) {
    final vs = _extractVariantStyle(entry.value);
    if (vs == null) continue;
    final v = applyStackContainerStyle(StackBoxStyler(), vs, ctx, context);
    styler = _applyVariantByName(styler, entry.key, v);
  }
  return styler;
}

StackBoxStyler applyStackAnimation(
    StackBoxStyler styler, SchemaAnimation? anim) {
  final config = _buildAnimConfig(anim);
  return config != null ? styler.animate(config) : styler;
}

// -- IconStyler animation (no variants for icons in v0.1) --

IconStyler applyIconAnimation(IconStyler styler, SchemaAnimation? anim) {
  final config = _buildAnimConfig(anim);
  return config != null ? styler.animate(config) : styler;
}

/// Apply a named variant to any styler that has the variant mixin methods.
/// All concrete stylers have the same method names, so this works for any T
/// that extends a MixStyler with VariantStyleMixin + WidgetStateVariantMixin.
T _applyVariantByName<T>(T styler, String name, T variantStyler) {
  // We need to call onHovered/onDark/etc on the concrete type.
  // Since MixStyler is private, we pattern-match on the concrete type.
  if (styler is BoxStyler) {
    return _boxVariant(styler, name, variantStyler as BoxStyler) as T;
  }
  if (styler is TextStyler) {
    return _textVariant(styler, name, variantStyler as TextStyler) as T;
  }
  if (styler is FlexBoxStyler) {
    return _flexVariant(styler, name, variantStyler as FlexBoxStyler) as T;
  }
  if (styler is StackBoxStyler) {
    return _stackVariant(styler, name, variantStyler as StackBoxStyler) as T;
  }
  return styler;
}

BoxStyler _boxVariant(BoxStyler s, String name, BoxStyler v) => switch (name) {
      'hover' || 'hovered' => s.onHovered(v),
      'press' || 'pressed' => s.onPressed(v),
      'focus' || 'focused' => s.onFocused(v),
      'disabled' => s.onDisabled(v),
      'enabled' => s.onEnabled(v),
      'dark' => s.onDark(v),
      'light' => s.onLight(v),
      'mobile' => s.onMobile(v),
      'tablet' => s.onTablet(v),
      'desktop' => s.onDesktop(v),
      _ => s,
    };

TextStyler _textVariant(TextStyler s, String name, TextStyler v) =>
    switch (name) {
      'hover' || 'hovered' => s.onHovered(v),
      'press' || 'pressed' => s.onPressed(v),
      'focus' || 'focused' => s.onFocused(v),
      'disabled' => s.onDisabled(v),
      'enabled' => s.onEnabled(v),
      'dark' => s.onDark(v),
      'light' => s.onLight(v),
      'mobile' => s.onMobile(v),
      'tablet' => s.onTablet(v),
      'desktop' => s.onDesktop(v),
      _ => s,
    };

FlexBoxStyler _flexVariant(FlexBoxStyler s, String name, FlexBoxStyler v) =>
    switch (name) {
      'hover' || 'hovered' => s.onHovered(v),
      'press' || 'pressed' => s.onPressed(v),
      'focus' || 'focused' => s.onFocused(v),
      'disabled' => s.onDisabled(v),
      'enabled' => s.onEnabled(v),
      'dark' => s.onDark(v),
      'light' => s.onLight(v),
      'mobile' => s.onMobile(v),
      'tablet' => s.onTablet(v),
      'desktop' => s.onDesktop(v),
      _ => s,
    };

StackBoxStyler _stackVariant(
        StackBoxStyler s, String name, StackBoxStyler v) =>
    switch (name) {
      'hover' || 'hovered' => s.onHovered(v),
      'press' || 'pressed' => s.onPressed(v),
      'focus' || 'focused' => s.onFocused(v),
      'disabled' => s.onDisabled(v),
      'enabled' => s.onEnabled(v),
      'dark' => s.onDark(v),
      'light' => s.onLight(v),
      'mobile' => s.onMobile(v),
      'tablet' => s.onTablet(v),
      'desktop' => s.onDesktop(v),
      _ => s,
    };

/// Emit a diagnostic for an unknown style property and return styler unchanged.
T skipUnknown<T>(T styler, String property, RenderContext ctx) {
  ctx.diagnostics.add(SchemaDiagnostic(
    code: DiagnosticCode.invalidValueType,
    severity: DiagnosticSeverity.info,
    message: 'Unknown style property "$property" — skipped',
    suggestion: 'Check supported properties for this node type',
  ));
  return styler;
}

// --- Color helpers (typed per-styler due to sibling hierarchy) ---

BoxStyler _applyColor(BoxStyler styler, dynamic resolved) {
  final color = _parseColor(resolved);
  return color != null ? styler.color(color) : styler;
}

FlexBoxStyler _applyColorFlex(FlexBoxStyler styler, dynamic resolved) {
  final color = _parseColor(resolved);
  return color != null ? styler.color(color) : styler;
}

StackBoxStyler _applyColorStack(StackBoxStyler styler, dynamic resolved) {
  final color = _parseColor(resolved);
  return color != null ? styler.color(color) : styler;
}

TextStyler _applyTextColor(TextStyler styler, dynamic resolved) {
  final color = _parseColor(resolved);
  return color != null ? styler.color(color) : styler;
}

IconStyler _applyIconColor(IconStyler styler, dynamic resolved) {
  final color = _parseColor(resolved);
  return color != null ? styler.color(color) : styler;
}

// --- Parsers ---

Color? _parseColor(dynamic resolved) {
  if (resolved is Color) return resolved;
  if (resolved is String) {
    // Parse hex color: "#RRGGBB" or "#AARRGGBB"
    final hex = resolved.replaceFirst('#', '');
    final intVal = int.tryParse(hex, radix: 16);
    if (intVal != null) {
      if (hex.length == 6) {
        return Color(0xFF000000 | intVal);
      }
      if (hex.length == 8) {
        return Color(intVal);
      }
    }
  }
  return null;
}

double _toDouble(dynamic v) {
  if (v is double) return v;
  if (v is num) return v.toDouble();
  return 0.0;
}

int _toInt(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  return 0;
}

FontWeight parseFontWeight(dynamic value) {
  return switch (value) {
    FontWeight w => w,
    'thin' || 'w100' || '100' => FontWeight.w100,
    'extraLight' || 'w200' || '200' => FontWeight.w200,
    'light' || 'w300' || '300' => FontWeight.w300,
    'normal' || 'regular' || 'w400' || '400' => FontWeight.w400,
    'medium' || 'w500' || '500' => FontWeight.w500,
    'semiBold' || 'w600' || '600' => FontWeight.w600,
    'bold' || 'w700' || '700' => FontWeight.w700,
    'extraBold' || 'w800' || '800' => FontWeight.w800,
    'black' || 'w900' || '900' => FontWeight.w900,
    _ => FontWeight.w400,
  };
}

TextOverflow parseTextOverflow(String value) => switch (value) {
      'ellipsis' => TextOverflow.ellipsis,
      'clip' => TextOverflow.clip,
      'fade' => TextOverflow.fade,
      'visible' => TextOverflow.visible,
      _ => TextOverflow.clip,
    };

Clip parseClip(String value) => switch (value) {
      'none' => Clip.none,
      'hardEdge' => Clip.hardEdge,
      'antiAlias' => Clip.antiAlias,
      'antiAliasWithSaveLayer' => Clip.antiAliasWithSaveLayer,
      _ => Clip.none,
    };

CrossAxisAlignment parseCrossAxis(String value) => switch (value) {
      'start' => CrossAxisAlignment.start,
      'end' => CrossAxisAlignment.end,
      'center' => CrossAxisAlignment.center,
      'stretch' => CrossAxisAlignment.stretch,
      'baseline' => CrossAxisAlignment.baseline,
      _ => CrossAxisAlignment.start,
    };

MainAxisAlignment parseMainAxis(String value) => switch (value) {
      'start' => MainAxisAlignment.start,
      'end' => MainAxisAlignment.end,
      'center' => MainAxisAlignment.center,
      'spaceBetween' => MainAxisAlignment.spaceBetween,
      'spaceAround' => MainAxisAlignment.spaceAround,
      'spaceEvenly' => MainAxisAlignment.spaceEvenly,
      _ => MainAxisAlignment.start,
    };

AlignmentGeometry parseAlignment(String value) => switch (value) {
      'topLeft' => Alignment.topLeft,
      'topCenter' => Alignment.topCenter,
      'topRight' => Alignment.topRight,
      'centerLeft' => Alignment.centerLeft,
      'center' => Alignment.center,
      'centerRight' => Alignment.centerRight,
      'bottomLeft' => Alignment.bottomLeft,
      'bottomCenter' => Alignment.bottomCenter,
      'bottomRight' => Alignment.bottomRight,
      _ => Alignment.center,
    };

Curve parseCurve(String? name) => switch (name) {
      'linear' => Curves.linear,
      'easeIn' => Curves.easeIn,
      'easeOut' => Curves.easeOut,
      'easeInOut' => Curves.easeInOut,
      'bounceIn' => Curves.bounceIn,
      'bounceOut' => Curves.bounceOut,
      'elasticIn' => Curves.elasticIn,
      'elasticOut' => Curves.elasticOut,
      _ => Curves.easeOut, // default
    };

/// Resolve a Material Icons icon name to IconData.
IconData resolveIconData(dynamic value) {
  if (value is IconData) return value;
  if (value is int) return IconData(value, fontFamily: 'MaterialIcons');
  // String icon names: try to match common material icons
  // For now, return a default icon. A full icon registry could be added.
  return Icons.help_outline;
}
