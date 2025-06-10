import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

// Helper to create ComputedStyle from Style
ComputedStyle _computeStyle(Style style) {
  final mixData = MixData.create(MockBuildContext(), style);

  return ComputedStyle.compute(mixData);
}

void main() {
  group('ComputedStyle', () {
    group('Construction', () {
      test('empty() creates empty ComputedStyle', () {
        const computedStyle = ComputedStyle.empty();

        expect(computedStyle.getSpec<BoxSpec>(), isNull);
        expect(computedStyle.getSpec<TextSpec>(), isNull);
        expect(computedStyle.modifiers, isEmpty);
        expect(computedStyle.animation, isNull);
        expect(computedStyle.isAnimated, isFalse);
        expect(computedStyle.debugSpecs, isEmpty);
      });

      test('empty ComputedStyles are equal', () {
        const style1 = ComputedStyle.empty();
        const style2 = ComputedStyle.empty();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });
    });

    group('Spec Resolution', () {
      test('compute() resolves single spec attribute', () {
        final computedStyle = _computeStyle(Style($box.color(Colors.red)));

        final spec = computedStyle.getSpec<BoxSpec>();
        expect(spec, isNotNull);
        expect((spec!.decoration as BoxDecoration?)?.color, Colors.red);
      });

      test('compute() merges multiple attributes of same type', () {
        final computedStyle = _computeStyle(Style(
          $box.color(Colors.blue),
          $box.padding(16),
        ));

        final spec = computedStyle.getSpec<BoxSpec>();
        expect(spec, isNotNull);
        expect((spec!.decoration as BoxDecoration?)?.color, Colors.blue);
        expect(spec.padding, const EdgeInsets.all(16));
      });

      test('compute() resolves multiple spec types', () {
        final computedStyle = _computeStyle(Style(
          $box.color(Colors.red),
          $text.style.fontSize(14),
          $icon.size(24),
        ));

        expect(computedStyle.getSpec<BoxSpec>(), isNotNull);
        expect(computedStyle.getSpec<TextSpec>(), isNotNull);
        expect(computedStyle.getSpec<IconSpec>(), isNotNull);
      });

      test('compute() separates modifiers from specs', () {
        final computedStyle = _computeStyle(Style(
          $box.color(Colors.blue),
          $with.scale(2.0),
          $with.opacity(0.5),
        ));

        expect(computedStyle.getSpec<BoxSpec>(), isNotNull);
        expect(computedStyle.modifiers.length, 2);
      });

      test('compute() preserves animation data', () {
        final computedStyle = _computeStyle(
          Style($box.color(Colors.red)).animate(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          ),
        );

        expect(computedStyle.isAnimated, isTrue);
        expect(
          computedStyle.animation?.duration,
          const Duration(milliseconds: 300),
        );
        expect(computedStyle.animation?.curve, Curves.easeIn);
      });
    });

    group('Spec Access', () {
      test('getSpec() returns correct spec type', () {
        final computedStyle = _computeStyle(Style(
          $box.color(Colors.blue),
          $text.style.fontSize(16),
        ));

        expect(computedStyle.getSpec<BoxSpec>(), isA<BoxSpec>());
        expect(computedStyle.getSpec<TextSpec>(), isA<TextSpec>());
        expect(computedStyle.getSpec<IconSpec>(), isNull);
      });

      test('specOfType() returns spec by runtime type', () {
        final computedStyle = _computeStyle(Style($box.color(Colors.green)));

        expect(computedStyle.specOfType(BoxSpec), isA<BoxSpec>());
        expect(computedStyle.specOfType(IconSpec), isNull);
      });

      test('debugSpecs provides unmodifiable map', () {
        final computedStyle = _computeStyle(Style(
          $box.color(Colors.red),
          $text.style.fontSize(14),
        ));

        final debugSpecs = computedStyle.debugSpecs;
        expect(debugSpecs.length, 2);
        expect(debugSpecs.containsKey(BoxSpec), isTrue);
        expect(debugSpecs.containsKey(TextSpec), isTrue);

        // Verify it's unmodifiable
        expect(
          () => debugSpecs[BoxSpec] = const BoxSpec(),
          throwsUnsupportedError,
        );
      });
    });

    group('Equality and Hashing', () {
      test('equal ComputedStyles have same hashCode', () {
        final style = Style($box.color(Colors.red));
        final computedStyle1 = _computeStyle(style);
        final computedStyle2 = _computeStyle(style);

        expect(computedStyle1, equals(computedStyle2));
        expect(computedStyle1.hashCode, equals(computedStyle2.hashCode));
      });

      test('different content creates different ComputedStyles', () {
        final computedStyle1 = _computeStyle(Style($box.color(Colors.red)));
        final computedStyle2 = _computeStyle(Style($box.color(Colors.blue)));
        final computedStyle3 = _computeStyle(Style(
          $box.color(Colors.red),
          $with.scale(2.0),
        ));
        final computedStyle4 = _computeStyle(
          Style($box.color(Colors.red)).animate(
            duration: const Duration(seconds: 1),
          ),
        );

        expect(computedStyle1, isNot(equals(computedStyle2)));
        expect(computedStyle1, isNot(equals(computedStyle3)));
        expect(computedStyle1, isNot(equals(computedStyle4)));
      });
    });

    group('Edge Cases', () {
      test('handles empty style', () {
        final computedStyle = _computeStyle(Style());

        expect(computedStyle.debugSpecs, isEmpty);
        expect(computedStyle.modifiers, isEmpty);
        expect(computedStyle.animation, isNull);
        expect(computedStyle.isAnimated, isFalse);
      });

      test('handles style with only modifiers', () {
        final computedStyle =
            _computeStyle(Style($with.scale(2.0), $with.opacity(0.5)));

        expect(computedStyle.debugSpecs, isEmpty);
        expect(computedStyle.modifiers.length, 2);
        expect(computedStyle.animation, isNull);
      });

      test('handles style with only animation', () {
        final computedStyle = _computeStyle(
          Style().animate(duration: const Duration(seconds: 1)),
        );

        expect(computedStyle.debugSpecs, isEmpty);
        expect(computedStyle.modifiers, isEmpty);
        expect(computedStyle.isAnimated, isTrue);
        expect(computedStyle.animation?.duration, const Duration(seconds: 1));
      });
    });
  });
}
