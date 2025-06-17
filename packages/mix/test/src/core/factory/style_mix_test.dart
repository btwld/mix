import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

class _MockBaseStyle extends StyleUtility<SpecAttribute> {
  _MockBaseStyle({
    this.styles = const AttributeMap.empty(),
    this.variants = const AttributeMap.empty(),
  });

  @override
  StyleElement merge(covariant StyleElement? other) {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [styles, variants];

  @override
  final AttributeMap<SpecAttribute> styles;

  @override
  final AttributeMap<VariantAttribute<IVariant>> variants;
}

void main() {
  group('Style.from()', () {
    test('should create Style from StyleUtility implementation', () {
      const attribute = MockDoubleScalarAttribute(42.0);
      final baseStyle = _MockBaseStyle(styles: AttributeMap([attribute]));

      final result = Style.from(baseStyle);

      expect(result, isA<Style>());
      expect(result.styles.length, 1);
      expect(result.styles.values.first, equals(attribute));
      expect(result.variants.isEmpty, isTrue);
    });

    test('should create Style from BaseStyle with variants', () {
      const variant = Variant('test');
      const variantAttribute = VariantAttribute(variant, Style.empty());
      final baseStyle =
          _MockBaseStyle(variants: AttributeMap([variantAttribute]));

      final result = Style.from(baseStyle);

      expect(result, isA<Style>());
      expect(result.styles.isEmpty, isTrue);
      expect(result.variants.length, 1);
      expect(result.variants.values.first, equals(variantAttribute));
    });

    test('should create Style from BaseStyle with both styles and variants',
        () {
      const attribute = MockDoubleScalarAttribute(3.14);
      const variant = Variant('mixed');
      const variantAttribute = VariantAttribute(variant, Style.empty());

      final baseStyle = _MockBaseStyle(
        styles: AttributeMap([attribute]),
        variants: AttributeMap([variantAttribute]),
      );

      final result = Style.from(baseStyle);

      expect(result, isA<Style>());
      expect(result.styles.length, 1);
      expect(result.variants.length, 1);
      expect(result.styles.values.first, equals(attribute));
      expect(result.variants.values.first, equals(variantAttribute));
    });

    test('should return same instance when input is already a Style', () {
      const attribute = MockDoubleScalarAttribute(99.0);
      final originalStyle = Style(attribute);

      final result = Style.from(originalStyle);

      expect(result, same(originalStyle));
    });

    test('should return same instance when input is already a AnimatedStyle',
        () {
      const attribute = MockDoubleScalarAttribute(99.0);
      final originalStyle = AnimatedStyle(
        Style(attribute),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      final result = Style.from(originalStyle);

      expect(result, same(originalStyle));
    });

    test('should handle empty BaseStyle', () {
      final baseStyle = _MockBaseStyle();

      final result = Style.from(baseStyle);

      expect(result, isA<Style>());
      expect(result.styles.isEmpty, isTrue);
      expect(result.variants.isEmpty, isTrue);
      expect(result, equals(const Style.empty()));
    });

    test('should preserve complex attribute structures', () {
      const attribute1 = MockDoubleScalarAttribute(1.0);
      const attribute2 = MockIntScalarAttribute(2);
      const attribute3 = MockBooleanScalarAttribute(true);

      final baseStyle = _MockBaseStyle(
        styles: AttributeMap([attribute1, attribute2, attribute3]),
      );

      final result = Style.from(baseStyle);

      expect(result.styles.length, 3);
      expect(result.styles.values.contains(attribute1), isTrue);
      expect(result.styles.values.contains(attribute2), isTrue);
      expect(result.styles.values.contains(attribute3), isTrue);
    });

    test('should preserve complex variant structures', () {
      const variant1 = Variant('v1');
      const variant2 = Variant('v2');
      final variantAttr1 = VariantAttribute(
          variant1, Style(const MockDoubleScalarAttribute(1.0)));
      final variantAttr2 =
          VariantAttribute(variant2, Style(const MockIntScalarAttribute(2)));

      final baseStyle = _MockBaseStyle(
        variants: AttributeMap([variantAttr1, variantAttr2]),
      );

      final result = Style.from(baseStyle);

      expect(result.variants.length, 2);
      expect(result.variants.values.contains(variantAttr1), isTrue);
      expect(result.variants.values.contains(variantAttr2), isTrue);
    });
  });
  group('StyleUtility', () {
    late _TestStyleUtility utility;

    setUp(() {
      utility = _TestStyleUtility();
    });

    @isTest
    void testAddVariant<T extends IVariant>(String description,
        {required T variant,
        required void Function(T, _TestStyleUtility) action}) {
      test(description, () {
        final testStyle = _TestStyleUtility(
            styles: AttributeMap([const MockSpecIntAttribute(200)]));

        action(variant, testStyle);

        expect(utility.variants.length, 1);
        expect(utility.variants.values.first.variant, equals(variant));
        expect(utility.variants.values.first.value.styles,
            equals(testStyle.styles));
      });
    }

    testAddVariant(
      'should add variants correctly',
      variant: const Variant('test'),
      action: (variant, testStyle) {
        utility.variant(variant, testStyle);
      },
    );

    test('should add context-dependent styles correctly', () {
      final testStyle = _TestStyleUtility(
          styles: AttributeMap([const MockSpecIntAttribute(300)]));

      utility.onContext((context) => testStyle);

      expect(utility.variants.length, 1);
      expect(utility.variants.values.first, isA<ContextVariantBuilder>());
    });

    testAddVariant(
      'should add hover variant correctly',
      variant: const OnHoverVariant(),
      action: (_, testStyle) {
        utility.onHover(testStyle);
      },
    );

    testAddVariant(
      'should add disabled variant correctly',
      variant: const OnDisabledVariant(),
      action: (_, testStyle) {
        utility.onDisabled(testStyle);
      },
    );

    testAddVariant(
      'should add focus variant correctly',
      variant: const OnFocusedVariant(),
      action: (_, testStyle) {
        utility.onFocus(testStyle);
      },
    );

    testAddVariant(
      'should add selected variant correctly',
      variant: const OnSelectedVariant(),
      action: (_, testStyle) {
        utility.onSelected(testStyle);
      },
    );

    testAddVariant(
      'should add dragged variant correctly',
      variant: const OnDraggedVariant(),
      action: (_, testStyle) {
        utility.onDragged(testStyle);
      },
    );

    testAddVariant(
      'should add error variant correctly',
      variant: const OnErrorVariant(),
      action: (_, testStyle) {
        utility.onError(testStyle);
      },
    );

    testAddVariant(
      'should add pressed variant correctly',
      variant: const OnPressVariant(),
      action: (_, testStyle) {
        utility.onPressed(testStyle);
      },
    );
  });
}

// Test implementation of StyleUtility for testing purposes
class _TestStyleUtility extends StyleUtility<MockSpecIntAttribute> {
  @override
  AttributeMap<MockSpecIntAttribute> styles =
      const AttributeMap<MockSpecIntAttribute>.empty();

  @override
  AttributeMap<VariantAttribute> variants = const AttributeMap.empty();

  _TestStyleUtility({
    this.styles = const AttributeMap.empty(),
    this.variants = const AttributeMap.empty(),
  });

  MockSpecIntAttribute value(int v) {
    final attribute = MockSpecIntAttribute(v);
    styles = styles.merge(AttributeMap([attribute]));
    return attribute;
  }

  @override
  _TestStyleUtility merge(_TestStyleUtility other) {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [styles, variants];
}

class _MockContextVariant extends ContextVariant {
  const _MockContextVariant();

  @override
  bool when(BuildContext context) => true;
}
