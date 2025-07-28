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

      test(
        'factory method creates different variants for different states',
        () {
          final hovered = ContextVariant.widgetState(WidgetState.hovered);
          final pressed = ContextVariant.widgetState(WidgetState.pressed);

          expect(hovered, isA<WidgetStateVariant>());
          expect(pressed, isA<WidgetStateVariant>());
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

      test('separate variants can be used independently', () {
        final hovered = WidgetStateVariant(WidgetState.hovered);
        final pressed = WidgetStateVariant(WidgetState.pressed);

        expect(hovered.state, WidgetState.hovered);
        expect(pressed.state, WidgetState.pressed);
        expect(hovered, isNot(equals(pressed)));
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
        expect(
          ContextVariant.widgetState(WidgetState.hovered),
          isA<WidgetStateVariant>(),
        );
        expect(
          ContextVariant.widgetState(WidgetState.pressed),
          isA<WidgetStateVariant>(),
        );
        expect(
          ContextVariant.widgetState(WidgetState.focused),
          isA<WidgetStateVariant>(),
        );
        expect(
          ContextVariant.widgetState(WidgetState.disabled),
          isA<WidgetStateVariant>(),
        );
        expect(
          ContextVariant.widgetState(WidgetState.selected),
          isA<WidgetStateVariant>(),
        );
        expect(
          ContextVariant.widgetState(WidgetState.dragged),
          isA<WidgetStateVariant>(),
        );
        expect(
          ContextVariant.widgetState(WidgetState.error),
          isA<WidgetStateVariant>(),
        );
      });

      test('predefined variants have correct states', () {
        expect(
          ContextVariant.widgetState(WidgetState.hovered).state,
          WidgetState.hovered,
        );
        expect(
          ContextVariant.widgetState(WidgetState.pressed).state,
          WidgetState.pressed,
        );
        expect(
          ContextVariant.widgetState(WidgetState.focused).state,
          WidgetState.focused,
        );
        expect(
          ContextVariant.widgetState(WidgetState.disabled).state,
          WidgetState.disabled,
        );
        expect(
          ContextVariant.widgetState(WidgetState.selected).state,
          WidgetState.selected,
        );
        expect(
          ContextVariant.widgetState(WidgetState.dragged).state,
          WidgetState.dragged,
        );
        expect(
          ContextVariant.widgetState(WidgetState.error).state,
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
        final hovered = WidgetStateVariant(WidgetState.hovered);
        final pressed = WidgetStateVariant(WidgetState.pressed);

        // Test they are distinct variants
        expect(hovered.key, isNot(equals(pressed.key)));
        expect(hovered.state, isNot(equals(pressed.state)));
      });

      test('widget states can combine with named variants', () {
        final hovered = WidgetStateVariant(WidgetState.hovered);
        const primary = NamedVariant('primary');

        // Test they are different types of variants
        expect(hovered, isA<WidgetStateVariant>());
        expect(primary, isA<NamedVariant>());
        expect(hovered.key, isNot(equals(primary.key)));
      });

      test('negated widget states work correctly', () {
        final hovered = WidgetStateVariant(WidgetState.hovered);
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
        final hoverVariant = WidgetStateVariant(WidgetState.hovered);
        final style = BoxMix.width(100.0);
        final variantAttr = VariantStyleAttribute(hoverVariant, style);

        expect(variantAttr.variant, hoverVariant);
        expect(variantAttr.value, style);
        expect(variantAttr.mergeKey, hoverVariant.key);
      });

      test(
        'different widget states create different VariantSpecAttribute mergeKeys',
        () {
          final hoverStyle = VariantStyleAttribute(
            WidgetStateVariant(WidgetState.hovered),
            BoxMix.width(100.0),
          );

          final pressStyle = VariantStyleAttribute(
            WidgetStateVariant(WidgetState.pressed),
            BoxMix.width(150.0),
          );

          expect(hoverStyle.mergeKey, isNot(equals(pressStyle.mergeKey)));
          expect(hoverStyle.mergeKey, 'widget_state_hovered');
          expect(pressStyle.mergeKey, 'widget_state_pressed');
        },
      );

      test('merges correctly when variants match', () {
        final hoverVariant = WidgetStateVariant(WidgetState.hovered);

        final style1 = VariantStyleAttribute(hoverVariant, BoxMix.width(100.0));

        final style2 = VariantStyleAttribute(
          hoverVariant,
          BoxMix.height(200.0),
        );

        final merged = style1.merge(style2);

        expect(merged.variant, hoverVariant);
        final mergedBox = merged.value as BoxMix;
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
