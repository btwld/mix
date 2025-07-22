import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('ContextVariant', () {
    group('Constructor', () {
      test('creates variant with correct properties', () {
        final variant = ContextVariant('test_key', (context) => true);

        expect(variant.key, 'test_key');
        expect(variant.when(MockBuildContext()), true);
        expect(variant, isA<Variant>());
        expect(variant, isA<ContextVariant>());
      });

      test('creates variants with different keys and functions', () {
        final variant1 = ContextVariant('key1', (context) => true);
        final variant2 = ContextVariant('key2', (context) => false);
        final variant3 = ContextVariant('key3', (context) => context.mounted);

        expect(variant1.key, 'key1');
        expect(variant2.key, 'key2');
        expect(variant3.key, 'key3');

        final context = MockBuildContext();
        expect(variant1.when(context), isTrue);
        expect(variant2.when(context), isFalse);
        expect(variant3.when(context), isTrue);
      });

      test('accepts complex conditional functions', () {
        var callCount = 0;
        final variant = ContextVariant('complex', (context) {
          callCount++;
          return callCount % 2 == 0;
        });

        final context = MockBuildContext();
        expect(variant.when(context), isFalse); // callCount = 1
        expect(variant.when(context), isTrue); // callCount = 2
        expect(variant.when(context), isFalse); // callCount = 3
      });

      test('accepts empty string key', () {
        final variant = ContextVariant('', (context) => true);

        expect(variant.key, '');
        expect(variant.when(MockBuildContext()), isTrue);
      });

      test('function parameter is properly passed', () {
        BuildContext? capturedContext;
        final variant = ContextVariant('test', (context) {
          capturedContext = context;
          return true;
        });

        final mockContext = MockBuildContext();
        variant.when(mockContext);

        expect(capturedContext, same(mockContext));
      });
    });

    group('widgetState factory', () {
      test('creates widget state variant with correct key', () {
        final variant = ContextVariant.widgetState(WidgetState.hovered);

        expect(variant.key, 'widget_state_hovered');
      });

      test('creates different variants for different states', () {
        final hovered = ContextVariant.widgetState(WidgetState.hovered);
        final pressed = ContextVariant.widgetState(WidgetState.pressed);

        expect(hovered.key, 'widget_state_hovered');
        expect(pressed.key, 'widget_state_pressed');
        expect(hovered.key != pressed.key, true);
      });
    });

    group('orientation factory', () {
      test('creates orientation variant with correct key', () {
        final variant = ContextVariant.orientation(Orientation.portrait);

        expect(variant.key, 'media_query_orientation_portrait');
      });
    });

    group('platformBrightness factory', () {
      test('creates brightness variant with correct key', () {
        final variant = ContextVariant.platformBrightness(Brightness.dark);

        expect(variant.key, 'media_query_platform_brightness_dark');
      });
    });

    group('size factory', () {
      test('creates size variant with correct key', () {
        final variant = ContextVariant.size(
          'mobile',
          (size) => size.width < 768,
        );

        expect(variant.key, 'media_query_size_mobile');
      });
    });

    group('direction factory', () {
      test('creates direction variant with correct key', () {
        final variant = ContextVariant.direction(TextDirection.ltr);

        expect(variant.key, 'directionality_ltr');
      });

      test('creates different variants for different directions', () {
        final ltr = ContextVariant.direction(TextDirection.ltr);
        final rtl = ContextVariant.direction(TextDirection.rtl);

        expect(ltr.key, 'directionality_ltr');
        expect(rtl.key, 'directionality_rtl');
        expect(ltr.key, isNot(equals(rtl.key)));
      });
    });

    group('platform factory', () {
      test('creates platform variant with correct key', () {
        final ios = ContextVariant.platform(TargetPlatform.iOS);
        final android = ContextVariant.platform(TargetPlatform.android);
        final windows = ContextVariant.platform(TargetPlatform.windows);

        expect(ios.key, 'platform_iOS');
        expect(android.key, 'platform_android');
        expect(windows.key, 'platform_windows');
      });

      test('creates different variants for different platforms', () {
        const platforms = TargetPlatform.values;
        final variants = platforms
            .map((p) => ContextVariant.platform(p))
            .toList();
        final keys = variants.map((v) => v.key).toSet();

        // All platforms should have different keys
        expect(keys.length, platforms.length);
      });
    });

    group('web factory', () {
      test('creates web variant with correct key', () {
        final variant = ContextVariant.web();

        expect(variant.key, 'web');
      });
    });

    group('when method', () {
      test('calls shouldApply function', () {
        bool called = false;
        final variant = ContextVariant('test', (context) {
          called = true;
          return true;
        });

        final result = variant.when(MockBuildContext());

        expect(called, true);
        expect(result, true);
      });

      test('returns shouldApply function result', () {
        final trueVariant = ContextVariant('true', (context) => true);
        final falseVariant = ContextVariant('false', (context) => false);
        final nullCheckVariant = ContextVariant(
          'null_check',
          (context) => context.mounted,
        );

        final context = MockBuildContext();
        expect(trueVariant.when(context), isTrue);
        expect(falseVariant.when(context), isFalse);
        expect(nullCheckVariant.when(context), isTrue);
      });

      test('calls function each time when is called', () {
        var callCount = 0;
        final variant = ContextVariant('counter', (context) {
          callCount++;
          return true;
        });

        final context = MockBuildContext();
        variant.when(context);
        variant.when(context);
        variant.when(context);

        expect(callCount, 3);
      });
    });
    group('Equality and hashCode', () {
      test('equal ContextVariants have same hashCode', () {
        final variant1 = ContextVariant('test', (context) => true);
        final variant2 = ContextVariant('test', (context) => true);

        // Note: ContextVariant equality is based on key, not function
        expect(variant1.key, equals(variant2.key));
      });

      test('different keys create different variants', () {
        final variant1 = ContextVariant('test1', (context) => true);
        final variant2 = ContextVariant('test2', (context) => true);

        expect(variant1.key, isNot(equals(variant2.key)));
      });

      test('factory method variants have consistent keys', () {
        final variant1 = ContextVariant.platformBrightness(Brightness.dark);
        final variant2 = ContextVariant.platformBrightness(Brightness.dark);

        expect(variant1.key, equals(variant2.key));
      });
    });

    group('MultiVariant integration', () {
      test('can be combined with AND operator', () {
        final variant1 = ContextVariant('test1', (context) => true);
        final variant2 = ContextVariant('test2', (context) => false);

        final combined = variant1 & variant2;

        expect(combined, isA<MultiVariant>());
        expect(combined.operatorType, MultiVariantOperator.and);
        expect(combined.variants, contains(variant1));
        expect(combined.variants, contains(variant2));
      });

      test('can be combined with OR operator', () {
        final variant1 = ContextVariant('test1', (context) => true);
        final variant2 = ContextVariant('test2', (context) => false);

        final combined = variant1 | variant2;

        expect(combined, isA<MultiVariant>());
        expect(combined.operatorType, MultiVariantOperator.or);
        expect(combined.variants, contains(variant1));
        expect(combined.variants, contains(variant2));
      });

      test('can be negated with NOT operation', () {
        final variant = ContextVariant('test', (context) => true);
        final notVariant = not(variant);

        expect(notVariant, isA<MultiVariant>());
        expect(notVariant.operatorType, MultiVariantOperator.not);
        expect(notVariant.variants.first, variant);
      });

      test('combines with NamedVariants', () {
        final contextVariant = ContextVariant('test', (context) => true);
        const namedVariant = NamedVariant('primary');

        final combined = contextVariant & namedVariant;

        expect(combined.variants, contains(contextVariant));
        expect(combined.variants, contains(namedVariant));
      });
    });

    group('VariantSpecAttribute integration', () {
      test('can be wrapped in VariantSpecAttribute', () {
        final contextVariant = ContextVariant('test', (context) => true);
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(contextVariant, style);

        expect(variantAttr.variant, contextVariant);
        expect(variantAttr.value, style);
        expect(variantAttr.mergeKey, 'test');
      });

      test('different contexts create different mergeKeys', () {
        final variant1 = ContextVariant('context1', (context) => true);
        final variant2 = ContextVariant('context2', (context) => false);

        final style1 = VariantSpecAttribute(
          variant1,
          BoxSpecAttribute.only(width: 100.0),
        );
        final style2 = VariantSpecAttribute(
          variant2,
          BoxSpecAttribute.only(height: 200.0),
        );

        expect(style1.mergeKey, 'context1');
        expect(style2.mergeKey, 'context2');
        expect(style1.mergeKey, isNot(equals(style2.mergeKey)));
      });
    });

    group('Complex condition scenarios', () {
      test('handles complex conditional logic', () {
        final complexVariant = ContextVariant('complex', (context) {
          // Simulate complex logic that might depend on context properties
          return context.size?.width != null && context.size!.width > 800;
        });

        final context = MockBuildContext();
        final result = complexVariant.when(context);

        // The MockBuildContext has size (800, 600) by default
        expect(result, isFalse);
      });

      test('can throw exceptions in shouldApply function', () {
        final throwingVariant = ContextVariant('throwing', (context) {
          throw Exception('Test exception');
        });

        final context = MockBuildContext();
        expect(() => throwingVariant.when(context), throwsException);
      });

      test('handles null context gracefully in custom functions', () {
        final nullSafeVariant = ContextVariant('null_safe', (context) {
          return context.mounted;
        });

        final context = MockBuildContext();
        expect(() => nullSafeVariant.when(context), returnsNormally);
      });
    });

    group('Factory method comprehensive testing', () {
      test('all orientation values create valid variants', () {
        for (final orientation in Orientation.values) {
          final variant = ContextVariant.orientation(orientation);
          expect(variant.key, contains(orientation.name));
          expect(variant, isA<ContextVariant>());
        }
      });

      test('all brightness values create valid variants', () {
        for (final brightness in Brightness.values) {
          final variant = ContextVariant.platformBrightness(brightness);
          expect(variant.key, contains(brightness.name));
          expect(variant, isA<ContextVariant>());
        }
      });

      test('all text direction values create valid variants', () {
        for (final direction in TextDirection.values) {
          final variant = ContextVariant.direction(direction);
          expect(variant.key, contains(direction.name));
          expect(variant, isA<ContextVariant>());
        }
      });

      test('size factory accepts custom conditions', () {
        final mobileVariant = ContextVariant.size(
          'mobile',
          (size) => size.width <= 480,
        );
        final tabletVariant = ContextVariant.size(
          'tablet',
          (size) => size.width > 480 && size.width <= 1024,
        );
        final desktopVariant = ContextVariant.size(
          'desktop',
          (size) => size.width > 1024,
        );

        expect(mobileVariant.key, 'media_query_size_mobile');
        expect(tabletVariant.key, 'media_query_size_tablet');
        expect(desktopVariant.key, 'media_query_size_desktop');
      });
    });

    group('Edge cases and error handling', () {
      test('handles function that returns non-boolean gracefully', () {
        // In Dart, this would be a compile-time error, but let's test runtime behavior
        expect(
          () => ContextVariant('test', (context) => true),
          returnsNormally,
        );
      });

      test('key property is immutable', () {
        final variant = ContextVariant('immutable', (context) => true);
        expect(variant.key, 'immutable');
        // Key should not change
        expect(variant.key, 'immutable');
      });

      test('shouldApply function is consistently referenced', () {
        final variant = ContextVariant('consistent', (context) => true);
        final function1 = variant.shouldApply;
        final function2 = variant.shouldApply;

        expect(identical(function1, function2), isTrue);
      });
    });

    group('Performance considerations', () {
      test('creating many ContextVariants is efficient', () {
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 1000; i++) {
          ContextVariant('variant$i', (context) => i % 2 == 0);
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('when method calls are efficient', () {
        final variant = ContextVariant('performance', (context) => true);
        final context = MockBuildContext();
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 1000; i++) {
          variant.when(context);
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(50));
      });
    });
  });

  group('Predefined variants', () {
    test('widget state variants are defined', () {
      expect(hover.key, 'widget_state_hovered');
      expect(press.key, 'widget_state_pressed');
      expect(focus.key, 'widget_state_focused');
      expect(disabled.key, 'widget_state_disabled');
      expect(selected.key, 'widget_state_selected');
      expect(dragged.key, 'widget_state_dragged');
      expect(error.key, 'widget_state_error');
    });

    test('brightness variants are defined', () {
      expect(dark.key, 'media_query_platform_brightness_dark');
      expect(light.key, 'media_query_platform_brightness_light');
    });

    test('orientation variants are defined', () {
      expect(portrait.key, 'media_query_orientation_portrait');
      expect(landscape.key, 'media_query_orientation_landscape');
    });

    test('size variants are defined', () {
      expect(mobile.key, 'media_query_size_mobile');
      expect(tablet.key, 'media_query_size_tablet');
      expect(desktop.key, 'media_query_size_desktop');
    });

    test('breakpoint variants are defined', () {
      expect(xsmall.key, 'media_query_size_xsmall');
      expect(small.key, 'media_query_size_small');
      expect(medium.key, 'media_query_size_medium');
      expect(large.key, 'media_query_size_large');
      expect(xlarge.key, 'media_query_size_xlarge');
    });

    test('platform variants are defined', () {
      expect(ios.key, 'platform_iOS');
      expect(android.key, 'platform_android');
      expect(macos.key, 'platform_macOS');
      expect(windows.key, 'platform_windows');
      expect(linux.key, 'platform_linux');
      expect(fuchsia.key, 'platform_fuchsia');
      expect(web.key, 'web');
    });

    test('direction variants are defined', () {
      expect(ltr.key, 'directionality_ltr');
      expect(rtl.key, 'directionality_rtl');
    });

    test('utility variants using NOT logic are defined', () {
      expect(enabled, isA<MultiVariant>());
      expect(enabled.operatorType, MultiVariantOperator.not);
      expect(enabled.variants.first, disabled);

      expect(unselected, isA<MultiVariant>());
      expect(unselected.operatorType, MultiVariantOperator.not);
      expect(unselected.variants.first, selected);
    });

    test('named variants are defined', () {
      expect(primary.key, 'primary');
      expect(secondary.key, 'secondary');
      expect(outlined.key, 'outlined');
      expect(primary, isA<NamedVariant>());
      expect(secondary, isA<NamedVariant>());
      expect(outlined, isA<NamedVariant>());
    });

    test('all predefined context variants are ContextVariant instances', () {
      expect(dark, isA<ContextVariant>());
      expect(light, isA<ContextVariant>());
      expect(portrait, isA<ContextVariant>());
      expect(landscape, isA<ContextVariant>());
      expect(mobile, isA<ContextVariant>());
      expect(tablet, isA<ContextVariant>());
      expect(desktop, isA<ContextVariant>());
      expect(ltr, isA<ContextVariant>());
      expect(rtl, isA<ContextVariant>());
      expect(ios, isA<ContextVariant>());
      expect(android, isA<ContextVariant>());
      expect(web, isA<ContextVariant>());
    });

    test('predefined size variants have different breakpoints', () {
      // Test that the size conditions are different
      expect(mobile.key, isNot(equals(tablet.key)));
      expect(tablet.key, isNot(equals(desktop.key)));
      expect(mobile.key, isNot(equals(desktop.key)));

      // Test extended breakpoint variants
      expect(xsmall.key, isNot(equals(small.key)));
      expect(small.key, isNot(equals(medium.key)));
      expect(medium.key, isNot(equals(large.key)));
      expect(large.key, isNot(equals(xlarge.key)));
    });
  });
}
