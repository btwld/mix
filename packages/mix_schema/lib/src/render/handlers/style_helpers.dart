import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show OrdinalSortKey;
import 'package:mix/mix.dart';

import '../../ast/schema_node.dart';
import '../../ast/schema_values.dart';
import '../../validate/diagnostics.dart';
import '../render_context.dart';

// ---------------------------------------------------------------------------
// Style application helpers
// ---------------------------------------------------------------------------

/// Apply container-level style properties to a BoxStyler.
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
      'color' || 'backgroundColor' =>
        _applyColorTo(styler, resolved, (s, c) => s.color(c)),
      'padding' => styler.paddingAll(toDouble(resolved)),
      'paddingX' => styler.paddingX(toDouble(resolved)),
      'paddingY' => styler.paddingY(toDouble(resolved)),
      'paddingTop' => styler.paddingTop(toDouble(resolved)),
      'paddingBottom' => styler.paddingBottom(toDouble(resolved)),
      'paddingLeft' => styler.paddingLeft(toDouble(resolved)),
      'paddingRight' => styler.paddingRight(toDouble(resolved)),
      'margin' => styler.marginAll(toDouble(resolved)),
      'marginX' => styler.marginX(toDouble(resolved)),
      'marginY' => styler.marginY(toDouble(resolved)),
      'width' => styler.width(toDouble(resolved)),
      'height' => styler.height(toDouble(resolved)),
      'minWidth' => styler.minWidth(toDouble(resolved)),
      'maxWidth' => styler.maxWidth(toDouble(resolved)),
      'minHeight' => styler.minHeight(toDouble(resolved)),
      'maxHeight' => styler.maxHeight(toDouble(resolved)),
      'borderRadius' => styler.borderRounded(toDouble(resolved)),
      'clipBehavior' =>
        styler.clipBehavior(parseClip(resolved as String)),
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
      'color' || 'backgroundColor' =>
        _applyColorTo(styler, resolved, (s, c) => s.color(c)),
      'padding' => styler.paddingAll(toDouble(resolved)),
      'paddingX' => styler.paddingX(toDouble(resolved)),
      'paddingY' => styler.paddingY(toDouble(resolved)),
      'margin' => styler.marginAll(toDouble(resolved)),
      'width' => styler.width(toDouble(resolved)),
      'height' => styler.height(toDouble(resolved)),
      'minWidth' => styler.minWidth(toDouble(resolved)),
      'maxWidth' => styler.maxWidth(toDouble(resolved)),
      'minHeight' => styler.minHeight(toDouble(resolved)),
      'maxHeight' => styler.maxHeight(toDouble(resolved)),
      'borderRadius' => styler.borderRounded(toDouble(resolved)),
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
      'color' || 'backgroundColor' =>
        _applyColorTo(styler, resolved, (s, c) => s.color(c)),
      'padding' => styler.paddingAll(toDouble(resolved)),
      'paddingX' => styler.paddingX(toDouble(resolved)),
      'paddingY' => styler.paddingY(toDouble(resolved)),
      'margin' => styler.marginAll(toDouble(resolved)),
      'width' => styler.width(toDouble(resolved)),
      'height' => styler.height(toDouble(resolved)),
      'minWidth' => styler.minWidth(toDouble(resolved)),
      'maxWidth' => styler.maxWidth(toDouble(resolved)),
      'minHeight' => styler.minHeight(toDouble(resolved)),
      'maxHeight' => styler.maxHeight(toDouble(resolved)),
      'borderRadius' => styler.borderRounded(toDouble(resolved)),
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
      'color' => _applyColorTo(styler, resolved, (s, c) => s.color(c)),
      'fontSize' => styler.fontSize(toDouble(resolved)),
      'fontWeight' => styler.fontWeight(parseFontWeight(resolved)),
      'lineHeight' => styler.height(toDouble(resolved)),
      'letterSpacing' => styler.letterSpacing(toDouble(resolved)),
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
      'color' => _applyColorTo(styler, resolved, (s, c) => s.color(c)),
      'size' => styler.size(toDouble(resolved)),
      _ => skipUnknown(styler, entry.key, ctx),
    };
  }
  return styler;
}

