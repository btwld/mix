import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/internal/variant_activation.dart';
import '../core/spec.dart';
import '../core/style_spec.dart';
import 'animation_config.dart';
import 'internal/reversible_animation.dart';
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
      // ignore: avoid-undisposed-instances
      null => NoAnimationDriver(vsync: this, initialSpec: initialSpec),
    };
  }

  // Drivers run the original forward or reverse instance, never the pair.
  AnimationConfig? _forwardConfig(AnimationConfig? config) => switch (config) {
    ReversibleAnimation(:final forward) => forward,
    _ => config,
  };

  AnimationConfig? _exitConfig(StyleSpec<S> previous, StyleSpec<S> target) {
    final reverse = AnimationConfig.reverseOf(previous.animation);
    final activation = readVariantActivation(previous);
    final targetActivation = readVariantActivation(target);
    if (reverse == null ||
        activation == null ||
        activation.animationOwner == null) {
      return null;
    }
    if (targetActivation?.active.contains(activation.animationOwner) ?? false) {
      return null;
    }

    return reverse;
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
    bool matchesTarget(StyleSpec<S> source) =>
        source.spec == target.spec &&
        listEquals(source.widgetModifiers, target.widgetModifiers);

    final targetChanged = !matchesTarget(previous);
    final targetOwner = readVariantActivation(target)?.animationOwner;
    final hasNewAnimationOwner =
        targetOwner != null &&
        !(readVariantActivation(previous)?.active.contains(targetOwner) ??
            false);
    final isSameTargetImplicitTransition =
        !targetChanged &&
        !isTimeline &&
        animationDriver is ImplicitAnimationDriver<S, AnimationConfig> &&
        animationDriver.isAnimating;
    final reverse = !isTimeline && !hasNewAnimationOwner
        ? _exitConfig(previous, target)
        : null;
    final rendered = isSameTargetImplicitTransition && reverse != null
        ? animationDriver.animation.value
        : null;
    final exitConfig =
        targetChanged || (rendered != null && !matchesTarget(rendered))
        ? reverse
        : null;
    final isSameTargetExit = _isExiting && isSameTargetImplicitTransition;
    if (isSameTargetExit && !hasNewAnimationOwner && exitConfig == null) {
      animationDriver.didUpdateSpec(target, target);

      return;
    }

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
    final restartsSameTarget =
        isSameTargetImplicitTransition &&
        (isSameTargetExit || exitConfig != null);
    var source = previous;
    if (reverse != null && exitConfig == null) {
      source = target;
    } else if (restartsSameTarget || startsImplicitDriver) {
      source = animationDriver.animation.value ?? previous;
    }
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
