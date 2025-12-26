import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/animation/spring_curves.dart';

void main() {
  group('SpringCurve', () {
    group('default constructor', () {
      test('starts at 0 when t = 0', () {
        final curve = SpringCurve();

        expect(curve.transform(0.0), closeTo(0.0, 0.001));
      });

      test('ends near 1 when t = 1', () {
        final curve = SpringCurve();

        // Spring may overshoot, but should settle near 1
        expect(curve.transform(1.0), closeTo(1.0, 0.1));
      });

      test('produces intermediate values', () {
        final curve = SpringCurve();

        final midValue = curve.transform(0.5);
        expect(midValue, greaterThan(0.0));
        expect(midValue, lessThan(1.5)); // Allow for overshoot
      });

      test('respects custom mass parameter', () {
        final lightCurve = SpringCurve(mass: 0.5);
        final heavyCurve = SpringCurve(mass: 2.0);

        // Lighter mass should move faster initially
        final lightValue = lightCurve.transform(0.2);
        final heavyValue = heavyCurve.transform(0.2);

        expect(lightValue, isNot(equals(heavyValue)));
      });

      test('respects custom stiffness parameter', () {
        final softCurve = SpringCurve(stiffness: 100.0);
        final stiffCurve = SpringCurve(stiffness: 300.0);

        // Stiffer spring should reach target faster
        final softValue = softCurve.transform(0.3);
        final stiffValue = stiffCurve.transform(0.3);

        expect(stiffValue, greaterThan(softValue));
      });

      test('respects custom damping parameter', () {
        final underdampedCurve = SpringCurve(damping: 5.0);
        final overdampedCurve = SpringCurve(damping: 30.0);

        // Underdamped should overshoot more
        final underdampedValue = underdampedCurve.transform(0.5);
        final overdampedValue = overdampedCurve.transform(0.5);

        expect(underdampedValue, isNot(equals(overdampedValue)));
      });
    });

    group('withDampingRatio constructor', () {
      test('starts at 0 when t = 0', () {
        final curve = SpringCurve.withDampingRatio();

        expect(curve.transform(0.0), closeTo(0.0, 0.001));
      });

      test('ends near 1 when t = 1', () {
        final curve = SpringCurve.withDampingRatio();

        expect(curve.transform(1.0), closeTo(1.0, 0.1));
      });

      test('critically damped (ratio = 1.0) does not overshoot', () {
        final curve = SpringCurve.withDampingRatio(ratio: 1.0);

        // Sample multiple points - critically damped should never exceed 1
        for (var t = 0.0; t <= 1.0; t += 0.1) {
          expect(curve.transform(t), lessThanOrEqualTo(1.05));
        }
      });

      test('underdamped (ratio < 1.0) may overshoot', () {
        final curve = SpringCurve.withDampingRatio(ratio: 0.3);

        // Find max value to check for overshoot
        var maxValue = 0.0;
        for (var t = 0.0; t <= 1.0; t += 0.05) {
          final value = curve.transform(t);
          if (value > maxValue) maxValue = value;
        }

        // Underdamped spring should overshoot
        expect(maxValue, greaterThan(1.0));
      });
    });

    group('withDurationAndBounce constructor', () {
      test('starts at 0 when t = 0', () {
        final curve = SpringCurve.withDurationAndBounce();

        expect(curve.transform(0.0), closeTo(0.0, 0.001));
      });

      test('ends near 1 when t = 1', () {
        final curve = SpringCurve.withDurationAndBounce();

        expect(curve.transform(1.0), closeTo(1.0, 0.1));
      });

      test('zero bounce produces minimal overshoot', () {
        final curve = SpringCurve.withDurationAndBounce(bounce: 0.0);

        var maxValue = 0.0;
        for (var t = 0.0; t <= 1.0; t += 0.05) {
          final value = curve.transform(t);
          if (value > maxValue) maxValue = value;
        }

        // Zero bounce should have minimal overshoot
        expect(maxValue, lessThan(1.1));
      });

      test('positive bounce produces overshoot', () {
        final curve = SpringCurve.withDurationAndBounce(bounce: 0.5);

        var maxValue = 0.0;
        for (var t = 0.0; t <= 1.0; t += 0.05) {
          final value = curve.transform(t);
          if (value > maxValue) maxValue = value;
        }

        // Positive bounce should overshoot
        expect(maxValue, greaterThan(1.0));
      });

      test('respects duration parameter', () {
        final shortCurve = SpringCurve.withDurationAndBounce(
          duration: const Duration(milliseconds: 200),
        );
        final longCurve = SpringCurve.withDurationAndBounce(
          duration: const Duration(milliseconds: 1000),
        );

        // Different durations should produce different spring behaviors
        final shortValue = shortCurve.transform(0.5);
        final longValue = longCurve.transform(0.5);

        expect(shortValue, isNot(equals(longValue)));
      });
    });

    group('monotonicity', () {
      test('overdamped spring is monotonically increasing', () {
        final curve = SpringCurve.withDampingRatio(ratio: 1.5);

        var previousValue = -1.0;
        for (var t = 0.0; t <= 1.0; t += 0.05) {
          final value = curve.transform(t);
          expect(value, greaterThanOrEqualTo(previousValue));
          previousValue = value;
        }
      });
    });
  });
}
