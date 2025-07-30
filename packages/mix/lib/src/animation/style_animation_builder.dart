import 'package:flutter/widgets.dart';

import 'animation_config.dart';
import '../core/spec.dart';
import '../core/style.dart';
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
    required this.resolvedStyle,
    required this.builder,
  });

  /// The animation driver that controls the animation.
  final AnimationConfig animationConfig;

  /// The target style to animate to.
  final ResolvedStyle<S> resolvedStyle;

  /// The builder function that creates the widget with the animated style.
  final Widget Function(BuildContext context, ResolvedStyle<S> resolvedStyle)
  builder;

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
        initialStyle: widget.resolvedStyle,
      ),
      // ignore: avoid-undisposed-instances
      SpringAnimationConfig() => SpringAnimationDriver<S>(
        vsync: this,
        config: config,
        initialStyle: widget.resolvedStyle,
      ),
      // ignore: avoid-undisposed-instances
      PhaseAnimationConfig() => PhaseAnimationDriver<S>(
        vsync: this,
        curvesAndDurations: config.curvesAndDurations,
        specs: config.styles.map((e) => e.resolve(context) as S).toList(),
        initialStyle: widget.resolvedStyle,
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

    // Animate to new style if changed
    if (oldWidget.resolvedStyle != widget.resolvedStyle) {
      animationDriver.animateTo(widget.resolvedStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: animationDriver,
      builder: (context, child) {
        final currentResolved = animationDriver.currentResolvedStyle;

        return widget.builder(context, currentResolved);
      },
    );
  }
}
