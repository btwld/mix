import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/dtcg/dtcg_parser.dart';
import 'package:mix_figma/src/core/dtcg/dtcg_writer.dart';
import 'package:mix_figma/src/core/protocol_json/theme_from_dtcg.dart';

void main() {
  group('DTCG 2025.10', () {
    test('parser and writer preserve aliases and extensions', () {
      final input = _json('dtcg/light.tokens.json');
      final document = parseDtcgDocument(input);

      expect(document.extensions['com.btwld.mix'], {'mode': 'light'});
      expect(
        document.tokens['color.brand.accent']!.value,
        '{color.brand.primary}',
      );
      expect(document.tokens['space.stack.sm']!.mixGroup, 'spaces');
      expect(writeDtcgDocument(document), input);
    });

    test('maps every protocol theme group to the canonical golden', () {
      final document = parseDtcgDocument(_json('dtcg/light.tokens.json'));
      final result = buildProtocolThemeJsonFromDtcg(document);

      expect(result.diagnostics, isEmpty);
      expect(result.value, _json('theme_docs/light.theme.json'));
      expect(result.value.keys.toList(), [
        'v',
        'type',
        'colors',
        'spaces',
        'doubles',
        'radii',
        'textStyles',
        'shadows',
        'boxShadows',
        'borders',
        'fontWeights',
        'breakpoints',
        'durations',
      ]);
    });
  });
}

Map<String, Object?> _json(String path) =>
    jsonDecode(File('test/fixtures/$path').readAsStringSync())
        as Map<String, Object?>;
