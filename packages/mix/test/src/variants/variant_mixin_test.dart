import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

// Test implementation of VariantMixin
class TestVariantAttribute extends Style<BoxSpec>
    with VariantStyleMixin<TestVariantAttribute, BoxSpec> {
  const TestVariantAttribute({super.variants, super.modifier, super.animation});

  @override
  TestVariantAttribute variant(covariant VariantStyle<BoxSpec> variantStyle) {
    return TestVariantAttribute(variants: [...?$variants, variantStyle]);
  }

  @override
  TestVariantAttribute withVariants(List<VariantStyle<BoxSpec>> value) {
    return merge(TestVariantAttribute(variants: value));
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

      final variantStyle = result.$variants!.first;
      expect(variantStyle, isA<ContextVariantStyle<BoxSpec>>());
      if (variantStyle is ContextVariantStyle<BoxSpec>) {
        expect(variantStyle.trigger, isA<ContextVariant>());
      }
    });

    test('onLight creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onLight(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);

      final variantStyle = result.$variants!.first;
      expect(variantStyle, isA<ContextVariantStyle<BoxSpec>>());
      if (variantStyle is ContextVariantStyle<BoxSpec>) {
        expect(variantStyle.trigger, isA<ContextVariant>());
      }
    });

    test('onHover creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onHovered(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      final variantStyle = result.$variants!.first;
      expect(variantStyle, isA<ContextVariantStyle<BoxSpec>>());
      if (variantStyle is ContextVariantStyle<BoxSpec>) {
        expect(variantStyle.trigger, isA<ContextVariant>());
      }
    });

    test('onPress creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onPressed(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      final variantStyle = result.$variants!.first;
      expect(variantStyle, isA<ContextVariantStyle<BoxSpec>>());
      if (variantStyle is ContextVariantStyle<BoxSpec>) {
        expect(variantStyle.trigger, isA<ContextVariant>());
      }
    });

    test('onDisabled creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onDisabled(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      final variantStyle = result.$variants!.first;
      expect(variantStyle, isA<ContextVariantStyle<BoxSpec>>());
      if (variantStyle is ContextVariantStyle<BoxSpec>) {
        expect(variantStyle.trigger, isA<ContextVariant>());
      }
    });

    test('onFocused creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onFocused(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      final variantStyle = result.$variants!.first;
      expect(variantStyle, isA<ContextVariantStyle<BoxSpec>>());
      if (variantStyle is ContextVariantStyle<BoxSpec>) {
        expect(variantStyle.trigger, isA<ContextVariant>());
      }
    });

    test('onSelected creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onSelected(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      final variantStyle = result.$variants!.first;
      expect(variantStyle, isA<ContextVariantStyle<BoxSpec>>());
      if (variantStyle is ContextVariantStyle<BoxSpec>) {
        expect(variantStyle.trigger, isA<ContextVariant>());
      }
    });

    test('onMobile creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onMobile(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      final variantStyle = result.$variants!.first;
      expect(variantStyle, isA<ContextVariantStyle<BoxSpec>>());
      if (variantStyle is ContextVariantStyle<BoxSpec>) {
        expect(variantStyle.trigger, isA<ContextVariant>());
      }
    });

    test('onDesktop creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onDesktop(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      final variantStyle = result.$variants!.first;
      expect(variantStyle, isA<ContextVariantStyle<BoxSpec>>());
      if (variantStyle is ContextVariantStyle<BoxSpec>) {
        expect(variantStyle.trigger, isA<ContextVariant>());
      }
    });

    test('onTablet creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onTablet(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      final variantStyle = result.$variants!.first;
      expect(variantStyle, isA<ContextVariantStyle<BoxSpec>>());
      if (variantStyle is ContextVariantStyle<BoxSpec>) {
        expect(variantStyle.trigger, isA<ContextVariant>());
      }
    });

    test('onBreakpoint creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final breakpoint = Breakpoint(minWidth: 800, maxWidth: 1200);
      final result = attribute.onBreakpoint(breakpoint, style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      final variantStyle = result.$variants!.first;
      expect(variantStyle, isA<ContextVariantStyle<BoxSpec>>());
      if (variantStyle is ContextVariantStyle<BoxSpec>) {
        expect(variantStyle.trigger, isA<ContextVariant>());
      }
    });

    test('variant creates proper style attribute', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();

      final result = attribute.onDark(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      final variantStyle = result.$variants!.first;
      expect(variantStyle, isA<ContextVariantStyle<BoxSpec>>());
      if (variantStyle is ContextVariantStyle<BoxSpec>) {
        expect(variantStyle.style, equals(style));
      }
    });

    test('variant can be chained with different styles', () {
      const attribute = TestVariantAttribute();
      const darkStyle = TestVariantAttribute();
      const hoverStyle = TestVariantAttribute();

      final result = attribute.onDark(darkStyle).onHovered(hoverStyle);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 2);

      final firstVariant = result.$variants!.first;
      final lastVariant = result.$variants!.last;
      expect(firstVariant, isA<ContextVariantStyle<BoxSpec>>());
      expect(lastVariant, isA<ContextVariantStyle<BoxSpec>>());
      if (firstVariant is ContextVariantStyle<BoxSpec> &&
          lastVariant is ContextVariantStyle<BoxSpec>) {
        expect(firstVariant.style, equals(darkStyle));
        expect(lastVariant.style, equals(hoverStyle));
      }
    });

    test('onError creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onError(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      final variantStyle = result.$variants!.first;
      expect(variantStyle, isA<ContextVariantStyle<BoxSpec>>());
      if (variantStyle is ContextVariantStyle<BoxSpec>) {
        expect(variantStyle.trigger, isA<ContextVariant>());
      }
    });

    test('onScrolledUnder creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onScrolledUnder(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      final variantStyle = result.$variants!.first;
      expect(variantStyle, isA<ContextVariantStyle<BoxSpec>>());
      if (variantStyle is ContextVariantStyle<BoxSpec>) {
        expect(variantStyle.trigger, isA<ContextVariant>());
      }
    });

    test('onDragged creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onDragged(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      final variantStyle = result.$variants!.first;
      expect(variantStyle, isA<ContextVariantStyle<BoxSpec>>());
      if (variantStyle is ContextVariantStyle<BoxSpec>) {
        expect(variantStyle.trigger, isA<ContextVariant>());
      }
    });

    test('onEnabled creates correct variant', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();
      final result = attribute.onEnabled(style);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      final variantStyle = result.$variants!.first;
      expect(variantStyle, isA<ContextVariantStyle<BoxSpec>>());
      if (variantStyle is ContextVariantStyle<BoxSpec>) {
        expect(variantStyle.trigger, isA<ContextVariant>());
      }
    });

    test('onBuilder creates correct variant', () {
      const attribute = TestVariantAttribute();
      final result = attribute.onBuilder((context) => attribute);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first, isA<VariantStyleBuilder<BoxSpec>>());
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
          builderResult.$variants!.first,
          isA<VariantStyleBuilder<BoxSpec>>(),
        );

        // Both should create the same type of variant
        expect(
          builderResult.$variants!.first.runtimeType,
          equals(onBuilderResult.$variants!.first.runtimeType),
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
          result.$variants!.first as VariantStyleBuilder<BoxSpec>;
      final mockContext = MockBuildContext();
      variantBuilder.resolve(mockContext);

      expect(capturedContext, same(mockContext));
    });
  });
}
