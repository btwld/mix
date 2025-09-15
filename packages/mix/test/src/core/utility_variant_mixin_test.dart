import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Test implementation that uses the utility variant mixin
class TestUtilityVariant extends Spec<TestUtilityVariant>
    with UtilityVariantMixin<TestUtilityVariant, TestUtilityStyle> {
  final List<VariantStyle<TestUtilityVariant>> variantCalls;
  final String value;

  const TestUtilityVariant({
    required this.value,
    List<VariantStyle<TestUtilityVariant>>? variantCalls,
  }) : variantCalls =
           variantCalls ?? const <VariantStyle<TestUtilityVariant>>[];

  @override
  TestUtilityStyle withVariants(
    List<VariantStyle<TestUtilityVariant>> variants,
  ) {
    return TestUtilityStyle(
      value: value,
      variantCalls: [...variantCalls, ...variants],
    );
  }

  @override
  TestUtilityStyle get currentValue =>
      TestUtilityStyle(value: value, variantCalls: variantCalls);

  @override
  TestUtilityVariant resolve(BuildContext context) {
    return this;
  }

  @override
  TestUtilityVariant merge(TestUtilityVariant? other) {
    return TestUtilityVariant(
      value: other?.value ?? value,
      variantCalls: [...variantCalls, ...?other?.variantCalls],
    );
  }

  @override
  TestUtilityVariant copyWith() {
    return TestUtilityVariant(value: value, variantCalls: variantCalls);
  }

  @override
  TestUtilityVariant lerp(TestUtilityVariant? other, double t) {
    return other ?? this;
  }

  @override
  List<Object?> get props => [value, variantCalls];
}

