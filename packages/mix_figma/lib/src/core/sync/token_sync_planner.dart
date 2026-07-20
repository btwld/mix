import 'dart:math' as math;

import '../diagnostics/mix_figma_diagnostic.dart';
import '../figma/figma_styles_document.dart';
import '../figma/figma_variables_document.dart';
import '../identity/mix_figma_lock.dart';
import '../json_map.dart';
import '../protocol_json/figma_style_payloads.dart';
import 'sync_plan.dart';

/// Compares Mix token write payloads with a values-bearing Figma snapshot.
MixFigmaSyncPlan buildTokenPushSyncPlan({
  required FigmaVariablesDocument currentVariables,
  required FigmaStylesDocument currentStyles,
  required JsonMap desiredVariables,
  required JsonMap desiredStyles,
  MixFigmaLock lock = .empty,
  Iterable<MixFigmaDiagnostic> diagnostics = const [],
}) {
  final operations = <MixFigmaSyncOperation>[];
  final collectionMatches = _planCollections(
    operations,
    currentVariables,
    desiredVariables,
    lock,
  );
  _planVariables(
    operations,
    currentVariables,
    desiredVariables,
    collectionMatches,
    lock,
  );
  _planStyles(operations, currentStyles, desiredStyles, lock);

  return MixFigmaSyncPlan.create(
    direction: .mixToFigma,
    resource: .tokens,
    current: _currentState(currentVariables, currentStyles),
    desired: {'variables': desiredVariables, 'styles': desiredStyles},
    operations: operations,
    diagnostics: diagnostics,
  );
}

