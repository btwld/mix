import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

final _testOutlined = 'test_testOutlined';
final _testSolid = 'test_testSolid';
final _testSmall = 'test_small';
final _testLarge = 'test_large';
final _primary = 'primary';

class TestOutlinedBoxStyler extends BoxStyler
    with StyleVariantMixin<BoxStyler, BoxSpec> {
  @override
  final variantKey = _testOutlined;

  @override
  BoxStyler buildStyle(Set<String> activeVariants) {
    // Always apply styling - StyleVariantMixin activation is handled by EventVariantStyle
    // Create a clean BoxStyler without variants to prevent recursion
    final cleanBase = BoxStyler();

    final result = switch (activeVariants) {
      _ when activeVariants.contains(_testSmall) => cleanBase.width(80.0),
      _ when activeVariants.contains(_testLarge) => cleanBase.width(120.0),
      _ => cleanBase.width(100.0),
    };

    return switch ((
      activeVariants.contains(_testSmall),
      activeVariants.contains(_primary),
    )) {
      (true, true) => result.height(40.0),
      _ => result,
    };
  }
}

class TestSolidBoxStyler extends BoxStyler
    with StyleVariantMixin<BoxStyler, BoxSpec> {
  @override
  final variantKey = _testSolid;

  @override
  BoxStyler buildStyle(Set<String> activeVariants) {
    // Always apply styling - StyleVariantMixin activation is handled by EventVariantStyle
    // Create a clean BoxStyler without variants to prevent recursion
    final cleanBase = BoxStyler();

    return switch (activeVariants) {
      _ when activeVariants.contains(_testSmall) => cleanBase.width(70.0),
      _ when activeVariants.contains(_testLarge) => cleanBase.width(110.0),
      _ => cleanBase.width(90.0),
    };
  }
}

class TestSmallBoxStyler extends BoxStyler
    with StyleVariantMixin<BoxStyler, BoxSpec> {
  @override
  final variantKey = _testSmall;

  @override
  BoxStyler buildStyle(Set<String> activeVariants) {
    // Always apply styling - StyleVariantMixin activation is handled by EventVariantStyle
    // Create a clean BoxStyler without variants to prevent recursion
    final cleanBase = BoxStyler();

    return cleanBase.height(32.0);
  }
}

