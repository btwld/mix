import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('MultiVariant', () {
    group('Factory constructors', () {
      test('MultiVariant.and creates AND variant with correct properties', () {
        const variants = [NamedVariant('primary'), NamedVariant('large')];
        final multiVariant = MultiVariant.and(variants);

        expect(multiVariant.operatorType, MultiVariantOperator.and);
        expect(multiVariant.variants.length, 2);
        expect(multiVariant.variants, contains(const NamedVariant('primary')));
        expect(multiVariant.variants, contains(const NamedVariant('large')));
      });

      test('MultiVariant.or creates OR variant with correct properties', () {
        const variants = [NamedVariant('primary'), NamedVariant('secondary')];
        final multiVariant = MultiVariant.or(variants);

        expect(multiVariant.operatorType, MultiVariantOperator.or);
        expect(multiVariant.variants.length, 2);
        expect(multiVariant.variants, contains(const NamedVariant('primary')));
        expect(
          multiVariant.variants,
          contains(const NamedVariant('secondary')),
        );
      });

      test('MultiVariant.not creates NOT variant with single variant', () {
        const variant = NamedVariant('disabled');
        final multiVariant = MultiVariant.not(variant);

        expect(multiVariant.operatorType, MultiVariantOperator.not);
        expect(multiVariant.variants.length, 1);
        expect(multiVariant.variants.first, const NamedVariant('disabled'));
      });

      test(
        'MultiVariant generic constructor creates variant with specified type',
        () {
          const variants = [NamedVariant('primary'), NamedVariant('large')];
          final multiVariant = MultiVariant(
            variants,
            type: MultiVariantOperator.or,
          );

          expect(multiVariant.operatorType, MultiVariantOperator.or);
          expect(multiVariant.variants.length, 2);
          expect(
            multiVariant.variants,
            contains(const NamedVariant('primary')),
          );
          expect(multiVariant.variants, contains(const NamedVariant('large')));
        },
      );
    });

    group('Variant flattening and optimization', () {
      test('flattens nested MultiVariants of same type', () {
        // Create nested AND variants
        final inner1 = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);

        final inner2 = MultiVariant.and(const [
          NamedVariant('outlined'),
          NamedVariant('rounded'),
        ]);

        // Create outer AND variant containing inner AND variants
        final outer = MultiVariant.and([inner1, inner2]);

        // Should flatten to a single AND with all 4 variants
        expect(outer.operatorType, MultiVariantOperator.and);
        expect(outer.variants.length, 4);
        expect(outer.variants, contains(const NamedVariant('primary')));
        expect(outer.variants, contains(const NamedVariant('large')));
        expect(outer.variants, contains(const NamedVariant('outlined')));
        expect(outer.variants, contains(const NamedVariant('rounded')));
      });

      test('preserves nested MultiVariants of different types', () {
        // Create AND variant
        final andVariant = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);

        // Create OR variant containing the AND variant
        final orVariant = MultiVariant.or([
          andVariant,
          const NamedVariant('secondary'),
        ]);

        // Should preserve the nested structure since types differ
        expect(orVariant.operatorType, MultiVariantOperator.or);
        expect(orVariant.variants.length, 2);
        expect(orVariant.variants, contains(andVariant));
        expect(orVariant.variants, contains(const NamedVariant('secondary')));
      });

      test('flattens mixed individual and MultiVariant of same type', () {
        final innerAnd = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);

        final outerAnd = MultiVariant.and([
          innerAnd,
          const NamedVariant('outlined'),
          const NamedVariant('rounded'),
        ]);

        // Should flatten to single AND with all variants
        expect(outerAnd.operatorType, MultiVariantOperator.and);
        expect(outerAnd.variants.length, 4);
        expect(outerAnd.variants, contains(const NamedVariant('primary')));
        expect(outerAnd.variants, contains(const NamedVariant('large')));
        expect(outerAnd.variants, contains(const NamedVariant('outlined')));
        expect(outerAnd.variants, contains(const NamedVariant('rounded')));
      });
    });

    group('when method - condition evaluation', () {
      group('AND logic', () {
        test('returns true when all ContextVariants match', () {
          final context = MockBuildContext();

          // Create mock ContextVariants with controlled conditions
          final trueVariant1 = ContextVariant('test1', (context) => true);
          final trueVariant2 = ContextVariant('test2', (context) => true);

          final variant = MultiVariant.and([trueVariant1, trueVariant2]);

          expect(variant.when(context), isTrue);
        });

        test('returns false when any ContextVariant does not match', () {
          final context = MockBuildContext();

          // Create mock ContextVariants - one true, one false
          final trueVariant = ContextVariant('test1', (context) => true);
          final falseVariant = ContextVariant('test2', (context) => false);

          final variant = MultiVariant.and([trueVariant, falseVariant]);

          expect(variant.when(context), isFalse);
        });

        test('returns false when contains NamedVariants', () {
          final context = MockBuildContext();

          final variant = MultiVariant.and([
            const NamedVariant('primary'), // NamedVariants never match context
            ContextVariant('test', (context) => true),
          ]);

          expect(variant.when(context), isFalse);
        });
      });

      group('OR logic', () {
        test('returns true when any ContextVariant matches', () {
          final context = MockBuildContext();

          // Create mock ContextVariants - one false, one true
          final falseVariant = ContextVariant('test1', (context) => false);
          final trueVariant = ContextVariant('test2', (context) => true);

          final variant = MultiVariant.or([falseVariant, trueVariant]);

          expect(variant.when(context), isTrue);
        });

        test('returns false when no ContextVariants match', () {
          final context = MockBuildContext();

          // Create mock ContextVariants that both return false
          final falseVariant1 = ContextVariant('test1', (context) => false);
          final falseVariant2 = ContextVariant('test2', (context) => false);

          final variant = MultiVariant.or([falseVariant1, falseVariant2]);

          expect(variant.when(context), isFalse);
        });

        test('returns false when contains only NamedVariants', () {
          final context = MockBuildContext();

          final variant = MultiVariant.or(const [
            NamedVariant('primary'),
            NamedVariant('secondary'),
          ]);

          expect(variant.when(context), isFalse);
        });
      });

      group('NOT logic', () {
        test('returns true when ContextVariant does not match', () {
          final context = MockBuildContext();

          // Create mock ContextVariant that returns false
          final falseVariant = ContextVariant('test', (context) => false);
          final variant = MultiVariant.not(falseVariant);

          expect(variant.when(context), isTrue);
        });

        test('returns false when ContextVariant matches', () {
          final context = MockBuildContext();

          // Create mock ContextVariant that returns true
          final trueVariant = ContextVariant('test', (context) => true);
          final variant = MultiVariant.not(trueVariant);

          expect(variant.when(context), isFalse);
        });

        test(
          'returns true when contains NamedVariant (never matches context)',
          () {
            final context = MockBuildContext();

            final variant = MultiVariant.not(const NamedVariant('primary'));

            expect(variant.when(context), isTrue);
          },
        );
      });
    });

    group('Operator overloading', () {
      test('& operator creates AND MultiVariant', () {
        const variant1 = NamedVariant('primary');
        const variant2 = NamedVariant('large');

        final combined = variant1 & variant2;

        expect(combined, isA<MultiVariant>());
        expect(combined.operatorType, MultiVariantOperator.and);
        expect(combined.variants, contains(variant1));
        expect(combined.variants, contains(variant2));
      });

      test('| operator creates OR MultiVariant', () {
        const variant1 = NamedVariant('primary');
        const variant2 = NamedVariant('secondary');

        final combined = variant1 | variant2;

        expect(combined, isA<MultiVariant>());
        expect(combined.operatorType, MultiVariantOperator.or);
        expect(combined.variants, contains(variant1));
        expect(combined.variants, contains(variant2));
      });

      test('chaining operators creates nested structure', () {
        const variant1 = NamedVariant('primary');
        const variant2 = NamedVariant('large');
        const variant3 = NamedVariant('secondary');

        // (primary AND large) OR secondary
        final combined = (variant1 & variant2) | variant3;

        expect(combined, isA<MultiVariant>());
        expect(combined.operatorType, MultiVariantOperator.or);
        expect(combined.variants.length, 2);
        expect(combined.variants, contains(variant3));

        // First variant should be the AND combination
        final andVariant =
            combined.variants.firstWhere((v) => v is MultiVariant)
                as MultiVariant;
        expect(andVariant.operatorType, MultiVariantOperator.and);
        expect(andVariant.variants, contains(variant1));
        expect(andVariant.variants, contains(variant2));
      });
    });

    group('Complex nested scenarios', () {
      test('deeply nested AND/OR combinations work correctly', () {
        final context = MockBuildContext();

        // Create mock variants for testing logic
        final trueVariant1 = ContextVariant('true1', (context) => true);
        final trueVariant2 = ContextVariant('true2', (context) => true);
        final falseVariant1 = ContextVariant('false1', (context) => false);
        final falseVariant2 = ContextVariant('false2', (context) => false);

        // (true AND true) OR (false AND false) = true OR false = true
        final complex = MultiVariant.or([
          MultiVariant.and([trueVariant1, trueVariant2]),
          MultiVariant.and([falseVariant1, falseVariant2]),
        ]);

        expect(complex.when(context), isTrue);
      });

      test('NOT with complex nested variants', () {
        final context = MockBuildContext();

        // Create mock variants
        final falseVariant1 = ContextVariant('false1', (context) => false);
        final falseVariant2 = ContextVariant('false2', (context) => false);

        // NOT (false AND false) = NOT false = true
        final notComplex = MultiVariant.not(
          MultiVariant.and([falseVariant1, falseVariant2]),
        );

        expect(notComplex.when(context), isTrue);
      });
    });

    group('Equality and hashing', () {
      test('equal MultiVariants have same hashCode', () {
        final variant1 = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);

        final variant2 = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);

        expect(variant1, equals(variant2));
        expect(variant1.hashCode, equals(variant2.hashCode));
      });

      test('different operator types are not equal', () {
        final andVariant = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);

        final orVariant = MultiVariant.or(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);

        expect(andVariant, isNot(equals(orVariant)));
      });

      test('different variant lists are not equal', () {
        final variant1 = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);

        final variant2 = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('small'),
        ]);

        expect(variant1, isNot(equals(variant2)));
      });

      test('order of variants affects equality', () {
        final variant1 = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);

        final variant2 = MultiVariant.and(const [
          NamedVariant('large'),
          NamedVariant('primary'),
        ]);

        // Implementation is order-sensitive for equality
        expect(variant1, isNot(equals(variant2)));
      });
    });

    group('Key generation', () {
      test('key contains MultiVariant identifier and variant keys', () {
        final variant = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);

        expect(variant.key, contains('MultiVariant'));
        expect(variant.key, contains('primary'));
        expect(variant.key, contains('large'));
      });

      test('MultiVariants with same variants have same key pattern', () {
        final andVariant = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);

        final orVariant = MultiVariant.or(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);

        // Key generation appears to focus on variant content, not operator type
        expect(andVariant.key, equals(orVariant.key));

        // But they should still be different objects with different operator types
        expect(andVariant, isNot(equals(orVariant)));
        expect(andVariant.operatorType, isNot(equals(orVariant.operatorType)));
      });
    });

    group('Props getter', () {
      test('props returns variants and operator type', () {
        final variant = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);

        final props = variant.props;
        expect(props.length, 2);
        expect(props, contains(variant.variants));
        expect(props, contains(variant.operatorType));
      });
    });

    group('Edge cases', () {
      test('empty variant list creates valid MultiVariant', () {
        final variant = MultiVariant.and(const []);

        expect(variant.operatorType, MultiVariantOperator.and);
        expect(variant.variants, isEmpty);
      });

      test('single variant creates valid MultiVariant', () {
        final variant = MultiVariant.and(const [NamedVariant('primary')]);

        expect(variant.operatorType, MultiVariantOperator.and);
        expect(variant.variants.length, 1);
        expect(variant.variants.first, const NamedVariant('primary'));
      });

      test('when with empty variants returns appropriate default', () {
        final context = MockBuildContext();

        final andVariant = MultiVariant.and(const []);
        final orVariant = MultiVariant.or(const []);

        // AND with no conditions should be true (all conditions met vacuously)
        expect(andVariant.when(context), isTrue);

        // OR with no conditions should be false (no conditions to satisfy)
        expect(orVariant.when(context), isFalse);
      });
    });
  });

  group('Global not() function', () {
    test('creates MultiVariant with NOT operator', () {
      const variant = NamedVariant('disabled');
      final notVariant = not(variant);

      expect(notVariant, isA<MultiVariant>());
      expect(notVariant.operatorType, MultiVariantOperator.not);
      expect(notVariant.variants.length, 1);
      expect(notVariant.variants.first, variant);
    });

    test('works with complex variants', () {
      final complexVariant = MultiVariant.and(const [
        NamedVariant('primary'),
        NamedVariant('large'),
      ]);

      final notVariant = not(complexVariant);

      expect(notVariant.operatorType, MultiVariantOperator.not);
      expect(notVariant.variants.first, complexVariant);
    });
  });

  group('Integration with predefined variants', () {
    test('works with predefined widget state variants', () {
      final hover = ContextVariant.widgetState(WidgetState.hovered);
      final press = ContextVariant.widgetState(WidgetState.pressed);
      final variant = MultiVariant.and([hover, press]);

      expect(variant.operatorType, MultiVariantOperator.and);
      expect(variant.variants, contains(hover));
      expect(variant.variants, contains(press));
    });

    test('works with predefined responsive variants', () {
      final mobile = ContextVariant.size('mobile', (size) => size.width <= 767);
      final tablet = ContextVariant.size('tablet', (size) => size.width > 767 && size.width <= 1279);
      final desktop = ContextVariant.size('desktop', (size) => size.width > 1279);
      final variant = MultiVariant.or([mobile, tablet, desktop]);

      expect(variant.operatorType, MultiVariantOperator.or);
      expect(variant.variants, contains(mobile));
      expect(variant.variants, contains(tablet));
      expect(variant.variants, contains(desktop));
    });

    test('mixed predefined and custom variants', () {
      final dark = ContextVariant.platformBrightness(Brightness.dark);
      final variant = MultiVariant.and([
        dark,
        const NamedVariant('custom'), // custom
      ]);

      expect(variant.variants, contains(dark));
      expect(variant.variants, contains(const NamedVariant('custom')));
    });
  });
}
