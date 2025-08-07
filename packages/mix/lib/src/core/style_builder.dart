import 'package:flutter/widgets.dart';

import '../animation/style_animation_builder.dart';
import '../decorators/internal/render_decorator.dart';
import 'internal/mix_hoverable_region.dart';
import 'providers/resolved_style_provider.dart';
import 'providers/style_provider.dart';
import 'providers/widget_state_provider.dart';
import 'spec.dart';
import 'style.dart';

/// Builds widgets with Mix styling.
///
/// StyleBuilder handles the resolution of [Style] into [ResolvedStyle]
/// and provides it to the builder function. It also manages style inheritance,
/// variant application, and decorator rendering.
class StyleBuilder<S extends Spec<S>> extends StatefulWidget {
  const StyleBuilder({
    super.key,
    this.style,
    required this.builder,
    this.controller,
  });

  /// The style element to resolve and apply.
  final Style<S>? style;

  /// Function that builds the widget with the resolved style.
  final Widget Function(BuildContext context, S? spec) builder;

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

    final alreadyHasWidgetStateScope = WidgetStateProvider.of(context) != null;

    final inheritedStyle = StyleProvider.maybeOf<S>(context);

    Widget current = ResolvedStyleBuilder(
      builder: widget.builder,
      style: inheritedStyle?.merge(widget.style) ?? widget.style,
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
  const ResolvedStyleBuilder({super.key, required this.builder, this.style});

  /// The style to resolve.
  final Style<S>? style;

  /// The builder function that receives the resolved style.
  final Widget Function(BuildContext context, S? spec) builder;

  Widget _widgetBuilder(BuildContext context, ResolvedStyle<S> resolvedStyle) {
    Widget current = builder(context, resolvedStyle.spec);

    // Always wrap with ResolvedStyleProvider first
    current = ResolvedStyleProvider<S>(
      resolvedStyle: resolvedStyle,
      child: current,
    );

    if (resolvedStyle.widgetDecorators != null &&
        resolvedStyle.widgetDecorators!.isNotEmpty) {
      // Apply decorators if any
      current = RenderWidgetDecorators(
        widgetDecorators: resolvedStyle.widgetDecorators!,
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
