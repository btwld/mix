import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('StyleProviderModifier', () {
    test('can create modifier with resolved style', () {
      final resolvedStyle = ResolvedStyle<BoxSpec>(
        spec: const BoxSpec(),
      );
      
      final modifier = StyleProviderModifier(resolvedStyle);
      
      expect(modifier.resolvedStyle, equals(resolvedStyle));
    });

    test('builds ResolvedStyleProvider widget', () {
      final resolvedStyle = ResolvedStyle<BoxSpec>(
        spec: const BoxSpec(),
      );
      
      final modifier = StyleProviderModifier(resolvedStyle);
      final child = Container();
      final result = modifier.build(child);
      
      expect(result, isA<ResolvedStyleProvider<BoxSpec>>());
      expect((result as ResolvedStyleProvider).resolvedStyle, equals(resolvedStyle));
    });

    test('lerp handles null specs correctly', () {
      final modifier1 = StyleProviderModifier<BoxSpec>(
        const ResolvedStyle(spec: null),
      );
      
      final modifier2 = StyleProviderModifier<BoxSpec>(
        const ResolvedStyle(spec: BoxSpec()),
      );
      
      // Should use step function when spec is null
      final result05 = modifier1.lerp(modifier2, 0.3);
      expect(result05, equals(modifier1));
      
      final result15 = modifier1.lerp(modifier2, 0.7);
      expect(result15, equals(modifier2));
    });

    test('lerp interpolates when both specs are present', () {
      final spec1 = const BoxSpec(
        alignment: Alignment.topLeft,
      );
      
      final spec2 = const BoxSpec(
        alignment: Alignment.bottomRight,
      );
      
      final modifier1 = StyleProviderModifier<BoxSpec>(
        ResolvedStyle(spec: spec1),
      );
      
      final modifier2 = StyleProviderModifier<BoxSpec>(
        ResolvedStyle(spec: spec2),
      );
      
      final result = modifier1.lerp(modifier2, 0.5);
      
      // The lerped spec should be different from both originals
      expect(result.resolvedStyle.spec, isNot(equals(spec1)));
      expect(result.resolvedStyle.spec, isNot(equals(spec2)));
    });
  });

  group('StyleProviderModifierMix', () {
    testWidgets('resolves style using context', (tester) async {
      final style = BoxMix(
        alignment: Alignment.center,
        padding: EdgeInsetsGeometryMix.all(16),
      );
      
      final mix = StyleProviderModifierMix(style);
      
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final resolved = mix.resolve(context);
            
            expect(resolved, isA<StyleProviderModifier<BoxSpec>>());
            expect(resolved.resolvedStyle.spec, isNotNull);
            expect(resolved.resolvedStyle.spec!.alignment, equals(Alignment.center));
            
            return Container();
          },
        ),
      );
    });

    test('merges styles correctly', () {
      final style1 = BoxMix(
        alignment: Alignment.topLeft,
      );
      
      final style2 = BoxMix(
        padding: EdgeInsetsGeometryMix.all(8),
      );
      
      final mix1 = StyleProviderModifierMix(style1);
      final mix2 = StyleProviderModifierMix(style2);
      
      final merged = mix1.merge(mix2);
      
      // The merged style should contain both alignment and padding
      // We can verify this by checking that it's a BoxMix with both properties
      expect(merged.style, isA<BoxMix>());
      final boxMix = merged.style as BoxMix;
      expect(boxMix.$alignment, isNotNull);
      expect(boxMix.$padding, isNotNull);
    });

    test('handles null merge correctly', () {
      final style = BoxMix(
        alignment: Alignment.center,
      );
      
      final mix = StyleProviderModifierMix(style);
      final merged = mix.merge(null);
      
      expect(merged, equals(mix));
    });

    testWidgets('handles empty style resolution', (tester) async {
      // Create an empty style
      final emptyStyle = BoxMix();
      final mix = StyleProviderModifierMix(emptyStyle);
      
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final resolved = mix.resolve(context);
            
            // Should still create a valid modifier even with empty style
            expect(resolved, isA<StyleProviderModifier<BoxSpec>>());
            // The spec might be null or have all null properties
            expect(resolved.resolvedStyle, isNotNull);
            
            return Container();
          },
        ),
      );
    });
  });

  group('ResolvedStyle lerp null handling', () {
    test('handles null specs without crashing', () {
      final style1 = const ResolvedStyle<BoxSpec>(spec: null);
      final style2 = const ResolvedStyle<BoxSpec>(spec: BoxSpec());
      
      // Should not throw when lerping with null specs
      final result = style1.lerp(style2, 0.5);
      expect(result.spec, equals(style2.spec)); // Uses step function, t >= 0.5
      
      final result2 = style1.lerp(style2, 0.3);
      expect(result2.spec, equals(style1.spec)); // Uses step function, t < 0.5
    });

    test('interpolates properly when both specs exist', () {
      final spec1 = const BoxSpec(
        alignment: Alignment.topLeft,
      );
      final spec2 = const BoxSpec(
        alignment: Alignment.bottomRight,
      );
      
      final style1 = ResolvedStyle<BoxSpec>(spec: spec1);
      final style2 = ResolvedStyle<BoxSpec>(spec: spec2);
      
      final result = style1.lerp(style2, 0.5);
      
      // Should have interpolated the alignment
      expect(result.spec, isNotNull);
      expect(result.spec!.alignment, equals(Alignment.center));
    });
  });
}