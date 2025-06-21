import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/parsers/parsers.dart';

void main() {
  group('EdgeInsetsParser', () {
    const parser = EdgeInsetsParser.instance;

    group('encode', () {
      test('encodes EdgeInsets.all as single value', () {
        expect(parser.encode(const EdgeInsets.all(16)), equals(16.0));
      });

      test('encodes EdgeInsets.symmetric as array', () {
        expect(
          parser.encode(const EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
          equals([8.0, 16.0]),
        );
      });

      test('encodes EdgeInsets.fromLTRB as array', () {
        expect(
          parser.encode(const EdgeInsets.fromLTRB(1, 2, 3, 4)),
          equals([1.0, 2.0, 3.0, 4.0]),
        );
      });

      test('encodes EdgeInsetsDirectional as map', () {
        expect(
          parser.encode(const EdgeInsetsDirectional.fromSTEB(1, 2, 3, 4)),
          equals({'start': 1.0, 'top': 2.0, 'end': 3.0, 'bottom': 4.0}),
        );
      });

      test('encodes null as null', () {
        expect(parser.encode(null), isNull);
      });
    });

    group('decode', () {
      test('decodes single number as EdgeInsets.all', () {
        expect(parser.decode(16), equals(const EdgeInsets.all(16)));
        expect(parser.decode(16.0), equals(const EdgeInsets.all(16)));
      });

      test('decodes 2-element array as symmetric', () {
        expect(
          parser.decode([8, 16]),
          equals(const EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
        );
      });

      test('decodes 4-element array as fromLTRB', () {
        expect(
          parser.decode([1, 2, 3, 4]),
          equals(const EdgeInsets.fromLTRB(1, 2, 3, 4)),
        );
      });

      test('decodes map with start/end as EdgeInsetsDirectional', () {
        expect(
          parser.decode({'start': 1, 'top': 2, 'end': 3, 'bottom': 4}),
          equals(const EdgeInsetsDirectional.fromSTEB(1, 2, 3, 4)),
        );
      });

      test('returns null for invalid input', () {
        expect(parser.decode(null), isNull);
        expect(parser.decode('invalid'), isNull);
        expect(parser.decode([1, 2, 3]), isNull); // Wrong array length
      });
    });

    group('tryDecode', () {
      test('returns ParseSuccess for valid input', () {
        final result = parser.tryDecode(16);
        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, equals(const EdgeInsets.all(16)));
      });

      test('returns ParseError for invalid input', () {
        final result = parser.tryDecode([1, 2, 3]); // Invalid array length
        expect(result.isError, isTrue);
      });
    });
  });
}
