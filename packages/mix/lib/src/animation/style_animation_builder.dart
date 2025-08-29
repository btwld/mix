import 'package:flutter/widgets.dart';

import '../core/spec.dart';
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
    required this.animationConfig,
    required this.spec,
    required this.builder,
  });

  /// The animation driver that controls the animation.
  final AnimationConfig animationConfig;

  /// The target spec to animate to.
  final S spec;

  /// The builder function that creates the widget with the animated spec.
  final Widget Function(BuildContext context, S spec) builder;

  @override
  State<StyleAnimationBuilder<S>> createState() =>
      _StyleAnimationBuilderState<S>();
}

class _StyleAnimationBuilderState<S extends Spec<S>>
    extends State<StyleAnimationBuilder<S>>
    with TickerProviderStateMixin {
  late final StyleAnimationDriver<S> animationDriver;

  @override
  void initState() {
    super.initState();

    animationDriver = _createAnimationDriver(widget.animationConfig);
  }

  StyleAnimationDriver<S> _createAnimationDriver(AnimationConfig config) {
    return switch (config) {
      // ignore: avoid-undisposed-instances
      CurveAnimationConfig() => CurveAnimationDriver<S>(
        vsync: this,
        config: config,
        initialSpec: widget.spec,
      ),
      // ignore: avoid-undisposed-instances
      SpringAnimationConfig() => SpringAnimationDriver<S>(
        vsync: this,
        config: config,
        initialSpec: widget.spec,
      ),
      // ignore: avoid-undisposed-instances
      PhaseAnimationConfig() => PhaseAnimationDriver<S>(
        vsync: this,
        curveConfigs: config.curveConfigs,
        specs: config.styles.map((e) => e.resolve(context) as S).toList(),
        initialSpec: widget.spec,
        trigger: config.trigger,
      ),
      // ignore: avoid-undisposed-instances
      KeyframeAnimationConfig() => KeyframeAnimationDriver<S>(
        vsync: this,
        config: config as KeyframeAnimationConfig<S>,
        initialSpec: widget.spec,
        context: context,
      ),
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

    // Animate to spec if changed
    if (oldWidget.spec != widget.spec && animationDriver.autoAnimateOnUpdate) {
      animationDriver.animateTo(widget.spec);
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
