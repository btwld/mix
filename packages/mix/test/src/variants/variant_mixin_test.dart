import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

// Test implementation of VariantMixin
class TestVariantAttribute extends Style<BoxSpec>
    with
        VariantStyleMixin<TestVariantAttribute, BoxSpec>,
        WidgetStateVariantMixin<TestVariantAttribute, BoxSpec> {
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

    test('onEnabled creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onEnabled(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
    });

    test('onBuilder creates correct variant', () {
      const attribute = TestVariantAttribute();
      final result = attribute.onBuilder((context) => attribute);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariantBuilder>());
    });

    test(
      'builder (deprecated) still works and creates same result as onBuilder',
      () {
        const attribute = TestVariantAttribute();

        final onBuilderResult = attribute.onBuilder((context) => attribute);
        final builderResult = attribute.builder((context) => attribute);

        expect(builderResult.$variants, isNotNull);
        expect(builderResult.$variants!.length, 1);
        expect(
          builderResult.$variants!.first.variant,
          isA<ContextVariantBuilder>(),
        );

        // Both should create the same type of variant
        expect(
          builderResult.$variants!.first.variant.runtimeType,
          equals(onBuilderResult.$variants!.first.variant.runtimeType),
        );
      },
    );

    test('onBuilder function receives correct context', () {
      const attribute = TestVariantAttribute();
      BuildContext? capturedContext;

      final result = attribute.onBuilder((context) {
        capturedContext = context;
        return attribute;
      });

      // Get the variant builder and execute it
      final variantBuilder =
          result.$variants!.first.variant
              as ContextVariantBuilder<TestVariantAttribute>;
      final mockContext = MockBuildContext();
      variantBuilder.build(mockContext);

      expect(capturedContext, same(mockContext));
    });
  });

  group('applyVariants', () {
    test('returns concrete type T', () {
      const smallVariant = NamedVariant('small');
      const attribute = TestVariantAttribute();
      const smallStyle = TestVariantAttribute();

      final withVariant = attribute.variant(smallVariant, smallStyle);
      final result = withVariant.applyVariants([smallVariant]);

      expect(result, isA<TestVariantAttribute>());
    });

    test('merges matching variant style into result', () {
      const smallVariant = NamedVariant('small');
      const attribute = TestVariantAttribute();
      const smallStyle = TestVariantAttribute();

      final withVariant = attribute.variant(smallVariant, smallStyle);
      final result = withVariant.applyVariants([smallVariant]);

      // The applied variant style is merged, and variant stays in $variants
      // (harmless - only re-applies if explicitly passed to build's namedVariants)
      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
    });

    test('keeps all variants in \$variants after applying', () {
      const smallVariant = NamedVariant('small');
      const largeVariant = NamedVariant('large');
      const attribute = TestVariantAttribute();
      const smallStyle = TestVariantAttribute();
      const largeStyle = TestVariantAttribute();

      final withVariants = attribute
          .variant(smallVariant, smallStyle)
          .variant(largeVariant, largeStyle);

      // Apply only small - both variants stay (style is merged in)
      final result = withVariants.applyVariants([smallVariant]);

      // Both variants remain (applied variant styles are merged in)
      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 2);
      expect(result.$variants!.any((v) => v.variant == largeVariant), isTrue);
      expect(result.$variants!.any((v) => v.variant == smallVariant), isTrue);
    });

    test('applies multiple variants at once', () {
      const smallVariant = NamedVariant('small');
      const primaryVariant = NamedVariant('primary');
      const outlinedVariant = NamedVariant('outlined');
      const attribute = TestVariantAttribute();
      const smallStyle = TestVariantAttribute();
      const primaryStyle = TestVariantAttribute();
      const outlinedStyle = TestVariantAttribute();

      final withVariants = attribute
          .variant(smallVariant, smallStyle)
          .variant(primaryVariant, primaryStyle)
          .variant(outlinedVariant, outlinedStyle);

      // Apply small and primary - all variants stay (styles are merged in)
      final result = withVariants.applyVariants([smallVariant, primaryVariant]);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 3);
    });

    test('handles non-existent variants gracefully', () {
      const smallVariant = NamedVariant('small');
      const nonExistent = NamedVariant('nonexistent');
      const attribute = TestVariantAttribute();
      const smallStyle = TestVariantAttribute();

      final withVariant = attribute.variant(smallVariant, smallStyle);

      // Applying a non-existent variant should not throw
      final result = withVariant.applyVariants([nonExistent]);

      // Original variant should still be there
      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, equals(smallVariant));
    });

    test('handles empty variant list', () {
      const smallVariant = NamedVariant('small');
      const attribute = TestVariantAttribute();
      const smallStyle = TestVariantAttribute();

      final withVariant = attribute.variant(smallVariant, smallStyle);

      // Applying empty list should not change anything
      final result = withVariant.applyVariants([]);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, equals(smallVariant));
    });

    test('handles duplicate variants in apply list', () {
      const smallVariant = NamedVariant('small');
      const attribute = TestVariantAttribute();
      const smallStyle = TestVariantAttribute();

      final withVariant = attribute.variant(smallVariant, smallStyle);

      // Applying same variant multiple times should work (merges once per match)
      final result = withVariant.applyVariants([smallVariant, smallVariant]);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
    });

    test('preserves all variants when applying named variants', () {
      const smallVariant = NamedVariant('small');
      const attribute = TestVariantAttribute();
      const smallStyle = TestVariantAttribute();
      const darkStyle = TestVariantAttribute();

      final withVariants = attribute
          .variant(smallVariant, smallStyle)
          .onDark(darkStyle);

      final result = withVariants.applyVariants([smallVariant]);

      // Both variants remain (named variant style is merged in)
      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 2);
      expect(result.$variants!.any((v) => v.variant is ContextVariant), isTrue);
      expect(result.$variants!.any((v) => v.variant == smallVariant), isTrue);
    });
  });
}
