import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'translate/tw_translator.dart';
import 'tw_config.dart';
import 'tw_layout_plan.dart';
import 'tw_types.dart';

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
    required this.responsiveWidth,
    required super.child,
  });

  static _TwFlexScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();
  final Axis axis;

  final bool isMainAxisBounded;
  final double responsiveWidth;

  @override
  bool updateShouldNotify(_TwFlexScope oldWidget) =>
      axis != oldWidget.axis ||
      isMainAxisBounded != oldWidget.isMainAxisBounded ||
      responsiveWidth != oldWidget.responsiveWidth;
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
    return axis == .horizontal
        ? renderFlex.constraints.hasBoundedWidth
        : renderFlex.constraints.hasBoundedHeight;
  }

  // First frame, no layout yet — assume bounded (safe default)
  return true;
}

// =============================================================================
// CSS Semantic Widgets
// =============================================================================

/// Applies the compiled margin outside the hover and press hit-test area.
///
/// The semantic plan supplies [externalMargin]. This widget removes the resolved
/// BoxSpec margin so only the outer Padding applies the margin.
///
/// Widget tree structure:
/// ```
/// Padding(margin)              <- OUTSIDE hover detection
///   └── StyleBuilder
///         └── MixInteractionDetector  <- Hover detection here
///               └── Box(no margin)
/// ```
class _CssSemanticBox extends StatelessWidget {
  const _CssSemanticBox({
    required this.style,
    this.child,
    this.wrapBorderBox,
    this.externalMargin,
  });

  final BoxStyler style;
  final Widget? child;
  final _BorderBoxWrapper? wrapBorderBox;
  final EdgeInsetsGeometry? externalMargin;

  @override
  Widget build(BuildContext context) {
    // Build inner content with StyleBuilder (handles variants/animations).
    // The compiler keeps margin out of widget Stylers; the plan owns it.
    Widget inner = StyleBuilder<BoxSpec>(
      style: style,
      builder: (context, spec) => Box(
        styleSpec: StyleSpec(spec: spec),
        child: child,
      ),
    );

    if (wrapBorderBox case final wrap?) {
      inner = wrap(inner);
    }

    // Apply margin outside MixInteractionDetector.
    if (externalMargin case final margin?) {
      inner = Padding(padding: margin, child: inner);
    }

    return inner;
  }
}

/// A FlexBox widget with CSS-style margin semantics.
///
/// See [_CssSemanticBox] for details on CSS margin semantics.
class _CssSemanticFlexBox extends StatelessWidget {
  const _CssSemanticFlexBox({
    required this.style,
    required this.children,
    this.wrapBorderBox,
    this.selfAlignments,
    this.zeroBasisItems,
    this.externalMargin,
  });

  final FlexBoxStyler style;
  final List<Widget> children;
  final _BorderBoxWrapper? wrapBorderBox;
  final EdgeInsetsGeometry? externalMargin;

  /// Per-child `self-*` alignment, positional and null where a child keeps the
  /// container's alignment. Null when no child opts out at all.
  final List<_SelfAlignment?>? selfAlignments;

  /// CSS sizing inputs for direct `flex-basis: 0` children. Null keeps the
  /// stock Flutter flex path.
  final List<_ZeroBasisFlexItem?>? zeroBasisItems;

  @override
  Widget build(BuildContext context) {
    // Build inner content with StyleBuilder (handles variants/animations).
    // The compiler keeps margin out of widget Stylers; the plan owns it.
    Widget inner = StyleBuilder<FlexBoxSpec>(
      style: style,
      builder: (context, spec) {
        final alignments = selfAlignments;
        final items = zeroBasisItems;
        if (alignments == null && items == null) {
          return FlexBox(
            styleSpec: StyleSpec(spec: spec),
            children: children,
          );
        }

        // FlexBox is a Box wrapping a Flex, so rebuild that composition when
        // Tailwind needs per-child alignment or content-box flex sizing.
        final flexSpec = spec.flex?.spec;
        final Widget flex = _TailwindFlex(
          direction: flexSpec?.direction ?? .horizontal,
          mainAxisAlignment: flexSpec?.mainAxisAlignment ?? .start,
          mainAxisSize: flexSpec?.mainAxisSize ?? .max,
          crossAxisAlignment: flexSpec?.crossAxisAlignment ?? .center,
          verticalDirection: flexSpec?.verticalDirection ?? .down,
          clipBehavior: flexSpec?.clipBehavior ?? .none,
          spacing: flexSpec?.spacing ?? 0.0,
          selfAlignments: alignments ?? const [],
          zeroBasisItems: items ?? const [],
          textDirection: flexSpec?.textDirection,
          textBaseline: flexSpec?.textBaseline,
          children: children,
        );

        final box = spec.box;

        return box == null ? flex : Box(styleSpec: box, child: flex);
      },
    );

    if (wrapBorderBox case final wrap?) {
      inner = wrap(inner);
    }

    // Apply margin outside MixInteractionDetector.
    if (externalMargin case final margin?) {
      inner = Padding(padding: margin, child: inner);
    }

    return inner;
  }
}

// =============================================================================
// Public Widgets
// =============================================================================

/// A Tailwind element that exposes the class string it was built from.
///
/// A Tailwind flex container reads this interface on direct children for
/// semantics that Flutter's [RenderFlex] cannot infer from their render boxes,
/// including `self-*` alignment and zero-basis content-box sizing.
abstract interface class TwClassed {
  String get classNames;
}

abstract interface class _TwConfigured {
  TwConfig? get config;
}

/// Internal description needed to compile a built-in Tailwind widget once.
abstract interface class _TwCompilable implements TwClassed, _TwConfigured {
  TwWidgetCompilationMode get _compilationMode;