// ---------------------------------------------------------------------------
// Variant + animation helpers
// ---------------------------------------------------------------------------

// All Mix stylers share .animate() and variant methods via mixins but have
// no common supertype accessible from outside the package. We use dynamic
// dispatch for animate (single method, no branching needed) and typed
// dispatch for variants (which need concrete styler constructors).

/// Apply animation config to any styler. Works via dynamic dispatch since
/// all Mix stylers expose `.animate(CurveAnimationConfig)`.
T applyAnimation<T>(T styler, SchemaAnimation? anim) {
  if (anim == null) return styler;
  final config = CurveAnimationConfig(
    duration: Duration(milliseconds: anim.durationMs),
    curve: parseCurve(anim.curve),
    delay: anim.delayMs != null
        ? Duration(milliseconds: anim.delayMs!)
        : Duration.zero,
  );
  return (styler as dynamic).animate(config) as T;
}

/// Apply variants using a style-application callback to build the variant styler.
T applyVariants<T>(
  T styler,
  Map<String, SchemaValue>? variants,
  RenderContext ctx,
  BuildContext context,
  T Function(T fresh, Map<String, SchemaValue> style, RenderContext ctx,
          BuildContext context)
      applyStyle,
  T Function() createFresh,
) {
  if (variants == null) return styler;
  for (final entry in variants.entries) {
    final vs = _extractVariantStyle(entry.value);
    if (vs == null) continue;
    final v = applyStyle(createFresh(), vs, ctx, context);
    styler = _applyVariantByName(styler, entry.key, v);
  }
  return styler;
}

// Convenience wrappers for each styler type (needed because each requires
// a different style-application function and fresh constructor).

BoxStyler applyBoxVariants(
  BoxStyler styler,
  Map<String, SchemaValue>? variants,
  RenderContext ctx,
  BuildContext context,
) =>
    applyVariants(styler, variants, ctx, context, applyContainerStyle,
        BoxStyler.new);

TextStyler applyTextVariants(
  TextStyler styler,
  Map<String, SchemaValue>? variants,
  RenderContext ctx,
  BuildContext context,
) =>
    applyVariants(
        styler, variants, ctx, context, applyTextStyle, TextStyler.new);

FlexBoxStyler applyFlexVariants(
  FlexBoxStyler styler,
  Map<String, SchemaValue>? variants,
  RenderContext ctx,
  BuildContext context,
) =>
    applyVariants(styler, variants, ctx, context, applyFlexContainerStyle,
        FlexBoxStyler.new);

StackBoxStyler applyStackVariants(
  StackBoxStyler styler,
  Map<String, SchemaValue>? variants,
  RenderContext ctx,
  BuildContext context,
) =>
    applyVariants(styler, variants, ctx, context, applyStackContainerStyle,
        StackBoxStyler.new);

IconStyler applyIconVariants(
  IconStyler styler,
  Map<String, SchemaValue>? variants,
  RenderContext ctx,
  BuildContext context,
) =>
    applyVariants(
        styler, variants, ctx, context, applyIconStyle, IconStyler.new);

ImageStyler applyImageVariants(
  ImageStyler styler,
  Map<String, SchemaValue>? variants,
  RenderContext ctx,
  BuildContext context,
) =>
    applyVariants(
        styler, variants, ctx, context, _applyImageStyleProps, ImageStyler.new);

ImageStyler _applyImageStyleProps(
  ImageStyler styler,
  Map<String, SchemaValue> style,
  RenderContext ctx,
  BuildContext context,
) {
  for (final entry in style.entries) {
    final resolved = ctx.resolveValue<dynamic>(entry.value, context);
    if (resolved == null) continue;
    styler = switch (entry.key) {
      'width' => styler.width(toDouble(resolved)),
      'height' => styler.height(toDouble(resolved)),
      _ => styler,
    };
  }
  return styler;
}

Map<String, SchemaValue>? _extractVariantStyle(SchemaValue value) {
  return switch (value) {
    DirectValue<Map<String, SchemaValue>>(value: final v) => v,
    _ => null,
  };
}

