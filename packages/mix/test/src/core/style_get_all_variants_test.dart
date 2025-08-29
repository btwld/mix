import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  // Helper to test variant priority with proper WidgetStateScope
  Future<void> testVariantPriority(
    WidgetTester tester, {
    required _MockSpecAttribute testAttribute,
    required Set<WidgetState> activeStates,
    required Set<NamedVariant> namedVariants,
    required double expectedWidth,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WidgetStateProvider(
          states: activeStates,
          child: Builder(
            builder: (context) {
              final result = testAttribute.getAllStyleVariants(
                context,
                namedVariants: namedVariants,
              );
              final spec = result.resolve(context);
              expect((spec.resolvedValue as Map)['width'], expectedWidth);
              return Container();
            },
          ),
        ),
      ),
    );
  }

  group('Style.getAllStyleVariants', () {
    group('Variant priority system', () {
      testWidgets('WidgetStateVariant gets sorted last (highest priority)', (
        tester,
      ) async {
        // Create test attribute with mixed variant types
        final contextVariant = ContextVariant('context', (context) => true);
        const namedVariant = NamedVariant('named');
        // Create a real WidgetStateVariant for testing priority
        final widgetStateVariant = WidgetStateVariant(WidgetState.hovered);

        // Create VariantSpecAttributes with different priorities
        final contextVarAttr = VariantStyle(
          contextVariant,
          _MockSpecAttribute(width: 100.0),
        );
        final namedVarAttr = VariantStyle(
          namedVariant,
          _MockSpecAttribute(width: 200.0),
        );
        final widgetStateVarAttr = VariantStyle(
          widgetStateVariant,
          _MockSpecAttribute(width: 300.0),
        );

        // Create test attribute with variants in mixed order
        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: [
            contextVarAttr,
            widgetStateVarAttr, // Should be sorted last
            namedVarAttr,
          ],
        );

        // Create a proper widget tree with WidgetStateScope
        await tester.pumpWidget(
          MaterialApp(
            home: WidgetStateProvider(
              states: const {WidgetState.hovered}, // Enable hovered state
              child: Builder(
                builder: (context) {
                  final result = testAttribute.getAllStyleVariants(
                    context,
                    namedVariants: {namedVariant},
                  );

                  // The result should have applied all variants
                  // WidgetStateVariant (width: 300) should have been applied last
                  final spec = result.resolve(context);
                  expect((spec.resolvedValue as Map)['width'], 300.0);

                  return Container();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('multiple WidgetStateVariants maintain relative order', (
        tester,
      ) async {
        final hoveredVariant = WidgetStateVariant(WidgetState.hovered);
        final pressedVariant = WidgetStateVariant(WidgetState.pressed);
        final focusedVariant = WidgetStateVariant(WidgetState.focused);

        final hoveredVarAttr = VariantStyle(
          hoveredVariant,
          _MockSpecAttribute(width: 100.0),
        );
        final pressedVarAttr = VariantStyle(
          pressedVariant,
          _MockSpecAttribute(width: 200.0),
        );
        final focusedVarAttr = VariantStyle(
          focusedVariant,
          _MockSpecAttribute(width: 300.0),
        );

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: [hoveredVarAttr, pressedVarAttr, focusedVarAttr],
        );

        // Create a proper widget tree with all widget states enabled
        await tester.pumpWidget(
          MaterialApp(
            home: WidgetStateProvider(
              states: const {
                WidgetState.hovered,
                WidgetState.pressed,
                WidgetState.focused,
              },
              child: Builder(
                builder: (context) {
                  final result = testAttribute.getAllStyleVariants(
                    context,
                    namedVariants: {},
                  );

                  // All WidgetStateVariants should be applied, with focused (300) last
                  final spec = result.resolve(context);
                  expect((spec.resolvedValue as Map)['width'], 300.0);

                  return Container();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('mixed variant types are sorted correctly', (tester) async {
        // Create a mix of all variant types
        final contextVariant = ContextVariant('context', (context) => true);
        const namedVariant = NamedVariant('named');
        final widgetStateVariant1 = WidgetStateVariant(WidgetState.hovered);
        final widgetStateVariant2 = WidgetStateVariant(WidgetState.pressed);
        const multiNamedVariant = NamedVariant('multi');

        final varAttrs = [
          VariantStyle(
            widgetStateVariant1,
            _MockSpecAttribute(width: 100.0),
          ), // Should be sorted to end
          VariantStyle(
            contextVariant,
            _MockSpecAttribute(width: 200.0),
          ), // Should be sorted earlier
          VariantStyle(
            widgetStateVariant2,
            _MockSpecAttribute(width: 300.0),
          ), // Should be sorted to end
          VariantStyle(
            namedVariant,
            _MockSpecAttribute(width: 400.0),
          ), // Should be sorted earlier
          VariantStyle(
            multiNamedVariant,
            _MockSpecAttribute(width: 500.0),
          ), // Should be sorted earlier
        ];

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: varAttrs,
        );

        await testVariantPriority(
          tester,
          testAttribute: testAttribute,
          activeStates: {WidgetState.hovered, WidgetState.pressed},
          namedVariants: {namedVariant, multiNamedVariant},
          expectedWidth: 300.0, // WidgetStateVariant2 (pressed) applied last
        );
      });

      test('non-WidgetStateVariants have equal priority', () {
        final contextVariant1 = ContextVariant('context1', (context) => true);
        final contextVariant2 = ContextVariant('context2', (context) => true);
        const namedVariant1 = NamedVariant('named1');
        const namedVariant2 = NamedVariant('named2');

        final varAttrs = [
          VariantStyle(contextVariant1, _MockSpecAttribute(width: 100.0)),
          VariantStyle(contextVariant2, _MockSpecAttribute(width: 200.0)),
          VariantStyle(namedVariant1, _MockSpecAttribute(width: 300.0)),
          VariantStyle(namedVariant2, _MockSpecAttribute(width: 400.0)),
        ];

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: varAttrs,
        );

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(
          context,
          namedVariants: {namedVariant1, namedVariant2},
        );

        // All should be treated equally, last one applied (namedVariant2: 400)
        final spec = result.resolve(context);
        expect((spec.resolvedValue as Map)['width'], 400.0);
      });
    });

    group('Variant resolution logic', () {
      test('ContextVariant evaluation with context conditions', () {
        // Context variant that checks screen width
        final mobileVariant = ContextVariant('mobile', (context) {
          final size =
              MediaQuery.maybeOf(context)?.size ?? const Size(800, 600);
          return size.width <= 768;
        });
        final desktopVariant = ContextVariant('desktop', (context) {
          final size =
              MediaQuery.maybeOf(context)?.size ?? const Size(800, 600);
          return size.width > 768;
        });

        final mobileVarAttr = VariantStyle(
          mobileVariant,
          _MockSpecAttribute(width: 100.0),
        );
        final desktopVarAttr = VariantStyle(
          desktopVariant,
          _MockSpecAttribute(width: 200.0),
        );

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: [mobileVarAttr, desktopVarAttr],
        );

        // MockBuildContext has size (800, 600) which is > 768
        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(
          context,
          namedVariants: {},
        );

        // Desktop variant should apply (width: 200)
        final spec = result.resolve(context);
        expect((spec.resolvedValue as Map)['width'], 200.0);
      });

      test('NamedVariant evaluation with namedVariants parameter', () {
        const primaryVariant = NamedVariant('primary');
        const secondaryVariant = NamedVariant('secondary');
        const unusedVariant = NamedVariant('unused');

        final primaryVarAttr = VariantStyle(
          primaryVariant,
          _MockSpecAttribute(width: 100.0),
        );
        final secondaryVarAttr = VariantStyle(
          secondaryVariant,
          _MockSpecAttribute(width: 200.0),
        );
        final unusedVarAttr = VariantStyle(
          unusedVariant,
          _MockSpecAttribute(width: 300.0),
        );

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: [primaryVarAttr, secondaryVarAttr, unusedVarAttr],
        );

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(
          context,
          namedVariants: {primaryVariant, secondaryVariant},
        );

        // Secondary variant should apply last (width: 200)
        final spec = result.resolve(context);
        expect((spec.resolvedValue as Map)['width'], 200.0);
      });

      test('ContextVariantBuilder is always applied', () {
        final contextBuilder = ContextVariantBuilder<_MockSpecAttribute>(
          (context) => _MockSpecAttribute(width: 150.0),
        );

        final builderVarAttr = VariantStyle(
          contextBuilder,
          _MockSpecAttribute(width: 100.0),
        );

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: [builderVarAttr],
        );

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(
          context,
          namedVariants: {},
        );

        // ContextVariantBuilder variant should apply (width: 150 from builder)
        final spec = result.resolve(context);
        expect((spec.resolvedValue as Map)['width'], 150.0);
      });

      test('filtering excludes non-matching variants', () {
        final falseContextVariant = ContextVariant('false', (context) => false);
        const unmatchedNamedVariant = NamedVariant('unmatched');

        final falseVarAttr = VariantStyle(
          falseContextVariant,
          _MockSpecAttribute(width: 100.0),
        );
        final unmatchedVarAttr = VariantStyle(
          unmatchedNamedVariant,
          _MockSpecAttribute(width: 200.0),
        );

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: [falseVarAttr, unmatchedVarAttr],
        );

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(
          context,
          namedVariants: {const NamedVariant('other')},
        );

        // No variants should apply, base width remains
        final spec = result.resolve(context);
        expect((spec.resolvedValue as Map)['width'], 50.0);
      });
    });

    group('Merging behavior', () {
      testWidgets('variants are merged in sorted order', (tester) async {
        final contextVariant = ContextVariant('context', (context) => true);
        final widgetStateVariant = WidgetStateVariant(WidgetState.hovered);

        final contextVarAttr = VariantStyle(
          contextVariant,
          _MockSpecAttribute(width: 100.0, height: 200.0),
        );
        final widgetStateVarAttr = VariantStyle(
          widgetStateVariant,
          _MockSpecAttribute(width: 300.0), // Overrides width, keeps height
        );

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          height: 75.0,
          variants: [contextVarAttr, widgetStateVarAttr],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: WidgetStateProvider(
              states: const {WidgetState.hovered}, // Enable hovered state
              child: Builder(
                builder: (context) {
                  final result = testAttribute.getAllStyleVariants(
                    context,
                    namedVariants: {},
                  );

                  // WidgetStateVariant should override width, but context variant height remains
                  final spec = result.resolve(context);
                  expect((spec.resolvedValue as Map)['width'], 300.0);
                  expect((spec.resolvedValue as Map)['height'], 200.0);

                  return Container();
                },
              ),
            ),
          ),
        );
      });

      test('empty variants list returns original attribute', () {
        final testAttribute = _MockSpecAttribute(width: 100.0, variants: []);

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(
          context,
          namedVariants: {},
        );

        // Should return original attribute unchanged
        final spec = result.resolve(context);
        expect((spec.resolvedValue as Map)['width'], 100.0);
        expect(identical(result, testAttribute), isTrue);
      });

      test('null variants list returns original attribute', () {
        final testAttribute = _MockSpecAttribute(width: 100.0, variants: null);

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(
          context,
          namedVariants: {},
        );

        // Should return original attribute unchanged
        final spec = result.resolve(context);
        expect((spec.resolvedValue as Map)['width'], 100.0);
        expect(identical(result, testAttribute), isTrue);
      });
    });

    group('Complex scenarios', () {
      testWidgets('combination of all variant types with priority', (
        tester,
      ) async {
        // Create comprehensive test with all variant types
        final contextVariant = ContextVariant('context', (context) => true);
        const namedVariant = NamedVariant('named');
        final widgetStateVariant = WidgetStateVariant(WidgetState.hovered);
        const multiNamedVariant = NamedVariant('multi_named');
        final contextBuilder = ContextVariantBuilder<_MockSpecAttribute>(
          (context) => _MockSpecAttribute(width: 150.0, height: 500.0),
        );

        final varAttrs = [
          VariantStyle(multiNamedVariant, _MockSpecAttribute(width: 100.0)),
          VariantStyle(contextVariant, _MockSpecAttribute(width: 200.0)),
          VariantStyle(
            widgetStateVariant,
            _MockSpecAttribute(width: 300.0),
          ), // Highest priority
          VariantStyle(namedVariant, _MockSpecAttribute(width: 400.0)),
          VariantStyle(contextBuilder, _MockSpecAttribute(width: 500.0)),
        ];

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: varAttrs,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: WidgetStateProvider(
              states: const {WidgetState.hovered}, // Enable hovered state
              child: Builder(
                builder: (context) {
                  final result = testAttribute.getAllStyleVariants(
                    context,
                    namedVariants: {
                      namedVariant,
                      const NamedVariant('multi_named'),
                    },
                  );

                  // WidgetStateVariant should have highest priority (width: 300)
                  final spec = result.resolve(context);
                  expect((spec.resolvedValue as Map)['width'], 300.0);

                  return Container();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('multiple WidgetStateVariants with different states', (
        tester,
      ) async {
        final hoveredVariant = WidgetStateVariant(WidgetState.hovered);
        final pressedVariant = WidgetStateVariant(WidgetState.pressed);
        final focusedVariant = WidgetStateVariant(WidgetState.focused);
        final disabledVariant = WidgetStateVariant(WidgetState.disabled);

        final varAttrs = [
          VariantStyle(
            hoveredVariant,
            _MockSpecAttribute(width: 100.0, height: 100.0),
          ),
          VariantStyle(
            pressedVariant,
            _MockSpecAttribute(width: 200.0, height: 200.0),
          ),
          VariantStyle(
            focusedVariant,
            _MockSpecAttribute(width: 300.0), // Only overrides width
          ),
          VariantStyle(
            disabledVariant,
            _MockSpecAttribute(
              width: 0.0,
              height: 400.0,
            ), // Only overrides height
          ),
        ];

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          height: 75.0,
          variants: varAttrs,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: WidgetStateProvider(
              states: const {
                WidgetState.hovered,
                WidgetState.pressed,
                WidgetState.focused,
                WidgetState.disabled,
              },
              child: Builder(
                builder: (context) {
                  final result = testAttribute.getAllStyleVariants(
                    context,
                    namedVariants: {},
                  );

                  // Last merged properties: width from focused (300), height from disabled (400)
                  final spec = result.resolve(context);
                  expect((spec.resolvedValue as Map)['width'], 300.0);
                  expect((spec.resolvedValue as Map)['height'], 400.0);

                  return Container();
                },
              ),
            ),
          ),
        );
      });

      test('variant merging preserves base attribute properties', () {
        final contextVariant = ContextVariant('context', (context) => true);

        final contextVarAttr = VariantStyle(
          contextVariant,
          _MockSpecAttribute(width: 0.0, height: 200.0), // Only sets height
        );

        final testAttribute = _MockSpecAttribute(
          width: 100.0, // This should be preserved
          height: 75.0,
          variants: [contextVarAttr],
        );

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(
          context,
          namedVariants: {},
        );

        // Base width preserved, variant height applied
        final spec = result.resolve(context);
        expect((spec.resolvedValue as Map)['width'], 100.0);
        expect((spec.resolvedValue as Map)['height'], 200.0);
      });
    });

    group('Edge cases', () {
      test('handles empty context with no matching variants', () {
        final contextVariant = ContextVariant('context', (context) => false);
        const namedVariant = NamedVariant('named');

        final varAttrs = [
          VariantStyle(contextVariant, _MockSpecAttribute(width: 100.0)),
          VariantStyle(namedVariant, _MockSpecAttribute(width: 200.0)),
        ];

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: varAttrs,
        );

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(
          context,
          namedVariants: {}, // No named variants provided
        );

        // No variants should match, original width preserved
        final spec = result.resolve(context);
        expect((spec.resolvedValue as Map)['width'], 50.0);
      });

      test('sorting is stable for non-WidgetStateVariant elements', () {
        // Create multiple non-WidgetState variants to test stable sort
        final variants = [
          VariantStyle(
            ContextVariant('context1', (context) => true),
            _MockSpecAttribute(width: 100.0),
          ),
          VariantStyle(
            const NamedVariant('named1'),
            _MockSpecAttribute(width: 200.0),
          ),
          VariantStyle(
            ContextVariant('context2', (context) => true),
            _MockSpecAttribute(width: 300.0),
          ),
          VariantStyle(
            const NamedVariant('named2'),
            _MockSpecAttribute(width: 400.0),
          ),
        ];

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: variants,
        );

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(
          context,
          namedVariants: {
            const NamedVariant('named1'),
            const NamedVariant('named2'),
          },
        );

        // Should maintain original order, last applied is named2 (400)
        final spec = result.resolve(context);
        expect((spec.resolvedValue as Map)['width'], 400.0);
      });
    });

    group('Integration with existing variant system', () {
      testWidgets('works with actual WidgetStateVariant instances', (
        tester,
      ) async {
        // Test with real WidgetStateVariant from the codebase
        final hoverVariant = WidgetStateVariant(WidgetState.hovered);
        final pressVariant = WidgetStateVariant(WidgetState.pressed);

        final varAttrs = [
          VariantStyle(hoverVariant, _MockSpecAttribute(width: 100.0)),
          VariantStyle(pressVariant, _MockSpecAttribute(width: 200.0)),
        ];

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: varAttrs,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: WidgetStateProvider(
              states: const {WidgetState.hovered, WidgetState.pressed},
              child: Builder(
                builder: (context) {
                  final result = testAttribute.getAllStyleVariants(
                    context,
                    namedVariants: {},
                  );

                  // Press variant (last) should apply
                  final spec = result.resolve(context);
                  expect((spec.resolvedValue as Map)['width'], 200.0);

                  return Container();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('integrates with predefined variant instances', (
        tester,
      ) async {
        // Test with predefined variants from the variant system
        final varAttrs = [
          VariantStyle(
            WidgetStateVariant(WidgetState.hovered), // hover variant
            _MockSpecAttribute(width: 100.0),
          ),
          VariantStyle(
            WidgetStateVariant(WidgetState.pressed), // press variant
            _MockSpecAttribute(width: 200.0),
          ),
        ];

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: varAttrs,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: WidgetStateProvider(
              states: const {WidgetState.hovered, WidgetState.pressed},
              child: Builder(
                builder: (context) {
                  final result = testAttribute.getAllStyleVariants(
                    context,
                    namedVariants: {},
                  );

                  // Both are WidgetStateVariants, press (last) should apply
                  final spec = result.resolve(context);
                  expect((spec.resolvedValue as Map)['width'], 200.0);

                  return Container();
                },
              ),
            ),
          ),
        );
      });
    });
  });
}

// Test helper class that implements SpecAttribute for testing
class _MockSpecAttribute extends Style<MockSpec<Map<String, dynamic>>> {
  final double width;
  final double? height;

  _MockSpecAttribute({
    required this.width,
    this.height,
    super.variants,
    super.modifier,
    super.animation,
  });

  @override
  StyleSpec<MockSpec<Map<String, dynamic>>> resolve(BuildContext context) {
    return StyleSpec(
      spec: MockSpec<Map<String, dynamic>>(
        resolvedValue: {'width': width, 'height': height},
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  _MockSpecAttribute merge(covariant _MockSpecAttribute? other) {
    if (other == null) return this;

    return _MockSpecAttribute(
      width: other.width != 0.0 ? other.width : width,
      height: other.height ?? height,
      variants: mergeVariantLists($variants, other.$variants),
    );
  }

  @override
  List<Object?> get props => [width, height, $variants];
}
