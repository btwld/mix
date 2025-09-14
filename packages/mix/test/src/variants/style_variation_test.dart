import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

class TestOutlinedBoxStyler extends BoxStyler implements StyleVariation<BoxSpec> {
  @override
  String get variantName => 'outlined';
  
  @override
  BoxStyler styleBuilder(BoxStyler style, List<NamedVariant> activeVariants) {
    final result = switch (activeVariants) {
      _ when hasVariant(activeVariants, small) => style.width(80.0),
      _ when hasVariant(activeVariants, large) => style.width(120.0),
      _ => style.width(100.0),
    };
    
    return switch ((hasVariant(activeVariants, small), hasVariant(activeVariants, primary))) {
      (true, true) => result.height(40.0),
      _ => result,
    };
  }
}

class TestSolidBoxStyler extends BoxStyler implements StyleVariation<BoxSpec> {
  @override
  String get variantName => 'solid';
  
  @override
  BoxStyler styleBuilder(BoxStyler style, List<NamedVariant> activeVariants) =>
    switch (activeVariants) {
      _ when hasVariant(activeVariants, small) => style.width(70.0),
      _ when hasVariant(activeVariants, large) => style.width(110.0),
      _ => style.width(90.0),
    };
}

class TestSmallBoxStyler extends BoxStyler implements StyleVariation<BoxSpec> {
  @override
  String get variantName => 'small';
  
  @override
  BoxStyler styleBuilder(BoxStyler style, List<NamedVariant> activeVariants) => style.height(32.0);
}

