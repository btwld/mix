import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'tw_config.dart';
import 'tw_parser.dart';
import 'tw_utils.dart';

// =============================================================================
// CSS Semantic Box Widgets
// =============================================================================

/// A Box widget with CSS-style margin semantics.
///
/// In CSS, margin is outside the hit-test area - hover/press only triggers
/// on the border-box (content + padding + border). This widget extracts
/// margin from the BoxSpec and applies it OUTSIDE the MixInteractionDetector.
///
/// Widget tree structure:
/// ```
/// Padding(margin)              <- OUTSIDE hover detection
///   └── StyleBuilder
///         └── MixInteractionDetector  <- Hover detection here
///               └── Container(no margin)
/// ```
class _CssSemanticBox extends StatelessWidget {
  const _CssSemanticBox({required this.style, this.child});

  final BoxStyler style;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    // Step 1: Resolve base margin BEFORE MixInteractionDetector
    // This ensures margin is outside the hover/press detection area
    final baseSpec = style.resolve(context).spec;
    final margin = baseSpec.margin;

    // Step 2: Build inner content with StyleBuilder (handles variants/animations)
    Widget inner = StyleBuilder<BoxSpec>(
      style: style,
      builder: (context, spec) {
        // Build Container WITHOUT margin - margin is applied externally
        return Container(
          alignment: spec.alignment,
          padding: spec.padding,
          decoration: spec.decoration,
          foregroundDecoration: spec.foregroundDecoration,
          constraints: spec.constraints,
          transform: spec.transform,
          transformAlignment: spec.transformAlignment,
          clipBehavior: spec.clipBehavior ?? Clip.none,
          // NOTE: margin intentionally omitted - applied externally
          child: child,
        );
      },
    );

    // Step 3: Apply margin OUTSIDE MixInteractionDetector
    if (margin != null) {
      inner = Padding(padding: margin, child: inner);
    }

    return inner;
  }
}

/// A FlexBox widget with CSS-style margin semantics.
///
/// See [_CssSemanticBox] for details on CSS margin semantics.
class _CssSemanticFlexBox extends StatelessWidget {
  const _CssSemanticFlexBox({required this.style, required this.children});

  final FlexBoxStyler style;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // Step 1: Resolve base margin BEFORE MixInteractionDetector
    final baseSpec = style.resolve(context);
    final margin = baseSpec.spec.box?.spec.margin;

    // Step 2: Build inner content with StyleBuilder (handles variants/animations)
    Widget inner = StyleBuilder<FlexBoxSpec>(
      style: style,
      builder: (context, spec) {
        // Build Flex widget
        final flexWidget = Flex(
          direction: spec.flex?.spec.direction ?? Axis.horizontal,
          mainAxisAlignment:
              spec.flex?.spec.mainAxisAlignment ?? MainAxisAlignment.start,
          mainAxisSize: spec.flex?.spec.mainAxisSize ?? MainAxisSize.max,
          crossAxisAlignment:
              spec.flex?.spec.crossAxisAlignment ?? CrossAxisAlignment.center,
          textDirection: spec.flex?.spec.textDirection,
          verticalDirection:
              spec.flex?.spec.verticalDirection ?? VerticalDirection.down,
          textBaseline: spec.flex?.spec.textBaseline,
          clipBehavior: spec.flex?.spec.clipBehavior ?? Clip.none,
          spacing: spec.flex?.spec.spacing ?? 0.0,
          children: children,
        );

        // Wrap with box styling if present (but WITHOUT margin)
        if (spec.box != null) {
          final boxSpec = spec.box!.spec;
          return Container(
            alignment: boxSpec.alignment,
            padding: boxSpec.padding,
            decoration: boxSpec.decoration,
            foregroundDecoration: boxSpec.foregroundDecoration,
            constraints: boxSpec.constraints,
            transform: boxSpec.transform,
            transformAlignment: boxSpec.transformAlignment,
            clipBehavior: boxSpec.clipBehavior ?? Clip.none,
            // NOTE: margin intentionally omitted - applied externally
            child: flexWidget,
          );
        }

        return flexWidget;
      },
    );

