import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('TextStyleDto', () {
    test('from constructor sets all values correctly', () {
      final attr = TextStyleDto(
        color: Colors.red.toDto(),
        fontVariations: const [],
      );
      final result = attr.resolve(EmptyMixData);
      expect(result.color, Colors.red);
    });
    test('merge returns merged object correctly', () {
      const attr1 = TextStyleDto(
        color: Mixable.value(Colors.red),
        fontSize: Mixable.value(24.0),
        fontWeight: Mixable.value(FontWeight.bold),
        fontStyle: Mixable.value(FontStyle.italic),
        letterSpacing: Mixable.value(1.0),
        wordSpacing: Mixable.value(2.0),
        fontVariations: [FontVariation('wght', 900)],
        textBaseline: Mixable.value(TextBaseline.ideographic),
        decoration: Mixable.value(TextDecoration.underline),
        decorationColor: Mixable.value(Colors.blue),
        decorationStyle: Mixable.value(TextDecorationStyle.dashed),
        height: Mixable.value(2.0),
      );

      const attr2 = TextStyleDto(
        color: Mixable.value(Colors.blue),
        fontSize: Mixable.value(30.0),
        fontWeight: Mixable.value(FontWeight.w100),
        fontStyle: Mixable.value(FontStyle.normal),
        letterSpacing: Mixable.value(2.0),
        wordSpacing: Mixable.value(3.0),
        fontVariations: [FontVariation('wght', 400)],
        textBaseline: Mixable.value(TextBaseline.alphabetic),
        decoration: Mixable.value(TextDecoration.lineThrough),
        decorationColor: Mixable.value(Colors.red),
        decorationStyle: Mixable.value(TextDecorationStyle.dotted),
        height: Mixable.value(3.0),
      );

      final merged = attr1.merge(attr2).resolve(EmptyMixData);

      expect(merged.color, Colors.blue);
      expect(merged.fontSize, 30.0);
      expect(merged.decoration, TextDecoration.lineThrough);
      expect(merged.decorationColor, Colors.red);
      expect(merged.decorationStyle, TextDecorationStyle.dotted);
      expect(merged.fontWeight, FontWeight.w100);
      expect(merged.fontStyle, FontStyle.normal);
      expect(merged.fontVariations, [const FontVariation('wght', 400)]);
      expect(merged.letterSpacing, 2.0);
      expect(merged.wordSpacing, 3.0);
      expect(merged.height, 3.0);
      expect(merged.textBaseline, TextBaseline.alphabetic);
    });
    test('resolve returns correct TextStyle with specific values', () {
      const attr = TextStyleDto(
        color: Mixable.value(Colors.red),
        fontSize: Mixable.value(24.0),
        fontWeight: Mixable.value(FontWeight.bold),
        fontStyle: Mixable.value(FontStyle.italic),
        letterSpacing: Mixable.value(1.0),
        wordSpacing: Mixable.value(2.0),
        fontVariations: [FontVariation('wght', 900)],
        textBaseline: Mixable.value(TextBaseline.ideographic),
        decoration: Mixable.value(TextDecoration.underline),
        decorationColor: Mixable.value(Colors.blue),
        decorationStyle: Mixable.value(TextDecorationStyle.dashed),
        height: Mixable.value(2.0),
      );
      final textStyle = attr.resolve(EmptyMixData);
      expect(textStyle.color, Colors.red);
      expect(textStyle.fontSize, 24.0);
      expect(textStyle.decoration, TextDecoration.underline);
      expect(textStyle.decorationColor, Colors.blue);
      expect(textStyle.decorationStyle, TextDecorationStyle.dashed);
      expect(textStyle.fontWeight, FontWeight.bold);
      expect(textStyle.fontStyle, FontStyle.italic);
      expect(textStyle.fontVariations, [const FontVariation('wght', 900)]);
      expect(textStyle.letterSpacing, 1.0);
      expect(textStyle.wordSpacing, 2.0);
      expect(textStyle.height, 2.0);
      expect(textStyle.textBaseline, TextBaseline.ideographic);

      return const Placeholder();
    });
    test('Equality holds when all attributes are the same', () {
      const attr1 = TextStyleDto(
        color: Mixable.value(Colors.red),
        fontVariations: [],
      );
      const attr2 = TextStyleDto(
        color: Mixable.value(Colors.red),
        fontVariations: [],
      );
      expect(attr1, attr2);
    });
    test('Equality fails when attributes are different', () {
      const attr1 = TextStyleDto(
        color: Mixable.value(Colors.red),
        fontVariations: [],
      );
      const attr2 = TextStyleDto(
        color: Mixable.value(Colors.blue),
        fontVariations: [],
      );
      expect(attr1, isNot(attr2));
    });
  });
  test('TextStyleDto.token creates a TextStyleDto with a token', () {
    const token = MixableToken<TextStyle>('test_token');
    const attr = TextStyleDto.token(token);
    expect((attr as TokenTextStyleDto).token, token);
  });

  test(
    'TextStyleExt toDto method converts TextStyle to TextStyleDto correctly',
    () {
      const style = TextStyle(
        color: Colors.blue,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      );
      final attr = style.toDto();
      expect(attr, isA<ValueTextStyleDto>());
      final valueDto = attr as ValueTextStyleDto;
      // Resolve the DTO to get actual values
      final resolved = valueDto.resolve(EmptyMixData);
      expect(resolved.color, Colors.blue);
      expect(resolved.fontSize, 18.0);
      expect(resolved.fontWeight, FontWeight.bold);
    },
  );

  testWidgets('TextStyleDto.token resolves using unified resolver system', (
    tester,
  ) async {
    const testToken = MixableToken<TextStyle>('test-text-style');

    await tester.pumpWidget(
      MaterialApp(
        home: MixScope(
          data: MixScopeData.static(
            tokens: {
              testToken: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            },
          ),
          child: Container(),
        ),
      ),
    );

    final buildContext = tester.element(find.byType(Container));
    final mockMixData = MixContext.create(buildContext, Style());

    const textStyleDto = TextStyleDto.token(testToken);
    final resolvedValue = textStyleDto.resolve(mockMixData);

    expect(resolvedValue, isA<TextStyle>());
    expect(resolvedValue.fontSize, 24);
    expect(resolvedValue.fontWeight, FontWeight.bold);
    expect(resolvedValue.color, Colors.blue);
  });
}
