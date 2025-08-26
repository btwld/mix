import 'dart:math' as math;

import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

class SpringCurve extends Curve {
  final double mass;
  final double stiffness;
  final double damping;
  final Tolerance tolerance = Tolerance.defaultTolerance;
  final SpringSimulation _sim;

  SpringCurve({
    required this.mass,
    required this.stiffness,
    required this.damping,
  }) : _sim = SpringSimulation(
         SpringDescription(mass: mass, stiffness: stiffness, damping: damping),
         0.0,
         1.0,
         0.0,
       );

  factory SpringCurve.withDampingRatio({
    double mass = 1.0,
    double stiffness = 180.0,
    double dampingRatio = 0.8,
  }) {
    final damping = dampingRatio * 2.0 * math.sqrt(mass * stiffness);

    return SpringCurve(mass: mass, stiffness: stiffness, damping: damping);
  }

  factory SpringCurve.withDurationAndBounce({
    Duration duration = const Duration(milliseconds: 500),
    double bounce = 0.0,
  }) {
    assert(duration.inMilliseconds > 0, 'Duration must be positive');
    final double durationInSeconds =
        duration.inMilliseconds / Duration.millisecondsPerSecond;
    const double mass = 1.0;
    final double stiffness =
        (4 * math.pi * math.pi * mass) / math.pow(durationInSeconds, 2);
    final double dampingRatio = bounce > 0
        ? (1.0 - bounce)
        : (1 / (bounce + 1));
    final double damping = dampingRatio * 2.0 * math.sqrt(mass * stiffness);

    return SpringCurve(mass: mass, stiffness: stiffness, damping: damping);
  }

  Duration get settlingDuration {
    final tolerance = this.tolerance.distance;
    assert(mass > 0 && stiffness > 0 && damping >= 0, 'Invalid spring params');
    assert(tolerance > 0 && tolerance < 1, 'tolerance must be (0,1)');

    final wn = math.sqrt(stiffness / mass); // ω_n
    final zeta = damping / (2.0 * math.sqrt(mass * stiffness)); // ζ

    double seconds;
    if (zeta < 1.0) {
      // underdamped
      seconds = -math.log(tolerance) / (zeta * wn);
    } else if ((zeta - 1.0).abs() < 1e-6) {
      // critically damped (approx for 2% band)
      // If you change tolerance, you can replace 4.0 with -ln(tol) * ~1.02 … but 4/wn is standard.
      seconds = 4.0 / wn;
    } else {
      // overdamped: use slow pole
      final slow = wn * (zeta - math.sqrt(zeta * zeta - 1.0)); // positive rate
      seconds = -math.log(tolerance) / slow;
    }

    return Duration(microseconds: (seconds * 1e6).round());
  }

  @override
  double transform(double t) => _sim.x(t);
}
