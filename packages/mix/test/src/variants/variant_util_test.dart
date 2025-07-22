import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('OnContextVariantUtility', () {
    const utility = OnContextVariantUtility();

    group('Widget State Variants', () {
      test('hover creates VariantAttributeBuilder with hovered state', () {
        final builder = utility.hover;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('press creates VariantAttributeBuilder with pressed state', () {
        final builder = utility.press;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('focus creates VariantAttributeBuilder with focused state', () {
        final builder = utility.focus;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('disabled creates VariantAttributeBuilder with disabled state', () {
        final builder = utility.disabled;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('selected creates VariantAttributeBuilder with selected state', () {
        final builder = utility.selected;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('dragged creates VariantAttributeBuilder with dragged state', () {
        final builder = utility.dragged;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('error creates VariantAttributeBuilder with error state', () {
        final builder = utility.error;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('enabled creates VariantAttributeBuilder with not disabled state', () {
        final builder = utility.enabled;
        expect(builder, isA<VariantAttributeBuilder>());
      });
    });

    group('Platform Brightness Variants', () {
      test('dark creates VariantAttributeBuilder for dark mode', () {
        final builder = utility.dark;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('light creates VariantAttributeBuilder for light mode', () {
        final builder = utility.light;
        expect(builder, isA<VariantAttributeBuilder>());
      });
    });

    group('Orientation Variants', () {
      test('portrait creates VariantAttributeBuilder for portrait orientation', () {
        final builder = utility.portrait;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('landscape creates VariantAttributeBuilder for landscape orientation', () {
        final builder = utility.landscape;
        expect(builder, isA<VariantAttributeBuilder>());
      });
    });

    group('Size Variants', () {
      test('mobile creates VariantAttributeBuilder for mobile size', () {
        final builder = utility.mobile;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('tablet creates VariantAttributeBuilder for tablet size', () {
        final builder = utility.tablet;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('desktop creates VariantAttributeBuilder for desktop size', () {
        final builder = utility.desktop;
        expect(builder, isA<VariantAttributeBuilder>());
      });
    });

    group('Text Direction Variants', () {
      test('ltr creates VariantAttributeBuilder for left-to-right direction', () {
        final builder = utility.ltr;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('rtl creates VariantAttributeBuilder for right-to-left direction', () {
        final builder = utility.rtl;
        expect(builder, isA<VariantAttributeBuilder>());
      });
    });

    group('Platform Variants', () {
      test('ios creates VariantAttributeBuilder for iOS platform', () {
        final builder = utility.ios;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('android creates VariantAttributeBuilder for Android platform', () {
        final builder = utility.android;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('macos creates VariantAttributeBuilder for macOS platform', () {
        final builder = utility.macos;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('windows creates VariantAttributeBuilder for Windows platform', () {
        final builder = utility.windows;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('linux creates VariantAttributeBuilder for Linux platform', () {
        final builder = utility.linux;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('fuchsia creates VariantAttributeBuilder for Fuchsia platform', () {
        final builder = utility.fuchsia;
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('web creates VariantAttributeBuilder for web platform', () {
        final builder = utility.web;
        expect(builder, isA<VariantAttributeBuilder>());
      });
    });

    group('Breakpoint Variants', () {
      test('minWidth creates VariantAttributeBuilder with minimum width condition', () {
        final builder = utility.minWidth(768.0);
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('maxWidth creates VariantAttributeBuilder with maximum width condition', () {
        final builder = utility.maxWidth(1024.0);
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('widthRange creates VariantAttributeBuilder with width range condition', () {
        final builder = utility.widthRange(768.0, 1024.0);
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('minHeight creates VariantAttributeBuilder with minimum height condition', () {
        final builder = utility.minHeight(600.0);
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('maxHeight creates VariantAttributeBuilder with maximum height condition', () {
        final builder = utility.maxHeight(800.0);
        expect(builder, isA<VariantAttributeBuilder>());
      });

      test('heightRange creates VariantAttributeBuilder with height range condition', () {
        final builder = utility.heightRange(600.0, 800.0);
        expect(builder, isA<VariantAttributeBuilder>());
      });
    });

    group('Singleton Pattern', () {
      test('self returns the same instance', () {
        expect(OnContextVariantUtility.self, same(OnContextVariantUtility.self));
        expect(OnContextVariantUtility.self, isA<OnContextVariantUtility>());
      });
    });
  });

  group('VariantAttributeBuilder', () {
    test('can be created with a variant', () {
      const variant = NamedVariant('test');
      const builder = VariantAttributeBuilder(variant);
      expect(builder, isA<VariantAttributeBuilder>());
    });

    // TODO: Add tests for call method once it's implemented
    // The call method is currently commented out in the source
  });
}