  bool? get _forceFlex;
}

class Div extends StatelessWidget implements _TwCompilable {
  const Div({
    super.key,
    required this.classNames,
    this.child,
    this.children = const [],
    this.isFlex,
    this.onDiagnostic,
    @Deprecated('Use onDiagnostic instead.') this.onUnsupported,
    this.config,
  });

  @override
  final String classNames;
  final Widget? child;
  final List<Widget> children;
  final bool? isFlex;
  @override
  final TwConfig? config;
  final TwDiagnosticCallback? onDiagnostic;

  @override
  TwWidgetCompilationMode get _compilationMode => .boxOrFlex;

  @override
  bool? get _forceFlex => isFlex;

  @Deprecated('Use onDiagnostic instead.')
  final void Function(String token)? onUnsupported;

  @override
  Widget build(BuildContext context) {
    return _TwElement(
      classNames: classNames,
      isFlex: isFlex,
      onDiagnostic: onDiagnostic,
      onUnsupported: onUnsupported,
      config: config,
      child: child,
      children: children,
    );
  }
}

/// A Tailwind-styled button backed by Mix [Pressable].
///
/// Its margin remains outside the interactive and semantic hit-test area,
/// matching the CSS box model. A null [onPressed] disables the button unless
/// [onLongPress] provides an action.
class Button extends StatelessWidget implements _TwCompilable {
  const Button({
    super.key,
    required this.classNames,
    required this.onPressed,
    this.child,
    this.children = const [],
    this.isFlex,
    this.onDiagnostic,
    @Deprecated('Use onDiagnostic instead.') this.onUnsupported,
    this.config,
    this.enableFeedback = false,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.onLongPress,
    this.onFocusChange,
    this.autofocus = false,
    this.focusNode,
    this.mouseCursor,
    this.canRequestFocus = true,
    this.excludeFromSemantics = false,
    this.semanticsLabel,
    this.onKeyEvent,
    this.controller,
    this.actions,
  });

  @override
  final String classNames;
  final VoidCallback? onPressed;
  final Widget? child;
  final List<Widget> children;
  final bool? isFlex;
  @override
  final TwConfig? config;
  final TwDiagnosticCallback? onDiagnostic;

  @override
  TwWidgetCompilationMode get _compilationMode => .boxOrFlex;

  @override
  bool? get _forceFlex => isFlex;

  @Deprecated('Use onDiagnostic instead.')
  final void Function(String token)? onUnsupported;

  final bool enableFeedback;
  final HitTestBehavior hitTestBehavior;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onFocusChange;
  final bool autofocus;
  final FocusNode? focusNode;
  final MouseCursor? mouseCursor;
  final bool canRequestFocus;
  final bool excludeFromSemantics;

  /// An accessible label for a child that does not provide one itself.
  ///
  /// Omit this when visible child text already names the button because Mix
  /// combines an explicit label with descendant semantics.
  final String? semanticsLabel;
  final FocusOnKeyEventCallback? onKeyEvent;
  final WidgetStatesController? controller;
  final Map<Type, Action<Intent>>? actions;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null || onLongPress != null;

    return _TwElement(
      classNames: classNames,
      isFlex: isFlex,
      onDiagnostic: onDiagnostic,
      onUnsupported: onUnsupported,
      config: config,
      wrapBorderBox: (child) => Pressable(
        enabled: enabled,
        enableFeedback: enableFeedback,
        onPress: onPressed,
        hitTestBehavior: hitTestBehavior,
        onLongPress: onLongPress,
        onFocusChange: onFocusChange,
        autofocus: autofocus,
        focusNode: focusNode,
        mouseCursor: mouseCursor,
        canRequestFocus: canRequestFocus,
        excludeFromSemantics: excludeFromSemantics,
        semanticsLabel: semanticsLabel,
        semanticsRole: .button,
        onKeyEvent: onKeyEvent,
        controller: controller,
        actions: actions,
        child: child,
      ),
      child: child,
      children: children,
    );
  }
}

typedef _BorderBoxWrapper = Widget Function(Widget child);

class _TwPreparedCompilationScope extends InheritedWidget {
  const _TwPreparedCompilationScope({
    super.key,
    required this.classNames,
    required this.config,
    required this.mode,
    required this.forceFlex,
    required this.compilation,
    required super.child,
  });

  static _TwPreparedCompilationScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  final String classNames;
  final TwConfig config;
  final TwWidgetCompilationMode mode;
  final bool? forceFlex;
  final TwWidgetCompilation compilation;

  bool matches({
    required String classNames,
    required TwConfig config,
    required TwWidgetCompilationMode mode,
    required bool? forceFlex,
  }) =>
      this.classNames == classNames &&
      identical(this.config, config) &&
      this.mode == mode &&
      this.forceFlex == forceFlex;

  @override
  bool updateShouldNotify(_TwPreparedCompilationScope oldWidget) =>
      !identical(compilation, oldWidget.compilation) ||
      !identical(config, oldWidget.config) ||
      classNames != oldWidget.classNames ||
      mode != oldWidget.mode ||
      forceFlex != oldWidget.forceFlex;
}

TwWidgetCompilation _compileBuiltInWidget(
  BuildContext context, {
  required String classNames,
  required TwConfig config,
  required TwWidgetCompilationMode mode,
  bool? forceFlex,
}) {
  final prepared = _TwPreparedCompilationScope.maybeOf(context);
  if (prepared != null &&
      prepared.matches(
        classNames: classNames,
        config: config,
        mode: mode,
        forceFlex: forceFlex,
      )) {
    return prepared.compilation;
  }

  return TwTranslator(
    config: config,
  ).compileForWidget(classNames, mode, forceFlex: forceFlex);
}

