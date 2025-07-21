import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
import '../../helpers/testing_utils.dart';

void main() {
  group('LinearGradientMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final linearGradientMix = LinearGradientMix.only(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.repeated,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
        );

        expect(linearGradientMix.begin, isProp(Alignment.topLeft));
        expect(linearGradientMix.end, isProp(Alignment.bottomRight));
        expect(linearGradientMix.tileMode, isProp(TileMode.repeated));
        expect(linearGradientMix.colors, hasLength(2));
        expect(linearGradientMix.colors![0], isProp(Colors.red));
        expect(linearGradientMix.colors![1], isProp(Colors.blue));
        expect(linearGradientMix.stops, hasLength(2));
        expect(linearGradientMix.stops![0], isProp(0.0));
        expect(linearGradientMix.stops![1], isProp(1.0));
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

        expect(linearGradientMix.begin, isProp(Alignment.topCenter));
        expect(linearGradientMix.end, isProp(Alignment.bottomCenter));
        expect(linearGradientMix.tileMode, isProp(TileMode.clamp));
        expect(linearGradientMix.colors, hasLength(2));
        expect(linearGradientMix.colors![0], isProp(Colors.green));
        expect(linearGradientMix.colors![1], isProp(Colors.yellow));
        expect(linearGradientMix.stops, hasLength(2));
        expect(linearGradientMix.stops![0], isProp(0.2));
        expect(linearGradientMix.stops![1], isProp(0.8));
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
        expect(result!.colors, hasLength(2));
      });
    });

    group('resolve', () {
      test('resolves to LinearGradient with correct properties', () {
        final linearGradientMix = LinearGradientMix.only(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [Colors.red, Colors.blue],
          tileMode: TileMode.repeated,
        );

        final context = MockBuildContext();
        final resolved = linearGradientMix.resolve(context);

        expect(resolved.begin, Alignment.topLeft);
        expect(resolved.end, Alignment.bottomRight);
        expect(resolved.colors, [Colors.red, Colors.blue]);
        expect(resolved.tileMode, TileMode.repeated);
      });

      test('uses default values for null properties', () {
        final linearGradientMix = LinearGradientMix.only(
          colors: const [Colors.red, Colors.blue],
        );

        final context = MockBuildContext();
        final resolved = linearGradientMix.resolve(context);

        expect(resolved.colors, [Colors.red, Colors.blue]);
        expect(resolved.begin, Alignment.centerLeft);
        expect(resolved.end, Alignment.centerRight);
        expect(resolved.tileMode, TileMode.clamp);
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final linearGradientMix = LinearGradientMix.only(
          colors: const [Colors.red, Colors.blue],
        );
        final merged = linearGradientMix.merge(null);

        expect(merged, same(linearGradientMix));
      });

      test('merges properties correctly', () {
        final first = LinearGradientMix.only(
          begin: Alignment.topLeft,
          colors: const [Colors.red, Colors.blue],
        );

        final second = LinearGradientMix.only(
          end: Alignment.bottomRight,
          colors: const [Colors.green, Colors.yellow],
          tileMode: TileMode.repeated,
        );

        final merged = first.merge(second);

        expect(merged.begin, isProp(Alignment.topLeft));
        expect(merged.end, isProp(Alignment.bottomRight));
        expect(merged.tileMode, isProp(TileMode.repeated));
        expect(merged.colors, hasLength(4));
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final linearGradientMix1 = LinearGradientMix.only(
          begin: Alignment.topLeft,
          colors: const [Colors.red, Colors.blue],
        );

        final linearGradientMix2 = LinearGradientMix.only(
          begin: Alignment.topLeft,
          colors: const [Colors.red, Colors.blue],
        );

        expect(linearGradientMix1, linearGradientMix2);
        expect(linearGradientMix1.hashCode, linearGradientMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final linearGradientMix1 = LinearGradientMix.only(
          colors: const [Colors.red, Colors.blue],
        );
        final linearGradientMix2 = LinearGradientMix.only(
          colors: const [Colors.green, Colors.yellow],
        );

        expect(linearGradientMix1, isNot(linearGradientMix2));
      });
    });
  });

  group('RadialGradientMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final radialGradientMix = RadialGradientMix.only(
          center: Alignment.center,
          radius: 0.5,
          tileMode: TileMode.mirror,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
        );

        expect(radialGradientMix.center, isProp(Alignment.center));
        expect(radialGradientMix.radius, isProp(0.5));
        expect(radialGradientMix.tileMode, isProp(TileMode.mirror));
        expect(radialGradientMix.colors, hasLength(2));
        expect(radialGradientMix.stops, hasLength(2));
      });

      test('value constructor extracts properties from RadialGradient', () {
        const radialGradient = RadialGradient(
          center: Alignment.topLeft,
          radius: 0.8,
          colors: [Colors.purple, Colors.orange],
          tileMode: TileMode.repeated,
        );

        final radialGradientMix = RadialGradientMix.value(radialGradient);

        expect(radialGradientMix.center, isProp(Alignment.topLeft));
        expect(radialGradientMix.radius, isProp(0.8));
        expect(radialGradientMix.tileMode, isProp(TileMode.repeated));
        expect(radialGradientMix.colors, hasLength(2));
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
        expect(result!.colors, hasLength(2));
      });
    });

    group('resolve', () {
      test('resolves to RadialGradient with correct properties', () {
        final radialGradientMix = RadialGradientMix.only(
          center: Alignment.center,
          radius: 0.5,
          colors: const [Colors.red, Colors.blue],
        );

        final context = MockBuildContext();
        final resolved = radialGradientMix.resolve(context);

        expect(resolved.center, Alignment.center);
        expect(resolved.radius, 0.5);
        expect(resolved.colors, [Colors.red, Colors.blue]);
      });
    });

    group('merge', () {
      test('merges properties correctly', () {
        final first = RadialGradientMix.only(
          center: Alignment.center,
          colors: const [Colors.red, Colors.blue],
        );

        final second = RadialGradientMix.only(
          radius: 0.8,
          colors: const [Colors.green, Colors.yellow],
        );

        final merged = first.merge(second);

        expect(merged.center, isProp(Alignment.center));
        expect(merged.radius, isProp(0.8));
        expect(merged.colors, hasLength(4));
      });
    });
  });

  group('SweepGradientMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final sweepGradientMix = SweepGradientMix.only(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 3.14159,
          tileMode: TileMode.mirror,
          colors: const [Colors.red, Colors.blue],
        );

        expect(sweepGradientMix.center, isProp(Alignment.center));
        expect(sweepGradientMix.startAngle, isProp(0.0));
        expect(sweepGradientMix.endAngle, isProp(3.14159));
        expect(sweepGradientMix.tileMode, isProp(TileMode.mirror));
        expect(sweepGradientMix.colors, hasLength(2));
      });

      test('value constructor extracts properties from SweepGradient', () {
        const sweepGradient = SweepGradient(
          center: Alignment.topRight,
          startAngle: 1.0,
          endAngle: 2.0,
          colors: [Colors.cyan, Colors.pink],
        );

        final sweepGradientMix = SweepGradientMix.value(sweepGradient);

        expect(sweepGradientMix.center, isProp(Alignment.topRight));
        expect(sweepGradientMix.startAngle, isProp(1.0));
        expect(sweepGradientMix.endAngle, isProp(2.0));
        expect(sweepGradientMix.colors, hasLength(2));
      });

      test('maybeValue returns null for null input', () {
        final result = SweepGradientMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns SweepGradientMix for non-null input', () {
        const sweepGradient = SweepGradient(colors: [Colors.red, Colors.blue]);
        final result = SweepGradientMix.maybeValue(sweepGradient);

        expect(result, isNotNull);
        expect(result!.colors, hasLength(2));
      });
    });

    group('resolve', () {
      test('resolves to SweepGradient with correct properties', () {
        final sweepGradientMix = SweepGradientMix.only(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 3.14159,
          colors: const [Colors.red, Colors.blue],
        );

        final context = MockBuildContext();
        final resolved = sweepGradientMix.resolve(context);

        expect(resolved.center, Alignment.center);
        expect(resolved.startAngle, 0.0);
        expect(resolved.endAngle, 3.14159);
        expect(resolved.colors, [Colors.red, Colors.blue]);
      });
    });

    group('merge', () {
      test('merges properties correctly', () {
        final first = SweepGradientMix.only(
          center: Alignment.center,
          startAngle: 0.0,
          colors: const [Colors.red, Colors.blue],
        );

        final second = SweepGradientMix.only(
          endAngle: 3.14159,
          colors: const [Colors.green, Colors.yellow],
        );

        final merged = first.merge(second);

        expect(merged.center, isProp(Alignment.center));
        expect(merged.startAngle, isProp(0.0));
        expect(merged.endAngle, isProp(3.14159));
        expect(merged.colors, hasLength(4));
      });
    });
  });
}
