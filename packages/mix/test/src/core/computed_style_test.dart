import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/mock_build_context.dart';

void main() {
  group('ComputedStyle', () {
    group('Core functionality', () {
      test('empty constructor creates empty ComputedStyle', () {
        const computedStyle = ComputedStyle.empty();

        expect(computedStyle.getSpec<BoxSpec>(), isNull);
        expect(computedStyle.getSpec<TextSpec>(), isNull);
        expect(computedStyle.getSpec<IconSpec>(), isNull);
        expect(computedStyle.modifiers, isEmpty);
        expect(computedStyle.animation, isNull);
        expect(computedStyle.isAnimated, isFalse);
      });

      test('compute resolves all spec attributes from MixData', () {
        final style = Style(
          $box.color(const Color(0xFF000000)),
          $box.padding(16),
          $text.style.fontSize(16),
          $icon.size(24),
        );

        final mixData = MixData.create(MockBuildContext(), style);
        final computedStyle = ComputedStyle.compute(mixData);

        // Verify all specs are resolved
        expect(computedStyle.getSpec<BoxSpec>(), isNotNull);
        expect(computedStyle.getSpec<TextSpec>(), isNotNull);
        expect(computedStyle.getSpec<IconSpec>(), isNotNull);

        // Verify specific values
        final boxSpec = computedStyle.getSpec<BoxSpec>()!;
        expect(boxSpec.padding, const EdgeInsets.all(16));
        expect((boxSpec.decoration as BoxDecoration?)?.color,
            const Color(0xFF000000));

        final textSpec = computedStyle.getSpec<TextSpec>()!;
        expect(textSpec.style?.fontSize, 16);

        final iconSpec = computedStyle.getSpec<IconSpec>()!;
        expect(iconSpec.size, 24);
      });

      test('handles merged MixData correctly', () {
        final style1 = Style(
          $box.color(const Color(0xFF000000)),
          $box.padding(16),
        );

        final style2 = Style(
          $box.margin(8),
          $text.style.fontSize(16),
        );

        final mixData1 = MixData.create(MockBuildContext(), style1);
        final mixData2 = MixData.create(MockBuildContext(), style2);
        final mergedMixData = mixData1.merge(mixData2);

        final computedStyle = ComputedStyle.compute(mergedMixData);

        // Should have both BoxSpec and TextSpec
        final boxSpec = computedStyle.getSpec<BoxSpec>()!;
        expect(boxSpec.padding, const EdgeInsets.all(16));
        expect(boxSpec.margin, const EdgeInsets.all(8));

        final textSpec = computedStyle.getSpec<TextSpec>()!;
        expect(textSpec.style?.fontSize, 16);
      });

      test('handles animated styles', () {
        final style = Style(
          $box.color(const Color(0xFF000000)),
        ).animate(duration: const Duration(seconds: 1));

        final mixData = MixData.create(MockBuildContext(), style);
        final computedStyle = ComputedStyle.compute(mixData);

        expect(computedStyle.isAnimated, isTrue);
        expect(computedStyle.animation, isNotNull);
        expect(computedStyle.animation!.duration, const Duration(seconds: 1));
      });

      test('handles modifiers correctly', () {
        final style = Style(
          $box.color(const Color(0xFF000000)),
          $with.scale(2.0),
          $with.opacity(0.5),
        );

        final mixData = MixData.create(MockBuildContext(), style);
        final computedStyle = ComputedStyle.compute(mixData);

        expect(computedStyle.modifiers.length, 2);
      });

      test('equality and hashCode', () {
        final style = Style(
          $box.color(const Color(0xFF000000)),
          $text.style.fontSize(16),
        );

        final mixData = MixData.create(MockBuildContext(), style);
        final computedStyle1 = ComputedStyle.compute(mixData);
        final computedStyle2 = ComputedStyle.compute(mixData);

        // Same content should be equal
        expect(computedStyle1, equals(computedStyle2));
        expect(computedStyle1.hashCode, equals(computedStyle2.hashCode));

        // Different content should not be equal
        final differentStyle = Style($box.color(const Color(0xFFFF0000)));
        final differentMixData =
            MixData.create(MockBuildContext(), differentStyle);
        final computedStyle3 = ComputedStyle.compute(differentMixData);

        expect(computedStyle1, isNot(equals(computedStyle3)));
      });

      test('debugSpecs provides read-only access', () {
        final style = Style(
          $box.color(const Color(0xFF000000)),
          $text.style.fontSize(16),
          $icon.size(24),
        );

        final mixData = MixData.create(MockBuildContext(), style);
        final computedStyle = ComputedStyle.compute(mixData);

        final debugSpecs = computedStyle.debugSpecs;

        // Verify all specs are visible
        expect(debugSpecs.length, 3);
        expect(debugSpecs.containsKey(BoxSpec), isTrue);
        expect(debugSpecs.containsKey(TextSpec), isTrue);
        expect(debugSpecs.containsKey(IconSpec), isTrue);

        // Verify it's unmodifiable
        expect(
          () => debugSpecs[BoxSpec] = const BoxSpec(),
          throwsUnsupportedError,
        );
      });

      test('specOfType works correctly', () {
        final style = Style(
          $box.color(const Color(0xFF000000)),
          $text.style.fontSize(16),
        );

        final mixData = MixData.create(MockBuildContext(), style);
        final computedStyle = ComputedStyle.compute(mixData);

        // Test internal specOfType method
        expect(computedStyle.specOfType(BoxSpec), isA<BoxSpec>());
        expect(computedStyle.specOfType(TextSpec), isA<TextSpec>());
        expect(computedStyle.specOfType(IconSpec), isNull);
      });
    });
  });
}