    // Step 3: Apply margin OUTSIDE MixInteractionDetector
    if (margin != null) {
      inner = Padding(padding: margin, child: inner);
    }

    return inner;
  }
}

// =============================================================================
// Public Widgets
// =============================================================================

class Div extends StatelessWidget {
  const Div({
    super.key,
    required this.classNames,
    this.child,
    this.children = const [],
    this.isFlex,
    this.onUnsupported,
    this.config,
  });

  final String classNames;
  final Widget? child;
  final List<Widget> children;
  final bool? isFlex;
  final TwConfig? config;
  final TokenWarningCallback? onUnsupported;

  @override
  Widget build(BuildContext context) {
    assert(
      child == null || children.isEmpty,
      'Provide either child or children, not both.',
    );
    final cfg = config ?? TwConfigProvider.of(context);
    final parser = TwParser(config: cfg, onUnsupported: onUnsupported);
    final tokens = parser.setTokens(classNames);
    final shouldUseFlex = isFlex ?? parser.wantsFlex(tokens);
    final animationConfig = parser.parseAnimationFromTokens(tokens.toList());

    Widget built;

    if (shouldUseFlex) {
      var flexStyle = parser.parseFlex(classNames);
      if (animationConfig != null) {
        flexStyle = flexStyle.animate(animationConfig);
      }
      final rawChildren = children.isNotEmpty
          ? List<Widget>.from(children)
          : (child != null ? <Widget>[child!] : const <Widget>[]);

      built = _buildResponsiveFlex(
        tokens: tokens,
        cfg: cfg,
        baseStyle: flexStyle,
        rawChildren: rawChildren,
      );
    } else {
      var boxStyle = parser.parseBox(classNames);
      if (animationConfig != null) {
        boxStyle = boxStyle.animate(animationConfig);
      }
      final resolvedChild =
          child ?? (children.isNotEmpty ? Column(children: children) : null);

      built = _buildResponsiveBox(
        tokens: tokens,
        cfg: cfg,
        style: boxStyle,
        child: resolvedChild,
      );
    }

    return _wrapWithFlexItemDecorators(
      child: built,
      tokens: tokens,
      cfg: cfg,
      viewportWidth: _viewportSize(context).width,
    );
  }
}

/// Block-level text element with Tailwind styling.
///
/// Equivalent to HTML `<p>`. Renders as Flutter's `Text` widget
/// which is block-level (takes its own line).
///
/// ```dart
/// P(
///   text: 'Hello world',
///   classNames: 'text-lg font-bold text-gray-700',
/// )
/// ```
class P extends StatelessWidget {
  const P({super.key, required this.text, this.classNames = '', this.config});

  final String text;
  final String classNames;
  final TwConfig? config;

  @override
  Widget build(BuildContext context) {
    final cfg = config ?? TwConfigProvider.of(context);
    final style = TwParser(config: cfg).parseText(classNames);
    return StyledText(text, style: style);
  }
}

/// Inline-level text element with Tailwind styling.
///
/// Equivalent to HTML `<span>`. Renders as Mix's `StyledText` widget.
class Span extends StatelessWidget {
  const Span({
    super.key,
    required this.text,
    this.classNames = '',
    this.config,
  });

  final String text;
  final String classNames;
  final TwConfig? config;

  @override
  Widget build(BuildContext context) {
    final cfg = config ?? TwConfigProvider.of(context);
    final style = TwParser(config: cfg).parseText(classNames);
    return StyledText(text, style: style);
  }
}

/// Heading level 1 element with Tailwind styling.
///
/// Equivalent to HTML `<h1>`. Note: Like Tailwind's Preflight, headings have
/// no default styles - use utility classes like `text-4xl font-bold`.
class H1 extends StatelessWidget {
  const H1({super.key, required this.text, this.classNames = '', this.config});

  final String text;
  final String classNames;
  final TwConfig? config;

  @override
  Widget build(BuildContext context) {
    final cfg = config ?? TwConfigProvider.of(context);
    final style = TwParser(config: cfg).parseText(classNames);
    return StyledText(text, style: style);
  }
}

