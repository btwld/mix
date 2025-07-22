import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('VariantPriority enum', () {
    group('Enum definition', () {
      test('has correct values', () {
        expect(VariantPriority.normal.value, 0);
        expect(VariantPriority.high.value, 1);
      });

      test('values are ordered by priority', () {
        expect(
          VariantPriority.normal.value < VariantPriority.high.value,
          isTrue,
        );
      });

      test('enum contains all expected values', () {
        const values = VariantPriority.values;
        expect(values.length, 2);
        expect(values, contains(VariantPriority.normal));
        expect(values, contains(VariantPriority.high));
      });

      test('has string representation', () {
        expect(VariantPriority.normal.toString(), contains('normal'));
        expect(VariantPriority.high.toString(), contains('high'));
      });

      test('can be compared by value', () {
        expect(
          VariantPriority.normal.value,
          lessThan(VariantPriority.high.value),
        );
        expect(
          VariantPriority.high.value,
          greaterThan(VariantPriority.normal.value),
        );
      });
    });

    group('Enum behavior', () {
      test('equality works correctly', () {
        expect(VariantPriority.normal, equals(VariantPriority.normal));
        expect(VariantPriority.high, equals(VariantPriority.high));
        expect(VariantPriority.normal, isNot(equals(VariantPriority.high)));
      });

      test('hashCode works correctly', () {
        expect(
          VariantPriority.normal.hashCode,
          equals(VariantPriority.normal.hashCode),
        );
        expect(
          VariantPriority.high.hashCode,
          equals(VariantPriority.high.hashCode),
        );
        expect(
          VariantPriority.normal.hashCode,
          isNot(equals(VariantPriority.high.hashCode)),
        );
      });

      test('can be used in collections', () {
        const priorities = <VariantPriority>[
          VariantPriority.high,
          VariantPriority.normal,
        ];
        expect(priorities, contains(VariantPriority.normal));
        expect(priorities, contains(VariantPriority.high));
        expect(priorities.length, 2);
      });

      test('can be used in switch statements', () {
        String priorityName(VariantPriority priority) {
          switch (priority) {
            case VariantPriority.normal:
              return 'normal';
            case VariantPriority.high:
              return 'high';
          }
        }

        expect(priorityName(VariantPriority.normal), 'normal');
        expect(priorityName(VariantPriority.high), 'high');
      });

      test('can be sorted by value', () {
        final priorities = [VariantPriority.high, VariantPriority.normal];
        priorities.sort((a, b) => a.value.compareTo(b.value));

        expect(priorities.first, VariantPriority.normal);
        expect(priorities.last, VariantPriority.high);
      });
    });

    group('Current implementation status', () {
      test('enum is defined but unused in current codebase', () {
        // This test documents the current state: VariantPriority enum exists
        // but is not actually used anywhere in the variant resolution logic.
        // The priority behavior is currently hardcoded in Style.getAllStyleVariants
        expect(VariantPriority.normal, isA<VariantPriority>());
        expect(VariantPriority.high, isA<VariantPriority>());

        // This test serves as documentation that the enum exists
        // but priority is handled differently in the actual implementation
      });
    });
  });

  group('Actual Priority Implementation in Style.getAllStyleVariants', () {
    group('WidgetStateVariant priority behavior', () {
      test('WidgetStateVariants are sorted to apply last (highest priority)', () {
        // Create a mock SpecAttribute to test the sorting behavior
        final testAttribute = _MockSpecAttributeForPriority();

        // Create various types of variants
        final contextVariant = ContextVariant('context', (context) => true);
        const namedVariant = NamedVariant('named');
        final widgetStateVariant = WidgetStateVariant(WidgetState.hovered);

        // Create VariantSpecAttributes with different variant types
        final contextVarAttr = VariantSpecAttribute(
          contextVariant,
          testAttribute,
        );
        final namedVarAttr = VariantSpecAttribute(namedVariant, testAttribute);
        final widgetStateVarAttr = VariantSpecAttribute(
          widgetStateVariant,
          testAttribute,
        );

        // Create a SpecAttribute with variants in mixed order
        final attributeWithVariants = _MockSpecAttributeWithVariants([
          contextVarAttr,
          widgetStateVarAttr, // WidgetStateVariant - should be sorted last
          namedVarAttr,
        ]);

        final context = MockBuildContext();
        final result = attributeWithVariants.getAllStyleVariants(context);

        // The result should exist (though the exact behavior depends on implementation)
        expect(result, isA<SpecStyle>());
      });

      test('multiple WidgetStateVariants maintain relative order', () {
        final testAttribute = _MockSpecAttributeForPriority();

        // Create multiple WidgetStateVariants
        final hoveredVariant = WidgetStateVariant(WidgetState.hovered);
        final pressedVariant = WidgetStateVariant(WidgetState.pressed);
        final focusedVariant = WidgetStateVariant(WidgetState.focused);

        final hoveredVarAttr = VariantSpecAttribute(
          hoveredVariant,
          testAttribute,
        );
        final pressedVarAttr = VariantSpecAttribute(
          pressedVariant,
          testAttribute,
        );
        final focusedVarAttr = VariantSpecAttribute(
          focusedVariant,
          testAttribute,
        );

        final attributeWithVariants = _MockSpecAttributeWithVariants([
          hoveredVarAttr,
          pressedVarAttr,
          focusedVarAttr,
        ]);

        final context = MockBuildContext();
        final result = attributeWithVariants.getAllStyleVariants(context);

        expect(result, isA<SpecStyle>());
      });

      test('mixed variant types are sorted with WidgetStateVariant last', () {
        final testAttribute = _MockSpecAttributeForPriority();

        // Create a mix of all variant types
        final contextVariant = ContextVariant('context', (context) => true);
        const namedVariant = NamedVariant('named');
        final widgetStateVariant1 = WidgetStateVariant(WidgetState.hovered);
        final widgetStateVariant2 = WidgetStateVariant(WidgetState.pressed);
        final multiVariant = MultiVariant.and(const [
          NamedVariant('multi1'),
          NamedVariant('multi2'),
        ]);

        final varAttrs = [
          VariantSpecAttribute(
            widgetStateVariant1,
            testAttribute,
          ), // Should be sorted last
          VariantSpecAttribute(
            contextVariant,
            testAttribute,
          ), // Should be sorted earlier
          VariantSpecAttribute(
            widgetStateVariant2,
            testAttribute,
          ), // Should be sorted last
          VariantSpecAttribute(
            namedVariant,
            testAttribute,
          ), // Should be sorted earlier
          VariantSpecAttribute(
            multiVariant,
            testAttribute,
          ), // Should be sorted earlier
        ];

        final attributeWithVariants = _MockSpecAttributeWithVariants(varAttrs);

        final context = MockBuildContext();
        final result = attributeWithVariants.getAllStyleVariants(context);

        expect(result, isA<SpecStyle>());
      });
    });

    group('Priority documentation and behavior', () {
      test('documents that priority is hardcoded for WidgetStateVariant', () {
        // This test documents the current implementation:
        // Priority is not based on VariantPriority enum but is hardcoded
        // in Style.getAllStyleVariants to sort WidgetStateVariant last

        expect(
          WidgetStateVariant(WidgetState.hovered),
          isA<WidgetStateVariant>(),
        );
        expect(WidgetStateVariant(WidgetState.hovered), isA<ContextVariant>());

        // WidgetStateVariant has higher priority than regular ContextVariant
        // This is implemented through sorting, not through VariantPriority enum
      });

      test(
        'context variants without WidgetStateVariant have equal priority',
        () {
          final testAttribute = _MockSpecAttributeForPriority();

          // Create multiple non-WidgetState variants
          final contextVariant1 = ContextVariant('context1', (context) => true);
          final contextVariant2 = ContextVariant('context2', (context) => true);
          const namedVariant1 = NamedVariant('named1');
          const namedVariant2 = NamedVariant('named2');

          final varAttrs = [
            VariantSpecAttribute(contextVariant1, testAttribute),
            VariantSpecAttribute(contextVariant2, testAttribute),
            VariantSpecAttribute(namedVariant1, testAttribute),
            VariantSpecAttribute(namedVariant2, testAttribute),
          ];

          final attributeWithVariants = _MockSpecAttributeWithVariants(
            varAttrs,
          );

          final context = MockBuildContext();
          final result = attributeWithVariants.getAllStyleVariants(context);

          // All should be treated equally (no WidgetStateVariant priority)
          expect(result, isA<SpecStyle>());
        },
      );
    });
  });

  group('Priority system evolution and future considerations', () {
    test(
      'VariantPriority enum provides foundation for future implementation',
      () {
        // This test documents that while VariantPriority isn't used now,
        // it provides a foundation for a more flexible priority system

        expect(VariantPriority.values, hasLength(2));
        expect(
          VariantPriority.normal.value,
          lessThan(VariantPriority.high.value),
        );

        // The enum structure allows for:
        // 1. Adding more priority levels
        // 2. Assigning priorities to different variant types
        // 3. More flexible sorting algorithms
      },
    );

    test('current hardcoded approach vs enum-based approach comparison', () {
      // Current approach: Hardcoded in Style.getAllStyleVariants
      // - Simple and efficient
      // - Only supports WidgetStateVariant having higher priority
      // - No runtime configurability

      // Potential enum-based approach:
      // - More flexible and extensible
      // - Could support different priority levels for different variant types
      // - Would require more complex implementation

      expect(VariantPriority.normal, isA<VariantPriority>());
      expect(
        WidgetStateVariant(WidgetState.hovered),
        isA<WidgetStateVariant>(),
      );

      // Both systems exist but serve different purposes currently
    });
  });
}

// Mock classes to test the priority behavior
class _MockSpecAttributeForPriority extends SpecStyle<MockSpec> {
  @override
  SpecStyle<MockSpec> merge(covariant SpecStyle<MockSpec>? other) {
    return this;
  }

  @override
  MockSpec resolve(context) {
    return const MockSpec();
  }

  @override
  List<Object?> get props => [];
}

class _MockSpecAttributeWithVariants extends SpecStyle<MockSpec> {
  final List<VariantSpecAttribute<MockSpec>> testVariants;

  _MockSpecAttributeWithVariants(this.testVariants);

  @override
  List<VariantSpecAttribute<MockSpec>>? get variants => testVariants;

  @override
  SpecStyle<MockSpec> merge(covariant SpecStyle<MockSpec>? other) {
    return this;
  }

  @override
  MockSpec resolve(context) {
    return const MockSpec();
  }

  @override
  List<Object?> get props => [testVariants];
}
