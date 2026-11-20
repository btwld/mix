import 'package:flutter/widgets.dart';

import '../core/spec.dart';
import '../core/style_spec.dart';
import 'animation_config.dart';
import 'style_animation_driver.dart';

/// A widget that handles animation of styles using an AnimationDriver.
///
/// This widget listens to changes in the driver and rebuilds when the
/// animated style changes. It also manages the animation lifecycle,
/// triggering animations when the style changes.
class StyleAnimationBuilder<S extends Spec<S>> extends StatefulWidget {
  const StyleAnimationBuilder({
    super.key,

    required this.spec,
    required this.builder,
  });

  /// The target spec to animate to.
  final StyleSpec<S> spec;

  /// The builder function that creates the widget with the animated spec.
  final Widget Function(BuildContext context, StyleSpec<S> spec) builder;

  @override
  State<StyleAnimationBuilder<S>> createState() =>
      _StyleAnimationBuilderState<S>();
}

class _StyleAnimationBuilderState<S extends Spec<S>>
    extends State<StyleAnimationBuilder<S>>
    with TickerProviderStateMixin {
  late StyleAnimationDriver<S> animationDriver;
  bool _hasInitializedAnimationDriver = false;

  StyleAnimationDriver<S> _createAnimationDriver({
    required AnimationConfig? config,
    required StyleSpec<S> initialSpec,
  }) {
    return switch (config) {
      // ignore: avoid-undisposed-instances
      CurveAnimationConfig() => CurveAnimationDriver(
        vsync: this,
        config: config,
        initialSpec: initialSpec,
      ),
      // ignore: avoid-undisposed-instances
      SpringAnimationConfig() => SpringAnimationDriver(
        vsync: this,
        config: config,
        initialSpec: initialSpec,
      ),
      // ignore: avoid-undisposed-instances
      PhaseAnimationConfig() => PhaseAnimationDriver(
        vsync: this,
        config: config,
        initialSpec: initialSpec,
        context: context,
      ),
      // ignore: avoid-undisposed-instances
      KeyframeAnimationConfig() => KeyframeAnimationDriver(
        vsync: this,
        config: config as KeyframeAnimationConfig<S>,
        initialSpec: initialSpec,
        context: context,
      ),
      // ignore: avoid-undisposed-instances
      null => NoAnimationDriver(vsync: this, initialSpec: initialSpec),
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasInitializedAnimationDriver) {
      final spec = widget.spec;
      animationDriver = _createAnimationDriver(
        config: spec.animation,
        initialSpec: spec,
      );
      _hasInitializedAnimationDriver = true;

      return;
    }

    animationDriver.didChangeDependencies();
  }

  @override
  void dispose() {
    animationDriver.dispose();
    super.dispose();
  }

  /// Whether to keep the implicit driver after the style's config is gone.
  ///
  /// It is retained for the update that drops the config, so the style
  /// animates back, and for later updates while that return animation is
  /// still in flight. Once it settles, the style no longer animates.
  /// Phase/keyframe drivers must stop as soon as their config disappears.
  bool _retainsImplicitDriver(AnimationConfig? oldConfig) {
    if (animationDriver is! ImplicitAnimationDriver<S, AnimationConfig>) {
      return false;
    }

    return oldConfig != null || animationDriver.isAnimating;
  }

  @override
  void didUpdateWidget(StyleAnimationBuilder<S> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final config = widget.spec.animation;
    final oldConfig = oldWidget.spec.animation;

    if ((oldConfig.runtimeType == config.runtimeType) && config != null) {
      animationDriver.updateDriver(config);
    } else if (config != null || !_retainsImplicitDriver(oldConfig)) {
      animationDriver.dispose();
      animationDriver = _createAnimationDriver(
        config: config,
        initialSpec: oldWidget.spec,
      );
    }

    // Equal visible values can carry refreshed modifier-order metadata.
    animationDriver.didUpdateSpec(oldWidget.spec, widget.spec);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationDriver.animation,
      builder: (context, child) {
        final currentSpec = animationDriver.animation.value ?? widget.spec;

        return widget.builder(context, currentSpec);
      },
    );
  }
}