Map<String, _CollectionMatch> _planCollections(
  List<MixFigmaSyncOperation> operations,
  FigmaVariablesDocument current,
  JsonMap desired,
  MixFigmaLock lock,
) {
  final matches = <String, _CollectionMatch>{};
  final desiredCollections = _objects(desired['collections']);
  final desiredRefs = <String>{};
  for (final payload in desiredCollections) {
    final ref = _string(payload['ref']);
    desiredRefs.add(ref);
    final name = _string(payload['name']);
    final identity = _identity(payload);
    final sourceId =
        _optionalString(payload['sourceId']) ?? lock.collectionIds[ref];
    final existing = _findManagedResource(
      current.collections,
      sourceId: sourceId,
      identity: identity,
      idOf: (item) => item.id,
      pluginDataOf: (item) => item.pluginData,
    );
    final modeMatches = <String, FigmaVariableMode?>{};
    if (existing == null) {
      operations.add(
        MixFigmaSyncOperation(
          action: .create,
          kind: 'collection',
          ref: ref,
          name: name,
          path: '/variables/collections/$ref',
          changes: const ['collection'],
        ),
      );
    } else if (existing.remote) {
      operations.add(
        MixFigmaSyncOperation(
          action: .skip,
          kind: 'collection',
          ref: ref,
          name: existing.name,
          path: '/variables/collections/$ref',
          diagnostics: [
            _diagnostic(
              code: 'remote_resource_not_writable',
              severity: .error,
              path: '/variables/collections/$ref',
              message:
                  'Remote Figma collection "${existing.name}" cannot be updated.',
            ),
          ],
        ),
      );
    } else {
      final changes = <String>[
        if (existing.name != name) 'name',
        if (payload['hiddenFromPublishing'] is bool &&
            existing.hiddenFromPublishing != payload['hiddenFromPublishing'])
          'hiddenFromPublishing',
      ];
      operations.add(
        MixFigmaSyncOperation(
          action: changes.contains('name') && changes.length == 1
              ? .rename
              : (changes.isEmpty ? .unchanged : .update),
          kind: 'collection',
          ref: ref,
          name: name,
          path: '/variables/collections/$ref',
          changes: changes,
        ),
      );
    }

    final desiredModes = _objects(payload['modes']);
    final matchedModeIds = <String>{};
    for (final mode in desiredModes) {
      final modeRef = _string(mode['ref']);
      final modeName = _string(mode['name']);
      final modeId =
          _optionalString(mode['sourceId']) ?? lock.modeIds[ref]?[modeRef];
      final existingMode = existing == null
          ? null
          : modeId == null
          ? _firstWhereOrNull(existing.modes, (item) => item.name == modeName)
          : _firstWhereOrNull(existing.modes, (item) => item.id == modeId);
      final missingLockedMode =
          existing != null && modeId != null && existingMode == null;
      modeMatches[modeRef] = existingMode;
      if (existingMode != null) matchedModeIds.add(existingMode.id);
      operations.add(
        MixFigmaSyncOperation(
          action: missingLockedMode
              ? .skip
              : existingMode == null
              ? .create
              : (existingMode.name == modeName ? .unchanged : .rename),
          kind: 'mode',
          ref: modeRef,
          name: modeName,
          path: '/variables/collections/$ref/modes/$modeRef',
          changes: existingMode == null
              ? (missingLockedMode ? const [] : const ['mode'])
              : (existingMode.name == modeName ? const [] : const ['name']),
          diagnostics: missingLockedMode
              ? [
                  _diagnostic(
                    code: 'managed_mode_not_found',
                    severity: .error,
                    path: '/variables/collections/$ref/modes/$modeRef',
                    message:
                        'Managed Figma mode "$modeId" is missing. Remove the '
                        'stale lock entry or restore the mode before applying.',
                  ),
                ]
              : const [],
        ),
      );
    }
    if (existing != null) {
      final managedModeIds = lock.modeIds[ref] ?? const {};
      for (final mode in existing.modes.where(
        (item) => !matchedModeIds.contains(item.id),
      )) {
        final managedRef = _keyForValue(managedModeIds, mode.id);
        operations.add(
          managedRef == null
              ? _preservedOperation(
                  kind: 'mode',
                  ref: mode.id,
                  name: mode.name,
                  path: '/variables/collections/$ref/modes/${mode.id}',
                )
              : MixFigmaSyncOperation(
                  action: .delete,
                  kind: 'mode',
                  ref: managedRef,
                  sourceId: mode.id,
                  name: mode.name,
                  path: '/variables/collections/$ref/modes/$managedRef',
                  destructive: true,
                  changes: const ['delete'],
                ),
        );
      }
    }
    matches[ref] = _CollectionMatch(existing, modeMatches);
  }

  for (final entry in lock.collectionIds.entries) {
    if (desiredRefs.contains(entry.key)) continue;
    final existing = _firstWhereOrNull(
      current.collections,
      (item) => item.id == entry.value,
    );
    if (existing == null) continue;
    operations.add(
      MixFigmaSyncOperation(
        action: .delete,
        kind: 'collection',
        ref: entry.key,
        sourceId: existing.id,
        name: existing.name,
        path: '/variables/collections/${entry.key}',
        destructive: true,
        changes: const ['delete'],
      ),
    );
  }

  return matches;
}