/// Heading level 2 element with Tailwind styling.
///
/// Equivalent to HTML `<h2>`. Note: Like Tailwind's Preflight, headings have
/// no default styles - use utility classes like `text-3xl font-semibold`.
class H2 extends StatelessWidget {
  const H2({super.key, required this.text, this.classNames = '', this.config});

  final String text;
  final String classNames;
  final TwConfig? config;

  @override
  Widget build(BuildContext context) {
    final cfg = config ?? TwConfigProvider.of(context);
    final style = TwParser(config: cfg).parseText(classNames);
    return StyledText(text, style: style);
  }
}

/// Heading level 3 element with Tailwind styling.
///
/// Equivalent to HTML `<h3>`. Note: Like Tailwind's Preflight, headings have
/// no default styles - use utility classes like `text-2xl font-semibold`.
class H3 extends StatelessWidget {
  const H3({super.key, required this.text, this.classNames = '', this.config});

  final String text;
  final String classNames;
  final TwConfig? config;

  @override
  Widget build(BuildContext context) {
    final cfg = config ?? TwConfigProvider.of(context);
    final style = TwParser(config: cfg).parseText(classNames);
    return StyledText(text, style: style);
  }
}

/// Heading level 4 element with Tailwind styling.
///
/// Equivalent to HTML `<h4>`. Note: Like Tailwind's Preflight, headings have
/// no default styles - use utility classes like `text-xl font-semibold`.
class H4 extends StatelessWidget {
  const H4({super.key, required this.text, this.classNames = '', this.config});

  final String text;
  final String classNames;
  final TwConfig? config;

  @override
  Widget build(BuildContext context) {
    final cfg = config ?? TwConfigProvider.of(context);
    final style = TwParser(config: cfg).parseText(classNames);
    return StyledText(text, style: style);
  }
}

/// Heading level 5 element with Tailwind styling.
///
/// Equivalent to HTML `<h5>`. Note: Like Tailwind's Preflight, headings have
/// no default styles - use utility classes like `text-lg font-semibold`.
class H5 extends StatelessWidget {
  const H5({super.key, required this.text, this.classNames = '', this.config});

  final String text;
  final String classNames;
  final TwConfig? config;

  @override
  Widget build(BuildContext context) {
    final cfg = config ?? TwConfigProvider.of(context);
    final style = TwParser(config: cfg).parseText(classNames);
    return StyledText(text, style: style);
  }
}

/// Heading level 6 element with Tailwind styling.
///
/// Equivalent to HTML `<h6>`. Note: Like Tailwind's Preflight, headings have
/// no default styles - use utility classes like `text-base font-semibold`.
class H6 extends StatelessWidget {
  const H6({super.key, required this.text, this.classNames = '', this.config});

  final String text;
  final String classNames;
  final TwConfig? config;

  @override
  Widget build(BuildContext context) {
    final cfg = config ?? TwConfigProvider.of(context);
    final style = TwParser(config: cfg).parseText(classNames);
    return StyledText(text, style: style);
  }
}

/// Convenience wrapper for truncated text in flex containers.
///
/// Automatically wraps the text with `flex-1 min-w-0` container and applies
/// `truncate` to enable text truncation with ellipsis.
///
/// Equivalent to:
/// ```dart
/// Div(
///   classNames: 'flex-1 min-w-0',
///   child: P(text: text, classNames: 'truncate $classNames'),
/// )
/// ```
class TruncatedP extends StatelessWidget {
  const TruncatedP({
    super.key,
    required this.text,
    this.classNames = '',
    this.config,
  });

  final String text;
  final String classNames;
  final TwConfig? config;

  @override
  Widget build(BuildContext context) {
    return Div(
      classNames: 'flex-1 min-w-0',
      config: config,
      child: P(text: text, classNames: 'truncate $classNames', config: config),
    );
  }
}

List<Widget> _applyCrossAxisGap(List<Widget> input, Axis axis, double? gap) {
  if (gap == null || gap <= 0 || input.length <= 1) {
    return input;
  }

  final padding = axis == Axis.horizontal
      ? EdgeInsets.symmetric(vertical: gap / 2)
      : EdgeInsets.symmetric(horizontal: gap / 2);

  return input
      .map((child) => Padding(padding: padding, child: child))
      .toList(growable: false);
}

