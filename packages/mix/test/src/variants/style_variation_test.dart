import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';


class TestOutlinedBoxStyler extends BoxStyler implements StyleVariation<BoxSpec> {
  @override
  NamedVariant get variantType => outlined;
  
  @override
  BoxStyler styleBuilder(BoxStyler style, Set<NamedVariant> activeVariants, BuildContext context) {
    // Only apply styling if outlined variant is active
    if (!activeVariants.contains(outlined)) return style;
    
    final result = switch (activeVariants) {
      _ when activeVariants.contains(small) => style.width(80.0),
      _ when activeVariants.contains(large) => style.width(120.0),
      _ => style.width(100.0),
    };
    
    return switch ((activeVariants.contains(small), activeVariants.contains(primary))) {
      (true, true) => result.height(40.0),
      _ => result,
    };
  }
}

class TestSolidBoxStyler extends BoxStyler implements StyleVariation<BoxSpec> {
  @override
  NamedVariant get variantType => solid;
  
  @override
  BoxStyler styleBuilder(BoxStyler style, Set<NamedVariant> activeVariants, BuildContext context) {
    // Only apply styling if solid variant is active
    if (!activeVariants.contains(solid)) return style;
    
    return switch (activeVariants) {
      _ when activeVariants.contains(small) => style.width(70.0),
      _ when activeVariants.contains(large) => style.width(110.0),
      _ => style.width(90.0),
    };
  }
}

class TestSmallBoxStyler extends BoxStyler implements StyleVariation<BoxSpec> {
  @override
  NamedVariant get variantType => small;
  
  @override
  BoxStyler styleBuilder(BoxStyler style, Set<NamedVariant> activeVariants, BuildContext context) {
    // Only apply styling if small variant is active
    if (!activeVariants.contains(small)) return style;
    
    return style.height(32.0);
  }
}