class _TwElement extends StatefulWidget {
  const _TwElement({
    required this.classNames,
    required this.child,
    required this.children,
    required this.isFlex,
    required this.onDiagnostic,
    required this.onUnsupported,
    required this.config,
    this.wrapBorderBox,
  });

  final String classNames;
  final Widget? child;
  final List<Widget> children;
  final bool? isFlex;
  final TwConfig? config;
  final TwDiagnosticCallback? onDiagnostic;
  final void Function(String token)? onUnsupported;
  final _BorderBoxWrapper? wrapBorderBox;

  @override
  State<_TwElement> createState() => _TwElementState();
}

class _TwElementState extends State<_TwElement> {
  TwConfig? _compiledConfig;
  String? _compiledClassNames;
  bool? _compiledForceFlex;
  TwWidgetCompilation? _compilation;
  TwDiagnosticCallback? _reportedOnDiagnostic;
  void Function(String token)? _reportedOnUnsupported;

  void _replayDiagnostics(TwWidgetCompilation compilation) {
    for (final diagnostic in compilation.diagnostics) {
      widget.onDiagnostic?.call(diagnostic);
      widget.onUnsupported?.call(diagnostic.token);
    }
    _reportedOnDiagnostic = widget.onDiagnostic;
    _reportedOnUnsupported = widget.onUnsupported;
  }

  TwWidgetCompilation _compile(BuildContext context, TwConfig config) {
    final cached = _compilation;
    if (cached != null &&
        identical(config, _compiledConfig) &&
        widget.classNames == _compiledClassNames &&
        widget.isFlex == _compiledForceFlex) {
      if (!identical(widget.onDiagnostic, _reportedOnDiagnostic) ||
          !identical(widget.onUnsupported, _reportedOnUnsupported)) {
        _replayDiagnostics(cached);
      }

      return cached;
    }

    final compilation = _compileBuiltInWidget(
      context,
      classNames: widget.classNames,
      config: config,
      mode: .boxOrFlex,
      forceFlex: widget.isFlex,
    );
    _replayDiagnostics(compilation);
    _compiledConfig = config;
    _compiledClassNames = widget.classNames;
    _compiledForceFlex = widget.isFlex;
    _compilation = compilation;

    return compilation;
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.child == null || widget.children.isEmpty,
      'Provide either child or children, not both.',
    );
    final cfg = widget.config ?? TwConfigProvider.of(context);
    final compilation = _compile(context, cfg);
    final shouldUseFlex = compilation.wantsFlex;
    final plan = compilation.layoutPlan;

    Widget built;

    if (shouldUseFlex) {
      final rawChildren = widget.children.isNotEmpty
          ? List.of(widget.children)
          : (widget.child != null ? <Widget>[widget.child!] : const <Widget>[]);
      final preparedChildren = _prepareFlexChildren(rawChildren, cfg);

      built = _buildResponsiveFlex(
        plan: plan,
        baseStyle: compilation.flexStyler!,
        preparedChildren: preparedChildren,
        wrapBorderBox: widget.wrapBorderBox,
      );
    } else {
      // CSS block elements stretch horizontally but shrink-wrap vertically.
      final resolvedChild =
          widget.child ??
          (widget.children.isNotEmpty
              ? Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .stretch,
                  children: widget.children,
                )
              : null);

      built = _buildResponsiveBox(
        plan: plan,
        style: compilation.boxStyler!,
        wrapBorderBox: widget.wrapBorderBox,
        child: resolvedChild,
      );
    }

    return _wrapWithFlexItemDecorators(
      plan: plan,
      viewportWidth: _responsiveWidth(null, context),
      child: built,
    );
  }
}

EdgeInsets? _externalMargin(TwCompiledLayoutPlan plan, double width) {
  final margin = plan.externalMargin.select(width);
  if (margin == null ||
      (margin.left == 0 &&
          margin.top == 0 &&
          margin.right == 0 &&
          margin.bottom == 0)) {
    return null;
  }

  return EdgeInsets.fromLTRB(
    margin.left,
    margin.top,
    margin.right,
    margin.bottom,
  );
}

EdgeInsetsGeometry? _iconMargin(TwCompiledLayoutPlan plan, double width) {
  final margin = plan.iconLogicalMargin.select(width);
  if (margin == null ||
      (margin.start == 0 &&
          margin.end == 0 &&
          margin.left == 0 &&
          margin.right == 0)) {
    return null;
  }

  return EdgeInsetsDirectional.only(
    start: margin.start,
    end: margin.end,
  ).add(.only(left: margin.left, right: margin.right));
}

Widget _buildWithResponsiveMargin<T>(
  BuildContext context,
  TwResponsiveValue<T> margins,
  Widget Function(double width) builder,
) {
  final viewportWidth = _viewportSize(context).width;
  final hasBreakpoints = margins.entries.any((entry) => entry.minWidth > 0);
  // Static margins need no constraints. A known viewport or enclosing flex
  // scope also lets responsive margins participate in intrinsic measurement.
  if (!hasBreakpoints || viewportWidth > 0) return builder(viewportWidth);
  final scope = _TwFlexScope.maybeOf(context);
  if (scope != null) return builder(scope.responsiveWidth);

  return LayoutBuilder(
    builder: (context, constraints) =>
        builder(_responsiveWidth(constraints, context)),
  );
}

Widget _wrapWithResponsiveExternalMargin(
  BuildContext context,
  Widget child,
  TwCompiledLayoutPlan plan,
) {
  if (plan.externalMargin.isEmpty) return child;

  return _buildWithResponsiveMargin(context, plan.externalMargin, (width) {
    final margin = _externalMargin(plan, width);

    return margin == null ? child : Padding(padding: margin, child: child);
  });
}

