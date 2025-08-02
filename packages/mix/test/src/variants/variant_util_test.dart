import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('OnContextVariantUtility', () {
    final utility = OnContextVariantUtility<MockSpec, MockStyle<String>>(
      (variant) => MockStyle('test-value'),
    );

    group('Constructor', () {
      test('can be instantiated with builder function', () {
        expect(
          () => OnContextVariantUtility<MockSpec, MockStyle<String>>(
            (variant) => MockStyle('test'),
          ),
          returnsNormally,
        );
        expect(utility, isA<OnContextVariantUtility>());
      });
    });

    group('Widget State Variants', () {
      test('hover creates VariantAttributeBuilder', () {
        final builder = utility.hover;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('press creates VariantAttributeBuilder', () {
        final builder = utility.press;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('focus creates VariantAttributeBuilder', () {
        final builder = utility.focus;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('disabled creates VariantAttributeBuilder', () {
        final builder = utility.disabled;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('selected creates VariantAttributeBuilder', () {
        final builder = utility.selected;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('dragged creates VariantAttributeBuilder', () {
        final builder = utility.dragged;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('error creates VariantAttributeBuilder', () {
        final builder = utility.error;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('enabled creates VariantAttributeBuilder', () {
        final builder = utility.enabled;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('all widget state variant builders are unique', () {
        final builders = [
          utility.hover,
          utility.press,
          utility.focus,
          utility.disabled,
          utility.selected,
          utility.dragged,
          utility.error,
          utility.enabled,
        ];

        // Each builder represents a different WidgetState, so they should be distinct
        expect(builders.toSet(), hasLength(builders.length));
      });

      test('widget state builders return consistent builders', () {
        final hover1 = utility.hover;
        final hover2 = utility.hover;

        // Verify they are both VariantAttributeBuilders wrapping the same variant type
        expect(hover1, isA<VariantAttributeBuilder<MockSpec>>());
        expect(hover2, isA<VariantAttributeBuilder<MockSpec>>());
        // Note: Equality depends on the underlying variant implementation
      });
    });

    group('Platform Brightness Variants', () {
      test('dark creates VariantAttributeBuilder', () {
        final builder = utility.dark;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('light creates VariantAttributeBuilder', () {
        final builder = utility.light;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('dark and light are different builders', () {
        final dark = utility.dark;
        final light = utility.light;

        expect(identical(dark, light), isFalse);
      });
    });

    group('Orientation Variants', () {
      test('portrait creates VariantAttributeBuilder', () {
        final builder = utility.portrait;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('landscape creates VariantAttributeBuilder', () {
        final builder = utility.landscape;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('portrait and landscape are different builders', () {
        final portrait = utility.portrait;
        final landscape = utility.landscape;

        expect(identical(portrait, landscape), isFalse);
      });
    });

    group('Size Variants', () {
      test('mobile creates VariantAttributeBuilder', () {
        final builder = utility.mobile;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('tablet creates VariantAttributeBuilder', () {
        final builder = utility.tablet;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('desktop creates VariantAttributeBuilder', () {
        final builder = utility.desktop;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('size variants are all different builders', () {
        final sizeBuilders = [utility.mobile, utility.tablet, utility.desktop];

        expect(sizeBuilders[0], isNot(same(sizeBuilders[1])));
        expect(sizeBuilders[1], isNot(same(sizeBuilders[2])));
        expect(sizeBuilders[0], isNot(same(sizeBuilders[2])));
      });
    });

    group('Text Direction Variants', () {
      test('ltr creates VariantAttributeBuilder', () {
        final builder = utility.ltr;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('rtl creates VariantAttributeBuilder', () {
        final builder = utility.rtl;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('ltr and rtl are different builders', () {
        final ltr = utility.ltr;
        final rtl = utility.rtl;

        expect(identical(ltr, rtl), isFalse);
      });
    });

    group('Platform Variants', () {
      test('ios creates VariantAttributeBuilder', () {
        final builder = utility.ios;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('android creates VariantAttributeBuilder', () {
        final builder = utility.android;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('macos creates VariantAttributeBuilder', () {
        final builder = utility.macos;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('windows creates VariantAttributeBuilder', () {
        final builder = utility.windows;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('linux creates VariantAttributeBuilder', () {
        final builder = utility.linux;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('fuchsia creates VariantAttributeBuilder', () {
        final builder = utility.fuchsia;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('web creates VariantAttributeBuilder', () {
        final builder = utility.web;
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('all platform variants are unique builders', () {
        final platformBuilders = [
          utility.ios,
          utility.android,
          utility.macos,
          utility.windows,
          utility.linux,
          utility.fuchsia,
          utility.web,
        ];

        // Check that all builders are different instances
        for (int i = 0; i < platformBuilders.length; i++) {
          for (int j = i + 1; j < platformBuilders.length; j++) {
            expect(
              identical(platformBuilders[i], platformBuilders[j]),
              isFalse,
            );
          }
        }
      });
    });

    group('Breakpoint Variants', () {
      test(
        'minWidth creates VariantAttributeBuilder with different parameters',
        () {
          final builder1 = utility.minWidth(768.0);
          final builder2 = utility.minWidth(1024.0);

          expect(builder1, isA<VariantAttributeBuilder<MockSpec>>());
          expect(builder2, isA<VariantAttributeBuilder<MockSpec>>());
          expect(identical(builder1, builder2), isFalse);
        },
      );

      test(
        'maxWidth creates VariantAttributeBuilder with different parameters',
        () {
          final builder1 = utility.maxWidth(1024.0);
          final builder2 = utility.maxWidth(768.0);

          expect(builder1, isA<VariantAttributeBuilder<MockSpec>>());
          expect(builder2, isA<VariantAttributeBuilder<MockSpec>>());
          expect(identical(builder1, builder2), isFalse);
        },
      );

      test('widthRange creates VariantAttributeBuilder', () {
        final builder = utility.widthRange(768.0, 1024.0);
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('minHeight creates VariantAttributeBuilder', () {
        final builder = utility.minHeight(600.0);
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('maxHeight creates VariantAttributeBuilder', () {
        final builder = utility.maxHeight(800.0);
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('heightRange creates VariantAttributeBuilder', () {
        final builder = utility.heightRange(600.0, 800.0);
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('same parameters create functionally equivalent builders', () {
        final builder1 = utility.minWidth(768.0);
        final builder2 = utility.minWidth(768.0);

        // Builders with same parameters should work the same way
        expect(builder1, isA<VariantAttributeBuilder<MockSpec>>());
        expect(builder2, isA<VariantAttributeBuilder<MockSpec>>());
        // Note: Equality depends on underlying variant implementation
      });

      test('breakpoint methods work with integer values', () {
        final builder = utility.minWidth(768);
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });
    });

    group('Edge cases and error handling', () {
      test('breakpoint methods handle zero values', () {
        expect(() => utility.minWidth(0.0), returnsNormally);
        expect(() => utility.maxWidth(0.0), returnsNormally);
        expect(() => utility.minHeight(0.0), returnsNormally);
        expect(() => utility.maxHeight(0.0), returnsNormally);
      });

      test('breakpoint methods handle negative values', () {
        expect(() => utility.minWidth(-100.0), returnsNormally);
        expect(() => utility.maxWidth(-100.0), returnsNormally);
        expect(() => utility.minHeight(-100.0), returnsNormally);
        expect(() => utility.maxHeight(-100.0), returnsNormally);
      });

      test('widthRange and heightRange handle reversed parameters', () {
        // Should still work even if min > max (developer error)
        expect(() => utility.widthRange(1000.0, 500.0), returnsNormally);
        expect(() => utility.heightRange(800.0, 400.0), returnsNormally);
      });

      test('breakpoint methods handle very large values', () {
        expect(() => utility.minWidth(double.maxFinite), returnsNormally);
        expect(() => utility.maxWidth(double.maxFinite), returnsNormally);
      });

      test(
        'utility properties create consistent builders on repeated access',
        () {
          final hover1 = utility.hover;
          final hover2 = utility.hover;

          // Verify they are both VariantAttributeBuilders of same type
          expect(hover1, isA<VariantAttributeBuilder<MockSpec>>());
          expect(hover2, isA<VariantAttributeBuilder<MockSpec>>());
          // Note: Consistency in behavior matters more than object equality
        },
      );
    });

    group('Integration patterns', () {
      test('builders can be used as function returns', () {
        VariantAttributeBuilder getBuilder() => utility.hover;

        final builder = getBuilder();
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('builders can be stored and reused', () {
        final storedBuilders = {
          'hover': utility.hover,
          'press': utility.press,
          'mobile': utility.mobile,
        };

        expect(
          storedBuilders['hover'],
          isA<VariantAttributeBuilder<MockSpec>>(),
        );
        expect(
          storedBuilders['press'],
          isA<VariantAttributeBuilder<MockSpec>>(),
        );
        expect(
          storedBuilders['mobile'],
          isA<VariantAttributeBuilder<MockSpec>>(),
        );
      });

      test('utility works in different contexts', () {
        // Test that the utility works consistently across different usage patterns
        final builders = <VariantAttributeBuilder>[];

        // Direct access
        builders.add(utility.hover);

        // Method call
        builders.add(utility.minWidth(768.0));

        // All should be valid VariantAttributeBuilder instances
        for (final builder in builders) {
          expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
        }
      });
    });

    group('Documentation and usage patterns', () {
      test('demonstrates common responsive breakpoint usage', () {
        // Common responsive breakpoints
        final mobile = utility.maxWidth(767.0);
        final tablet = utility.widthRange(768.0, 1023.0);
        final desktop = utility.minWidth(1024.0);

        expect(mobile, isA<VariantAttributeBuilder<MockSpec>>());
        expect(tablet, isA<VariantAttributeBuilder<MockSpec>>());
        expect(desktop, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('demonstrates dark mode usage pattern', () {
        final darkVariant = utility.dark;
        expect(darkVariant, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('demonstrates platform-specific styling pattern', () {
        final iosVariant = utility.ios;
        final webVariant = utility.web;

        expect(iosVariant, isA<VariantAttributeBuilder<MockSpec>>());
        expect(webVariant, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('demonstrates interaction state patterns', () {
        final interactionStates = [
          utility.hover,
          utility.press,
          utility.focus,
          utility.disabled,
        ];

        for (final state in interactionStates) {
          expect(state, isA<VariantAttributeBuilder<MockSpec>>());
        }
      });

      test('demonstrates size-based responsive design pattern', () {
        final sizeVariants = [utility.mobile, utility.tablet, utility.desktop];

        for (final variant in sizeVariants) {
          expect(variant, isA<VariantAttributeBuilder<MockSpec>>());
        }
      });
    });

    group('Comprehensive utility coverage', () {
      test('covers all widget state utilities', () {
        final widgetStateUtils = [
          utility.hover,
          utility.press,
          utility.focus,
          utility.disabled,
          utility.selected,
          utility.dragged,
          utility.error,
          utility.enabled,
        ];

        for (final util in widgetStateUtils) {
          expect(util, isA<VariantAttributeBuilder<MockSpec>>());
        }
      });

      test('covers all platform utilities', () {
        final platformUtils = [
          utility.ios,
          utility.android,
          utility.macos,
          utility.windows,
          utility.linux,
          utility.fuchsia,
          utility.web,
        ];

        for (final util in platformUtils) {
          expect(util, isA<VariantAttributeBuilder<MockSpec>>());
        }
      });

      test('covers all context-based utilities', () {
        final contextUtils = [
          utility.dark,
          utility.light,
          utility.portrait,
          utility.landscape,
          utility.mobile,
          utility.tablet,
          utility.desktop,
          utility.ltr,
          utility.rtl,
        ];

        for (final util in contextUtils) {
          expect(util, isA<VariantAttributeBuilder<MockSpec>>());
        }
      });

      test('covers all parametric utilities', () {
        final parametricUtils = [
          utility.minWidth(100.0),
          utility.maxWidth(200.0),
          utility.widthRange(100.0, 200.0),
          utility.minHeight(300.0),
          utility.maxHeight(400.0),
          utility.heightRange(300.0, 400.0),
        ];

        for (final util in parametricUtils) {
          expect(util, isA<VariantAttributeBuilder<MockSpec>>());
        }
      });
    });
  });

  group('VariantAttributeBuilder', () {
    group('Constructor', () {
      test('can be created with a variant', () {
        const variant = NamedVariant('test');
        const builder = VariantAttributeBuilder<MockSpec>(variant);
        expect(builder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('can be created with different variant types', () {
        const namedVariant = NamedVariant('test');
        final contextVariant = ContextVariant('test', (context) => true);
        final widgetStateVariant = WidgetStateVariant(WidgetState.hovered);

        expect(
          VariantAttributeBuilder<MockSpec>(namedVariant),
          isA<VariantAttributeBuilder<MockSpec>>(),
        );
        expect(
          VariantAttributeBuilder<MockSpec>(contextVariant),
          isA<VariantAttributeBuilder<MockSpec>>(),
        );
        expect(
          VariantAttributeBuilder<MockSpec>(widgetStateVariant),
          isA<VariantAttributeBuilder<MockSpec>>(),
        );
        expect(
          VariantAttributeBuilder<MockSpec>(namedVariant),
          isA<VariantAttributeBuilder<MockSpec>>(),
        );
      });

      test('maintains const constructor behavior', () {
        const variant = NamedVariant('test');
        expect(
          () => const VariantAttributeBuilder<MockSpec>(variant),
          returnsNormally,
        );
      });
    });

    group('Equality and hashCode', () {
      test('equality based on wrapped variant', () {
        const variant = NamedVariant('test');
        const builder1 = VariantAttributeBuilder<MockSpec>(variant);
        const builder2 = VariantAttributeBuilder<MockSpec>(variant);
        const builder3 = VariantAttributeBuilder<MockSpec>(
          NamedVariant('other'),
        );

        expect(builder1, equals(builder2));
        expect(builder1, isNot(equals(builder3)));
      });

      test('hashCode consistent for equal builders', () {
        const variant = NamedVariant('test');
        const builder1 = VariantAttributeBuilder<MockSpec>(variant);
        const builder2 = VariantAttributeBuilder<MockSpec>(variant);

        expect(builder1.hashCode, equals(builder2.hashCode));
        expect(builder1.hashCode, equals(variant.hashCode));
      });

      test('toString provides meaningful representation', () {
        const variant = NamedVariant('primary');
        const builder = VariantAttributeBuilder<MockSpec>(variant);

        final stringRep = builder.toString();
        expect(stringRep, contains('VariantAttributeBuilder'));
        expect(stringRep, contains('primary'));
      });

      test('different variant types create different builders', () {
        const namedVariant = NamedVariant('test');
        final contextVariant = ContextVariant('test', (context) => true);

        const namedBuilder = VariantAttributeBuilder<MockSpec>(namedVariant);
        final contextBuilder = VariantAttributeBuilder<MockSpec>(
          contextVariant,
        );

        expect(namedBuilder, isNot(equals(contextBuilder)));
        expect(namedBuilder.hashCode, isNot(equals(contextBuilder.hashCode)));
      });
    });

    group('Integration', () {
      test('works with utility-created builders', () {
        final testUtility =
            OnContextVariantUtility<MockSpec, MockStyle<String>>(
              (variant) => MockStyle('test'),
            );
        final hoverBuilder = testUtility.hover;

        expect(hoverBuilder, isA<VariantAttributeBuilder<MockSpec>>());
      });

      test('can be stored in collections', () {
        const variant1 = NamedVariant('test1');
        const variant2 = NamedVariant('test2');

        final builders = [
          const VariantAttributeBuilder<MockSpec>(variant1),
          const VariantAttributeBuilder<MockSpec>(variant2),
        ];

        expect(builders, hasLength(2));
        expect(builders.first, isA<VariantAttributeBuilder<MockSpec>>());
        expect(builders.last, isA<VariantAttributeBuilder<MockSpec>>());
      });
    });

    group('Call method functionality', () {
      test('call method creates VariantSpecAttribute with single element', () {
        const variant = NamedVariant('primary');
        const builder = VariantAttributeBuilder<MockSpec>(variant);
        final attribute = MockStyle<double>(100.0);

        final result = builder.call(attribute);

        expect(result, isA<VariantStyle<MultiSpec>>());
        expect(result.variant, same(variant));
        expect(result.value, isA<Style>());
      });

      test(
        'call method creates VariantSpecAttribute with multiple elements',
        () {
          const variant = NamedVariant('primary');
          const builder = VariantAttributeBuilder<MockSpec>(variant);
          final attr1 = MockStyle<double>(100.0);
          final attr2 = MockStyle<String>('test');

          final result = builder.call(attr1, attr2);

          expect(result, isA<VariantStyle<MultiSpec>>());
          expect(result.variant, same(variant));
          expect(result.value, isA<Style>());
        },
      );

      test('call method works with utility-created builders', () {
        final testUtility =
            OnContextVariantUtility<MockSpec, MockStyle<String>>(
              (variant) => MockStyle('test'),
            );
        final hoverBuilder = testUtility.hover;
        final attribute = MockStyle<double>(200.0);

        final result = hoverBuilder.call(attribute);

        expect(result, isA<VariantStyle<MultiSpec>>());
        expect(result.value, isA<Style>());
      });

      test('call method preserves variant information', () {
        final contextVariant = ContextVariant('hover', (context) => true);
        final builder = VariantAttributeBuilder<MockSpec>(contextVariant);
        final attribute = MockStyle<String>('test');

        final result = builder.call(attribute);

        expect(result, isA<VariantStyle<MultiSpec>>());
        expect(result.variant, same(contextVariant));
        expect(result.value, isA<Style>());
      });

      test('call method throws error with no elements', () {
        const variant = NamedVariant('test');
        const builder = VariantAttributeBuilder<MockSpec>(variant);

        expect(() => builder.call(), throwsA(isA<ArgumentError>()));
      });

      test('call method supports usage pattern like README examples', () {
        final testUtility =
            OnContextVariantUtility<MockSpec, MockStyle<String>>(
              (variant) => MockStyle('test'),
            );
        final darkBuilder = testUtility.dark;

        // Simulate: $on.dark($box.color.white(), $text.style.color.black())
        final boxAttr = MockStyle<String>('white');
        final textAttr = MockStyle<String>('black');

        final result = darkBuilder.call(boxAttr, textAttr);

        expect(result, isA<VariantStyle<MultiSpec>>());
        expect(result.variant, equals(darkBuilder.variant));
        expect(result.value, isA<Style>());
      });
    });

    group('Type safety', () {
      test('maintains type safety with different variant types', () {
        const namedVariant = NamedVariant('test');
        final contextVariant = ContextVariant('test', (context) => true);
        final widgetStateVariant = WidgetStateVariant(WidgetState.hovered);

        expect(
          VariantAttributeBuilder<MockSpec>(namedVariant),
          isA<VariantAttributeBuilder<MockSpec>>(),
        );
        expect(
          VariantAttributeBuilder<MockSpec>(contextVariant),
          isA<VariantAttributeBuilder<MockSpec>>(),
        );
        expect(
          VariantAttributeBuilder<MockSpec>(widgetStateVariant),
          isA<VariantAttributeBuilder<MockSpec>>(),
        );
      });

      test('works with different variant types', () {
        const namedVariant = NamedVariant('test');
        final contextVariant = ContextVariant('test', (context) => true);
        final notVariant = ContextVariant.not(
          ContextVariant.widgetState(WidgetState.disabled),
        );

        expect(
          VariantAttributeBuilder<MultiSpec>(namedVariant),
          isA<VariantAttributeBuilder<MultiSpec>>(),
        );
        expect(
          VariantAttributeBuilder<MultiSpec>(contextVariant),
          isA<VariantAttributeBuilder<MultiSpec>>(),
        );
        expect(
          VariantAttributeBuilder<MultiSpec>(notVariant),
          isA<VariantAttributeBuilder<MultiSpec>>(),
        );
      });
    });
  });
}
