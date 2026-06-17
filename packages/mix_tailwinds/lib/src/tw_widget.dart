import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'parser/candidate_parser.dart';
import 'parser/data/parser_registry.g.dart';
import 'parser/diagnostics.dart';
import 'parser/model.dart';
import 'translate/tw_target.dart' as tw_target;
import 'translate/tw_routing.dart';
import 'tw_config.dart';
import 'tw_flex_item.dart';
import 'tw_parser.dart';
import 'tw_types.dart';
import 'tw_utils.dart';

// =============================================================================
// Box/Margin Utility Detection
// =============================================================================

final _whitespaceRegex = RegExp(r'\s+');
final _candidateParser = TailwindCandidateParser(
  registry: defaultTailwindParserRegistry,
);

/// Extracts positive margin [EdgeInsets] from [classNames].
///
/// Returns null when no positive margin token is present.
///
/// - Negative margins (`-mb-4`) are skipped. They are applied via [Padding],
///   whose `RenderPadding` asserts non-negative insets, so emitting them would
///   crash. True CSS negative-margin parity needs a transform-based strategy at
///   the box layer and is tracked separately.
/// - Variant-prefixed margins are skipped because responsive/interaction
///   margin semantics are not yet modeled in the widget layer.
EdgeInsets? _extractMargin(String classNames, TwConfig cfg) {
  final tokens = classNames.trim().isEmpty
      ? const <String>[]
      : classNames.trim().split(_whitespaceRegex);
  double? top, right, bottom, left;

  for (final token in tokens) {
    final candidate = _parseCandidate(token);
    if (candidate == null || candidate.variants.isNotEmpty) continue;

    final route = routeCandidate(candidate, breakpoints: cfg.breakpoints);
    if (route.kind != TwRouteKind.schemaValue) continue;

    final utility = candidate.utility;
    final root = tailwindUtilityRoot(utility);
    if (!_marginRoots.contains(root)) continue;
    if (tailwindUtilityNegative(utility)) continue;

    final value = _marginLength(tailwindUtilityValue(utility), cfg);
    if (value == null || value < 0) continue;

    switch (root) {
      case 'm':
        top = right = bottom = left = value;
      case 'mx':
        left = right = value;
      case 'my':
        top = bottom = value;
      case 'mt':
        top = value;
      case 'mr':
        right = value;
      case 'mb':
        bottom = value;
      case 'ml':
        left = value;
    }
  }

  if (top == null && right == null && bottom == null && left == null) {
    return null;
  }

  return EdgeInsets.only(
    left: left ?? 0,
    top: top ?? 0,
    right: right ?? 0,
    bottom: bottom ?? 0,
  );
}

double? _marginLength(TailwindValue? value, TwConfig cfg) {
  final key = tailwindValueKey(value);
  final scale = cfg.space[key];
  if (scale != null) return scale;
  if (value is! TailwindArbitraryValue) return null;
  final match = RegExp(r'^(-?\d+\.?\d*)(px|rem|em)?$').firstMatch(value.value);
  if (match == null) return null;
  var length = double.parse(match.group(1)!);
  final unit = match.group(2) ?? 'px';
  if (unit == 'rem' || unit == 'em') length *= 16;
  return length;
}

const _marginRoots = {'m', 'mx', 'my', 'mt', 'mr', 'mb', 'ml'};

TailwindCandidate? _parseCandidate(String token) {
  final parsed = _candidateParser.parseCandidate(token);
  return switch (parsed) {
    TailwindParseSuccess(:final candidate) => candidate,
    TailwindParseFailure() => null,
  };
}

// =============================================================================
// CSS Semantic Margin Helpers
// =============================================================================

/// Creates a new [BoxSpec] with margin set to null.
///
/// Used to strip margin from a spec so it can be applied externally
/// for CSS semantic hit-testing (margin outside interactive area).
BoxSpec _boxSpecWithoutMargin(BoxSpec spec) {
  return BoxSpec(
    alignment: spec.alignment,
    padding: spec.padding,
    margin: null,
    constraints: spec.constraints,
    decoration: spec.decoration,
    foregroundDecoration: spec.foregroundDecoration,
    transform: spec.transform,
    transformAlignment: spec.transformAlignment,
    clipBehavior: spec.clipBehavior,
  );
}