Widget _wrapWithResponsiveIconMargin(
  BuildContext context,
  Widget child,
  TwCompiledLayoutPlan plan,
) {
  if (plan.iconLogicalMargin.isEmpty) return child;

  return _buildWithResponsiveMargin(context, plan.iconLogicalMargin, (width) {
    final margin = _iconMargin(plan, width);

    return margin == null ? child : Padding(padding: margin, child: child);
  });
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
class P extends StatelessWidget implements _TwCompilable {
  const P({super.key, required this.text, this.classNames = '', this.config});

  final String text;
  @override
  final String classNames;
  @override
  final TwConfig? config;

  @override
  TwWidgetCompilationMode get _compilationMode => .text;

  @override
  bool? get _forceFlex => null;

  @override
  Widget build(BuildContext context) {
    final cfg = config ?? TwConfigProvider.of(context);
    final compilation = _compileBuiltInWidget(
      context,
      classNames: classNames,
      config: cfg,
      mode: _compilationMode,
    );
    Widget result = StyledText(text, style: compilation.textStyler!);

    result = _wrapWithResponsiveExternalMargin(
      context,
      result,
      compilation.layoutPlan,
    );

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
class Span extends StatelessWidget implements _TwCompilable {
  const Span({
    super.key,
    required this.text,
    this.classNames = '',
    this.config,
  });

  final String text;
  @override
  final String classNames;
  @override
  final TwConfig? config;

  @override
  TwWidgetCompilationMode get _compilationMode => .inline;

  @override
  bool? get _forceFlex => null;

  @override
  Widget build(BuildContext context) {
    final cfg = config ?? TwConfigProvider.of(context);
    final compilation = _compileBuiltInWidget(
      context,
      classNames: classNames,
      config: cfg,
      mode: _compilationMode,
    );

    // Check if we need box styling (padding, background, border, etc.)
    if (compilation.hasBoxUtilities) {
      // Use inline layout (no block-level stretch)
      return _buildWithResponsiveMargin(
        context,
        compilation.layoutPlan.externalMargin,
        (width) => _CssSemanticBox(
          style: compilation.boxStyler!,
          externalMargin: _externalMargin(compilation.layoutPlan, width),
          child: StyledText(text, style: compilation.textStyler!),
        ),
      );
    }

    // No box utilities - render as simple styled text
    return StyledText(text, style: compilation.textStyler!);
  }
}

/// Icon element with Tailwind-style size and color utilities.
///
/// This is a small bridge between Tailwind SVG icon classes and Mix's
/// [StyledIcon]. It supports the icon classes used by common inline SVGs:
/// `w-*`, `h-*`, `text-*`, and positive logical/physical margin tokens.
class TwIcon extends StatelessWidget implements _TwCompilable {
  const TwIcon(
    this.icon, {
    super.key,
    this.classNames = '',
    this.config,
    this.semanticLabel,
  });

  final IconData icon;
  @override
  final String classNames;
  @override
  final TwConfig? config;
  final String? semanticLabel;

  @override
  TwWidgetCompilationMode get _compilationMode => .icon;

  @override
  bool? get _forceFlex => null;

  @override
  Widget build(BuildContext context) {
    final cfg = config ?? TwConfigProvider.of(context);
    final compilation = _compileBuiltInWidget(
      context,
      classNames: classNames,
      config: cfg,
      mode: _compilationMode,
    );

    // Preserve the inherited text color as a fallback; the parsed icon style
    // overrides it when the class names include a `text-<color>` utility.
    final fallbackColor = DefaultTextStyle.of(context).style.color;
    var style = fallbackColor != null
        ? IconStyler().color(fallbackColor)
        : IconStyler();
    style = style.merge(compilation.iconStyler!);

    Widget current = StyledIcon(
      icon: icon,
      semanticLabel: semanticLabel,
      style: style,
    );

    current = _wrapWithResponsiveIconMargin(
      context,
      current,
      compilation.layoutPlan,
    );

    return current;
  }
}

abstract class _Heading extends StatelessWidget implements _TwCompilable {
  const _Heading({
    super.key,
    required this._headingLevel,
    required this.text,
    this.classNames = '',
    this.config,
  });

  final int _headingLevel;
  final String text;
  @override
  final String classNames;
  @override
  final TwConfig? config;

  @override
  TwWidgetCompilationMode get _compilationMode => .text;

  @override
  bool? get _forceFlex => null;

  @override
  Widget build(BuildContext context) {
    final cfg = config ?? TwConfigProvider.of(context);
    final compilation = _compileBuiltInWidget(
      context,
      classNames: classNames,
      config: cfg,
      mode: _compilationMode,
    );
    Widget result = StyledText(text, style: compilation.textStyler!);

    result = _wrapWithResponsiveExternalMargin(
      context,
      result,
      compilation.layoutPlan,
    );

    return Semantics(headingLevel: _headingLevel, child: result);
  }
}

/// Heading level 1 element with Tailwind styling.
///
/// Equivalent to HTML `<h1>`. Like Tailwind's Preflight, headings have no
/// default styles; use utility classes such as `text-4xl font-bold`.
/// Exposes Flutter semantics heading level 1 and supports margin utilities.
class H1 extends _Heading {
  const H1({
    super.key,
    required super.text,
    super.classNames = '',
    super.config,
  }) : super(headingLevel: 1);
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
  }) : super(headingLevel: 2);
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
  }) : super(headingLevel: 3);
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
  }) : super(headingLevel: 4);
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
  }) : super(headingLevel: 5);
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
  }) : super(headingLevel: 6);
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
class TruncatedP extends StatelessWidget implements TwClassed, _TwConfigured {
  const TruncatedP({
    super.key,
    required this.text,
    this.classNames = '',
    this.config,
  });

