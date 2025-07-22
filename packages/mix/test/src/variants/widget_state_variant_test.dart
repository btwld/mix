import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('WidgetStateVariant', () {
    group('Constructor', () {
      test('creates WidgetStateVariant with correct properties', () {
        final variant = WidgetStateVariant(WidgetState.hovered);

        expect(variant.state, WidgetState.hovered);
        expect(variant.key, 'widget_state_hovered');
        expect(variant, isA<ContextVariant>());
      });

      test('creates different variants for different states', () {
        final hovered = WidgetStateVariant(WidgetState.hovered);
        final pressed = WidgetStateVariant(WidgetState.pressed);
        final focused = WidgetStateVariant(WidgetState.focused);

        expect(hovered.state, WidgetState.hovered);
        expect(pressed.state, WidgetState.pressed);
        expect(focused.state, WidgetState.focused);

        expect(hovered.key, 'widget_state_hovered');
        expect(pressed.key, 'widget_state_pressed');
        expect(focused.key, 'widget_state_focused');
      });

      test('all WidgetState values create valid variants', () {
        for (final state in WidgetState.values) {
          final variant = WidgetStateVariant(state);
          expect(variant.state, state);
          expect(variant.key, 'widget_state_${state.name}');
        }
      });
    });

    group('Factory from ContextVariant', () {
      test('ContextVariant.widgetState creates WidgetStateVariant', () {
        final variant = ContextVariant.widgetState(WidgetState.hovered);

        expect(variant, isA<WidgetStateVariant>());
        expect(variant.state, WidgetState.hovered);
        expect(variant.key, 'widget_state_hovered');
      });

      test('factory method creates different variants for different states', () {
        final hovered = ContextVariant.widgetState(WidgetState.hovered);
        final pressed = ContextVariant.widgetState(WidgetState.pressed);

        expect(hovered, isA<WidgetStateVariant>());
        expect(pressed, isA<WidgetStateVariant>());
        expect(hovered.state, WidgetState.hovered);
        expect(pressed.state, WidgetState.pressed);
        expect(hovered.key, isNot(equals(pressed.key)));
      });
    });

    group('Key generation', () {
      test('key follows widget_state_<stateName> pattern', () {
        final testCases = {
          WidgetState.hovered: 'widget_state_hovered',
          WidgetState.pressed: 'widget_state_pressed',
          WidgetState.focused: 'widget_state_focused',
          WidgetState.disabled: 'widget_state_disabled',
          WidgetState.selected: 'widget_state_selected',
          WidgetState.dragged: 'widget_state_dragged',
          WidgetState.error: 'widget_state_error',
          WidgetState.scrolledUnder: 'widget_state_scrolledUnder',
        };

        for (final entry in testCases.entries) {
          final variant = WidgetStateVariant(entry.key);
          expect(variant.key, entry.value);
        }
      });

      test('different states have different keys', () {
        final variants = WidgetState.values
            .map((state) => WidgetStateVariant(state))
            .toList();

        final keys = variants.map((v) => v.key).toSet();
        expect(keys.length, WidgetState.values.length);
      });
    });

    group('Equality and hashCode', () {
      test('equal WidgetStateVariants have same hashCode', () {
        final variant1 = WidgetStateVariant(WidgetState.hovered);
        final variant2 = WidgetStateVariant(WidgetState.hovered);

        expect(variant1, equals(variant2));
        expect(variant1.hashCode, equals(variant2.hashCode));
      });

      test('different states are not equal', () {
        final hovered = WidgetStateVariant(WidgetState.hovered);
        final pressed = WidgetStateVariant(WidgetState.pressed);

        expect(hovered, isNot(equals(pressed)));
        expect(hovered.hashCode, isNot(equals(pressed.hashCode)));
      });

      test('identical instances are equal', () {
        final variant = WidgetStateVariant(WidgetState.hovered);

        expect(variant, equals(variant));
        expect(identical(variant, variant), isTrue);
      });

      test('equality works across factory methods', () {
        final direct = WidgetStateVariant(WidgetState.hovered);
        final factory = ContextVariant.widgetState(WidgetState.hovered);

        expect(direct, equals(factory));
        expect(direct.hashCode, equals(factory.hashCode));
      });
    });

    group('Inheritance from ContextVariant', () {
      test('inherits ContextVariant properties and methods', () {
        final variant = WidgetStateVariant(WidgetState.hovered);

        expect(variant, isA<ContextVariant>());
        expect(variant, isA<Variant>());
        expect(variant.key, isA<String>());
        expect(variant.shouldApply, isA<Function>());
      });

      test('when method delegates to shouldApply function', () {
        final variant = WidgetStateVariant(WidgetState.hovered);
        final context = MockBuildContext();

        // The actual behavior depends on MixWidgetStateModel.hasStateOf
        // We're testing that the method exists and can be called
        expect(() => variant.when(context), returnsNormally);
      });

      test('can be used in MultiVariant operations', () {
        final hovered = WidgetStateVariant(WidgetState.hovered);
        final pressed = WidgetStateVariant(WidgetState.pressed);

        final andVariant = hovered & pressed;
        final orVariant = hovered | pressed;

        expect(andVariant, isA<MultiVariant>());
        expect(orVariant, isA<MultiVariant>());
        expect(andVariant.operatorType, MultiVariantOperator.and);
        expect(orVariant.operatorType, MultiVariantOperator.or);
      });
    });

    group('Integration with MixWidgetStateModel', () {
      test('shouldApply function references MixWidgetStateModel.hasStateOf', () {
        final variant = WidgetStateVariant(WidgetState.hovered);
        final context = MockBuildContext();

        // Test that the function exists and is callable
        // The actual behavior depends on the MixWidgetStateModel implementation
        expect(() => variant.shouldApply(context), returnsNormally);
        expect(variant.shouldApply(context), isA<bool>());
      });

      test('different states have different shouldApply behaviors', () {
        final hovered = WidgetStateVariant(WidgetState.hovered);
        final pressed = WidgetStateVariant(WidgetState.pressed);
        
        // The functions should be different even if they might return the same result
        expect(hovered.shouldApply != pressed.shouldApply, isTrue);
      });
    });

    group('Predefined widget state variants', () {
      test('predefined variants use WidgetStateVariant', () {
        // These are imported from variant.dart
        expect(hover, isA<WidgetStateVariant>());
        expect(press, isA<WidgetStateVariant>());
        expect(focus, isA<WidgetStateVariant>());
        expect(disabled, isA<WidgetStateVariant>());
        expect(selected, isA<WidgetStateVariant>());
        expect(dragged, isA<WidgetStateVariant>());
        expect(error, isA<WidgetStateVariant>());
      });

      test('predefined variants have correct states', () {
        expect(hover.state, WidgetState.hovered);
        expect(press.state, WidgetState.pressed);
        expect(focus.state, WidgetState.focused);
        expect(disabled.state, WidgetState.disabled);
        expect(selected.state, WidgetState.selected);
        expect(dragged.state, WidgetState.dragged);
        expect(error.state, WidgetState.error);
      });

      test('predefined variants have correct keys', () {
        expect(hover.key, 'widget_state_hovered');
        expect(press.key, 'widget_state_pressed');
        expect(focus.key, 'widget_state_focused');
        expect(disabled.key, 'widget_state_disabled');
        expect(selected.key, 'widget_state_selected');
        expect(dragged.key, 'widget_state_dragged');
        expect(error.key, 'widget_state_error');
      });

      test('predefined enabled variant uses NOT logic', () {
        // enabled is defined as not(disabled) in variant.dart
        expect(enabled, isA<MultiVariant>());
        expect(enabled.operatorType, MultiVariantOperator.not);
        expect(enabled.variants.length, 1);
        expect(enabled.variants.first, disabled);
      });

      test('predefined unselected variant uses NOT logic', () {
        // unselected is defined as not(selected) in variant.dart
        expect(unselected, isA<MultiVariant>());
        expect(unselected.operatorType, MultiVariantOperator.not);
        expect(unselected.variants.length, 1);
        expect(unselected.variants.first, selected);
      });
    });

    group('Complex widget state scenarios', () {
      test('combines with other WidgetStateVariants in MultiVariant', () {
        final hoverAndPress = MultiVariant.and([
          WidgetStateVariant(WidgetState.hovered),
          WidgetStateVariant(WidgetState.pressed),
        ]);

        expect(hoverAndPress.variants.length, 2);
        expect(hoverAndPress.operatorType, MultiVariantOperator.and);
        
        final containsHover = hoverAndPress.variants
            .any((v) => v is WidgetStateVariant && v.state == WidgetState.hovered);
        final containsPress = hoverAndPress.variants
            .any((v) => v is WidgetStateVariant && v.state == WidgetState.pressed);
        
        expect(containsHover, isTrue);
        expect(containsPress, isTrue);
      });

      test('combines with NamedVariants in MultiVariant', () {
        final hoverAndPrimary = MultiVariant.and([
          WidgetStateVariant(WidgetState.hovered),
          const NamedVariant('primary'),
        ]);

        expect(hoverAndPrimary.variants.length, 2);
        expect(hoverAndPrimary.variants, contains(isA<WidgetStateVariant>()));
        expect(hoverAndPrimary.variants, contains(const NamedVariant('primary')));
      });

      test('can be negated with NOT operation', () {
        final notHovered = MultiVariant.not(
          WidgetStateVariant(WidgetState.hovered),
        );

        expect(notHovered.operatorType, MultiVariantOperator.not);
        expect(notHovered.variants.length, 1);
        expect(notHovered.variants.first, isA<WidgetStateVariant>());
        
        final widgetStateVariant = notHovered.variants.first as WidgetStateVariant;
        expect(widgetStateVariant.state, WidgetState.hovered);
      });

      test('works with predefined utility variants', () {
        // Test with predefined enabled (not disabled)
        final enabledAndHovered = MultiVariant.and([enabled, hover]);

        expect(enabledAndHovered.variants.length, 2);
        expect(enabledAndHovered.variants, contains(enabled)); // MultiVariant
        expect(enabledAndHovered.variants, contains(hover)); // WidgetStateVariant
      });
    });

    group('VariantSpecAttribute integration', () {
      test('can be used in VariantSpecAttribute wrapper', () {
        final hoverVariant = WidgetStateVariant(WidgetState.hovered);
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(hoverVariant, style);

        expect(variantAttr.variant, hoverVariant);
        expect(variantAttr.value, style);
        expect(variantAttr.mergeKey, hoverVariant.key);
      });

      test('different widget states create different VariantSpecAttribute mergeKeys', () {
        final hoverStyle = VariantSpecAttribute(
          WidgetStateVariant(WidgetState.hovered),
          BoxSpecAttribute.only(width: 100.0),
        );
        
        final pressStyle = VariantSpecAttribute(
          WidgetStateVariant(WidgetState.pressed),
          BoxSpecAttribute.only(width: 150.0),
        );

        expect(hoverStyle.mergeKey, isNot(equals(pressStyle.mergeKey)));
        expect(hoverStyle.mergeKey, 'widget_state_hovered');
        expect(pressStyle.mergeKey, 'widget_state_pressed');
      });

      test('merges correctly when variants match', () {
        final hoverVariant = WidgetStateVariant(WidgetState.hovered);
        
        final style1 = VariantSpecAttribute(
          hoverVariant,
          BoxSpecAttribute.only(width: 100.0),
        );
        
        final style2 = VariantSpecAttribute(
          hoverVariant,
          BoxSpecAttribute.only(height: 200.0),
        );

        final merged = style1.merge(style2);

        expect(merged.variant, hoverVariant);
        final mergedBox = merged.value as BoxSpecAttribute;
        expect(mergedBox.$width, hasValue(100.0));
        expect(mergedBox.$height, hasValue(200.0));
      });
    });

    group('Edge cases and error handling', () {
      test('handles all WidgetState enum values', () {
        // Ensure no WidgetState values are missed
        for (final state in WidgetState.values) {
          expect(() => WidgetStateVariant(state), returnsNormally);
          final variant = WidgetStateVariant(state);
          expect(variant.state, state);
          expect(variant.key, contains(state.name));
        }
      });

      test('state property is immutable', () {
        final variant = WidgetStateVariant(WidgetState.hovered);
        expect(variant.state, WidgetState.hovered);
        
        // Should not be able to modify the state after creation
        // (This is enforced by Dart's final keyword)
        expect(() => variant.state, returnsNormally);
      });

      test('key property is consistent', () {
        final variant1 = WidgetStateVariant(WidgetState.hovered);
        final variant2 = WidgetStateVariant(WidgetState.hovered);

        expect(variant1.key, equals(variant2.key));
        expect(variant1.key, 'widget_state_hovered');
        expect(variant2.key, 'widget_state_hovered');
      });
    });

    group('Performance considerations', () {
      test('creating many WidgetStateVariants is efficient', () {
        final stopwatch = Stopwatch()..start();
        
        for (int i = 0; i < 1000; i++) {
          WidgetStateVariant(WidgetState.hovered);
        }
        
        stopwatch.stop();
        
        // Should complete quickly (less than 100ms for 1000 instances)
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('equality checks are efficient', () {
        final variant1 = WidgetStateVariant(WidgetState.hovered);
        final variant2 = WidgetStateVariant(WidgetState.hovered);
        final variant3 = WidgetStateVariant(WidgetState.pressed);
        
        final stopwatch = Stopwatch()..start();
        
        for (int i = 0; i < 1000; i++) {
          variant1 == variant2; // should be true
          variant1 == variant3; // should be false
        }
        
        stopwatch.stop();
        
        // Should complete quickly (less than 50ms for 2000 comparisons)
        expect(stopwatch.elapsedMilliseconds, lessThan(50));
      });
    });
  });
}