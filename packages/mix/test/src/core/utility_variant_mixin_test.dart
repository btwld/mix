import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('UtilityVariantMixin', () {
    late BoxMutableStyler styler;

    setUp(() {
      styler = BoxMutableStyler();
    });

    group('brightness variants', () {
      test('onDark creates correct variant', () {
        final result = styler.onDark(BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariant>());
        expect(
          (result.$variants!.first.variant as ContextVariant).key,
          contains('brightness'),
        );
      });

      test('onLight creates correct variant', () {
        final result = styler.onLight(BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariant>());
        expect(
          (result.$variants!.first.variant as ContextVariant).key,
          contains('brightness'),
        );
      });
    });

    group('orientation variants', () {
      test('onPortrait creates correct variant', () {
        final result = styler.onPortrait(BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariant>());
        expect(
          (result.$variants!.first.variant as ContextVariant).key,
          contains('orientation'),
        );
      });

      test('onLandscape creates correct variant', () {
        final result = styler.onLandscape(BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariant>());
        expect(
          (result.$variants!.first.variant as ContextVariant).key,
          contains('orientation'),
        );
      });
    });

    group('breakpoint variants', () {
      test('onMobile creates correct variant', () {
        final result = styler.onMobile(BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariant>());
      });

      test('onTablet creates correct variant', () {
        final result = styler.onTablet(BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariant>());
      });

      test('onDesktop creates correct variant', () {
        final result = styler.onDesktop(BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariant>());
      });

      test('onBreakpoint creates correct variant with custom breakpoint', () {
        final breakpoint = Breakpoint(minWidth: 800, maxWidth: 1200);
        final result = styler.onBreakpoint(breakpoint, BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariant>());
      });
    });

    group('directionality variants', () {
      test('onLtr creates correct variant', () {
        final result = styler.onLtr(BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariant>());
        expect(
          (result.$variants!.first.variant as ContextVariant).key,
          contains('directionality'),
        );
      });

      test('onRtl creates correct variant', () {
        final result = styler.onRtl(BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariant>());
        expect(
          (result.$variants!.first.variant as ContextVariant).key,
          contains('directionality'),
        );
      });
    });

    group('platform variants', () {
      test('onIos creates correct variant', () {
        final result = styler.onIos(BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariant>());
        expect(
          (result.$variants!.first.variant as ContextVariant).key,
          contains('platform'),
        );
      });

      test('onAndroid creates correct variant', () {
        final result = styler.onAndroid(BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariant>());
        expect(
          (result.$variants!.first.variant as ContextVariant).key,
          contains('platform'),
        );
      });

      test('onMacos creates correct variant', () {
        final result = styler.onMacos(BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariant>());
        expect(
          (result.$variants!.first.variant as ContextVariant).key,
          contains('platform'),
        );
      });

      test('onWindows creates correct variant', () {
        final result = styler.onWindows(BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariant>());
        expect(
          (result.$variants!.first.variant as ContextVariant).key,
          contains('platform'),
        );
      });

      test('onLinux creates correct variant', () {
        final result = styler.onLinux(BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariant>());
        expect(
          (result.$variants!.first.variant as ContextVariant).key,
          contains('platform'),
        );
      });

      test('onFuchsia creates correct variant', () {
        final result = styler.onFuchsia(BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariant>());
        expect(
          (result.$variants!.first.variant as ContextVariant).key,
          contains('platform'),
        );
      });

      test('onWeb creates correct variant', () {
        final result = styler.onWeb(BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariant>());
        expect(
          (result.$variants!.first.variant as ContextVariant).key,
          equals('web'),
        );
      });
    });

    group('onNot variant', () {
      test('onNot creates negated variant', () {
        final darkVariant = ContextVariant.brightness(Brightness.dark);
        final result = styler.onNot(darkVariant, BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariant>());
        expect(
          (result.$variants!.first.variant as ContextVariant).key,
          startsWith('not_'),
        );
      });
    });

    group('onBuilder variant', () {
      test('onBuilder creates ContextVariantBuilder', () {
        final result = styler.onBuilder((context) => BoxStyler());

        expect(result.$variants, isNotNull);
        expect(result.$variants!.length, 1);
        expect(result.$variants!.first.variant, isA<ContextVariantBuilder>());
      });
    });

    group('chaining variants', () {
      test('can chain multiple variant methods', () {
        final darkStyle = BoxStyler();
        final mobileStyle = BoxStyler();

        final result = styler.onDark(darkStyle);
        final chained = BoxMutableStyler(result).onMobile(mobileStyle);

        expect(chained.$variants, isNotNull);
        expect(chained.$variants!.length, 2);
      });
    });

    group('API parity with VariantStyleMixin', () {
      test('BoxStyler and BoxMutableStyler have matching variant methods', () {
        final boxStyler = BoxStyler();
        final mutableStyler = BoxMutableStyler();
        final testStyle = BoxStyler();

        // Test that all methods exist and return valid results
        expect(boxStyler.onDark(testStyle).$variants, isNotNull);
        expect(mutableStyler.onDark(testStyle).$variants, isNotNull);

        expect(boxStyler.onLight(testStyle).$variants, isNotNull);
        expect(mutableStyler.onLight(testStyle).$variants, isNotNull);

        expect(boxStyler.onPortrait(testStyle).$variants, isNotNull);
        expect(mutableStyler.onPortrait(testStyle).$variants, isNotNull);

        expect(boxStyler.onLandscape(testStyle).$variants, isNotNull);
        expect(mutableStyler.onLandscape(testStyle).$variants, isNotNull);

        expect(boxStyler.onMobile(testStyle).$variants, isNotNull);
        expect(mutableStyler.onMobile(testStyle).$variants, isNotNull);

        expect(boxStyler.onTablet(testStyle).$variants, isNotNull);
        expect(mutableStyler.onTablet(testStyle).$variants, isNotNull);

        expect(boxStyler.onDesktop(testStyle).$variants, isNotNull);
        expect(mutableStyler.onDesktop(testStyle).$variants, isNotNull);

        expect(boxStyler.onLtr(testStyle).$variants, isNotNull);
        expect(mutableStyler.onLtr(testStyle).$variants, isNotNull);

        expect(boxStyler.onRtl(testStyle).$variants, isNotNull);
        expect(mutableStyler.onRtl(testStyle).$variants, isNotNull);

        expect(boxStyler.onIos(testStyle).$variants, isNotNull);
        expect(mutableStyler.onIos(testStyle).$variants, isNotNull);

        expect(boxStyler.onAndroid(testStyle).$variants, isNotNull);
        expect(mutableStyler.onAndroid(testStyle).$variants, isNotNull);

        expect(boxStyler.onMacos(testStyle).$variants, isNotNull);
        expect(mutableStyler.onMacos(testStyle).$variants, isNotNull);

        expect(boxStyler.onWindows(testStyle).$variants, isNotNull);
        expect(mutableStyler.onWindows(testStyle).$variants, isNotNull);

        expect(boxStyler.onLinux(testStyle).$variants, isNotNull);
        expect(mutableStyler.onLinux(testStyle).$variants, isNotNull);

        expect(boxStyler.onFuchsia(testStyle).$variants, isNotNull);
        expect(mutableStyler.onFuchsia(testStyle).$variants, isNotNull);

        expect(boxStyler.onWeb(testStyle).$variants, isNotNull);
        expect(mutableStyler.onWeb(testStyle).$variants, isNotNull);
      });
    });
  });
}