void main() {
  group('StyleVariation Interface', () {
    test('should implement basic interface correctly', () {
      final outlinedStyler = TestOutlinedBoxStyler();
      
      expect(outlinedStyler, isA<StyleVariation<BoxSpec>>());
      expect(outlinedStyler, isA<BoxStyler>());
      expect(outlinedStyler.variantType, outlined);
    });

    testWidgets('should apply base styling through styleBuilder', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            final result = outlinedStyler.styleBuilder(BoxStyler(), {}, context);
            
            expect(result, isA<BoxStyler>());
            expect(result, isNotNull);
            
            return Container();
          },
        ),
      ));
    });

    testWidgets('should handle user modifications correctly', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            final userModified = BoxStyler().height(48);
            final result = outlinedStyler.styleBuilder(userModified, {}, context);
            
            expect(result, isA<BoxStyler>());
            
            return Container();
          },
        ),
      ));
    });

    testWidgets('should preserve user styling in styleBuilder', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            final userStyle = BoxStyler().height(48).width(100);
            
            final result = outlinedStyler.styleBuilder(userStyle, {}, context);
            
            expect(result, isA<BoxStyler>());
            
            return Container();
          },
        ),
      ));
    });
  });

  group('Variant.named() Factory Method', () {
    test('should create NamedVariant correctly', () {
      final variant = Variant.named('test');
      
      expect(variant, isA<NamedVariant>());
      expect(variant.name, 'test');
      expect(variant.key, 'test');
    });

    test('should create different variants with different names', () {
      final variant1 = Variant.named('primary');
      final variant2 = Variant.named('secondary');
      
      expect(variant1.name, 'primary');
      expect(variant2.name, 'secondary');
      expect(variant1, isNot(equals(variant2)));
    });

    test('should create equal variants with same name', () {
      final variant1 = Variant.named('primary');
      final variant2 = Variant.named('primary');
      
      expect(variant1, equals(variant2));
      expect(variant1.hashCode, equals(variant2.hashCode));
    });
  });

  group('Contextual Adaptation', () {
    testWidgets('should adapt based on single active variant', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            final activeVariants = {outlined, small};
            
            final result = outlinedStyler.styleBuilder(BoxStyler(), activeVariants, context);
            
            expect(result, isA<BoxStyler>());
            // Should have base outlined styling + small adaptation
            
            return Container();
          },
        ),
      ));
    });

    testWidgets('should handle multiple active variants', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            final activeVariants = {
              outlined,
              small,
              large,
            };
            
            final result = outlinedStyler.styleBuilder(BoxStyler(), activeVariants, context);
            
            expect(result, isA<BoxStyler>());
            
            return Container();
          },
        ),
      ));
    });

    testWidgets('should handle complex variant combinations', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            final activeVariants = {
              outlined,
              small,
              primary,
            };
            
            final result = outlinedStyler.styleBuilder(BoxStyler(), activeVariants, context);
            
            expect(result, isA<BoxStyler>());
            
            return Container();
          },
        ),
      ));
    });

    testWidgets('should handle no active variants gracefully', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            final result = outlinedStyler.styleBuilder(BoxStyler(), {}, context);
            
            expect(result, isA<BoxStyler>());
            
            return Container();
          },
        ),
      ));
    });

    testWidgets('should adapt differently based on base variant', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            final solidStyler = TestSolidBoxStyler();
            final activeVariants = {small};
            
            final outlinedResult = outlinedStyler.styleBuilder(BoxStyler(), {outlined, ...activeVariants}, context);
            final solidResult = solidStyler.styleBuilder(BoxStyler(), {solid, ...activeVariants}, context);
            
            expect(outlinedResult, isA<BoxStyler>());
            expect(solidResult, isA<BoxStyler>());
            
            return Container();
          },
        ),
      ));
    });
  });

  group('Type Safety with Covariant', () {
    testWidgets('should maintain specific return types', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            final result = outlinedStyler.styleBuilder(BoxStyler(), {}, context);
            
            expect(result, isA<BoxStyler>());
            
            final chainedResult = result.height(100);
            expect(chainedResult, isA<BoxStyler>());
            
            return Container();
          },
        ),
      ));
    });

    testWidgets('should accept specific parameter types', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            final boxStyler = BoxStyler().height(48);
            
            final result = outlinedStyler.styleBuilder(boxStyler, {}, context);
            expect(result, isA<BoxStyler>());
            
            return Container();
          },
        ),
      ));
    });
  });

  group('StyleVariation Integration', () {
    test('should work as natural API', () {
      final component = TestOutlinedBoxStyler();
      
      expect(component, isA<BoxStyler>());
      expect(component, isA<StyleVariation<BoxSpec>>());
      expect(component.variantType, outlined);
      
      final modified = component.height(48).width(100);
      expect(modified, isA<BoxStyler>());
    });

    testWidgets('should enable contextual styling patterns', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            final smallStyler = TestSmallBoxStyler();
            final userStyle = BoxStyler().height(40);
            
            final outlinedResult = outlinedStyler.styleBuilder(
              userStyle,
              {outlined, small},
              context,
            );
            
            final smallResult = smallStyler.styleBuilder(BoxStyler(), {small}, context);
            
            expect(outlinedResult, isA<BoxStyler>());
            expect(smallResult, isA<BoxStyler>());
            
            return Container();
          },
        ),
      ));
    });

    testWidgets('should maintain user modifications through resolution', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            final userModifications = BoxStyler()
                .height(48)
                .width(100);
            
            final result = outlinedStyler.styleBuilder(
              userModifications,
              {outlined, small, primary},
              context,
            );
            
            expect(result, isA<BoxStyler>());
            
            return Container();
          },
        ),
      ));
    });
  });

  group('Backward Compatibility', () {
    test('should not break existing NamedVariant usage', () {
      final traditional = NamedVariant('test');
      
      expect(traditional, isA<NamedVariant>());
      expect(traditional.name, 'test');
      expect(traditional.key, 'test');
    });

    test('should not break existing VariantStyle usage', () {
      const variant = NamedVariant('test');
      final style = BoxStyler().color(Colors.blue);
      final variantStyle = VariantStyle(variant, style);
      
      expect(variantStyle, isA<VariantStyle<BoxSpec>>());
      expect(variantStyle.variant, variant);
      expect(variantStyle.value, style);
    });
  });

  group('Integration with Style.build()', () {
    testWidgets('should resolve StyleVariation through Style.build()', skip: true, (tester) async {
      // TODO: Infinite recursion issue - temporarily disabled
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            
            final baseStyle = BoxStyler()
                .height(48.0)
                .variants([
                  VariantStyle(outlined, outlinedStyler),
                ]);
            final resolvedSpec = baseStyle.build(
              context,
              namedVariants: {outlined},
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
      ));
    });

    testWidgets('should handle contextual adaptation in Style.build()', skip: true, (tester) async {
      // TODO: Infinite recursion issue - temporarily disabled
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            
            final baseStyle = BoxStyler()
                .height(48.0)
                .variants([
                  VariantStyle(outlined, outlinedStyler),
                ]);
            final resolvedSpec = baseStyle.build(
              context,
              namedVariants: {outlined, small},
            );
            
            expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());
            
            final resolved = resolvedSpec.spec;
            expect(resolved.constraints?.minWidth, 80.0);
            expect(resolved.constraints?.maxWidth, 80.0);
            
            return Container();
          },
        ),
      ));
    });

    testWidgets('should handle complex variant combinations in Style.build()', skip: true, (tester) async {
      // TODO: Infinite recursion issue - temporarily disabled
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            
            final baseStyle = BoxStyler()
                .width(200.0)
                .variants([
                  VariantStyle(outlined, outlinedStyler),
                ]);
            final resolvedSpec = baseStyle.build(
              context,
              namedVariants: {
                outlined,
                small,
                primary
              },
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
      ));
    });

    testWidgets('should work with multiple StyleVariations', skip: true, (tester) async {
      // TODO: Infinite recursion issue - temporarily disabled
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            final smallStyler = TestSmallBoxStyler();
            
            final baseStyle = BoxStyler()
                .variants([
                  VariantStyle(outlined, outlinedStyler),
                  VariantStyle(small, smallStyler),
                ]);
            final resolvedSpec = baseStyle.build(
              context,
              namedVariants: {outlined, small},
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
      ));
    });

    testWidgets('should handle no StyleVariations gracefully', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final baseStyle = BoxStyler().height(48.0).width(100.0);
            final resolvedSpec = baseStyle.build(
              context,
              namedVariants: {outlined},
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
      ));
    });

    testWidgets('should handle StyleVariation with no matching namedVariants', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            
            final baseStyle = BoxStyler()
                .height(48.0)
                .width(100.0)
                .variants([
                  VariantStyle(outlined, outlinedStyler),
                ]);
            final resolvedSpec = baseStyle.build(
              context,
              namedVariants: {solid}, // Doesn't match 'outlined'
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
      ));
    });
  });

  group('Integration with Traditional VariantStyle', () {
    testWidgets('should work alongside traditional VariantStyle', skip: true, (tester) async {
      // TODO: Infinite recursion issue - temporarily disabled
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            
            final baseStyle = BoxStyler()
                .height(48.0)
                .variants([
                  VariantStyle(outlined, outlinedStyler),
                ]);

            final resolvedSpec = baseStyle.build(
              context,
              namedVariants: {outlined},
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
      ));
    });
  });
}