class TestUtilityStyle extends Style<TestUtilityVariant>
    with UtilityVariantMixin<TestUtilityVariant, TestUtilityStyle> {
  final String value;
  final List<VariantStyle<TestUtilityVariant>> variantCalls;

  TestUtilityStyle({
    required this.value,
    List<VariantStyle<TestUtilityVariant>>? variantCalls,
    super.variants,
    super.modifier,
    super.animation,
  }) : variantCalls = variantCalls ?? <VariantStyle<TestUtilityVariant>>[];

  @override
  TestUtilityStyle get currentValue => this;

  @override
  TestUtilityStyle withVariants(
    List<VariantStyle<TestUtilityVariant>> variants,
  ) {
    return TestUtilityStyle(
      value: value,
      variantCalls: [...variantCalls, ...variants],
      variants: $variants,
      modifier: $modifier,
      animation: $animation,
    );
  }

  @override
  TestUtilityStyle animate(AnimationConfig animation) {
    return TestUtilityStyle(
      value: value,
      variantCalls: variantCalls,
      variants: $variants,
      modifier: $modifier,
      animation: animation,
    );
  }

  @override
  StyleSpec<TestUtilityVariant> resolve(BuildContext context) {
    return StyleSpec(
      spec: TestUtilityVariant(value: value, variantCalls: variantCalls),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  TestUtilityStyle merge(TestUtilityStyle? other) {
    return TestUtilityStyle(
      value: other?.value ?? value,
      variantCalls: [...variantCalls, ...?other?.variantCalls],
      variants: $variants,
      modifier: $modifier,
      animation: $animation,
    );
  }

  @override
  List<Object?> get props => [
    value,
    variantCalls,
    $animation,
    $modifier,
    $variants,
  ];
}

void main() {
  group('UtilityVariantMixin', () {
    late TestUtilityVariant testUtility;

    setUp(() {
      testUtility = const TestUtilityVariant(value: 'test');
    });

    group('onHovered', () {
      test('should create variant for hovered state', () {
        final hoverStyle = TestUtilityStyle(value: 'hovered');
        final result = testUtility.onHovered(hoverStyle);

        expect(result, isA<TestUtilityStyle>());
        expect(result.variantCalls.length, equals(1));

        final variant = result.variantCalls.first;
        expect(variant, isA<ContextVariantStyle<TestUtilityVariant>>());

        final eventVariant = variant as ContextVariantStyle<TestUtilityVariant>;
        expect(eventVariant.trigger, isA<WidgetStateTrigger>());
        expect(eventVariant.style, equals(hoverStyle));
      });

      test('should work with method chaining', () {
        final hoverStyle = TestUtilityStyle(value: 'hovered');
        final pressedStyle = TestUtilityStyle(value: 'pressed');

        final result = testUtility
            .onHovered(hoverStyle)
            .onPressed(pressedStyle);

        expect(result.variantCalls.length, equals(2));
      });
    });

    group('onPressed', () {
      test('should create variant for pressed state', () {
        final pressedStyle = TestUtilityStyle(value: 'pressed');
        final result = testUtility.onPressed(pressedStyle);

        expect(result, isA<TestUtilityStyle>());
        expect(result.variantCalls.length, equals(1));

        final variant = result.variantCalls.first;
        expect(variant, isA<ContextVariantStyle<TestUtilityVariant>>());

        final eventVariant = variant as ContextVariantStyle<TestUtilityVariant>;
        expect(eventVariant.trigger, isA<WidgetStateTrigger>());
        expect(eventVariant.style, equals(pressedStyle));
      });
    });

    group('onDark', () {
      test('should create variant for dark mode', () {
        final darkStyle = TestUtilityStyle(value: 'dark');
        final result = testUtility.onDark(darkStyle);

        expect(result, isA<TestUtilityStyle>());
        expect(result.variantCalls.length, equals(1));

        final variant = result.variantCalls.first;
        expect(variant, isA<ContextVariantStyle<TestUtilityVariant>>());

        final eventVariant = variant as ContextVariantStyle<TestUtilityVariant>;
        expect(eventVariant.trigger, isA<ContextVariant>());
        expect(eventVariant.style, equals(darkStyle));
      });
    });

    group('onLight', () {
      test('should create variant for light mode', () {
        final lightStyle = TestUtilityStyle(value: 'light');
        final result = testUtility.onLight(lightStyle);

        expect(result, isA<TestUtilityStyle>());
        expect(result.variantCalls.length, equals(1));

        final variant = result.variantCalls.first;
        expect(variant, isA<ContextVariantStyle<TestUtilityVariant>>());

        final eventVariant = variant as ContextVariantStyle<TestUtilityVariant>;
        expect(eventVariant.trigger, isA<ContextVariant>());
        expect(eventVariant.style, equals(lightStyle));
      });
    });

    group('onBuilder', () {
      test('should create variant with context builder', () {
        final builderResult = testUtility.onBuilder((context) {
          return TestUtilityStyle(value: 'builder');
        });

        expect(builderResult, isA<TestUtilityStyle>());
        expect(builderResult.variantCalls.length, equals(1));

        final variant = builderResult.variantCalls.first;
        expect(variant, isA<VariantStyleBuilder<TestUtilityVariant>>());
      });

      test('should call builder function correctly', () {
        var builderCalled = false;
        TestUtilityStyle? receivedContext;

        final builderResult = testUtility.onBuilder((context) {
          builderCalled = true;
          return TestUtilityStyle(value: 'builder-called');
        });

        expect(builderResult.variantCalls.length, equals(1));

        final variant =
            builderResult.variantCalls.first
                as VariantStyleBuilder<TestUtilityVariant>;

        // Test that the builder function works
        final context = MockBuildContext();
        final style = variant.resolve(context);

        expect((style as TestUtilityStyle).value, equals('builder-called'));
      });
    });

    group('builder (deprecated)', () {
      test('should work like onBuilder', () {
        final builderResult = testUtility.builder((context) {
          return TestUtilityStyle(value: 'deprecated-builder');
        });

        expect(builderResult, isA<TestUtilityStyle>());
        expect(builderResult.variantCalls.length, equals(1));

        final variant = builderResult.variantCalls.first;
        expect(variant, isA<VariantStyleBuilder<TestUtilityVariant>>());
      });
    });

    group('currentValue', () {
      test('should return current utility as style', () {
        final current = testUtility.currentValue;

        expect(current, isA<TestUtilityStyle>());
        expect(current.value, equals('test'));
        expect(current.variantCalls, isEmpty);
      });
    });

    group('method chaining', () {
      test('should support chaining multiple variants', () {
        final hoverStyle = TestUtilityStyle(value: 'hovered');
        final pressedStyle = TestUtilityStyle(value: 'pressed');
        final darkStyle = TestUtilityStyle(value: 'dark');
        final lightStyle = TestUtilityStyle(value: 'light');

        final result = testUtility
            .onHovered(hoverStyle)
            .onPressed(pressedStyle)
            .onDark(darkStyle)
            .onLight(lightStyle)
            .onBuilder((context) => TestUtilityStyle(value: 'builder'));

        expect(result.variantCalls.length, equals(5));

        // Check that all variants are present
        expect(
          result.variantCalls[0],
          isA<ContextVariantStyle<TestUtilityVariant>>(),
        );
        expect(
          result.variantCalls[1],
          isA<ContextVariantStyle<TestUtilityVariant>>(),
        );
        expect(
          result.variantCalls[2],
          isA<ContextVariantStyle<TestUtilityVariant>>(),
        );
        expect(
          result.variantCalls[3],
          isA<ContextVariantStyle<TestUtilityVariant>>(),
        );
        expect(
          result.variantCalls[4],
          isA<VariantStyleBuilder<TestUtilityVariant>>(),
        );
      });
    });

    group('comprehensive coverage', () {
      test('should verify all variant methods work', () {
        final styles = {
          'hover': TestUtilityStyle(value: 'hover'),
          'pressed': TestUtilityStyle(value: 'pressed'),
          'dark': TestUtilityStyle(value: 'dark'),
          'light': TestUtilityStyle(value: 'light'),
        };

        final result = testUtility
            .onHovered(styles['hover']!)
            .onPressed(styles['pressed']!)
            .onDark(styles['dark']!)
            .onLight(styles['light']!)
            .onBuilder((context) => TestUtilityStyle(value: 'context'))
            .builder((context) => TestUtilityStyle(value: 'deprecated'));

        // Should have 6 variants (including deprecated builder)
        expect(result.variantCalls.length, equals(6));

        // All should be proper variant types
        expect(
          result.variantCalls[0],
          isA<ContextVariantStyle<TestUtilityVariant>>(),
        );
        expect(
          result.variantCalls[1],
          isA<ContextVariantStyle<TestUtilityVariant>>(),
        );
        expect(
          result.variantCalls[2],
          isA<ContextVariantStyle<TestUtilityVariant>>(),
        );
        expect(
          result.variantCalls[3],
          isA<ContextVariantStyle<TestUtilityVariant>>(),
        );
        expect(
          result.variantCalls[4],
          isA<VariantStyleBuilder<TestUtilityVariant>>(),
        );
        expect(
          result.variantCalls[5],
          isA<VariantStyleBuilder<TestUtilityVariant>>(),
        );
      });
    });

    group('different widget states', () {
      test('should handle multiple widget state triggers', () {
        final hoverStyle = TestUtilityStyle(value: 'hover');
        final pressedStyle = TestUtilityStyle(value: 'pressed');

        final result = testUtility
            .onHovered(hoverStyle)
            .onPressed(pressedStyle);

        expect(result.variantCalls.length, equals(2));

        final hoverVariant =
            result.variantCalls[0] as ContextVariantStyle<TestUtilityVariant>;
        final pressedVariant =
            result.variantCalls[1] as ContextVariantStyle<TestUtilityVariant>;

        expect(hoverVariant.trigger, isA<WidgetStateTrigger>());
        expect(pressedVariant.trigger, isA<WidgetStateTrigger>());

        // Verify the triggers are for different states
        expect(hoverVariant.trigger, isNot(equals(pressedVariant.trigger)));
      });
    });

    group('brightness modes', () {
      test('should handle both light and dark mode triggers', () {
        final darkStyle = TestUtilityStyle(value: 'dark');
        final lightStyle = TestUtilityStyle(value: 'light');

        final result = testUtility.onDark(darkStyle).onLight(lightStyle);

        expect(result.variantCalls.length, equals(2));

        final darkVariant =
            result.variantCalls[0] as ContextVariantStyle<TestUtilityVariant>;
        final lightVariant =
            result.variantCalls[1] as ContextVariantStyle<TestUtilityVariant>;

        expect(darkVariant.trigger, isA<ContextVariant>());
        expect(lightVariant.trigger, isA<ContextVariant>());

        // Verify the triggers are for different brightness modes
        expect(darkVariant.trigger, isNot(equals(lightVariant.trigger)));
      });
    });
  });
}

// Simple mock for testing
class MockBuildContext extends Fake implements BuildContext {}
