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

  @override
  void initState() {
    super.initState();
    final spec = widget.spec;
    final config = spec.animation;
    animationDriver = _createAnimationDriver(config: config, initialSpec: spec);
  }

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

  /// Chooses the config that drives an animate-out transition when the new spec
  /// removes its animation (`config == null`).
  ///
  /// Only implicit drivers (curve, spring) retarget toward the new spec through
  /// [StyleAnimationDriver.didUpdateSpec], so only those may be reused. Phase and
  /// keyframe drivers replay their own sequence and never retarget; reusing an
  /// outgoing phase/keyframe config would keep the old animation running instead
  /// of showing the new target, so return `null` to let a [NoAnimationDriver]
  /// expose the target immediately on the same update.
  AnimationConfig? _outgoingConfigFor(AnimationConfig? oldConfig) {
    return switch (oldConfig) {
      CurveAnimationConfig() || SpringAnimationConfig() => oldConfig,
      PhaseAnimationConfig() || KeyframeAnimationConfig() || null => null,
    };
  }

  @override
  void dispose() {
    animationDriver.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StyleAnimationBuilder<S> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final config = widget.spec.animation;
    final oldConfig = oldWidget.spec.animation;

    if ((oldConfig.runtimeType == config.runtimeType) && config != null) {
      animationDriver.updateDriver(config);
    } else {
      animationDriver.dispose();
      animationDriver = _createAnimationDriver(
        config: config ?? _outgoingConfigFor(oldConfig),
        initialSpec: oldWidget.spec,
      );
    }

    if (oldWidget.spec != widget.spec) {
      animationDriver.didUpdateSpec(oldWidget.spec, widget.spec);
    }
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
