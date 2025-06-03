import 'dart:async';

import 'package:flutter/widgets.dart';

import '../core/factory/style_mix.dart';
import '../core/styled_widget.dart';
import '../core/variant.dart';

class PhaseAnimationData {
  final Duration duration;
  final Curve curve;
  final Duration delay;

  const PhaseAnimationData({
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.delay = Duration.zero,
  });

  const PhaseAnimationData.zero()
      : duration = Duration.zero,
        curve = Curves.easeInOut,
        delay = Duration.zero;
}

class StylePhaseAnimator extends StatefulWidget {
  const StylePhaseAnimator({
    super.key,
    this.repeat = true,
    required this.phases,
    required this.animation,
    required this.child,
    required this.trigger,
  });

  final bool repeat;
  final Map<Variant, Style> phases;
  final PhaseAnimationData Function(Variant phase) animation;
  final Widget child;
  final Object trigger;

  @override
  State<StylePhaseAnimator> createState() => _StylePhaseAnimatorState();
}

class _StylePhaseAnimatorState extends State<StylePhaseAnimator>
    with TickerProviderStateMixin {
  Style get _definitiveStyle => Style.create(
        widget.phases.entries.map((e) => e.key(e.value())),
      );

  List<Variant> get _variants => widget.phases.keys.toList();

  int _currentIndex = 0;
  Variant get _currentVariant => _variants[_currentIndex];
  Timer? _timer;

  late final AnimationController _controller = AnimationController(
    duration: widget.animation(_variants[_currentIndex]).duration,
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener(animationListener);
  }

  void _next() {
    final int nextIndex;
    if (widget.repeat) {
      nextIndex = (_currentIndex + 1) % _variants.length;
    } else {
      nextIndex = (_currentIndex + 1).clamp(0, _variants.length - 1);
    }

    setState(() {
      _currentIndex = nextIndex;
    });
  }

  @override
  void didUpdateWidget(covariant StylePhaseAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trigger != widget.trigger) {
      print('trigger changed ${DateTime.now()}');
      _currentIndex = 0;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _controller.removeStatusListener(animationListener);
    _controller.dispose();
    super.dispose();
  }

  void animationListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (!widget.repeat && _currentIndex == _variants.length - 1) {
        _timer?.cancel();
        _timer = null;

        return;
      }

      final delay = widget.animation(_variants[_currentIndex]).delay;

      _timer = Timer(delay, () {
        _next();
        _controller.duration =
            widget.animation(_variants[_currentIndex]).duration;
        _controller.forward(from: 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SpecBuilder(
      style: _definitiveStyle.applyVariant(_currentVariant).animate(
            duration: widget.animation(_currentVariant).duration,
            curve: widget.animation(_currentVariant).curve,
          ),
      builder: (context) {
        return widget.child;
      },
    );
  }
}
