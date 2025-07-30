import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/properties/painting/gradient_mix.dart';

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

    group('Factory Constructors', () {
      test('begin factory creates LinearGradientMix with begin', () {
        final gradientMix = LinearGradientMix.begin(Alignment.centerLeft);

        expectProp(gradientMix.$begin, Alignment.centerLeft);
        expect(gradientMix.$end, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('end factory creates LinearGradientMix with end', () {
        final gradientMix = LinearGradientMix.end(Alignment.centerRight);

        expectProp(gradientMix.$end, Alignment.centerRight);
        expect(gradientMix.$begin, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('tileMode factory creates LinearGradientMix with tileMode', () {
        final gradientMix = LinearGradientMix.tileMode(TileMode.mirror);

        expectProp(gradientMix.$tileMode, TileMode.mirror);
        expect(gradientMix.$begin, isNull);
        expect(gradientMix.$end, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('transform factory creates LinearGradientMix with transform', () {
        const transform = GradientRotation(1.0);
        final gradientMix = LinearGradientMix.transform(transform);

        expectProp(gradientMix.$transform, transform);
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

        expectProp(gradientMix.$begin, Alignment.topLeft);
      });

      test('end utility works correctly', () {
        final gradientMix = LinearGradientMix().end(Alignment.bottomRight);

        expectProp(gradientMix.$end, Alignment.bottomRight);
      });

      test('tileMode utility works correctly', () {
        final gradientMix = LinearGradientMix().tileMode(TileMode.repeated);

        expectProp(gradientMix.$tileMode, TileMode.repeated);
      });

      test('transform utility works correctly', () {
        const transform = GradientRotation(0.25);
        final gradientMix = LinearGradientMix().transform(transform);

        expectProp(gradientMix.$transform, transform);
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

    group('Factory Constructors', () {
      test('center factory creates RadialGradientMix with center', () {
        final gradientMix = RadialGradientMix.center(Alignment.topLeft);

        expectProp(gradientMix.$center, Alignment.topLeft);
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

        expectProp(gradientMix.$radius, 0.8);
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

        expectProp(gradientMix.$tileMode, TileMode.mirror);
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

        expectProp(gradientMix.$focal, Alignment.bottomRight);
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

          expectProp(gradientMix.$focalRadius, 0.3);
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

        expectProp(gradientMix.$transform, transform);
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

        expectProp(gradientMix.$center, Alignment.topLeft);
      });

      test('radius utility works correctly', () {
        final gradientMix = RadialGradientMix().radius(0.6);

        expectProp(gradientMix.$radius, 0.6);
      });

      test('tileMode utility works correctly', () {
        final gradientMix = RadialGradientMix().tileMode(TileMode.repeated);

        expectProp(gradientMix.$tileMode, TileMode.repeated);
      });

      test('focal utility works correctly', () {
        final gradientMix = RadialGradientMix().focal(Alignment.centerRight);

        expectProp(gradientMix.$focal, Alignment.centerRight);
      });

      test('focalRadius utility works correctly', () {
        final gradientMix = RadialGradientMix().focalRadius(0.4);

        expectProp(gradientMix.$focalRadius, 0.4);
      });

      test('transform utility works correctly', () {
        const transform = GradientRotation(0.75);
        final gradientMix = RadialGradientMix().transform(transform);

        expectProp(gradientMix.$transform, transform);
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

        expectProp(merged.$center, Alignment.center);
        expectProp(merged.$radius, 0.8);
        expect(merged.$colors, hasLength(2));
        expectProp(merged.$colors![0], Colors.green);
        expectProp(merged.$colors![1], Colors.yellow);
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

    group('Factory Constructors', () {
      test('center factory creates SweepGradientMix with center', () {
        final gradientMix = SweepGradientMix.center(Alignment.topLeft);

        expectProp(gradientMix.$center, Alignment.topLeft);
        expect(gradientMix.$startAngle, isNull);
        expect(gradientMix.$endAngle, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('startAngle factory creates SweepGradientMix with startAngle', () {
        final gradientMix = SweepGradientMix.startAngle(1.5);

        expectProp(gradientMix.$startAngle, 1.5);
        expect(gradientMix.$center, isNull);
        expect(gradientMix.$endAngle, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('endAngle factory creates SweepGradientMix with endAngle', () {
        final gradientMix = SweepGradientMix.endAngle(2.5);

        expectProp(gradientMix.$endAngle, 2.5);
        expect(gradientMix.$center, isNull);
        expect(gradientMix.$startAngle, isNull);
        expect(gradientMix.$tileMode, isNull);
        expect(gradientMix.$transform, isNull);
        expect(gradientMix.$colors, isNull);
        expect(gradientMix.$stops, isNull);
      });

      test('tileMode factory creates SweepGradientMix with tileMode', () {
        final gradientMix = SweepGradientMix.tileMode(TileMode.mirror);

        expectProp(gradientMix.$tileMode, TileMode.mirror);
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

        expectProp(gradientMix.$transform, transform);
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

        expectProp(gradientMix.$center, Alignment.topLeft);
      });

      test('startAngle utility works correctly', () {
        final gradientMix = SweepGradientMix().startAngle(0.5);

        expectProp(gradientMix.$startAngle, 0.5);
      });

      test('endAngle utility works correctly', () {
        final gradientMix = SweepGradientMix().endAngle(3.0);

        expectProp(gradientMix.$endAngle, 3.0);
      });

      test('tileMode utility works correctly', () {
        final gradientMix = SweepGradientMix().tileMode(TileMode.repeated);

        expectProp(gradientMix.$tileMode, TileMode.repeated);
      });

      test('transform utility works correctly', () {
        const transform = GradientRotation(1.25);
        final gradientMix = SweepGradientMix().transform(transform);

        expectProp(gradientMix.$transform, transform);
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

        expectProp(merged.$center, Alignment.center);
        expectProp(merged.$startAngle, 0.0);
        expectProp(merged.$endAngle, 3.14159);
        expect(merged.$colors, hasLength(2));
        expectProp(merged.$colors![0], Colors.green);
        expectProp(merged.$colors![1], Colors.yellow);
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
