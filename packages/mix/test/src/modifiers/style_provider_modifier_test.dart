import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('StyleProviderModifier', () {
    test('can create modifier with widget spec', () {
      const widgetSpec = BoxWidgetSpec();

      const modifier = StyleProviderModifier(widgetSpec);

      expect(modifier.spec, equals(widgetSpec));
    });

    test('builds WidgetSpecProvider widget', () {
      const widgetSpec = BoxWidgetSpec();

      const modifier = StyleProviderModifier(widgetSpec);
      final child = Container();
      final result = modifier.build(child);

      expect(result, isA<WidgetSpecProvider<BoxWidgetSpec>>());
      expect((result as WidgetSpecProvider).spec, equals(widgetSpec));
    });

    test('lerp interpolates when both specs are present', () {
      final spec1 = const BoxWidgetSpec(alignment: Alignment.topLeft);

      final spec2 = const BoxWidgetSpec(alignment: Alignment.bottomRight);

      final modifier1 = StyleProviderModifier<BoxWidgetSpec>(spec1);

      final modifier2 = StyleProviderModifier<BoxWidgetSpec>(spec2);

      final result = modifier1.lerp(modifier2, 0.5);

      // The lerped spec should be different from both originals
      expect(result.spec, isNot(equals(spec1)));
      expect(result.spec, isNot(equals(spec2)));
    });

    test('lerp interpolates properly when both specs exist', () {
      final spec1 = const BoxWidgetSpec(alignment: Alignment.topLeft);
      final spec2 = const BoxWidgetSpec(alignment: Alignment.bottomRight);

      // Now specs have lerp built-in
      final style1 = spec1;
      final style2 = spec2;

      final result = style1.lerp(style2, 0.5);

      // Should have interpolated the alignment
      expect(result, isNotNull);
      expect(result.alignment, equals(Alignment.center));
    });
  });

  group('StyleProviderModifierMix', () {
    testWidgets('resolves style using context', (tester) async {
      final style = BoxStyle(
        alignment: Alignment.center,
        padding: EdgeInsetsGeometryMix.all(16),
      );

      final mix = StyleProviderModifierMix(style);

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final resolved = mix.resolve(context);

            expect(resolved, isA<StyleProviderModifier<BoxWidgetSpec>>());
            expect(resolved.spec, isNotNull);
            expect(resolved.spec.alignment, equals(Alignment.center));

            return Container();
          },
        ),
      );
    });

    test('merges styles correctly', () {
      final style1 = BoxStyle(alignment: Alignment.topLeft);

      final style2 = BoxStyle(padding: EdgeInsetsGeometryMix.all(8));

      final mix1 = StyleProviderModifierMix(style1);
      final mix2 = StyleProviderModifierMix(style2);

      final merged = mix1.merge(mix2);

      // The merged style should contain both alignment and padding
      // We can verify this by checking that it's a BoxMix with both properties
      expect(merged.style, isA<BoxStyle>());
      final boxMix = merged.style as BoxStyle;
      expect(boxMix.$alignment, isNotNull);
      expect(boxMix.$padding, isNotNull);
    });

    test('handles null merge correctly', () {
      final style = BoxStyle(alignment: Alignment.center);

      final mix = StyleProviderModifierMix(style);
      final merged = mix.merge(null);

      expect(merged, equals(mix));
    });

    testWidgets('handles empty style resolution', (tester) async {
      // Create an empty style
      final emptyStyle = BoxStyle();
      final mix = StyleProviderModifierMix(emptyStyle);

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final resolved = mix.resolve(context);

            // Should still create a valid modifier even with empty style
            expect(resolved, isA<StyleProviderModifier<BoxWidgetSpec>>());
            // The spec might be null or have all null properties
            expect(resolved.spec, isNotNull);

            return Container();
          },
        ),
      );
    });
  });
}
