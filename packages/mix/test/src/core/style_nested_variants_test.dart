import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Style Nested Variants', () {
    test('simple nested named variants should work', () {
      const primaryVariant = NamedVariant('primary');
      const secondaryVariant = NamedVariant('secondary');

      final testAttribute = _MockSpecAttribute(
        width: 100.0,
        variants: [
          VariantStyle(
            primaryVariant,
            _MockSpecAttribute(
              width: 200.0,
              variants: [
                VariantStyle(
                  secondaryVariant,
                  _MockSpecAttribute(width: 300.0),
                ),
              ],
            ),
          ),
        ],
      );

      final context = MockBuildContext();
      final result = testAttribute.build(
        context,
        namedVariants: {primaryVariant, secondaryVariant},
      );
      final resolvedValue = result.spec.resolvedValue as Map<String, dynamic>;

      // Should resolve to 300.0 (nested secondary variant within primary)
      expect(resolvedValue['width'], 300.0);
    });

    testWidgets('nested context variant should be evaluated', (tester) async {
      // Create a style with nested variants: hover -> orientation(portrait)
      final testAttribute = _MockSpecAttribute(
        width: 100.0,
        variants: [
          VariantStyle(
            ContextVariant.widgetState(WidgetState.hovered),
            _MockSpecAttribute(
              width: 200.0,
              variants: [
                VariantStyle(
                  ContextVariant.orientation(Orientation.portrait),
                  _MockSpecAttribute(width: 300.0),
                ),
              ],
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(400, 800), // Portrait orientation
            ),
            child: WidgetStateProvider(
              states: const {WidgetState.hovered},
              child: Builder(
                builder: (context) {
                  final result = testAttribute.build(context);
                  final resolvedValue =
                      result.spec.resolvedValue as Map<String, dynamic>;

                  // Should resolve to 300.0 (nested orientation variant within hover)
                  expect(resolvedValue['width'], 300.0);

                  return Container();
                },
              ),
            ),
          ),
        ),
      );
    });

    testWidgets('nested variant without parent condition should not apply', (
      tester,
    ) async {
      final testAttribute = _MockSpecAttribute(
        width: 100.0,
        variants: [
          VariantStyle(
            ContextVariant.widgetState(WidgetState.hovered),
            _MockSpecAttribute(
              width: 200.0,
              variants: [
                VariantStyle(
                  ContextVariant.brightness(Brightness.dark),
                  _MockSpecAttribute(width: 300.0),
                ),
              ],
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          home: Builder(
            builder: (context) {
              final result = testAttribute.build(context);
              final resolvedValue =
                  result.spec.resolvedValue as Map<String, dynamic>;

              // Should resolve to 100.0 (base value, hover not active so nested dark doesn't apply)
              expect(resolvedValue['width'], 100.0);

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('multiple levels of nesting should work', (tester) async {
      final testAttribute = _MockSpecAttribute(
        width: 100.0,
        variants: [
          VariantStyle(
            ContextVariant.widgetState(WidgetState.hovered),
            _MockSpecAttribute(
              width: 200.0,
              variants: [
                VariantStyle(
                  ContextVariant.widgetState(WidgetState.pressed),
                  _MockSpecAttribute(
                    width: 300.0,
                    variants: [
                      VariantStyle(
                        ContextVariant.orientation(Orientation.portrait),
                        _MockSpecAttribute(width: 400.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(400, 800), // Portrait orientation
            ),
            child: WidgetStateProvider(
              states: const {WidgetState.hovered, WidgetState.pressed},
              child: Builder(
                builder: (context) {
                  final result = testAttribute.build(context);
                  final resolvedValue =
                      result.spec.resolvedValue as Map<String, dynamic>;

                  // Should resolve to 400.0 (three levels deep)
                  expect(resolvedValue['width'], 400.0);

                  return Container();
                },
              ),
            ),
          ),
        ),
      );
    });

    test('empty nested variants should not cause issues', () {
      const primaryVariant = NamedVariant('primary');

      final testAttribute = _MockSpecAttribute(
        width: 100.0,
        variants: [
          VariantStyle(
            primaryVariant,
            _MockSpecAttribute(
              width: 200.0,
              variants: [], // Empty nested variants
            ),
          ),
        ],
      );

      final context = MockBuildContext();
      final result = testAttribute.build(
        context,
        namedVariants: {primaryVariant},
      );
      final resolvedValue = result.spec.resolvedValue as Map<String, dynamic>;

      // Should resolve to 200.0 (primary variant with empty nested variants)
      expect(resolvedValue['width'], 200.0);
    });

    test('null nested variants should work correctly', () {
      const primaryVariant = NamedVariant('primary');

      final testAttribute = _MockSpecAttribute(
        width: 100.0,
        variants: [
          VariantStyle(
            primaryVariant,
            _MockSpecAttribute(
              width: 200.0,
              variants: null, // Null nested variants
            ),
          ),
        ],
      );

      final context = MockBuildContext();
      final result = testAttribute.build(
        context,
        namedVariants: {primaryVariant},
      );
      final resolvedValue = result.spec.resolvedValue as Map<String, dynamic>;

      // Should resolve to 200.0 (primary variant with null nested variants)
      expect(resolvedValue['width'], 200.0);
    });

    test('deeply nested named variants should work', () {
      // Create 5 levels of nesting with named variants
      const level1 = NamedVariant('level1');
      const level2 = NamedVariant('level2');
      const level3 = NamedVariant('level3');
      const level4 = NamedVariant('level4');
      const level5 = NamedVariant('level5');

      final testAttribute = _MockSpecAttribute(
        width: 100.0,
        variants: [
          VariantStyle(
            level1,
            _MockSpecAttribute(
              width: 200.0,
              variants: [
                VariantStyle(
                  level2,
                  _MockSpecAttribute(
                    width: 300.0,
                    variants: [
                      VariantStyle(
                        level3,
                        _MockSpecAttribute(
                          width: 400.0,
                          variants: [
                            VariantStyle(
                              level4,
                              _MockSpecAttribute(
                                width: 500.0,
                                variants: [
                                  VariantStyle(
                                    level5,
                                    _MockSpecAttribute(width: 600.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );

      final context = MockBuildContext();
      final result = testAttribute.build(
        context,
        namedVariants: {level1, level2, level3, level4, level5},
      );
      final resolvedValue = result.spec.resolvedValue as Map<String, dynamic>;

      // Should resolve to 600.0 (deepest level)
      expect(resolvedValue['width'], 600.0);
    });
  });
}

// Test helper class that implements Style for testing nested variants
class _MockSpecAttribute extends Style<MockSpec<Map<String, dynamic>>> {
  final double width;
  final double? height;

  _MockSpecAttribute({required this.width, this.height, super.variants});

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
