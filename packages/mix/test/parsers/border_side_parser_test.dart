import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/parsers/parsers.dart';

void main() {
  group('BorderSideParser', () {
    const parser = BorderSideParser.instance;

    group('decode', () {
      test('decodes "none" as BorderSide.none', () {
        expect(parser.decode('none'), equals(BorderSide.none));
      });

      test('decodes number as BorderSide with width', () {
        final result = parser.decode(2.5);
        expect(result?.width, equals(2.5));
        expect(result?.color, equals(const Color(0xFF000000))); // default color
        expect(result?.style, equals(BorderStyle.solid)); // default style
      });

      test('decodes map with color (int)', () {
        final result = parser.decode({
          'color': 0xFFFF0000,
          'width': 3.0,
          'style': 'solid',
        });
        
        expect(result?.color, equals(const Color(0xFFFF0000)));
        expect(result?.width, equals(3.0));
        expect(result?.style, equals(BorderStyle.solid));
      });

      test('decodes map with color (hex string)', () {
        final result = parser.decode({
          'color': '#FF0000',
          'width': 2.0,
          'style': 'dashed',
        });
        
        expect(result?.color, equals(const Color(0xFFFF0000)));
        expect(result?.width, equals(2.0));
        expect(result?.style, equals(BorderStyle.none)); // dashed doesn't exist, falls back to default
      });

      test('decodes map with valid BorderStyle', () {
        final result = parser.decode({
          'color': 0xFF0000FF,
          'width': 1.5,
          'style': 'none',
        });
        
        expect(result?.color, equals(const Color(0xFF0000FF)));
        expect(result?.width, equals(1.5));
        expect(result?.style, equals(BorderStyle.none));
      });

      test('uses defaults for missing values', () {
        final result = parser.decode({
          'width': 4.0,
        });
        
        expect(result?.color, equals(const Color(0xFF000000))); // default
        expect(result?.width, equals(4.0));
        expect(result?.style, equals(BorderStyle.solid)); // default
      });

      test('returns null for invalid input', () {
        expect(parser.decode(null), isNull);
        expect(parser.decode('invalid'), isNull);
        expect(parser.decode([1, 2, 3]), isNull);
      });
    });

    group('encode', () {
      test('encodes BorderSide.none as "none"', () {
        expect(parser.encode(BorderSide.none), equals('none'));
      });

      test('encodes simple BorderSide with default color/style as width', () {
        const borderSide = BorderSide(width: 2.5);
        expect(parser.encode(borderSide), equals(2.5));
      });

      test('encodes custom BorderSide as map', () {
        const borderSide = BorderSide(
          color: Color(0xFFFF0000),
          width: 3.0,
          style: BorderStyle.solid,
        );
        
        final result = parser.encode(borderSide) as Map<String, Object?>;
        expect(result['color'], equals(0xFFFF0000));
        expect(result['width'], equals(3.0));
        expect(result['style'], equals('solid'));
      });

      test('encodes null as null', () {
        expect(parser.encode(null), isNull);
      });
    });

    group('tryDecode', () {
      test('returns ParseSuccess for valid input', () {
        final result = parser.tryDecode(2.0);
        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.width, equals(2.0));
      });

      test('returns ParseError for invalid input', () {
        final result = parser.tryDecode('invalid');
        expect(result.isError, isTrue);
        expect(result, isA<ParseError>());
      });
    });
  });
}
