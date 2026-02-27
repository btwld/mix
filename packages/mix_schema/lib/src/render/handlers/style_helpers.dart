import 'package:flutter/semantics.dart' show OrdinalSortKey;
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../ast/schema_node.dart';
import '../../ast/schema_values.dart';
import '../../validate/diagnostics.dart';
import '../render_context.dart';
import 'parsers.dart';

// Re-export parsers so existing imports continue to work.
export 'parsers.dart';

// ---------------------------------------------------------------------------
// Style application helpers
// ---------------------------------------------------------------------------

/// Apply container-level style properties to any container styler
/// (BoxStyler, FlexBoxStyler, StackBoxStyler). Uses dynamic dispatch for
/// shared methods. Box-only properties (paddingTop/Bottom/Left/Right,
/// marginX/Y, clipBehavior) are gated to BoxStyler.
T applyContainerStyleMap<T>(
  T styler,
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
        _applyColorTo(styler, resolved, (s, c) => (s as dynamic).color(c) as T),
      'padding' => (styler as dynamic).paddingAll(toDouble(resolved)) as T,
      'paddingX' => (styler as dynamic).paddingX(toDouble(resolved)) as T,
      'paddingY' => (styler as dynamic).paddingY(toDouble(resolved)) as T,
      'paddingTop' when styler is BoxStyler =>
        (styler as BoxStyler).paddingTop(toDouble(resolved)) as T,
      'paddingBottom' when styler is BoxStyler =>
        (styler as BoxStyler).paddingBottom(toDouble(resolved)) as T,
      'paddingLeft' when styler is BoxStyler =>
        (styler as BoxStyler).paddingLeft(toDouble(resolved)) as T,
      'paddingRight' when styler is BoxStyler =>
        (styler as BoxStyler).paddingRight(toDouble(resolved)) as T,
      'margin' => (styler as dynamic).marginAll(toDouble(resolved)) as T,
      'marginX' when styler is BoxStyler =>
        (styler as BoxStyler).marginX(toDouble(resolved)) as T,
      'marginY' when styler is BoxStyler =>
        (styler as BoxStyler).marginY(toDouble(resolved)) as T,
      'width' => (styler as dynamic).width(toDouble(resolved)) as T,
      'height' => (styler as dynamic).height(toDouble(resolved)) as T,
      'minWidth' => (styler as dynamic).minWidth(toDouble(resolved)) as T,
      'maxWidth' => (styler as dynamic).maxWidth(toDouble(resolved)) as T,
      'minHeight' => (styler as dynamic).minHeight(toDouble(resolved)) as T,
      'maxHeight' => (styler as dynamic).maxHeight(toDouble(resolved)) as T,
      'borderRadius' => (styler as dynamic).borderRounded(toDouble(resolved)) as T,
      'clipBehavior' when styler is BoxStyler =>
        (styler as BoxStyler).clipBehavior(parseClip(resolved as String)) as T,
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
      'maxLines' => styler.maxLines(toInt(resolved)),
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

/// Apply image-level style properties to an ImageStyler.
ImageStyler applyImageStyleMap(
  ImageStyler styler,
  Map<String, SchemaValue>? style,
  RenderContext ctx,
  BuildContext context,
) {
  if (style == null) return styler;

  for (final entry in style.entries) {
    final resolved = ctx.resolveValue<dynamic>(entry.value, context);
    if (resolved == null) continue;

    styler = switch (entry.key) {
      'width' => styler.width(toDouble(resolved)),
      'height' => styler.height(toDouble(resolved)),
      'fit' => styler.fit(parseBoxFit(resolved as String)),
      _ => skipUnknown(styler, entry.key, ctx),
    };
  }
  return styler;
}

// ---------------------------------------------------------------------------
// Variant + animation helpers
// ---------------------------------------------------------------------------

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

/// Apply variants using a style-application callback to build the variant
/// styler. Uses dynamic dispatch for the variant method (all Mix stylers
/// share .onHovered/.onPressed/etc. via mixins).
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

Map<String, SchemaValue>? _extractVariantStyle(SchemaValue value) {
  return switch (value) {
    DirectValue<Map<String, SchemaValue>>(value: final v) => v,
    _ => null,
  };
}

/// Apply a named variant to any styler via dynamic dispatch.
T _applyVariantByName<T>(T styler, String name, T variantStyler) {
  final s = styler as dynamic;
  final v = variantStyler as dynamic;
  return (switch (name) {
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
  }) as T;
}

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
  final color = parseColor(resolved);
  return color != null ? apply(styler, color) : styler;
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
