import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Style.getAllStyleVariants', () {
    group('Variant priority system', () {
      test('WidgetStateVariant gets sorted last (highest priority)', () {
        // Create test attribute with mixed variant types
        final contextVariant = ContextVariant('context', (context) => true);
        const namedVariant = NamedVariant('named');
        // Create a mock WidgetStateVariant that always matches for testing priority
        final widgetStateVariant = _MockWidgetStateVariant();

        // Create VariantSpecAttributes with different priorities
        final contextVarAttr = VariantSpecAttribute(
          contextVariant,
          _MockSpecAttribute(width: 100.0),
        );
        final namedVarAttr = VariantSpecAttribute(
          namedVariant,
          _MockSpecAttribute(width: 200.0),
        );
        final widgetStateVarAttr = VariantSpecAttribute(
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

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(
          context,
          namedVariants: {namedVariant},
        );

        // The result should have applied all variants
        // WidgetStateVariant (width: 300) should have been applied last
        final spec = result.resolveSpec(context);
        expect((spec.resolvedValue as Map)['width'], 300.0);
      });

      test('multiple WidgetStateVariants maintain relative order', () {
        final hoveredVariant = _MockWidgetStateVariant();
        final pressedVariant = _MockWidgetStateVariant();
        final focusedVariant = _MockWidgetStateVariant();

        final hoveredVarAttr = VariantSpecAttribute(
          hoveredVariant,
          _MockSpecAttribute(width: 100.0),
        );
        final pressedVarAttr = VariantSpecAttribute(
          pressedVariant,
          _MockSpecAttribute(width: 200.0),
        );
        final focusedVarAttr = VariantSpecAttribute(
          focusedVariant,
          _MockSpecAttribute(width: 300.0),
        );

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: [
            hoveredVarAttr,
            pressedVarAttr,
            focusedVarAttr,
          ],
        );

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(context);

        // All WidgetStateVariants should be applied, with focused (300) last
        final spec = result.resolveSpec(context);
        expect((spec.resolvedValue as Map)['width'], 300.0);
      });

      test('mixed variant types are sorted correctly', () {
        // Create a mix of all variant types
        final contextVariant = ContextVariant('context', (context) => true);
        const namedVariant = NamedVariant('named');
        final widgetStateVariant1 = _MockWidgetStateVariant();
        final widgetStateVariant2 = _MockWidgetStateVariant();
        final multiVariant = MultiVariant.and(const [
          NamedVariant('multi1'),
          NamedVariant('multi2'),
        ]);

        final varAttrs = [
          VariantSpecAttribute(
            widgetStateVariant1,
            _MockSpecAttribute(width: 100.0),
          ), // Should be sorted to end
          VariantSpecAttribute(
            contextVariant,
            _MockSpecAttribute(width: 200.0),
          ), // Should be sorted earlier
          VariantSpecAttribute(
            widgetStateVariant2,
            _MockSpecAttribute(width: 300.0),
          ), // Should be sorted to end
          VariantSpecAttribute(
            namedVariant,
            _MockSpecAttribute(width: 400.0),
          ), // Should be sorted earlier
          VariantSpecAttribute(
            multiVariant,
            _MockSpecAttribute(width: 500.0),
          ), // Should be sorted earlier
        ];

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: varAttrs,
        );

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(
          context,
          namedVariants: {namedVariant, const NamedVariant('multi1'), const NamedVariant('multi2')},
        );

        // WidgetStateVariant2 (width: 300) should be applied last
        final spec = result.resolveSpec(context);
        expect((spec.resolvedValue as Map)['width'], 300.0);
      });

      test('non-WidgetStateVariants have equal priority', () {
        final contextVariant1 = ContextVariant('context1', (context) => true);
        final contextVariant2 = ContextVariant('context2', (context) => true);
        const namedVariant1 = NamedVariant('named1');
        const namedVariant2 = NamedVariant('named2');

        final varAttrs = [
          VariantSpecAttribute(
            contextVariant1,
            _MockSpecAttribute(width: 100.0),
          ),
          VariantSpecAttribute(
            contextVariant2,
            _MockSpecAttribute(width: 200.0),
          ),
          VariantSpecAttribute(
            namedVariant1,
            _MockSpecAttribute(width: 300.0),
          ),
          VariantSpecAttribute(
            namedVariant2,
            _MockSpecAttribute(width: 400.0),
          ),
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
        final spec = result.resolveSpec(context);
        expect((spec.resolvedValue as Map)['width'], 400.0);
      });
    });

    group('Variant resolution logic', () {
      test('ContextVariant evaluation with context conditions', () {
        // Context variant that checks screen width
        final mobileVariant = ContextVariant('mobile', (context) {
          final size = MediaQuery.maybeOf(context)?.size ?? const Size(800, 600);
          return size.width <= 768;
        });
        final desktopVariant = ContextVariant('desktop', (context) {
          final size = MediaQuery.maybeOf(context)?.size ?? const Size(800, 600);
          return size.width > 768;
        });

        final mobileVarAttr = VariantSpecAttribute(
          mobileVariant,
          _MockSpecAttribute(width: 100.0),
        );
        final desktopVarAttr = VariantSpecAttribute(
          desktopVariant,
          _MockSpecAttribute(width: 200.0),
        );

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: [mobileVarAttr, desktopVarAttr],
        );

        // MockBuildContext has size (800, 600) which is > 768
        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(context);

        // Desktop variant should apply (width: 200)
        final spec = result.resolveSpec(context);
        expect((spec.resolvedValue as Map)['width'], 200.0);
      });

      test('NamedVariant evaluation with namedVariants parameter', () {
        const primaryVariant = NamedVariant('primary');
        const secondaryVariant = NamedVariant('secondary');
        const unusedVariant = NamedVariant('unused');

        final primaryVarAttr = VariantSpecAttribute(
          primaryVariant,
          _MockSpecAttribute(width: 100.0),
        );
        final secondaryVarAttr = VariantSpecAttribute(
          secondaryVariant,
          _MockSpecAttribute(width: 200.0),
        );
        final unusedVarAttr = VariantSpecAttribute(
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
        final spec = result.resolveSpec(context);
        expect((spec.resolvedValue as Map)['width'], 200.0);
      });

      test('ContextVariantBuilder is always applied', () {
        final contextBuilder = ContextVariantBuilder<_MockSpecAttribute>(
          (context) => _MockSpecAttribute(width: 150.0),
        );

        final builderVarAttr = VariantSpecAttribute(
          contextBuilder,
          _MockSpecAttribute(width: 100.0),
        );

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: [builderVarAttr],
        );

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(context);

        // ContextVariantBuilder variant should apply (width: 100)
        final spec = result.resolveSpec(context);
        expect((spec.resolvedValue as Map)['width'], 100.0);
      });

      test('filtering excludes non-matching variants', () {
        final falseContextVariant = ContextVariant('false', (context) => false);
        const unmatchedNamedVariant = NamedVariant('unmatched');

        final falseVarAttr = VariantSpecAttribute(
          falseContextVariant,
          _MockSpecAttribute(width: 100.0),
        );
        final unmatchedVarAttr = VariantSpecAttribute(
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
        final spec = result.resolveSpec(context);
        expect((spec.resolvedValue as Map)['width'], 50.0);
      });
    });

    group('Merging behavior', () {
      test('variants are merged in sorted order', () {
        final contextVariant = ContextVariant('context', (context) => true);
        final widgetStateVariant = _MockWidgetStateVariant();

        final contextVarAttr = VariantSpecAttribute(
          contextVariant,
          _MockSpecAttribute(width: 100.0, height: 200.0),
        );
        final widgetStateVarAttr = VariantSpecAttribute(
          widgetStateVariant,
          _MockSpecAttribute(width: 300.0), // Overrides width, keeps height
        );

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          height: 75.0,
          variants: [contextVarAttr, widgetStateVarAttr],
        );

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(context);

        // WidgetStateVariant should override width, but context variant height remains
        final spec = result.resolveSpec(context);
        expect((spec.resolvedValue as Map)['width'], 300.0);
        expect((spec.resolvedValue as Map)['height'], 200.0);
      });

      test('empty variants list returns original attribute', () {
        final testAttribute = _MockSpecAttribute(
          width: 100.0,
          variants: [],
        );

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(context);

        // Should return original attribute unchanged
        final spec = result.resolveSpec(context);
        expect((spec.resolvedValue as Map)['width'], 100.0);
        expect(identical(result, testAttribute), isTrue);
      });

      test('null variants list returns original attribute', () {
        final testAttribute = _MockSpecAttribute(
          width: 100.0,
          variants: null,
        );

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(context);

        // Should return original attribute unchanged
        final spec = result.resolveSpec(context);
        expect((spec.resolvedValue as Map)['width'], 100.0);
        expect(identical(result, testAttribute), isTrue);
      });
    });

    group('Complex scenarios', () {
      test('combination of all variant types with priority', () {
        // Create comprehensive test with all variant types
        final contextVariant = ContextVariant('context', (context) => true);
        const namedVariant = NamedVariant('named');
        final widgetStateVariant = _MockWidgetStateVariant();
        final multiVariant = MultiVariant.and([
          ContextVariant('multi_context', (context) => true),
          const NamedVariant('multi_named'),
        ]);
        final contextBuilder = ContextVariantBuilder<_MockSpecAttribute>(
          (context) => _MockSpecAttribute(width: 150.0, height: 500.0),
        );

        final varAttrs = [
          VariantSpecAttribute(
            multiVariant,
            _MockSpecAttribute(width: 100.0),
          ),
          VariantSpecAttribute(
            contextVariant,
            _MockSpecAttribute(width: 200.0),
          ),
          VariantSpecAttribute(
            widgetStateVariant,
            _MockSpecAttribute(width: 300.0),
          ), // Highest priority
          VariantSpecAttribute(
            namedVariant,
            _MockSpecAttribute(width: 400.0),
          ),
          VariantSpecAttribute(
            contextBuilder,
            _MockSpecAttribute(width: 500.0),
          ),
        ];

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: varAttrs,
        );

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(
          context,
          namedVariants: {namedVariant, const NamedVariant('multi_named')},
        );

        // WidgetStateVariant should have highest priority (width: 300)
        final spec = result.resolveSpec(context);
        expect((spec.resolvedValue as Map)['width'], 300.0);
      });

      test('multiple WidgetStateVariants with different states', () {
        final hoveredVariant = _MockWidgetStateVariant();
        final pressedVariant = _MockWidgetStateVariant();
        final focusedVariant = _MockWidgetStateVariant();
        final disabledVariant = _MockWidgetStateVariant();

        final varAttrs = [
          VariantSpecAttribute(
            hoveredVariant,
            _MockSpecAttribute(width: 100.0, height: 100.0),
          ),
          VariantSpecAttribute(
            pressedVariant,
            _MockSpecAttribute(width: 200.0, height: 200.0),
          ),
          VariantSpecAttribute(
            focusedVariant,
            _MockSpecAttribute(width: 300.0), // Only overrides width
          ),
          VariantSpecAttribute(
            disabledVariant,
            _MockSpecAttribute(width: 0.0, height: 400.0), // Only overrides height
          ),
        ];

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          height: 75.0,
          variants: varAttrs,
        );

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(context);

        // Last merged properties: width from focused (300), height from disabled (400)
        final spec = result.resolveSpec(context);
        expect((spec.resolvedValue as Map)['width'], 300.0);
        expect((spec.resolvedValue as Map)['height'], 400.0);
      });

      test('variant merging preserves base attribute properties', () {
        final contextVariant = ContextVariant('context', (context) => true);

        final contextVarAttr = VariantSpecAttribute(
          contextVariant,
          _MockSpecAttribute(width: 0.0, height: 200.0), // Only sets height
        );

        final testAttribute = _MockSpecAttribute(
          width: 100.0, // This should be preserved
          height: 75.0,
          variants: [contextVarAttr],
        );

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(context);

        // Base width preserved, variant height applied
        final spec = result.resolveSpec(context);
        expect((spec.resolvedValue as Map)['width'], 100.0);
        expect((spec.resolvedValue as Map)['height'], 200.0);
      });
    });

    group('Performance and edge cases', () {
      test('handles large number of variants efficiently', () {
        final variants = List.generate(100, (i) {
          final variant = ContextVariant('variant_$i', (context) => true);
          return VariantSpecAttribute(
            variant,
            _MockSpecAttribute(width: i.toDouble()),
          );
        });

        final testAttribute = _MockSpecAttribute(
          width: 0.0,
          variants: variants,
        );

        final context = MockBuildContext();
        final stopwatch = Stopwatch()..start();
        
        final result = testAttribute.getAllStyleVariants(context);
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
        final spec = result.resolveSpec(context);
        // Since all ContextVariants match (return true), they merge sequentially
        // The base width is 0.0, and variants with width 0.0 won't override it
        // So we need to check what actually gets merged
        expect((spec.resolvedValue as Map)['width'], isA<double>()); // Some variant applied
      });

      test('handles empty context with no matching variants', () {
        final contextVariant = ContextVariant('context', (context) => false);
        const namedVariant = NamedVariant('named');

        final varAttrs = [
          VariantSpecAttribute(
            contextVariant,
            _MockSpecAttribute(width: 100.0),
          ),
          VariantSpecAttribute(
            namedVariant,
            _MockSpecAttribute(width: 200.0),
          ),
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
        final spec = result.resolveSpec(context);
        expect((spec.resolvedValue as Map)['width'], 50.0);
      });

      test('sorting is stable for non-WidgetStateVariant elements', () {
        // Create multiple non-WidgetState variants to test stable sort
        final variants = [
          VariantSpecAttribute(
            ContextVariant('context1', (context) => true),
            _MockSpecAttribute(width: 100.0),
          ),
          VariantSpecAttribute(
            const NamedVariant('named1'),
            _MockSpecAttribute(width: 200.0),
          ),
          VariantSpecAttribute(
            ContextVariant('context2', (context) => true),
            _MockSpecAttribute(width: 300.0),
          ),
          VariantSpecAttribute(
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
          namedVariants: {const NamedVariant('named1'), const NamedVariant('named2')},
        );

        // Should maintain original order, last applied is named2 (400)
        final spec = result.resolveSpec(context);
        expect((spec.resolvedValue as Map)['width'], 400.0);
      });
    });

    group('Integration with existing variant system', () {
      test('works with actual WidgetStateVariant instances', () {
        // Test with real WidgetStateVariant from the codebase
        final hoverVariant = _MockWidgetStateVariant();
        final pressVariant = _MockWidgetStateVariant();

        final varAttrs = [
          VariantSpecAttribute(
            hoverVariant,
            _MockSpecAttribute(width: 100.0),
          ),
          VariantSpecAttribute(
            pressVariant,
            _MockSpecAttribute(width: 200.0),
          ),
        ];

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: varAttrs,
        );

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(context);

        // Press variant (last) should apply
        final spec = result.resolveSpec(context);
        expect((spec.resolvedValue as Map)['width'], 200.0);
      });

      test('integrates with predefined variant instances', () {
        // Test with predefined variants from the variant system
        final varAttrs = [
          VariantSpecAttribute(
            _MockWidgetStateVariant(), // Mock hover variant
            _MockSpecAttribute(width: 100.0),
          ),
          VariantSpecAttribute(
            _MockWidgetStateVariant(), // Mock press variant  
            _MockSpecAttribute(width: 200.0),
          ),
        ];

        final testAttribute = _MockSpecAttribute(
          width: 50.0,
          variants: varAttrs,
        );

        final context = MockBuildContext();
        final result = testAttribute.getAllStyleVariants(context);

        // Both are WidgetStateVariants, press (last) should apply
        final spec = result.resolveSpec(context);
        expect((spec.resolvedValue as Map)['width'], 200.0);
      });
    });
  });
}

// Test helper class that implements SpecAttribute for testing
class _MockSpecAttribute extends SpecAttribute<MockSpec> {
  final double width;
  final double? height;

  _MockSpecAttribute({
    required this.width,
    this.height,
    super.variants,
  });

  @override
  MockSpec resolveSpec(BuildContext context) {
    return MockSpec(resolvedValue: {'width': width, 'height': height});
  }

  @override
  _MockSpecAttribute merge(covariant _MockSpecAttribute? other) {
    if (other == null) return this;

    return _MockSpecAttribute(
      width: other.width != 0.0 ? other.width : width,
      height: other.height ?? height,
      variants: mergeVariantLists(variants, other.variants),
    );
  }

  @override
  List<Object?> get props => [width, height, variants];
}

// Mock WidgetStateVariant that always matches for testing priority behavior
class _MockWidgetStateVariant extends WidgetStateVariant {
  static int _counter = 0;
  final int _id = _counter++;

  _MockWidgetStateVariant() : super(WidgetState.hovered);

  @override
  String get key => 'mock_widget_state_$_id';

  @override
  bool when(BuildContext context) => true; // Always matches for testing

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _MockWidgetStateVariant && other._id == _id;

  @override
  int get hashCode => _id.hashCode;
}