  final String text;
  @override
  final String classNames;
  @override
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

  return List.generate(input.length, (index) {
    final isFirst = index == 0;
    final isLast = index == lastIndex;
    final padding = axis == .horizontal
        ? EdgeInsets.only(
            top: isFirst ? 0 : halfGap,
            bottom: isLast ? 0 : halfGap,
          )
        : EdgeInsets.only(
            left: isFirst ? 0 : halfGap,
            right: isLast ? 0 : halfGap,
          );

    final child = input[index];

    return Padding(
      key: child.key == null ? null : ValueKey(child.key),
      padding: padding,
      child: child,
    );
  }, growable: false);
}

@immutable
final class _PreparedFlexChild {
  final Widget child;
  final TwCompiledLayoutPlan? parentLayoutPlan;

  const _PreparedFlexChild({
    required this.parentLayoutPlan,
    required this.child,
  });
}

List<_PreparedFlexChild> _prepareFlexChildren(
  List<Widget> children,
  TwConfig inheritedConfig,
) {
  return children
      .map((child) {
        final Object childDescriptor = child;
        final childConfig = switch (childDescriptor) {
          _TwConfigured(:final config) => config ?? inheritedConfig,
          _ => inheritedConfig,
        };
        if (childDescriptor case final _TwCompilable descriptor) {
          final compilation = TwTranslator(config: childConfig)
              .compileForWidget(
                descriptor.classNames,
                descriptor._compilationMode,
                forceFlex: descriptor._forceFlex,
              );

          return _PreparedFlexChild(
            parentLayoutPlan: compilation.parentLayoutPlan,
            child: _TwPreparedCompilationScope(
              key: child.key == null ? null : ValueKey(child.key),
              classNames: descriptor.classNames,
              config: childConfig,
              mode: descriptor._compilationMode,
              forceFlex: descriptor._forceFlex,
              compilation: compilation,
              child: child,
            ),
          );
        }

        if (childDescriptor case final TwClassed classed) {
          final compilation = TwTranslator(
            config: childConfig,
          ).compileForWidget(classed.classNames, .boxOrFlex);

          return _PreparedFlexChild(
            parentLayoutPlan: compilation.parentLayoutPlan,
            child: child,
          );
        }

        return _PreparedFlexChild(parentLayoutPlan: null, child: child);
      })
      .toList(growable: false);
}

@immutable
class _ZeroBasisFlexItem {
  final double grow;

  /// Margin, padding, and border along the container's main axis.
  final double outerExtra;

  const _ZeroBasisFlexItem({required this.grow, required this.outerExtra});

  @override
  bool operator ==(Object other) =>
      other is _ZeroBasisFlexItem &&
      grow == other.grow &&
      outerExtra == other.outerExtra;

  @override
  int get hashCode => Object.hash(grow, outerExtra);
}

_ZeroBasisFlexItem? _zeroBasisFlexItemOfPlan(
  TwCompiledLayoutPlan? plan,
  double width,
  double styleWidth,
  Axis axis,
) {
  if (plan == null) return null;
  final grow = plan.flexItem.resolve(width).zeroBasisGrow;
  if (grow == null || grow <= 0) return null;

  return _ZeroBasisFlexItem(
    grow: grow,
    outerExtra: plan.zeroBasisOuterExtent(
      _twFlexAxis(axis),
      marginWidth: width,
      styleWidth: styleWidth,
    ),
  );
}

Widget _buildResponsiveFlex({
  required TwCompiledLayoutPlan plan,
  required FlexBoxStyler baseStyle,
  required List<_PreparedFlexChild> preparedChildren,
  _BorderBoxWrapper? wrapBorderBox,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final rawChildren = preparedChildren
          .map((prepared) => prepared.child)
          .toList(growable: false);
      final childPlans = preparedChildren
          .map((prepared) => prepared.parentLayoutPlan)
          .toList(growable: false);
      final layoutWidth = _responsiveWidth(constraints, context);
      final styleWidth = _viewportSize(context).width;
      final resolvedContainer = plan.flexContainer.resolve(layoutWidth);
      final axis = _flutterAxis(resolvedContainer.axis);
      final isMainAxisBounded = axis == .horizontal
          ? constraints.hasBoundedWidth
          : constraints.hasBoundedHeight;

      var style = baseStyle;
      final mainGap = resolvedContainer.mainGap;
      if (mainGap != null) {
        style = style.spacing(mainGap);
      }

      final crossGap = resolvedContainer.crossGap;
      final flexChildren = _applyCrossAxisGap(rawChildren, axis, crossGap);

      // CSS `align-self` lets a child opt out of the container's `align-items`.
      // RenderFlex has one cross alignment for every child, so the opt-out is
      // carried to the flex itself and applied after it has sized its cross
      // axis. Collected positionally: the gap wrapper preserves child order.
      final selfAlignments = childPlans
          .map(
            (childPlan) => childPlan == null
                ? null
                : _selfAlignment(
                    childPlan.flexItem.resolve(layoutWidth).selfAlignment,
                  ),
          )
          .toList(growable: false);
      final hasSelfAlignedChild = selfAlignments.any((a) => a != null);
      final zeroBasisItems = childPlans
          .map(
            (childPlan) => _zeroBasisFlexItemOfPlan(
              childPlan,
              layoutWidth,
              styleWidth,
              axis,
            ),
          )
          .toList(growable: false);
      final zeroBasisChildren = zeroBasisItems
          .whereType<_ZeroBasisFlexItem>()
          .toList(growable: false);
      final totalGrow = zeroBasisChildren.fold<double>(
        0,
        (sum, item) => sum + item.grow,
      );
      final totalOuterExtra = zeroBasisChildren.fold<double>(
        0,
        (sum, item) => sum + item.outerExtra,
      );
      // Stock RenderFlex is already correct when each item's non-content
      // extent is proportional to its grow factor.
      final needsContentBoxSizing =
          zeroBasisChildren.length > 1 &&
          zeroBasisChildren.any(
            (item) =>
                (item.outerExtra * totalGrow - totalOuterExtra * item.grow)
                    .abs() >
                0.001,
          );

      // CSS parity: Tailwind's default `align-items` is `stretch` (unless an
      // explicit `items-*` utility is present). Stretch is invalid on an
      // unbounded Flutter cross axis, so use `start` there to preserve CSS
      // block-child alignment instead of FlexBox's centered fallback.
      if (resolvedContainer.implicitCrossAxisPolicy ==
          .stretchWhenBoundedStartWhenUnbounded) {
        final isCrossAxisBounded = axis == .horizontal
            ? constraints.hasBoundedHeight
            : constraints.hasBoundedWidth;
        style = style.crossAxisAlignment(
          isCrossAxisBounded ? .stretch : .start,
        );
      }

      // Use CSS semantic flex box - margin is outside hover/press detection area
      Widget current = _TwFlexScope(
        axis: axis,
        isMainAxisBounded: isMainAxisBounded,
        responsiveWidth: layoutWidth,
        child: _CssSemanticFlexBox(
          style: style,
          wrapBorderBox: wrapBorderBox,
          selfAlignments: hasSelfAlignedChild ? selfAlignments : null,
          zeroBasisItems: needsContentBoxSizing ? zeroBasisItems : null,
          externalMargin: _externalMargin(plan, layoutWidth),
          children: flexChildren,
        ),
      );
      current = _applyResponsiveSizing(
        dimensions: plan.dimensions,
        constraints: constraints,
        context: context,
        width: layoutWidth,
        child: current,
      );

      return current;
    },
  );
}

