import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  const attribute1 = MockDoubleScalarAttribute(1.0);
  const attribute2 = MockIntScalarAttribute(2);
  const attribute3 = MockBooleanScalarAttribute(true);
  const attribute4 = MockStringScalarAttribute('string1');
  const variantAttr1 = Variant('mock1');
  const variantAttr2 = Variant('mock2');
  group('Style()', () {
    test('Initialization with All Null Attributes', () {
      final mix = Style(null, null, null, null);
      expect(mix.styles.isEmpty, true);
      expect(mix.variants.isEmpty, true);
    });

    test('Initialization with Mixed Null and Non-Null Attributes', () {
      final mix = Style(null, attribute1, null);
      expect(mix.styles.length, 1);
      expect(mix.variants.isEmpty, true);
      expect(mix.styles.values[0], attribute1);
    });

    test('Initialization with All Non-Null ScalarAttributes', () {
      final mix = Style(attribute1, attribute2);
      expect(mix.styles.length, 2);
      expect(mix.variants.isEmpty, true);
    });

    test('Initialization with All Non-Null VariantAttributes', () {
      final mix = Style(variantAttr1(), variantAttr2());
      expect(mix.variants.length, 2);
      expect(mix.styles.isEmpty, true);
    });

    test('Initialization with Mixed Scalar and Variant Attributes', () {
      final mix = Style(attribute1, variantAttr1());
      expect(mix.styles.length, 1);
      expect(mix.variants.length, 1);
    });

    test('Initialization with many typse of attributes', () {
      final mix = Style(
        attribute1,
        attribute2,
        variantAttr1(),
        variantAttr2(),
      );
      expect(mix.styles.length, 2);
      expect(mix.styles.isEmpty, false);
      expect(mix.variants.length, 2);
      expect(mix.variants.isEmpty, false);
    });
  });

  group('Style.create([]) ', () {
    test('Initialization with Empty Array', () {
      final mix = Style.create([]);
      expect(mix.styles.isEmpty, true);
      expect(mix.variants.isEmpty, true);
    });

    test('Initialization with attributes', () {
      final attributes = [
        attribute1,
        attribute2,
        attribute3,
        attribute4,
        variantAttr1(),
      ];
      final mix = Style.create(attributes);
      expect(mix.styles.isEmpty, false);
      expect(mix.variants.isEmpty, false);
      expect(mix.styles.length, 4);
      expect(mix.variants.length, 1);
      expect(mix.length, 5);
    });

    test('Initialization with invalid attribute triggers assertion', () {
      final attributes = [
        attribute1,
        attribute2,
        attribute3,
        attribute4,
        const MockInvalidAttribute(),
      ];
      expect(() => Style.create(attributes), throwsFlutterError);
    });
  });

  group('Style.combine', () {
    test('should return a Style with all instances combined', () {
      final styleList = [
        Style(attribute1),
        Style(attribute2),
        Style(attribute3),
        Style(variantAttr1(attribute4)),
      ];

      final combinedStyle = Style.combine(styleList);

      // Expect that combinedStyle contains all attributes of style1, style2, and style3
      expect(combinedStyle.styles.length, 3);
      expect(combinedStyle.variants.length, 1);
      expect(combinedStyle.length, 4);

      expect(combinedStyle.values.contains(attribute1), true);
      expect(combinedStyle.values.contains(attribute2), true);
      expect(combinedStyle.values.contains(attribute3), true);
      expect(combinedStyle.values.contains(variantAttr1(attribute4)), true);
    });

    test('should return an empty Style when the list is empty', () {
      final combinedStyle = Style.combine([]);

      // Expect that combinedStyle is an empty Style instance
      expect(combinedStyle.isEmpty, true);
      expect(combinedStyle.isNotEmpty, false);
      expect(combinedStyle.styles.isEmpty, true);
      expect(combinedStyle.variants.isEmpty, true);

      expect(combinedStyle.length, 0);
    });
  });

  group('Style.variant', () {
    const attr1 = MockDoubleScalarAttribute(1.0);
    const attr2 = MockIntScalarAttribute(2);
    const attr3 = MockBooleanScalarAttribute(true);

    const variantAttr1 = Variant('variant1');

    test('with a Matched Variant', () {
      final style = Style(attr1, attr2, variantAttr1(attr3));
      final updatedStyle = style.applyVariant(variantAttr1);

      expect(updatedStyle.styles.length, 3);
      expect(updatedStyle.variants.length, 0);

      expect(style.styles.length, 2);
      expect(style.variants.length, 1);
    });

    test('with matching multi variant `and` ', () {
      final multiVariant = MultiVariant.and(const [variantAttr1, variantAttr2]);
      final style = Style(attr1, attr2, multiVariant(attr3));

      final a = style.applyVariant(variantAttr1);
      final b = a.applyVariant(variantAttr2);
      final c = style.applyVariant(variantAttr1, variantAttr2);

      expect(a.styles.length, 2);
      expect(a.variants.length, 1);

      expect(b.styles.length, 3);
      expect(b.variants.length, 0);

      expect(c.styles.length, 3);
      expect(c.variants.length, 0);

      expect(a, isNot(b));
      expect(c, b);
    });

    test('with matching multivariant `or` ', () {
      final multiVariant = MultiVariant.or(const [variantAttr1, variantAttr2]);
      final style = Style(attr1, attr2, multiVariant(attr3));

      final firstStyle = style.applyVariant(variantAttr1);
      final secondStyle = style.applyVariant(variantAttr2);
      final thirdStyle = style.applyVariant(variantAttr1, variantAttr2);

      $with.scale(1);

      expect(firstStyle.styles.length, 3);
      expect(firstStyle.variants.length, 0);

      expect(secondStyle.styles.length, 3);
      expect(secondStyle.variants.length, 0);

      expect(thirdStyle.styles.length, 3);
      expect(thirdStyle.variants.length, 0);

      expect(secondStyle, firstStyle);
      expect(secondStyle, thirdStyle);
    });

    test('with matching complex multivariant `or` ', () {
      const variantAttr3 = Variant('variantAttr3');

      final multiVariant = MultiVariant.and([
        variantAttr3,
        MultiVariant.or(const [variantAttr1, variantAttr2]),
      ]);

      final style = Style(attr1, attr2, multiVariant(attr3));

      final a = style.applyVariant(variantAttr1);

      expect(a.styles.length, 2);
      expect(a.variants.length, 1);

      final b = style.applyVariant(variantAttr2);

      expect(b.styles.length, 2);
      expect(b.variants.length, 1);

      final c = style.applyVariant(variantAttr3);

      expect(c.styles.length, 2);
      expect(c.variants.length, 1);

      final d = style.applyVariant(variantAttr1, variantAttr2);

      expect(d.styles.length, 2);
      expect(d.variants.length, 1);

      final e = style.applyVariant(variantAttr1, variantAttr3);

      expect(e.styles.length, 3);
      expect(e.variants.length, 0);

      final f = style.applyVariant(variantAttr2, variantAttr3);

      expect(f.styles.length, 3);
      expect(f.variants.length, 0);
    });

    test('with an Unmatched Variant', () {
      final style = Style(attr1, attr2);
      final updatedStyle = style.applyVariant(variantAttr1);

      expect(updatedStyle, style);
    });
  });

  group('Style.priority', () {
    const attr1 = MockBooleanScalarAttribute(true);
    const attr2 = MockDoubleScalarAttribute(1.0);

    const variantLow = MockContextVariantCondition(
      true,
      priority: VariantPriority.low,
    );

    const variantNormal = MockContextVariantCondition(
      true,
      priority: VariantPriority.normal,
    );

    const variantHigh = MockContextVariantCondition(
      true,
      priority: VariantPriority.high,
    );

    void testPriorityOrder({
      required ContextVariant first,
      required ContextVariant second,
      required ContextVariant third,
      required String expectedValue,
    }) {
      final whichItemIsHigh = [variantLow, variantNormal, variantHigh]
              .indexWhere((e) => e.priority == VariantPriority.high) -
          1;
      final reason = '$whichItemIsHigh should return $expectedValue';
      final style = applyContextToVisualAttributes(
        MockBuildContext(),
        Style(
          attr1,
          attr2,
          first(
            const MockStringScalarAttribute('first'),
          ),
          second(
            const MockStringScalarAttribute('second'),
          ),
          third(
            const MockStringScalarAttribute('third'),
          ),
        ),
      );

      expect(style.length, 3, reason: reason);

      final attribute =
          style.firstWhere((element) => element is MockStringScalarAttribute)
              as MockStringScalarAttribute;

      expect(attribute.value, expectedValue, reason: reason);
    }

    test('testing all priorities', () {
      testPriorityOrder(
        first: variantLow,
        second: variantNormal,
        third: variantHigh,
        expectedValue: 'third',
      );

      testPriorityOrder(
        first: variantLow,
        second: variantHigh,
        third: variantNormal,
        expectedValue: 'second',
      );

      testPriorityOrder(
        first: variantNormal,
        second: variantHigh,
        third: variantLow,
        expectedValue: 'second',
      );

      testPriorityOrder(
        first: variantNormal,
        second: variantLow,
        third: variantHigh,
        expectedValue: 'third',
      );

      testPriorityOrder(
        first: variantHigh,
        second: variantLow,
        third: variantNormal,
        expectedValue: 'first',
      );

      testPriorityOrder(
        first: variantHigh,
        second: variantNormal,
        third: variantLow,
        expectedValue: 'first',
      );
    });
  });

  group('Style.variantList', () {
    const attr1 = MockDoubleScalarAttribute(1.0);
    const attr2 = MockIntScalarAttribute(2);
    const attr3 = MockBooleanScalarAttribute(true);

    const variantAttr1 = Variant('variant1');
    const variantAttr2 = Variant('variant2');

    test('with Matched Variants', () {
      final style = Style(attr1, variantAttr1(attr2), variantAttr2(attr3));
      final updatedStyle = style.applyVariants([variantAttr1, variantAttr2]);

      expect(style.styles.length, 1);
      expect(style.variants.length, 2);
      expect(updatedStyle.styles.length, 3);
      expect(updatedStyle.variants.length, 0);
    });

    test('with matching multi variant', () {
      final multiVariant = MultiVariant.and(const [variantAttr1, variantAttr2]);
      final style = Style(attr1, attr2, multiVariant(attr3));
      final thirdStyle = style.applyVariants([variantAttr1, variantAttr2]);

      expect(thirdStyle.styles.length, 3);
      expect(thirdStyle.variants.length, 0);
    });

    test('with Unmatched Variants', () {
      final mix = Style(attr1);
      final updatedMix = mix.applyVariants([variantAttr1, variantAttr2]);

      expect(updatedMix, mix);
    });

    test('with Empty List', () {
      final mix = Style(attr1, attr2);
      final updatedMix = mix.applyVariants([]);

      expect(updatedMix, mix);
    });

    test(
      'should return the same value if the parameter don`t satisfy the logic expression with 3 variants combined with `and` operator',
      () {
        const variantAttr3 = Variant('variantAttr3');

        final style = Style(
          $box.color.red(),
          (variantAttr1 & variantAttr2 & variantAttr3)($icon.color.black()),
        );

        final a = style.applyVariants([variantAttr1]);
        final b = style.applyVariants([variantAttr3]);
        final c = style.applyVariants([variantAttr1]);
        final d = style.applyVariants([variantAttr2, variantAttr3]);
        final e = style.applyVariants([variantAttr1, variantAttr3]);
        final f = style.applyVariants([variantAttr2, variantAttr1]);

        final ab = a.applyVariants([variantAttr3]);
        final ba = b.applyVariants([variantAttr1]);

        expect(ab, ba);
        expect(a, c);
        expect(a, isNot(d));
        expect(a.styles, d.styles);
        expect(a, isNot(e));
        expect(a.styles, e.styles);
        expect(a, isNot(f));
        expect(a.styles, f.styles);
      },
    );

    test(
      'should return the same value if the parameter don`t satisfy the logic expression with 3 variants combined with `or` operator',
      () {
        const variantAttr3 = Variant('variantAttr3');

        const extraVariant1 = Variant('extraVariant1');
        const extraVariant2 = Variant('extraVariant2');

        final style = Style(
          $box.color.red(),
          (variantAttr1 | variantAttr2 | variantAttr3)($icon.color.black()),
        );

        final a = style.applyVariants([extraVariant1]);
        final b = style.applyVariants([extraVariant2]);
        final c = style.applyVariants([extraVariant1, extraVariant2]);

        expect(a, equals(b), reason: 'a and b');
        expect(a, equals(c), reason: 'a and c');
      },
    );
  });

  group('Style.pickVariants', () {
    const attr1 = MockDoubleScalarAttribute(1.0);
    const attr2 = MockIntScalarAttribute(2);

    const stringAttr1 = MockStringScalarAttribute('string1');
    const stringAttr2 = MockStringScalarAttribute('string2');
    const stringAttr3 = MockStringScalarAttribute('string3');

    const outlinedVariant = Variant('outlined');
    const smallVariant = Variant('small');

    test('Picks specified Variants and ignores others', () {
      final style = Style(
        attr1,
        attr2,
        outlinedVariant(stringAttr1, stringAttr2),
        smallVariant(stringAttr3),
      );
      final pickedMix = style.pickVariants([outlinedVariant, smallVariant]);

      expect(pickedMix.styles.containsType(stringAttr1), isTrue);
      expect(pickedMix.styles.containsType(stringAttr2), isTrue);
      expect(pickedMix.styles.containsType(stringAttr3), isTrue);
      expect(pickedMix.styles.containsType(attr1), isFalse);
      expect(pickedMix.styles.containsType(attr2), isFalse);
      expect(pickedMix.variants.isEmpty, isTrue);
    });

    test('Returns empty Style when no Variants are picked', () {
      final style = Style(attr1, attr2);
      final pickedMix = style.pickVariants([]);

      expect(pickedMix.styles.isEmpty, isTrue);
      expect(pickedMix.variants.isEmpty, isTrue);
    });

    test('Returns empty Style when picked Variants are not present', () {
      final style = Style(attr1, attr2); // no variants added here
      final pickedMix = style.pickVariants([outlinedVariant, smallVariant]);

      expect(pickedMix.styles.isEmpty, isTrue);
      expect(pickedMix.variants.isEmpty, isTrue);
    });
  });

  group('Style hashcode', () {
    test('should return different hashcode for same attributes', () {
      final style1 = Style(attribute1, attribute2);
      final style2 = Style(attribute1, attribute2);

      expect(style1.hashCode, equals(style2.hashCode));
    });

    test('should return different hashcode for different attributes', () {
      final style1 = Style(attribute1, attribute2);
      final style2 = Style(attribute1, attribute3);

      expect(style1.hashCode, isNot(style2.hashCode));
    });
  });

  group('Style equality', () {
    test('should return true for same attributes', () {
      final style1 = Style(attribute1, attribute2);
      final style2 = Style(attribute1, attribute2);

      expect(style1, style2);
    });

    test('should return false for different attributes', () {
      final style1 = Style(attribute1, attribute2);
      final style2 = Style(attribute1, attribute3);

      expect(style1, isNot(style2));
    });
  });

  group('AnimatedStyle applyVariants', () {
    test(
        'when a variant is applied an AnimatedStyle continues an AnimatedStyle',
        () {
      final style = AnimatedStyle(
        Style(
          attribute1,
          attribute2,
        ),
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 200),
      );

      expect(style.isAnimated, true);

      final updatedStyle = style.applyVariants([variantAttr1]);

      expect(updatedStyle.isAnimated, true);
    });
  });

  group('Nested Style', () {
    test(
        'merging a nested empty style should not alter the parent style attributes',
        () {
      final sut = Style(
        attribute1,
        Style(null),
      );

      final expectedStyle = Style(
        attribute1,
      );

      expect(sut, expectedStyle);
    });

    test('should merge with the attributes in parent style', () {
      final sut = Style(
        attribute1,
        Style(attribute2),
      );

      final expectedStyle = Style(
        attribute1,
        attribute2,
      );

      expect(sut, expectedStyle);
    });
  });

  group('Style.merge', () {
    test('Style + AnimatedStyle', () {
      const animatedData = AnimationConfig(
        curve: Curves.linear,
        duration: Durations.medium1,
      );

      final style = Style(
        attribute1,
        Style(attribute2),
      );

      final animatedStyle = AnimatedStyle(
        Style(),
        duration: animatedData.duration,
        curve: animatedData.curve,
      );

      final result = style.merge(animatedStyle);

      expect(result, isA<AnimatedStyle>());
      expect((result as AnimatedStyle).animated, animatedData);
    });

    test('AnimatedStyle + Style', () {
      const animatedData = AnimationConfig(
        curve: Curves.linear,
        duration: Durations.medium1,
      );

      final animatedStyle = AnimatedStyle(
        Style(),
        duration: animatedData.duration,
        curve: animatedData.curve,
      );

      final style = Style(
        attribute1,
        Style(attribute2),
      );

      final result = animatedStyle.merge(style);

      expect(result, isA<AnimatedStyle>());
      expect((result as AnimatedStyle).animated, animatedData);
    });
  });
}