/// Creates a new [StyleSpec<BoxSpec>] with margin stripped from the inner spec.
///
/// Preserves animation and widgetModifiers from the original.
StyleSpec<BoxSpec> _styleSpecWithoutMargin(StyleSpec<BoxSpec> styleSpec) {
  return StyleSpec<BoxSpec>(
    spec: _boxSpecWithoutMargin(styleSpec.spec),
    animation: styleSpec.animation,
    widgetModifiers: styleSpec.widgetModifiers,
  );
}

/// Creates a new [FlexBoxSpec] with margin stripped from the box spec.
///
/// Preserves flex spec and other box properties.
FlexBoxSpec _flexBoxSpecWithoutMargin(FlexBoxSpec spec) {
  if (spec.box == null) return spec;
  return FlexBoxSpec(box: _styleSpecWithoutMargin(spec.box!), flex: spec.flex);
}

// =============================================================================
// CSS Semantic Box Widgets
// =============================================================================

/// A Box widget with CSS-style margin semantics.
///
// =============================================================================
// Flex Scope (boundedness propagation)
// =============================================================================

/// Exposes flex container context to children for boundedness gating.
///
/// Injected by [_buildResponsiveFlex] inside its [LayoutBuilder], where the
/// parent constraints are known. Children read this via [maybeOf] to decide
/// whether `flex > 0` wrappers are safe to apply.
class _TwFlexScope extends InheritedWidget {
  const _TwFlexScope({
    required this.axis,
    required this.isMainAxisBounded,
    required super.child,
  });

  final Axis axis;
  final bool isMainAxisBounded;

  static _TwFlexScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_TwFlexScope>();

  @override
  bool updateShouldNotify(_TwFlexScope oldWidget) =>
      axis != oldWidget.axis ||
      isMainAxisBounded != oldWidget.isMainAxisBounded;
}

/// Determines if the parent flex container's main axis is bounded.
///
/// Priority:
/// 1. [_TwFlexScope] (accurate, set at LayoutBuilder time) — only used when
///    scope axis matches [axis] to prevent nested mismatch.
/// 2. [RenderFlex.constraints] from previous layout pass (covers native
///    Column/Row parents that have no scope).
/// 3. Default `true` (first frame, conservative — prevents false negatives).
bool _resolveIsMainAxisBounded(
  BuildContext context,
  RenderFlex renderFlex,
  Axis axis,
) {
  final scope = _TwFlexScope.maybeOf(context);
  if (scope != null && scope.axis == axis) {
    return scope.isMainAxisBounded;
  }

  // Fallback: read RenderFlex constraints directly (covers native parents)
  if (renderFlex.hasSize) {
    return axis == Axis.horizontal
        ? renderFlex.constraints.hasBoundedWidth
        : renderFlex.constraints.hasBoundedHeight;
  }

  // First frame, no layout yet — assume bounded (safe default)
  return true;
}

// =============================================================================
// CSS Semantic Widgets
// =============================================================================

/// In CSS, margin is outside the hit-test area - hover/press only triggers
/// on the border-box (content + padding + border). This widget extracts
/// margin from the BoxSpec and applies it OUTSIDE the MixInteractionDetector.
///
/// Widget tree structure:
/// ```
/// Padding(margin)              <- OUTSIDE hover detection
///   └── StyleBuilder
///         └── MixInteractionDetector  <- Hover detection here
///               └── Box(no margin)
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
        // Use Box widget with margin stripped - margin is applied externally
        return Box(
          styleSpec: _styleSpecWithoutMargin(StyleSpec(spec: spec)),
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
        // Use FlexBox widget with margin stripped - margin is applied externally
        return FlexBox(
          styleSpec: StyleSpec(spec: _flexBoxSpecWithoutMargin(spec)),
          children: children,
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
    final reportedUnsupported = <String>{};
    void reportUnsupported(String token) {
      if (reportedUnsupported.add(token)) {
        onUnsupported?.call(token);
      }
    }

    final parser = TwParser(config: cfg, onUnsupported: reportUnsupported);
    final tokens = parser.setTokens(classNames);
    _reportUnsupportedWidgetLayerVariants(tokens, cfg, reportUnsupported);
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
      // CSS block elements stretch horizontally but shrink-wrap vertically.
      final resolvedChild =
          child ??
          (children.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                )
              : null);

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
      viewportWidth: _responsiveWidth(null, context),
    );
  }
}

