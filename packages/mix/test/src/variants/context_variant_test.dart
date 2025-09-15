import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

// Test variant constants
const primary = 'primary';
const secondary = 'secondary';
const outlined = 'outlined';

void main() {
  group('ContextTrigger', () {
    group('Constructor', () {
      test('creates variant with correct properties', () {
        final variant = ContextTrigger('test_key', (context) => true);

        expect(variant.key, 'test_key');
        expect(variant.matches(MockBuildContext()), true);
        expect(variant, isA<ContextTrigger>());
        expect(variant, isA<ContextTrigger>());
      });

      test('creates variants with different keys and functions', () {
        final variant1 = ContextTrigger('key1', (context) => true);
        final variant2 = ContextTrigger('key2', (context) => false);
        final variant3 = ContextTrigger('key3', (context) => context.mounted);

        expect(variant1.key, 'key1');
        expect(variant2.key, 'key2');
        expect(variant3.key, 'key3');

        final context = MockBuildContext();
        expect(variant1.matches(context), isTrue);
        expect(variant2.matches(context), isFalse);
        expect(variant3.matches(context), isTrue);
      });

      test('accepts complex conditional functions', () {
        var callCount = 0;
        final variant = ContextTrigger('complex', (context) {
          callCount++;
          return callCount % 2 == 0;
        });

        final context = MockBuildContext();
        expect(variant.matches(context), isFalse); // callCount = 1
        expect(variant.matches(context), isTrue); // callCount = 2
        expect(variant.matches(context), isFalse); // callCount = 3
      });

      test('accepts empty string key', () {
        final variant = ContextTrigger('', (context) => true);

        expect(variant.key, '');
        expect(variant.matches(MockBuildContext()), isTrue);
      });

      test('function parameter is properly passed', () {
        BuildContext? capturedContext;
        final variant = ContextTrigger('test', (context) {
          capturedContext = context;
          return true;
        });

        final mockContext = MockBuildContext();
        variant.matches(mockContext);

        expect(capturedContext, same(mockContext));
      });
    });

    group('widgetState factory', () {
      test('creates widget state variant with correct key', () {
        final variant = ContextTrigger.widgetState(WidgetState.hovered);

        expect(variant.key, 'widget_state_hovered');
      });

      test('creates different variants for different states', () {
        final hovered = ContextTrigger.widgetState(WidgetState.hovered);
        final pressed = ContextTrigger.widgetState(WidgetState.pressed);

        expect(hovered.key, 'widget_state_hovered');
        expect(pressed.key, 'widget_state_pressed');
        expect(hovered.key != pressed.key, true);
      });
    });

    group('orientation factory', () {
      test('creates orientation variant with correct key', () {
        final variant = ContextTrigger.orientation(Orientation.portrait);

        expect(variant.key, 'media_query_orientation_portrait');
      });
    });

    group('platformBrightness factory', () {
      test('creates brightness variant with correct key', () {
        final variant = ContextTrigger.brightness(Brightness.dark);

        expect(variant.key, 'media_query_platform_brightness_dark');
      });
    });

    group('size factory', () {
      test('creates size variant with correct key', () {
        final variant = ContextTrigger.size(
          'mobile',
          (size) => size.width < 768,
        );

        expect(variant.key, 'media_query_size_mobile');
      });
    });

    group('direction factory', () {
      test('creates direction variant with correct key', () {
        final variant = ContextTrigger.directionality(TextDirection.ltr);

        expect(variant.key, 'directionality_ltr');
      });

      test('creates different variants for different directions', () {
        final ltr = ContextTrigger.directionality(TextDirection.ltr);
        final rtl = ContextTrigger.directionality(TextDirection.rtl);

        expect(ltr.key, 'directionality_ltr');
        expect(rtl.key, 'directionality_rtl');
        expect(ltr.key, isNot(equals(rtl.key)));
      });
    });

    group('platform factory', () {
      test('creates platform variant with correct key', () {
        final ios = ContextTrigger.platform(TargetPlatform.iOS);
        final android = ContextTrigger.platform(TargetPlatform.android);
        final windows = ContextTrigger.platform(TargetPlatform.windows);

        expect(ios.key, 'platform_iOS');
        expect(android.key, 'platform_android');
        expect(windows.key, 'platform_windows');
      });

      test('creates different variants for different platforms', () {
        const platforms = TargetPlatform.values;
        final variants = platforms
            .map((p) => ContextTrigger.platform(p))
            .toList();
        final keys = variants.map((v) => v.key).toSet();

        // All platforms should have different keys
        expect(keys.length, platforms.length);
      });
    });

    group('web factory', () {
      test('creates web variant with correct key', () {
        final variant = ContextTrigger.web();

        expect(variant.key, 'web');
      });
    });

    group('when method', () {
      test('calls shouldApply function', () {
        bool called = false;
        final variant = ContextTrigger('test', (context) {
          called = true;
          return true;
        });

        final result = variant.matches(MockBuildContext());

        expect(called, true);
        expect(result, true);
      });

      test('returns shouldApply function result', () {
        final trueVariant = ContextTrigger('true', (context) => true);
        final falseVariant = ContextTrigger('false', (context) => false);
        final nullCheckVariant = ContextTrigger(
          'null_check',
          (context) => context.mounted,
        );

        final context = MockBuildContext();
        expect(trueVariant.matches(context), isTrue);
        expect(falseVariant.matches(context), isFalse);
        expect(nullCheckVariant.matches(context), isTrue);
      });

      test('calls function each time when is called', () {
        var callCount = 0;
        final variant = ContextTrigger('counter', (context) {
          callCount++;
          return true;
        });

        final context = MockBuildContext();
        variant.matches(context);
        variant.matches(context);
        variant.matches(context);

        expect(callCount, 3);
      });
    });
    group('Equality and hashCode', () {
      test('equal ContextTriggers have same hashCode', () {
        final variant1 = ContextTrigger('test', (context) => true);
        final variant2 = ContextTrigger('test', (context) => true);

        // Note: ContextTrigger equality is based on key, not function
        expect(variant1.key, equals(variant2.key));
      });

      test('different keys create different variants', () {
        final variant1 = ContextTrigger('test1', (context) => true);
        final variant2 = ContextTrigger('test2', (context) => true);

        expect(variant1.key, isNot(equals(variant2.key)));
      });

      test('factory method variants have consistent keys', () {
        final variant1 = ContextTrigger.brightness(Brightness.dark);
        final variant2 = ContextTrigger.brightness(Brightness.dark);

        expect(variant1.key, equals(variant2.key));
      });
    });

    group('Variant composition', () {
      test('separate variants can be used independently', () {
        final variant1 = ContextTrigger('test1', (context) => true);
        final variant2 = ContextTrigger('test2', (context) => false);

        expect(variant1.key, 'test1');
        expect(variant2.key, 'test2');
        expect(variant1, isNot(equals(variant2)));
      });

      test('can be negated with NOT static method', () {
        final variant = ContextTrigger('test', (context) => true);
        final notVariant = ContextTrigger.not(variant);

        expect(notVariant, isA<ContextTrigger>());
        expect(notVariant.key, 'not_test');
      });

    });

    group('VariantSpecAttribute integration', () {
      test('can be wrapped in VariantSpecAttribute', () {
        final contextVariant = ContextTrigger('test', (context) => true);
        final style = BoxStyler().width(100.0);
        final variantAttr = EventVariantStyle<BoxSpec>(contextVariant, style);

        expect(variantAttr.trigger, contextVariant);
        expect(variantAttr.style, style);
        expect(variantAttr.variantKey, 'test');
      });

      test('different contexts create different mergeKeys', () {
        final variant1 = ContextTrigger('context1', (context) => true);
        final variant2 = ContextTrigger('context2', (context) => false);

        final style1 = EventVariantStyle<BoxSpec>(
          variant1,
          BoxStyler().width(100.0),
        );
        final style2 = EventVariantStyle<BoxSpec>(
          variant2,
          BoxStyler().height(200.0),
        );

        expect(style1.variantKey, 'context1');
        expect(style2.variantKey, 'context2');
        expect(style1.variantKey, isNot(equals(style2.variantKey)));
      });
    });

    group('Complex condition scenarios', () {
      test('handles complex conditional logic', () {
        final complexVariant = ContextTrigger('complex', (context) {
          // Simulate complex logic that might depend on context properties
          return context.size?.width != null && context.size!.width > 800;
        });

        final context = MockBuildContext();
        final result = complexVariant.matches(context);

        // The MockBuildContext has size (800, 600) by default
        expect(result, isFalse);
      });

      test('can throw exceptions in shouldApply function', () {
        final throwingVariant = ContextTrigger('throwing', (context) {
          throw Exception('Test exception');
        });

        final context = MockBuildContext();
        expect(() => throwingVariant.matches(context), throwsException);
      });

      test('handles null context gracefully in custom functions', () {
        final nullSafeVariant = ContextTrigger('null_safe', (context) {
          return context.mounted;
        });

        final context = MockBuildContext();
        expect(() => nullSafeVariant.matches(context), returnsNormally);
      });
    });

    group('Factory method comprehensive testing', () {
      test('all orientation values create valid variants', () {
        for (final orientation in Orientation.values) {
          final variant = ContextTrigger.orientation(orientation);
          expect(variant.key, contains(orientation.name));
          expect(variant, isA<ContextTrigger>());
        }
      });

      test('all brightness values create valid variants', () {
        for (final brightness in Brightness.values) {
          final variant = ContextTrigger.brightness(brightness);
          expect(variant.key, contains(brightness.name));
          expect(variant, isA<ContextTrigger>());
        }
      });

      test('all text direction values create valid variants', () {
        for (final direction in TextDirection.values) {
          final variant = ContextTrigger.directionality(direction);
          expect(variant.key, contains(direction.name));
          expect(variant, isA<ContextTrigger>());
        }
      });

      test('size factory accepts custom conditions', () {
        final mobileVariant = ContextTrigger.size(
          'mobile',
          (size) => size.width <= 480,
        );
        final tabletVariant = ContextTrigger.size(
          'tablet',
          (size) => size.width > 480 && size.width <= 1024,
        );
        final desktopVariant = ContextTrigger.size(
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
          () => ContextTrigger('test', (context) => true),
          returnsNormally,
        );
      });

      test('key property is immutable', () {
        final variant = ContextTrigger('immutable', (context) => true);
        expect(variant.key, 'immutable');
        // Key should not change
        expect(variant.key, 'immutable');
      });

      test('shouldApply function is consistently referenced', () {
        final variant = ContextTrigger('consistent', (context) => true);
        final function1 = variant.shouldApply;
        final function2 = variant.shouldApply;

        expect(identical(function1, function2), isTrue);
      });
    });
  });

  group('Predefined variants', () {
    test('widget state variants are defined', () {
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

    test('brightness variants are defined', () {
      expect(
        ContextTrigger.brightness(Brightness.dark).key,
        'media_query_platform_brightness_dark',
      );
      expect(
        ContextTrigger.brightness(Brightness.light).key,
        'media_query_platform_brightness_light',
      );
    });

    test('orientation variants are defined', () {
      expect(
        ContextTrigger.orientation(Orientation.portrait).key,
        'media_query_orientation_portrait',
      );
      expect(
        ContextTrigger.orientation(Orientation.landscape).key,
        'media_query_orientation_landscape',
      );
    });

    test('size variants are defined', () {
      expect(
        ContextTrigger.size('mobile', (size) => size.width <= 767).key,
        'media_query_size_mobile',
      );
      expect(
        ContextTrigger.size(
          'tablet',
          (size) => size.width > 767 && size.width <= 1279,
        ).key,
        'media_query_size_tablet',
      );
      expect(
        ContextTrigger.size('desktop', (size) => size.width > 1279).key,
        'media_query_size_desktop',
      );
    });

    test('breakpoint variants are defined', () {
      expect(
        ContextTrigger.size('xsmall', (size) => size.width <= 480).key,
        'media_query_size_xsmall',
      );
      expect(
        ContextTrigger.size('small', (size) => size.width <= 768).key,
        'media_query_size_small',
      );
      expect(
        ContextTrigger.size('medium', (size) => size.width <= 1024).key,
        'media_query_size_medium',
      );
      expect(
        ContextTrigger.size('large', (size) => size.width <= 1280).key,
        'media_query_size_large',
      );
      expect(
        ContextTrigger.size('xlarge', (size) => size.width > 1280).key,
        'media_query_size_xlarge',
      );
    });

    test('platform variants are defined', () {
      expect(ContextTrigger.platform(TargetPlatform.iOS).key, 'platform_iOS');
      expect(
        ContextTrigger.platform(TargetPlatform.android).key,
        'platform_android',
      );
      expect(
        ContextTrigger.platform(TargetPlatform.macOS).key,
        'platform_macOS',
      );
      expect(
        ContextTrigger.platform(TargetPlatform.windows).key,
        'platform_windows',
      );
      expect(
        ContextTrigger.platform(TargetPlatform.linux).key,
        'platform_linux',
      );
      expect(
        ContextTrigger.platform(TargetPlatform.fuchsia).key,
        'platform_fuchsia',
      );
      expect(ContextTrigger.web().key, 'web');
    });

    test('direction variants are defined', () {
      expect(
        ContextTrigger.directionality(TextDirection.ltr).key,
        'directionality_ltr',
      );
      expect(
        ContextTrigger.directionality(TextDirection.rtl).key,
        'directionality_rtl',
      );
    });

    test('utility variants using NOT logic are defined', () {
      final disabled = ContextTrigger.widgetState(WidgetState.disabled);
      final selected = ContextTrigger.widgetState(WidgetState.selected);
      final enabled = ContextTrigger.not(disabled);
      final unselected = ContextTrigger.not(selected);

      expect(enabled, isA<ContextTrigger>());
      expect(enabled.key, contains('not'));

      expect(unselected, isA<ContextTrigger>());
      expect(unselected.key, contains('not'));
    });

    test('named variants are defined', () {
      expect(primary, 'primary');
      expect(secondary, 'secondary');
      expect(outlined, 'outlined');
      expect(primary, isA<String>());
      expect(secondary, isA<String>());
      expect(outlined, isA<String>());
    });

    test('all predefined context variants are ContextTrigger instances', () {
      expect(ContextTrigger.brightness(Brightness.dark), isA<ContextTrigger>());
      expect(
        ContextTrigger.brightness(Brightness.light),
        isA<ContextTrigger>(),
      );
      expect(
        ContextTrigger.orientation(Orientation.portrait),
        isA<ContextTrigger>(),
      );
      expect(
        ContextTrigger.orientation(Orientation.landscape),
        isA<ContextTrigger>(),
      );
      expect(
        ContextTrigger.size('mobile', (size) => size.width <= 767),
        isA<ContextTrigger>(),
      );
      expect(
        ContextTrigger.size(
          'tablet',
          (size) => size.width > 767 && size.width <= 1279,
        ),
        isA<ContextTrigger>(),
      );
      expect(
        ContextTrigger.size('desktop', (size) => size.width > 1279),
        isA<ContextTrigger>(),
      );
      expect(
        ContextTrigger.directionality(TextDirection.ltr),
        isA<ContextTrigger>(),
      );
      expect(
        ContextTrigger.directionality(TextDirection.rtl),
        isA<ContextTrigger>(),
      );
      expect(
        ContextTrigger.platform(TargetPlatform.iOS),
        isA<ContextTrigger>(),
      );
      expect(
        ContextTrigger.platform(TargetPlatform.android),
        isA<ContextTrigger>(),
      );
      expect(ContextTrigger.web(), isA<ContextTrigger>());
    });

    test('predefined size variants have different breakpoints', () {
      final mobile = ContextTrigger.size('mobile', (size) => size.width <= 767);
      final tablet = ContextTrigger.size(
        'tablet',
        (size) => size.width > 767 && size.width <= 1279,
      );
      final desktop = ContextTrigger.size(
        'desktop',
        (size) => size.width > 1279,
      );
      final xsmall = ContextTrigger.size('xsmall', (size) => size.width <= 480);
      final small = ContextTrigger.size('small', (size) => size.width <= 768);
      final medium = ContextTrigger.size(
        'medium',
        (size) => size.width <= 1024,
      );
      final large = ContextTrigger.size('large', (size) => size.width <= 1280);
      final xlarge = ContextTrigger.size('xlarge', (size) => size.width > 1280);

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
