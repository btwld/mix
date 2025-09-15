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
    required Set<String> namedVariants,
    required double expectedWidth,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WidgetStateProvider(
          states: activeStates,
          child: Builder(
            builder: (context) {
              final result = testAttribute.mergeActiveVariants(
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

  group('Style.mergeActiveVariants', () {
    group('Variant priority system', () {
      testWidgets('WidgetStateVariant gets sorted last (highest priority)', (
        tester,
      ) async {
        // Create test attribute with mixed variant types
        final contextVariant = ContextTrigger('context', (context) => true);
        const namedVariant = 'named';
        // Create a real WidgetStateVariant for testing priority
        final widgetStateVariant = WidgetStateTrigger(WidgetState.hovered);

        // Create VariantSpecAttributes with different priorities
        final contextVarAttr = TriggerVariant(
          contextVariant,
          _MockSpecAttribute(width: 100.0),
        );
        final namedVarAttr = NamedVariant(
          namedVariant,
          _MockSpecAttribute(width: 200.0),
        );
        final widgetStateVarAttr = TriggerVariant(
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
                  final result = testAttribute.mergeActiveVariants(
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
        final hoveredVariant = WidgetStateTrigger(WidgetState.hovered);
        final pressedVariant = WidgetStateTrigger(WidgetState.pressed);
        final focusedVariant = WidgetStateTrigger(WidgetState.focused);

        final hoveredVarAttr = TriggerVariant(
          hoveredVariant,
          _MockSpecAttribute(width: 100.0),
        );
        final pressedVarAttr = TriggerVariant(
          pressedVariant,
          _MockSpecAttribute(width: 200.0),
        );
        final focusedVarAttr = TriggerVariant(
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
                  final result = testAttribute.mergeActiveVariants(
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
        final contextVariant = ContextTrigger('context', (context) => true);
        const namedVariant = 'named';
        final widgetStateVariant1 = WidgetStateTrigger(WidgetState.hovered);
        final widgetStateVariant2 = WidgetStateTrigger(WidgetState.pressed);
        const multiNamedVariant = 'multi';

        final varAttrs = [
          TriggerVariant(
            widgetStateVariant1,
            _MockSpecAttribute(width: 100.0),
          ), // Should be sorted to end
          TriggerVariant(
            contextVariant,
            _MockSpecAttribute(width: 200.0),
          ), // Should be sorted earlier
          TriggerVariant(
            widgetStateVariant2,
            _MockSpecAttribute(width: 300.0),
          ), // Should be sorted to end
          NamedVariant(
            namedVariant,
            _MockSpecAttribute(width: 400.0),
          ), // Should be sorted earlier
          NamedVariant(
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
        final contextVariant1 = ContextTrigger('context1', (context) => true);
        final contextVariant2 = ContextTrigger('context2', (context) => true);
        const namedVariant1 = 'named1';
        const namedVariant2 = 'named2';

        final varAttrs = [
          TriggerVariant(contextVariant1, _MockSpecAttribute(width: 100.0)),
          TriggerVariant(contextVariant2, _MockSpecAttribute(width: 200.0)),
          NamedVariant(namedVariant1, _MockSpecAttribute(width: 300.0)),
          NamedVariant(namedVariant2, _MockSpecAttribute(width: 400.0)),
        ];

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: varAttrs,
        );

        final context = MockBuildContext();
        final result = testAttribute.mergeActiveVariants(
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
        final mobileVariant = ContextTrigger('mobile', (context) {
          final size =
              MediaQuery.maybeOf(context)?.size ?? const Size(800, 600);
          return size.width <= 768;
        });
        final desktopVariant = ContextTrigger('desktop', (context) {
          final size =
              MediaQuery.maybeOf(context)?.size ?? const Size(800, 600);
          return size.width > 768;
        });

        final mobileVarAttr = TriggerVariant(
          mobileVariant,
          _MockSpecAttribute(width: 100.0),
        );
        final desktopVarAttr = TriggerVariant(
          desktopVariant,
          _MockSpecAttribute(width: 200.0),
        );

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: [mobileVarAttr, desktopVarAttr],
        );

        // MockBuildContext has size (800, 600) which is > 768
        final context = MockBuildContext();
        final result = testAttribute.mergeActiveVariants(
          context,
          namedVariants: {},
        );

        // Desktop variant should apply (width: 200)
        final spec = result.resolve(context);
        expect((spec.resolvedValue as Map)['width'], 200.0);
      });

      test('NamedVariant evaluation with namedVariants parameter', () {
        const primaryVariant = 'primary';
        const secondaryVariant = 'secondary';
        const unusedVariant = 'unused';

        final primaryVarAttr = NamedVariant(
          primaryVariant,
          _MockSpecAttribute(width: 100.0),
        );
        final secondaryVarAttr = NamedVariant(
          secondaryVariant,
          _MockSpecAttribute(width: 200.0),
        );
        final unusedVarAttr = NamedVariant(
          unusedVariant,
          _MockSpecAttribute(width: 300.0),
        );

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: [primaryVarAttr, secondaryVarAttr, unusedVarAttr],
        );

        final context = MockBuildContext();
        final result = testAttribute.mergeActiveVariants(
          context,
          namedVariants: {primaryVariant, secondaryVariant},
        );

        // Secondary variant should apply last (width: 200)
        final spec = result.resolve(context);
        expect((spec.resolvedValue as Map)['width'], 200.0);
      });

      test('ContextVariantBuilder is always applied', () {
        final contextBuilder = VariantBuilder<MockSpec<Map<String, dynamic>>>(
          (context) => _MockSpecAttribute(width: 150.0),
        );

        final builderVarAttr = contextBuilder;

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: [builderVarAttr],
        );

        final context = MockBuildContext();
        final result = testAttribute.mergeActiveVariants(
          context,
          namedVariants: {},
        );

        // ContextVariantBuilder variant should apply (width: 150 from builder)
        final spec = result.resolve(context);
        expect((spec.resolvedValue as Map)['width'], 150.0);
      });

      test('filtering excludes non-matching variants', () {
        final falseContextVariant = ContextTrigger('false', (context) => false);
        const unmatchedNamedVariant = 'unmatched';

        final falseVarAttr = TriggerVariant(
          falseContextVariant,
          _MockSpecAttribute(width: 100.0),
        );
        final unmatchedVarAttr = NamedVariant(
          unmatchedNamedVariant,
          _MockSpecAttribute(width: 200.0),
        );

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: [falseVarAttr, unmatchedVarAttr],
        );

        final context = MockBuildContext();
        final result = testAttribute.mergeActiveVariants(
          context,
          namedVariants: {'other'},
        );

        // No variants should apply, base width remains
        final spec = result.resolve(context);
        expect((spec.resolvedValue as Map)['width'], 50.0);
      });
    });

    group('Merging behavior', () {
      testWidgets('variants are merged in sorted order', (tester) async {
        final contextVariant = ContextTrigger('context', (context) => true);
        final widgetStateVariant = WidgetStateTrigger(WidgetState.hovered);

        final contextVarAttr = TriggerVariant(
          contextVariant,
          _MockSpecAttribute(width: 100.0, height: 200.0),
        );
        final widgetStateVarAttr = TriggerVariant(
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
                  final result = testAttribute.mergeActiveVariants(
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
        final result = testAttribute.mergeActiveVariants(
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
        final result = testAttribute.mergeActiveVariants(
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
        final contextVariant = ContextTrigger('context', (context) => true);
        const namedVariant = 'named';
        final widgetStateVariant = WidgetStateTrigger(WidgetState.hovered);
        const multiNamedVariant = 'multi_named';
        final contextBuilder = VariantBuilder<MockSpec<Map<String, dynamic>>>(
          (context) => _MockSpecAttribute(width: 150.0, height: 500.0),
        );

        final varAttrs = [
          NamedVariant(multiNamedVariant, _MockSpecAttribute(width: 100.0)),
          TriggerVariant(contextVariant, _MockSpecAttribute(width: 200.0)),
          TriggerVariant(
            widgetStateVariant,
            _MockSpecAttribute(width: 300.0),
          ), // Highest priority
          NamedVariant(namedVariant, _MockSpecAttribute(width: 400.0)),
          contextBuilder,
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
                  final result = testAttribute.mergeActiveVariants(
                    context,
                    namedVariants: {
                      namedVariant,
                      'multi_named',
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
        final hoveredVariant = WidgetStateTrigger(WidgetState.hovered);
        final pressedVariant = WidgetStateTrigger(WidgetState.pressed);
        final focusedVariant = WidgetStateTrigger(WidgetState.focused);
        final disabledVariant = WidgetStateTrigger(WidgetState.disabled);

        final varAttrs = [
          TriggerVariant(
            hoveredVariant,
            _MockSpecAttribute(width: 100.0, height: 100.0),
          ),
          TriggerVariant(
            pressedVariant,
            _MockSpecAttribute(width: 200.0, height: 200.0),
          ),
          TriggerVariant(
            focusedVariant,
            _MockSpecAttribute(width: 300.0), // Only overrides width
          ),
          TriggerVariant(
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
                  final result = testAttribute.mergeActiveVariants(
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
        final contextVariant = ContextTrigger('context', (context) => true);

        final contextVarAttr = TriggerVariant(
          contextVariant,
          _MockSpecAttribute(width: 0.0, height: 200.0), // Only sets height
        );

        final testAttribute = _MockSpecAttribute(
          width: 100.0, // This should be preserved
          height: 75.0,
          variants: [contextVarAttr],
        );

        final context = MockBuildContext();
        final result = testAttribute.mergeActiveVariants(
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
        final contextVariant = ContextTrigger('context', (context) => false);
        const namedVariant = 'named';

        final varAttrs = [
          TriggerVariant(contextVariant, _MockSpecAttribute(width: 100.0)),
          NamedVariant(namedVariant, _MockSpecAttribute(width: 200.0)),
        ];

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: varAttrs,
        );

        final context = MockBuildContext();
        final result = testAttribute.mergeActiveVariants(
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
          TriggerVariant(
            ContextTrigger('context1', (context) => true),
            _MockSpecAttribute(width: 100.0),
          ),
          NamedVariant(
            'named1',
            _MockSpecAttribute(width: 200.0),
          ),
          TriggerVariant(
            ContextTrigger('context2', (context) => true),
            _MockSpecAttribute(width: 300.0),
          ),
          NamedVariant(
            'named2',
            _MockSpecAttribute(width: 400.0),
          ),
        ];

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: variants,
        );

        final context = MockBuildContext();
        final result = testAttribute.mergeActiveVariants(
          context,
          namedVariants: {
            'named1',
            'named2',
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
        final hoverVariant = WidgetStateTrigger(WidgetState.hovered);
        final pressVariant = WidgetStateTrigger(WidgetState.pressed);

        final varAttrs = [
          TriggerVariant(hoverVariant, _MockSpecAttribute(width: 100.0)),
          TriggerVariant(pressVariant, _MockSpecAttribute(width: 200.0)),
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
                  final result = testAttribute.mergeActiveVariants(
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
          TriggerVariant(
            WidgetStateTrigger(WidgetState.hovered), // hover variant
            _MockSpecAttribute(width: 100.0),
          ),
          TriggerVariant(
            WidgetStateTrigger(WidgetState.pressed), // press variant
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
                  final result = testAttribute.mergeActiveVariants(
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
      variants: MixOps.mergeVariants($variants, other.$variants),
    );
  }

  @override
  List<Object?> get props => [width, height, $variants];
}