/// Block-level text element with Tailwind styling.
///
/// Equivalent to HTML `<p>`. Renders as Flutter's `Text` widget
/// which is block-level (takes its own line).
///
/// Supports margin utilities (m-*, mx-*, my-*, mt-*, mr-*, mb-*, ml-*)
/// which wrap the text with appropriate padding.
///
/// ```dart
/// P(
///   text: 'Hello world',
///   classNames: 'text-lg font-bold text-gray-700 mb-4',
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
    Widget result = StyledText(text, style: style);

    // Apply margin if present
    final margin = _extractMargin(classNames, cfg);
    if (margin != null) {
      result = Padding(padding: margin, child: result);
    }

    return result;
  }
}

/// Inline-level text element with Tailwind styling.
///
/// Equivalent to HTML `<span>`. Renders as Mix's `StyledText` widget.
///
/// When box utilities (padding, background, border, rounded, etc.) are present,
/// the text is wrapped in a Box container to apply those styles, matching
/// CSS behavior where `<span>` can have padding, background, etc.
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
    final parser = TwParser(config: cfg);

    // Check if we need box styling (padding, background, border, etc.)
    if (tw_target.hasBoxUtilities(classNames, breakpoints: cfg.breakpoints)) {
      // Parse as box to get padding, background, border, etc.
      // parseBox also handles text styling via DefaultTextStyle wrapper
      final boxStyle = parser.parseBox(classNames);
      final textStyle = parser.parseText(classNames);

      // Use inline layout (no block-level stretch)
      return _CssSemanticBox(
        style: boxStyle,
        child: StyledText(text, style: textStyle),
      );
    }

    // No box utilities - render as simple styled text
    final style = parser.parseText(classNames);
    return StyledText(text, style: style);
  }
}

/// Icon element with Tailwind-style size and color utilities.
///
/// This is a small bridge between Tailwind SVG icon classes and Mix's
/// [StyledIcon]. It supports the icon classes used by common inline SVGs:
/// `w-*`, `h-*`, `text-*`, and positive logical/physical margin tokens.
class TwIcon extends StatelessWidget {
  const TwIcon(
    this.icon, {
    super.key,
    this.classNames = '',
    this.config,
    this.semanticLabel,
  });

  final IconData icon;
  final String classNames;
  final TwConfig? config;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final cfg = config ?? TwConfigProvider.of(context);
    final parsedStyle = TwParser(config: cfg).parseIcon(classNames);

    // Preserve the inherited text color as a fallback; the parsed icon style
    // overrides it when the class names include a `text-<color>` utility.
    final fallbackColor = DefaultTextStyle.of(context).style.color;
    var style = fallbackColor != null
        ? IconStyler().color(fallbackColor)
        : IconStyler();
    style = style.merge(parsedStyle);

    Widget current = StyledIcon(
      icon: icon,
      semanticLabel: semanticLabel,
      style: style,
    );

    final margin = _extractLogicalMargin(classNames, cfg);
    if (margin != null) {
      current = Padding(padding: margin, child: current);
    }

    return current;
  }
}

/// Extracts logical/physical icon margins (`ms-*`, `me-*`, `ml-*`, `mr-*`).
///
/// Parses each token through the candidate parser so variant-prefixed margins
/// (e.g. `hover:me-1`) and negatives do not apply as base styles. `ms`/`me` are
/// not schema-routed utility roots, so sides are matched on the unprefixed
/// utility text rather than via [routeCandidate].
EdgeInsetsGeometry? _extractLogicalMargin(String classNames, TwConfig cfg) {
  var start = 0.0;
  var end = 0.0;
  var left = 0.0;
  var right = 0.0;
  var hasMargin = false;

  final tokens = classNames.trim().isEmpty
      ? const <String>[]
      : classNames.trim().split(_whitespaceRegex);
  for (final token in tokens) {
    final candidate = _parseCandidate(token);
    if (candidate == null || candidate.variants.isNotEmpty) continue;

    final utility = candidate.utility;
    if (tailwindUtilityNegative(utility)) continue;

    final raw = utility.raw;
    void Function(double value)? setter;
    if (raw.startsWith('ms-')) {
      setter = (value) => start = value;
    } else if (raw.startsWith('me-')) {
      setter = (value) => end = value;
    } else if (raw.startsWith('ml-')) {
      setter = (value) => left = value;
    } else if (raw.startsWith('mr-')) {
      setter = (value) => right = value;
    }
    if (setter == null) continue;

    final length = _spacingTokenLength(raw.substring(3), cfg);
    if (length == null) continue;
    setter(length);
    hasMargin = true;
  }

  if (!hasMargin) return null;
  return EdgeInsetsDirectional.only(
    start: start,
    end: end,
  ).add(EdgeInsets.only(left: left, right: right));
}

