import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('ShadowUtility', () {
    late ShadowUtility<MockStyle<ShadowMix>> util;

    setUp(() {
      util = ShadowUtility<MockStyle<ShadowMix>>((mix) => MockStyle(mix));
    });

    group('utility properties', () {
      test('blurRadius is now a method', () {
        expect(util.blurRadius, isA<Function>());
      });

      test('has color utility', () {
        expect(util.color, isA<ColorUtility>());
      });

      test('has offset utility', () {
        expect(util.offset, isA<MixUtility>());
      });
    });

    group('property setters', () {
      test('blurRadius sets blur radius', () {
        final result = util.blurRadius(4.0);

        final shadow = result.value.resolve(MockBuildContext());

        expect(shadow, const Shadow(blurRadius: 4.0));
      });

      test('color sets shadow color', () {
        final result = util.color(Colors.red);

        final shadow = result.value.resolve(MockBuildContext());

        expect(shadow, const Shadow(color: Colors.red));
      });

      test('offset sets shadow offset', () {
        const offset = Offset(2.0, 3.0);
        final result = util.offset(offset);

        final shadow = result.value.resolve(MockBuildContext());

        expect(shadow, const Shadow(offset: offset));
      });
    });

    group('only method', () {
      test('sets specific properties', () {
        const offset = Offset(4.0, 5.0);
        final result = util(
          blurRadius: 8.0,
          color: Colors.blue,
          offset: offset,
        );

        final shadow = result.value.resolve(MockBuildContext());

        expect(
          shadow,
          const Shadow(blurRadius: 8.0, color: Colors.blue, offset: offset),
        );
      });

      test('handles partial properties', () {
        final result = util(blurRadius: 6.0, color: Colors.green);

        final shadow = result.value.resolve(MockBuildContext());

        expect(shadow, const Shadow(blurRadius: 6.0, color: Colors.green));
      });

      test('handles null values', () {
        final result = util();

        final shadow = result.value.resolve(MockBuildContext());

        expect(shadow, const Shadow());
      });
    });

    group('call method', () {
      test('delegates to only method', () {
        const offset = Offset(1.0, 2.0);
        final result = util(
          blurRadius: 3.0,
          color: Colors.yellow,
          offset: offset,
        );

        final shadow = result.value.resolve(MockBuildContext());

        expect(
          shadow,
          const Shadow(blurRadius: 3.0, color: Colors.yellow, offset: offset),
        );
      });

      test('handles partial parameters', () {
        final result = util(blurRadius: 2.0);

        final shadow = result.value.resolve(MockBuildContext());

        expect(shadow, const Shadow(blurRadius: 2.0));
      });
    });

    group('as method', () {
      test('accepts Shadow', () {
        const shadow = Shadow(
          blurRadius: 5.0,
          color: Colors.purple,
          offset: Offset(3.0, 4.0),
        );
        final result = util.as(shadow);

        expect(
          result.value,
          ShadowMix(
            blurRadius: 5.0,
            color: Colors.purple,
            offset: const Offset(3.0, 4.0),
          ),
        );
      });

      test('handles minimal Shadow', () {
        const shadow = Shadow();
        final result = util.as(shadow);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, shadow);
      });
    });

    group('color utility integration', () {
      test('color utility supports directives', () {
        final result = util.color.withOpacity(0.5);

        expect(result.value, isA<ShadowMix>());
        // Shadow color directives should be applied during resolution
      });

      test('color utility supports tokens', () {
        const colorToken = MixToken<Color>('shadowColor');
        final context = MockBuildContext(
          tokens: {TokenDefinition(colorToken, Colors.black54)},
        );

        final result = util.color.token(colorToken);
        final shadow = result.value.resolve(context);

        expect(shadow.color, Colors.black54);
      });
    });
  });

  group('BoxShadowUtility', () {
    late BoxShadowUtility<MockStyle<BoxShadowMix>> util;

    setUp(() {
      util = BoxShadowUtility<MockStyle<BoxShadowMix>>((mix) => MockStyle(mix));
    });

    group('utility properties', () {
      test('blurRadius is now a method', () {
        expect(util.blurRadius, isA<Function>());
      });

      test('spreadRadius is now a method', () {
        expect(util.spreadRadius, isA<Function>());
      });

      test('has color utility (deprecated)', () {
        expect(util.color, isA<ColorUtility>());
      });

      test('has offset utility (deprecated)', () {
        expect(util.offset, isA<MixUtility>());
      });
    });

    group('property setters', () {
      test('color sets box shadow color', () {
        final result = util.color(Colors.red);

        final boxShadow = result.value.resolve(MockBuildContext());

        expect(boxShadow, const BoxShadow(color: Colors.red));
      });

      test('offset sets box shadow offset', () {
        const offset = Offset(2.0, 3.0);
        final result = util.offset(offset);

        final boxShadow = result.value.resolve(MockBuildContext());

        expect(boxShadow, const BoxShadow(offset: offset));
      });

      test('blurRadius sets blur radius', () {
        final result = util.blurRadius(8.0);

        final boxShadow = result.value.resolve(MockBuildContext());

        expect(boxShadow, const BoxShadow(blurRadius: 8.0));
      });

      test('spreadRadius sets spread radius', () {
        final result = util.spreadRadius(2.0);

        final boxShadow = result.value.resolve(MockBuildContext());

        expect(boxShadow, const BoxShadow(spreadRadius: 2.0));
      });
    });

    group('only method', () {
      test('sets all properties', () {
        const offset = Offset(4.0, 5.0);
        final result = util(
          color: Colors.blue,
          offset: offset,
          blurRadius: 10.0,
          spreadRadius: 3.0,
        );

        final boxShadow = result.value.resolve(MockBuildContext());

        expect(
          boxShadow,
          const BoxShadow(
            color: Colors.blue,
            offset: offset,
            blurRadius: 10.0,
            spreadRadius: 3.0,
          ),
        );
      });

      test('handles partial properties', () {
        final result = util(color: Colors.green, blurRadius: 6.0);

        final boxShadow = result.value.resolve(MockBuildContext());

        expect(
          boxShadow,
          const BoxShadow(color: Colors.green, blurRadius: 6.0),
        );
      });

      test('handles null values', () {
        final result = util();

        final boxShadow = result.value.resolve(MockBuildContext());

        expect(boxShadow, const BoxShadow());
      });
    });

    group('call method', () {
      test('delegates to only method', () {
        const offset = Offset(1.0, 2.0);
        final result = util(
          color: Colors.yellow,
          offset: offset,
          blurRadius: 4.0,
          spreadRadius: 1.0,
        );

        final boxShadow = result.value.resolve(MockBuildContext());

        expect(
          boxShadow,
          const BoxShadow(
            color: Colors.yellow,
            offset: offset,
            blurRadius: 4.0,
            spreadRadius: 1.0,
          ),
        );
      });

      test('handles partial parameters', () {
        final result = util(color: Colors.orange, blurRadius: 5.0);

        final boxShadow = result.value.resolve(MockBuildContext());

        expect(
          boxShadow,
          const BoxShadow(color: Colors.orange, blurRadius: 5.0),
        );
      });
    });

    group('as method', () {
      test('accepts BoxShadow', () {
        const boxShadow = BoxShadow(
          color: Colors.purple,
          offset: Offset(3.0, 4.0),
          blurRadius: 8.0,
          spreadRadius: 2.0,
        );
        final result = util.as(boxShadow);

        expect(
          result.value,
          BoxShadowMix(
            color: Colors.purple,
            offset: const Offset(3.0, 4.0),
            blurRadius: 8.0,
            spreadRadius: 2.0,
          ),
        );
      });

      test('handles minimal BoxShadow', () {
        const boxShadow = BoxShadow();
        final result = util.as(boxShadow);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, boxShadow);
      });
    });

    group('color utility integration', () {
      test('color utility supports directives', () {
        final result = util.color.withAlpha(128);

        expect(result.value, isA<BoxShadowMix>());
        // BoxShadow color directives should be applied during resolution
      });

      test('color utility supports material colors', () {
        final result = util.color.black54();

        final boxShadow = result.value.resolve(MockBuildContext());

        expect(boxShadow.color, Colors.black54);
      });
    });
  });

  group('ElevationPropUtility', () {
    late ElevationPropUtility<MockStyle<List<Prop<BoxShadow>>>> util;

    setUp(() {
      util = ElevationPropUtility<MockStyle<List<Prop<BoxShadow>>>>(
        (mixProps) => MockStyle(mixProps),
      );
    });

    group('predefined elevation properties', () {
      test('has e1 property', () {
        expect(util.e1, isA<MockStyle<List<Prop<BoxShadow>>>>());
      });

      test('has e2 property', () {
        expect(util.e2, isA<MockStyle<List<Prop<BoxShadow>>>>());
      });

      test('has e3 property', () {
        expect(util.e3, isA<MockStyle<List<Prop<BoxShadow>>>>());
      });

      test('has e4 property', () {
        expect(util.e4, isA<MockStyle<List<Prop<BoxShadow>>>>());
      });

      test('has e6 property', () {
        expect(util.e6, isA<MockStyle<List<Prop<BoxShadow>>>>());
      });

      test('has e8 property', () {
        expect(util.e8, isA<MockStyle<List<Prop<BoxShadow>>>>());
      });

      test('has e9 property', () {
        expect(util.e9, isA<MockStyle<List<Prop<BoxShadow>>>>());
      });

      test('has e12 property', () {
        expect(util.e12, isA<MockStyle<List<Prop<BoxShadow>>>>());
      });

      test('has e16 property', () {
        expect(util.e16, isA<MockStyle<List<Prop<BoxShadow>>>>());
      });

      test('has e24 property', () {
        expect(util.e24, isA<MockStyle<List<Prop<BoxShadow>>>>());
      });
    });

    group('elevation getters', () {
      test('one creates elevation 1', () {
        final result = util.one;
        expect(result, isA<MockStyle<List<Prop<BoxShadow>>>>());
        expect(result.value.length, kElevationToShadow[1]!.length);
      });

      test('two creates elevation 2', () {
        final result = util.two;
        expect(result, isA<MockStyle<List<Prop<BoxShadow>>>>());
        expect(result.value.length, kElevationToShadow[2]!.length);
      });

      test('three creates elevation 3', () {
        final result = util.three;
        expect(result, isA<MockStyle<List<Prop<BoxShadow>>>>());
        expect(result.value.length, kElevationToShadow[3]!.length);
      });

      test('twentyFour creates elevation 24', () {
        final result = util.twentyFour;
        expect(result, isA<MockStyle<List<Prop<BoxShadow>>>>());
        expect(result.value.length, kElevationToShadow[24]!.length);
      });
    });

    group('call method', () {
      test('creates elevation shadow for valid values', () {
        const elevation = 6;
        final result = util(elevation);

        expect(result.value.length, kElevationToShadow[elevation]!.length);

        // Verify that the Props contain the correct BoxShadow values
        final expectedShadows = kElevationToShadow[elevation]!;
        for (int i = 0; i < expectedShadows.length; i++) {
          final mixProp = result.value[i];
          expect(mixProp, resolvesTo(expectedShadows[i]));
        }
      });

      test('throws FlutterError for invalid elevation values', () {
        expect(
          () => util(5), // 5 is not a valid predefined elevation
          throwsA(isA<FlutterError>()),
        );
      });

      test('throws FlutterError with proper error details', () {
        expect(
          () => util(100),
          throwsA(
            allOf([
              isA<FlutterError>(),
              predicate<FlutterError>((error) {
                final summary = error.diagnostics
                    .whereType<ErrorSummary>()
                    .first
                    .toString();
                return summary.contains('Invalid elevation value');
              }),
            ]),
          ),
        );
      });
    });

    group('predefined elevations validation', () {
      test('all predefined elevations are valid', () {
        final validElevations = [1, 2, 3, 4, 6, 8, 9, 12, 16, 24];

        for (final elevation in validElevations) {
          expect(() => util(elevation), returnsNormally);
        }
      });

      test('elevation values match Flutter material design', () {
        // Test that our elevation values correspond to actual Flutter values
        const testElevation = 3;
        final result = util(testElevation);
        final expectedShadows = kElevationToShadow[testElevation]!;

        expect(result.value.length, expectedShadows.length);
      });
    });

    group('shadow properties validation', () {
      test('elevation shadows have correct properties', () {
        const elevation = 8;
        final result = util(elevation);
        final expectedShadows = kElevationToShadow[elevation]!;

        for (int i = 0; i < expectedShadows.length; i++) {
          final mixProp = result.value[i];
          // Verify that each Prop resolves to the expected BoxShadow
          expect(mixProp, resolvesTo(expectedShadows[i]));
        }
      });
    });

    group('edge cases', () {
      test('handles minimum elevation', () {
        final result = util(1);
        expect(result.value.isNotEmpty, true);
      });

      test('handles maximum elevation', () {
        final result = util(24);
        expect(result.value.isNotEmpty, true);
      });

      test('throws for negative elevation', () {
        expect(() => util(-1), throwsA(isA<FlutterError>()));
      });

      test('handles zero elevation', () {
        final result = util(0);
        expect(result, isA<MockStyle<List<Prop<BoxShadow>>>>());
        expect(result.value, isEmpty);
      });
    });
  });

  group('Shadow integration tests', () {
    test('ShadowUtility and BoxShadowUtility work together', () {
      final shadowUtil = ShadowUtility<MockStyle<ShadowMix>>(
        (mix) => MockStyle(mix),
      );
      final boxShadowUtil = BoxShadowUtility<MockStyle<BoxShadowMix>>(
        (mix) => MockStyle(mix),
      );

      // Both should handle basic shadow properties
      final shadow = shadowUtil(
        color: Colors.black,
        blurRadius: 4.0,
        offset: const Offset(2, 2),
      );

      final boxShadow = boxShadowUtil(
        color: Colors.black,
        blurRadius: 4.0,
        offset: const Offset(2, 2),
        spreadRadius: 1.0,
      );

      expect(shadow.value, isA<ShadowMix>());
      expect(boxShadow.value, isA<BoxShadowMix>());
    });

    test('color utilities maintain consistency', () {
      final shadowUtil = ShadowUtility<MockStyle<ShadowMix>>(
        (mix) => MockStyle(mix),
      );
      final boxShadowUtil = BoxShadowUtility<MockStyle<BoxShadowMix>>(
        (mix) => MockStyle(mix),
      );

      // Both color utilities should support the same features
      final shadowColor = shadowUtil.color.red();
      final boxShadowColor = boxShadowUtil.color.red();

      final shadowResolved = shadowColor.value.resolve(MockBuildContext());
      final boxShadowResolved = boxShadowColor.value.resolve(
        MockBuildContext(),
      );

      expect(shadowResolved.color, Colors.red);
      expect(boxShadowResolved.color, Colors.red);
    });
  });
}
