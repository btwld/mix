import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

void main() {
  test('public barrel keeps semantic compatibility symbols', () {
    const length = TwLengthValue(4);
    const color = TwColorValue(Color(0xFF112233));
    const parsed = TwParsedClass(
      property: TwProperty.padding,
      value: length,
      variants: [TwInteractionVariant('hover')],
    );

    expect(length.unit, TwUnit.px);
    expect(color.color, const Color(0xFF112233));
    expect(parsed.variantKey, 'hover');
    expect(functionalPlugins, contains('p'));
    expect(namedPlugins, contains('flex'));
    expect(gradientDirections, contains('to-r'));
    expect(tailwindLineHeights, contains('base'));
    expect(preflightLineHeight, 1.5);
    expect(kTailwindBoxShadowPresets['shadow-md'], isA<List<BoxShadowMix>>());
  });
}