Widget _buildResponsiveBox({
  required TwCompiledLayoutPlan plan,
  required BoxStyler style,
  Widget? child,
  _BorderBoxWrapper? wrapBorderBox,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final width = _responsiveWidth(constraints, context);
      // Use CSS semantic box - margin is outside hover/press detection area
      Widget current = _CssSemanticBox(
        style: style,
        wrapBorderBox: wrapBorderBox,
        externalMargin: _externalMargin(plan, width),
        child: child,
      );
      current = _applyResponsiveSizing(
        dimensions: plan.dimensions,
        constraints: constraints,
        context: context,
        width: width,
        child: current,
      );

      return current;
    },
  );
}

Widget _applyResponsiveSizing({
  required TwDimensionPlan dimensions,
  required BoxConstraints constraints,
  required BuildContext context,
  required double width,
  required Widget child,
}) {
  var current = _applyContainerSizingResponsive(
    child,
    dimensions,
    constraints,
    context,
    width,
  );
  current = _applyMinSizingResponsive(current, dimensions, context, width);
  current = _applyFractionalSizingResponsive(current, dimensions, width);

  return _loosenFixedWidthUnderTightStretch(
    current,
    dimensions,
    width,
    constraints,
  );
}

Widget _wrapWithFlexItemDecorators({
  required Widget child,
  required TwCompiledLayoutPlan plan,
  required double viewportWidth,
}) {
  if (!_needsFlexItemDecorators(plan)) {
    return child;
  }

  return Builder(
    builder: (context) =>
        _applyFlexItemDecorators(child, plan, context, viewportWidth),
  );
}

bool _needsFlexItemDecorators(TwCompiledLayoutPlan plan) =>
    !plan.flexItem.isEmpty ||
    _hasDimensionKind(plan.dimensions.width, .full) ||
    _hasDimensionKind(plan.dimensions.height, .full);

Widget _applyContainerSizingResponsive(
  Widget child,
  TwDimensionPlan dimensions,
  BoxConstraints constraints,
  BuildContext context,
  double width,
) {
  final widthIntent = dimensions.width.select(width);
  final heightIntent = dimensions.height.select(width);
  final hasWidthIntent = _isContainerDimension(widthIntent);
  final hasHeightIntent = _isContainerDimension(heightIntent);

  if (!hasWidthIntent && !hasHeightIntent) {
    return child;
  }

  final viewport = _viewportSize(context);
  double? targetWidth;
  double? targetHeight;

  if (hasWidthIntent) {
    targetWidth = widthIntent!.kind == .screen
        ? (viewport.width > 0
              ? viewport.width
              : _finiteOrNull(constraints.maxWidth))
        : (_finiteOrNull(constraints.maxWidth) ??
              (viewport.width > 0 ? viewport.width : null));
  }

  if (hasHeightIntent) {
    targetHeight = heightIntent!.kind == .screen
        ? (viewport.height > 0
              ? viewport.height
              : _finiteOrNull(constraints.maxHeight))
        : (_finiteOrNull(constraints.maxHeight) ??
              (viewport.height > 0 ? viewport.height : null));
  }

  if (targetWidth == null && targetHeight == null) {
    return child;
  }

  return SizedBox(width: targetWidth, height: targetHeight, child: child);
}

bool _isContainerDimension(TwDimensionIntent? intent) =>
    intent?.kind == .full || intent?.kind == .screen;