Widget _buildResponsiveFlex({
  required Set<String> tokens,
  required TwConfig cfg,
  required FlexBoxStyler baseStyle,
  required List<Widget> rawChildren,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final width = _effectiveWidth(constraints, context);
      final axis = _resolveFlexAxisResponsive(tokens, cfg, width);
      final baseGap = _resolveResponsiveGap(tokens, cfg, width, 'gap-');
      final gapX = _resolveResponsiveGap(tokens, cfg, width, 'gap-x-');
      final gapY = _resolveResponsiveGap(tokens, cfg, width, 'gap-y-');

      var style = baseStyle;
      final mainGap = axis == Axis.horizontal
          ? (gapX ?? baseGap)
          : (gapY ?? baseGap);
      if (mainGap != null) {
        style = style.spacing(mainGap);
      }

      final crossGap = axis == Axis.horizontal ? gapY : gapX;
      final flexChildren = _applyCrossAxisGap(rawChildren, axis, crossGap);

      final hasBoundedMainAxis = axis == Axis.horizontal
          ? constraints.hasBoundedWidth
          : constraints.hasBoundedHeight;
      final resolvedChildren =
          flexChildren.length == 1 &&
              hasBoundedMainAxis &&
              flexChildren.single is! ParentDataWidget<FlexParentData>
          ? <Widget>[
              _FlexParentDataWrapper(
                flex: 1,
                fit: FlexFit.loose,
                child: flexChildren.single,
              ),
            ]
          : flexChildren;

      // Use CSS semantic flex box - margin is outside hover/press detection area
      Widget current = _CssSemanticFlexBox(
        style: style,
        children: resolvedChildren,
      );
      current = _applyContainerSizingResponsive(
        current,
        tokens,
        cfg,
        constraints,
        context,
        width,
      );
      current = _applyFractionalSizingResponsive(current, tokens, cfg, width);
      return current;
    },
  );
}

Widget _buildResponsiveBox({
  required Set<String> tokens,
  required TwConfig cfg,
  required BoxStyler style,
  Widget? child,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final width = _effectiveWidth(constraints, context);
      // Use CSS semantic box - margin is outside hover/press detection area
      Widget current = _CssSemanticBox(style: style, child: child);
      current = _applyContainerSizingResponsive(
        current,
        tokens,
        cfg,
        constraints,
        context,
        width,
      );
      current = _applyFractionalSizingResponsive(current, tokens, cfg, width);
      return current;
    },
  );
}

Widget _wrapWithFlexItemDecorators({
  required Widget child,
  required Set<String> tokens,
  required TwConfig cfg,
  required double viewportWidth,
}) {
  if (!_needsFlexItemDecorators(tokens)) {
    return child;
  }

  return Builder(
    builder: (context) =>
        _applyFlexItemDecorators(child, tokens, cfg, context, viewportWidth),
  );
}

bool _needsFlexItemDecorators(Set<String> tokens) {
  for (final token in tokens) {
    final base = token.substring(token.lastIndexOf(':') + 1);
    if (base.startsWith('flex-') ||
        base.startsWith('basis-') ||
        base.startsWith('self-')) {
      return true;
    }
  }
  return false;
}

