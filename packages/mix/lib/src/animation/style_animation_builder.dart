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

  /// The config currently driving the active driver. Tracked separately from
  /// the spec's config because a reverse transition can leave the driver using
  /// a different kind from the current spec's forward config.
  AnimationConfig? _activeConfig;

  @override
  void initState() {
    super.initState();
    final spec = widget.spec;
    final config = _forwardOf(spec.animation);
    animationDriver = _createAnimationDriver(config: config, initialSpec: spec);
    _activeConfig = config;
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
      // A reversible config is unwrapped to its forward config for driving.
      ReversibleAnimationConfig() => _createAnimationDriver(
        config: config.forward,
        initialSpec: initialSpec,
      ),
      // ignore: avoid-undisposed-instances
      null => NoAnimationDriver(vsync: this, initialSpec: initialSpec),
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

    final newConfig = widget.spec.animation;
    final oldConfig = oldWidget.spec.animation;

    // Select the effective transition config: the leaving style's reverse
    // config when leaving it, otherwise the target style's forward config.
    final config =
        _transitionConfig(oldConfig, newConfig) ?? _forwardOf(oldConfig);

    // Compare against the active driver's config kind, not the spec's, because
    // a reverse transition can leave the driver using a different kind.
    if ((_activeConfig.runtimeType == config.runtimeType) && config != null) {
      animationDriver.updateDriver(config);
    } else {
      animationDriver.dispose();
      animationDriver = _createAnimationDriver(
        config: config,
        initialSpec: oldWidget.spec,
      );
    }
    _activeConfig = config;

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

/// Unwraps the forward (enter) config from a [ReversibleAnimationConfig].
AnimationConfig? _forwardOf(AnimationConfig? config) {
  return switch (config) {
    ReversibleAnimationConfig(:final forward) => forward,
    _ => config,
  };
}

/// Unwraps the reverse (exit) config from a [ReversibleAnimationConfig].
AnimationConfig? _reverseOf(AnimationConfig? config) {
  return switch (config) {
    ReversibleAnimationConfig(:final reverse) => reverse,
    _ => null,
  };
}

/// Selects the effective transition config when moving from [oldConfig] to
/// [newConfig].
///
/// Uses the leaving style's reverse config only when the old and new configs
/// are distinct; otherwise uses the target style's forward config. This keeps
/// an inherited base reversible config from being mistaken for an exit
/// animation on enter.
AnimationConfig? _transitionConfig(
  AnimationConfig? oldConfig,
  AnimationConfig? newConfig,
) {
  if (oldConfig != newConfig) {
    final reverse = _reverseOf(oldConfig);
    if (reverse != null) return reverse;
  }

  return _forwardOf(newConfig);
}
