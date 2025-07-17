import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('ContextVariant', () {
    test('constructor creates variant with correct properties', () {
      final variant = ContextVariant(
        'test_key',
        (context) => true,
      );

      expect(variant.key, 'test_key');
      expect(variant.when(MockBuildContext()), true);
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
        final variant = ContextVariant.size('mobile', (size) => size.width < 768);

        expect(variant.key, 'media_query_size_mobile');
      });
    });

    group('direction factory', () {
      test('creates direction variant with correct key', () {
        final variant = ContextVariant.direction(TextDirection.ltr);

        expect(variant.key, 'directionality_ltr');
      });
    });

    test('when method calls shouldApply function', () {
      bool called = false;
      final variant = ContextVariant('test', (context) {
        called = true;
        return true;
      });

      final result = variant.when(MockBuildContext());

      expect(called, true);
      expect(result, true);
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

    test('named variants are defined', () {
      expect(primary.key, 'primary');
      expect(secondary.key, 'secondary');
      expect(outlined.key, 'outlined');
      expect(large.key, 'large');
      expect(medium.key, 'medium');
      expect(small.key, 'small');
    });
  });
}