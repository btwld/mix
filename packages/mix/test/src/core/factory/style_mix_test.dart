import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
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
          styles: AttributeMap(
            [const MockSpecIntAttribute(200)],
          ),
        );

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

      utility.on.context((context) => testStyle);

      expect(utility.variants.length, 1);
      expect(utility.variants.values.first, isA<ContextVariantBuilder>());
    });

    testAddVariant(
      'should add hover variant correctly',
      variant: const OnHoverVariant(),
      action: (_, testStyle) {
        utility.on.hover(testStyle);
      },
    );

    testAddVariant(
      'should add disabled variant correctly',
      variant: const OnDisabledVariant(),
      action: (_, testStyle) {
        utility.on.disabled(testStyle);
      },
    );

    testAddVariant(
      'should add focus variant correctly',
      variant: const OnFocusedVariant(),
      action: (_, testStyle) {
        utility.on.focus(testStyle);
      },
    );

    testAddVariant(
      'should add selected variant correctly',
      variant: const OnSelectedVariant(),
      action: (_, testStyle) {
        utility.on.selected(testStyle);
      },
    );

    testAddVariant(
      'should add dragged variant correctly',
      variant: const OnDraggedVariant(),
      action: (_, testStyle) {
        utility.on.dragged(testStyle);
      },
    );

    testAddVariant(
      'should add error variant correctly',
      variant: const OnErrorVariant(),
      action: (_, testStyle) {
        utility.on.error(testStyle);
      },
    );

    testAddVariant(
      'should add pressed variant correctly',
      variant: const OnPressVariant(),
      action: (_, testStyle) {
        utility.on.pressed(testStyle);
      },
    );
  });
}

// Test implementation of StyleUtility for testing purposes
class _TestStyleUtility extends SpecUtility<SpecAttribute, SpecAttribute> {
  @override
  AttributeMap<SpecAttribute> styles =
      const AttributeMap<SpecAttribute>.empty();

  @override
  MockSpecIntAttribute only() {
    // TODO: implement only
    throw UnimplementedError();
  }

  _TestStyleUtility({
    this.styles = const AttributeMap<SpecAttribute>.empty(),
  }) : super((v) => v);

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
