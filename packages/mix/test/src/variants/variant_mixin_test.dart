import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

// Test helper for PointerPosition context
class MockBuildContextWithPointerPosition extends MockBuildContext {
  final PointerPosition _position;

  MockBuildContextWithPointerPosition(this._position);

  @override
  T? getInheritedWidgetOfExactType<T extends InheritedWidget>() {
    if (T == PointerPositionProvider) {
      final notifier = PointerPositionNotifier();
      notifier.addListener(() {}); // Add listener so it tracks position
      notifier.updatePosition(_position.position, _position.offset);
      return PointerPositionProvider(notifier: notifier, child: const SizedBox()) as T?;
    }
    return super.getInheritedWidgetOfExactType<T>();
  }
}

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

    test('onPointerPosition creates variant with builder', () {
      const attribute = TestVariantAttribute();
      final result = attribute.onPointerPosition((position) {
        return const TestVariantAttribute();
      });

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      expect(result.$variants!.first.variant, isA<ContextVariantBuilder>());
    });

    test('orientation variants work correctly', () {
      const attribute = TestVariantAttribute();
      const style = TestVariantAttribute();

      final portraitResult = attribute.onPortrait(style);
      final landscapeResult = attribute.onLandscape(
        style,
      );

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
      final scrolledUnderResult = attribute.onScrolledUnder(
        style,
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
      final result = attribute.onTablet(style);

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
        style,
      );

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

      final result = attribute
          .onDark(darkStyle)
          .onHovered(hoverStyle);

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 2);

      expect(result.$variants!.first.value, equals(darkStyle));
      expect(result.$variants!.last.value, equals(hoverStyle));
    });

    test('onPointerPosition builder receives position from context', () {
      const position = PointerPosition(
        position: Alignment.center,
        offset: Offset(100, 50),
      );
      
      PointerPosition? receivedPosition;
      const attribute = TestVariantAttribute();
      final result = attribute.onPointerPosition((pos) {
        receivedPosition = pos;
        return const TestVariantAttribute();
      });

      final variant = result.$variants!.first.variant as ContextVariantBuilder;
      
      // Create a mock context that returns the position
      final mockContext = MockBuildContextWithPointerPosition(position);
      
      // Build the variant which should call our function
      variant.build(mockContext);

      // The function should have been called with the position
      expect(receivedPosition, equals(position));
    });

    test('onPointerPosition handles null position gracefully', () {
      const attribute = TestVariantAttribute();
      var wasCallbackCalled = false;
      
      final result = attribute.onPointerPosition((position) {
        wasCallbackCalled = true;
        return const TestVariantAttribute();
      });

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 1);
      
      final variant = result.$variants!.first.variant as ContextVariantBuilder;
      // Create a mock context without PointerPosition
      final mockContext = MockBuildContext();
      
      // Should return the base style without calling callback
      final builtStyle = variant.build(mockContext);
      expect(builtStyle, isA<TestVariantAttribute>());
      expect(wasCallbackCalled, isFalse);
    });

    test('onPointerPosition works with other variants', () {
      const attribute = TestVariantAttribute();
      const hoverStyle = TestVariantAttribute();
      
      final result = attribute
          .onHovered(hoverStyle)
          .onPointerPosition((position) => const TestVariantAttribute());

      expect(result.$variants, isNotNull);
      expect(result.$variants!.length, 2);
      expect(result.$variants!.first.variant, isA<ContextVariant>());
      expect(result.$variants!.last.variant, isA<ContextVariantBuilder>());
    });
  });
}
