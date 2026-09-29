import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('BlurModifier', () {
    group('Constructor', () {
      test('assigns default sigma of 0.0', () {
        const modifier = BlurModifier();

        expect(modifier.sigma, 0.0);
      });

      test('assigns sigma correctly', () {
        const sigma = 5.0;
        const modifier = BlurModifier(sigma);

        expect(modifier.sigma, sigma);
      });

      test('defaults tileMode to clamp', () {
        const modifier = BlurModifier(5.0);

        expect(modifier.tileMode, ui.TileMode.clamp);
      });

      test('assigns tileMode correctly', () {
        const modifier = BlurModifier(5.0, ui.TileMode.decal);

        expect(modifier.tileMode, ui.TileMode.decal);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated sigma', () {
        const original = BlurModifier(5.0);
        final updated = original.copyWith(sigma: 8.0);

        expect(updated.sigma, 8.0);
        expect(updated, isNot(same(original)));
      });

      test('preserves original sigma when parameter is null', () {
        const original = BlurModifier(5.0);
        final updated = original.copyWith();

        expect(updated.sigma, 5.0);
        expect(updated, isNot(same(original)));
      });

      test('updates tileMode and preserves sigma', () {
        const original = BlurModifier(5.0);
        final updated = original.copyWith(tileMode: ui.TileMode.decal);

        expect(updated.sigma, 5.0);
        expect(updated.tileMode, ui.TileMode.decal);
      });

      test('preserves tileMode when parameter is null', () {
        const original = BlurModifier(5.0, ui.TileMode.decal);
        final updated = original.copyWith(sigma: 2.0);

        expect(updated.tileMode, ui.TileMode.decal);
      });
    });

    group('lerp', () {
      test('interpolates sigma correctly', () {
        const start = BlurModifier(0.0);
        const end = BlurModifier(10.0);
        final result = start.lerp(end, 0.5);

        expect(result.sigma, 5.0);
      });

      test('handles null other parameter', () {
        const start = BlurModifier(5.0);
        final result = start.lerp(null, 0.5);

        expect(result.sigma, 2.5);
      });

      test('handles extreme t values', () {
        const start = BlurModifier(0.0);
        const end = BlurModifier(10.0);

        final result0 = start.lerp(end, 0.0);
        expect(result0.sigma, 0.0);

        final result1 = start.lerp(end, 1.0);
        expect(result1.sigma, 10.0);
      });

      test('snaps tileMode at t = 0.5', () {
        const start = BlurModifier(0.0);
        const end = BlurModifier(10.0, ui.TileMode.decal);

        expect(start.lerp(end, 0.49).tileMode, ui.TileMode.clamp);
        expect(start.lerp(end, 0.5).tileMode, ui.TileMode.decal);
        expect(start.lerp(end, 1.0).tileMode, ui.TileMode.decal);
      });

      test('treats null other as the default tileMode', () {
        const start = BlurModifier(5.0, ui.TileMode.decal);

        expect(start.lerp(null, 0.25).tileMode, ui.TileMode.decal);
        expect(start.lerp(null, 0.75).tileMode, ui.TileMode.clamp);
      });
    });

    group('equality and hashCode', () {
      test('equal when sigma values match', () {
        const modifier1 = BlurModifier(5.0);
        const modifier2 = BlurModifier(5.0);

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });

      test('not equal when sigma differs', () {
        const modifier1 = BlurModifier(5.0);
        const modifier2 = BlurModifier(8.0);

        expect(modifier1, isNot(equals(modifier2)));
      });

      test('equal when sigma and tileMode match', () {
        const modifier1 = BlurModifier(5.0, ui.TileMode.decal);
        const modifier2 = BlurModifier(5.0, ui.TileMode.decal);

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });

      test('not equal when tileMode differs', () {
        const modifier1 = BlurModifier(5.0);
        const modifier2 = BlurModifier(5.0, ui.TileMode.decal);

        expect(modifier1, isNot(equals(modifier2)));
      });
    });

    group('props', () {
      test('contains sigma and tileMode values', () {
        const modifier = BlurModifier(5.0);

        expect(modifier.props, [5.0, ui.TileMode.clamp]);
      });
    });

    group('build', () {
      test('returns child unchanged when sigma is 0.0', () {
        const modifier = BlurModifier(0.0);
        const child = SizedBox(width: 50, height: 50);

        final result = modifier.build(child);

        expect(result, same(child));
      });

      testWidgets('creates ImageFiltered widget when sigma > 0', (
        WidgetTester tester,
      ) async {
        const sigma = 5.0;
        const modifier = BlurModifier(sigma);
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final imageFiltered = tester.widget<ImageFiltered>(
          find.byType(ImageFiltered),
        );
        expect(imageFiltered.child, same(child));

        // Verify the blur is applied (ImageFiltered with blur filter)
        expect(find.byType(ImageFiltered), findsOneWidget);
      });

      testWidgets('uses clamp tile mode by default', (tester) async {
        const modifier = BlurModifier(5.0);

        await tester.pumpWidget(modifier.build(const SizedBox()));

        final imageFiltered = tester.widget<ImageFiltered>(
          find.byType(ImageFiltered),
        );
        expect(
          imageFiltered.imageFilter,
          ui.ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY: 5.0,
            tileMode: ui.TileMode.clamp,
          ),
        );
      });

      testWidgets('passes decal tile mode to the blur filter', (tester) async {
        const modifier = BlurModifier(5.0, ui.TileMode.decal);

        await tester.pumpWidget(modifier.build(const SizedBox()));

        final imageFiltered = tester.widget<ImageFiltered>(
          find.byType(ImageFiltered),
        );
        expect(
          imageFiltered.imageFilter,
          ui.ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY: 5.0,
            tileMode: ui.TileMode.decal,
          ),
        );
      });
    });
  });

  group('BlurModifierMix', () {
    group('Constructor', () {
      test('creates with null sigma by default', () {
        final attribute = BlurModifierMix();

        expect(attribute.sigma, isNull);
        expect(attribute.tileMode, isNull);
      });

      test('creates with provided Prop sigma value', () {
        final sigma = Prop.value(5.0);
        final attribute = BlurModifierMix.create(sigma: sigma);

        expect(attribute.sigma, same(sigma));
      });
    });

    group('only constructor', () {
      test('creates Prop value from direct sigma', () {
        final attribute = BlurModifierMix(sigma: 7.0);

        expect(attribute.sigma!, resolvesTo(7.0));
      });

      test('creates Prop value from direct tileMode', () {
        final attribute = BlurModifierMix(tileMode: ui.TileMode.decal);

        expect(attribute.tileMode!, resolvesTo(ui.TileMode.decal));
      });

      test('handles null sigma correctly', () {
        final attribute = BlurModifierMix();

        expect(attribute.sigma, isNull);
      });
    });

    group('resolve', () {
      test('resolves to BlurModifier with resolved sigma', () {
        final attribute = BlurModifierMix(sigma: 7.0);

        const expectedModifier = BlurModifier(7.0);

        expect(attribute, resolvesTo(expectedModifier));
      });

      test('resolves with null sigma to default', () {
        final attribute = BlurModifierMix();

        const expectedModifier = BlurModifier(0.0);

        expect(attribute, resolvesTo(expectedModifier));
      });

      test('resolves tileMode', () {
        final attribute = BlurModifierMix(
          sigma: 7.0,
          tileMode: ui.TileMode.decal,
        );

        expect(
          attribute,
          resolvesTo(const BlurModifier(7.0, ui.TileMode.decal)),
        );
      });
    });

    group('merge', () {
      test('merges with other BlurModifierMix', () {
        final attribute1 = BlurModifierMix(sigma: 5.0);
        final attribute2 = BlurModifierMix(sigma: 8.0);

        final merged = attribute1.merge(attribute2);

        expect(merged.sigma!, resolvesTo(8.0));
      });

      test('returns original when other is null', () {
        final attribute = BlurModifierMix(sigma: 5.0);

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });

      test('merges with null sigma', () {
        final attribute1 = BlurModifierMix();
        final attribute2 = BlurModifierMix(sigma: 7.0);

        final merged = attribute1.merge(attribute2);

        expect(merged.sigma!, resolvesTo(7.0));
      });

      test('merges tileMode independently of sigma', () {
        final attribute1 = BlurModifierMix(
          sigma: 5.0,
          tileMode: ui.TileMode.decal,
        );
        final attribute2 = BlurModifierMix(sigma: 8.0);

        final merged = attribute1.merge(attribute2);

        expect(merged.sigma!, resolvesTo(8.0));
        expect(merged.tileMode!, resolvesTo(ui.TileMode.decal));
      });

      test('later tileMode overrides earlier tileMode', () {
        final attribute1 = BlurModifierMix(tileMode: ui.TileMode.decal);
        final attribute2 = BlurModifierMix(tileMode: ui.TileMode.mirror);

        final merged = attribute1.merge(attribute2);

        expect(merged.tileMode!, resolvesTo(ui.TileMode.mirror));
      });
    });

    group('equality and props', () {
      test('equal when sigma values match', () {
        final attribute1 = BlurModifierMix(sigma: 5.0);
        final attribute2 = BlurModifierMix(sigma: 5.0);

        expect(attribute1, equals(attribute2));
      });

      test('not equal when sigma differs', () {
        final attribute1 = BlurModifierMix(sigma: 5.0);
        final attribute2 = BlurModifierMix(sigma: 8.0);

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('not equal when tileMode differs', () {
        final attribute1 = BlurModifierMix(sigma: 5.0);
        final attribute2 = BlurModifierMix(
          sigma: 5.0,
          tileMode: ui.TileMode.decal,
        );

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('props contains Prop sigma and tileMode values', () {
        final attribute = BlurModifierMix(
          sigma: 5.0,
          tileMode: ui.TileMode.decal,
        );

        final props = attribute.props;
        expect(props.length, 2);
        expect(props[0], attribute.sigma);
        expect(props[1], attribute.tileMode);
      });
    });
  });

  group('Integration tests', () {
    testWidgets('BlurModifierMix resolves and builds correctly', (
      WidgetTester tester,
    ) async {
      final attribute = BlurModifierMix(sigma: 3.0);

      final modifier = attribute.resolve(MockBuildContext());
      const child = SizedBox(width: 100, height: 100);

      await tester.pumpWidget(modifier.build(child));

      expect(find.byType(ImageFiltered), findsOneWidget);
      final imageFiltered = tester.widget<ImageFiltered>(
        find.byType(ImageFiltered),
      );
      expect(imageFiltered.child, same(child));
    });

    test('Complex merge scenario preserves and overrides correctly', () {
      final base = BlurModifierMix(sigma: 5.0);
      final override1 = BlurModifierMix(sigma: 8.0);
      final override2 = BlurModifierMix(sigma: 2.0);

      final result = base.merge(override1).merge(override2);

      expect(result.sigma!, resolvesTo(2.0));
    });

    test('Lerp produces expected intermediate values', () {
      const start = BlurModifier(0.0);
      const end = BlurModifier(10.0);

      final quarter = start.lerp(end, 0.25);
      final half = start.lerp(end, 0.5);
      final threeQuarter = start.lerp(end, 0.75);

      expect(quarter.sigma, 2.5);
      expect(half.sigma, 5.0);
      expect(threeQuarter.sigma, 7.5);
    });
  });
}