void main() {
  group('StyleVariation Interface', () {
    test('should implement basic interface correctly', () {
      final outlinedStyler = TestOutlinedBoxStyler();
      
      expect(outlinedStyler, isA<StyleVariation<BoxSpec>>());
      expect(outlinedStyler, isA<BoxStyler>());
      expect(outlinedStyler.variantName, 'outlined');
    });

    test('should apply base styling through styleBuilder', () {
      final outlinedStyler = TestOutlinedBoxStyler();
      final result = outlinedStyler.styleBuilder(BoxStyler(), []);
      
      expect(result, isA<BoxStyler>());
      expect(result, isNotNull);
    });

    test('should handle user modifications correctly', () {
      final outlinedStyler = TestOutlinedBoxStyler();
      final userModified = BoxStyler().height(48);
      final result = outlinedStyler.styleBuilder(userModified, []);
      
      expect(result, isA<BoxStyler>());
    });

    test('should preserve user styling in styleBuilder', () {
      final outlinedStyler = TestOutlinedBoxStyler();
      final userStyle = BoxStyler().height(48).width(100);
      
      final result = outlinedStyler.styleBuilder(userStyle, []);
      
      expect(result, isA<BoxStyler>());
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
    test('should adapt based on single active variant', () {
      final outlinedStyler = TestOutlinedBoxStyler();
      final activeVariants = [small];
      
      final result = outlinedStyler.styleBuilder(BoxStyler(), activeVariants);
      
      expect(result, isA<BoxStyler>());
      // Should have base outlined styling + small adaptation
    });

    test('should handle multiple active variants', () {
      final outlinedStyler = TestOutlinedBoxStyler();
      final activeVariants = [
        small,
        large,
      ];
      
      final result = outlinedStyler.styleBuilder(BoxStyler(), activeVariants);
      
      expect(result, isA<BoxStyler>());
    });

    test('should handle complex variant combinations', () {
      final outlinedStyler = TestOutlinedBoxStyler();
      final activeVariants = [
        small,
        primary,
      ];
      
      final result = outlinedStyler.styleBuilder(BoxStyler(), activeVariants);
      
      expect(result, isA<BoxStyler>());
    });

    test('should handle no active variants gracefully', () {
      final outlinedStyler = TestOutlinedBoxStyler();
      final result = outlinedStyler.styleBuilder(BoxStyler(), []);
      
      expect(result, isA<BoxStyler>());
    });

    test('should adapt differently based on base variant', () {
      final outlinedStyler = TestOutlinedBoxStyler();
      final solidStyler = TestSolidBoxStyler();
      final activeVariants = [small];
      
      final outlinedResult = outlinedStyler.styleBuilder(BoxStyler(), activeVariants);
      final solidResult = solidStyler.styleBuilder(BoxStyler(), activeVariants);
      
      expect(outlinedResult, isA<BoxStyler>());
      expect(solidResult, isA<BoxStyler>());
    });
  });

  group('Type Safety with Covariant', () {
    test('should maintain specific return types', () {
      final outlinedStyler = TestOutlinedBoxStyler();
      final result = outlinedStyler.styleBuilder(BoxStyler(), []);
      
      expect(result, isA<BoxStyler>());
      
      final chainedResult = result.height(100);
      expect(chainedResult, isA<BoxStyler>());
    });

    test('should accept specific parameter types', () {
      final outlinedStyler = TestOutlinedBoxStyler();
      final boxStyler = BoxStyler().height(48);
      
      final result = outlinedStyler.styleBuilder(boxStyler, []);
      expect(result, isA<BoxStyler>());
    });
  });

  group('StyleVariation Integration', () {
    test('should work as natural API', () {
      final component = TestOutlinedBoxStyler();
      
      expect(component, isA<BoxStyler>());
      expect(component, isA<StyleVariation<BoxSpec>>());
      expect(component.variantName, 'outlined');
      
      final modified = component.height(48).width(100);
      expect(modified, isA<BoxStyler>());
    });

    test('should enable contextual styling patterns', () {
      final outlinedStyler = TestOutlinedBoxStyler();
      final smallStyler = TestSmallBoxStyler();
      final userStyle = BoxStyler().height(40);
      
      final outlinedResult = outlinedStyler.styleBuilder(
        userStyle,
        [small],
      );
      
      final smallResult = smallStyler.styleBuilder(BoxStyler(), []);
      
      expect(outlinedResult, isA<BoxStyler>());
      expect(smallResult, isA<BoxStyler>());
    });

    test('should maintain user modifications through resolution', () {
      final outlinedStyler = TestOutlinedBoxStyler();
      final userModifications = BoxStyler()
          .height(48)
          .width(100);
      
      final result = outlinedStyler.styleBuilder(
        userModifications,
        [small, primary],
      );
      
      expect(result, isA<BoxStyler>());
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
    testWidgets('should resolve StyleVariation through Style.build()', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            final styleVariations = <StyleVariation<BoxSpec>>[outlinedStyler];
            
            final baseStyle = BoxStyler().height(48.0);
            final resolvedSpec = baseStyle.build(
              context,
              namedVariants: {outlined},
              styleVariations: styleVariations,
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

    testWidgets('should handle contextual adaptation in Style.build()', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            final styleVariations = <StyleVariation<BoxSpec>>[outlinedStyler];
            
            final baseStyle = BoxStyler().height(48.0);
            final resolvedSpec = baseStyle.build(
              context,
              namedVariants: {outlined, small},
              styleVariations: styleVariations,
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

    testWidgets('should handle complex variant combinations in Style.build()', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            final styleVariations = <StyleVariation<BoxSpec>>[outlinedStyler];
            
            final baseStyle = BoxStyler().width(200.0);
            final resolvedSpec = baseStyle.build(
              context,
              namedVariants: {
                outlined,
                small,
                primary
              },
              styleVariations: styleVariations,
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

    testWidgets('should work with multiple StyleVariations', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            final smallStyler = TestSmallBoxStyler();
            final styleVariations = <StyleVariation<BoxSpec>>[outlinedStyler, smallStyler];
            
            final baseStyle = BoxStyler();
            final resolvedSpec = baseStyle.build(
              context,
              namedVariants: {outlined, small},
              styleVariations: styleVariations,
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

    testWidgets('should handle empty styleVariations gracefully', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final baseStyle = BoxStyler().height(48.0).width(100.0);
            final resolvedSpec = baseStyle.build(
              context,
              namedVariants: {outlined},
              styleVariations: [], // Empty styleVariations
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
            final styleVariations = <StyleVariation<BoxSpec>>[outlinedStyler];
            
            final baseStyle = BoxStyler().height(48.0).width(100.0);
            final resolvedSpec = baseStyle.build(
              context,
              namedVariants: {NamedVariant('solid')}, // Doesn't match 'outlined'
              styleVariations: styleVariations,
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
    testWidgets('should work alongside traditional VariantStyle', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final outlinedStyler = TestOutlinedBoxStyler();
            final styleVariations = <StyleVariation<BoxSpec>>[outlinedStyler];
            
            final baseStyle = BoxStyler().height(48.0);

            final resolvedSpec = baseStyle.build(
              context,
              namedVariants: {outlined},
              styleVariations: styleVariations,
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