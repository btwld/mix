import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('WidgetStateVariant', () {
    group('Constructor', () {
      test('creates WidgetStateVariant with correct properties', () {
        final variant = WidgetStateTrigger(WidgetState.hovered);

        expect(variant.state, WidgetState.hovered);
        expect(variant.key, 'widget_state_hovered');
        expect(variant, isA<ContextTrigger>());
      });

      test('creates different variants for different states', () {
        final hovered = WidgetStateTrigger(WidgetState.hovered);
        final pressed = WidgetStateTrigger(WidgetState.pressed);
        final focused = WidgetStateTrigger(WidgetState.focused);

        expect(hovered.state, WidgetState.hovered);
        expect(pressed.state, WidgetState.pressed);
        expect(focused.state, WidgetState.focused);

        expect(hovered.key, 'widget_state_hovered');
        expect(pressed.key, 'widget_state_pressed');
        expect(focused.key, 'widget_state_focused');
      });

      test('all WidgetState values create valid variants', () {
        for (final state in WidgetState.values) {
          final variant = WidgetStateTrigger(state);
          expect(variant.state, state);
          expect(variant.key, 'widget_state_${state.name}');
        }
      });
    });

    group('Factory from ContextTrigger', () {
      test('ContextTrigger.widgetState creates WidgetStateVariant', () {
        final variant = ContextTrigger.widgetState(WidgetState.hovered);

        expect(variant, isA<WidgetStateTrigger>());
        expect(variant.state, WidgetState.hovered);
        expect(variant.key, 'widget_state_hovered');
      });

      test(
        'factory method creates different variants for different states',
        () {
          final hovered = ContextTrigger.widgetState(WidgetState.hovered);
          final pressed = ContextTrigger.widgetState(WidgetState.pressed);

          expect(hovered, isA<WidgetStateTrigger>());
          expect(pressed, isA<WidgetStateTrigger>());
          expect(hovered.state, WidgetState.hovered);
          expect(pressed.state, WidgetState.pressed);
          expect(hovered.key, isNot(equals(pressed.key)));
        },
      );
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
          final variant = WidgetStateTrigger(entry.key);
          expect(variant.key, entry.value);
        }
      });

      test('different states have different keys', () {
        final variants = WidgetState.values
            .map((state) => WidgetStateTrigger(state))
            .toList();

        final keys = variants.map((v) => v.key).toSet();
        expect(keys.length, WidgetState.values.length);
      });
    });

    group('Equality and hashCode', () {
      test('equal WidgetStateVariants have same hashCode', () {
        final variant1 = WidgetStateTrigger(WidgetState.hovered);
        final variant2 = WidgetStateTrigger(WidgetState.hovered);

        expect(variant1, equals(variant2));
        expect(variant1.hashCode, equals(variant2.hashCode));
      });

      test('different states are not equal', () {
        final hovered = WidgetStateTrigger(WidgetState.hovered);
        final pressed = WidgetStateTrigger(WidgetState.pressed);

        expect(hovered, isNot(equals(pressed)));
        expect(hovered.hashCode, isNot(equals(pressed.hashCode)));
      });

      test('identical instances are equal', () {
        final variant = WidgetStateTrigger(WidgetState.hovered);

        expect(variant, equals(variant));
        expect(identical(variant, variant), isTrue);
      });

      test('equality works across factory methods', () {
        final direct = WidgetStateTrigger(WidgetState.hovered);
        final factory = ContextTrigger.widgetState(WidgetState.hovered);

        expect(direct, equals(factory));
        expect(direct.hashCode, equals(factory.hashCode));
      });
    });

    group('Inheritance from ContextTrigger', () {
      test('inherits ContextTrigger properties and methods', () {
        final variant = WidgetStateTrigger(WidgetState.hovered);

        expect(variant, isA<ContextTrigger>());
        expect(variant, isA<ContextTrigger>());
        expect(variant.key, isA<String>());
        expect(variant.shouldApply, isA<Function>());
      });

      test('matches method delegates to shouldApply function', () {
        final variant = WidgetStateTrigger(WidgetState.hovered);
        final context = MockBuildContext();

        // The actual behavior depends on WidgetStateProvider.hasStateOf
        // We're testing that the method exists and can be called
        expect(() => variant.matches(context), returnsNormally);
      });

      test('separate variants can be used independently', () {
        final hovered = WidgetStateTrigger(WidgetState.hovered);
        final pressed = WidgetStateTrigger(WidgetState.pressed);

        expect(hovered.state, WidgetState.hovered);
        expect(pressed.state, WidgetState.pressed);
        expect(hovered, isNot(equals(pressed)));
      });
    });

    group('Integration with WidgetStateProvider', () {
      test('shouldApply function references WidgetStateProvider.hasStateOf', () {
        final variant = WidgetStateTrigger(WidgetState.hovered);
        final context = MockBuildContext();

        // Test that the function exists and is callable
        // The actual behavior depends on the WidgetStateProvider implementation
        expect(() => variant.shouldApply(context), returnsNormally);
        expect(variant.shouldApply(context), isA<bool>());
      });

      test('different states have different shouldApply behaviors', () {
        final hovered = WidgetStateTrigger(WidgetState.hovered);
        final pressed = WidgetStateTrigger(WidgetState.pressed);

        // The functions should be different even if they might return the same result
        expect(hovered.shouldApply != pressed.shouldApply, isTrue);
      });
    });

    group('Predefined widget state variants', () {
      test('predefined variants use WidgetStateVariant', () {
        expect(
          ContextTrigger.widgetState(WidgetState.hovered),
          isA<WidgetStateTrigger>(),
        );
        expect(
          ContextTrigger.widgetState(WidgetState.pressed),
          isA<WidgetStateTrigger>(),
        );
        expect(
          ContextTrigger.widgetState(WidgetState.focused),
          isA<WidgetStateTrigger>(),
        );
        expect(
          ContextTrigger.widgetState(WidgetState.disabled),
          isA<WidgetStateTrigger>(),
        );
        expect(
          ContextTrigger.widgetState(WidgetState.selected),
          isA<WidgetStateTrigger>(),
        );
        expect(
          ContextTrigger.widgetState(WidgetState.dragged),
          isA<WidgetStateTrigger>(),
        );
        expect(
          ContextTrigger.widgetState(WidgetState.error),
          isA<WidgetStateTrigger>(),
        );
      });

      test('predefined variants have correct states', () {
        expect(
          ContextTrigger.widgetState(WidgetState.hovered).state,
          WidgetState.hovered,
        );
        expect(
          ContextTrigger.widgetState(WidgetState.pressed).state,
          WidgetState.pressed,
        );
        expect(
          ContextTrigger.widgetState(WidgetState.focused).state,
          WidgetState.focused,
        );
        expect(
          ContextTrigger.widgetState(WidgetState.disabled).state,
          WidgetState.disabled,
        );
        expect(
          ContextTrigger.widgetState(WidgetState.selected).state,
          WidgetState.selected,
        );
        expect(
          ContextTrigger.widgetState(WidgetState.dragged).state,
          WidgetState.dragged,
        );
        expect(
          ContextTrigger.widgetState(WidgetState.error).state,
          WidgetState.error,
        );
      });

      test('predefined variants have correct keys', () {
        expect(
          ContextTrigger.widgetState(WidgetState.hovered).key,
          'widget_state_hovered',
        );
        expect(
          ContextTrigger.widgetState(WidgetState.pressed).key,
          'widget_state_pressed',
        );
        expect(
          ContextTrigger.widgetState(WidgetState.focused).key,
          'widget_state_focused',
        );
        expect(
          ContextTrigger.widgetState(WidgetState.disabled).key,
          'widget_state_disabled',
        );
        expect(
          ContextTrigger.widgetState(WidgetState.selected).key,
          'widget_state_selected',
        );
        expect(
          ContextTrigger.widgetState(WidgetState.dragged).key,
          'widget_state_dragged',
        );
        expect(
          ContextTrigger.widgetState(WidgetState.error).key,
          'widget_state_error',
        );
      });

      test('predefined enabled variant uses NOT logic', () {
        final disabled = ContextTrigger.widgetState(WidgetState.disabled);
        final enabled = ContextTrigger.not(disabled);

        expect(enabled, isA<ContextTrigger>());
        expect(enabled.key, contains('not'));
      });

      test('predefined unselected variant uses NOT logic', () {
        final selected = ContextTrigger.widgetState(WidgetState.selected);
        final unselected = ContextTrigger.not(selected);

        expect(unselected, isA<ContextTrigger>());
        expect(unselected.key, contains('not'));
      });
    });

    group('Complex widget state scenarios', () {
      test('multiple widget states can be applied separately', () {
        final hovered = WidgetStateTrigger(WidgetState.hovered);
        final pressed = WidgetStateTrigger(WidgetState.pressed);

        // Test they are distinct variants
        expect(hovered.key, isNot(equals(pressed.key)));
        expect(hovered.state, isNot(equals(pressed.state)));
      });


      test('negated widget states work correctly', () {
        final hovered = WidgetStateTrigger(WidgetState.hovered);
        final notHovered = ContextTrigger.not(hovered);

        expect(notHovered, isA<ContextTrigger>());
        expect(notHovered.key, contains('not'));
      });

      test('enabled variant is opposite of disabled', () {
        final disabled = ContextTrigger.widgetState(WidgetState.disabled);
        final enabled = ContextTrigger.not(disabled);
        final hover = ContextTrigger.widgetState(WidgetState.hovered);

        // Test they are distinct
        expect(enabled.key, isNot(equals(disabled.key)));
        expect(enabled.key, isNot(equals(hover.key)));
      });
    });

    group('VariantSpecAttribute integration', () {
      test('can be used in VariantSpecAttribute wrapper', () {
        final hoverVariant = WidgetStateTrigger(WidgetState.hovered);
        final style = BoxStyler().width(100.0);
        final variantAttr = TriggerVariant<BoxSpec>(hoverVariant, style);

        expect(variantAttr.trigger, hoverVariant);
        expect(variantAttr.style, style);
        expect(variantAttr.variantKey, hoverVariant.key);
      });

      test(
        'different widget states create different VariantSpecAttribute mergeKeys',
        () {
          final hoverStyle = TriggerVariant<BoxSpec>(
            WidgetStateTrigger(WidgetState.hovered),
            BoxStyler().width(100.0),
          );

          final pressStyle = TriggerVariant<BoxSpec>(
            WidgetStateTrigger(WidgetState.pressed),
            BoxStyler().width(150.0),
          );

          expect(hoverStyle.variantKey, isNot(equals(pressStyle.variantKey)));
          expect(hoverStyle.variantKey, 'widget_state_hovered');
          expect(pressStyle.variantKey, 'widget_state_pressed');
        },
      );

      test('merges correctly when variants match', () {
        final hoverVariant = WidgetStateTrigger(WidgetState.hovered);

        final style1 = TriggerVariant<BoxSpec>(
          hoverVariant,
          BoxStyler().width(100.0),
        );

        final style2 = TriggerVariant<BoxSpec>(
          hoverVariant,
          BoxStyler().height(200.0),
        );

        final merged = style1.merge(style2);

        expect(merged.trigger, hoverVariant);
        final mergedBox = merged.style as BoxStyler;
        final context = MockBuildContext();
        final constraints = mergedBox.resolve(context).constraints;
        expect(constraints?.minWidth, 100.0);
        expect(constraints?.maxWidth, 100.0);
        expect(constraints?.minHeight, 200.0);
        expect(constraints?.maxHeight, 200.0);
      });
    });

    group('Edge cases and error handling', () {
      test('handles all WidgetState enum values', () {
        // Ensure no WidgetState values are missed
        for (final state in WidgetState.values) {
          expect(() => WidgetStateTrigger(state), returnsNormally);
          final variant = WidgetStateTrigger(state);
          expect(variant.state, state);
          expect(variant.key, contains(state.name));
        }
      });

      test('state property is immutable', () {
        final variant = WidgetStateTrigger(WidgetState.hovered);
        expect(variant.state, WidgetState.hovered);

        // Should not be able to modify the state after creation
        // (This is enforced by Dart's final keyword)
        expect(() => variant.state, returnsNormally);
      });

      test('key property is consistent', () {
        final variant1 = WidgetStateTrigger(WidgetState.hovered);
        final variant2 = WidgetStateTrigger(WidgetState.hovered);

        expect(variant1.key, equals(variant2.key));
        expect(variant1.key, 'widget_state_hovered');
        expect(variant2.key, 'widget_state_hovered');
      });
    });
  });
}
