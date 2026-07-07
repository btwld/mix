import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('typed context variants', () {
    test(
      'brightness factory returns BrightnessVariant with stable equality',
      () {
        final dark = ContextVariant.brightness(Brightness.dark);
        final anotherDark = ContextVariant.brightness(Brightness.dark);
        final light = ContextVariant.brightness(Brightness.light);

        expect(dark, isA<BrightnessVariant>());
        expect((dark as BrightnessVariant).brightness, Brightness.dark);
        expect(dark.key, 'media_query_platform_brightness_dark');
        expect(dark, anotherDark);
        expect(dark.hashCode, anotherDark.hashCode);
        expect(dark, isNot(light));
      },
    );

    test('breakpoint factory retains concrete breakpoint data', () {
      const breakpoint = Breakpoint(minWidth: 800, maxWidth: 1200);
      final variant = ContextVariant.breakpoint(breakpoint);
      final sameVariant = ContextVariant.breakpoint(breakpoint);

      expect(variant, isA<BreakpointVariant>());
      expect((variant as BreakpointVariant).breakpoint, breakpoint);
      expect(variant.key, 'breakpoint_800.0_1200.0');
      expect(variant, sameVariant);
      expect(variant.hashCode, sameVariant.hashCode);
    });

    test('breakpoint factory retains token-backed breakpoint data', () {
      const token = BreakpointToken('breakpoint.custom');
      final ref = token();
      final variant = ContextVariant.breakpoint(ref);

      expect(variant, isA<BreakpointVariant>());
      expect((variant as BreakpointVariant).breakpoint, ref);
      expect(variant.key, 'breakpoint_breakpoint.custom');
    });

    test('not factory returns NotVariant with stable equality', () {
      final disabled = ContextVariant.widgetState(WidgetState.disabled);
      final enabled = ContextVariant.not(disabled);
      final anotherEnabled = ContextVariant.not(
        ContextVariant.widgetState(WidgetState.disabled),
      );

      expect(enabled, isA<NotVariant>());
      expect((enabled as NotVariant).inner, disabled);
      expect(enabled.key, 'not_widget_state_disabled');
      expect(enabled, anotherEnabled);
      expect(enabled.hashCode, anotherEnabled.hashCode);
    });
  });

  group('responsive breakpoint shorthand factories', () {
    test('mobile factory has stable breakpoint token key', () {
      expect(ContextVariant.mobile().key, 'breakpoint_mix.breakpoint.mobile');
    });

    test('tablet factory has stable breakpoint token key', () {
      expect(ContextVariant.tablet().key, 'breakpoint_mix.breakpoint.tablet');
    });

    test('desktop factory has stable breakpoint token key', () {
      expect(ContextVariant.desktop().key, 'breakpoint_mix.breakpoint.desktop');
    });
  });

  group('size factory', () {
    test('creates variant with correct key', () {
      final variant = ContextVariant.size('mobile', (size) => size.width < 768);

      expect(variant.key, 'media_query_size_mobile');
    });
  });

  group('shouldApply behavior', () {
    testWidgets('brightness variant applies for matching theme brightness', (
      tester,
    ) async {
      final dark = ContextVariant.brightness(Brightness.dark);
      final light = ContextVariant.brightness(Brightness.light);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(platformBrightness: Brightness.dark),
            child: Builder(
              builder: (context) {
                expect(dark.shouldApply(context), isTrue);
                expect(light.shouldApply(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('breakpoint variant applies from MediaQuery width', (
      tester,
    ) async {
      const breakpoint = Breakpoint(minWidth: 400, maxWidth: 800);
      final variant = ContextVariant.breakpoint(breakpoint);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(500, 800)),
            child: Builder(
              builder: (context) {
                expect(variant.shouldApply(context), isTrue);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(200, 800)),
            child: Builder(
              builder: (context) {
                expect(variant.shouldApply(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('not variant inverts inner shouldApply result', (tester) async {
      final disabled = ContextVariant.widgetState(WidgetState.disabled);
      final enabled = ContextVariant.not(disabled);

      await tester.pumpWidget(
        MaterialApp(
          home: WidgetStateProvider(
            states: const {WidgetState.disabled},
            child: Builder(
              builder: (context) {
                expect(disabled.shouldApply(context), isTrue);
                expect(enabled.shouldApply(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });
}