void _planVariables(
  List<MixFigmaSyncOperation> operations,
  FigmaVariablesDocument current,
  JsonMap desired,
  Map<String, _CollectionMatch> collectionMatches,
  MixFigmaLock lock,
) {
  final payloads = _objects(desired['variables']);
  final matches = <String, FigmaVariable?>{};
  final matchedIds = <String>{};
  for (final payload in payloads) {
    final ref = _string(payload['ref']);
    final identity = _identity(payload);
    final sourceId =
        _optionalString(payload['sourceId']) ?? lock.variableIds[ref];
    final existing = _findManagedResource(
      current.variables,
      sourceId: sourceId,
      identity: identity,
      idOf: (item) => item.id,
      pluginDataOf: (item) => item.pluginData,
    );
    matches[ref] = existing;
    if (existing != null) matchedIds.add(existing.id);
  }
  final currentIdentityById = <String, String>{};
  for (final entry in matches.entries) {
    final value = entry.value;
    if (value != null) currentIdentityById[value.id] = entry.key;
  }

  for (final payload in payloads) {
    final ref = _string(payload['ref']);
    final name = _string(payload['name']);
    final existing = matches[ref];
    if (existing == null) {
      operations.add(
        MixFigmaSyncOperation(
          action: .create,
          kind: 'variable',
          ref: ref,
          name: name,
          path: '/variables/variables/$ref',
          changes: const ['variable'],
        ),
      );
      continue;
    }
    if (existing.remote) {
      operations.add(
        MixFigmaSyncOperation(
          action: .skip,
          kind: 'variable',
          ref: ref,
          name: existing.name,
          path: '/variables/variables/$ref',
          diagnostics: [
            _diagnostic(
              code: 'remote_resource_not_writable',
              severity: .error,
              path: '/variables/variables/$ref',
              message:
                  'Remote Figma variable "${existing.name}" cannot be updated.',
            ),
          ],
        ),
      );
      continue;
    }
    final collectionRef = _string(payload['collectionRef']);
    final modeMatches = collectionMatches[collectionRef]?.modes ?? const {};
    final changes = <String>[
      if (existing.name != name) 'name',
      if (existing.resolvedType.name.toUpperCase() != payload['resolvedType'])
        'resolvedType',
      if (existing.description != (payload['description'] ?? '')) 'description',
      if (!_same(existing.scopes, payload['scopes'] ?? const [])) 'scopes',
      if (!_same(existing.codeSyntax, payload['codeSyntax'] ?? const {}))
        'codeSyntax',
      if (!_same(
        _currentValues(existing, modeMatches, currentIdentityById),
        _desiredValues(payload['valuesByMode']),
      ))
        'valuesByMode',
    ];
    operations.add(
      MixFigmaSyncOperation(
        action: changes.contains('name') && changes.length == 1
            ? .rename
            : (changes.isEmpty ? .unchanged : .update),
        kind: 'variable',
        ref: ref,
        name: name,
        path: '/variables/variables/$ref',
        changes: changes,
      ),
    );
  }

  final desiredCollectionIds = collectionMatches.values
      .map((item) => item.collection?.id)
      .whereType<String>()
      .toSet();
  for (final variable in current.variables.where(
    (item) =>
        desiredCollectionIds.contains(item.collectionId) &&
        !matchedIds.contains(item.id),
  )) {
    final managedRef = _managedIdentity(variable.pluginData);
    operations.add(
      managedRef == null
          ? _preservedOperation(
              kind: 'variable',
              ref: variable.id,
              name: variable.name,
              path: '/variables/variables/${variable.id}',
            )
          : MixFigmaSyncOperation(
              action: .delete,
              kind: 'variable',
              ref: managedRef,
              sourceId: variable.id,
              name: variable.name,
              path: '/variables/variables/$managedRef',
              destructive: true,
              changes: const ['delete'],
            ),
    );
  }
}