double? _spacingTokenLength(String key, TwConfig cfg) {
  if (key == 'px') return 1;
  return cfg.hasSpace(key) ? cfg.spaceOf(key) : null;
}

/// Heading level 1 element with Tailwind styling.
///
/// Equivalent to HTML `<h1>`. Note: Like Tailwind's Preflight, headings have
/// no default styles - use utility classes like `text-4xl font-bold`.
/// Supports margin utilities (m-*, mx-*, my-*, mt-*, mr-*, mb-*, ml-*).
abstract class _Heading extends StatelessWidget {
  const _Heading({
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
    Widget result = StyledText(text, style: style);

    final margin = _extractMargin(classNames, cfg);
    if (margin != null) {
      result = Padding(padding: margin, child: result);
    }

    return result;
  }
}

class H1 extends _Heading {
  const H1({
    super.key,
    required super.text,
    super.classNames = '',
    super.config,
  });
}

/// Heading level 2 element with Tailwind styling.
///
/// Equivalent to HTML `<h2>`. Note: Like Tailwind's Preflight, headings have
/// no default styles - use utility classes like `text-3xl font-semibold`.
/// Supports margin utilities (m-*, mx-*, my-*, mt-*, mr-*, mb-*, ml-*).
class H2 extends _Heading {
  const H2({
    super.key,
    required super.text,
    super.classNames = '',
    super.config,
  });
}

/// Heading level 3 element with Tailwind styling.
///
/// Equivalent to HTML `<h3>`. Note: Like Tailwind's Preflight, headings have
/// no default styles - use utility classes like `text-2xl font-semibold`.
/// Supports margin utilities (m-*, mx-*, my-*, mt-*, mr-*, mb-*, ml-*).
class H3 extends _Heading {
  const H3({
    super.key,
    required super.text,
    super.classNames = '',
    super.config,
  });
}

/// Heading level 4 element with Tailwind styling.
///
/// Equivalent to HTML `<h4>`. Note: Like Tailwind's Preflight, headings have
/// no default styles - use utility classes like `text-xl font-semibold`.
/// Supports margin utilities (m-*, mx-*, my-*, mt-*, mr-*, mb-*, ml-*).
class H4 extends _Heading {
  const H4({
    super.key,
    required super.text,
    super.classNames = '',
    super.config,
  });
}

/// Heading level 5 element with Tailwind styling.
///
/// Equivalent to HTML `<h5>`. Note: Like Tailwind's Preflight, headings have
/// no default styles - use utility classes like `text-lg font-semibold`.
/// Supports margin utilities (m-*, mx-*, my-*, mt-*, mr-*, mb-*, ml-*).
class H5 extends _Heading {
  const H5({
    super.key,
    required super.text,
    super.classNames = '',
    super.config,
  });
}

/// Heading level 6 element with Tailwind styling.
///
/// Equivalent to HTML `<h6>`. Note: Like Tailwind's Preflight, headings have
/// no default styles - use utility classes like `text-base font-semibold`.
/// Supports margin utilities (m-*, mx-*, my-*, mt-*, mr-*, mb-*, ml-*).
class H6 extends _Heading {
  const H6({
    super.key,
    required super.text,
    super.classNames = '',
    super.config,
  });
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

  final halfGap = gap / 2;
  final lastIndex = input.length - 1;

