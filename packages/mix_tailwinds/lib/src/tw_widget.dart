import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'tw_config.dart';
import 'tw_parser.dart';
import 'tw_utils.dart';

// =============================================================================
// Box/Margin Utility Detection
// =============================================================================

/// Tokens that indicate box-level styling (padding, background, border, etc.)
/// When present on Span, we need to wrap text in a Box container.
const _boxUtilityPrefixes = [
  'p-', 'px-', 'py-', 'pt-', 'pr-', 'pb-', 'pl-', // padding
  'bg-', // background
  'border', // border (includes border-*, rounded-*)
  'rounded', // border radius
  'shadow', // box shadow
  'ring', // ring
  'opacity-', // opacity
];

/// Check if classNames contain any box utilities that require wrapping.
bool _hasBoxUtilities(String classNames) {
  final tokens = classNames.split(RegExp(r'\s+'));
  for (final token in tokens) {
    // Strip variant prefixes (hover:, md:, etc.) to get base token
    final colonIdx = findLastColonOutsideBrackets(token);
    final base = colonIdx >= 0 ? token.substring(colonIdx + 1) : token;

    for (final prefix in _boxUtilityPrefixes) {
      if (base.startsWith(prefix) || base == prefix.replaceAll('-', '')) {
        return true;
      }
    }
  }
  return false;
}

/// Extract margin value from tokens for a given prefix (e.g., 'mb-').
/// Returns null if not found.
EdgeInsets? _extractMargin(String classNames, TwConfig cfg) {
  final tokens = classNames.split(RegExp(r'\s+'));
  double? top, right, bottom, left;

  for (final token in tokens) {
    final colonIdx = findLastColonOutsideBrackets(token);
    final base = colonIdx >= 0 ? token.substring(colonIdx + 1) : token;

    if (base.startsWith('m-')) {
      final value = cfg.spaceOf(base.substring(2), fallback: double.nan);
      if (!value.isNaN) {
        top = right = bottom = left = value;
      }
    } else if (base.startsWith('mx-')) {
      final value = cfg.spaceOf(base.substring(3), fallback: double.nan);
      if (!value.isNaN) {
        left = right = value;
      }
    } else if (base.startsWith('my-')) {
      final value = cfg.spaceOf(base.substring(3), fallback: double.nan);
      if (!value.isNaN) {
        top = bottom = value;
      }
    } else if (base.startsWith('mt-')) {
      final value = cfg.spaceOf(base.substring(3), fallback: double.nan);
      if (!value.isNaN) {
        top = value;
      }
    } else if (base.startsWith('mr-')) {
      final value = cfg.spaceOf(base.substring(3), fallback: double.nan);
      if (!value.isNaN) {
        right = value;
      }
    } else if (base.startsWith('mb-')) {
      final value = cfg.spaceOf(base.substring(3), fallback: double.nan);
      if (!value.isNaN) {
        bottom = value;
      }
    } else if (base.startsWith('ml-')) {
      final value = cfg.spaceOf(base.substring(3), fallback: double.nan);
      if (!value.isNaN) {
        left = value;
      }
    }
  }

  if (top == null && right == null && bottom == null && left == null) {
    return null;
  }

  return EdgeInsets.only(
    top: top ?? 0,
    right: right ?? 0,
    bottom: bottom ?? 0,
    left: left ?? 0,
  );
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
      // CSS block elements stretch by default; mimic this with CrossAxisAlignment.stretch
      final resolvedChild = child ??
          (children.isNotEmpty
              ? Column(
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
      viewportWidth: _viewportSize(context).width,
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
    if (_hasBoxUtilities(classNames)) {
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

/// Heading level 1 element with Tailwind styling.
///
/// Equivalent to HTML `<h1>`. Note: Like Tailwind's Preflight, headings have
/// no default styles - use utility classes like `text-4xl font-bold`.
/// Supports margin utilities (m-*, mx-*, my-*, mt-*, mr-*, mb-*, ml-*).
class H1 extends StatelessWidget {
  const H1({super.key, required this.text, this.classNames = '', this.config});

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

/// Heading level 2 element with Tailwind styling.
///
/// Equivalent to HTML `<h2>`. Note: Like Tailwind's Preflight, headings have
/// no default styles - use utility classes like `text-3xl font-semibold`.
/// Supports margin utilities (m-*, mx-*, my-*, mt-*, mr-*, mb-*, ml-*).
class H2 extends StatelessWidget {
  const H2({super.key, required this.text, this.classNames = '', this.config});

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

/// Heading level 3 element with Tailwind styling.
///
/// Equivalent to HTML `<h3>`. Note: Like Tailwind's Preflight, headings have
/// no default styles - use utility classes like `text-2xl font-semibold`.
/// Supports margin utilities (m-*, mx-*, my-*, mt-*, mr-*, mb-*, ml-*).
class H3 extends StatelessWidget {
  const H3({super.key, required this.text, this.classNames = '', this.config});

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

/// Heading level 4 element with Tailwind styling.
///
/// Equivalent to HTML `<h4>`. Note: Like Tailwind's Preflight, headings have
/// no default styles - use utility classes like `text-xl font-semibold`.
/// Supports margin utilities (m-*, mx-*, my-*, mt-*, mr-*, mb-*, ml-*).
class H4 extends StatelessWidget {
  const H4({super.key, required this.text, this.classNames = '', this.config});

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

/// Heading level 5 element with Tailwind styling.
///
/// Equivalent to HTML `<h5>`. Note: Like Tailwind's Preflight, headings have
/// no default styles - use utility classes like `text-lg font-semibold`.
/// Supports margin utilities (m-*, mx-*, my-*, mt-*, mr-*, mb-*, ml-*).
class H5 extends StatelessWidget {
  const H5({super.key, required this.text, this.classNames = '', this.config});

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

/// Heading level 6 element with Tailwind styling.
///
/// Equivalent to HTML `<h6>`. Note: Like Tailwind's Preflight, headings have
/// no default styles - use utility classes like `text-base font-semibold`.
/// Supports margin utilities (m-*, mx-*, my-*, mt-*, mr-*, mb-*, ml-*).
class H6 extends StatelessWidget {
  const H6({super.key, required this.text, this.classNames = '', this.config});

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
    // Use bracket-aware colon finding to handle arbitrary values like bg-[color:red]
    final colonIdx = findLastColonOutsideBrackets(token);
    final base = colonIdx >= 0 ? token.substring(colonIdx + 1) : token;
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
    if (info.minWidth > width) {
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
    // Use bracket-aware colon finding to handle arbitrary values like bg-[color:red]
    final index = findFirstColonOutsideBrackets(remaining);
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
  // Check for min-w-auto escape hatch (respects breakpoint prefixes)
  var hasMinWidthAuto = false;
  for (final token in tokens) {
    final info = _parseResponsiveToken(token, cfg);
    if (info.minWidth <= width && info.base == 'min-w-auto') {
      hasMinWidthAuto = true;
      break;
    }
  }

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
