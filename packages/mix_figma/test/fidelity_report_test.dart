import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/diagnostics/mix_figma_coverage_report.dart';
import 'package:mix_figma/src/core/figma/figma_styles_parser.dart';
import 'package:mix_figma/src/core/figma/figma_variables_parser.dart';
import 'package:mix_figma/src/core/protocol_json/theme_from_figma_styles.dart';
import 'package:mix_figma/src/core/protocol_json/theme_from_figma_variables.dart';

void main() {
  test('coverage JSON reports native and round-trip fidelity separately', () {
    final report = MixFigmaCoverageReport(
      items: [
        MixFigmaCoverageItem(
          id: 'color-brand',
          kind: 'variable',
          status: MixFigmaCoverageStatus.supported,
        ),
      ],
    );

    expect(report.toJson(), {
      'schema': 'mix_figma/coverage/v2',
      'supported': 1,
      'unsupported': 0,
      'fidelity': {
        'native': {'exact': 1},
        'roundTrip': {'exact': 1},
      },
      'items': [
        {
          'id': 'color-brand',
          'kind': 'variable',
          'status': 'supported',
          'nativeFidelity': 'exact',
          'roundTripFidelity': 'exact',
          'diagnostics': <Object?>[],
        },
      ],
    });
  });

  test(
    'variable coverage distinguishes normalization from unsupported input',
    () {
      final source = _json('test/fixtures/figma_variables/primitives.json');
      final result = buildProtocolThemeJsonFromFigmaVariables(
        parseFigmaVariablesDocument(source),
        modeId: 'mode-light',
      );
      final byId = {for (final item in result.coverage.items) item.id: item};

      expect(byId['ambiguous']?.nativeFidelity, MixFigmaFidelity.normalized);
      expect(byId['ambiguous']?.roundTripFidelity, MixFigmaFidelity.exact);
      expect(
        byId['unsupported-string']?.nativeFidelity,
        MixFigmaFidelity.unsupported,
      );
      expect(
        byId['unsupported-string']?.roundTripFidelity,
        MixFigmaFidelity.unsupported,
      );
    },
  );

  test('style coverage reports target and round-trip fidelity honestly', () {
    final result = buildProtocolThemeJsonFromFigmaStyles(
      parseFigmaStylesDocument(
        _json('test/fixtures/style_docs/figma_styles.json'),
      ),
    );
    final byId = {for (final item in result.coverage.items) item.id: item};

    expect(byId['text-body']?.nativeFidelity, MixFigmaFidelity.exact);
    expect(byId['effect-raised']?.roundTripFidelity, MixFigmaFidelity.exact);
    expect(byId['effect-inner']?.nativeFidelity, MixFigmaFidelity.unsupported);
    expect(byId['paint-brand']?.nativeFidelity, MixFigmaFidelity.normalized);
    expect(byId['paint-brand']?.roundTripFidelity, MixFigmaFidelity.lossy);
    expect(
      byId['paint-gradient']?.roundTripFidelity,
      MixFigmaFidelity.unsupported,
    );
  });
}

Map<String, Object?> _json(String path) =>
    (jsonDecode(File(path).readAsStringSync())! as Map).cast();
