import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Test implementation of VariantMixin
class TestVariantAttribute extends Style<BoxSpec>
    with VariantStyleMixin<TestVariantAttribute, BoxSpec> {
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
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: $modifier?.merge(other?.$modifier) ?? other?.$modifier,
      animation: other?.$animation ?? $animation,
    );
  }

  @override
  List<Object?> get props => [$variants, $modifier, $animation];
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

    test('onFocused creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onFocused(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onSelected creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onSelected(style);

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

    test('onError creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onError(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onScrolledUnder creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onScrolledUnder(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onDragged creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onDragged(style);

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
  });
}