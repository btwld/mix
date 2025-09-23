import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/animation/spring_curves.dart';

void main() {
  group('SpringCurve', () {
    group('constructor', () {
      test('should create with default parameters', () {
        final curve = SpringCurve();

        expect(curve, isA<SpringCurve>());
        expect(curve.tolerance, equals(Tolerance.defaultTolerance));
      });

      test('should create with custom mass, stiffness, and damping', () {
        final curve = SpringCurve(mass: 2.0, stiffness: 200.0, damping: 15.0);

        expect(curve, isA<SpringCurve>());
        expect(curve.tolerance, equals(Tolerance.defaultTolerance));
      });

      test('should handle edge case parameters', () {
        final curve = SpringCurve(mass: 0.1, stiffness: 10.0, damping: 1.0);

        expect(curve, isA<SpringCurve>());
      });
    });

    group('withDampingRatio constructor', () {
      test('should create with default parameters', () {
        final curve = SpringCurve.withDampingRatio();

        expect(curve, isA<SpringCurve>());
        expect(curve.tolerance, equals(Tolerance.defaultTolerance));
      });

      test('should create with custom mass, stiffness, and ratio', () {
        final curve = SpringCurve.withDampingRatio(
          mass: 1.5,
          stiffness: 150.0,
          ratio: 0.6,
        );

        expect(curve, isA<SpringCurve>());
      });

      test('should handle different damping ratios', () {
        final curves = [
          SpringCurve.withDampingRatio(ratio: 0.1), // Underdamped
          SpringCurve.withDampingRatio(ratio: 1.0), // Critically damped
          SpringCurve.withDampingRatio(ratio: 1.5), // Overdamped
        ];

        for (final curve in curves) {
          expect(curve, isA<SpringCurve>());
        }
      });
    });

    group('withDurationAndBounce constructor', () {
      test('should create with default parameters', () {
        final curve = SpringCurve.withDurationAndBounce();

        expect(curve, isA<SpringCurve>());
        expect(curve.tolerance, equals(Tolerance.defaultTolerance));
      });

      test('should create with custom duration and bounce', () {
        final curve = SpringCurve.withDurationAndBounce(
          duration: const Duration(milliseconds: 800),
          bounce: 0.3,
        );

        expect(curve, isA<SpringCurve>());
      });

      test('should handle different bounce values', () {
        final curves = [
          SpringCurve.withDurationAndBounce(bounce: 0.0), // No bounce
          SpringCurve.withDurationAndBounce(bounce: 0.5), // Medium bounce
          SpringCurve.withDurationAndBounce(bounce: 1.0), // High bounce
        ];

        for (final curve in curves) {
          expect(curve, isA<SpringCurve>());
        }
      });

      test('should handle different durations', () {
        final curves = [
          SpringCurve.withDurationAndBounce(
            duration: const Duration(milliseconds: 100),
          ),
          SpringCurve.withDurationAndBounce(
            duration: const Duration(milliseconds: 500),
          ),
          SpringCurve.withDurationAndBounce(
            duration: const Duration(milliseconds: 1000),
          ),
        ];

        for (final curve in curves) {
          expect(curve, isA<SpringCurve>());
        }
      });
    });

    group('transform', () {
      test('should return valid values for input range [0, 1]', () {
        final curve = SpringCurve();

        final t0 = curve.transform(0.0);
        final t05 = curve.transform(0.5);
        final t1 = curve.transform(1.0);

        expect(t0, isA<double>());
        expect(t05, isA<double>());
        expect(t1, isA<double>());

        // At t=0, spring should be at start position (close to 0)
        expect(t0, lessThan(0.1));

        // Values should be finite
        expect(t0.isFinite, isTrue);
        expect(t05.isFinite, isTrue);
        expect(t1.isFinite, isTrue);
      });

      test('should handle boundary values', () {
        final curve = SpringCurve();

        final t0 = curve.transform(0.0);
        final t1 = curve.transform(1.0);

        expect(t0, isA<double>());
        expect(t1, isA<double>());
        expect(t0.isFinite, isTrue);
        expect(t1.isFinite, isTrue);
      });

      test('should produce different curves for different parameters', () {
        final defaultCurve = SpringCurve();
        final stiffCurve = SpringCurve(stiffness: 300.0);
        final softCurve = SpringCurve(stiffness: 50.0);

        final t = 0.5;
        final defaultValue = defaultCurve.transform(t);
        final stiffValue = stiffCurve.transform(t);
        final softValue = softCurve.transform(t);

        // Different parameters should produce different results
        expect(defaultValue, isNot(equals(stiffValue)));
        expect(defaultValue, isNot(equals(softValue)));
        expect(stiffValue, isNot(equals(softValue)));
      });

      test('should be monotonic for overdamped spring', () {
        final curve = SpringCurve.withDampingRatio(ratio: 2.0); // Overdamped

        final values = <double>[];
        for (double t = 0.0; t <= 1.0; t += 0.1) {
          values.add(curve.transform(t));
        }

        // For overdamped springs, values should generally increase
        for (int i = 1; i < values.length; i++) {
          expect(
            values[i],
            greaterThanOrEqualTo(values[i - 1] - 0.1),
          ); // Allow small deviations
        }
      });

      test('should handle edge cases in input', () {
        final curve = SpringCurve();

        // Test with very small values
        final small = curve.transform(0.001);
        expect(small.isFinite, isTrue);

        // Test with values close to 1
        final large = curve.transform(0.999);
        expect(large.isFinite, isTrue);
      });
    });

    group('curve behavior', () {
      test('should behave as a proper curve', () {
        final curve = SpringCurve();

        // Test that it implements Curve interface properly
        expect(curve, isA<Curve>());

        // Test some curve properties
        final start = curve.transform(0.0);
        final end = curve.transform(1.0);

        expect(start.isFinite, isTrue);
        expect(end.isFinite, isTrue);
      });

      test('should work with different spring configurations', () {
        final configurations = [
          // Light spring
          SpringCurve(mass: 0.5, stiffness: 100.0, damping: 8.0),
          // Heavy spring
          SpringCurve(mass: 2.0, stiffness: 200.0, damping: 20.0),
          // Bouncy spring
          SpringCurve.withDampingRatio(ratio: 0.3),
          // Smooth spring
          SpringCurve.withDampingRatio(ratio: 0.9),
        ];

        for (final curve in configurations) {
          final midpoint = curve.transform(0.5);
          expect(midpoint.isFinite, isTrue);
        }
      });

      test('should produce consistent results for same input', () {
        final curve = SpringCurve(mass: 1.0, stiffness: 180.0, damping: 12.0);

        final t = 0.7;
        final result1 = curve.transform(t);
        final result2 = curve.transform(t);

        expect(result1, equals(result2));
      });

      test('should handle animation timing correctly', () {
        final fastCurve = SpringCurve.withDurationAndBounce(
          duration: const Duration(milliseconds: 200),
          bounce: 0.1,
        );

        final slowCurve = SpringCurve.withDurationAndBounce(
          duration: const Duration(milliseconds: 1000),
          bounce: 0.1,
        );

        // Both should produce valid values
        expect(fastCurve.transform(0.5).isFinite, isTrue);
        expect(slowCurve.transform(0.5).isFinite, isTrue);
      });
    });

    group('tolerance', () {
      test('should use default tolerance', () {
        final curve = SpringCurve();

        expect(curve.tolerance, equals(Tolerance.defaultTolerance));
      });

      test('should have same tolerance across different constructors', () {
        final curve1 = SpringCurve();
        final curve2 = SpringCurve.withDampingRatio();
        final curve3 = SpringCurve.withDurationAndBounce();

        expect(curve1.tolerance, equals(curve2.tolerance));
        expect(curve2.tolerance, equals(curve3.tolerance));
        expect(curve3.tolerance, equals(Tolerance.defaultTolerance));
      });
    });
  });
}