void _planStyles(
  List<MixFigmaSyncOperation> operations,
  FigmaStylesDocument current,
  JsonMap desired,
  MixFigmaLock lock,
) {
  final desiredDocument = figmaStylesDocumentFromWritePayload(desired);
  final payloads = <JsonMap>[
    ..._objects(desired['textStyles']),
    ..._objects(desired['effectStyles']),
    ..._objects(desired['paintStyles']),
  ];
  final desiredByRef = {
    for (final style in desiredDocument.styles) style.key: style,
  };
  final matchedIds = <String>{};
  for (final payload in payloads) {
    final ref = _string(payload['ref']);
    final name = _string(payload['name']);
    final identity = _identity(payload);
    final sourceId = _optionalString(payload['sourceId']) ?? lock.styleIds[ref];
    final existing = _findManagedResource(
      current.styles,
      sourceId: sourceId,
      identity: identity,
      idOf: (item) => item.id,
      pluginDataOf: (item) => item.pluginData,
    );
    final desiredStyle = desiredByRef[ref]!;
    final kind = _styleKind(desiredStyle.type);
    if (existing == null) {
      operations.add(
        MixFigmaSyncOperation(
          action: .create,
          kind: kind,
          ref: ref,
          name: name,
          path: '/styles/$ref',
          changes: const ['style'],
        ),
      );
      continue;
    }
    matchedIds.add(existing.id);
    if (existing.remote) {
      operations.add(
        MixFigmaSyncOperation(
          action: .skip,
          kind: kind,
          ref: ref,
          name: existing.name,
          path: '/styles/$ref',
          diagnostics: [
            _diagnostic(
              code: 'remote_resource_not_writable',
              severity: .error,
              path: '/styles/$ref',
              message:
                  'Remote Figma style "${existing.name}" cannot be updated.',
            ),
          ],
        ),
      );
      continue;
    }
    final changes = <String>[
      if (existing.name != name) 'name',
      if (existing.description != (payload['description'] ?? '')) 'description',
      if (!_sameControlledStyleValue(existing.value, desiredStyle.value))
        'value',
    ];
    operations.add(
      MixFigmaSyncOperation(
        action: changes.contains('name') && changes.length == 1
            ? .rename
            : (changes.isEmpty ? .unchanged : .update),
        kind: kind,
        ref: ref,
        name: name,
        path: '/styles/$ref',
        changes: changes,
      ),
    );
  }

  for (final style in current.styles.where(
    (item) => !matchedIds.contains(item.id),
  )) {
    final managedRef = _managedIdentity(style.pluginData);
    final kind = _styleKind(style.type);
    operations.add(
      managedRef == null
          ? _preservedOperation(
              kind: kind,
              ref: style.id,
              name: style.name,
              path: '/styles/${style.id}',
            )
          : MixFigmaSyncOperation(
              action: .delete,
              kind: kind,
              ref: managedRef,
              sourceId: style.id,
              name: style.name,
              path: '/styles/$managedRef',
              destructive: true,
              changes: const ['delete'],
            ),
    );
  }
}

JsonMap _currentValues(
  FigmaVariable variable,
  Map<String, FigmaVariableMode?> modeMatches,
  Map<String, String> identitiesById,
) {
  final modeRefsById = <String, String>{};
  for (final entry in modeMatches.entries) {
    final value = entry.value;
    if (value != null) modeRefsById[value.id] = entry.key;
  }

  return {
    for (final entry in variable.valuesByMode.entries)
      modeRefsById[entry.key] ?? entry.key: switch (entry.value) {
        FigmaVariableAlias(:final variableId) => {
          'type': 'VARIABLE_ALIAS',
          'ref': identitiesById[variableId] ?? variableId,
        },
        final value => value,
      },
  };
}

JsonMap _desiredValues(Object? value) => {
  for (final entry in jsonObject(value, path: '/valuesByMode').entries)
    entry.key: switch (entry.value) {
      final Map alias when alias['type'] == 'VARIABLE_ALIAS' => {
        'type': 'VARIABLE_ALIAS',
        'ref': alias['ref'] ?? alias['id'],
      },
      final value => value,
    },
};

JsonMap _currentState(
  FigmaVariablesDocument variables,
  FigmaStylesDocument styles,
) {
  final collections =
      variables.collections.map((item) => item.toJson()).toList()..sort(
        (left, right) => _string(left['id']).compareTo(_string(right['id'])),
      );
  final variableValues =
      variables.variables.map((item) => item.toJson()).toList()..sort(
        (left, right) => _string(left['id']).compareTo(_string(right['id'])),
      );
  final styleValues = styles.styles.map(_styleJson).toList()
    ..sort(
      (left, right) => _string(left['id']).compareTo(_string(right['id'])),
    );

  return {
    'variables': {'collections': collections, 'variables': variableValues},
    'styles': styleValues,
  };
}

JsonMap _styleJson(FigmaStyle style) => {
  'id': style.id,
  'key': style.key,
  'name': style.name,
  'type': style.type.name,
  'value': style.value,
  'pluginData': style.pluginData,
  'description': style.description,
  'remote': style.remote,
};

MixFigmaSyncOperation _preservedOperation({
  required String kind,
  required String ref,
  required String name,
  required String path,
}) => .new(
  action: .skip,
  kind: kind,
  ref: ref,
  name: name,
  path: path,
  diagnostics: [
    _diagnostic(
      code: 'unmanaged_resource_preserved',
      severity: .info,
      path: path,
      message: 'Unowned Figma resource "$name" will not be changed or deleted.',
    ),
  ],
);

