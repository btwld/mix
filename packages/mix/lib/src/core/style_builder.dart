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

class _StyleBuilderState<S extends Spec<S>> extends State<StyleBuilder<S>> {
  WidgetStatesController? _preservedController;

  Style<S> _buildStyle(BuildContext context) {
    final inheritedStyle = Style.maybeOf<S>(context);
    final style = widget.style;

    if (inheritedStyle == null || inheritedStyle is IdentityStyle<S>) {
      return style;
    }

    if (style is IdentityStyle<S>) {
      return inheritedStyle;
    }

    return inheritedStyle.merge(style);
  }

  @override
  void didUpdateWidget(covariant StyleBuilder<S> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller == widget.controller) return;

    if (widget.controller != null) {
      _preservedController?.dispose();
      _preservedController = null;
    } else {
      _preservedController = WidgetStatesController(
        oldWidget.controller?.value ?? {},
      );
    }
  }

  @override
  void dispose() {
    _preservedController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _buildStyle(context);
    final externalController = widget.controller;

    Widget current = Builder(
      builder: (context) {
        final wrappedSpec = style.build(context);

        return StyleSpecBuilder(
          builder: widget.builder,
          styleSpec: wrappedSpec,
        );
      },
    );

    if (externalController != null) {
      current = _ExternalControllerProvider(
        controller: externalController,
        child: current,
      );
    } else if (style.needsPointerTracking &&
        !WidgetStateProvider.hasProvider(context)) {
      current = MixInteractionDetector(
        controller: _preservedController,
        child: current,
      );
    }

    // If inheritable is true, wrap with StyleProvider to pass the merged style down
    if (widget.inheritable) {
      current = StyleProvider(style: style, child: current);
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
    return StyleAnimationBuilder<S>(
      spec: styleSpec,

      builder: (context, animatedWrappedSpec) {
        Widget animatedChild = builder(context, animatedWrappedSpec.spec);

        // Always wrap with StyleSpecProvider first
        animatedChild = StyleSpecProvider(
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