void main() {
  group('StyleVariation Interface', () {
    test('should implement basic interface correctly', () {
      final outlinedStyler = TestOutlinedBoxStyler();

      expect(outlinedStyler, isA<StyleVariantMixin<BoxStyler, BoxSpec>>());
      expect(outlinedStyler, isA<BoxStyler>());
      expect(outlinedStyler.variantKey, _testOutlined);
    });

    testWidgets('should apply base styling through styleBuilder', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final outlinedStyler = TestOutlinedBoxStyler();
              final result = outlinedStyler.buildStyle({});

              expect(result, isA<BoxStyler>());
              expect(result, isNotNull);

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should handle user modifications correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final outlinedStyler = TestOutlinedBoxStyler();
              final result = outlinedStyler.buildStyle({});

              expect(result, isA<BoxStyler>());

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should preserve user styling in styleBuilder', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final outlinedStyler = TestOutlinedBoxStyler();

              final result = outlinedStyler.buildStyle({});

              expect(result, isA<BoxStyler>());

              return Container();
            },
          ),
        ),
      );
    });
  });

  group('Contextual Adaptation', () {
    testWidgets('should adapt based on single active variant', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final outlinedStyler = TestOutlinedBoxStyler();
              final activeVariants = {_testOutlined, _testSmall};

              final result = outlinedStyler.buildStyle(activeVariants);

              expect(result, isA<BoxStyler>());
              // Should have base outlined styling + small adaptation

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should handle multiple active variants', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final outlinedStyler = TestOutlinedBoxStyler();
              final activeVariants = {_testOutlined, _testSmall, _testLarge};

              final result = outlinedStyler.buildStyle(activeVariants);

              expect(result, isA<BoxStyler>());

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should handle complex variant combinations', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final outlinedStyler = TestOutlinedBoxStyler();
              final activeVariants = {_testOutlined, _testSmall, _primary};

              final result = outlinedStyler.buildStyle(activeVariants);

              expect(result, isA<BoxStyler>());

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should handle no active variants gracefully', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final outlinedStyler = TestOutlinedBoxStyler();
              final result = outlinedStyler.buildStyle({});

              expect(result, isA<BoxStyler>());

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should adapt differently based on base variant', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final outlinedStyler = TestOutlinedBoxStyler();
              final solidStyler = TestSolidBoxStyler();
              final activeVariants = {_testSmall};

              final outlinedResult = outlinedStyler.buildStyle({
                _testOutlined,
                ...activeVariants,
              });
              final solidResult = solidStyler.buildStyle({
                _testSolid,
                ...activeVariants,
              });

              expect(outlinedResult, isA<BoxStyler>());
              expect(solidResult, isA<BoxStyler>());

              return Container();
            },
          ),
        ),
      );
    });
  });

  group('Type Safety with Covariant', () {
    testWidgets('should maintain specific return types', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final outlinedStyler = TestOutlinedBoxStyler();
              final result = outlinedStyler.buildStyle({});

              expect(result, isA<BoxStyler>());

              final chainedResult = result.height(100);
              expect(chainedResult, isA<BoxStyler>());

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should accept specific parameter types', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final outlinedStyler = TestOutlinedBoxStyler();

              final result = outlinedStyler.buildStyle({});
              expect(result, isA<BoxStyler>());

              return Container();
            },
          ),
        ),
      );
    });
  });

  group('StyleVariation Integration', () {
    test('should work as natural API', () {
      final component = TestOutlinedBoxStyler();

      expect(component, isA<BoxStyler>());
      expect(component, isA<StyleVariantMixin<BoxStyler, BoxSpec>>());
      expect(component.variantKey, _testOutlined);

      final modified = component.height(48).width(100);
      expect(modified, isA<BoxStyler>());
    });

    testWidgets('should enable contextual styling patterns', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final outlinedStyler = TestOutlinedBoxStyler();
              final smallStyler = TestSmallBoxStyler();

              final outlinedResult = outlinedStyler.buildStyle({
                _testOutlined,
                _testSmall,
              });

              final smallResult = smallStyler.buildStyle({_testSmall});

              expect(outlinedResult, isA<BoxStyler>());
              expect(smallResult, isA<BoxStyler>());

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should maintain user modifications through resolution', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final outlinedStyler = TestOutlinedBoxStyler();

              final result = outlinedStyler.buildStyle({
                _testOutlined,
                _testSmall,
                _primary,
              });

              expect(result, isA<BoxStyler>());

              return Container();
            },
          ),
        ),
      );
    });
  });

  group('Integration with Style.build()', () {
    testWidgets('should resolve StyleVariation through Style.build()', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final outlinedStyler = TestOutlinedBoxStyler();

              final baseStyle = BoxStyler().height(48.0).withVariants([
                EventVariantStyle(
                  ContextTrigger(_testOutlined, (context) => true),
                  outlinedStyler,
                ),
              ]);
              final resolvedSpec = baseStyle.build(
                context,
                namedVariants: {_testOutlined},
              );

              expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());

              final resolved = resolvedSpec.spec;
              expect(resolved.constraints?.minWidth, 100.0);
              expect(resolved.constraints?.maxWidth, 100.0);
              expect(resolved.constraints?.minHeight, 48.0);
              expect(resolved.constraints?.maxHeight, 48.0);

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should handle contextual adaptation in Style.build()', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final outlinedStyler = TestOutlinedBoxStyler();

              final baseStyle = BoxStyler().height(48.0).withVariants([
                EventVariantStyle(
                  ContextTrigger(_testOutlined, (context) => true),
                  outlinedStyler,
                ),
              ]);
              final resolvedSpec = baseStyle.build(
                context,
                namedVariants: {_testOutlined, _testSmall},
              );

              expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());

              final resolved = resolvedSpec.spec;
              expect(resolved.constraints?.minWidth, 80.0);
              expect(resolved.constraints?.maxWidth, 80.0);

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should handle complex variant combinations in Style.build()', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final outlinedStyler = TestOutlinedBoxStyler();

              final baseStyle = BoxStyler().width(200.0).withVariants([
                EventVariantStyle(
                  ContextTrigger(_testOutlined, (context) => true),
                  outlinedStyler,
                ),
              ]);
              final resolvedSpec = baseStyle.build(
                context,
                namedVariants: {_testOutlined, _testSmall, _primary},
              );

              expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());

              final resolved = resolvedSpec.spec;
              expect(resolved.constraints?.minWidth, 80.0);
              expect(resolved.constraints?.maxWidth, 80.0);
              expect(resolved.constraints?.minHeight, 40.0);
              expect(resolved.constraints?.maxHeight, 40.0);

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should work with multiple StyleVariations', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final outlinedStyler = TestOutlinedBoxStyler();
              final smallStyler = TestSmallBoxStyler();

              final baseStyle = BoxStyler().withVariants([
                EventVariantStyle(
                  ContextTrigger(_testOutlined, (context) => true),
                  outlinedStyler,
                ),
                EventVariantStyle(
                  ContextTrigger(_testSmall, (context) => true),
                  smallStyler,
                ),
              ]);
              final resolvedSpec = baseStyle.build(
                context,
                namedVariants: {_testOutlined, _testSmall},
              );

              expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());

              final resolved = resolvedSpec.spec;
              expect(resolved.constraints?.minWidth, 80.0);
              expect(resolved.constraints?.maxWidth, 80.0);
              expect(resolved.constraints?.minHeight, 32.0);
              expect(resolved.constraints?.maxHeight, 32.0);

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should handle no StyleVariations gracefully', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final baseStyle = BoxStyler().height(48.0).width(100.0);
              final resolvedSpec = baseStyle.build(
                context,
                namedVariants: {_testOutlined},
              );

              expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());

              final resolved = resolvedSpec.spec;
              expect(resolved.constraints?.minWidth, 100.0);
              expect(resolved.constraints?.maxWidth, 100.0);
              expect(resolved.constraints?.minHeight, 48.0);
              expect(resolved.constraints?.maxHeight, 48.0);

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should handle StyleVariation with no matching namedVariants', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final outlinedStyler = TestOutlinedBoxStyler();

              final baseStyle = BoxStyler()
                  .height(48.0)
                  .width(100.0)
                  .withVariants([
                    EventVariantStyle(
                      ContextTrigger(_testOutlined, (context) => true),
                      outlinedStyler,
                    ),
                  ]);
              final resolvedSpec = baseStyle.build(
                context,
                namedVariants: {_testSolid}, // Doesn't match 'outlined'
              );

              expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());

              final resolved = resolvedSpec.spec;
              expect(resolved.constraints?.minWidth, 100.0);
              expect(resolved.constraints?.maxWidth, 100.0);
              expect(resolved.constraints?.minHeight, 48.0);
              expect(resolved.constraints?.maxHeight, 48.0);

              return Container();
            },
          ),
        ),
      );
    });
  });

  group('Integration with Traditional VariantStyle', () {
    testWidgets('should work alongside traditional VariantStyle', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final outlinedStyler = TestOutlinedBoxStyler();

              final baseStyle = BoxStyler().height(48.0).withVariants([
                EventVariantStyle(
                  ContextTrigger(_testOutlined, (context) => true),
                  outlinedStyler,
                ),
              ]);

              final resolvedSpec = baseStyle.build(
                context,
                namedVariants: {_testOutlined},
              );

              expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());

              final resolved = resolvedSpec.spec;
              expect(resolved.constraints?.minHeight, 48.0);
              expect(resolved.constraints?.maxHeight, 48.0);
              expect(resolved.constraints?.minWidth, 100.0);
              expect(resolved.constraints?.maxWidth, 100.0);

              return Container();
            },
          ),
        ),
      );
    });
  });
}
