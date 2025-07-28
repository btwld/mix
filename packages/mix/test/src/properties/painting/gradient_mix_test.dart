import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';
import 'package:mix/src/properties/painting/gradient_mix.dart';

void main() {
  group('LinearGradientMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final linearGradientMix = LinearGradientMix(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.repeated,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
        );

        expectProp(linearGradientMix.$begin, Alignment.topLeft);
        expectProp(linearGradientMix.$end, Alignment.bottomRight);
        expectProp(linearGradientMix.$tileMode, TileMode.repeated);
        expect(linearGradientMix.$colors, hasLength(2));
        expectProp(linearGradientMix.$colors![0], Colors.red);
        expectProp(linearGradientMix.$colors![1], Colors.blue);
        expect(linearGradientMix.$stops, hasLength(2));
        expectProp(linearGradientMix.$stops![0], 0.0);
        expectProp(linearGradientMix.$stops![1], 1.0);
      });

      test('value constructor extracts properties from LinearGradient', () {
        const linearGradient = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green, Colors.yellow],
          stops: [0.2, 0.8],
          tileMode: TileMode.clamp,
        );

        final linearGradientMix = LinearGradientMix.value(linearGradient);

        expectProp(linearGradientMix.$begin, Alignment.topCenter);
        expectProp(linearGradientMix.$end, Alignment.bottomCenter);
        expectProp(linearGradientMix.$tileMode, TileMode.clamp);
        expect(linearGradientMix.$colors, hasLength(2));
        expectProp(linearGradientMix.$colors![0], Colors.green);
        expectProp(linearGradientMix.$colors![1], Colors.yellow);
        expect(linearGradientMix.$stops, hasLength(2));
        expectProp(linearGradientMix.$stops![0], 0.2);
        expectProp(linearGradientMix.$stops![1], 0.8);
      });

      test('maybeValue returns null for null input', () {
        final result = LinearGradientMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns LinearGradientMix for non-null input', () {
        const linearGradient = LinearGradient(
          colors: [Colors.red, Colors.blue],
        );
        final result = LinearGradientMix.maybeValue(linearGradient);

        expect(result, isNotNull);
        expect(result!.$colors, hasLength(2));
      });
    });

    group('resolve', () {
      test('resolves to LinearGradient with correct properties', () {
        final linearGradientMix = LinearGradientMix(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [Colors.red, Colors.blue],
          tileMode: TileMode.repeated,
        );

        const resolvedValue = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.red, Colors.blue],
          tileMode: TileMode.repeated,
        );

        expect(linearGradientMix, resolvesTo(resolvedValue));
      });

      test('uses default values for null properties', () {
        final linearGradientMix = LinearGradientMix(
          colors: const [Colors.red, Colors.blue],
        );

        const resolvedValue = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.red, Colors.blue],
          tileMode: TileMode.clamp,
        );

        expect(linearGradientMix, resolvesTo(resolvedValue));
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final linearGradientMix = LinearGradientMix(
          colors: const [Colors.red, Colors.blue],
        );
        final merged = linearGradientMix.merge(null);

        expect(merged, same(linearGradientMix));
      });

      test('merges properties correctly', () {
        final first = LinearGradientMix(
          begin: Alignment.topLeft,
          colors: const [Colors.red, Colors.blue],
        );

        final second = LinearGradientMix(
          end: Alignment.bottomRight,
          colors: const [Colors.green, Colors.yellow],
          tileMode: TileMode.repeated,
        );

        final merged = first.merge(second);

        expectProp(merged.$begin, Alignment.topLeft);
        expectProp(merged.$end, Alignment.bottomRight);
        expectProp(merged.$tileMode, TileMode.repeated);
        expect(merged.$colors, hasLength(2));
        expectProp(merged.$colors![0], Colors.green);
        expectProp(merged.$colors![1], Colors.yellow);
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final linearGradientMix1 = LinearGradientMix(
          begin: Alignment.topLeft,
          colors: const [Colors.red, Colors.blue],
        );

        final linearGradientMix2 = LinearGradientMix(
          begin: Alignment.topLeft,
          colors: const [Colors.red, Colors.blue],
        );

        expect(linearGradientMix1, linearGradientMix2);
      });

      test('returns false when properties are different', () {
        final linearGradientMix1 = LinearGradientMix(
          colors: const [Colors.red, Colors.blue],
        );
        final linearGradientMix2 = LinearGradientMix(
          colors: const [Colors.green, Colors.yellow],
        );

        expect(linearGradientMix1, isNot(linearGradientMix2));
      });
    });
  });

  group('RadialGradientMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final radialGradientMix = RadialGradientMix(
          center: Alignment.center,
          radius: 0.5,
          tileMode: TileMode.mirror,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
        );

        expectProp(radialGradientMix.$center, Alignment.center);
        expectProp(radialGradientMix.$radius, 0.5);
        expectProp(radialGradientMix.$tileMode, TileMode.mirror);
        expect(radialGradientMix.$colors, hasLength(2));
        expect(radialGradientMix.$stops, hasLength(2));
      });

      test('value constructor extracts properties from RadialGradient', () {
        const radialGradient = RadialGradient(
          center: Alignment.topLeft,
          radius: 0.8,
          colors: [Colors.purple, Colors.orange],
          tileMode: TileMode.repeated,
        );

        final radialGradientMix = RadialGradientMix.value(radialGradient);

        expectProp(radialGradientMix.$center, Alignment.topLeft);
        expectProp(radialGradientMix.$radius, 0.8);
        expectProp(radialGradientMix.$tileMode, TileMode.repeated);
        expect(radialGradientMix.$colors, hasLength(2));
      });

      test('maybeValue returns null for null input', () {
        final result = RadialGradientMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns RadialGradientMix for non-null input', () {
        const radialGradient = RadialGradient(
          colors: [Colors.red, Colors.blue],
        );
        final result = RadialGradientMix.maybeValue(radialGradient);

        expect(result, isNotNull);
        expect(result!.$colors, hasLength(2));
      });
    });

    group('resolve', () {
      test('resolves to RadialGradient with correct properties', () {
        final radialGradientMix = RadialGradientMix(
          center: Alignment.center,
          radius: 0.5,
          colors: const [Colors.red, Colors.blue],
        );

        const resolvedValue = RadialGradient(
          center: Alignment.center,
          radius: 0.5,
          colors: [Colors.red, Colors.blue],
        );

        expect(radialGradientMix, resolvesTo(resolvedValue));
      });
    });

    group('merge', () {
      test('merges properties correctly', () {
        final first = RadialGradientMix(
          center: Alignment.center,
          colors: const [Colors.red, Colors.blue],
        );

        final second = RadialGradientMix(
          radius: 0.8,
          colors: const [Colors.green, Colors.yellow],
        );

        final merged = first.merge(second);

        expectProp(merged.$center, Alignment.center);
        expectProp(merged.$radius, 0.8);
        expect(merged.$colors, hasLength(2));
        expectProp(merged.$colors![0], Colors.green);
        expectProp(merged.$colors![1], Colors.yellow);
      });
    });
  });

  group('SweepGradientMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final sweepGradientMix = SweepGradientMix(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 3.14159,
          tileMode: TileMode.mirror,
          colors: const [Colors.red, Colors.blue],
        );

        expectProp(sweepGradientMix.$center, Alignment.center);
        expectProp(sweepGradientMix.$startAngle, 0.0);
        expectProp(sweepGradientMix.$endAngle, 3.14159);
        expectProp(sweepGradientMix.$tileMode, TileMode.mirror);
        expect(sweepGradientMix.$colors, hasLength(2));
      });

      test('value constructor extracts properties from SweepGradient', () {
        const sweepGradient = SweepGradient(
          center: Alignment.topRight,
          startAngle: 1.0,
          endAngle: 2.0,
          colors: [Colors.cyan, Colors.pink],
        );

        final sweepGradientMix = SweepGradientMix.value(sweepGradient);

        expectProp(sweepGradientMix.$center, Alignment.topRight);
        expectProp(sweepGradientMix.$startAngle, 1.0);
        expectProp(sweepGradientMix.$endAngle, 2.0);
        expect(sweepGradientMix.$colors, hasLength(2));
      });

      test('maybeValue returns null for null input', () {
        final result = SweepGradientMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns SweepGradientMix for non-null input', () {
        const sweepGradient = SweepGradient(colors: [Colors.red, Colors.blue]);
        final result = SweepGradientMix.maybeValue(sweepGradient);

        expect(result, isNotNull);
        expect(result!.$colors, hasLength(2));
      });
    });

    group('resolve', () {
      test('resolves to SweepGradient with correct properties', () {
        final sweepGradientMix = SweepGradientMix(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 3.14159,
          colors: const [Colors.red, Colors.blue],
        );

        const resolvedValue = SweepGradient(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 3.14159,
          colors: [Colors.red, Colors.blue],
        );

        expect(sweepGradientMix, resolvesTo(resolvedValue));
      });
    });

    group('merge', () {
      test('merges properties correctly', () {
        final first = SweepGradientMix(
          center: Alignment.center,
          startAngle: 0.0,
          colors: const [Colors.red, Colors.blue],
        );

        final second = SweepGradientMix(
          endAngle: 3.14159,
          colors: const [Colors.green, Colors.yellow],
        );

        final merged = first.merge(second);

        expectProp(merged.$center, Alignment.center);
        expectProp(merged.$startAngle, 0.0);
        expectProp(merged.$endAngle, 3.14159);
        expect(merged.$colors, hasLength(2));
        expectProp(merged.$colors![0], Colors.green);
        expectProp(merged.$colors![1], Colors.yellow);
      });
    });
  });
}
