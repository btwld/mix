import 'package:flutter/widgets.dart';

import '../modifiers/internal/render_widget_modifier.dart';
import '../widgets/pressable_widget.dart';
import 'animation/animation_driver.dart';
import 'animation_config.dart';
import 'factory/style_mix.dart';
import 'modifier.dart';
import 'named_variant_scope.dart';
import 'resolved_style_provider.dart';
import 'spec.dart';
import 'style_provider.dart';
import 'variant.dart';
import 'widget_state/widget_state_controller.dart';

/// Builds widgets with Mix styling.
///
/// StyleBuilder handles the resolution of [Style] into [ResolvedStyle]
/// and provides it to the builder function. It also manages style inheritance,
/// variant application, and modifier rendering.
class StyleBuilder<S extends Spec<S>> extends StatefulWidget {
  const StyleBuilder({
    super.key,
    required this.style,
    required this.builder,
    this.inherit = false,
    this.orderOfModifiers,
    this.controller,
  });

  /// The style element to resolve and apply.
  final Style<S> style;

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

class _StyleBuilderState<S extends Spec<S>> extends State<StyleBuilder<S>> {
  late final WidgetStatesController _controller;

  // Cache for optimization
  Style<S>? _cachedFinalStyle;
  ResolvedStyle<S>? _cachedResolvedStyle;
  bool? _cachedNeedsInteractivity;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? WidgetStatesController();
  }

  Style<S> _prepareFinalStyle(BuildContext context) {
    // Handle inheritance
    final inheritedStyle = widget.inherit ? _getInheritedStyle(context) : null;
    final effectiveStyle = inheritedStyle != null
        ? inheritedStyle.merge(widget.style)
        : widget.style;

    // Apply named variants
    final namedVariants = NamedVariantScope.maybeOf(context);

    return namedVariants.isNotEmpty
        ? effectiveStyle.applyVariants(namedVariants)
        : effectiveStyle;
  }

  Widget _buildCore(BuildContext context, ResolvedStyle<S> resolved) {
    Widget child = widget.builder(context, resolved.spec);

    return _applyModifiers(child, resolved.modifiers);
  }

  Widget _applyModifiers(Widget child, List<ModifierSpec>? modifiers) {
    if (modifiers == null || modifiers.isEmpty) return child;

    return RenderModifiers(
      modifiers: modifiers,
      orderOfModifiers: widget.orderOfModifiers ?? const [],
      child: child,
    );
  }

  Widget _wrapWithAnimationIfNeeded(
    Widget child,
    AnimationConfig? animationConfig,
    Style<S> style,
  ) {
    if (animationConfig == null) return child;

    if (animationConfig is ImplicitAnimationConfig) {
      final driver = ImplicitAnimationDriver<S>(
        duration: animationConfig.duration,
        curve: animationConfig.curve,
        onEnd: animationConfig.onEnd,
      );

      return driver.build(
        context: context,
        style: style,
        builder: (context, resolved) => child,
      );
    }

    return child;
  }

  Widget _wrapWithInteractableIfNeeded(Widget child, bool needsInteractivity) {
    if (needsInteractivity && MixWidgetStateModel.of(context) == null) {
      return Interactable(controller: _controller, child: child);
    }

    return child;
  }

  Widget _wrapWithStyleProviderIfNeeded(Widget child, Style<S> style) {
    if (widget.inherit) {
      return StyleProvider<S>(style: style, child: child);
    }

    return child;
  }

  Style<S>? _getInheritedStyle(BuildContext context) {
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
    final resolved = finalStyle.resolve(context);
    _cachedFinalStyle = finalStyle;
    _cachedResolvedStyle = resolved;

    return resolved;
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
      _cachedNeedsInteractivity = null;
    }
  }

  @override
  void dispose() {
    // Only dispose controllers we created internally
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get resolved style (cached when possible)
    final resolved = _getResolvedStyle(context);
    final finalStyle = _cachedFinalStyle!;

    // Calculate interactivity need (cache it)
    final needsInteractivity = _cachedNeedsInteractivity ??=
        widget.controller != null ||
        finalStyle.variants.any((v) => v.variant is WidgetStateVariant);

    return ResolvedStyleProvider<S>(
      resolvedStyle: resolved,
      child: Builder(
        builder: (context) {
          // Build core widget with modifiers
          Widget child = _buildCore(context, resolved);

          // Apply wrappers (these are lightweight)
          child = _wrapWithAnimationIfNeeded(
            child,
            finalStyle.animation,
            finalStyle,
          );
          child = _wrapWithInteractableIfNeeded(child, needsInteractivity);
          child = _wrapWithStyleProviderIfNeeded(child, finalStyle);

          return child;
        },
      ),
    );
  }
}
