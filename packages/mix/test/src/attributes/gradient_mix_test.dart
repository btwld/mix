import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
import '../../helpers/testing_utils.dart';

void main() {
  // Base GradientMix factory tests
  group('GradientMix factory tests', () {
    test('value factory with LinearGradient', () {
      const gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.red, Colors.blue],
        stops: [0.0, 1.0],
      );

      final mix = GradientMix.value(gradient);

      expect(mix, isA<LinearGradientMix>());
      expect(mix, resolvesTo(gradient));
    });

    test('value factory with RadialGradient', () {
      const gradient = RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [Colors.red, Colors.blue],
        stops: [0.0, 1.0],
      );

      final mix = GradientMix.value(gradient);

      expect(mix, isA<RadialGradientMix>());
      expect(mix, resolvesTo(gradient));
    });

    test('value factory with SweepGradient', () {
      const gradient = SweepGradient(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 1.0,
        colors: [Colors.red, Colors.blue],
        stops: [0.0, 1.0],
      );

      final mix = GradientMix.value(gradient);

      expect(mix, isA<SweepGradientMix>());
      expect(mix, resolvesTo(gradient));
    });

    test('maybeValue factory with null', () {
      final mix = GradientMix.maybeValue(null);
      expect(mix, isNull);
    });

    test('maybeValue factory with non-null gradient', () {
      const gradient = LinearGradient(colors: [Colors.red, Colors.blue]);
      final mix = GradientMix.maybeValue(gradient);

      expect(mix, isNotNull);
      expect(mix, isA<LinearGradientMix>());
    });
  });

  // Simplified merge tests (same-type merging + override behavior)
  group('GradientMix simplified merge tests', () {
    test('tryToMerge with same types', () {
      final mix1 = LinearGradientMix.only(colors: const [Colors.red]);
      final mix2 = LinearGradientMix.only(colors: const [Colors.blue]);

      final merged = GradientMix.tryToMerge(mix1, mix2) as LinearGradientMix?;

      expect(merged, isNotNull);
      expect(merged!.colors, resolvesTo([Colors.blue]));
    });

    test('tryToMerge LinearGradient with RadialGradient (override behavior)', () {
      final linear = LinearGradientMix.only(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const [Colors.red, Colors.green],
      );
      final radial = RadialGradientMix.only(
        center: Alignment.center,
        radius: 0.8,
        colors: const [Colors.blue, Colors.yellow],
      );

      // Simplified behavior: different types result in override (second parameter wins)
      final merged =
          GradientMix.tryToMerge(linear, radial) as RadialGradientMix?;

      expect(merged, isNotNull);
      expect(
        merged,
        same(radial),
      ); // Should be exactly the same object (override behavior)
    });

    test('tryToMerge with null values', () {
      final mix = LinearGradientMix.only(colors: const [Colors.red]);

      expect(GradientMix.tryToMerge(mix, null), same(mix));
      expect(GradientMix.tryToMerge(null, dto), same(mix));
      expect(GradientMix.tryToMerge(null, null), isNull);
    });

    test('common properties merge correctly across all gradient types', () {
      // Test that common properties (colors, stops, transform) merge consistently
      const transform = GradientRotation(1.0);
      final baseColors = [Colors.red];
      final baseStops = [0.0];
      final mergeColors = [Colors.blue, Colors.green];
      final mergeStops = [0.0, 1.0];

      // Test LinearGradient
      final linear1 = LinearGradientMix.only(
        colors: baseColors,
        stops: baseStops,
        transform: transform,
      );
      final linear2 = LinearGradientMix.only(
        colors: mergeColors,
        stops: mergeStops,
      );
      final mergedLinear = linear1.merge(linear2);
      expect(mergedLinear.colors, resolvesTo(mergeColors));
      expect(mergedLinear.stops, resolvesTo(mergeStops));
      expect(mergedLinear.transform, resolvesTo(transform));

      // Test RadialGradient
      final radial1 = RadialGradientMix.only(
        colors: baseColors,
        stops: baseStops,
        transform: transform,
      );
      final radial2 = RadialGradientMix.only(
        colors: mergeColors,
        stops: mergeStops,
      );
      final mergedRadial = radial1.merge(radial2);
      expect(mergedRadial.colors, resolvesTo(mergeColors));
      expect(mergedRadial.stops, resolvesTo(mergeStops));
      expect(mergedRadial.transform, resolvesTo(transform));
    });
  });

  group('LinearGradientMix', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test(
        'main constructor creates LinearGradientMix with all properties',
        () {
          const transform = GradientRotation(1.5);
          final mix = LinearGradientMix.only(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            tileMode: TileMode.clamp,
            transform: transform,
            colors: const [Colors.red, Colors.blue],
            stops: const [0.0, 1.0],
          );

          expect(mix.begin, resolvesTo(Alignment.topLeft));
          expect(mix.end, resolvesTo(Alignment.bottomRight));
          expect(mix.tileMode, resolvesTo(TileMode.clamp));
          expect(mix.transform, resolvesTo(transform));
          expect(mix.colors, resolvesTo([Colors.red, Colors.blue]));
          expect(mix.stops, resolvesTo([0.0, 1.0]));
        },
      );

      test('only constructor with raw values', () {
        final mix = LinearGradientMix.only(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.mirror,
          colors: const [Colors.green, Colors.yellow],
          stops: const [0.25, 0.75],
        );

        expect(mix.begin, resolvesTo(Alignment.topCenter));
        expect(mix.end, resolvesTo(Alignment.bottomCenter));
        expect(mix.tileMode, resolvesTo(TileMode.mirror));
        expect(mix.colors, resolvesTo([Colors.green, Colors.yellow]));
        expect(mix.stops, resolvesTo([0.25, 0.75]));
      });

      test('main constructor with Prop values', () {
        final mix = LinearGradientMix(
          begin: Prop(Alignment.topCenter),
          end: Prop(Alignment.bottomCenter),
          tileMode: Prop(TileMode.mirror),
          colors: [Prop(Colors.green), Prop(Colors.yellow)],
          stops: [Prop(0.25), Prop(0.75)],
        );

        expect(mix.begin, resolvesTo(Alignment.topCenter));
        expect(mix.end, resolvesTo(Alignment.bottomCenter));
        expect(mix.tileMode, resolvesTo(TileMode.mirror));
        expect(mix.colors, resolvesTo([Colors.green, Colors.yellow]));
        expect(mix.stops, resolvesTo([0.25, 0.75]));
      });

      test('value constructor from LinearGradient', () {
        const gradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.red, Colors.blue],
          stops: [0.0, 1.0],
          tileMode: TileMode.repeated,
        );
        final mix = LinearGradientMix.value(gradient);

        expect(mix.begin, resolvesTo(gradient.begin));
        expect(mix.end, resolvesTo(gradient.end));
        expect(mix.colors, resolvesTo(gradient.colors));
        expect(mix.stops, resolvesTo(gradient.stops));
        expect(mix.tileMode, resolvesTo(gradient.tileMode));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns LinearGradientMix for non-null gradient', () {
        const gradient = LinearGradient(colors: [Colors.red, Colors.blue]);
        final mix = LinearGradientMix.maybeValue(gradient);

        expect(mix, isNotNull);
        expect(mix?.colors, resolvesTo(gradient.colors));
      });

      test('maybeValue returns null for null gradient', () {
        final mix = LinearGradientMix.maybeValue(null);
        expect(mix, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to LinearGradient with all properties', () {
        const transform = GradientRotation(2.0);
        final mix = LinearGradientMix.only(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
          transform: transform,
        );

        expect(
          dto,
          resolvesTo(
            const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.red, Colors.blue],
              stops: [0.0, 1.0],
              tileMode: TileMode.mirror,
              transform: transform,
            ),
          ),
        );
      });

      test('resolves with default values for null properties', () {
        final mix = LinearGradientMix.only(
          begin: null,
          end: null,
          tileMode: null,
          transform: null,
          colors: const [Colors.purple],
          stops: null,
        );

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.begin, Alignment.centerLeft);
        expect(resolved.end, Alignment.centerRight);
        expect(resolved.tileMode, TileMode.clamp);
        expect(resolved.transform, isNull);
        expect(resolved.colors, [Colors.purple]);
        expect(resolved.stops, isNull);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another LinearGradientMix - all properties', () {
        const transform1 = GradientRotation(1.0);
        const transform2 = GradientRotation(2.0);

        final mix1 = LinearGradientMix.only(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.clamp,
          transform: transform1,
        );
        final mix2 = LinearGradientMix.only(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: const [Colors.green, Colors.yellow],
          stops: const [0.25, 0.75],
          tileMode: TileMode.mirror,
          transform: transform2,
        );

        final merged = dto1.merge(mix2);

        expect(merged.begin, resolvesTo(Alignment.centerLeft));
        expect(merged.end, resolvesTo(Alignment.centerRight));
        expect(merged.colors, resolvesTo([Colors.green, Colors.yellow]));
        expect(merged.stops, resolvesTo([0.25, 0.75]));
        expect(merged.tileMode, resolvesTo(TileMode.mirror));
        expect(merged.transform, resolvesTo(transform2));
      });

      test('merge with partial properties', () {
        final mix1 = LinearGradientMix.only(
          begin: Alignment.topLeft,
          colors: const [Colors.red, Colors.blue],
          tileMode: TileMode.repeated,
        );
        final mix2 = LinearGradientMix.only(
          end: Alignment.bottomCenter,
          stops: const [0.3, 0.7],
        );

        final merged = dto1.merge(mix2);

        expect(merged.begin, resolvesTo(Alignment.topLeft));
        expect(merged.end, resolvesTo(Alignment.bottomCenter));
        expect(merged.colors, resolvesTo([Colors.red, Colors.blue]));
        expect(merged.stops, resolvesTo([0.3, 0.7]));
        expect(merged.tileMode, resolvesTo(TileMode.repeated));
      });

      test('merge with null returns original', () {
        final mix = LinearGradientMix.only(
          colors: const [Colors.purple, Colors.orange],
        );

        final merged = mix.merge(null);
        expect(merged, same(mix));
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal LinearGradientMixs', () {
        const transform = GradientRotation(1.5);
        final mix1 = LinearGradientMix.only(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
          transform: transform,
        );
        final mix2 = LinearGradientMix.only(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
          transform: transform,
        );

        expect(mix1, equals(mix2));
        expect(mix1.hashCode, equals(mix2.hashCode));
      });

      test('not equal LinearGradientMixs', () {
        final mix1 = LinearGradientMix.only(
          begin: Alignment.topLeft,
          colors: const [Colors.red, Colors.blue],
        );
        final mix2 = LinearGradientMix.only(
          begin: Alignment.centerLeft,
          colors: const [Colors.red, Colors.blue],
        );

        expect(mix1, isNot(equals(mix2)));
      });
    });

    // Edge Cases
    group('Edge Cases', () {
      test('handles empty colors list', () {
        final mix = LinearGradientMix.only(colors: const []);

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.colors, isEmpty);
      });

      test('handles single color', () {
        final mix = LinearGradientMix.only(colors: const [Colors.red]);

        expect(mix, resolvesTo(const LinearGradient(colors: [Colors.red])));
      });

      test('handles many colors without stops', () {
        final mix = LinearGradientMix.only(
          colors: const [Colors.red, Colors.green, Colors.blue, Colors.yellow],
        );

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.colors.length, 4);
        expect(resolved.stops, isNull);
      });

      test('handles mismatched colors and stops lengths', () {
        final mix = LinearGradientMix.only(
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 0.5, 1.0], // 3 stops for 2 colors
        );

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.colors, [Colors.red, Colors.blue]);
        expect(resolved.stops, [0.0, 0.5, 1.0]);
      });
    });
  });

  group('RadialGradientMix', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test(
        'main constructor creates RadialGradientMix with all properties',
        () {
          const transform = GradientRotation(1.5);
          final mix = RadialGradientMix.only(
            center: Alignment.center,
            radius: 0.5,
            focal: Alignment.bottomRight,
            focalRadius: 0.2,
            tileMode: TileMode.clamp,
            transform: transform,
            colors: const [Colors.red, Colors.blue],
            stops: const [0.0, 1.0],
          );

          expect(mix.center, resolvesTo(Alignment.center));
          expect(mix.radius, resolvesTo(0.5));
          expect(mix.focal, resolvesTo(Alignment.bottomRight));
          expect(mix.focalRadius, resolvesTo(0.2));
          expect(mix.tileMode, resolvesTo(TileMode.clamp));
          expect(mix.transform, resolvesTo(transform));
          expect(mix.colors, resolvesTo([Colors.red, Colors.blue]));
          expect(mix.stops, resolvesTo([0.0, 1.0]));
        },
      );

      test('only constructor with raw values', () {
        final mix = RadialGradientMix.only(
          center: Alignment.topCenter,
          radius: 0.8,
          tileMode: TileMode.mirror,
          colors: const [Colors.green, Colors.yellow],
          stops: const [0.25, 0.75],
        );

        expect(mix.center, resolvesTo(Alignment.topCenter));
        expect(mix.radius, resolvesTo(0.8));
        expect(mix.tileMode, resolvesTo(TileMode.mirror));
        expect(mix.colors, resolvesTo([Colors.green, Colors.yellow]));
        expect(mix.stops, resolvesTo([0.25, 0.75]));
      });

      test('main constructor with Prop values', () {
        final mix = RadialGradientMix(
          center: Prop(Alignment.topCenter),
          radius: Prop(0.8),
          tileMode: Prop(TileMode.mirror),
          colors: [Prop(Colors.green), Prop(Colors.yellow)],
          stops: [Prop(0.25), Prop(0.75)],
        );

        expect(mix.center, resolvesTo(Alignment.topCenter));
        expect(mix.radius, resolvesTo(0.8));
        expect(mix.tileMode, resolvesTo(TileMode.mirror));
        expect(mix.colors, resolvesTo([Colors.green, Colors.yellow]));
        expect(mix.stops, resolvesTo([0.25, 0.75]));
      });

      test('value constructor from RadialGradient', () {
        const gradient = RadialGradient(
          center: Alignment.bottomCenter,
          radius: 0.7,
          colors: [Colors.purple, Colors.orange],
          stops: [0.2, 0.8],
          tileMode: TileMode.repeated,
          focal: Alignment.center,
          focalRadius: 0.1,
        );
        final mix = RadialGradientMix.value(gradient);

        expect(mix.center, resolvesTo(gradient.center));
        expect(mix.radius, resolvesTo(gradient.radius));
        expect(mix.focal, resolvesTo(gradient.focal));
        expect(mix.focalRadius, resolvesTo(gradient.focalRadius));
        expect(mix.colors, resolvesTo(gradient.colors));
        expect(mix.stops, resolvesTo(gradient.stops));
        expect(mix.tileMode, resolvesTo(gradient.tileMode));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns RadialGradientMix for non-null gradient', () {
        const gradient = RadialGradient(colors: [Colors.red, Colors.blue]);
        final mix = RadialGradientMix.maybeValue(gradient);

        expect(mix, isNotNull);
        expect(mix?.colors, gradient.colors);
      });

      test('maybeValue returns null for null gradient', () {
        final mix = RadialGradientMix.maybeValue(null);
        expect(mix, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to RadialGradient with all properties', () {
        const transform = GradientRotation(2.0);
        final mix = RadialGradientMix.only(
          center: Alignment.center,
          radius: 0.5,
          focal: Alignment.topRight,
          focalRadius: 0.3,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
          transform: transform,
        );

        expect(
          dto,
          resolvesTo(
            const RadialGradient(
              center: Alignment.center,
              radius: 0.5,
              focal: Alignment.topRight,
              focalRadius: 0.3,
              colors: [Colors.red, Colors.blue],
              stops: [0.0, 1.0],
              tileMode: TileMode.mirror,
              transform: transform,
            ),
          ),
        );
      });

      test('resolves with default values for null properties', () {
        final mix = RadialGradientMix.only(
          center: null,
          radius: null,
          focal: null,
          focalRadius: null,
          tileMode: null,
          transform: null,
          colors: const [Colors.purple],
          stops: null,
        );

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.center, Alignment.center);
        expect(resolved.radius, 0.5);
        expect(resolved.focal, isNull);
        expect(resolved.focalRadius, 0.0);
        expect(resolved.tileMode, TileMode.clamp);
        expect(resolved.transform, isNull);
        expect(resolved.colors, [Colors.purple]);
        expect(resolved.stops, isNull);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another RadialGradientMix - all properties', () {
        const transform1 = GradientRotation(1.0);
        const transform2 = GradientRotation(2.0);

        final mix1 = RadialGradientMix.only(
          center: Alignment.center,
          radius: 0.5,
          focal: Alignment.bottomLeft,
          focalRadius: 0.1,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.clamp,
          transform: transform1,
        );
        final mix2 = RadialGradientMix.only(
          center: Alignment.centerLeft,
          radius: 0.75,
          focal: Alignment.topRight,
          focalRadius: 0.2,
          colors: const [Colors.green, Colors.yellow],
          stops: const [0.25, 0.75],
          tileMode: TileMode.mirror,
          transform: transform2,
        );

        final merged = dto1.merge(mix2);

        expect(merged.center, resolvesTo(Alignment.centerLeft));
        expect(merged.radius, resolvesTo(0.75));
        expect(merged.focal, resolvesTo(Alignment.topRight));
        expect(merged.focalRadius, resolvesTo(0.2));
        expect(merged.colors, resolvesTo([Colors.green, Colors.yellow]));
        expect(merged.stops, resolvesTo([0.25, 0.75]));
        expect(merged.tileMode, resolvesTo(TileMode.mirror));
        expect(merged.transform, resolvesTo(transform2));
      });

      test('merge with partial properties', () {
        final mix1 = RadialGradientMix.only(
          center: Alignment.topCenter,
          radius: 0.6,
          colors: const [Colors.red, Colors.blue],
        );
        final mix2 = RadialGradientMix.only(
          focal: Alignment.center,
          focalRadius: 0.15,
          stops: const [0.3, 0.7],
        );

        final merged = dto1.merge(mix2);

        expect(merged.center, resolvesTo(Alignment.topCenter));
        expect(merged.radius, resolvesTo(0.6));
        expect(merged.focal, resolvesTo(Alignment.center));
        expect(merged.focalRadius, resolvesTo(0.15));
        expect(merged.colors, resolvesTo([Colors.red, Colors.blue]));
        expect(merged.stops, resolvesTo([0.3, 0.7]));
      });

      test('merge with null returns original', () {
        final mix = RadialGradientMix.only(
          colors: const [Colors.purple, Colors.orange],
          radius: 0.8,
        );

        final merged = mix.merge(null);
        expect(merged, same(mix));
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal RadialGradientMixs', () {
        const transform = GradientRotation(1.5);
        final mix1 = RadialGradientMix.only(
          center: Alignment.center,
          radius: 0.5,
          focal: Alignment.topLeft,
          focalRadius: 0.1,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
          transform: transform,
        );
        final mix2 = RadialGradientMix.only(
          center: Alignment.center,
          radius: 0.5,
          focal: Alignment.topLeft,
          focalRadius: 0.1,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
          transform: transform,
        );

        expect(mix1, equals(mix2));
        expect(mix1.hashCode, equals(mix2.hashCode));
      });

      test('not equal RadialGradientMixs', () {
        final mix1 = RadialGradientMix.only(
          center: Alignment.center,
          radius: 0.5,
          colors: const [Colors.red, Colors.blue],
        );
        final mix2 = RadialGradientMix.only(
          center: Alignment.center,
          radius: 0.6,
          colors: const [Colors.red, Colors.blue],
        );

        expect(mix1, isNot(equals(mix2)));
      });
    });

    // Edge Cases
    group('Edge Cases', () {
      test('handles radius at boundaries', () {
        final mix1 = RadialGradientMix.only(
          radius: 0.0,
          colors: const [Colors.red, Colors.blue],
        );
        final mix2 = RadialGradientMix.only(
          radius: 1.0,
          colors: const [Colors.red, Colors.blue],
        );

        expect(mix1.radius, resolvesTo(0.0));
        expect(mix2.radius, resolvesTo(1.0));
      });

      test('handles focal and focalRadius relationships', () {
        final mix = RadialGradientMix.only(
          focal: Alignment.topRight,
          focalRadius: 0.5,
          colors: const [Colors.red, Colors.blue],
        );

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.focal, Alignment.topRight);
        expect(resolved.focalRadius, 0.5);
      });

      test('handles focal without focalRadius', () {
        final mix = RadialGradientMix.only(
          focal: Alignment.bottomLeft,
          colors: const [Colors.red, Colors.blue],
        );

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.focal, Alignment.bottomLeft);
        expect(resolved.focalRadius, 0.0);
      });
    });
  });

  group('SweepGradientMix', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('main constructor creates SweepGradientMix with all properties', () {
        const transform = GradientRotation(1.5);
        final mix = SweepGradientMix.only(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 6.28, // 2π
          tileMode: TileMode.clamp,
          transform: transform,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
        );

        expect(mix.center, resolvesTo(Alignment.center));
        expect(mix.startAngle, resolvesTo(0.0));
        expect(mix.endAngle, resolvesTo(6.28));
        expect(mix.tileMode, resolvesTo(TileMode.clamp));
        expect(mix.transform, resolvesTo(transform));
        expect(mix.colors, resolvesTo([Colors.red, Colors.blue]));
        expect(mix.stops, resolvesTo([0.0, 1.0]));
      });

      test('only constructor with raw values', () {
        final mix = SweepGradientMix.only(
          center: Alignment.topCenter,
          startAngle: 1.57, // π/2
          endAngle: 4.71, // 3π/2
          tileMode: TileMode.mirror,
          colors: const [Colors.green, Colors.yellow],
          stops: const [0.25, 0.75],
        );

        expect(mix.center, resolvesTo(Alignment.topCenter));
        expect(mix.startAngle, resolvesTo(1.57));
        expect(mix.endAngle, resolvesTo(4.71));
        expect(mix.tileMode, resolvesTo(TileMode.mirror));
        expect(mix.colors, resolvesTo([Colors.green, Colors.yellow]));
        expect(mix.stops, resolvesTo([0.25, 0.75]));
      });

      test('main constructor with Prop values', () {
        final mix = SweepGradientMix(
          center: Prop(Alignment.topCenter),
          startAngle: Prop(1.57), // π/2
          endAngle: Prop(4.71), // 3π/2
          tileMode: Prop(TileMode.mirror),
          colors: [Prop(Colors.green), Prop(Colors.yellow)],
          stops: [Prop(0.25), Prop(0.75)],
        );

        expect(mix.center, resolvesTo(Alignment.topCenter));
        expect(mix.startAngle, resolvesTo(1.57));
        expect(mix.endAngle, resolvesTo(4.71));
        expect(mix.tileMode, resolvesTo(TileMode.mirror));
        expect(mix.colors, resolvesTo([Colors.green, Colors.yellow]));
        expect(mix.stops, resolvesTo([0.25, 0.75]));
      });

      test('value constructor from SweepGradient', () {
        const gradient = SweepGradient(
          center: Alignment.bottomCenter,
          startAngle: 0.5,
          endAngle: 5.5,
          colors: [Colors.purple, Colors.orange],
          stops: [0.2, 0.8],
          tileMode: TileMode.repeated,
        );
        final mix = SweepGradientMix.value(gradient);

        expect(mix.center, resolvesTo(gradient.center));
        expect(mix.startAngle, resolvesTo(gradient.startAngle));
        expect(mix.endAngle, resolvesTo(gradient.endAngle));
        expect(mix.colors, resolvesTo(gradient.colors));
        expect(mix.stops, resolvesTo(gradient.stops));
        expect(mix.tileMode, resolvesTo(gradient.tileMode));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns SweepGradientMix for non-null gradient', () {
        const gradient = SweepGradient(colors: [Colors.red, Colors.blue]);
        final mix = SweepGradientMix.maybeValue(gradient);

        expect(mix, isNotNull);
        expect(mix?.colors, gradient.colors);
      });

      test('maybeValue returns null for null gradient', () {
        final mix = SweepGradientMix.maybeValue(null);
        expect(mix, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to SweepGradient with all properties', () {
        const transform = GradientRotation(2.0);
        final mix = SweepGradientMix.only(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 6.28,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
          transform: transform,
        );

        expect(
          dto,
          resolvesTo(
            const SweepGradient(
              center: Alignment.center,
              startAngle: 0.0,
              endAngle: 6.28,
              colors: [Colors.red, Colors.blue],
              stops: [0.0, 1.0],
              tileMode: TileMode.mirror,
              transform: transform,
            ),
          ),
        );
      });

      test('resolves with default values for null properties', () {
        final mix = SweepGradientMix.only(
          center: null,
          startAngle: null,
          endAngle: null,
          tileMode: null,
          transform: null,
          colors: const [Colors.purple],
          stops: null,
        );

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.center, Alignment.center);
        expect(resolved.startAngle, 0.0);
        expect(resolved.endAngle, 6.283185307179586); // 2π
        expect(resolved.tileMode, TileMode.clamp);
        expect(resolved.transform, isNull);
        expect(resolved.colors, [Colors.purple]);
        expect(resolved.stops, isNull);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another SweepGradientMix - all properties', () {
        const transform1 = GradientRotation(1.0);
        const transform2 = GradientRotation(2.0);

        final mix1 = SweepGradientMix.only(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 3.14,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.clamp,
          transform: transform1,
        );
        final mix2 = SweepGradientMix.only(
          center: Alignment.centerLeft,
          startAngle: 1.57,
          endAngle: 4.71,
          colors: const [Colors.green, Colors.yellow],
          stops: const [0.25, 0.75],
          tileMode: TileMode.mirror,
          transform: transform2,
        );

        final merged = dto1.merge(mix2);

        expect(merged.center, resolvesTo(Alignment.centerLeft));
        expect(merged.startAngle, resolvesTo(1.57));
        expect(merged.endAngle, resolvesTo(4.71));
        expect(merged.colors, resolvesTo([Colors.green, Colors.yellow]));
        expect(merged.stops, resolvesTo([0.25, 0.75]));
        expect(merged.tileMode, resolvesTo(TileMode.mirror));
        expect(merged.transform, resolvesTo(transform2));
      });

      test('merge with partial properties', () {
        final mix1 = SweepGradientMix.only(
          center: Alignment.topCenter,
          startAngle: 0.5,
          colors: const [Colors.red, Colors.blue],
        );
        final mix2 = SweepGradientMix.only(
          endAngle: 5.5,
          stops: const [0.3, 0.7],
          tileMode: TileMode.repeated,
        );

        final merged = dto1.merge(mix2);

        expect(merged.center, resolvesTo(Alignment.topCenter));
        expect(merged.startAngle, resolvesTo(0.5));
        expect(merged.endAngle, resolvesTo(5.5));
        expect(merged.colors, resolvesTo([Colors.red, Colors.blue]));
        expect(merged.stops, resolvesTo([0.3, 0.7]));
        expect(merged.tileMode, resolvesTo(TileMode.repeated));
      });

      test('merge with null returns original', () {
        final mix = SweepGradientMix.only(
          colors: const [Colors.purple, Colors.orange],
          startAngle: 0.0,
          endAngle: 6.28,
        );

        final merged = mix.merge(null);
        expect(merged, same(mix));
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal SweepGradientMixs', () {
        const transform = GradientRotation(1.5);
        final mix1 = SweepGradientMix.only(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 6.28,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
          transform: transform,
        );
        final mix2 = SweepGradientMix.only(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 6.28,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
          transform: transform,
        );

        expect(mix1, equals(mix2));
        expect(mix1.hashCode, equals(mix2.hashCode));
      });

      test('not equal SweepGradientMixs', () {
        final mix1 = SweepGradientMix.only(
          center: Alignment.center,
          startAngle: 0.0,
          colors: const [Colors.red, Colors.blue],
        );
        final mix2 = SweepGradientMix.only(
          center: Alignment.center,
          startAngle: 0.5,
          colors: const [Colors.red, Colors.blue],
        );

        expect(mix1, isNot(equals(mix2)));
      });
    });

    // Edge Cases
    group('Edge Cases', () {
      test('handles angle wrapping', () {
        final mix = SweepGradientMix.only(
          startAngle: -1.0,
          endAngle: 7.28, // > 2π
          colors: const [Colors.red, Colors.blue],
        );

        expect(mix.startAngle, resolvesTo(-1.0));
        expect(mix.endAngle, resolvesTo(7.28));
      });

      test('handles startAngle equal to endAngle', () {
        final mix = SweepGradientMix.only(
          startAngle: 3.14,
          endAngle: 3.14,
          colors: const [Colors.red, Colors.blue],
        );

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.startAngle, 3.14);
        expect(resolved.endAngle, 3.14);
      });

      test('handles colors in circular pattern', () {
        final mix = SweepGradientMix.only(
          colors: const [Colors.red, Colors.green, Colors.blue, Colors.red],
          stops: const [0.0, 0.33, 0.67, 1.0],
        );

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.colors.first, resolved.colors.last);
        expect(resolved.stops?.first, 0.0);
        expect(resolved.stops?.last, 1.0);
      });
    });
  });

  // Integration Tests
  group('Integration Tests', () {
    test('GradientMix in BoxDecoration context', () {
      final gradientDto = LinearGradientMix.only(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const [Colors.purple, Colors.orange],
      );

      final decorationDto = BoxDecorationMix.only(
        gradient: gradientDto,
        borderRadius: BorderRadiusMix.value(BorderRadius.circular(12)),
      );

      final context = MockBuildContext();
      final resolved = decorationDto.resolve(context);

      expect(resolved.gradient, isA<LinearGradient>());
      expect((resolved.gradient as LinearGradient).colors, [
        Colors.purple,
        Colors.orange,
      ]);
    });

    test('complex gradient merging scenario', () {
      final baseGradient = LinearGradientMix.only(
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );

      final overrideGradient = LinearGradientMix.only(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        tileMode: TileMode.mirror,
      );

      final finalGradient = LinearGradientMix.only(
        transform: const GradientRotation(1.57),
      );

      final merged = baseGradient.merge(overrideGradient).merge(finalGradient);

      expect(merged.colors, resolvesTo([Colors.red, Colors.blue]));
      expect(merged.stops, resolvesTo([0.0, 1.0]));
      expect(merged.begin, resolvesTo(Alignment.topCenter));
      expect(merged.end, resolvesTo(Alignment.bottomCenter));
      expect(merged.tileMode, resolvesTo(TileMode.mirror));
      expect(merged.transform, resolvesTo(const GradientRotation(1.57)));
    });
  });
}
