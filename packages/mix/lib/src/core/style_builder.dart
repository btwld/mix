import 'package:flutter/widgets.dart';

import '../modifiers/internal/render_modifier.dart';
import '../widgets/pressable_widget.dart';
import 'animation/animation_driver.dart';
import 'animation/animation_style_widget.dart';
import 'animation_config.dart';
import 'modifier.dart';
import 'resolved_style_provider.dart';
import 'spec.dart';
import 'style.dart';
import 'style_provider.dart';
import 'widget_state/widget_state_controller.dart';

/// Builds widgets with Mix styling.
///
/// StyleBuilder handles the resolution of [SpecStyle] into [ResolvedStyle]
/// and provides it to the builder function. It also manages style inheritance,
/// variant application, and modifier rendering.
class StyleBuilder<S extends Spec<S>> extends StatefulWidget {
  const StyleBuilder({
    super.key,
    this.style,
    required this.builder,
    this.inherit = false,
    this.orderOfModifiers,
    this.controller,
  });

  /// The style element to resolve and apply.
  final SpecStyle<S>? style;

  /// Function that builds the widget with the resolved style.
  final Widget Function(BuildContext context, S resolved) builder;

  /// Whether to inherit style from parent widgets.
  final bool inherit;

  /// The order in which modifiers should be applied.
  final List<Type>? orderOfModifiers;

  /// Optional controller for managing widget state.
  final WidgetStatesController? controller;

  @override
  State<StyleBuilder<S>> createState() => _StyleBuilderState<S>();
}

class _StyleBuilderState<S extends Spec<S>> extends State<StyleBuilder<S>>
    with TickerProviderStateMixin {
  late final WidgetStatesController _controller;

  // Cache for optimization
  SpecStyle<S>? _cachedFinalStyle;
  ResolvedStyle<S>? _cachedResolvedStyle;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? WidgetStatesController();
  }

  SpecStyle<S>? _prepareFinalStyle(BuildContext context) {
    // Handle inheritance
    final inheritedStyle = widget.inherit ? _getInheritedStyle(context) : null;
    final effectiveStyle = inheritedStyle != null
        ? inheritedStyle.merge(widget.style)
        : widget.style;

    return effectiveStyle;
  }

  Widget _buildCore(BuildContext context, ResolvedStyle<S> resolved) {
    Widget child = widget.builder(context, resolved.spec!);

    return _applyModifiers(child, resolved.modifiers);
  }

  Widget _applyModifiers(Widget child, List<Modifier>? modifiers) {
    if (modifiers == null || modifiers.isEmpty) return child;

    return RenderModifiers(
      modifiers: modifiers,
      orderOfModifiers: widget.orderOfModifiers ?? const [],
      child: child,
    );
  }

  // Cache for animation driver
  AnimationDriver<S>? _animationDriver;
  AnimationConfig? _lastAnimationConfig;

  Widget _wrapWithAnimationIfNeeded(
    BuildContext context,
    Widget child,
    AnimationConfig? animationConfig,
    SpecStyle<S> style,
  ) {
    if (animationConfig == null) {
      _disposeAnimationDriver();

      return child;
    }

    // Create or update animation driver if needed
    if (_animationDriver == null || _lastAnimationConfig != animationConfig) {
      _disposeAnimationDriver();
      _animationDriver = _createAnimationDriver(animationConfig);
      _lastAnimationConfig = animationConfig;
    }

    final resolved = style.build(context);

    return AnimationStyleWidget<S>(
      driver: _animationDriver!,
      style: resolved,
      builder: (context, spec) => child,
    );
  }

  AnimationDriver<S> _createAnimationDriver(AnimationConfig config) {
    return switch (config) {
      CurveAnimationConfig(:final duration, :final curve, :final onEnd) =>
        CurveAnimationDriver<S>(
          vsync: this,
          duration: duration,
          curve: curve,
          onEnd: onEnd,
        ),
      SpringAnimationConfig(:final spring, :final onEnd) =>
        SpringAnimationDriver<S>(vsync: this, spring: spring, onEnd: onEnd),
    };
  }

  void _disposeAnimationDriver() {
    _animationDriver?.dispose();
    _animationDriver = null;
    _lastAnimationConfig = null;
  }

  SpecStyle<S>? _getInheritedStyle(BuildContext context) {
    // Try to get inherited style of the same type
    return StyleProvider.maybeOf(context);
  }

  ResolvedStyle<S> _getResolvedStyle(BuildContext context) {
    // 1. Prepare final style (inheritance + variants)
    final finalStyle = _prepareFinalStyle(context);

    // 2. Check if we can use cached resolved style
    if (_cachedFinalStyle == finalStyle && _cachedResolvedStyle != null) {
      return _cachedResolvedStyle!;
    }

    // 3. Resolve and cache
    final resolved = finalStyle?.build(context);
    _cachedFinalStyle = finalStyle;
    _cachedResolvedStyle = resolved;

    return resolved ?? ResolvedStyle<S>(spec: null);
  }

  Widget _buildInnerTree(BuildContext context) {
    // Get resolved style (cached when possible)
    final resolved = _getResolvedStyle(context);
    final finalStyle = _cachedFinalStyle!;

    return ResolvedStyleProvider<S>(
      resolvedStyle: resolved,
      child: Builder(
        builder: (context) {
          // Build core widget with modifiers
          Widget child = _buildCore(context, resolved);

          // Apply wrappers (these are lightweight)
          child = _wrapWithAnimationIfNeeded(
            context,
            child,
            resolved.animation,
            finalStyle,
          );
          child = StyleProvider<S>(style: finalStyle, child: child);

          return child;
        },
      ),
    );
  }

  @override
  void didUpdateWidget(StyleBuilder<S> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Clear cache if style or inheritance config changed
    final orderChanged =
        (oldWidget.orderOfModifiers?.length ?? 0) !=
        (widget.orderOfModifiers?.length ?? 0);

    if (oldWidget.style != widget.style ||
        oldWidget.inherit != widget.inherit ||
        orderChanged) {
      _cachedFinalStyle = null;
      _cachedResolvedStyle = null;
    }
  }

  @override
  void dispose() {
    // Only dispose controllers we created internally
    if (widget.controller == null) {
      _controller.dispose();
    }
    _disposeAnimationDriver();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // First prepare style to check if we need interactivity
    final preliminaryStyle = _prepareFinalStyle(context);

    // Calculate interactivity need early
    final needsInteractivity =
        widget.controller != null || preliminaryStyle?.hasWidgetState == false;

    // Build the widget tree with proper ordering
    Widget result =
        needsInteractivity && MixWidgetStateModel.of(context) == null
        ? Interactable(
            controller: _controller,
            child: Builder(builder: (context) => _buildInnerTree(context)),
          )
        : _buildInnerTree(context);

    return result;
  }
}
