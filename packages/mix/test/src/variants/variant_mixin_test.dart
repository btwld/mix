import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Test implementation of VariantMixin
class TestVariantAttribute extends StyleAttribute<BoxSpec>
    with VariantMixin<TestVariantAttribute, BoxSpec> {
  const TestVariantAttribute({
    super.variants,
    super.modifiers,
    super.animation,
  });

  @override
  TestVariantAttribute variant(Variant variant, TestVariantAttribute style) {
    return TestVariantAttribute(
      variants: [...?$variants, VariantStyleAttribute(variant, style)],
    );
  }

  @override
  TestVariantAttribute createEmptyStyle() {
    return const TestVariantAttribute();
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
      final result = attribute.onDark((style) => style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);

      final variant = result.$variants!.first.variant;
      expect(variant, isA<ContextVariant>());
    });

    test('onLight creates correct variant', () {
      const attribute = TestVariantAttribute();
      final result = attribute.onLight((style) => style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);

      final variant = result.$variants!.first.variant;
      expect(variant, isA<ContextVariant>());
    });

    test('onHover creates correct variant', () {
      const attribute = TestVariantAttribute();
      final result = attribute.onHover((style) => style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onPress creates correct variant', () {
      const attribute = TestVariantAttribute();
      final result = attribute.onPress((style) => style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onDisabled creates correct variant', () {
      const attribute = TestVariantAttribute();
      final result = attribute.onDisabled((style) => style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onEnabled creates correct variant', () {
      const attribute = TestVariantAttribute();
      final result = attribute.onEnabled((style) => style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<MultiVariant>());
    });

    test('onMobile creates correct variant', () {
      const attribute = TestVariantAttribute();
      final result = attribute.onMobile((style) => style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onDesktop creates correct variant', () {
      const attribute = TestVariantAttribute();
      final result = attribute.onDesktop((style) => style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('orientation variants work correctly', () {
      const attribute = TestVariantAttribute();

      final portraitResult = attribute.onPortrait((style) => style);
      final landscapeResult = attribute.onLandscape((style) => style);

      expect(portraitResult.$variants!.length, 1);
      expect(landscapeResult.$variants!.length, 1);
      expect(portraitResult.$variants!.first.variant, isA<ContextVariant>());
      expect(landscapeResult.$variants!.first.variant, isA<ContextVariant>());
    });

    test('direction variants work correctly', () {
      const attribute = TestVariantAttribute();

      final ltrResult = attribute.onLtr((style) => style);
      final rtlResult = attribute.onRtl((style) => style);

      expect(ltrResult.$variants!.length, 1);
      expect(rtlResult.$variants!.length, 1);
      expect(ltrResult.$variants!.first.variant, isA<ContextVariant>());
      expect(rtlResult.$variants!.first.variant, isA<ContextVariant>());
    });

    test('platform variants work correctly', () {
      const attribute = TestVariantAttribute();

      final iosResult = attribute.onIos((style) => style);
      final androidResult = attribute.onAndroid((style) => style);
      final macosResult = attribute.onMacos((style) => style);
      final windowsResult = attribute.onWindows((style) => style);
      final linuxResult = attribute.onLinux((style) => style);
      final fuchsiaResult = attribute.onFuchsia((style) => style);
      final webResult = attribute.onWeb((style) => style);

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

      final focusResult = attribute.onFocus((style) => style);
      final selectedResult = attribute.onSelected((style) => style);
      final draggedResult = attribute.onDragged((style) => style);
      final errorResult = attribute.onError((style) => style);

      expect(focusResult.$variants!.length, 1);
      expect(selectedResult.$variants!.length, 1);
      expect(draggedResult.$variants!.length, 1);
      expect(errorResult.$variants!.length, 1);
    });

    test('onTablet creates correct variant', () {
      const attribute = TestVariantAttribute();
      final result = attribute.onTablet((style) => style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onBreakpoint creates correct variant', () {
      const attribute = TestVariantAttribute();
      final breakpoint = Breakpoint(minWidth: 800, maxWidth: 1200);
      final result = attribute.onBreakpoint(breakpoint, (style) => style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('builder function is called with blank style', () {
      const attribute = TestVariantAttribute();
      TestVariantAttribute? receivedStyle;

      attribute.onDark((style) {
        receivedStyle = style;
        return style;
      });

      expect(receivedStyle, isNotNull);
      expect(receivedStyle, equals(const TestVariantAttribute()));
    });

    test('builder function can modify style', () {
      const attribute = TestVariantAttribute();

      final result = attribute.onDark((style) {
        return const TestVariantAttribute(
          variants: [VariantStyleAttribute(NamedVariant('test'), TestVariantAttribute())],
        );
      });

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      // The returned style should have the variant applied by onDark
      final variantStyle = result.$variants!.first.value;
      expect(variantStyle, isA<TestVariantAttribute>());
    });
  });
}