Widget _applyContainerSizingResponsive(
  Widget child,
  Set<String> tokens,
  TwConfig cfg,
  BoxConstraints constraints,
  BuildContext context,
  double width,
) {
  final widthIntent = _resolveDimensionIntent(
    tokens,
    cfg,
    width,
    isWidth: true,
  );
  final heightIntent = _resolveDimensionIntent(
    tokens,
    cfg,
    width,
    isWidth: false,
  );

  if (widthIntent == _DimensionIntent.none &&
      heightIntent == _DimensionIntent.none) {
    return child;
  }

  final viewport = _viewportSize(context);
  double? targetWidth;
  double? targetHeight;

  if (widthIntent != _DimensionIntent.none) {
    targetWidth = widthIntent == _DimensionIntent.screen
        ? (viewport.width > 0
              ? viewport.width
              : _finiteOrNull(constraints.maxWidth))
        : _finiteOrNull(constraints.maxWidth) ??
              (viewport.width > 0 ? viewport.width : null);
  }

  if (heightIntent != _DimensionIntent.none) {
    targetHeight = heightIntent == _DimensionIntent.screen
        ? (viewport.height > 0
              ? viewport.height
              : _finiteOrNull(constraints.maxHeight))
        : _finiteOrNull(constraints.maxHeight) ??
              (viewport.height > 0 ? viewport.height : null);
  }

  if (targetWidth == null && targetHeight == null) {
    return child;
  }

  return SizedBox(width: targetWidth, height: targetHeight, child: child);
}

Widget _applyFractionalSizingResponsive(
  Widget child,
  Set<String> tokens,
  TwConfig cfg,
  double width,
) {
  final widthFactor = _resolveResponsiveFraction(tokens, cfg, width, 'w-');
  final heightFactor = _resolveResponsiveFraction(tokens, cfg, width, 'h-');

  if (widthFactor == null && heightFactor == null) {
    return child;
  }

  return FractionallySizedBox(
    widthFactor: widthFactor,
    heightFactor: heightFactor,
    child: child,
  );
}

Widget _applyFlexItemDecorators(
  Widget child,
  Set<String> tokens,
  TwConfig cfg,
  BuildContext context,
  double viewportWidth,
) {
  final renderFlex = context.findAncestorRenderObjectOfType<RenderFlex>();
  if (renderFlex == null) {
    return child;
  }

  final axis = renderFlex.direction;
  var current = child;

  final basis = _resolveBasisValue(tokens, cfg, viewportWidth);
  if (basis != null) {
    current = _applyBasis(current, basis, axis);
  }

  final selfAlignment = _resolveSelfAlignment(tokens, cfg, viewportWidth);
  if (selfAlignment != null) {
    current = _applySelfAlignment(current, selfAlignment, axis);
  }

  final behavior = _resolveFlexItemBehavior(tokens, cfg, viewportWidth);
  if (behavior != null) {
    // Apply min constraint for CSS flex: 1 1 0% parity (shrink below content)
    if (behavior.applyMinConstraint) {
      current = ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        child: current,
      );
    }
    current = _FlexParentDataWrapper(
      flex: behavior.flex,
      fit: behavior.fit,
      child: current,
    );
  }

  return current;
}

Axis _resolveFlexAxisResponsive(
  Set<String> tokens,
  TwConfig cfg,
  double width,
) {
  Axis? resolved;
  double chosenMin = -1;

  for (final token in tokens) {
    final info = _parseResponsiveToken(token, cfg);
    if (info.minWidth > width) {
      continue;
    }
    if (info.base == 'flex-col') {
      if (info.minWidth >= chosenMin) {
        resolved = Axis.vertical;
        chosenMin = info.minWidth;
      }
    } else if (info.base == 'flex-row' || info.base == 'flex') {
      if (info.minWidth >= chosenMin) {
        resolved = Axis.horizontal;
        chosenMin = info.minWidth;
      }
    }
  }

  if (resolved != null) {
    return resolved;
  }

  final hasBaseFlex = tokens.any((token) {
    if (token.contains(':')) return false;
    return token == 'flex' || token == 'flex-row' || token == 'flex-col';
  });

  return hasBaseFlex ? Axis.horizontal : Axis.vertical;
}

double? _resolveResponsiveGap(
  Set<String> tokens,
  TwConfig cfg,
  double width,
  String prefix,
) {
  double? resolved;
  double chosenMin = -1;

  for (final token in tokens) {
    final info = _parseResponsiveToken(token, cfg);
    if (info.minWidth > width) {
      continue;
    }
    if (!info.base.startsWith(prefix)) {
      continue;
    }

    final key = info.base.substring(prefix.length);
    if (key.isEmpty) {
      continue;
    }

    final value = cfg.spaceOf(key, fallback: double.nan);
    if (!value.isNaN && info.minWidth >= chosenMin) {
      resolved = value;
      chosenMin = info.minWidth;
    }
  }

  return resolved;
}