/// Apply a named variant to any styler type.
T _applyVariantByName<T>(T styler, String name, T variantStyler) {
  return switch (styler) {
    BoxStyler s =>
      _variantSwitch(s, name, variantStyler as BoxStyler) as T,
    TextStyler s =>
      _variantSwitch(s, name, variantStyler as TextStyler) as T,
    FlexBoxStyler s =>
      _variantSwitch(s, name, variantStyler as FlexBoxStyler) as T,
    StackBoxStyler s =>
      _variantSwitch(s, name, variantStyler as StackBoxStyler) as T,
    ImageStyler s =>
      _variantSwitch(s, name, variantStyler as ImageStyler) as T,
    IconStyler s =>
      _variantSwitch(s, name, variantStyler as IconStyler) as T,
    _ => styler,
  };
}

/// Single variant name -> method dispatch.
S _variantSwitch<S>(dynamic s, String name, dynamic v) => switch (name) {
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
    } as S;

// ---------------------------------------------------------------------------
// Utility helpers
// ---------------------------------------------------------------------------

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

T _applyColorTo<T>(T styler, dynamic resolved, T Function(T, Color) apply) {
  final color = _parseColor(resolved);
  return color != null ? apply(styler, color) : styler;
}

// ---------------------------------------------------------------------------
// Parsers
// ---------------------------------------------------------------------------

Color? _parseColor(dynamic resolved) {
  if (resolved is Color) return resolved;
  if (resolved is String) {
    final hex = resolved.replaceFirst('#', '');
    final intVal = int.tryParse(hex, radix: 16);
    if (intVal != null) {
      if (hex.length == 6) return Color(0xFF000000 | intVal);
      if (hex.length == 8) return Color(intVal);
    }
  }
  return null;
}

double toDouble(dynamic v) {
  if (v is double) return v;
  if (v is num) return v.toDouble();
  return 0.0;
}

int _toInt(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  return 0;
}

FontWeight parseFontWeight(dynamic value) => switch (value) {
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
      _ => Curves.easeOut,
    };

/// Resolve a Material Icons icon name to IconData.
IconData resolveIconData(dynamic value) {
  if (value is IconData) return value;
  if (value is int) return IconData(value, fontFamily: 'MaterialIcons');
  if (value is String) return _iconLookup[value] ?? Icons.help_outline;
  return Icons.help_outline;
}

// ---------------------------------------------------------------------------
// Semantics helper
// ---------------------------------------------------------------------------

/// Wrap a widget with Flutter Semantics when the node has semantic metadata.
Widget wrapWithSemantics(Widget child, SchemaSemantics? semantics) {
  if (semantics == null) return child;

  final hasContent = semantics.role != null ||
      semantics.label != null ||
      semantics.hint != null ||
      semantics.value != null ||
      semantics.enabled != null ||
      semantics.selected != null ||
      semantics.checked != null ||
      semantics.expanded != null ||
      semantics.liveRegionMode != null;

  if (!hasContent) return child;

  return Semantics(
    label: semantics.label,
    hint: semantics.hint,
    value: semantics.value,
    enabled: semantics.enabled,
    selected: semantics.selected,
    checked: semantics.checked,
    expanded: semantics.expanded,
    button: semantics.role == 'button',
    header: semantics.role == 'heading',
    image: semantics.role == 'img',
    liveRegion: semantics.liveRegionMode != null,
    sortKey: semantics.focusOrder != null
        ? OrdinalSortKey(semantics.focusOrder!.toDouble())
        : null,
    child: child,
  );
}

const _iconLookup = <String, IconData>{
  'add': Icons.add,
  'arrow_back': Icons.arrow_back,
  'arrow_forward': Icons.arrow_forward,
  'check': Icons.check,
  'check_circle': Icons.check_circle,
  'close': Icons.close,
  'delete': Icons.delete,
  'edit': Icons.edit,
  'error': Icons.error,
  'favorite': Icons.favorite,
  'home': Icons.home,
  'info': Icons.info,
  'menu': Icons.menu,
  'more_vert': Icons.more_vert,
  'person': Icons.person,
  'search': Icons.search,
  'settings': Icons.settings,
  'share': Icons.share,
  'star': Icons.star,
  'visibility': Icons.visibility,
  'visibility_off': Icons.visibility_off,
  'warning': Icons.warning,
};
