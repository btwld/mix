import 'dart:convert';

import 'package:mix_protocol/mix_protocol.dart';

/// One authored-document drift finding.
final class MixFigmaDriftDifference {
  final String path;

  final String message;
  const MixFigmaDriftDifference({required this.path, required this.message});

  Map<String, Object?> toJson() => {'path': path, 'message': message};
}

/// Deterministic authored-document drift report.
final class MixFigmaDriftReport {
  final List<MixFigmaDriftDifference> differences;

  final String _kind;
  MixFigmaDriftReport({
    required String kind,
    required Iterable<MixFigmaDriftDifference> differences,
  }) : _kind = kind,
       differences = List.unmodifiable(differences);

  bool get isClean => differences.isEmpty;

  Map<String, Object?> toJson() => {
    'schema': 'mix_figma/drift/v1',
    'kind': _kind,
    'status': isClean ? 'clean' : 'drift',
    'differences': differences.map((item) => item.toJson()).toList(),
  };
}

/// Compares authored token declarations, including alias chains.
MixFigmaDriftReport compareThemeDocuments(Object? expected, Object? actual) {
  final left = _themeInspection(expected);
  final right = _themeInspection(actual);
  final leftByKey = {
    for (final token in left.tokens) '${token.kind}/${token.name}': token,
  };
  final rightByKey = {
    for (final token in right.tokens) '${token.kind}/${token.name}': token,
  };
  final keys = {...leftByKey.keys, ...rightByKey.keys}.toList()..sort();
  final differences = <MixFigmaDriftDifference>[];
  for (final key in keys) {
    final expectedToken = leftByKey[key];
    final actualToken = rightByKey[key];
    final path = expectedToken?.jsonPointer ?? actualToken!.jsonPointer;
    if (expectedToken == null || actualToken == null) {
      differences.add(
        MixFigmaDriftDifference(
          path: path,
          message: expectedToken == null
              ? 'Token declaration was added.'
              : 'Token declaration was removed.',
        ),
      );
      continue;
    }
    final expectedProjection = _tokenProjection(expectedToken);
    final actualProjection = _tokenProjection(actualToken);
    if (_canonical(expectedProjection) != _canonical(actualProjection)) {
      differences.add(
        MixFigmaDriftDifference(
          path: path,
          message: 'Token declaration, alias chain, or resolved value changed.',
        ),
      );
    }
  }

  return MixFigmaDriftReport(kind: 'theme', differences: differences);
}

/// Compares strict style inspection evidence instead of materialized objects.
MixFigmaDriftReport compareStyleDocuments(Object? expected, Object? actual) {
  final left = _styleInspection(expected);
  final right = _styleInspection(actual);
  final leftProjection = left.evidence.map(_styleEvidenceProjection).toList();
  final rightProjection = right.evidence.map(_styleEvidenceProjection).toList();

  return MixFigmaDriftReport(
    kind: 'style',
    differences: _canonical(leftProjection) == _canonical(rightProjection)
        ? const []
        : const [
            MixFigmaDriftDifference(
              path: '',
              message: 'Declared style evidence changed.',
            ),
          ],
  );
}

MixProtocolThemeInspection _themeInspection(Object? document) {
  return switch (inspectThemeDocument(document)) {
    MixProtocolSuccess<MixProtocolThemeInspection>(:final value) => value,
    MixProtocolFailure<MixProtocolThemeInspection>(:final errors) =>
      throw FormatException('Invalid protocol theme: $errors'),
  };
}

MixProtocolStyleInspection _styleInspection(Object? document) {
  return switch (inspectStyleDocument(document)) {
    MixProtocolSuccess<MixProtocolStyleInspection>(:final value) => value,
    MixProtocolFailure<MixProtocolStyleInspection>(:final errors) =>
      throw FormatException('Invalid protocol style: $errors'),
  };
}

Map<String, Object?> _tokenProjection(MixProtocolThemeTokenInspection token) =>
    {
      'declaration': token.declaration.name,
      'declared': token.declaredWireValue,
      'aliasChain': token.aliasChain,
      'resolved': token.resolvedWireValue,
    };

Map<String, Object?> _styleEvidenceProjection(MixProtocolStyleEvidence item) {
  return switch (item) {
    MixProtocolValueEvidence() => {
      'kind': 'value',
      'path': item.jsonPointer,
      'property': item.property,
      'mergePath': item.mergePath,
      'literal': item.literalValue,
      if (item.token != null)
        'token': {'kind': item.token!.kind, 'name': item.token!.name},
    },
    MixProtocolDirectiveEvidence() => {
      'kind': 'directive',
      'path': item.jsonPointer,
      'property': item.property,
      'mergePath': item.mergePath,
      'op': item.op,
      'parameters': item.parameters,
    },
    MixProtocolSelectorEvidence() => {
      'kind': 'selector',
      'path': item.jsonPointer,
      'mergePath': item.mergePath,
      'selector': item.selector.key,
      'tokens': [
        for (final token in item.tokenOccurrences)
          {'kind': token.kind, 'name': token.name},
      ],
    },
  };
}

String _canonical(Object value) => jsonEncode(_sort(value));

Object? _sort(Object? value) {
  if (value is List) return value.map(_sort).toList();
  if (value is Map) {
    final keys = value.keys.cast<String>().toList()..sort();

    return {for (final key in keys) key: _sort(value[key])};
  }

  return value;
}