  return List<Widget>.generate(input.length, (index) {
    final isFirst = index == 0;
    final isLast = index == lastIndex;
    final padding = axis == Axis.horizontal
        ? EdgeInsets.only(
            top: isFirst ? 0 : halfGap,
            bottom: isLast ? 0 : halfGap,
          )
        : EdgeInsets.only(
            left: isFirst ? 0 : halfGap,
            right: isLast ? 0 : halfGap,
          );
    return Padding(padding: padding, child: input[index]);
  }, growable: false);
}

bool _hasResponsiveAlignItems(Set<String> tokens, TwConfig cfg, double width) {
  for (final token in tokens) {
    final info = _parseResponsiveToken(token, cfg);
    if (info == null || info.minWidth > width) {
      continue;
    }
    if (info.base.startsWith('items-')) {
      return true;
    }
  }
  return false;
}

bool _hasResponsiveWidthToken(String classNames, TwConfig cfg, double width) {
  final tokens = classNames.split(_whitespaceRegex);
  for (final token in tokens) {
    final info = _parseResponsiveToken(token, cfg);
    if (info == null || info.minWidth > width) {
      continue;
    }
    if (info.base.startsWith('w-')) {
      return true;
    }
  }
  return false;
}

Widget _wrapIfExplicitWidthInStretchColumn(
  Widget child,
  TwConfig cfg,
  double width,
) {
  final classNames = switch (child) {
    Div() => child.classNames,
    P() => child.classNames,
    _Heading() => child.classNames,
    _ => null,
  };

  if (classNames == null || classNames.trim().isEmpty) {
    return child;
  }

  if (_hasResponsiveWidthToken(classNames, cfg, width)) {
    // Allow the child to keep its own explicit width under a stretched Column.
    return Align(alignment: AlignmentDirectional.centerStart, child: child);
  }

  return child;
}

Widget _buildResponsiveFlex({
  required Set<String> tokens,
  required TwConfig cfg,
  required FlexBoxStyler baseStyle,
  required List<Widget> rawChildren,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final width = _responsiveWidth(constraints, context);
      final axis = _resolveFlexAxisResponsive(tokens, cfg, width);
      final isMainAxisBounded = axis == Axis.horizontal
          ? constraints.hasBoundedWidth
          : constraints.hasBoundedHeight;
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

      var resolvedChildren = flexChildren;

      // CSS parity: Tailwind's default `align-items` is `stretch` (unless an
      // explicit `items-*` utility is present). In Flutter, a Column/Row with
      // `crossAxisAlignment == center` shrink-wraps on the cross-axis, causing
      // flex containers to render centered/narrower than their available width.
      //
      // Only apply `stretch` when the cross-axis is bounded to avoid Flutter
      // layout assertions in unbounded contexts (e.g. Row inside Column).
      final hasExplicitItems = _hasResponsiveAlignItems(tokens, cfg, width);
      final isCrossAxisBounded = axis == Axis.horizontal
          ? constraints.hasBoundedHeight
          : constraints.hasBoundedWidth;
      if (!hasExplicitItems && axis == Axis.vertical && isCrossAxisBounded) {
        style = style.crossAxisAlignment(CrossAxisAlignment.stretch);
        // Preserve explicit widths (e.g. `w-44`) which should not be stretched.
        resolvedChildren = [
          for (final child in resolvedChildren)
            _wrapIfExplicitWidthInStretchColumn(child, cfg, width),
        ];
      }

      // Use CSS semantic flex box - margin is outside hover/press detection area
      Widget current = _TwFlexScope(
        axis: axis,
        isMainAxisBounded: isMainAxisBounded,
        child: _CssSemanticFlexBox(style: style, children: resolvedChildren),
      );
      current = _applyContainerSizingResponsive(
        current,
        tokens,
        cfg,
        constraints,
        context,
        width,
      );
      current = _applyMinSizingResponsive(current, tokens, cfg, context, width);
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
      final width = _responsiveWidth(constraints, context);
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
      current = _applyMinSizingResponsive(current, tokens, cfg, context, width);
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
  if (!_needsFlexItemDecorators(tokens, cfg)) {
    return child;
  }

  return Builder(
    builder: (context) =>
        _applyFlexItemDecorators(child, tokens, cfg, context, viewportWidth),
  );
}

bool _needsFlexItemDecorators(Set<String> tokens, TwConfig cfg) {
  for (final token in tokens) {
    final info = _parseResponsiveToken(token, cfg);
    if (info == null) continue;
    final base = info.base;
    if (base == 'w-full' || base == 'h-full') {
      return true;
    }
    if (base.startsWith('flex-') ||
        base.startsWith('basis-') ||
        base.startsWith('self-') ||
        base.startsWith('shrink') ||
        base.startsWith('grow')) {
      return true;
    }
  }
  return false;
}

void _reportUnsupportedWidgetLayerVariants(
  Set<String> tokens,
  TwConfig cfg,
  TokenWarningCallback onUnsupported,
) {
  for (final token in tokens) {
    final candidate = _parseCandidate(token);
    if (candidate == null || candidate.variants.isEmpty) {
      continue;
    }
    if (!_isRootLayoutWidgetUtility(candidate.utility)) {
      continue;
    }
    if (_hasOnlyBreakpointVariants(candidate.variants, cfg)) {
      continue;
    }

    onUnsupported(token);
  }
}

bool _hasOnlyBreakpointVariants(List<TailwindVariant> variants, TwConfig cfg) {
  for (final variant in variants) {
    if (variant is! TailwindStaticVariant ||
        !cfg.breakpoints.containsKey(variant.root)) {
      return false;
    }
  }

  return true;
}

bool _isRootLayoutWidgetUtility(TailwindUtility utility) {
  final raw = utility.raw;
  final root = tailwindUtilityRoot(utility);
  final valueKey = tailwindValueKey(tailwindUtilityValue(utility));

  if (raw.startsWith('flex-') ||
      raw.startsWith('basis-') ||
      raw.startsWith('self-') ||
      raw.startsWith('shrink') ||
      raw.startsWith('grow')) {
    return true;
  }

  if (root == 'basis' ||
      root == 'self' ||
      root == 'grow' ||
      root == 'shrink' ||
      root == 'gap-x' ||
      root == 'gap-y' ||
      raw == 'block') {
    return true;
  }

  if (root == 'w' ||
      root == 'h' ||
      root == 'min-w' ||
      root == 'min-h' ||
      root == 'max-w' ||
      root == 'max-h') {
    return valueKey == 'full' ||
        valueKey == 'screen' ||
        valueKey == 'auto' ||
        valueKey?.contains('/') == true;
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

Widget _applyMinSizingResponsive(
  Widget child,
  Set<String> tokens,
  TwConfig cfg,
  BuildContext context,
  double width,
) {
  final minWidthScreen = _resolveMinScreenIntent(
    tokens,
    cfg,
    width,
    isWidth: true,
  );
  final minHeightScreen = _resolveMinScreenIntent(
    tokens,
    cfg,
    width,
    isWidth: false,
  );

  if (!minWidthScreen && !minHeightScreen) {
    return child;
  }

  final viewport = _viewportSize(context);
  double? minWidth;
  double? minHeight;

  if (minWidthScreen && viewport.width > 0) {
    minWidth = viewport.width;
  }
  if (minHeightScreen && viewport.height > 0) {
    minHeight = viewport.height;
  }

  if (minWidth == null && minHeight == null) {
    return child;
  }

  return ConstrainedBox(
    constraints: BoxConstraints(
      minWidth: minWidth ?? 0,
      minHeight: minHeight ?? 0,
    ),
    child: child,
  );
}

bool _resolveMinScreenIntent(
  Set<String> tokens,
  TwConfig cfg,
  double width, {
  required bool isWidth,
}) {
  final target = isWidth ? 'min-w-screen' : 'min-h-screen';

  for (final token in tokens) {
    final info = _parseResponsiveToken(token, cfg);
    if (info == null || info.minWidth > width) {
      continue;
    }
    if (info.base == target) {
      return true;
    }
  }
  return false;
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
  final isMainAxisBounded = _resolveIsMainAxisBounded(
    context,
    renderFlex,
    axis,
  );
  var current = child;

  final widthIntent = _resolveDimensionIntent(
    tokens,
    cfg,
    viewportWidth,
    isWidth: true,
  );
  final heightIntent = _resolveDimensionIntent(
    tokens,
    cfg,
    viewportWidth,
    isWidth: false,
  );

  final basis = _resolveBasisValue(tokens, cfg, viewportWidth);
  if (basis != null) {
    current = _applyBasis(current, basis, axis);
  }

  final selfAlignment = _resolveSelfAlignment(tokens, cfg, viewportWidth);
  if (selfAlignment != null) {
    current = _applySelfAlignment(current, selfAlignment, axis);
  }

  final behavior = _resolveFlexItemBehavior(
    tokens,
    cfg,
    viewportWidth,
    context,
  );

  // Handle w-full/h-full when used as a direct child of a Flex.
  //
  // In Flutter, non-flex children of Row/Column get unbounded constraints along
  // the main axis. Our `w-full`/`h-full` sizing currently falls back to the
  // viewport size in that case, which does not match CSS semantics inside flex
  // containers (it should resolve against the flex container’s available space).
  //
  // To align with Tailwind/CSS behavior, treat w-full/h-full as a flex item that
  // expands to fill the available space on the main axis, unless the user already
  // provided explicit flex/basis behavior (or wrapped the widget in Flexible).
  final isAlreadyFlexible =
      context.findAncestorWidgetOfExactType<Flexible>() != null ||
      context.findAncestorWidgetOfExactType<Expanded>() != null;
  final wantsFullOnMainAxis = axis == Axis.horizontal
      ? widthIntent == _DimensionIntent.full
      : heightIntent == _DimensionIntent.full;
  if (!isAlreadyFlexible &&
      wantsFullOnMainAxis &&
      behavior == null &&
      basis == null &&
      isMainAxisBounded) {
    current = _FlexParentDataWrapper(
      flex: 1,
      fit: FlexFit.tight,
      child: current,
    );
  }

  if (behavior != null) {
    if (!isMainAxisBounded && behavior.flex > 0) {
      // CSS parity: flex-grow has no effect in unbounded context. Skip.
    } else {
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
    if (info == null || info.minWidth > width) {
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
    if (info == null || info.minWidth > width) {
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
    if (info == null || info.minWidth > width) {
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
    if (info == null || info.minWidth > width) {
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

double _responsiveWidth(BoxConstraints? constraints, BuildContext context) {
  final viewportWidth = _viewportSize(context).width;
  if (viewportWidth > 0) {
    return viewportWidth;
  }
  if (constraints != null) {
    return _effectiveWidth(constraints, context);
  }
  return 0;
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

_ResponsiveToken? _parseResponsiveToken(String token, TwConfig cfg) {
  final candidate = _parseCandidate(token);
  if (candidate == null) return null;

  final route = routeCandidate(candidate, breakpoints: cfg.breakpoints);
  if (route.kind == TwRouteKind.ignored ||
      route.kind == TwRouteKind.unsupported) {
    return null;
  }

  double minWidth = 0;

  for (final variant in candidate.variants) {
    if (variant is TailwindStaticVariant &&
        cfg.breakpoints.containsKey(variant.root)) {
      minWidth = cfg.breakpointOf(variant.root);
    } else {
      return null;
    }
  }

  return _ResponsiveToken(candidate.utility.raw, minWidth);
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
  BuildContext context,
) {
  // Check for min-w-auto escape hatch (respects breakpoint prefixes)
  var hasMinWidthAuto = false;
  for (final token in tokens) {
    final info = _parseResponsiveToken(token, cfg);
    if (info != null && info.minWidth <= width && info.base == 'min-w-auto') {
      hasMinWidthAuto = true;
      break;
    }
  }

  _FlexItemBehavior? behavior;
  double chosenMin = -1;

  for (final token in tokens) {
    final info = _parseResponsiveToken(token, cfg);
    if (info == null || info.minWidth > width) {
      continue;
    }

    final modifier = twFlexibleModifierForFlexItem(info.base);
    final candidate = modifier == null
        ? null
        : _flexItemBehaviorFromModifier(
            modifier,
            context,
            utility: info.base,
            hasMinWidthAuto: hasMinWidthAuto,
          );

    if (candidate != null && info.minWidth >= chosenMin) {
      behavior = candidate;
      chosenMin = info.minWidth;
    }
  }

  return behavior;
}

_FlexItemBehavior _flexItemBehaviorFromModifier(
  FlexibleModifierMix modifier,
  BuildContext context, {
  required String utility,
  required bool hasMinWidthAuto,
}) {
  final resolved = modifier.resolve(context);

  return _FlexItemBehavior(
    flex: resolved.flex ?? 1,
    fit: resolved.fit ?? FlexFit.loose,
    applyMinConstraint: _appliesAutoMinConstraint(utility, hasMinWidthAuto),
  );
}

bool _appliesAutoMinConstraint(String utility, bool hasMinWidthAuto) {
  if (hasMinWidthAuto) return false;

  return utility == 'flex-1' || utility == 'flex-shrink' || utility == 'shrink';
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
    if (info == null || info.minWidth > width) {
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
    if (info == null || info.minWidth > width) {
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
