import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_component_contract/mix_component_contract.dart';
import 'package:mix_figma/src/core/conformance/conformance_manifest.dart';
import 'package:mix_figma/src/core/figma/figma_node_document.dart';
import 'package:mix_figma/src/core/figma/figma_styles_parser.dart';
import 'package:mix_figma/src/core/figma/figma_variables_parser.dart';
import 'package:mix_figma/src/core/protocol_json/theme_from_figma_styles.dart';
import 'package:mix_figma/src/core/protocol_json/theme_from_figma_variables.dart';
import 'package:mix_figma/src/core/protocol_json/component_set_payload.dart';
import 'package:mix_figma/src/core/protocol_json/style_from_figma_node.dart';

void main() {
  test('shared conformance manifest has unique, resolvable cases', () {
    const manifestPath = 'test/fixtures/conformance/manifest.json';
    final manifest = parseMixFigmaConformanceManifest(
      (jsonDecode(File(manifestPath).readAsStringSync())! as Map).cast(),
    );
    final ids = manifest.cases.map((item) => item.id).toList();

    expect(ids.toSet(), hasLength(ids.length));
    expect(
      manifest.cases.map((item) => item.kind).toSet(),
      containsAll(['variables', 'styles', 'selection', 'component']),
    );
    for (final item in manifest.cases) {
      final source = File(
        Uri.file(manifestPath).resolve(item.source).toFilePath(),
      );
      expect(source.existsSync(), isTrue, reason: '${item.id}: ${item.source}');
    }
  });

  test('fidelity expectations account for every source item', () {
    final manifest = parseMixFigmaConformanceManifest(
      (jsonDecode(
                File(
                  'test/fixtures/conformance/manifest.json',
                ).readAsStringSync(),
              )!
              as Map)
          .cast(),
    );

    for (final item in manifest.cases.where(
      (item) => item.expected.containsKey('sourceItems'),
    )) {
      final sourceItems = item.expected['sourceItems']! as int;
      final native = (item.expected['nativeFidelity']! as Map).values
          .cast<int>()
          .fold(0, (total, count) => total + count);
      final roundTrip = (item.expected['roundTripFidelity']! as Map).values
          .cast<int>()
          .fold(0, (total, count) => total + count);

      expect(native, sourceItems, reason: '${item.id} native fidelity');
      expect(roundTrip, sourceItems, reason: '${item.id} round-trip fidelity');
      expect(item.expected['diagnosticCodes'], isNotEmpty);
    }
  });

  test('variable and style mappings match the conformance expectations', () {
    final manifest = _manifest();
    final variablesCase = manifest.cases.singleWhere(
      (item) => item.kind == 'variables',
    );
    final variableResult = buildProtocolThemeJsonFromFigmaVariables(
      parseFigmaVariablesDocument(_caseJson(variablesCase)),
      modeId: 'mode-light',
    );
    _expectCoverage(
      variableResult.coverage.toJson(),
      variableResult.diagnostics.map((item) => item.code),
      variablesCase.expected,
    );

    final stylesCase = manifest.cases.singleWhere(
      (item) => item.kind == 'styles',
    );
    final styleResult = buildProtocolThemeJsonFromFigmaStyles(
      parseFigmaStylesDocument(_caseJson(stylesCase)),
    );
    _expectCoverage(
      styleResult.coverage.toJson(),
      styleResult.diagnostics.map((item) => item.code),
      stylesCase.expected,
    );
  });

  test('selection and Button/Input/Card component cases are executable', () {
    final manifest = _manifest();
    for (final item in manifest.cases.where(
      (item) => item.kind == 'selection',
    )) {
      final result = buildProtocolStyleJsonFromNode(
        parseFigmaNodeDocument(_caseJson(item)).root,
      );
      expect(
        result.value['type'],
        item.expected['protocolType'],
        reason: item.id,
      );
    }

    final componentIds = <String>{};
    for (final item in manifest.cases.where(
      (item) => item.kind == 'component',
    )) {
      final path = _casePath(item);
      final component = parsePortableComponentDocument(
        Uint8List.fromList(File(path).readAsBytesSync()),
        path: path,
      );
      componentIds.add(component.id);
      final payload = buildComponentSetPayload(component).value;
      expect(
        (payload['variants']! as List).length,
        greaterThanOrEqualTo(item.expected['minimumVariants']! as int),
        reason: item.id,
      );
    }
    expect(componentIds, containsAll(['button', 'input', 'card']));
  });
}

MixFigmaConformanceManifest _manifest() => parseMixFigmaConformanceManifest(
  (jsonDecode(
            File('test/fixtures/conformance/manifest.json').readAsStringSync(),
          )!
          as Map)
      .cast(),
);

Map<String, Object?> _caseJson(MixFigmaConformanceCase item) {
  final path = _casePath(item);

  return (jsonDecode(File(path).readAsStringSync())! as Map).cast();
}

String _casePath(MixFigmaConformanceCase item) {
  const manifestPath = 'test/fixtures/conformance/manifest.json';

  return Uri.file(manifestPath).resolve(item.source).toFilePath();
}

void _expectCoverage(
  Map<String, Object?> actual,
  Iterable<String> diagnosticCodes,
  Map<String, Object?> expected,
) {
  expect(actual['supported'], expected['supported']);
  expect(actual['unsupported'], expected['unsupported']);
  final fidelity = actual['fidelity']! as Map;
  expect(fidelity['native'], expected['nativeFidelity']);
  expect(fidelity['roundTrip'], expected['roundTripFidelity']);
  expect(
    diagnosticCodes.toSet(),
    (expected['diagnosticCodes']! as List).cast<String>().toSet(),
  );
}
