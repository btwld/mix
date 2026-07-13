import 'package:flutter_test/flutter_test.dart';
import 'package:mix_tailwinds/src/tw_utils.dart';

void main() {
  group('splitTailwindTokens', () {
    test('splits whitespace-delimited class names', () {
      expect(splitTailwindTokens(' flex\n  md:hover:bg-red-500 '), [
        'flex',
        'md:hover:bg-red-500',
      ]);
    });

    test('returns an empty list for blank input', () {
      expect(splitTailwindTokens('  \n '), isEmpty);
    });
  });

  group('parseFractionToken', () {
    test('parses valid fractions', () {
      expect(parseFractionToken('1/2'), 0.5);
      expect(parseFractionToken('2/3'), closeTo(0.6667, 0.001));
      expect(parseFractionToken('3/4'), 0.75);
    });

    test('returns null for invalid fractions', () {
      expect(parseFractionToken('not-a-fraction'), isNull);
      expect(parseFractionToken('1/0'), isNull);
      expect(parseFractionToken('1/2/3'), isNull);
      expect(parseFractionToken(''), isNull);
    });
  });
}
