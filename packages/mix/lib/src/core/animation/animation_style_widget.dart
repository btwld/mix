import 'package:flutter/widgets.dart';

import '../spec.dart';
import '../style.dart';
import 'animation_driver.dart';

/// A widget that handles animation of styles using an AnimationDriver.
///
/// This widget listens to changes in the driver and rebuilds when the
/// animated style changes. It also manages the animation lifecycle,
/// triggering animations when the style changes.
class AnimationStyleWidget<S extends Spec<S>> extends StatefulWidget {
  const AnimationStyleWidget({
    super.key,
    required this.driver,
    required this.style,
    required this.builder,
  });

  /// The animation driver that controls the animation.
  final MixAnimationDriver<S> driver;

  /// The target style to animate to.
  final ResolvedStyle<S> style;

  /// The builder function that creates the widget with the animated style.
  final Widget Function(BuildContext context, S spec) builder;

  @override
  State<AnimationStyleWidget<S>> createState() =>
      _AnimationStyleWidgetState<S>();
}

class _AnimationStyleWidgetState<S extends Spec<S>>
    extends State<AnimationStyleWidget<S>> {
  @override
  void initState() {
    super.initState();
    widget.driver.addListener(_onDriverChanged);

    // Trigger initial animation if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.driver.currentResolvedStyle != widget.style) {
        widget.driver.animateTo(widget.style);
      }
    });
  }

  void _onDriverChanged() {
    if (mounted) {
      // Force rebuild to reflect animation changes
      // ignore: no-empty-block
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(AnimationStyleWidget<S> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.driver != widget.driver) {
      oldWidget.driver.removeListener(_onDriverChanged);
      widget.driver.addListener(_onDriverChanged);
    }

    // Animate to new style if changed
    if (oldWidget.style != widget.style) {
      widget.driver.animateTo(widget.style);
    }
  }

  @override
  void dispose() {
    widget.driver.removeListener(_onDriverChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentResolved = widget.driver.currentResolvedStyle ?? widget.style;
    final spec = currentResolved.spec;

    if (spec == null) {
      return const SizedBox.shrink();
    }

    return widget.builder(context, spec);
  }
}
