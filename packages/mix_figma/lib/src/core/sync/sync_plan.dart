import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../diagnostics/mix_figma_diagnostic.dart';
import '../json_map.dart';

enum MixFigmaSyncDirection { figmaToMix, mixToFigma }

enum MixFigmaSyncResource { tokens, selection, component }

enum MixFigmaSyncAction { create, update, rename, delete, unchanged, skip }

/// One deterministic change shown before a bridge operation is applied.
final class MixFigmaSyncOperation {
  final MixFigmaSyncAction action;
  final String kind;
  final String ref;
  final String? sourceId;
  final String name;
  final String path;
  final bool destructive;
  final List<String> changes;
  final List<MixFigmaDiagnostic> diagnostics;
  const MixFigmaSyncOperation({
    required this.action,
    required this.kind,
    required this.ref,
    this.sourceId,
    required this.name,
    this.path = '',
    this.destructive = false,
    this.changes = const [],
    this.diagnostics = const [],
  });

  JsonMap toJson() => {
    'action': action.name,
    'kind': kind,
    'ref': ref,
    'sourceId': ?sourceId,
    'name': name,
    'path': path,
    'destructive': destructive,
    'changes': changes,
    'diagnostics': diagnostics.map((item) => item.toJson()).toList(),
  };
}

/// Counts for a sync preview and its diagnostics.
final class MixFigmaSyncSummary {
  final int errors;
  final int warnings;
  final Map<MixFigmaSyncAction, int> _actions;
  MixFigmaSyncSummary._({
    required Map<MixFigmaSyncAction, int> actions,
    required this.errors,
    required this.warnings,
  }) : _actions = Map.unmodifiable(actions);

  int count(MixFigmaSyncAction action) => _actions[action] ?? 0;

  JsonMap toJson() => {
    for (final action in MixFigmaSyncAction.values) action.name: count(action),
    'errors': errors,
    'warnings': warnings,
  };
}

/// Stable Analyze result consumed by the bridge and plugin preview UI.
final class MixFigmaSyncPlan {
  final String id;
  final MixFigmaSyncDirection direction;
  final MixFigmaSyncResource resource;
  final String sourceFingerprint;
  final String desiredFingerprint;
  final List<MixFigmaSyncOperation> operations;
  final List<MixFigmaDiagnostic> diagnostics;
  final MixFigmaSyncSummary summary;

  MixFigmaSyncPlan._({
    required this.id,
    required this.direction,
    required this.resource,
    required this.sourceFingerprint,
    required this.desiredFingerprint,
    required Iterable<MixFigmaSyncOperation> operations,
    required Iterable<MixFigmaDiagnostic> diagnostics,
  }) : operations = List.unmodifiable(operations),
       diagnostics = List.unmodifiable(diagnostics),
       summary = _summary(operations, diagnostics);

  factory MixFigmaSyncPlan.create({
    required MixFigmaSyncDirection direction,
    required MixFigmaSyncResource resource,
    required Object? current,
    required Object? desired,
    required Iterable<MixFigmaSyncOperation> operations,
    Iterable<MixFigmaDiagnostic> diagnostics = const [],
  }) {
    final orderedOperations = operations.toList()..sort(_compareOperations);
    final orderedDiagnostics = diagnostics.toList()..sort(_compareDiagnostics);
    final sourceFingerprint = mixFigmaFingerprint(current);
    final desiredFingerprint = mixFigmaFingerprint(desired);
    final id = mixFigmaFingerprint({
      'direction': direction.name,
      'resource': resource.name,
      'sourceFingerprint': sourceFingerprint,
      'desiredFingerprint': desiredFingerprint,
      'operations': orderedOperations.map((item) => item.toJson()).toList(),
      'diagnostics': orderedDiagnostics.map((item) => item.toJson()).toList(),
    });

    return MixFigmaSyncPlan._(
      id: id,
      direction: direction,
      resource: resource,
      sourceFingerprint: sourceFingerprint,
      desiredFingerprint: desiredFingerprint,
      operations: orderedOperations,
      diagnostics: orderedDiagnostics,
    );
  }

  bool get hasErrors => summary.errors > 0;

  List<MixFigmaSyncOperation> operationsForApply({
    required bool allowDeletes,
  }) => .unmodifiable(
    operations.where((item) => allowDeletes || !item.destructive),
  );

  JsonMap toJson() => {
    'schema': 'mix_figma/sync-plan/v1',
    'version': 1,
    'id': id,
    'direction': direction.name,
    'resource': resource.name,
    'sourceFingerprint': sourceFingerprint,
    'desiredFingerprint': desiredFingerprint,
    'summary': summary.toJson(),
    'operations': operations.map((item) => item.toJson()).toList(),
    'diagnostics': diagnostics.map((item) => item.toJson()).toList(),
  };
}

String mixFigmaFingerprint(Object? value) =>
    sha256.convert(utf8.encode(jsonEncode(_canonical(value)))).toString();

MixFigmaSyncSummary _summary(
  Iterable<MixFigmaSyncOperation> operations,
  Iterable<MixFigmaDiagnostic> diagnostics,
) {
  final actions = {for (final action in MixFigmaSyncAction.values) action: 0};
  final allDiagnostics = <MixFigmaDiagnostic>[...diagnostics];
  for (final operation in operations) {
    actions[operation.action] = actions[operation.action]! + 1;
    allDiagnostics.addAll(operation.diagnostics);
  }

  return MixFigmaSyncSummary._(
    actions: actions,
    errors: allDiagnostics.where((item) => item.severity == .error).length,
    warnings: allDiagnostics.where((item) => item.severity == .warning).length,
  );
}

int _compareOperations(
  MixFigmaSyncOperation left,
  MixFigmaSyncOperation right,
) {
  final kind = left.kind.compareTo(right.kind);
  if (kind != 0) return kind;
  final reference = left.ref.compareTo(right.ref);
  if (reference != 0) return reference;

  return left.action.index.compareTo(right.action.index);
}

int _compareDiagnostics(MixFigmaDiagnostic left, MixFigmaDiagnostic right) {
  final path = left.path.compareTo(right.path);

  return path != 0 ? path : left.code.compareTo(right.code);
}

Object? _canonical(Object? value) {
  if (value is List) return value.map(_canonical).toList();
  if (value is Map) {
    final keys = value.keys.map((key) => key.toString()).toList()..sort();

    return {for (final key in keys) key: _canonical(value[key])};
  }

  return value;
}
