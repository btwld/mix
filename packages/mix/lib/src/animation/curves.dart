import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

class SpringCurve extends Curve {
  late final SpringSimulation _sim;
  late final double _val;

  SpringCurve.durationBased({required Duration duration, double bounce = 0.0}) {
    assert(
      (bounce >= -1.0 && bounce <= 1.0),
      '"bounce" value must be between -1.0 and 1.0.',
    );

    final SpringDescription desc = SpringDescription.withDurationAndBounce(
      duration: duration,
      bounce: bounce,
    );

    _sim = SpringSimulation(desc, 0.0, 1.0, 0.0);

    _val = (1 - _sim.x(1.0));
  }

  SpringCurve({
    double stiffness = 3.5,
    double dampingRatio = 1.0,
    double mass = 1.0,
  }) {
    final SpringDescription desc = SpringDescription.withDampingRatio(
      mass: mass,
      stiffness: stiffness,
      ratio: dampingRatio,
    );

    _sim = SpringSimulation(desc, 0.0, 1.0, 0.0);

    _val = (1 - _sim.x(1.0));
  }

  @override
  double transform(double t) => _sim.x(t) + t * _val;
}
