import 'package:mix_generator/src/core/curated/flag_descriptions.dart';
import 'package:test/test.dart';

void main() {
  group('Flag Descriptions', () {
    group('flagPropertyDescriptions', () {
      test('softWrap has correct description', () {
        expect(
          flagPropertyDescriptions['softWrap'],
          equals('wrapping at word boundaries'),
        );
      });

      test('excludeFromSemantics has correct description', () {
        expect(
          flagPropertyDescriptions['excludeFromSemantics'],
          equals('excluded from semantics'),
        );
      });

      test('gaplessPlayback has correct description', () {
        expect(
          flagPropertyDescriptions['gaplessPlayback'],
          equals('gapless playback'),
        );
      });

      test('isAntiAlias has correct description', () {
        expect(flagPropertyDescriptions['isAntiAlias'], equals('anti-aliased'));
      });

      test('matchTextDirection has correct description', () {
        expect(
          flagPropertyDescriptions['matchTextDirection'],
          equals('matches text direction'),
        );
      });

      test('applyTextScaling has correct description', () {
        expect(
          flagPropertyDescriptions['applyTextScaling'],
          equals('scales with text'),
        );
      });
    });

    group('getFlagDescription', () {
      test('returns description for known field', () {
        expect(
          getFlagDescription('softWrap'),
          equals('wrapping at word boundaries'),
        );
      });

      test('returns null for unknown field', () {
        expect(getFlagDescription('unknownField'), isNull);
      });
    });
  });
}
