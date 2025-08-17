import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

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

        expect(linearGradientMix.$begin, resolvesTo(Alignment.topLeft));
        expect(linearGradientMix.$end, resolvesTo(Alignment.bottomRight));
        expect(linearGradientMix.$tileMode, resolvesTo(TileMode.repeated));
        expect(linearGradientMix.$colors, hasLength(2));
        expect(linearGradientMix.$colors![0], resolvesTo(Colors.red));
        expect(linearGradientMix.$colors![1], resolvesTo(Colors.blue));
        expect(linearGradientMix.$stops, hasLength(2));
        expect(linearGradientMix.$stops![0], resolvesTo(0.0));
        expect(linearGradientMix.$stops![1], resolvesTo(1.0));
      });

      test('value constructor extracts all properties from LinearGradient', () {
        const linearGradient = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green, Colors.yellow, Colors.red],
          stops: [0.0, 0.5, 1.0],
          tileMode: TileMode.clamp,
          transform: GradientRotation(0.25),
        );

        final linearGradientMix = LinearGradientMix.value(linearGradient);

        expect(linearGradientMix.$begin, resolvesTo(Alignment.topCenter));
        expect(linearGradientMix.$end, resolvesTo(Alignment.bottomCenter));
        expect(linearGradientMix.$tileMode, resolvesTo(TileMode.clamp));
        expect(linearGradientMix.$transform, resolvesTo(const GradientRotation(0.25)));
        
        expect(linearGradientMix.$colors, hasLength(3));
        expect(linearGradientMix.$colors![0], resolvesTo(Colors.green));
        expect(linearGradientMix.$colors![1], resolvesTo(Colors.yellow));
        expect(linearGradientMix.$colors![2], resolvesTo(Colors.red));
        
        expect(linearGradientMix.$stops, hasLength(3));
        expect(linearGradientMix.$stops![0], resolvesTo(0.0));
        expect(linearGradientMix.$stops![1], resolvesTo(0.5));
        expect(linearGradientMix.$stops![2], resolvesTo(1.0));
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

    group('Factory Constructors', () {
      test('begin factory creates LinearGradientMix with begin', () {
        final gradientMix = LinearGradientMix.begin(Alignment.centerLeft);

        expect(gradientMix.$begin, resolvesTo(Alignment.centerLeft));
        expect(gradientMix.$end, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('end factory creates LinearGradientMix with end', () {
        final gradientMix = LinearGradientMix.end(Alignment.centerRight);

        expect(gradientMix.$end, resolvesTo(Alignment.centerRight));
        expect(gradientMix.$begin, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('tileMode factory creates LinearGradientMix with tileMode', () {
        final gradientMix = LinearGradientMix.tileMode(TileMode.mirror);

        expect(gradientMix.$tileMode, resolvesTo(TileMode.mirror));
        expect(gradientMix.$begin, isNull);
        expect(gradientMix.$end, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('transform factory creates LinearGradientMix with transform', () {
        const transform = GradientRotation(1.0);
        final gradientMix = LinearGradientMix.transform(transform);

        expect(gradientMix.$transform, resolvesTo(transform));
        expect(gradientMix.$begin, isNull);
        expect(gradientMix.$end, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('colors factory creates LinearGradientMix with colors', () {
        final colors = [Colors.red, Colors.green, Colors.blue];
        final gradientMix = LinearGradientMix.colors(colors);

        expect(gradientMix.$colors?.length, 3);
        expect(gradientMix.$begin, isNull);
        expect(gradientMix.$end, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('stops factory creates LinearGradientMix with stops', () {
        final stops = [0.0, 0.5, 1.0];
        final gradientMix = LinearGradientMix.stops(stops);

        expect(gradientMix.$stops?.length, 3);
        expect(gradientMix.$begin, isNull);
        expect(gradientMix.$end, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
      });
    });

    group('Utility Methods', () {
      test('begin utility works correctly', () {
        final gradientMix = LinearGradientMix().begin(Alignment.topLeft);

        expect(gradientMix.$begin, resolvesTo(Alignment.topLeft));
      });

      test('end utility works correctly', () {
        final gradientMix = LinearGradientMix().end(Alignment.bottomRight);

        expect(gradientMix.$end, resolvesTo(Alignment.bottomRight));
      });

      test('tileMode utility works correctly', () {
        final gradientMix = LinearGradientMix().tileMode(TileMode.repeated);

        expect(gradientMix.$tileMode, resolvesTo(TileMode.repeated));
      });

      test('transform utility works correctly', () {
        const transform = GradientRotation(0.25);
        final gradientMix = LinearGradientMix().transform(transform);

        expect(gradientMix.$transform, resolvesTo(transform));
      });

      test('colors utility works correctly', () {
        final colors = [Colors.yellow, Colors.purple];
        final gradientMix = LinearGradientMix().colors(colors);

        expect(gradientMix.$colors?.length, 2);
      });

      test('stops utility works correctly', () {
        final stops = [0.2, 0.8];
        final gradientMix = LinearGradientMix().stops(stops);

        expect(gradientMix.$stops?.length, 2);
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

        expect(merged.$begin, resolvesTo(Alignment.topLeft));
        expect(merged.$end, resolvesTo(Alignment.bottomRight));
        expect(merged.$tileMode, resolvesTo(TileMode.repeated));
        expect(merged.$colors, hasLength(2));
        expect(merged.$colors![0], resolvesTo(Colors.green));
        expect(merged.$colors![1], resolvesTo(Colors.yellow));
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

    group('Props getter', () {
      test('props includes all properties', () {
        final gradientMix = LinearGradientMix(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.repeated,
          transform: const GradientRotation(0.5),
          colors: [Colors.red, Colors.blue],
          stops: [0.0, 1.0],
        );

        expect(gradientMix.props.length, 6);
        expect(gradientMix.props, contains(gradientMix.$begin));
        expect(gradientMix.props, contains(gradientMix.$end));
        expect(gradientMix.props, contains(gradientMix.$tileMode));
        expect(gradientMix.props, contains(gradientMix.$transform));
        expect(gradientMix.props, contains(gradientMix.$colors));
        expect(gradientMix.props, contains(gradientMix.$stops));
      });
    });

    group('Default Value', () {
      test('has correct default value', () {
        final gradientMix = LinearGradientMix();

        expect(gradientMix.defaultValue, const LinearGradient(colors: []));
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

        expect(radialGradientMix.$center, resolvesTo(Alignment.center));
        expect(radialGradientMix.$radius, resolvesTo(0.5));
        expect(radialGradientMix.$tileMode, resolvesTo(TileMode.mirror));
        expect(radialGradientMix.$colors, hasLength(2));
        expect(radialGradientMix.$stops, hasLength(2));
      });

      test('value constructor extracts all properties from RadialGradient', () {
        const radialGradient = RadialGradient(
          center: Alignment.topLeft,
          radius: 0.8,
          colors: [Colors.purple, Colors.orange, Colors.cyan],
          stops: [0.1, 0.6, 0.9],
          tileMode: TileMode.repeated,
          focal: Alignment.bottomRight,
          focalRadius: 0.3,
          transform: GradientRotation(1.5),
        );

        final radialGradientMix = RadialGradientMix.value(radialGradient);

        expect(radialGradientMix.$center, resolvesTo(Alignment.topLeft));
        expect(radialGradientMix.$radius, resolvesTo(0.8));
        expect(radialGradientMix.$tileMode, resolvesTo(TileMode.repeated));
        expect(radialGradientMix.$focal, resolvesTo(Alignment.bottomRight));
        expect(radialGradientMix.$focalRadius, resolvesTo(0.3));
        expect(radialGradientMix.$transform, resolvesTo(const GradientRotation(1.5)));
        
        expect(radialGradientMix.$colors, hasLength(3));
        expect(radialGradientMix.$colors![0], resolvesTo(Colors.purple));
        expect(radialGradientMix.$colors![1], resolvesTo(Colors.orange));
        expect(radialGradientMix.$colors![2], resolvesTo(Colors.cyan));
        
        expect(radialGradientMix.$stops, hasLength(3));
        expect(radialGradientMix.$stops![0], resolvesTo(0.1));
        expect(radialGradientMix.$stops![1], resolvesTo(0.6));
        expect(radialGradientMix.$stops![2], resolvesTo(0.9));
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

    group('Factory Constructors', () {
      test('center factory creates RadialGradientMix with center', () {
        final gradientMix = RadialGradientMix.center(Alignment.topLeft);

        expect(gradientMix.$center, resolvesTo(Alignment.topLeft));
        expect(gradientMix.$radius, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$focal, isNull);
        expect(gradientMix.$focalRadius, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('radius factory creates RadialGradientMix with radius', () {
        final gradientMix = RadialGradientMix.radius(0.8);

        expect(gradientMix.$radius, resolvesTo(0.8));
        expect(gradientMix.$center, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$focal, isNull);
        expect(gradientMix.$focalRadius, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('tileMode factory creates RadialGradientMix with tileMode', () {
        final gradientMix = RadialGradientMix.tileMode(TileMode.mirror);

        expect(gradientMix.$tileMode, resolvesTo(TileMode.mirror));
        expect(gradientMix.$center, isNull);
        expect(gradientMix.$radius, isNull);
        expect(gradientMix.$focal, isNull);
        expect(gradientMix.$focalRadius, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('focal factory creates RadialGradientMix with focal', () {
        final gradientMix = RadialGradientMix.focal(Alignment.bottomRight);

        expect(gradientMix.$focal, resolvesTo(Alignment.bottomRight));
        expect(gradientMix.$center, isNull);
        expect(gradientMix.$radius, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$focalRadius, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test(
        'focalRadius factory creates RadialGradientMix with focalRadius',
        () {
          final gradientMix = RadialGradientMix.focalRadius(0.3);

          expect(gradientMix.$focalRadius, resolvesTo(0.3));
          expect(gradientMix.$center, isNull);
          expect(gradientMix.$radius, isNull);
          expect(gradientMix.$tileMode, isNull);
          expect(gradientMix.$focal, isNull);
          expect(gradientMix.$transform, isNull);
          expect(gradientMix.$colors, isNull);
          expect(gradientMix.$stops, isNull);
        },
      );

      test('transform factory creates RadialGradientMix with transform', () {
        const transform = GradientRotation(1.5);
        final gradientMix = RadialGradientMix.transform(transform);

        expect(gradientMix.$transform, resolvesTo(transform));
        expect(gradientMix.$center, isNull);
        expect(gradientMix.$radius, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$focal, isNull);
        expect(gradientMix.$focalRadius, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('colors factory creates RadialGradientMix with colors', () {
        final colors = [Colors.red, Colors.green, Colors.blue];
        final gradientMix = RadialGradientMix.colors(colors);

        expect(gradientMix.$colors?.length, 3);
        expect(gradientMix.$center, isNull);
        expect(gradientMix.$radius, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$focal, isNull);
        expect(gradientMix.$focalRadius, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('stops factory creates RadialGradientMix with stops', () {
        final stops = [0.0, 0.5, 1.0];
        final gradientMix = RadialGradientMix.stops(stops);

        expect(gradientMix.$stops?.length, 3);
        expect(gradientMix.$center, isNull);
        expect(gradientMix.$radius, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$focal, isNull);
        expect(gradientMix.$focalRadius, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
      });
    });

    group('Utility Methods', () {
      test('center utility works correctly', () {
        final gradientMix = RadialGradientMix().center(Alignment.topLeft);

        expect(gradientMix.$center, resolvesTo(Alignment.topLeft));
      });

      test('radius utility works correctly', () {
        final gradientMix = RadialGradientMix().radius(0.6);

        expect(gradientMix.$radius, resolvesTo(0.6));
      });

      test('tileMode utility works correctly', () {
        final gradientMix = RadialGradientMix().tileMode(TileMode.repeated);

        expect(gradientMix.$tileMode, resolvesTo(TileMode.repeated));
      });

      test('focal utility works correctly', () {
        final gradientMix = RadialGradientMix().focal(Alignment.centerRight);

        expect(gradientMix.$focal, resolvesTo(Alignment.centerRight));
      });

      test('focalRadius utility works correctly', () {
        final gradientMix = RadialGradientMix().focalRadius(0.4);

        expect(gradientMix.$focalRadius, resolvesTo(0.4));
      });

      test('transform utility works correctly', () {
        const transform = GradientRotation(0.75);
        final gradientMix = RadialGradientMix().transform(transform);

        expect(gradientMix.$transform, resolvesTo(transform));
      });

      test('colors utility works correctly', () {
        final colors = [Colors.yellow, Colors.purple];
        final gradientMix = RadialGradientMix().colors(colors);

        expect(gradientMix.$colors?.length, 2);
      });

      test('stops utility works correctly', () {
        final stops = [0.1, 0.9];
        final gradientMix = RadialGradientMix().stops(stops);

        expect(gradientMix.$stops?.length, 2);
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

        expect(merged.$center, resolvesTo(Alignment.center));
        expect(merged.$radius, resolvesTo(0.8));
        expect(merged.$colors, hasLength(2));
        expect(merged.$colors![0], resolvesTo(Colors.green));
        expect(merged.$colors![1], resolvesTo(Colors.yellow));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final gradientMix = RadialGradientMix(
          center: Alignment.center,
          radius: 0.5,
          tileMode: TileMode.mirror,
          focal: Alignment.topLeft,
          focalRadius: 0.3,
          transform: const GradientRotation(1.0),
          colors: [Colors.red, Colors.blue],
          stops: [0.0, 1.0],
        );

        expect(gradientMix.props.length, 8);
        expect(gradientMix.props, contains(gradientMix.$center));
        expect(gradientMix.props, contains(gradientMix.$radius));
        expect(gradientMix.props, contains(gradientMix.$tileMode));
        expect(gradientMix.props, contains(gradientMix.$focal));
        expect(gradientMix.props, contains(gradientMix.$focalRadius));
        expect(gradientMix.props, contains(gradientMix.$transform));
        expect(gradientMix.props, contains(gradientMix.$colors));
        expect(gradientMix.props, contains(gradientMix.$stops));
      });
    });

    group('Default Value', () {
      test('has correct default value', () {
        final gradientMix = RadialGradientMix();

        expect(gradientMix.defaultValue, const RadialGradient(colors: []));
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

        expect(sweepGradientMix.$center, resolvesTo(Alignment.center));
        expect(sweepGradientMix.$startAngle, resolvesTo(0.0));
        expect(sweepGradientMix.$endAngle, resolvesTo(3.14159));
        expect(sweepGradientMix.$tileMode, resolvesTo(TileMode.mirror));
        expect(sweepGradientMix.$colors, hasLength(2));
      });

      test('value constructor extracts all properties from SweepGradient', () {
        const sweepGradient = SweepGradient(
          center: Alignment.topRight,
          startAngle: 1.0,
          endAngle: 2.0,
          colors: [Colors.cyan, Colors.pink, Colors.lime],
          stops: [0.2, 0.7, 1.0],
          tileMode: TileMode.decal,
          transform: GradientRotation(0.75),
        );

        final sweepGradientMix = SweepGradientMix.value(sweepGradient);

        expect(sweepGradientMix.$center, resolvesTo(Alignment.topRight));
        expect(sweepGradientMix.$startAngle, resolvesTo(1.0));
        expect(sweepGradientMix.$endAngle, resolvesTo(2.0));
        expect(sweepGradientMix.$tileMode, resolvesTo(TileMode.decal));
        expect(sweepGradientMix.$transform, resolvesTo(const GradientRotation(0.75)));
        
        expect(sweepGradientMix.$colors, hasLength(3));
        expect(sweepGradientMix.$colors![0], resolvesTo(Colors.cyan));
        expect(sweepGradientMix.$colors![1], resolvesTo(Colors.pink));
        expect(sweepGradientMix.$colors![2], resolvesTo(Colors.lime));
        
        expect(sweepGradientMix.$stops, hasLength(3));
        expect(sweepGradientMix.$stops![0], resolvesTo(0.2));
        expect(sweepGradientMix.$stops![1], resolvesTo(0.7));
        expect(sweepGradientMix.$stops![2], resolvesTo(1.0));
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

    group('Factory Constructors', () {
      test('center factory creates SweepGradientMix with center', () {
        final gradientMix = SweepGradientMix.center(Alignment.topLeft);

        expect(gradientMix.$center, resolvesTo(Alignment.topLeft));
        expect(gradientMix.$startAngle, isNull);
        expect(gradientMix.$endAngle, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('startAngle factory creates SweepGradientMix with startAngle', () {
        final gradientMix = SweepGradientMix.startAngle(1.5);

        expect(gradientMix.$startAngle, resolvesTo(1.5));
        expect(gradientMix.$center, isNull);
        expect(gradientMix.$endAngle, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('endAngle factory creates SweepGradientMix with endAngle', () {
        final gradientMix = SweepGradientMix.endAngle(2.5);

        expect(gradientMix.$endAngle, resolvesTo(2.5));
        expect(gradientMix.$center, isNull);
        expect(gradientMix.$startAngle, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('tileMode factory creates SweepGradientMix with tileMode', () {
        final gradientMix = SweepGradientMix.tileMode(TileMode.mirror);

        expect(gradientMix.$tileMode, resolvesTo(TileMode.mirror));
        expect(gradientMix.$center, isNull);
        expect(gradientMix.$startAngle, isNull);
        expect(gradientMix.$endAngle, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('transform factory creates SweepGradientMix with transform', () {
        const transform = GradientRotation(2.0);
        final gradientMix = SweepGradientMix.transform(transform);

        expect(gradientMix.$transform, resolvesTo(transform));
        expect(gradientMix.$center, isNull);
        expect(gradientMix.$startAngle, isNull);
        expect(gradientMix.$endAngle, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('colors factory creates SweepGradientMix with colors', () {
        final colors = [Colors.red, Colors.green, Colors.blue];
        final gradientMix = SweepGradientMix.colors(colors);

        expect(gradientMix.$colors?.length, 3);
        expect(gradientMix.$center, isNull);
        expect(gradientMix.$startAngle, isNull);
        expect(gradientMix.$endAngle, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('stops factory creates SweepGradientMix with stops', () {
        final stops = [0.0, 0.5, 1.0];
        final gradientMix = SweepGradientMix.stops(stops);

        expect(gradientMix.$stops?.length, 3);
        expect(gradientMix.$center, isNull);
        expect(gradientMix.$startAngle, isNull);
        expect(gradientMix.$endAngle, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
      });
    });

    group('Utility Methods', () {
      test('center utility works correctly', () {
        final gradientMix = SweepGradientMix().center(Alignment.topLeft);

        expect(gradientMix.$center, resolvesTo(Alignment.topLeft));
      });

      test('startAngle utility works correctly', () {
        final gradientMix = SweepGradientMix().startAngle(0.5);

        expect(gradientMix.$startAngle, resolvesTo(0.5));
      });

      test('endAngle utility works correctly', () {
        final gradientMix = SweepGradientMix().endAngle(3.0);

        expect(gradientMix.$endAngle, resolvesTo(3.0));
      });

      test('tileMode utility works correctly', () {
        final gradientMix = SweepGradientMix().tileMode(TileMode.repeated);

        expect(gradientMix.$tileMode, resolvesTo(TileMode.repeated));
      });

      test('transform utility works correctly', () {
        const transform = GradientRotation(1.25);
        final gradientMix = SweepGradientMix().transform(transform);

        expect(gradientMix.$transform, resolvesTo(transform));
      });

      test('colors utility works correctly', () {
        final colors = [Colors.yellow, Colors.purple];
        final gradientMix = SweepGradientMix().colors(colors);

        expect(gradientMix.$colors?.length, 2);
      });

      test('stops utility works correctly', () {
        final stops = [0.3, 0.7];
        final gradientMix = SweepGradientMix().stops(stops);

        expect(gradientMix.$stops?.length, 2);
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

        expect(merged.$center, resolvesTo(Alignment.center));
        expect(merged.$startAngle, resolvesTo(0.0));
        expect(merged.$endAngle, resolvesTo(3.14159));
        expect(merged.$colors, hasLength(2));
        expect(merged.$colors![0], resolvesTo(Colors.green));
        expect(merged.$colors![1], resolvesTo(Colors.yellow));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final gradientMix = SweepGradientMix(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 3.14159,
          tileMode: TileMode.mirror,
          transform: const GradientRotation(1.0),
          colors: [Colors.red, Colors.blue],
          stops: [0.0, 1.0],
        );

        expect(gradientMix.props.length, 7);
        expect(gradientMix.props, contains(gradientMix.$center));
        expect(gradientMix.props, contains(gradientMix.$startAngle));
        expect(gradientMix.props, contains(gradientMix.$endAngle));
        expect(gradientMix.props, contains(gradientMix.$tileMode));
        expect(gradientMix.props, contains(gradientMix.$transform));
        expect(gradientMix.props, contains(gradientMix.$colors));
        expect(gradientMix.props, contains(gradientMix.$stops));
      });
    });

    group('Default Value', () {
      test('has correct default value', () {
        final gradientMix = SweepGradientMix();

        expect(gradientMix.defaultValue, const SweepGradient(colors: []));
      });
    });
  });
}