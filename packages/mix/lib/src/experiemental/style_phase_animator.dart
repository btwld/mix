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
}

class StylePhaseAnimator extends StatefulWidget {
  const StylePhaseAnimator({
    super.key,
    this.repeat = true,
    required this.initialStyle,
    required this.phases,
    required this.animation,
    required this.child,
  });

  final bool repeat;
  final Style initialStyle;
  final Map<Variant, Style> phases;
  final PhaseAnimationData Function(Variant phase) animation;
  final Widget child;

  @override
  State<StylePhaseAnimator> createState() => _StylePhaseAnimatorState();
}

class _StylePhaseAnimatorState extends State<StylePhaseAnimator>
    with TickerProviderStateMixin {
  static const _initialVariant = Variant('phase.animator.initial');

  Style get _definitiveStyle => widget.initialStyle.addAll(
        widget.phases.entries.map((e) => e.key(e.value())),
      );
  List<Variant> get _variants => [_initialVariant, ...widget.phases.keys];

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
    _controller.forward();
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
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _controller.dispose();
    super.dispose();
  }

  void animationListener(status) {
    if (status == AnimationStatus.completed) {
      _timer = Timer(widget.animation(_variants[_currentIndex]).delay, () {
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
