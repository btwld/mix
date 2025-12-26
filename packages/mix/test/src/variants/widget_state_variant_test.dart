import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Widget State Variants', () {
    group('Constructor', () {
      test('creates widget state variant with correct properties', () {
        final variant = ContextVariant.widgetState(WidgetState.hovered);

        expect(variant.trackedState, WidgetState.hovered);
        expect(variant.key, 'widget_state_hovered');
        expect(variant, isA<ContextVariant>());
      });

      test('creates different variants for different states', () {
        final hovered = ContextVariant.widgetState(WidgetState.hovered);
        final pressed = ContextVariant.widgetState(WidgetState.pressed);
        final focused = ContextVariant.widgetState(WidgetState.focused);

        expect(hovered.trackedState, WidgetState.hovered);
        expect(pressed.trackedState, WidgetState.pressed);
        expect(focused.trackedState, WidgetState.focused);

        expect(hovered.key, 'widget_state_hovered');
        expect(pressed.key, 'widget_state_pressed');
        expect(focused.key, 'widget_state_focused');
      });

      test('all WidgetState values create valid variants', () {
        for (final state in WidgetState.values) {
          final variant = ContextVariant.widgetState(state);
          expect(variant.trackedState, state);
          expect(variant.key, 'widget_state_${state.name}');
        }
      });
    });

    group('Factory from ContextVariant', () {
      test('ContextVariant.widgetState creates widget state variant', () {
        final variant = ContextVariant.widgetState(WidgetState.hovered);

        expect(variant, isA<ContextVariant>());
        expect(variant.trackedState, WidgetState.hovered);
        expect(variant.key, 'widget_state_hovered');
      });

      test(
        'factory method creates different variants for different states',
        () {
          final hovered = ContextVariant.widgetState(WidgetState.hovered);
          final pressed = ContextVariant.widgetState(WidgetState.pressed);

          expect(hovered, isA<ContextVariant>());
          expect(pressed, isA<ContextVariant>());
          expect(hovered.trackedState, WidgetState.hovered);
          expect(pressed.trackedState, WidgetState.pressed);
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
          final variant = ContextVariant.widgetState(entry.key);
          expect(variant.key, entry.value);
        }
      });

      test('different states have different keys', () {
        final variants = WidgetState.values
            .map((state) => ContextVariant.widgetState(state))
            .toList();

        final keys = variants.map((v) => v.key).toSet();
        expect(keys.length, WidgetState.values.length);
      });
    });

    group('Equality and hashCode', () {
      test('equal widget state variants have same hashCode', () {
        final variant1 = ContextVariant.widgetState(WidgetState.hovered);
        final variant2 = ContextVariant.widgetState(WidgetState.hovered);

        expect(variant1, equals(variant2));
        expect(variant1.hashCode, equals(variant2.hashCode));
      });

      test('different states are not equal', () {
        final hovered = ContextVariant.widgetState(WidgetState.hovered);
        final pressed = ContextVariant.widgetState(WidgetState.pressed);

        expect(hovered, isNot(equals(pressed)));
        expect(hovered.hashCode, isNot(equals(pressed.hashCode)));
      });

      test('identical instances are equal', () {
        final variant = ContextVariant.widgetState(WidgetState.hovered);

        expect(variant, equals(variant));
        expect(identical(variant, variant), isTrue);
      });
    });

    group('trackedState property', () {
      test('widget state variants have non-null trackedState', () {
        final variant = ContextVariant.widgetState(WidgetState.hovered);
        expect(variant.trackedState, isNotNull);
        expect(variant.trackedState, WidgetState.hovered);
      });

      test('regular context variants have null trackedState', () {
        final variant = ContextVariant.brightness(Brightness.dark);
        expect(variant.trackedState, isNull);
      });
    });

    group('Inheritance from ContextVariant', () {
      test('inherits ContextVariant properties and methods', () {
        final variant = ContextVariant.widgetState(WidgetState.hovered);

        expect(variant, isA<ContextVariant>());
        expect(variant, isA<Variant>());
        expect(variant.key, isA<String>());
        expect(variant.shouldApply, isA<Function>());
      });

      test('when method delegates to shouldApply function', () {
        final variant = ContextVariant.widgetState(WidgetState.hovered);
        final context = MockBuildContext();

        // The actual behavior depends on WidgetStateProvider.hasStateOf
        // We're testing that the method exists and can be called
        expect(() => variant.when(context), returnsNormally);
      });

      test('separate variants can be used independently', () {
        final hovered = ContextVariant.widgetState(WidgetState.hovered);
        final pressed = ContextVariant.widgetState(WidgetState.pressed);

        expect(hovered.trackedState, WidgetState.hovered);
        expect(pressed.trackedState, WidgetState.pressed);
        expect(hovered, isNot(equals(pressed)));
      });
    });

    group('Integration with WidgetStateProvider', () {
      test('shouldApply function references WidgetStateProvider.hasStateOf', () {
        final variant = ContextVariant.widgetState(WidgetState.hovered);
        final context = MockBuildContext();

        // Test that the function exists and is callable
        // The actual behavior depends on the WidgetStateProvider implementation
        expect(() => variant.shouldApply(context), returnsNormally);
        expect(variant.shouldApply(context), isA<bool>());
      });

      test('different states have different shouldApply behaviors', () {
        final hovered = ContextVariant.widgetState(WidgetState.hovered);
        final pressed = ContextVariant.widgetState(WidgetState.pressed);

        // The functions should be different even if they might return the same result
        expect(hovered.shouldApply != pressed.shouldApply, isTrue);
      });
    });

    group('Predefined widget state variants', () {
      test('predefined variants are ContextVariants with trackedState', () {
        expect(
          ContextVariant.widgetState(WidgetState.hovered),
          isA<ContextVariant>(),
        );
        expect(
          ContextVariant.widgetState(WidgetState.hovered).trackedState,
          isNotNull,
        );
        expect(
          ContextVariant.widgetState(WidgetState.pressed),
          isA<ContextVariant>(),
        );
        expect(
          ContextVariant.widgetState(WidgetState.focused),
          isA<ContextVariant>(),
        );
        expect(
          ContextVariant.widgetState(WidgetState.disabled),
          isA<ContextVariant>(),
        );
        expect(
          ContextVariant.widgetState(WidgetState.selected),
          isA<ContextVariant>(),
        );
        expect(
          ContextVariant.widgetState(WidgetState.dragged),
          isA<ContextVariant>(),
        );
        expect(
          ContextVariant.widgetState(WidgetState.error),
          isA<ContextVariant>(),
        );
      });

      test('predefined variants have correct trackedState', () {
        expect(
          ContextVariant.widgetState(WidgetState.hovered).trackedState,
          WidgetState.hovered,
        );
        expect(
          ContextVariant.widgetState(WidgetState.pressed).trackedState,
          WidgetState.pressed,
        );
        expect(
          ContextVariant.widgetState(WidgetState.focused).trackedState,
          WidgetState.focused,
        );
        expect(
          ContextVariant.widgetState(WidgetState.disabled).trackedState,
          WidgetState.disabled,
        );
        expect(
          ContextVariant.widgetState(WidgetState.selected).trackedState,
          WidgetState.selected,
        );
        expect(
          ContextVariant.widgetState(WidgetState.dragged).trackedState,
          WidgetState.dragged,
        );
        expect(
          ContextVariant.widgetState(WidgetState.error).trackedState,
          WidgetState.error,
        );
      });

      test('predefined variants have correct keys', () {
        expect(
          ContextVariant.widgetState(WidgetState.hovered).key,
          'widget_state_hovered',
        );
        expect(
          ContextVariant.widgetState(WidgetState.pressed).key,
          'widget_state_pressed',
        );
        expect(
          ContextVariant.widgetState(WidgetState.focused).key,
          'widget_state_focused',
        );
        expect(
          ContextVariant.widgetState(WidgetState.disabled).key,
          'widget_state_disabled',
        );
        expect(
          ContextVariant.widgetState(WidgetState.selected).key,
          'widget_state_selected',
        );
        expect(
          ContextVariant.widgetState(WidgetState.dragged).key,
          'widget_state_dragged',
        );
        expect(
          ContextVariant.widgetState(WidgetState.error).key,
          'widget_state_error',
        );
      });

      test('predefined enabled variant uses NOT logic', () {
        final disabled = ContextVariant.widgetState(WidgetState.disabled);
        final enabled = ContextVariant.not(disabled);

        expect(enabled, isA<ContextVariant>());
        expect(enabled.key, contains('not'));
      });

      test('predefined unselected variant uses NOT logic', () {
        final selected = ContextVariant.widgetState(WidgetState.selected);
        final unselected = ContextVariant.not(selected);

        expect(unselected, isA<ContextVariant>());
        expect(unselected.key, contains('not'));
      });
    });

    group('Complex widget state scenarios', () {
      test('multiple widget states can be applied separately', () {
        final hovered = ContextVariant.widgetState(WidgetState.hovered);
        final pressed = ContextVariant.widgetState(WidgetState.pressed);

        // Test they are distinct variants
        expect(hovered.key, isNot(equals(pressed.key)));
        expect(hovered.trackedState, isNot(equals(pressed.trackedState)));
      });

      test('widget states can combine with named variants', () {
        final hovered = ContextVariant.widgetState(WidgetState.hovered);
        const primary = NamedVariant('primary');

        // Test they are different types of variants
        expect(hovered, isA<ContextVariant>());
        expect(hovered.trackedState, isNotNull);
        expect(primary, isA<NamedVariant>());
        expect(hovered.key, isNot(equals(primary.key)));
      });

      test('negated widget states work correctly', () {
        final hovered = ContextVariant.widgetState(WidgetState.hovered);
        final notHovered = ContextVariant.not(hovered);

        expect(notHovered, isA<ContextVariant>());
        expect(notHovered.key, contains('not'));
      });

      test('enabled variant is opposite of disabled', () {
        final disabled = ContextVariant.widgetState(WidgetState.disabled);
        final enabled = ContextVariant.not(disabled);
        final hover = ContextVariant.widgetState(WidgetState.hovered);

        // Test they are distinct
        expect(enabled.key, isNot(equals(disabled.key)));
        expect(enabled.key, isNot(equals(hover.key)));
      });
    });

    group('VariantSpecAttribute integration', () {
      test('can be used in VariantSpecAttribute wrapper', () {
        final hoverVariant = ContextVariant.widgetState(WidgetState.hovered);
        final style = BoxStyler().width(100.0);
        final variantAttr = VariantStyle<BoxSpec>(hoverVariant, style);

        expect(variantAttr.variant, hoverVariant);
        expect(variantAttr.value, style);
        expect(variantAttr.mergeKey, hoverVariant.key);
      });

      test(
        'different widget states create different VariantSpecAttribute mergeKeys',
        () {
          final hoverStyle = VariantStyle<BoxSpec>(
            ContextVariant.widgetState(WidgetState.hovered),
            BoxStyler().width(100.0),
          );

          final pressStyle = VariantStyle<BoxSpec>(
            ContextVariant.widgetState(WidgetState.pressed),
            BoxStyler().width(150.0),
          );

          expect(hoverStyle.mergeKey, isNot(equals(pressStyle.mergeKey)));
          expect(hoverStyle.mergeKey, 'widget_state_hovered');
          expect(pressStyle.mergeKey, 'widget_state_pressed');
        },
      );

      test('merges correctly when variants match', () {
        final hoverVariant = ContextVariant.widgetState(WidgetState.hovered);

        final style1 = VariantStyle<BoxSpec>(
          hoverVariant,
          BoxStyler().width(100.0),
        );

        final style2 = VariantStyle<BoxSpec>(
          hoverVariant,
          BoxStyler().height(200.0),
        );

        final merged = style1.merge(style2);

        expect(merged.variant, hoverVariant);
        final mergedBox = merged.value as BoxStyler;
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
          expect(() => ContextVariant.widgetState(state), returnsNormally);
          final variant = ContextVariant.widgetState(state);
          expect(variant.trackedState, state);
          expect(variant.key, contains(state.name));
        }
      });

      test('trackedState property is consistent', () {
        final variant1 = ContextVariant.widgetState(WidgetState.hovered);
        final variant2 = ContextVariant.widgetState(WidgetState.hovered);

        expect(variant1.trackedState, equals(variant2.trackedState));
        expect(variant1.trackedState, WidgetState.hovered);
        expect(variant2.trackedState, WidgetState.hovered);
      });

      test('key property is consistent', () {
        final variant1 = ContextVariant.widgetState(WidgetState.hovered);
        final variant2 = ContextVariant.widgetState(WidgetState.hovered);

        expect(variant1.key, equals(variant2.key));
        expect(variant1.key, 'widget_state_hovered');
        expect(variant2.key, 'widget_state_hovered');
      });
    });
  });
}
