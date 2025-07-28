import 'package:flutter/widgets.dart';

import '../animation/style_animation_builder.dart';
import '../modifiers/internal/render_modifier.dart';
import 'internal/mix_hoverable_region.dart';
import 'providers/resolved_style_provider.dart';
import 'providers/widget_state_provider.dart';
import 'spec.dart';
import 'style.dart';

/// Builds widgets with Mix styling.
///
/// StyleBuilder handles the resolution of [StyleAttribute] into [ResolvedStyle]
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
  final StyleAttribute<S>? style;

  /// Function that builds the widget with the resolved style.
  final Widget Function(BuildContext context, S? spec) builder;

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

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? WidgetStatesController();
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
    final widgetStates = widget.style?.widgetStates ?? {};
    // Calculate interactivity need early
    final needsToTrackWidgetState =
        widget.controller != null || widgetStates.isNotEmpty;

    final alreadyHasWidgetStateScope =
        WidgetStateProvider.maybeOf(context) != null;

    Widget current = ResolvedStyleBuilder(
      builder: widget.builder,
      style: widget.style,
      inherit: widget.inherit,
      orderOfModifiers: widget.orderOfModifiers,
    );

    if (needsToTrackWidgetState && !alreadyHasWidgetStateScope) {
      // If we need interactivity and no MixWidgetStateModel is present,
      // wrap in MixHoverableRegion
      current = MixHoverableRegion(controller: _controller, child: current);
    }

    return current;
  }
}

class ResolvedStyleBuilder<S extends Spec<S>> extends StatelessWidget {
  const ResolvedStyleBuilder({
    super.key,
    required this.builder,
    this.style,
    this.inherit = false,
    this.orderOfModifiers,
  });

  /// The style to resolve.
  final StyleAttribute<S>? style;

  final List<Type>? orderOfModifiers;

  /// The builder function that receives the resolved style.
  final Widget Function(BuildContext context, S? spec) builder;

  /// Whether to inherit style from parent widgets.
  final bool inherit;

  Widget _widgetBuilder(BuildContext context, ResolvedStyle<S> resolvedStyle) {
    Widget current = builder(context, resolvedStyle.spec);

    // Always wrap with ResolvedStyleProvider first
    current = ResolvedStyleProvider<S>(
      resolvedStyle: resolvedStyle,
      child: current,
    );

    if (resolvedStyle.modifiers != null &&
        resolvedStyle.modifiers!.isNotEmpty) {
      // Apply modifiers if any
      current = RenderModifiers(
        modifiers: resolvedStyle.modifiers!,
        orderOfModifiers: orderOfModifiers ?? const [],
        child: current,
      );
    }

    return current;
  }

  @override
  Widget build(BuildContext context) {
    final resolvedStyle = style?.build(context) ?? ResolvedStyle<S>();

    final animation = resolvedStyle.animation;

    if (animation != null) {
      // If animation is configured, wrap with StyleAnimationBuilder
      return StyleAnimationBuilder<S>(
        animationConfig: animation,
        resolvedStyle: resolvedStyle,
        builder: _widgetBuilder,
      );
    }

    return _widgetBuilder(context, resolvedStyle);
  }
}
