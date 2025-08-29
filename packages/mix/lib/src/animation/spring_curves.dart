import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

class SpringCurve extends Curve {
  final Tolerance tolerance = Tolerance.defaultTolerance;
  final SpringSimulation _sim;

  SpringCurve({
    double mass = 1.0,
    double stiffness = 180.0,
    double damping = 0.8,
  }) : _sim = SpringSimulation(
         SpringDescription(mass: 1.0, stiffness: 180.0, damping: 0.8),
         0.0,
         1.0,
         0.0,
       );

  SpringCurve.withDampingRatio({
    double mass = 1.0,
    double stiffness = 180.0,
    double ratio = 0.8,
  }) : _sim = SpringSimulation(
         SpringDescription.withDampingRatio(
           mass: mass,
           stiffness: stiffness,
           ratio: ratio,
         ),
         0.0,
         1.0,
         0.0,
       );

  SpringCurve.withDurationAndBounce({
    Duration duration = const Duration(milliseconds: 500),
    double bounce = 0.0,
  }) : _sim = SpringSimulation(
         SpringDescription.withDurationAndBounce(
           duration: duration,
           bounce: bounce,
         ),
         0.0,
         1.0,
         0.0,
       );

  @override
  double transform(double t) => _sim.x(t);
}