double? _resolveResponsiveFraction(
  Set<String> tokens,
  TwConfig cfg,
  double width,
  String prefix,
) {
  double? fraction;
  double chosenMin = -1;

  for (final token in tokens) {
    final info = _parseResponsiveToken(token, cfg);
    if (info.minWidth > width) {
      continue;
    }
    if (!info.base.startsWith(prefix)) {
      continue;
    }

    final value = parseFractionToken(info.base.substring(prefix.length));
    if (value != null && info.minWidth >= chosenMin) {
      fraction = value;
      chosenMin = info.minWidth;
    }
  }

  return fraction;
}

_DimensionIntent _resolveDimensionIntent(
  Set<String> tokens,
  TwConfig cfg,
  double width, {
  required bool isWidth,
}) {
  _DimensionIntent? intent;
  double chosenMin = -1;

  final fullTarget = isWidth ? 'w-full' : 'h-full';
  final screenTarget = isWidth ? 'w-screen' : 'h-screen';

  for (final token in tokens) {
    final info = _parseResponsiveToken(token, cfg);
    if (info.minWidth > width) {
      continue;
    }

    if (info.base == fullTarget && info.minWidth >= chosenMin) {
      intent = _DimensionIntent.full;
      chosenMin = info.minWidth;
    } else if (info.base == screenTarget && info.minWidth >= chosenMin) {
      intent = _DimensionIntent.screen;
      chosenMin = info.minWidth;
    }
  }

  return intent ?? _DimensionIntent.none;
}

double _effectiveWidth(BoxConstraints constraints, BuildContext context) {
  final finite = _finiteOrNull(constraints.maxWidth);
  if (finite != null) {
    return finite;
  }
  final mediaWidth = _viewportSize(context).width;
  return mediaWidth > 0 ? mediaWidth : 0;
}

Size _viewportSize(BuildContext context) {
  final query = MediaQuery.maybeOf(context);
  return query?.size ?? Size.zero;
}

double? _finiteOrNull(double value) => value.isFinite ? value : null;

class _ResponsiveToken {
  const _ResponsiveToken(this.base, this.minWidth);

  final String base;
  final double minWidth;
}

_ResponsiveToken _parseResponsiveToken(String token, TwConfig cfg) {
  var remaining = token;
  double minWidth = 0;

  while (true) {
    final index = remaining.indexOf(':');
    if (index <= 0) {
      break;
    }

    final head = remaining.substring(0, index);
    final tail = remaining.substring(index + 1);
    if (cfg.breakpoints.containsKey(head)) {
      minWidth = cfg.breakpointOf(head);
      remaining = tail;
      continue;
    }
    break;
  }

  return _ResponsiveToken(remaining, minWidth);
}

enum _DimensionIntent { none, full, screen }

class _FlexItemBehavior {
  const _FlexItemBehavior({
    required this.flex,
    required this.fit,
    this.applyMinConstraint = false,
  });

  final int flex;
  final FlexFit fit;
  final bool applyMinConstraint;
}

class _BasisValue {
  const _BasisValue({this.pixels});

  final double? pixels;
}

enum _SelfAlignment { start, center, end }

