import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

void main() {
  group('TwResolver.resolveToken', () {
    test('parses variants and important flag', () {
      final parsed = TwResolver(
        TwConfig.standard(),
      ).resolveToken('md:hover:!bg-blue-500');

      expect(parsed, isNotNull);
      expect(parsed, hasLength(1));

      final result = parsed!.single;
      expect(result.property, TwProperty.backgroundColor);
      expect(
        result.value,
        TwColorValue(TwConfig.standard().colorOf('blue-500')!),
      );
      expect(result.important, isTrue);
      expect(result.negative, isFalse);
      expect(result.arbitrary, isFalse);
      expect(result.variants, hasLength(2));
      expect(result.variantKey, 'md:hover');
      expect(result.variants[0], const TwBreakpointVariant('md', 768));
      expect(result.variants[1], const TwInteractionVariant('hover'));
    });

    test('parses negative spacing values', () {
      final parsed = TwResolver(TwConfig.standard()).resolveToken('-m-4');

      expect(parsed, isNotNull);
      expect(parsed, hasLength(1));

      final result = parsed!.single;
      expect(result.property, TwProperty.margin);
      expect(result.value, const TwLengthValue(-16));
      expect(result.negative, isTrue);
    });

    test('rejects unsupported negative tokens', () {
      final parsed = TwResolver(
        TwConfig.standard(),
      ).resolveToken('-bg-blue-500');
      expect(parsed, isNull);
    });

    test('parses arbitrary rem length and marks arbitrary', () {
      final parsed = TwResolver(TwConfig.standard()).resolveToken('w-[10rem]');

      expect(parsed, isNotNull);
      final result = parsed!.single;
      expect(result.property, TwProperty.width);
      expect(result.value, const TwLengthValue(160, TwUnit.px));
      expect(result.arbitrary, isTrue);
    });

    test('parses arbitrary percent length', () {
      final parsed = TwResolver(TwConfig.standard()).resolveToken('w-[50%]');

      expect(parsed, isNotNull);
      final result = parsed!.single;
      expect(result.property, TwProperty.width);
      expect(result.value, const TwLengthValue(50, TwUnit.percent));
    });

    test('rejects 3-digit arbitrary hex colors', () {
      final parsed = TwResolver(TwConfig.standard()).resolveToken('bg-[#fff]');
      expect(parsed, isNull);
    });

    test('parses 8-digit arbitrary hex colors', () {
      final parsed = TwResolver(
        TwConfig.standard(),
      ).resolveToken('bg-[#80ffffff]');

      expect(parsed, isNotNull);
      final result = parsed!.single;
      expect(result.property, TwProperty.backgroundColor);
      expect(result.value, const TwColorValue(Color(0x80FFFFFF)));
    });

    test('reports unknown variants while parsing valid base token', () {
      final unknown = <String>[];
      final parsed = TwResolver(
        TwConfig.standard(),
        onUnknownVariant: unknown.add,
      ).resolveToken('foo:bg-blue-500');

      expect(parsed, isNotNull);
      expect(parsed, hasLength(1));
      expect(unknown, contains('foo'));
      expect(parsed!.single.property, TwProperty.backgroundColor);
      expect(parsed.single.variants, isEmpty);
    });
  });

  group('TwParsedClass', () {
    test('builds stable variant keys', () {
      const parsed = TwParsedClass(
        property: TwProperty.marginTop,
        value: TwLengthValue(8),
        variants: [
          TwBreakpointVariant('lg', 1024),
          TwInteractionVariant('hover'),
        ],
      );

      expect(parsed.variantKey, 'lg:hover');
    });
  });

  group('Semantic value types', () {
    test('TwFractionValue computes decimal value', () {
      const value = TwFractionValue(2, 3);
      expect(value.value, closeTo(0.666666, 0.000001));
      expect(value, const TwFractionValue(2, 3));
    });

    test('TwMatrixValue stores matrix', () {
      final matrix = Matrix4.identity()..setTranslationRaw(4.0, 8.0, 0.0);
      final value = TwMatrixValue(matrix);

      expect(value.matrix, same(matrix));
      expect(value.toString(), contains('TwMatrixValue'));
    });

    test('TwGradientValue stores direction and colors', () {
      const value = TwGradientValue(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.red, Colors.blue],
      );

      expect(value.begin, Alignment.topLeft);
      expect(value.end, Alignment.bottomRight);
      expect(value.colors, const [Colors.red, Colors.blue]);
    });
  });
}
