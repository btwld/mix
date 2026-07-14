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
  StyleAnimationDriver<S>? _animationDriver;

  @override
  void initState() {
    super.initState();
    final spec = widget.spec;
    final config = spec.animation;
    _animationDriver = _createAnimationDriver(
      config: config,
      initialSpec: spec,
    );
  }

  StyleAnimationDriver<S>? _createAnimationDriver({
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
      null => null,
    };
  }

  @override
  void dispose() {
    _animationDriver?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StyleAnimationBuilder<S> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final config = widget.spec.animation;
    final oldConfig = oldWidget.spec.animation;

    if ((oldConfig.runtimeType == config.runtimeType) && config != null) {
      _animationDriver!.updateDriver(config);
    } else {
      _animationDriver?.dispose();
      _animationDriver = _createAnimationDriver(
        config: config ?? oldConfig,
        initialSpec: oldWidget.spec,
      );
    }

    if (oldWidget.spec != widget.spec) {
      _animationDriver?.didUpdateSpec(oldWidget.spec, widget.spec);
    }
  }

  @override
  Widget build(BuildContext context) {
    final animationDriver = _animationDriver;
    if (animationDriver == null) {
      return widget.builder(context, widget.spec);
    }

    return AnimatedBuilder(
      animation: animationDriver.animation,
      builder: (context, child) {
        final currentSpec = animationDriver.animation.value ?? widget.spec;

        return widget.builder(context, currentSpec);
      },
    );
  }
}