MixFigmaDiagnostic _diagnostic({
  required String code,
  required MixFigmaDiagnosticSeverity severity,
  required String path,
  required String message,
}) => .new(code: code, severity: severity, path: path, message: message);

String _styleKind(FigmaStyleType type) => switch (type) {
  .text => 'textStyle',
  .effect => 'effectStyle',
  .paint => 'paintStyle',
};

String? _identity(JsonMap payload) {
  final identity = payload['identity'];

  return identity is Map && identity['id'] is String
      ? identity['id']! as String
      : null;
}

String? _managedIdentity(Map<String, Object?> pluginData) =>
    _optionalString(pluginData['mix_figma.id']) ??
    _optionalString(pluginData['mix.key']);

String? _keyForValue(Map<String, String> values, String value) {
  for (final entry in values.entries) {
    if (entry.value == value) return entry.key;
  }

  return null;
}

bool _same(Object? left, Object right) => _equivalent(left, right);

bool _equivalent(Object? left, Object? right) {
  if (identical(left, right)) return true;
  if (left is num && right is num) {
    final leftValue = left.toDouble();
    final rightValue = right.toDouble();
    if (!leftValue.isFinite || !rightValue.isFinite) {
      return leftValue == rightValue;
    }
    final scale = math.max(1.0, math.max(leftValue.abs(), rightValue.abs()));

    return (leftValue - rightValue).abs() <= 1e-7 * scale;
  }
  if (left is List && right is List) {
    if (left.length != right.length) return false;
    for (var index = 0; index < left.length; index++) {
      if (!_equivalent(left[index], right[index])) return false;
    }

    return true;
  }
  if (left is Map && right is Map) {
    if (left.length != right.length) return false;
    for (final entry in left.entries) {
      if (!right.containsKey(entry.key) ||
          !_equivalent(entry.value, right[entry.key])) {
        return false;
      }
    }

    return true;
  }

  return left == right;
}

bool _sameControlledStyleValue(JsonMap current, JsonMap desired) =>
    _same(_projectToDesiredShape(current, desired), desired);

Object? _projectToDesiredShape(Object? current, Object? desired) {
  if (desired is Map && current is Map) {
    return {
      for (final entry in desired.entries)
        entry.key: _projectToDesiredShape(current[entry.key], entry.value),
    };
  }
  if (desired is List && current is List) {
    if (current.length != desired.length) return current;

    return [
      for (var index = 0; index < desired.length; index++)
        _projectToDesiredShape(current[index], desired[index]),
    ];
  }

  return current;
}

T? _findManagedResource<T>(
  Iterable<T> resources, {
  required String? sourceId,
  required String? identity,
  required String Function(T resource) idOf,
  required Map<String, Object?> Function(T resource) pluginDataOf,
}) {
  if (identity == null) return null;
  final bySourceId = sourceId == null
      ? null
      : _firstWhereOrNull(resources, (item) => idOf(item) == sourceId);
  if (bySourceId != null &&
      _managedIdentity(pluginDataOf(bySourceId)) == identity) {
    return bySourceId;
  }

  return _firstWhereOrNull(
    resources,
    (item) => _managedIdentity(pluginDataOf(item)) == identity,
  );
}

List<JsonMap> _objects(Object? value) => jsonList(
  value ?? const <Object?>[],
  path: '/items',
).map((item) => jsonObject(item, path: '/items')).toList(growable: false);

String _string(Object? value) {
  if (value is! String) throw const FormatException('Expected a string.');

  return value;
}

String? _optionalString(Object? value) => value is String ? value : null;

T? _firstWhereOrNull<T>(Iterable<T> values, bool Function(T) test) {
  for (final value in values) {
    if (test(value)) return value;
  }

  return null;
}

final class _CollectionMatch {
  final FigmaVariableCollection? collection;
  final Map<String, FigmaVariableMode?> modes;
  const _CollectionMatch(this.collection, this.modes);
}
