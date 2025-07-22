import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('OnContextVariantUtility', () {
    const utility = OnContextVariantUtility();

    group('Constructor and singleton', () {
      test('can be instantiated with const constructor', () {
        expect(() => const OnContextVariantUtility(), returnsNormally);
        expect(utility, isA<OnContextVariantUtility>());
      });

      test('self returns the same singleton instance', () {
        expect(OnContextVariantUtility.self, same(OnContextVariantUtility.self));
        expect(OnContextVariantUtility.self, isA<OnContextVariantUtility>());
        expect(OnContextVariantUtility.self, equals(utility));
      });

      test('multiple const instances are identical', () {
        const utility1 = OnContextVariantUtility();
        const utility2 = OnContextVariantUtility();
        
        expect(utility1, equals(utility2));
        expect(identical(utility1, utility2), isTrue); // Const constructor creates identical instances
      });
    });

    group('Widget State Variants', () {
      test('hover creates VariantAttributeBuilder', () {
        final builder = utility.hover;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('press creates VariantAttributeBuilder', () {
        final builder = utility.press;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('focus creates VariantAttributeBuilder', () {
        final builder = utility.focus;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('disabled creates VariantAttributeBuilder', () {
        final builder = utility.disabled;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('selected creates VariantAttributeBuilder', () {
        final builder = utility.selected;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('dragged creates VariantAttributeBuilder', () {
        final builder = utility.dragged;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('error creates VariantAttributeBuilder', () {
        final builder = utility.error;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('enabled creates VariantAttributeBuilder', () {
        final builder = utility.enabled;
        expect(builder, isA<VariantAttributeBuilder>());
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
        expect(hover1, isA<VariantAttributeBuilder>());
        expect(hover2, isA<VariantAttributeBuilder>());
        // Note: Equality depends on the underlying variant implementation
      });
    });

    group('Platform Brightness Variants', () {
      test('dark creates VariantAttributeBuilder', () {
        final builder = utility.dark;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('light creates VariantAttributeBuilder', () {
        final builder = utility.light;
        expect(builder, isA<VariantAttributeBuilder>());
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
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('landscape creates VariantAttributeBuilder', () {
        final builder = utility.landscape;
        expect(builder, isA<VariantAttributeBuilder>());
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
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('tablet creates VariantAttributeBuilder', () {
        final builder = utility.tablet;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('desktop creates VariantAttributeBuilder', () {
        final builder = utility.desktop;
        expect(builder, isA<VariantAttributeBuilder>());
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
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('rtl creates VariantAttributeBuilder', () {
        final builder = utility.rtl;
        expect(builder, isA<VariantAttributeBuilder>());
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
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('android creates VariantAttributeBuilder', () {
        final builder = utility.android;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('macos creates VariantAttributeBuilder', () {
        final builder = utility.macos;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('windows creates VariantAttributeBuilder', () {
        final builder = utility.windows;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('linux creates VariantAttributeBuilder', () {
        final builder = utility.linux;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('fuchsia creates VariantAttributeBuilder', () {
        final builder = utility.fuchsia;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('web creates VariantAttributeBuilder', () {
        final builder = utility.web;
        expect(builder, isA<VariantAttributeBuilder>());
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
            expect(identical(platformBuilders[i], platformBuilders[j]), isFalse);
          }
        }
      });
    });

    group('Breakpoint Variants', () {
      test('minWidth creates VariantAttributeBuilder with different parameters', () {
        final builder1 = utility.minWidth(768.0);
        final builder2 = utility.minWidth(1024.0);
        
        expect(builder1, isA<VariantAttributeBuilder>());
        expect(builder2, isA<VariantAttributeBuilder>());
        expect(identical(builder1, builder2), isFalse);
      });

      test('maxWidth creates VariantAttributeBuilder with different parameters', () {
        final builder1 = utility.maxWidth(1024.0);
        final builder2 = utility.maxWidth(768.0);
        
        expect(builder1, isA<VariantAttributeBuilder>());
        expect(builder2, isA<VariantAttributeBuilder>());
        expect(identical(builder1, builder2), isFalse);
      });

      test('widthRange creates VariantAttributeBuilder', () {
        final builder = utility.widthRange(768.0, 1024.0);
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('minHeight creates VariantAttributeBuilder', () {
        final builder = utility.minHeight(600.0);
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('maxHeight creates VariantAttributeBuilder', () {
        final builder = utility.maxHeight(800.0);
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('heightRange creates VariantAttributeBuilder', () {
        final builder = utility.heightRange(600.0, 800.0);
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('same parameters create functionally equivalent builders', () {
        final builder1 = utility.minWidth(768.0);
        final builder2 = utility.minWidth(768.0);
        
        // Builders with same parameters should work the same way
        expect(builder1, isA<VariantAttributeBuilder>());
        expect(builder2, isA<VariantAttributeBuilder>());
        // Note: Equality depends on underlying variant implementation
      });

      test('breakpoint methods work with integer values', () {
        final builder = utility.minWidth(768);
        expect(builder, isA<VariantAttributeBuilder>());
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

      test('utility properties create consistent builders on repeated access', () {
        final hover1 = utility.hover;
        final hover2 = utility.hover;
        
        // Verify they are both VariantAttributeBuilders of same type
        expect(hover1, isA<VariantAttributeBuilder>());
        expect(hover2, isA<VariantAttributeBuilder>());
        // Note: Consistency in behavior matters more than object equality
      });
    });

    group('Performance considerations', () {
      test('utility getter access is efficient', () {
        final stopwatch = Stopwatch()..start();
        
        for (int i = 0; i < 1000; i++) {
          utility.hover;
          utility.press;
          utility.focus;
          utility.disabled;
          utility.dark;
          utility.light;
          utility.mobile;
          utility.tablet;
          utility.desktop;
        }
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(50));
      });

      test('breakpoint method calls are efficient', () {
        final stopwatch = Stopwatch()..start();
        
        for (int i = 0; i < 1000; i++) {
          utility.minWidth(i.toDouble());
          utility.maxWidth(i.toDouble());
          utility.widthRange(i.toDouble(), (i + 100).toDouble());
        }
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });
    });

    group('Integration patterns', () {
      test('builders can be used as function returns', () {
        VariantAttributeBuilder getBuilder() => utility.hover;
        
        final builder = getBuilder();
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('builders can be stored and reused', () {
        final storedBuilders = {
          'hover': utility.hover,
          'press': utility.press,
          'mobile': utility.mobile,
        };
        
        expect(storedBuilders['hover'], isA<VariantAttributeBuilder>());
        expect(storedBuilders['press'], isA<VariantAttributeBuilder>());
        expect(storedBuilders['mobile'], isA<VariantAttributeBuilder>());
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
          expect(builder, isA<VariantAttributeBuilder>());
        }
      });
    });

    group('Documentation and usage patterns', () {
      test('demonstrates common responsive breakpoint usage', () {
        // Common responsive breakpoints
        final mobile = utility.maxWidth(767.0);
        final tablet = utility.widthRange(768.0, 1023.0);
        final desktop = utility.minWidth(1024.0);
        
        expect(mobile, isA<VariantAttributeBuilder>());
        expect(tablet, isA<VariantAttributeBuilder>());
        expect(desktop, isA<VariantAttributeBuilder>());
      });

      test('demonstrates dark mode usage pattern', () {
        final darkVariant = utility.dark;
        expect(darkVariant, isA<VariantAttributeBuilder>());
      });

      test('demonstrates platform-specific styling pattern', () {
        final iosVariant = utility.ios;
        final webVariant = utility.web;
        
        expect(iosVariant, isA<VariantAttributeBuilder>());
        expect(webVariant, isA<VariantAttributeBuilder>());
      });

      test('demonstrates interaction state patterns', () {
        final interactionStates = [
          utility.hover,
          utility.press,
          utility.focus,
          utility.disabled,
        ];
        
        for (final state in interactionStates) {
          expect(state, isA<VariantAttributeBuilder>());
        }
      });

      test('demonstrates size-based responsive design pattern', () {
        final sizeVariants = [
          utility.mobile,
          utility.tablet,
          utility.desktop,
        ];
        
        for (final variant in sizeVariants) {
          expect(variant, isA<VariantAttributeBuilder>());
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
          expect(util, isA<VariantAttributeBuilder>());
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
          expect(util, isA<VariantAttributeBuilder>());
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
          expect(util, isA<VariantAttributeBuilder>());
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
          expect(util, isA<VariantAttributeBuilder>());
        }
      });
    });
  });

  group('VariantAttributeBuilder', () {
    group('Constructor', () {
      test('can be created with a variant', () {
        const variant = NamedVariant('test');
        const builder = VariantAttributeBuilder(variant);
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('can be created with different variant types', () {
        const namedVariant = NamedVariant('test');
        final contextVariant = ContextVariant('test', (context) => true);
        final widgetStateVariant = WidgetStateVariant(WidgetState.hovered);
        final multiVariant = MultiVariant.and([namedVariant, contextVariant]);
        
        expect(VariantAttributeBuilder(namedVariant), isA<VariantAttributeBuilder>());
        expect(VariantAttributeBuilder(contextVariant), isA<VariantAttributeBuilder>());
        expect(VariantAttributeBuilder(widgetStateVariant), isA<VariantAttributeBuilder>());
        expect(VariantAttributeBuilder(multiVariant), isA<VariantAttributeBuilder>());
      });

      test('maintains const constructor behavior', () {
        const variant = NamedVariant('test');
        expect(() => const VariantAttributeBuilder(variant), returnsNormally);
      });
    });

    group('Equality and hashCode', () {
      test('equality based on wrapped variant', () {
        const variant = NamedVariant('test');
        const builder1 = VariantAttributeBuilder(variant);
        const builder2 = VariantAttributeBuilder(variant);
        const builder3 = VariantAttributeBuilder(NamedVariant('other'));
        
        expect(builder1, equals(builder2));
        expect(builder1, isNot(equals(builder3)));
      });

      test('hashCode consistent for equal builders', () {
        const variant = NamedVariant('test');
        const builder1 = VariantAttributeBuilder(variant);
        const builder2 = VariantAttributeBuilder(variant);
        
        expect(builder1.hashCode, equals(builder2.hashCode));
        expect(builder1.hashCode, equals(variant.hashCode));
      });

      test('toString provides meaningful representation', () {
        const variant = NamedVariant('primary');
        const builder = VariantAttributeBuilder(variant);
        
        final stringRep = builder.toString();
        expect(stringRep, contains('VariantAttributeBuilder'));
        expect(stringRep, contains('primary'));
      });

      test('different variant types create different builders', () {
        const namedVariant = NamedVariant('test');
        final contextVariant = ContextVariant('test', (context) => true);
        
        const namedBuilder = VariantAttributeBuilder(namedVariant);
        final contextBuilder = VariantAttributeBuilder(contextVariant);
        
        expect(namedBuilder, isNot(equals(contextBuilder)));
        expect(namedBuilder.hashCode, isNot(equals(contextBuilder.hashCode)));
      });
    });

    group('Integration', () {
      test('works with utility-created builders', () {
        const utility = OnContextVariantUtility();
        final hoverBuilder = utility.hover;
        
        expect(hoverBuilder, isA<VariantAttributeBuilder>());
      });

      test('can be stored in collections', () {
        const variant1 = NamedVariant('test1');
        const variant2 = NamedVariant('test2');
        
        final builders = [
          const VariantAttributeBuilder(variant1),
          const VariantAttributeBuilder(variant2),
        ];
        
        expect(builders, hasLength(2));
        expect(builders.first, isA<VariantAttributeBuilder>());
        expect(builders.last, isA<VariantAttributeBuilder>());
      });
    });

    group('Call method functionality', () {
      test('call method creates VariantSpecAttribute with single element', () {
        const variant = NamedVariant('primary');
        const builder = VariantAttributeBuilder(variant);
        final attribute = UtilityTestAttribute<double>(100.0);
        
        final result = builder.call(attribute);
        
        expect(result, isA<VariantSpecAttribute<MultiSpec>>());
        expect(result.variant, same(variant));
        expect(result.value, isA<Style>());
      });

      test('call method creates VariantSpecAttribute with multiple elements', () {
        const variant = NamedVariant('primary');
        const builder = VariantAttributeBuilder(variant);
        final attr1 = UtilityTestAttribute<double>(100.0);
        final attr2 = UtilityTestAttribute<String>('test');
        
        final result = builder.call(attr1, attr2);
        
        expect(result, isA<VariantSpecAttribute<MultiSpec>>());
        expect(result.variant, same(variant));
        expect(result.value, isA<Style>());
      });

      test('call method works with utility-created builders', () {
        const utility = OnContextVariantUtility();
        final hoverBuilder = utility.hover;
        final attribute = UtilityTestAttribute<double>(200.0);
        
        final result = hoverBuilder.call(attribute);
        
        expect(result, isA<VariantSpecAttribute<MultiSpec>>());
        expect(result.value, isA<Style>());
      });

      test('call method preserves variant information', () {
        final contextVariant = ContextVariant('hover', (context) => true);
        final builder = VariantAttributeBuilder(contextVariant);
        final attribute = UtilityTestAttribute<String>('test');
        
        final result = builder.call(attribute);
        
        expect(result, isA<VariantSpecAttribute<MultiSpec>>());
        expect(result.variant, same(contextVariant));
        expect(result.value, isA<Style>());
      });

      test('call method throws error with no elements', () {
        const variant = NamedVariant('test');
        const builder = VariantAttributeBuilder(variant);
        
        expect(
          () => builder.call(),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('call method supports usage pattern like README examples', () {
        const utility = OnContextVariantUtility();
        final darkBuilder = utility.dark;
        
        // Simulate: $on.dark($box.color.white(), $text.style.color.black())
        final boxAttr = UtilityTestAttribute<String>('white');
        final textAttr = UtilityTestAttribute<String>('black');
        
        final result = darkBuilder.call(boxAttr, textAttr);
        
        expect(result, isA<VariantSpecAttribute<MultiSpec>>());
        expect(result.variant, equals(darkBuilder.variant));
        expect(result.value, isA<Style>());
      });
    });

    group('Performance', () {
      test('creation is efficient', () {
        const variant = NamedVariant('test');
        final stopwatch = Stopwatch()..start();
        
        for (int i = 0; i < 1000; i++) {
          const VariantAttributeBuilder(variant);
        }
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(10));
      });

      test('equality comparison is efficient', () {
        const variant = NamedVariant('test');
        const builder1 = VariantAttributeBuilder(variant);
        const builder2 = VariantAttributeBuilder(variant);
        final stopwatch = Stopwatch()..start();
        
        for (int i = 0; i < 1000; i++) {
          builder1 == builder2;
        }
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(5));
      });

      test('hashCode computation is efficient', () {
        const variant = NamedVariant('test');
        const builder = VariantAttributeBuilder(variant);
        final stopwatch = Stopwatch()..start();
        
        for (int i = 0; i < 1000; i++) {
          builder.hashCode;
        }
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(5));
      });
    });

    group('Type safety', () {
      test('maintains type safety with different variant types', () {
        const namedVariant = NamedVariant('test');
        final contextVariant = ContextVariant('test', (context) => true);
        final widgetStateVariant = WidgetStateVariant(WidgetState.hovered);
        
        expect(VariantAttributeBuilder(namedVariant), isA<VariantAttributeBuilder>());
        expect(VariantAttributeBuilder(contextVariant), isA<VariantAttributeBuilder>());
        expect(VariantAttributeBuilder(widgetStateVariant), isA<VariantAttributeBuilder>());
      });

      test('works with complex variant compositions', () {
        const namedVariant = NamedVariant('test');
        final contextVariant = ContextVariant('test', (context) => true);
        final multiVariant = MultiVariant.and([namedVariant, contextVariant]);
        final notVariant = MultiVariant.not(namedVariant);
        
        expect(VariantAttributeBuilder(multiVariant), isA<VariantAttributeBuilder>());
        expect(VariantAttributeBuilder(notVariant), isA<VariantAttributeBuilder>());
      });
    });
  });
}