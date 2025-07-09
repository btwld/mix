import 'package:flutter/widgets.dart';

import '../spec.dart';
import 'computed_style.dart';
import 'computed_style_provider.dart';

/// A widget that animates when the [computedStyle] changes.
class ComputedStyleAnimationManager extends StatefulWidget {
  const ComputedStyleAnimationManager({
    super.key,
    required this.style,
    required this.child,
  });

  final ComputedStyle style;

  final Widget child;

  @override
  ComputedStyleAnimationManagerState createState() =>
      ComputedStyleAnimationManagerState();
}

class ComputedStyleAnimationManagerState
    extends State<ComputedStyleAnimationManager>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const _defaultDuration = Duration.zero;
  static const _defaultCurve = Curves.easeInOut;

  late Animation<double> _animation;
  late ComputedStyleMapTween _tween;

  @override
  void initState() {
    super.initState();
    final oldStyle = widget.style.specs;
    _tween = ComputedStyleMapTween(begin: oldStyle, end: widget.style.specs);
    _controller = AnimationController(
      duration: widget.style.animation?.duration ?? _defaultDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.style.animation?.curve ?? _defaultCurve,
    );
  }

  @override
  void didUpdateWidget(covariant ComputedStyleAnimationManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    final targetStyle = widget.style.specs;

    if (widget.style.animation?.duration !=
        oldWidget.style.animation?.duration) {
      _controller.duration =
          widget.style.animation?.duration ?? _defaultDuration;
    }

    if (widget.style.animation?.curve != oldWidget.style.animation?.curve) {
      _animation = CurvedAnimation(
        parent: _controller,
        curve: widget.style.animation?.curve ?? _defaultCurve,
      );
    }

    if (_controller.status == AnimationStatus.forward) {
      _tween = ComputedStyleMapTween(
        begin: _tween.evaluate(_animation),
        end: targetStyle,
      );
    } else {
      final oldStyle = oldWidget.style.specs;
      _tween = ComputedStyleMapTween(begin: oldStyle, end: targetStyle);
    }

    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Here you can apply the animation to the child widget
        return ComputedStyleProvider(
          style: ComputedStyle.raw(
            specs: _tween.evaluate(_animation),
            modifiers: widget.style.modifiers,
            animation: widget.style.animation,
          ),
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}

typedef ComputedStyleMap = Map<Type, Spec>;

class ComputedStyleMapTween extends Tween<ComputedStyleMap> {
  ComputedStyleMapTween({required super.begin, required super.end});

  @override
  ComputedStyleMap lerp(double t) {
    return begin!.map(
      (type, spec) => MapEntry(type, spec.lerp(end![type], t) as Spec),
    );
  }
}
