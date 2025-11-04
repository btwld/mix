import 'package:flutter/widgets.dart';

import '../animation/style_animation_builder.dart';
import '../modifiers/internal/render_modifier.dart';
import 'internal/mix_interaction_detector.dart';
import 'providers/style_provider.dart';
import 'providers/style_spec_provider.dart';
import 'providers/widget_state_provider.dart';
import 'spec.dart';
import 'style.dart';
import 'style_spec.dart';

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
    this.inheritable = false,
  });

  /// The style element to resolve and apply.
  final Style<S> style;

  /// Function that builds the widget with the resolved style.
  final Widget Function(BuildContext context, S spec) builder;

  /// Optional controller for managing widget state.
  final WidgetStatesController? controller;

  /// Whether to provide the resolved style to descendant widgets.
  ///
  /// When true, wraps the child widget with StyleProvider containing the final
  /// resolved style (after merging with any inherited styles). This allows
  /// descendant widgets to inherit the complete computed style.
  ///
  /// Defaults to false.
  final bool inheritable;

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

  Style<S> _buildStyle(BuildContext context) {
    final inheritedStyle = Style.maybeOf<S>(context);

    return inheritedStyle?.merge(widget.style) ?? widget.style;
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
    final style = _buildStyle(context);

    // Calculate interactivity need early
    final needsToTrackWidgetState =
        widget.controller == null && style.widgetStates.isNotEmpty;

    final alreadyHasWidgetStateScope = WidgetStateProvider.of(context) != null;

    Widget current = Builder(
      builder: (context) {
        final wrappedSpec = style.build(context);

        return StyleSpecBuilder(
          builder: widget.builder,
          styleSpec: wrappedSpec,
        );
      },
    );

    if (needsToTrackWidgetState && !alreadyHasWidgetStateScope) {
      // If we need interactivity and no MixWidgetStateModel is present,
      // wrap in MixInteractionDetector
      current = MixInteractionDetector(controller: _controller, child: current);
    } else if (widget.controller != null) {
      // If we have an external controller, wrap with _ExternalControllerProvider
      current = _ExternalControllerProvider(
        controller: _controller,
        child: current,
      );
    }

    // If inheritable is true, wrap with StyleProvider to pass the merged style down
    if (widget.inheritable) {
      current = StyleProvider<S>(style: style, child: current);
    }

    return current;
  }
}

/// Builds widgets with resolved style specifications.
///
/// Applies resolved style specs, widget modifiers, and animation support
/// to the builder function while providing the spec through StyleSpecProvider.
class StyleSpecBuilder<S extends Spec<S>> extends StatelessWidget {
  const StyleSpecBuilder({
    super.key,
    required this.builder,
    required this.styleSpec,
  });

  /// The style to resolve.
  final StyleSpec<S> styleSpec;

  /// The builder function that receives the resolved style.
  final Widget Function(BuildContext context, S spec) builder;

  @override
  Widget build(BuildContext context) {
    // style.build returns StyleSpec<S>

    // Pass the inner spec to the builder
    Widget current = builder(context, styleSpec.spec);

    // Always wrap with StyleSpecProvider first
    current = StyleSpecProvider<S>(spec: styleSpec, child: current);

    if (styleSpec.widgetModifiers != null &&
        styleSpec.widgetModifiers!.isNotEmpty) {
      // Apply modifiers if any
      current = RenderModifiers(
        widgetModifiers: styleSpec.widgetModifiers!,
        child: current,
      );
    }

    return StyleAnimationBuilder<S>(
      spec: styleSpec,

      builder: (context, animatedWrappedSpec) {
        Widget animatedChild = builder(context, animatedWrappedSpec.spec);

        // Always wrap with StyleSpecProvider first
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
}

class _ExternalControllerProvider extends StatelessWidget {
  const _ExternalControllerProvider({
    required this.controller,
    required this.child,
  });

  final WidgetStatesController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (_, _) {
        return WidgetStateProvider(states: controller.value, child: child);
      },
    );
  }
}