Widget _applyMinSizingResponsive(
  Widget child,
  TwDimensionPlan dimensions,
  BuildContext context,
  double width,
) {
  final minWidthScreen = dimensions.minWidth.select(width)?.kind == .screen;
  final minHeightScreen = dimensions.minHeight.select(width)?.kind == .screen;

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

Widget _applyFractionalSizingResponsive(
  Widget child,
  TwDimensionPlan dimensions,
  double width,
) {
  final widthIntent = dimensions.width.select(width);
  final heightIntent = dimensions.height.select(width);
  final widthFactor = widthIntent?.kind == .fraction
      ? widthIntent?.value
      : null;
  final heightFactor = heightIntent?.kind == .fraction
      ? heightIntent?.value
      : null;

  if (widthFactor == null && heightFactor == null) {
    return child;
  }

  return FractionallySizedBox(
    alignment: AlignmentDirectional.topStart,
    widthFactor: widthFactor,
    heightFactor: heightFactor,
    child: child,
  );
}

Widget _loosenFixedWidthUnderTightStretch(
  Widget child,
  TwDimensionPlan dimensions,
  double width,
  BoxConstraints constraints,
) {
  final activeWidth = dimensions.width.select(width);
  if (!constraints.hasTightWidth || activeWidth?.kind != .fixed) {
    return child;
  }

  return Align(alignment: AlignmentDirectional.centerStart, child: child);
}

Widget _applyFlexItemDecorators(
  Widget child,
  TwCompiledLayoutPlan plan,
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

  final widthIntent = plan.dimensions.width.select(viewportWidth)?.kind;
  final heightIntent = plan.dimensions.height.select(viewportWidth)?.kind;
  final resolvedItem = plan.flexItem.resolve(viewportWidth);

  final basis =
      resolvedItem.hasExplicitBasis && resolvedItem.basis.kind != .auto
      ? resolvedItem.basis
      : null;
  if (basis != null) {
    current = _applyBasis(current, basis, axis);
  }

  final selfAlignment = _selfAlignment(resolvedItem.selfAlignment);
  if (selfAlignment != null) {
    current = _positionInCrossAxis(current, selfAlignment, axis);
  }

  final behavior = _flexItemBehavior(resolvedItem.behavior);

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
  final wantsFullOnMainAxis = axis == .horizontal
      ? widthIntent == .full
      : heightIntent == .full;
  if (!isAlreadyFlexible &&
      wantsFullOnMainAxis &&
      behavior == null &&
      basis == null &&
      isMainAxisBounded) {
    current = _FlexParentDataWrapper(flex: 1, fit: .tight, child: current);
  }

  if (behavior != null) {
    // CSS parity: flex-grow has no effect in unbounded context.
    if (isMainAxisBounded || behavior.flex <= 0) {
      current = _FlexParentDataWrapper(
        flex: behavior.flex,
        fit: behavior.fit,
        child: current,
      );
    }
  }

  return current;
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
  final scope = _TwFlexScope.maybeOf(context);
  if (scope != null) return scope.responsiveWidth;
  if (constraints != null) {
    return _effectiveWidth(constraints, context);
  }

  return 0;
}

Size _viewportSize(BuildContext context) {
  final query = MediaQuery.maybeOf(context);

  return query?.size ?? .zero;
}

double? _finiteOrNull(double value) => value.isFinite ? value : null;

class _FlexItemBehavior {
  final int flex;

  final FlexFit fit;
  const _FlexItemBehavior({required this.flex, required this.fit});
}

enum _SelfAlignment { start, center, end }

Axis _flutterAxis(TwFlexAxis axis) => switch (axis) {
  .horizontal => .horizontal,
  .vertical => .vertical,
};

TwFlexAxis _twFlexAxis(Axis axis) => switch (axis) {
  .horizontal => .horizontal,
  .vertical => .vertical,
};

_SelfAlignment? _selfAlignment(TwSelfAlignment? alignment) =>
    switch (alignment) {
      .start => .start,
      .center => .center,
      .end => .end,
      null => null,
    };

_FlexItemBehavior? _flexItemBehavior(TwFlexBehavior? behavior) {
  if (behavior == null) return null;

  return _FlexItemBehavior(
    flex: behavior.flex,
    fit: switch (behavior.fit) {
      .tight => .tight,
      .loose => .loose,
    },
  );
}

bool _hasDimensionKind(
  TwResponsiveValue<TwDimensionIntent> value,
  TwDimensionKind kind,
) => value.entries.any((entry) => entry.value.kind == kind);

Widget _applyBasis(Widget child, TwFlexBasis basis, Axis axis) {
  if (basis.pixels != null) {
    return SizedBox(
      width: axis == .horizontal ? basis.pixels : null,
      height: axis == .vertical ? basis.pixels : null,
      child: child,
    );
  }

  return child;
}

/// Places [child] at [position] within the cross extent the flex handed it.
///
/// With a tight cross extent, [Align] positions the styled box inside that
/// extent. With a loose extent it shrink-wraps, and [_RenderTailwindFlex]
/// positions the wrapper after the flex has determined its own size.
Widget _positionInCrossAxis(Widget child, _SelfAlignment position, Axis axis) {
  final resolved = switch (position) {
    .start =>
      axis == .horizontal
          ? AlignmentDirectional.topCenter
          : AlignmentDirectional.centerStart,
    .center => AlignmentDirectional.center,
    .end =>
      axis == .horizontal
          ? AlignmentDirectional.bottomCenter
          : AlignmentDirectional.centerEnd,
  };

  return Align(alignment: resolved, child: child);
}

/// A [Flex] that fills the two CSS gaps Flutter's [RenderFlex] cannot express:
/// per-child cross alignment and zero-basis content-box distribution.
///
/// [selfAlignments] is positional: entry _i_ belongs to child _i_, and null
/// means the child keeps the container's alignment.
class _TailwindFlex extends Flex {
  const _TailwindFlex({
    required super.direction,
    required super.mainAxisAlignment,
    required super.mainAxisSize,
    required super.crossAxisAlignment,
    required super.verticalDirection,
    required super.clipBehavior,
    required super.spacing,
    required this.selfAlignments,
    required this.zeroBasisItems,
    super.textDirection,
    super.textBaseline,
    super.children,
  });

  final List<_SelfAlignment?> selfAlignments;
  final List<_ZeroBasisFlexItem?> zeroBasisItems;

  @override
  RenderFlex createRenderObject(BuildContext context) {
    return _RenderTailwindFlex(
        direction: direction,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        verticalDirection: verticalDirection,
        clipBehavior: clipBehavior,
        spacing: spacing,
        textDirection: getEffectiveTextDirection(context),
        textBaseline: textBaseline,
      )
      ..selfAlignments = selfAlignments
      ..zeroBasisItems = zeroBasisItems;
  }

  @override
  void updateRenderObject(BuildContext context, RenderFlex renderObject) {
    super.updateRenderObject(context, renderObject);
    final tailwindFlex = renderObject as _RenderTailwindFlex;
    tailwindFlex
      ..selfAlignments = selfAlignments
      ..zeroBasisItems = zeroBasisItems;
  }
}

class _RenderTailwindFlex extends RenderFlex {
  List<_SelfAlignment?> _selfAlignments = const [];

  List<_ZeroBasisFlexItem?> _zeroBasisItems = const [];
  _RenderTailwindFlex({
    required super.direction,
    required super.mainAxisAlignment,
    required super.mainAxisSize,
    required super.crossAxisAlignment,
    required super.verticalDirection,
    required super.clipBehavior,
    required super.spacing,
    super.textDirection,
    super.textBaseline,
  });

  double _mainExtent(RenderBox child) =>
      direction == .horizontal ? child.size.width : child.size.height;

  void _redistributeZeroBasisItems() {
    if (_zeroBasisItems.isEmpty) return;

    final flexChildren =
        <({RenderBox child, FlexParentData data, _ZeroBasisFlexItem item})>[];
    var child = firstChild;
    var index = 0;
    while (child != null) {
      final parentData = child.parentData! as FlexParentData;
      if ((parentData.flex ?? 0) > 0) {
        final item = index < _zeroBasisItems.length
            ? _zeroBasisItems[index]
            : null;
        if (item == null || parentData.fit != .tight) return;
        flexChildren.add((child: child, data: parentData, item: item));
      }
      child = parentData.nextSibling;
      index++;
    }
    if (flexChildren.length < 2) return;

    final outerSpace = flexChildren.fold<double>(
      0,
      (sum, entry) => sum + _mainExtent(entry.child),
    );
    final outerExtra = flexChildren.fold<double>(
      0,
      (sum, entry) => sum + entry.item.outerExtra,
    );
    final totalGrow = flexChildren.fold<double>(
      0,
      (sum, entry) => sum + entry.item.grow,
    );
    final contentSpace = outerSpace - outerExtra;
    if (contentSpace <= 0 || totalGrow <= 0) return;

    final targets = flexChildren
        .map(
          (entry) =>
              entry.item.outerExtra +
              contentSpace * entry.item.grow / totalGrow,
        )
        .toList(growable: false);
    final changed = Iterable<int>.generate(flexChildren.length).any(
      (index) =>
          (targets[index] - _mainExtent(flexChildren[index].child)).abs() >
          0.001,
    );
    if (!changed) return;

    // RenderFlex accepts integer factors, so encode the target outer-size
    // ratios with enough precision to keep sub-pixel layout differences.
    const factorBudget = 1000000;
    final originalFactors = flexChildren
        .map((entry) => entry.data.flex!)
        .toList(growable: false);
    for (var index = 0; index < flexChildren.length; index++) {
      flexChildren[index].data.flex =
          (targets[index] / outerSpace * factorBudget).round().clamp(
            1,
            factorBudget,
          );
    }

    try {
      super.performLayout();
    } finally {
      for (var index = 0; index < flexChildren.length; index++) {
        flexChildren[index].data.flex = originalFactors[index];
      }
    }
  }

  /// Whether cross-axis start sits at the far edge rather than at zero.
  bool get _crossAxisIsReversed => direction == .horizontal
      ? verticalDirection == .up
      : textDirection == .rtl;

  set selfAlignments(List<_SelfAlignment?> value) {
    if (listEquals(_selfAlignments, value)) return;
    _selfAlignments = value;
    markNeedsLayout();
  }

  set zeroBasisItems(List<_ZeroBasisFlexItem?> value) {
    if (listEquals(_zeroBasisItems, value)) return;
    _zeroBasisItems = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    super.performLayout();

    _redistributeZeroBasisItems();

    // RenderFlex has sized itself from its children by now, so the cross extent
    // is known even when the incoming constraints were unbounded. Only the
    // offsets of the opted-out children change; nothing is laid out again.
    var child = firstChild;
    var index = 0;
    while (child != null) {
      final parentData = child.parentData! as FlexParentData;
      final alignment = index < _selfAlignments.length
          ? _selfAlignments[index]
          : null;

      if (alignment != null) {
        final free = direction == .horizontal
            ? size.height - child.size.height
            : size.width - child.size.width;
        final reversed = _crossAxisIsReversed;
        final crossOffset = switch (alignment) {
          .start => reversed ? free : 0.0,
          .center => free / 2,
          .end => reversed ? 0.0 : free,
        };
        parentData.offset = direction == .horizontal
            ? Offset(parentData.offset.dx, crossOffset)
            : Offset(crossOffset, parentData.offset.dy);
      }

      child = parentData.nextSibling;
      index++;
    }
  }
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
