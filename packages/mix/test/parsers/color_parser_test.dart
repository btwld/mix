import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/parsers/parsers.dart';

void main() {
  group('ColorParser', () {
    const parser = ColorParser.instance;

    group('encode', () {
      test('encodes color as int value', () {
        expect(parser.encode(Colors.red), equals(0xFFFF0000));
        expect(parser.encode(Colors.blue), equals(0xFF2196F3));
        expect(parser.encode(null), isNull);
      });
    });

    group('decode', () {
      test('decodes from int value', () {
        expect(parser.decode(0xFFFF0000), equals(const Color(0xFFFF0000)));
        expect(parser.decode(0xFF2196F3), equals(const Color(0xFF2196F3)));
      });

      test('decodes from hex string', () {
        expect(parser.decode('#FF0000'), equals(const Color(0xFFFF0000)));
        expect(parser.decode('#FFFF0000'), equals(const Color(0xFFFF0000)));
        expect(parser.decode('FF0000'), equals(const Color(0xFFFF0000)));
      });

      test('returns null for invalid input', () {
        expect(parser.decode(null), isNull);
        expect(parser.decode('invalid'), isNull);
        expect(parser.decode({}), isNull);
      });
    });

    group('tryDecode', () {
      test('returns ParseSuccess for valid input', () {
        final result = parser.tryDecode('#FF0000');
        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, equals(const Color(0xFFFF0000)));
      });

      test('returns ParseError for invalid input', () {
        final result = parser.tryDecode('invalid');
        expect(result.isError, isTrue);
        expect(result, isA<ParseError>());
      });
    });
  });
}
