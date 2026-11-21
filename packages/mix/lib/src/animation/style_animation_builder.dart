import 'package:flutter/foundation.dart';
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
  AnimationConfig? _driverConfig;
  bool _isExiting = false;

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
      ReversibleAnimationConfig() => throw StateError(
        'Select a forward or reverse config before creating a driver.',
      ),
      // ignore: avoid-undisposed-instances
      null => NoAnimationDriver(vsync: this, initialSpec: initialSpec),
    };
  }

  AnimationConfig? _forwardConfig(AnimationConfig? config) =>
      config is ReversibleAnimationConfig ? config.forward : config;

  AnimationConfig? _exitConfig(StyleSpec<S> previous, StyleSpec<S> target) {
    final previousConfig = previous.animation;
    final activation = previous.variantActivation;
    final targetActivation = target.variantActivation;
    if (previousConfig is! ReversibleAnimationConfig ||
        activation == null ||
        activation.animationOwner == null) {
      return null;
    }
    if (targetActivation?.active.contains(activation.animationOwner) ?? false) {
      return null;
    }

    return previousConfig.reverse;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasInitializedAnimationDriver) {
      final spec = widget.spec;
      _driverConfig = _forwardConfig(spec.animation);
      animationDriver = _createAnimationDriver(
        config: _driverConfig,
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

    final previous = oldWidget.spec;
    final target = widget.spec;
    final forward = _forwardConfig(target.animation);
    final isTimeline =
        forward is PhaseAnimationConfig || forward is KeyframeAnimationConfig;
    final targetChanged =
        previous.spec != target.spec ||
        !listEquals(previous.widgetModifiers, target.widgetModifiers);
    final targetOwner = target.variantActivation?.animationOwner;
    final hasNewAnimationOwner =
        targetOwner != null &&
        !(previous.variantActivation?.active.contains(targetOwner) ?? false);
    final isSameTargetExit =
        _isExiting &&
        animationDriver.isAnimating &&
        !targetChanged &&
        !isTimeline;
    if (isSameTargetExit && !hasNewAnimationOwner) {
      animationDriver.didUpdateSpec(target, target);

      return;
    }

    final exitConfig = targetChanged && !isTimeline && !hasNewAnimationOwner
        ? _exitConfig(previous, target)
        : null;
    var config = exitConfig ?? forward;
    if (config == null &&
        animationDriver is ImplicitAnimationDriver<S, AnimationConfig>) {
      config =
          _forwardConfig(previous.animation) ??
          (animationDriver.isAnimating ? _driverConfig : null);
    }
    _isExiting = exitConfig != null;

    final changesDriver = _driverConfig.runtimeType != config.runtimeType;
    final startsImplicitDriver =
        changesDriver &&
        (config is CurveAnimationConfig || config is SpringAnimationConfig);
    final source = isSameTargetExit || startsImplicitDriver
        ? (animationDriver.animation.value ?? previous)
        : previous;
    if (changesDriver) {
      animationDriver.dispose();
      animationDriver = _createAnimationDriver(
        config: config,
        initialSpec: source,
      );
    } else if (config != null) {
      animationDriver.updateDriver(config);
    }
    _driverConfig = config;

    // Equal visible values can carry refreshed modifier-order metadata.
    animationDriver.didUpdateSpec(source, target);
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
