import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import '../core/equatable.dart';

/// A curve that uses a spring simulation to animate.
class SpringCurve extends Curve with Equatable {
  final Tolerance tolerance = .defaultTolerance;
  final SpringDescription _description;
  final SpringSimulation _sim;

  /// Creates a spring curve with the given [mass], [stiffness], and [damping].
  SpringCurve({
    double mass = 1.0,
    double stiffness = 180.0,
    double damping = 12.0,
  }) : this._(
         SpringDescription(mass: mass, stiffness: stiffness, damping: damping),
       );

  /// Creates a spring curve with the given [mass], [stiffness], and [ratio].
  SpringCurve.withDampingRatio({
    double mass = 1.0,
    double stiffness = 180.0,
    double ratio = 0.8,
  }) : this._(
         SpringDescription.withDampingRatio(
           mass: mass,
           stiffness: stiffness,
           ratio: ratio,
         ),
       );

  /// Creates a spring curve with the given [duration] and [bounce].
  SpringCurve.withDurationAndBounce({
    Duration duration = const Duration(milliseconds: 500),
    double bounce = 0.0,
  }) : this._(
         SpringDescription.withDurationAndBounce(
           duration: duration,
           bounce: bounce,
         ),
       );

  SpringCurve._(SpringDescription description)
    : _description = description,
      _sim = SpringSimulation(description, 0.0, 1.0, 0.0);

  @override
  double transform(double t) => _sim.x(t);

  @override
  List<Object?> get props => [
    _description.mass,
    _description.stiffness,
    _description.damping,
  ];
}
