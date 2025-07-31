import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('GradientUtility', () {
    late GradientUtility<MockStyle<GradientMix>> util;

    setUp(() {
      util = GradientUtility<MockStyle<GradientMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has linear utility', () {
        expect(util.linear, isA<LinearGradientUtility>());
      });

      test('has radial utility', () {
        expect(util.radial, isA<RadialGradientUtility>());
      });

      test('has sweep utility', () {
        expect(util.sweep, isA<SweepGradientUtility>());
      });
    });

    group('as method', () {
      test('accepts LinearGradient', () {
        const gradient = LinearGradient(
          colors: [Colors.red, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        final result = util.as(gradient);

        expect(result.value, isA<GradientMix>());
        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, gradient);
      });

      test('accepts RadialGradient', () {
        const gradient = RadialGradient(
          colors: [Colors.green, Colors.yellow],
          center: Alignment.center,
          radius: 0.8,
        );
        final result = util.as(gradient);

        expect(result.value, isA<GradientMix>());
        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, gradient);
      });

      test('accepts SweepGradient', () {
        const gradient = SweepGradient(
          colors: [Colors.purple, Colors.orange],
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: math.pi * 2,
        );
        final result = util.as(gradient);

        expect(result.value, isA<GradientMix>());
        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, gradient);
      });
    });
  });

  group('LinearGradientUtility', () {
    late LinearGradientUtility<MockStyle<LinearGradientMix>> util;

    setUp(() {
      util = LinearGradientUtility<MockStyle<LinearGradientMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has begin utility', () {
        expect(util.begin, isA<MixUtility>());
      });

      test('has end utility', () {
        expect(util.end, isA<MixUtility>());
      });

      test('has tileMode utility', () {
        expect(util.tileMode, isA<MixUtility>());
      });

      test('has transform utility', () {
        expect(util.transform, isA<MixUtility>());
      });

      test('has colors utility', () {
        expect(util.colors, isA<PropListUtility>());
      });

      test('has stops utility', () {
        expect(util.stops, isA<PropListUtility>());
      });
    });

    group('property setters', () {
      test('begin sets start alignment', () {
        final result = util.begin(Alignment.topLeft);

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          const LinearGradient(
            colors: [],
            begin: Alignment.topLeft,
          ),
        );
      });

      test('end sets end alignment', () {
        final result = util.end(Alignment.bottomRight);

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          const LinearGradient(
            colors: [],
            end: Alignment.bottomRight,
          ),
        );
      });

      test('tileMode sets tile mode', () {
        final result = util.tileMode(TileMode.mirror);

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          const LinearGradient(
            colors: [],
            tileMode: TileMode.mirror,
          ),
        );
      });

      test('colors sets gradient colors', () {
        final result = util.colors([Colors.red, Colors.blue, Colors.green]);

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          const LinearGradient(
            colors: [Colors.red, Colors.blue, Colors.green],
          ),
        );
      });

      test('stops sets gradient stops', () {
        final result = util.stops([0.0, 0.5, 1.0]);

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          const LinearGradient(
            colors: [],
            stops: [0.0, 0.5, 1.0],
          ),
        );
      });
    });

    group('only method', () {
      test('sets specific properties', () {
        final result = util.only(
          colors: [Colors.red, Colors.blue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.repeated,
          stops: [0.0, 1.0],
        );

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          const LinearGradient(
            colors: [Colors.red, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.repeated,
            stops: [0.0, 1.0],
          ),
        );
      });

      test('handles null values', () {
        final result = util.only();

        final gradient = result.value.resolve(MockBuildContext());

        expect(gradient, const LinearGradient(colors: []));
      });
    });

    group('call method', () {
      test('delegates to only method', () {
        final result = util(
          colors: [Colors.purple, Colors.orange],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          tileMode: TileMode.clamp,
        );

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          const LinearGradient(
            colors: [Colors.purple, Colors.orange],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            tileMode: TileMode.clamp,
          ),
        );
      });
    });

    group('as method', () {
      test('accepts LinearGradient', () {
        const gradient = LinearGradient(
          colors: [Colors.cyan, Colors.pink],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.2, 0.8],
          tileMode: TileMode.decal,
        );
        final result = util.as(gradient);

        expect(
          result.value,
          LinearGradientMix(
            colors: [Colors.cyan, Colors.pink],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.2, 0.8],
            tileMode: TileMode.decal,
          ),
        );
      });
    });
  });

  group('RadialGradientUtility', () {
    late RadialGradientUtility<MockStyle<RadialGradientMix>> util;

    setUp(() {
      util = RadialGradientUtility<MockStyle<RadialGradientMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has center utility', () {
        expect(util.center, isA<MixUtility>());
      });

      test('has radius utility', () {
        expect(util.radius, isA<MixUtility>());
      });

      test('has tileMode utility', () {
        expect(util.tileMode, isA<MixUtility>());
      });

      test('has focal utility', () {
        expect(util.focal, isA<MixUtility>());
      });

      test('has focalRadius utility', () {
        expect(util.focalRadius, isA<MixUtility>());
      });

      test('has transform utility', () {
        expect(util.transform, isA<MixUtility>());
      });

      test('has colors utility', () {
        expect(util.colors, isA<PropListUtility>());
      });

      test('has stops utility', () {
        expect(util.stops, isA<PropListUtility>());
      });
    });

    group('property setters', () {
      test('center sets gradient center', () {
        final result = util.center(Alignment.topLeft);

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          const RadialGradient(
            colors: [],
            center: Alignment.topLeft,
          ),
        );
      });

      test('radius sets gradient radius', () {
        final result = util.radius(0.7);

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          const RadialGradient(
            colors: [],
            radius: 0.7,
          ),
        );
      });

      test('focal sets focal point', () {
        final result = util.focal(Alignment.bottomRight);

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          const RadialGradient(
            colors: [],
            focal: Alignment.bottomRight,
          ),
        );
      });

      test('focalRadius sets focal radius', () {
        final result = util.focalRadius(0.3);

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          const RadialGradient(
            colors: [],
            focalRadius: 0.3,
          ),
        );
      });

      test('colors sets gradient colors', () {
        final result = util.colors([Colors.yellow, Colors.red]);

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          const RadialGradient(
            colors: [Colors.yellow, Colors.red],
          ),
        );
      });
    });

    group('only method', () {
      test('sets specific properties', () {
        final result = util.only(
          colors: [Colors.blue, Colors.white],
          center: Alignment.center,
          radius: 0.5,
          focal: Alignment.topCenter,
          focalRadius: 0.2,
          tileMode: TileMode.mirror,
          stops: [0.0, 1.0],
        );

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          const RadialGradient(
            colors: [Colors.blue, Colors.white],
            center: Alignment.center,
            radius: 0.5,
            focal: Alignment.topCenter,
            focalRadius: 0.2,
            tileMode: TileMode.mirror,
            stops: [0.0, 1.0],
          ),
        );
      });
    });

    group('call method', () {
      test('delegates to only method', () {
        final result = util(
          colors: [Colors.green, Colors.blue],
          center: Alignment.bottomLeft,
          radius: 0.8,
        );

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          const RadialGradient(
            colors: [Colors.green, Colors.blue],
            center: Alignment.bottomLeft,
            radius: 0.8,
          ),
        );
      });
    });

    group('as method', () {
      test('accepts RadialGradient', () {
        const gradient = RadialGradient(
          colors: [Colors.orange, Colors.purple],
          center: Alignment.centerRight,
          radius: 0.9,
          focal: Alignment.center,
          focalRadius: 0.1,
        );
        final result = util.as(gradient);

        expect(
          result.value,
          RadialGradientMix(
            colors: [Colors.orange, Colors.purple],
            center: Alignment.centerRight,
            radius: 0.9,
            focal: Alignment.center,
            focalRadius: 0.1,
          ),
        );
      });
    });
  });

  group('SweepGradientUtility', () {
    late SweepGradientUtility<MockStyle<SweepGradientMix>> util;

    setUp(() {
      util = SweepGradientUtility<MockStyle<SweepGradientMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has center utility', () {
        expect(util.center, isA<MixUtility>());
      });

      test('has startAngle utility', () {
        expect(util.startAngle, isA<MixUtility>());
      });

      test('has endAngle utility', () {
        expect(util.endAngle, isA<MixUtility>());
      });

      test('has tileMode utility', () {
        expect(util.tileMode, isA<MixUtility>());
      });

      test('has transform utility', () {
        expect(util.transform, isA<MixUtility>());
      });

      test('has colors utility', () {
        expect(util.colors, isA<PropListUtility>());
      });

      test('has stops utility', () {
        expect(util.stops, isA<PropListUtility>());
      });
    });

    group('property setters', () {
      test('center sets sweep center', () {
        final result = util.center(Alignment.bottomCenter);

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          const SweepGradient(
            colors: [],
            center: Alignment.bottomCenter,
          ),
        );
      });

      test('startAngle sets start angle', () {
        final result = util.startAngle(math.pi / 4);

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          SweepGradient(
            colors: const [],
            startAngle: math.pi / 4,
          ),
        );
      });

      test('endAngle sets end angle', () {
        final result = util.endAngle(math.pi * 1.5);

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          SweepGradient(
            colors: const [],
            endAngle: math.pi * 1.5,
          ),
        );
      });

      test('colors sets gradient colors', () {
        final result = util.colors([Colors.red, Colors.green, Colors.blue]);

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          const SweepGradient(
            colors: [Colors.red, Colors.green, Colors.blue],
          ),
        );
      });
    });

    group('only method', () {
      test('sets specific properties', () {
        final result = util.only(
          colors: [Colors.pink, Colors.yellow],
          center: Alignment.centerLeft,
          startAngle: 0.0,
          endAngle: math.pi,
          tileMode: TileMode.repeated,
          stops: [0.3, 0.7],
        );

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          SweepGradient(
            colors: const [Colors.pink, Colors.yellow],
            center: Alignment.centerLeft,
            startAngle: 0.0,
            endAngle: math.pi,
            tileMode: TileMode.repeated,
            stops: const [0.3, 0.7],
          ),
        );
      });
    });

    group('call method', () {
      test('delegates to only method', () {
        final result = util(
          colors: [Colors.cyan, Colors.pink],
          center: Alignment.topRight,
          startAngle: math.pi / 2,
          endAngle: math.pi * 2,
        );

        final gradient = result.value.resolve(MockBuildContext());

        expect(
          gradient,
          SweepGradient(
            colors: const [Colors.cyan, Colors.pink],
            center: Alignment.topRight,
            startAngle: math.pi / 2,
            endAngle: math.pi * 2,
          ),
        );
      });
    });

    group('as method', () {
      test('accepts SweepGradient', () {
        final gradient = SweepGradient(
          colors: const [Colors.indigo, Colors.teal],
          center: Alignment.bottomRight,
          startAngle: math.pi / 6,
          endAngle: math.pi * 1.8,
          tileMode: TileMode.clamp,
        );
        final result = util.as(gradient);

        expect(
          result.value,
          SweepGradientMix(
            colors: const [Colors.indigo, Colors.teal],
            center: Alignment.bottomRight,
            startAngle: math.pi / 6,
            endAngle: math.pi * 1.8,
            tileMode: TileMode.clamp,
          ),
        );
      });
    });
  });

  group('Gradient integration tests', () {
    late GradientUtility<MockStyle<GradientMix>> util;

    setUp(() {
      util = GradientUtility<MockStyle<GradientMix>>(
        (mix) => MockStyle(mix),
      );
    });

    test('linear gradient through parent utility', () {
      final result = util.linear(
        colors: [Colors.red, Colors.blue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

      final gradient = result.value.resolve(MockBuildContext());

      expect(
        gradient,
        const LinearGradient(
          colors: [Colors.red, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );
    });

    test('radial gradient through parent utility', () {
      final result = util.radial(
        colors: [Colors.green, Colors.yellow],
        center: Alignment.center,
        radius: 0.6,
      );

      final gradient = result.value.resolve(MockBuildContext());

      expect(
        gradient,
        const RadialGradient(
          colors: [Colors.green, Colors.yellow],
          center: Alignment.center,
          radius: 0.6,
        ),
      );
    });

    test('sweep gradient through parent utility', () {
      final result = util.sweep(
        colors: [Colors.purple, Colors.orange],
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: math.pi * 2,
      );

      final gradient = result.value.resolve(MockBuildContext());

      expect(
        gradient,
        SweepGradient(
          colors: const [Colors.purple, Colors.orange],
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: math.pi * 2,
        ),
      );
    });
  });

  group('Edge cases and validation', () {
    test('handles empty colors list', () {
      final util = LinearGradientUtility<MockStyle<LinearGradientMix>>(
        (mix) => MockStyle(mix),
      );

      final result = util.colors([]);
      final gradient = result.value.resolve(MockBuildContext());

      expect(gradient.colors, isEmpty);
    });

    test('handles single color', () {
      final util = RadialGradientUtility<MockStyle<RadialGradientMix>>(
        (mix) => MockStyle(mix),
      );

      final result = util.colors([Colors.red]);
      final gradient = result.value.resolve(MockBuildContext());

      expect(gradient.colors, [Colors.red]);
    });

    test('handles all TileMode values', () {
      final util = SweepGradientUtility<MockStyle<SweepGradientMix>>(
        (mix) => MockStyle(mix),
      );

      final tileModes = [
        TileMode.clamp,
        TileMode.repeated,
        TileMode.mirror,
        TileMode.decal,
      ];

      for (final tileMode in tileModes) {
        final result = util.tileMode(tileMode);
        final gradient = result.value.resolve(MockBuildContext());
        expect(gradient.tileMode, tileMode);
      }
    });

    test('handles mismatched colors and stops lengths', () {
      final util = LinearGradientUtility<MockStyle<LinearGradientMix>>(
        (mix) => MockStyle(mix),
      );

      final result = util.only(
        colors: [Colors.red, Colors.blue, Colors.green],
        stops: [0.0, 1.0], // Only 2 stops for 3 colors
      );

      final gradient = result.value.resolve(MockBuildContext());

      expect(gradient.colors.length, 3);
      expect(gradient.stops?.length, 2);
    });
  });
}