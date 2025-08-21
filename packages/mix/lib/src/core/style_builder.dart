import 'package:flutter/widgets.dart';

import '../animation/style_animation_builder.dart';
import '../modifiers/internal/render_modifier.dart';
import 'internal/mix_hoverable_region.dart';
import 'providers/style_provider.dart';
import 'providers/widget_spec_provider.dart';
import 'providers/widget_state_provider.dart';
import 'style.dart';
import 'widget_spec.dart';

/// Builds widgets with Mix styling.
///
/// StyleBuilder handles the resolution of [Style] into a resolved spec
/// and provides it to the builder function. It also manages style inheritance,
/// variant application, and modifier rendering.
class StyleBuilder<S extends WidgetSpec<S>> extends StatefulWidget {
  const StyleBuilder({
    super.key,
    required this.style,
    required this.builder,
    this.controller,
  });

  /// The style element to resolve and apply.
  final Style<S> style;

  /// Function that builds the widget with the resolved style.
  final Widget Function(BuildContext context, S spec) builder;

  /// Optional controller for managing widget state.
  final WidgetStatesController? controller;

  @override
  State<StyleBuilder<S>> createState() => _StyleBuilderState<S>();
}

class _StyleBuilderState<S extends WidgetSpec<S>> extends State<StyleBuilder<S>>
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
    final widgetStates = widget.style.widgetStates;
    // Calculate interactivity need early
    final needsToTrackWidgetState =
        widget.controller != null || widgetStates.isNotEmpty;

    final alreadyHasWidgetStateScope = WidgetStateProvider.of(context) != null;

    final inheritedStyle = StyleProvider.maybeOf<S>(context);

    Widget current = WidgetSpecBuilder(
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

class WidgetSpecBuilder<S extends WidgetSpec<S>> extends StatelessWidget {
  const WidgetSpecBuilder({
    super.key,
    required this.builder,
    required this.style,
  });

  /// The style to resolve.
  final Style<S> style;

  /// The builder function that receives the resolved style.
  final Widget Function(BuildContext context, S spec) builder;

  @override
  Widget build(BuildContext context) {
    final spec = style.build(context);
    final animationConfig = spec.animation;

    Widget current = builder(context, spec);

    // Always wrap with WidgetSpecProvider first
    current = WidgetSpecProvider<S>(spec: spec, child: current);

    if (spec.widgetModifiers != null && spec.widgetModifiers!.isNotEmpty) {
      // Apply modifiers if any
      current = RenderModifiers(
        widgetModifiers: spec.widgetModifiers!,
        child: current,
      );
    }

    if (animationConfig != null) {
      return StyleAnimationBuilder<S>(
        spec: spec,
        animationConfig: animationConfig,
        builder: (context, animatedSpec) {
          Widget animatedChild = builder(context, animatedSpec);

          // Always wrap with WidgetSpecProvider first
          animatedChild = WidgetSpecProvider<S>(
            spec: animatedSpec,
            child: animatedChild,
          );

          if (animatedSpec.widgetModifiers != null &&
              animatedSpec.widgetModifiers!.isNotEmpty) {
            // Apply modifiers if any
            animatedChild = RenderModifiers(
              widgetModifiers: animatedSpec.widgetModifiers!,
              child: animatedChild,
            );
          }

          return animatedChild;
        },
      );
    }

    return current;
  }
}
