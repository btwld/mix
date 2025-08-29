import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Test implementation of VariantMixin
class TestVariantAttribute extends Style<BoxSpec>
    with StyleVariantMixin<TestVariantAttribute, BoxSpec> {
  const TestVariantAttribute({super.variants, super.modifier, super.animation});

  @override
  TestVariantAttribute variant(Variant variant, TestVariantAttribute style) {
    return TestVariantAttribute(
      variants: [...?$variants, VariantStyle(variant, style)],
    );
  }

  @override
  TestVariantAttribute variants(List<VariantStyle<BoxSpec>> value) {
    return TestVariantAttribute(variants: value);
  }

  @override
  StyleSpec<BoxSpec> resolve(BuildContext context) =>
      const StyleSpec(spec: BoxSpec());

  @override
  TestVariantAttribute merge(TestVariantAttribute? other) {
    return TestVariantAttribute(
      variants: other?.$variants ?? $variants,
      modifier: other?.$modifier ?? $modifier,
      animation: other?.$animation ?? $animation,
    );
  }

  @override
  List<Object?> get props => [$variants, $modifier, $animation];
}

TestVariantAttribute Function(TestVariantAttribute style) _testVariantCallback(
  TestVariantAttribute style,
) {
  return (s) => s.merge(style);
}

void main() {
  group('VariantMixin', () {
    test('onDark creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onDark(_testVariantCallback(style));

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);

      final variant = result.$variants!.first.variant;
      expect(variant, isA<ContextVariant>());
    });

    test('onLight creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onLight(_testVariantCallback(style));

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);

      final variant = result.$variants!.first.variant;
      expect(variant, isA<ContextVariant>());
    });

    test('onHover creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onHovered(_testVariantCallback(style));

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onPress creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onPressed(_testVariantCallback(style));

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onDisabled creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onDisabled(_testVariantCallback(style));

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onEnabled creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onEnabled(_testVariantCallback(style));

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onMobile creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onMobile(_testVariantCallback(style));

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onDesktop creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onDesktop(_testVariantCallback(style));

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('orientation variants work correctly', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();

      final portraitResult = attribute.onPortrait(_testVariantCallback(style));
      final landscapeResult = attribute.onLandscape(
        _testVariantCallback(style),
      );

      expect(portraitResult.$variants!.length, 1);
      expect(landscapeResult.$variants!.length, 1);
      expect(portraitResult.$variants!.first.variant, isA<ContextVariant>());
      expect(landscapeResult.$variants!.first.variant, isA<ContextVariant>());
    });

    test('direction variants work correctly', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();

      final ltrResult = attribute.onLtr(_testVariantCallback(style));
      final rtlResult = attribute.onRtl(_testVariantCallback(style));

      expect(ltrResult.$variants!.length, 1);
      expect(rtlResult.$variants!.length, 1);
      expect(ltrResult.$variants!.first.variant, isA<ContextVariant>());
      expect(rtlResult.$variants!.first.variant, isA<ContextVariant>());
    });

    test('platform variants work correctly', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();

      final iosResult = attribute.onIos(_testVariantCallback(style));
      final androidResult = attribute.onAndroid(_testVariantCallback(style));
      final macosResult = attribute.onMacos(_testVariantCallback(style));
      final windowsResult = attribute.onWindows(_testVariantCallback(style));
      final linuxResult = attribute.onLinux(_testVariantCallback(style));
      final fuchsiaResult = attribute.onFuchsia(_testVariantCallback(style));
      final webResult = attribute.onWeb(_testVariantCallback(style));

      expect(iosResult.$variants!.length, 1);
      expect(androidResult.$variants!.length, 1);
      expect(macosResult.$variants!.length, 1);
      expect(windowsResult.$variants!.length, 1);
      expect(linuxResult.$variants!.length, 1);
      expect(fuchsiaResult.$variants!.length, 1);
      expect(webResult.$variants!.length, 1);
    });

    test('widget state variants work correctly', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();

      final focusResult = attribute.onFocused(_testVariantCallback(style));
      final selectedResult = attribute.onSelected(_testVariantCallback(style));
      final draggedResult = attribute.onDragged(_testVariantCallback(style));
      final errorResult = attribute.onError(_testVariantCallback(style));
      final scrolledUnderResult = attribute.onScrolledUnder(
        _testVariantCallback(style),
      );

      expect(focusResult.$variants!.length, 1);
      expect(selectedResult.$variants!.length, 1);
      expect(draggedResult.$variants!.length, 1);
      expect(errorResult.$variants!.length, 1);
      expect(scrolledUnderResult.$variants!.length, 1);
    });

    test('onTablet creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onTablet(_testVariantCallback(style));

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onBreakpoint creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final breakpoint = Breakpoint(minWidth: 800, maxWidth: 1200);
      final result = attribute.onBreakpoint(
        breakpoint,
        _testVariantCallback(style),
      );

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('variant creates proper style attribute', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();

      final result = attribute.onDark(_testVariantCallback(style));

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.value, equals(style));
    });

    test('variant can be chained with different styles', () {
      const attribute = TestVariantAttribute();
      const darkStyle = TestVariantAttribute();
      const hoverStyle = TestVariantAttribute();

      final result = attribute
          .onDark(_testVariantCallback(darkStyle))
          .onHovered(_testVariantCallback(hoverStyle));

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 2);

      expect(result.$variants!.first.value, equals(darkStyle));
      expect(result.$variants!.last.value, equals(hoverStyle));
    });
  });
}