_FlexItemBehavior? _resolveFlexItemBehavior(
  Set<String> tokens,
  TwConfig cfg,
  double width,
) {
  // Check for min-w-auto escape hatch
  final hasMinWidthAuto = tokens.any((token) {
    final base = token.substring(token.lastIndexOf(':') + 1);
    return base == 'min-w-auto';
  });

  _FlexItemBehavior? behavior;
  double chosenMin = -1;

  for (final token in tokens) {
    final info = _parseResponsiveToken(token, cfg);
    if (info.minWidth > width) {
      continue;
    }

    final candidate = switch (info.base) {
      // flex-1: auto-apply min constraint for CSS flex: 1 1 0% parity
      'flex-1' => _FlexItemBehavior(
        flex: 1,
        fit: FlexFit.tight,
        applyMinConstraint: !hasMinWidthAuto,
      ),
      'flex-auto' => const _FlexItemBehavior(flex: 1, fit: FlexFit.loose),
      'flex-initial' => const _FlexItemBehavior(flex: 0, fit: FlexFit.loose),
      // flex-none / shrink-0: maintain intrinsic size (don't grow or fill)
      'flex-none' ||
      'flex-shrink-0' ||
      'shrink-0' => const _FlexItemBehavior(flex: 0, fit: FlexFit.loose),
      // Allow shrinking (default behavior)
      'flex-shrink' ||
      'shrink' => const _FlexItemBehavior(flex: 0, fit: FlexFit.loose),
      _ => null,
    };

    if (candidate != null && info.minWidth >= chosenMin) {
      behavior = candidate;
      chosenMin = info.minWidth;
    }
  }

  return behavior;
}

_BasisValue? _resolveBasisValue(
  Set<String> tokens,
  TwConfig cfg,
  double width,
) {
  _BasisValue? value;
  double chosenMin = -1;

  for (final token in tokens) {
    final info = _parseResponsiveToken(token, cfg);
    if (info.minWidth > width) {
      continue;
    }

    if (!info.base.startsWith('basis-')) {
      continue;
    }

    final key = info.base.substring(6);
    if (key.isEmpty) {
      continue;
    }

    bool handled = true;
    _BasisValue? candidate;

    if (key == 'auto') {
      candidate = null;
    } else {
      final size = cfg.spaceOf(key, fallback: double.nan);
      if (!size.isNaN) {
        candidate = _BasisValue(pixels: size);
      } else {
        handled = false;
      }
    }

    if (!handled) {
      continue;
    }

    if (info.minWidth >= chosenMin) {
      value = candidate;
      chosenMin = info.minWidth;
    }
  }

  return value;
}

Widget _applyBasis(Widget child, _BasisValue basis, Axis axis) {
  if (basis.pixels != null) {
    return SizedBox(
      width: axis == Axis.horizontal ? basis.pixels : null,
      height: axis == Axis.vertical ? basis.pixels : null,
      child: child,
    );
  }

  return child;
}

_SelfAlignment? _resolveSelfAlignment(
  Set<String> tokens,
  TwConfig cfg,
  double width,
) {
  _SelfAlignment? alignment;
  double chosenMin = -1;

  for (final token in tokens) {
    final info = _parseResponsiveToken(token, cfg);
    if (info.minWidth > width) {
      continue;
    }

    final candidate = switch (info.base) {
      'self-start' => _SelfAlignment.start,
      'self-center' => _SelfAlignment.center,
      'self-end' => _SelfAlignment.end,
      _ => null,
    };

    if (candidate != null && info.minWidth >= chosenMin) {
      alignment = candidate;
      chosenMin = info.minWidth;
    }
  }

  return alignment;
}

Widget _applySelfAlignment(Widget child, _SelfAlignment alignment, Axis axis) {
  final resolved = switch (alignment) {
    _SelfAlignment.start =>
      axis == Axis.horizontal
          ? AlignmentDirectional.topCenter
          : AlignmentDirectional.centerStart,
    _SelfAlignment.center => AlignmentDirectional.center,
    _SelfAlignment.end =>
      axis == Axis.horizontal
          ? AlignmentDirectional.bottomCenter
          : AlignmentDirectional.centerEnd,
  };
  return Align(alignment: resolved, child: child);
}

class _FlexParentDataWrapper extends ParentDataWidget<FlexParentData> {
  const _FlexParentDataWrapper({
    required this.flex,
    required this.fit,
    required super.child,
  });

  final int flex;
  final FlexFit fit;

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData = renderObject.parentData as FlexParentData;
    var needsLayout = false;

    if (parentData.flex != flex) {
      parentData.flex = flex;
      needsLayout = true;
    }

    if (parentData.fit != fit) {
      parentData.fit = fit;
      needsLayout = true;
    }

    if (needsLayout) {
      final targetParent = renderObject.parent;
      if (targetParent is RenderObject) {
        targetParent.markNeedsLayout();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => Flex;
}
