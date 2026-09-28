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

  /// `MediaQuery.disableAnimations` for this subtree; null until first read.
  ///
  /// The driver is created once it is known, so a loop never starts while
  /// the flag is set.
  bool? _reducedMotion;

  bool _readReducedMotion() =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  StyleAnimationDriver<S> _createAnimationDriver({
    required AnimationConfig? config,
    required StyleSpec<S> initialSpec,
  }) {
    final reducedMotion = _reducedMotion!;

    return switch (config) {
      // ignore: avoid-undisposed-instances
      CurveAnimationConfig() => CurveAnimationDriver(
        vsync: this,
        config: config,
        initialSpec: initialSpec,
        reducedMotion: reducedMotion,
      ),
      // ignore: avoid-undisposed-instances
      SpringAnimationConfig() => SpringAnimationDriver(
        vsync: this,
        config: config,
        initialSpec: initialSpec,
        reducedMotion: reducedMotion,
      ),
      // ignore: avoid-undisposed-instances
      PhaseAnimationConfig() => PhaseAnimationDriver(
        vsync: this,
        config: config,
        initialSpec: initialSpec,
        context: context,
        reducedMotion: reducedMotion,
      ),
      // ignore: avoid-undisposed-instances
      KeyframeAnimationConfig() => KeyframeAnimationDriver(
        vsync: this,
        config: config as KeyframeAnimationConfig<S>,
        initialSpec: initialSpec,
        context: context,
        reducedMotion: reducedMotion,
      ),
      // ignore: avoid-undisposed-instances
      null => NoAnimationDriver(
        vsync: this,
        initialSpec: initialSpec,
        reducedMotion: reducedMotion,
      ),
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isFirstRead = _reducedMotion == null;
    _reducedMotion = _readReducedMotion();
    if (isFirstRead) {
      animationDriver = _createAnimationDriver(
        config: widget.spec.animation,
        initialSpec: widget.spec,
      );
    } else {
      animationDriver.reducedMotion = _reducedMotion!;
    }
  }

  @override
  void dispose() {
    animationDriver.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StyleAnimationBuilder<S> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // didUpdateWidget runs before didChangeDependencies, so read the flag
    // here too: a spec change in the same frame must see the new value.
    final reducedMotion = _readReducedMotion();
    _reducedMotion = reducedMotion;
    animationDriver.reducedMotion = reducedMotion;

    final config = widget.spec.animation;
    final oldConfig = oldWidget.spec.animation;

    if ((oldConfig.runtimeType == config.runtimeType) && config != null) {
      animationDriver.updateDriver(config);
    } else {
      animationDriver.dispose();
      animationDriver = _createAnimationDriver(
        config: config ?? oldConfig,
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
