import 'package:flutter_test/flutter_test.dart';
import 'package:mix_tailwinds/src/tw_utils.dart';

void main() {
  group('findFirstColonOutsideBrackets', () {
    test('returns index of first colon with no brackets', () {
      expect(findFirstColonOutsideBrackets('md:flex'), 2);
      expect(findFirstColonOutsideBrackets('hover:bg-blue'), 5);
    });

    test('returns index of first colon with multiple colons', () {
      expect(findFirstColonOutsideBrackets('md:hover:flex'), 2);
      expect(findFirstColonOutsideBrackets('sm:md:lg:flex'), 2);
    });

    test('returns -1 when colon is inside brackets', () {
      expect(findFirstColonOutsideBrackets('bg-[color:red]'), -1);
      expect(findFirstColonOutsideBrackets('text-[rgba(0,0,0:0.5)]'), -1);
    });

    test('returns first colon outside brackets when mixed', () {
      expect(findFirstColonOutsideBrackets('md:bg-[color:red]'), 2);
      expect(findFirstColonOutsideBrackets('hover:text-[rgba(0:0:0:1)]'), 5);
    });

    test('returns -1 for no colons', () {
      expect(findFirstColonOutsideBrackets('flex'), -1);
      expect(findFirstColonOutsideBrackets('bg-blue-500'), -1);
    });

    test('returns -1 for malformed brackets (unclosed)', () {
      expect(findFirstColonOutsideBrackets('bg-[color:red'), -1);
      expect(findFirstColonOutsideBrackets('md:bg-[color'), -1);
    });

    test('returns -1 for malformed brackets (extra closing)', () {
      expect(findFirstColonOutsideBrackets('bg-color:red]'), -1);
      expect(findFirstColonOutsideBrackets('md:]bg-red'), -1);
    });

    test('handles nested brackets', () {
      // Nested brackets are unusual but should work
      expect(findFirstColonOutsideBrackets('md:bg-[[color:red]]'), 2);
    });

    test('handles empty string', () {
      expect(findFirstColonOutsideBrackets(''), -1);
    });

    test('handles colon at start', () {
      expect(findFirstColonOutsideBrackets(':flex'), 0);
    });
  });

  group('findLastColonOutsideBrackets', () {
    test('returns index of last colon with no brackets', () {
      expect(findLastColonOutsideBrackets('md:flex'), 2);
      expect(findLastColonOutsideBrackets('hover:bg-blue'), 5);
    });

    test('returns index of last colon with multiple colons', () {
      expect(findLastColonOutsideBrackets('md:hover:flex'), 8);
      expect(findLastColonOutsideBrackets('sm:md:lg:flex'), 8);
    });

    test('returns -1 when colon is inside brackets', () {
      expect(findLastColonOutsideBrackets('bg-[color:red]'), -1);
      expect(findLastColonOutsideBrackets('text-[rgba(0,0,0:0.5)]'), -1);
    });

    test('returns last colon outside brackets when mixed', () {
      expect(findLastColonOutsideBrackets('md:bg-[color:red]'), 2);
      expect(findLastColonOutsideBrackets('md:hover:bg-[color:red]'), 8);
      expect(findLastColonOutsideBrackets('hover:text-[rgba(0:0:0:1)]'), 5);
    });

    test('returns -1 for no colons', () {
      expect(findLastColonOutsideBrackets('flex'), -1);
      expect(findLastColonOutsideBrackets('bg-blue-500'), -1);
    });

    test('returns -1 for malformed brackets (unclosed)', () {
      expect(findLastColonOutsideBrackets('bg-[color:red'), -1);
      expect(findLastColonOutsideBrackets('md:bg-[color'), -1);
    });

    test('returns -1 for malformed brackets (extra closing)', () {
      expect(findLastColonOutsideBrackets('bg-color:red]'), -1);
      expect(findLastColonOutsideBrackets('md:]bg-red'), -1);
    });

    test('handles empty string', () {
      expect(findLastColonOutsideBrackets(''), -1);
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
