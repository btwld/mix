import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Test implementation of VariantMixin
class TestVariantAttribute extends Style<BoxSpec>
    with StyleVariantMixin<TestVariantAttribute, BoxSpec> {
  const TestVariantAttribute({
    super.variants,
    super.modifiers,
    super.animation,
    super.inherit,
    super.orderOfModifiers,
  });

  @override
  TestVariantAttribute variant(Variant variant, TestVariantAttribute style) {
    return TestVariantAttribute(
      variants: [...?$variants, VariantStyleAttribute(variant, style)],
    );
  }

  @override
  TestVariantAttribute variants(List<VariantStyleAttribute<BoxSpec>> value) {
    return TestVariantAttribute(variants: value);
  }

  @override
  BoxSpec resolve(BuildContext context) => const BoxSpec();

  @override
  TestVariantAttribute merge(TestVariantAttribute? other) {
    return TestVariantAttribute(
      variants: other?.$variants ?? $variants,
      modifiers: other?.$modifiers ?? $modifiers,
      animation: other?.$animation ?? $animation,
    );
  }

  @override
  List<Object?> get props => [$variants, $modifiers, $animation];
}

void main() {
  group('VariantMixin', () {
    test('onDark creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onDark(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);

      final variant = result.$variants!.first.variant;
      expect(variant, isA<ContextVariant>());
    });

    test('onLight creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onLight(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);

      final variant = result.$variants!.first.variant;
      expect(variant, isA<ContextVariant>());
    });

    test('onHover creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onHovered(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onPress creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onPressed(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onDisabled creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onDisabled(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onEnabled creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onEnabled(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onMobile creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onMobile(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onDesktop creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onDesktop(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('orientation variants work correctly', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();

      final portraitResult = attribute.onPortrait(style);
      final landscapeResult = attribute.onLandscape(style);

      expect(portraitResult.$variants!.length, 1);
      expect(landscapeResult.$variants!.length, 1);
      expect(portraitResult.$variants!.first.variant, isA<ContextVariant>());
      expect(landscapeResult.$variants!.first.variant, isA<ContextVariant>());
    });

    test('direction variants work correctly', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();

      final ltrResult = attribute.onLtr(style);
      final rtlResult = attribute.onRtl(style);

      expect(ltrResult.$variants!.length, 1);
      expect(rtlResult.$variants!.length, 1);
      expect(ltrResult.$variants!.first.variant, isA<ContextVariant>());
      expect(rtlResult.$variants!.first.variant, isA<ContextVariant>());
    });

    test('platform variants work correctly', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();

      final iosResult = attribute.onIos(style);
      final androidResult = attribute.onAndroid(style);
      final macosResult = attribute.onMacos(style);
      final windowsResult = attribute.onWindows(style);
      final linuxResult = attribute.onLinux(style);
      final fuchsiaResult = attribute.onFuchsia(style);
      final webResult = attribute.onWeb(style);

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

      final focusResult = attribute.onFocused(style);
      final selectedResult = attribute.onSelected(style);
      final draggedResult = attribute.onDragged(style);
      final errorResult = attribute.onError(style);
      final scrolledUnderResult = attribute.onScrolledUnder(style);

      expect(focusResult.$variants!.length, 1);
      expect(selectedResult.$variants!.length, 1);
      expect(draggedResult.$variants!.length, 1);
      expect(errorResult.$variants!.length, 1);
      expect(scrolledUnderResult.$variants!.length, 1);
    });

    test('onTablet creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onTablet(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onBreakpoint creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final breakpoint = Breakpoint(minWidth: 800, maxWidth: 1200);
      final result = attribute.onBreakpoint(breakpoint, style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('variant creates proper style attribute', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();

      final result = attribute.onDark(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.value, equals(style));
    });

    test('variant can be chained with different styles', () {
      const attribute = TestVariantAttribute();
      const darkStyle = TestVariantAttribute();
      const hoverStyle = TestVariantAttribute();

      final result = attribute.onDark(darkStyle).onHovered(hoverStyle);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 2);
      expect(result.$variants!.first.value, equals(darkStyle));
      expect(result.$variants!.last.value, equals(hoverStyle));
    });
  });
}
