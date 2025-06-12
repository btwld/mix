import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('TextStyleDto', () {
    test('from constructor sets all values correctly', () {
      final attr =
          TextStyleDto(color: Colors.red.toDto(), fontVariations: const []);
      final result = attr.resolve(EmptyMixData);
      expect(result.color, Colors.red);
    });
    test('merge returns merged object correctly', () {
      final attr1 = TextStyleDto(
        color: Colors.red.toDto(),
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        letterSpacing: 1.0,
        wordSpacing: 2.0,
        fontVariations: const [
          FontVariation('wght', 900),
        ],
        textBaseline: TextBaseline.ideographic,
        decoration: TextDecoration.underline,
        decorationColor: Colors.blue.toDto(),
        decorationStyle: TextDecorationStyle.dashed,
        height: 2.0,
      );

      final attr2 = TextStyleDto(
        color: Colors.blue.toDto(),
        fontSize: 30.0,
        fontWeight: FontWeight.w100,
        fontStyle: FontStyle.normal,
        letterSpacing: 2.0,
        wordSpacing: 3.0,
        fontVariations: const [
          FontVariation('wght', 400),
        ],
        textBaseline: TextBaseline.alphabetic,
        decoration: TextDecoration.lineThrough,
        decorationColor: Colors.red.toDto(),
        decorationStyle: TextDecorationStyle.dotted,
        height: 3.0,
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
      final attr = TextStyleDto(
        color: Colors.red.toDto(),
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        letterSpacing: 1.0,
        wordSpacing: 2.0,
        fontVariations: const [
          FontVariation('wght', 900),
        ],
        textBaseline: TextBaseline.ideographic,
        decoration: TextDecoration.underline,
        decorationColor: Colors.blue.toDto(),
        decorationStyle: TextDecorationStyle.dashed,
        height: 2.0,
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
      final attr1 =
          TextStyleDto(color: Colors.red.toDto(), fontVariations: const []);
      final attr2 =
          TextStyleDto(color: Colors.red.toDto(), fontVariations: const []);
      expect(attr1, attr2);
    });
    test('Equality fails when attributes are different', () {
      final attr1 =
          TextStyleDto(color: Colors.red.toDto(), fontVariations: const []);
      final attr2 =
          TextStyleDto(color: Colors.blue.toDto(), fontVariations: const []);
      expect(attr1, isNot(attr2));
    });
  });
  test('TextStyleDto.ref creates a TextStyleDto with a TextStyleDataRef', () {
    const token = TextStyleToken('test_token');
    final attr = TextStyleDto.ref(token);
    expect(attr.value.length, 1);
    expect(attr.value.first, isA<TextStyleDataRef>());
    expect((attr.value.first as TextStyleDataRef).ref.token, token);
  });

  test('TextStyleExt toDto method converts TextStyle to TextStyleDto correctly',
      () {
    const style = TextStyle(
      color: Colors.blue,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    );
    final attr = style.toDto();
    expect(attr.value.length, 1);
    expect(attr.value.first.color?.value, Colors.blue);
    expect(attr.value.first.fontSize, 18.0);
    expect(attr.value.first.fontWeight, FontWeight.bold);
  });

  test('TextStyleExt toDto method handles TextStyleRef correctly', () {
    const token = TextStyleToken('test_token');
    const style = TextStyleRef(token);
    final attr = style.toDto();
    expect(attr, isA<TextStyleDto>());
    expect(attr.value.length, 1);
    expect(attr.value.first, isA<TextStyleDataRef>());
    expect((attr.value.first as TextStyleDataRef).ref.token, token);
  });

  testWidgets('TextStyleDto.token resolves using unified resolver system',
      (tester) async {
    const testToken = MixToken<TextStyle>('test-text-style');

    await tester.pumpWithMixTheme(
      Container(),
      theme: MixThemeData.unified(
        tokens: {
          testToken: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        },
      ),
    );

    final buildContext = tester.element(find.byType(Container));
    final mockMixData = MixData.create(buildContext, Style());

    final textStyleDto = TextStyleDto.token(testToken);
    final resolvedValue = textStyleDto.resolve(mockMixData);

    expect(resolvedValue, isA<TextStyle>());
    expect(resolvedValue.fontSize, 24);
    expect(resolvedValue.fontWeight, FontWeight.bold);
    expect(resolvedValue.color, Colors.blue);
  });
}
