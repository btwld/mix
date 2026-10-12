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

  /// The config to keep using when a style drops its animation config.
  ///
  /// Implicit configs (curve, spring) keep animating toward the new spec, so a
  /// variant that removes its animation still transitions back smoothly.
  /// Keyframe and phase configs produce their own specs and may loop forever,
  /// so they are dropped and the new spec is applied directly.
  static AnimationConfig? _fallbackConfig(AnimationConfig? oldConfig) {
    return switch (oldConfig) {
      CurveAnimationConfig() || SpringAnimationConfig() => oldConfig,
      _ => null,
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
        config: config ?? _fallbackConfig(oldConfig),
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
