import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

/// A curve that uses a spring simulation to animate.
class SpringCurve extends Curve {
  final Tolerance tolerance = Tolerance.defaultTolerance;
  final SpringSimulation _sim;

  /// Creates a spring curve with the given [mass], [stiffness], and [damping].
  SpringCurve({
    double mass = 1.0,
    double stiffness = 180.0,
    double damping = 12.0,
  }) : _sim = SpringSimulation(
         SpringDescription(mass: mass, stiffness: stiffness, damping: damping),
         0.0,
         1.0,
         0.0,
       );

  /// Creates a spring curve with the given [mass], [stiffness], and [ratio].
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

  /// Creates a spring curve with the given [duration] and [bounce].
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
