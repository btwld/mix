import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('VariantStyle', () {
    group('Constructor', () {
      test('creates NamedVariant with name and style', () {
        final style = BoxStyler().width(100.0);
        final variant = NamedVariant('primary', style);

        expect(variant.name, 'primary');
        expect(variant.style, style);
        expect(variant.key, 'primary');
      });

      test('creates TriggerVariant with ContextTrigger', () {
        final trigger = ContextTrigger.widgetState(WidgetState.hovered);
        final style = BoxStyler().height(200.0);
        final variant = TriggerVariant(trigger, style);

        expect(variant.trigger, trigger);
        expect(variant.style, style);
        expect(variant.key, 'widget_state_hovered');
      });

      test('creates VariantBuilder with function', () {
        final variant = VariantBuilder<BoxSpec>(
          (context) => BoxStyler().width(150.0),
        );

        expect(variant.builder, isA<Function>());
        expect(variant.key, isA<String>());
      });
    });

    group('NamedVariant matching', () {
      test('matches when name is in the provided list', () {
        final variant = NamedVariant('primary', BoxStyler().width(100.0));

        const variantNames = ['primary', 'secondary'];
        expect(variant.matches(variantNames), isTrue);
      });

      test('does not match when name is not in the provided list', () {
        final variant = NamedVariant('tertiary', BoxStyler().width(100.0));

        const variantNames = ['primary', 'secondary'];
        expect(variant.matches(variantNames), isFalse);
      });

      test('matches empty list returns false', () {
        final variant = NamedVariant('primary', BoxStyler().width(100.0));

        expect(variant.matches([]), isFalse);
      });

      test('TriggerVariant isActive with context', () {
        final trigger = ContextTrigger('test', (context) => true);
        final variant = TriggerVariant(trigger, BoxStyler().width(100.0));

        // Should be active when trigger condition is true
        final context = MockBuildContext();
        expect(variant.isActive(context), isTrue);

        final falseTrigger = ContextTrigger('false', (context) => false);
        final falseVariant = TriggerVariant(falseTrigger, BoxStyler().width(100.0));
        expect(falseVariant.isActive(context), isFalse);
      });
    });

    group('NamedVariant removeVariants method', () {
      test('returns null when removing the variant', () {
        final variant = NamedVariant('primary', BoxStyler().width(100.0));

        const variantsToRemove = ['primary'];
        final result = variant.removeVariants(variantsToRemove);

        expect(result, isNull);
      });

      test('returns same instance when variant not in removal list', () {
        final variant = NamedVariant('primary', BoxStyler().width(100.0));

        const variantsToRemove = ['secondary'];
        final result = variant.removeVariants(variantsToRemove);

        expect(result, same(variant));
      });

      test('handles variant removal correctly', () {
        final variant = NamedVariant('primary', BoxStyler().width(100.0));

        const variantsToRemove = ['primary'];
        final result = variant.removeVariants(variantsToRemove);

        expect(result, isNull);
      });

      test('returns variant when name not in removal list', () {
        final variant = NamedVariant('primary', BoxStyler().width(100.0));

        const variantsToRemove = ['secondary'];
        final result = variant.removeVariants(variantsToRemove);

        expect(result, isNotNull);
        expect(result!.name, 'primary');
      });

      test('returns null when variant name is removed', () {
        final variant = NamedVariant('primary', BoxStyler().width(100.0));

        const variantsToRemove = ['primary'];
        final result = variant.removeVariants(variantsToRemove);

        expect(result, isNull);
      });

      test('TriggerVariant does not have removeVariants method', () {
        final trigger = ContextTrigger('test', (context) => true);
        final variant = TriggerVariant(trigger, BoxStyler().width(100.0));

        // TriggerVariant doesn't have removeVariants method since it's trigger-based
        expect(variant.trigger, same(trigger));
        expect(variant.key, 'test');
      });
    });

    group('NamedVariant merge method', () {
      test('merges styles when variants match', () {
        final style1 = BoxStyler().width(100.0);
        final style2 = BoxStyler().height(200.0);

        final variant1 = NamedVariant('primary', style1);
        final variant2 = NamedVariant('primary', style2);

        final merged = variant1.merge(variant2);

        expect(merged.name, 'primary');
        final context = MockBuildContext();
        final resolvedSpec = merged.style.resolve(context);
        final constraints = resolvedSpec.spec.constraints;
        expect(constraints?.minWidth, 100.0);
        expect(constraints?.maxWidth, 100.0);
        expect(constraints?.minHeight, 200.0);
        expect(constraints?.maxHeight, 200.0);
      });

      test('throws when variant names do not match', () {
        final style1 = BoxStyler().width(100.0);
        final style2 = BoxStyler().height(200.0);

        final variant1 = NamedVariant('primary', style1);
        final variant2 = NamedVariant('secondary', style2);

        expect(
          () => variant1.merge(variant2),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('Cannot merge NamedVariant with different keys'),
            ),
          ),
        );
      });

      test('returns this when other is null', () {
        final variant = NamedVariant('primary', BoxStyler().width(100.0));

        final merged = variant.merge(null);

        expect(merged, equals(variant));
      });

      test('merges with overlapping properties - other takes precedence', () {
        final style1 = BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: 100.0,
            maxWidth: 100.0,
            minHeight: 150.0,
            maxHeight: 150.0,
          ),
        );
        final style2 = BoxStyler().width(200.0);

        final variant1 = NamedVariant('primary', style1);
        final variant2 = NamedVariant('primary', style2);

        final merged = variant1.merge(variant2);

        expect(merged.name, 'primary');
        final context = MockBuildContext();
        final resolvedSpec = merged.style.resolve(context);
        final constraints = resolvedSpec.spec.constraints;
        expect(constraints?.minWidth, 200.0); // other overrides
        expect(constraints?.maxWidth, 200.0); // other overrides
        expect(constraints?.minHeight, 150.0); // from first
        expect(constraints?.maxHeight, 150.0); // from first
      });
    });

    group('Equality', () {
      test('equal NamedVariants have same hashCode', () {
        final style = BoxStyler().width(100.0);

        final variant1 = NamedVariant('primary', style);
        final variant2 = NamedVariant('primary', style);

        expect(variant1, equals(variant2));
        expect(variant1.hashCode, equals(variant2.hashCode));
      });

      test('different variant names are not equal', () {
        final style = BoxStyler().width(100.0);

        final variant1 = NamedVariant('primary', style);
        final variant2 = NamedVariant('secondary', style);

        expect(variant1, isNot(equals(variant2)));
      });

      test('different styles are not equal', () {
        final style1 = BoxStyler().width(100.0);
        final style2 = BoxStyler().width(200.0);

        final variant1 = NamedVariant('primary', style1);
        final variant2 = NamedVariant('primary', style2);

        expect(variant1, isNot(equals(variant2)));
      });

      test('identical instances are equal', () {
        final variant = NamedVariant('primary', BoxStyler().width(100.0));

        expect(variant, equals(variant));
        expect(identical(variant, variant), isTrue);
      });
    });

    group('key property', () {
      test('NamedVariant uses name as key', () {
        final variant = NamedVariant('primary', BoxStyler().width(100.0));

        expect(variant.key, 'primary');
      });

      test('TriggerVariant uses trigger key as key', () {
        final trigger = ContextTrigger.widgetState(WidgetState.hovered);
        final variant = TriggerVariant(trigger, BoxStyler().width(100.0));

        expect(variant.key, 'widget_state_hovered');
      });

      test('VariantBuilder uses builder hashCode as key', () {
        final variant = VariantBuilder<BoxSpec>(
          (context) => BoxStyler().width(100.0),
        );

        expect(variant.key, isA<String>());
      });
    });

    group('Different Spec Types', () {
      test('works with TextStyler', () {
        final textStyle = TextStyler(textAlign: TextAlign.center, maxLines: 2);
        final variant = NamedVariant('large', textStyle);

        expect(variant.name, 'large');
        expect(variant.style, textStyle);
        final context = MockBuildContext();
        final resolvedSpec = variant.style.resolve(context);
        expect(resolvedSpec.spec.textAlign, TextAlign.center);
        expect(resolvedSpec.spec.maxLines, 2);
      });

      test('works with ImageStyler', () {
        final imageStyle = ImageStyler(
          width: 50.0,
          height: 50.0,
          fit: BoxFit.cover,
        );
        final variant = NamedVariant('avatar', imageStyle);

        expect(variant.name, 'avatar');
        expect(variant.style, imageStyle);
        final context = MockBuildContext();
        final resolvedSpec = variant.style.resolve(context);
        expect(resolvedSpec.spec.width, 50.0);
        expect(resolvedSpec.spec.height, 50.0);
        expect(resolvedSpec.spec.fit, BoxFit.cover);
      });
    });

    group('Complex Scenarios', () {
      test('different trigger variants', () {
        final trigger1 = ContextTrigger.widgetState(WidgetState.hovered);
        final trigger2 = ContextTrigger.brightness(Brightness.dark);

        final style = BoxStyler().width(100.0);
        final variant1 = TriggerVariant(trigger1, style);
        final variant2 = TriggerVariant(trigger2, style);

        expect(variant1.trigger, trigger1);
        expect(variant2.trigger, trigger2);
        expect(variant1.style, style);
        expect(variant2.style, style);
        expect(variant1.key, 'widget_state_hovered');
        expect(variant2.key, 'media_query_platform_brightness_dark');
      });

      test('different variant types have different behaviors', () {
        final trigger = ContextTrigger.widgetState(WidgetState.hovered);
        final triggerVariant = TriggerVariant(trigger, BoxStyler().width(100.0));
        final namedVariant = NamedVariant('primary', BoxStyler().width(200.0));

        // TriggerVariant is context-based
        expect(triggerVariant.key, 'widget_state_hovered');
        expect(triggerVariant.trigger, trigger);

        // NamedVariant is name-based
        expect(namedVariant.key, 'primary');
        expect(namedVariant.name, 'primary');
      });
    });
  });
}
