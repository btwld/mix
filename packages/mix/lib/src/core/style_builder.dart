import 'package:flutter/widgets.dart';

import '../animation/style_animation_builder.dart';
import '../modifiers/internal/render_modifier.dart';
import 'internal/mix_interaction_detector.dart';
import 'providers/style_provider.dart';
import 'providers/widget_spec_provider.dart';
import 'providers/widget_state_provider.dart';
import 'spec.dart';
import 'style.dart';
import 'widget_spec.dart';

/// Builds widgets with Mix styling.
///
/// StyleBuilder handles the resolution of [Style] into a resolved spec
/// and provides it to the builder function. It also manages style inheritance,
/// variant application, and modifier rendering.
class StyleBuilder<S extends Spec<S>> extends StatefulWidget {
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
    final widgetStates = widget.style.widgetStates;
    // Calculate interactivity need early
    final needsToTrackWidgetState =
        widget.controller == null && widgetStates.isNotEmpty;

    final alreadyHasWidgetStateScope = WidgetStateProvider.of(context) != null;

    final inheritedStyle = StyleProvider.maybeOf<S>(context);
    final mergedStyle = inheritedStyle?.merge(widget.style) ?? widget.style;

    Widget current = Builder(
      builder: (context) {
        final wrappedSpec = mergedStyle.build(context);

        return StyleSpecBuilder(
          builder: widget.builder,
          wrappedSpec: wrappedSpec,
        );
      },
    );

    if (needsToTrackWidgetState && !alreadyHasWidgetStateScope) {
      // If we need interactivity and no MixWidgetStateModel is present,
      // wrap in MixInteractionDetector
      current = MixInteractionDetector(controller: _controller, child: current);
    }

    return current;
  }
}

class StyleSpecBuilder<S extends Spec<S>> extends StatelessWidget {
  const StyleSpecBuilder({
    super.key,
    required this.builder,
    required this.wrappedSpec,
  });

  /// The style to resolve.
  final StyleSpec<S> wrappedSpec;

  /// The builder function that receives the resolved style.
  final Widget Function(BuildContext context, S spec) builder;

  @override
  Widget build(BuildContext context) {
    // style.build returns WidgetSpec<S>

    final animationConfig = wrappedSpec.animation;

    // Pass the inner spec to the builder
    Widget current = builder(context, wrappedSpec.spec);

    // Always wrap with WidgetSpecProvider first
    current = StyleSpecProvider<S>(spec: wrappedSpec, child: current);

    if (wrappedSpec.widgetModifiers != null &&
        wrappedSpec.widgetModifiers!.isNotEmpty) {
      // Apply modifiers if any
      current = RenderModifiers(
        widgetModifiers: wrappedSpec.widgetModifiers!,
        child: current,
      );
    }

    if (animationConfig != null) {
      return StyleAnimationBuilder<S>(
        spec: wrappedSpec,
        animationConfig: animationConfig,
        builder: (context, animatedWrappedSpec) {
          Widget animatedChild = builder(context, animatedWrappedSpec.spec);

          // Always wrap with WidgetSpecProvider first
          animatedChild = StyleSpecProvider<S>(
            spec: animatedWrappedSpec,
            child: animatedChild,
          );

          if (animatedWrappedSpec.widgetModifiers != null &&
              animatedWrappedSpec.widgetModifiers!.isNotEmpty) {
            // Apply modifiers if any
            animatedChild = RenderModifiers(
              widgetModifiers: animatedWrappedSpec.widgetModifiers!,
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
