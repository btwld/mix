import 'package:flutter_test/flutter_test.dart';
import 'package:mix/parsers/parsers.dart';

void main() {
  group('DurationParser', () {
    const parser = DurationParser.instance;

    group('encode', () {
      test('encodes duration as milliseconds', () {
        expect(parser.encode(const Duration(seconds: 1)), equals(1000));
        expect(parser.encode(const Duration(minutes: 1)), equals(60000));
        expect(parser.encode(const Duration(hours: 1, minutes: 30)), equals(5400000));
        expect(parser.encode(null), isNull);
      });
    });

    group('decode', () {
      test('decodes from milliseconds', () {
        expect(parser.decode(1000), equals(const Duration(seconds: 1)));
        expect(parser.decode(60000), equals(const Duration(minutes: 1)));
        expect(parser.decode(0), equals(Duration.zero));
      });

      test('decodes from map with units', () {
        expect(
          parser.decode({'seconds': 30}),
          equals(const Duration(seconds: 30)),
        );
        
        expect(
          parser.decode({
            'hours': 1,
            'minutes': 30,
            'seconds': 45,
          }),
          equals(const Duration(hours: 1, minutes: 30, seconds: 45)),
        );
      });

      test('returns null for invalid input', () {
        expect(parser.decode(null), isNull);
        expect(parser.decode('invalid'), isNull);
        expect(parser.decode([]), isNull);
      });
    });

    group('tryDecode', () {
      test('returns ParseSuccess for valid input', () {
        final result = parser.tryDecode(5000);
        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, equals(const Duration(milliseconds: 5000)));
      });

      test('returns ParseError for invalid input', () {
        final result = parser.tryDecode('invalid');
        expect(result.isError, isTrue);
      });
    });
  });
}
