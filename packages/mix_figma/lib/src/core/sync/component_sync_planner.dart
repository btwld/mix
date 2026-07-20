import '../diagnostics/mix_figma_diagnostic.dart';
import '../json_map.dart';
import 'sync_plan.dart';

const mixFigmaPayloadFingerprintKey = 'mix_figma.payloadFingerprint';
const _identityKey = 'mix_figma.id';
const _kindKey = 'mix_figma.kind';
const _protocolVersionKey = 'mix_figma.protocolVersion';

/// Adds stable identity and content fingerprints used for component read-back.
JsonMap addComponentSyncMetadata(JsonMap payload) {
  if (payload['schema'] != 'mix_figma/component-set-write/v1' ||
      payload['version'] != 1) {
    throw const FormatException('Expected a component-set write payload.');
  }
  final ref = jsonString(payload['ref'], path: '/ref');
  final identity = _objectOrEmpty(payload['identity']);
  final protocolVersion = identity['protocolVersion'] is num
      ? (identity['protocolVersion']! as num).round()
      : 1;
  final variants = <Object?>[];
  final rawVariants = jsonList(payload['variants'], path: '/variants');
  for (final raw in rawVariants) {
    final variant = jsonObject(raw, path: '/variants');
    final variantRef = jsonString(variant['ref'], path: '/variants/ref');
    final root = jsonObject(
      variant['root'],
      path: '/variants/$variantRef/root',
    );
    final fingerprint = mixFigmaFingerprint({
      'properties': variant['properties'],
      'root': _withoutSyncMetadata(root),
    });
    variants.add({
      ...variant,
      'root': {
        ...root,
        'pluginData': {
          ..._objectOrEmpty(root['pluginData']),
          _identityKey: '$ref.$variantRef',
          _kindKey: 'component',
          _protocolVersionKey: '$protocolVersion',
          mixFigmaPayloadFingerprintKey: fingerprint,
        },
      },
    });
  }
  final contentPayload = <String, Object?>{...payload}..remove('sourceId');
  final contentFingerprint = mixFigmaFingerprint({
    ...contentPayload,
    'pluginData': _withoutSyncKeys(_objectOrEmpty(payload['pluginData'])),
    'variants': [
      for (final raw in variants)
        _variantWithoutSyncMetadata((raw! as Map).cast()),
    ],
  });

  return {
    ...payload,
    'pluginData': {
      ..._objectOrEmpty(payload['pluginData']),
      _identityKey: ref,
      _kindKey: 'componentSet',
      _protocolVersionKey: '$protocolVersion',
      mixFigmaPayloadFingerprintKey: contentFingerprint,
    },
    'variants': variants,
  };
}

/// Compares a values-bearing component-set snapshot with a desired payload.
MixFigmaSyncPlan buildComponentPushSyncPlan({
  required JsonMap current,
  required JsonMap desired,
  Iterable<MixFigmaDiagnostic> diagnostics = const [],
}) {
  final ref = jsonString(desired['ref'], path: '/ref');
  final name = jsonString(desired['name'], path: '/name');
  final rawSet = current['componentSet'];
  final currentSet = rawSet == null
      ? null
      : jsonObject(rawSet, path: '/componentSet');
  final sourceId = desired['sourceId'] is String
      ? desired['sourceId']! as String
      : null;
  final ownedSet =
      currentSet != null &&
      (_string(currentSet['id']) == sourceId ||
          _pluginIdentity(currentSet) == ref);
  final operations = <MixFigmaSyncOperation>[];

  if (currentSet != null && !ownedSet) {
    operations.add(
      _preserved(
        kind: 'componentSet',
        ref: _string(currentSet['id']),
        sourceId: _string(currentSet['id']),
        name: _string(currentSet['name']),
        path: '/componentSet',
      ),
    );
  }
  if (!ownedSet) {
    operations.add(
      MixFigmaSyncOperation(
        action: .create,
        kind: 'componentSet',
        ref: ref,
        name: name,
        path: '/componentSet',
        changes: const ['componentSet'],
      ),
    );
  } else {
    final desiredPluginData = _objectOrEmpty(desired['pluginData']);
    final desiredFingerprint = jsonString(
      desiredPluginData[mixFigmaPayloadFingerprintKey],
      path: '/pluginData/$mixFigmaPayloadFingerprintKey',
    );
    final setName = _string(currentSet['name']);
    final fingerprint = _pluginData(currentSet)[mixFigmaPayloadFingerprintKey];
    final changes = <String>[
      if (setName != name) 'name',
      if (fingerprint != desiredFingerprint) 'content',
    ];
    operations.add(
      MixFigmaSyncOperation(
        action: changes.length == 1 && changes.single == 'name'
            ? .rename
            : (changes.isEmpty ? .unchanged : .update),
        kind: 'componentSet',
        ref: ref,
        sourceId: _string(currentSet['id']),
        name: name,
        path: '/componentSet',
        changes: changes,
      ),
    );
  }

  final currentVariants = ownedSet
      ? _objects(currentSet['variants'], path: '/componentSet/variants')
      : const <JsonMap>[];
  final desiredVariants = _objects(desired['variants'], path: '/variants');
  final matchedIds = <String>{};
  for (final variant in desiredVariants) {
    final variantRef = _string(variant['ref']);
    final root = jsonObject(
      variant['root'],
      path: '/variants/$variantRef/root',
    );
    final identity = '$ref.$variantRef';
    final rootPluginData = _objectOrEmpty(root['pluginData']);
    final fingerprint = jsonString(
      rootPluginData[mixFigmaPayloadFingerprintKey],
      path:
          '/variants/$variantRef/root/pluginData/$mixFigmaPayloadFingerprintKey',
    );
    final variantName = _variantName(
      jsonObject(
        variant['properties'],
        path: '/variants/$variantRef/properties',
      ),
    );
    final existing = _firstWhereOrNull(
      currentVariants,
      (item) => _pluginIdentity(item) == identity,
    );
    if (existing == null) {
      operations.add(
        MixFigmaSyncOperation(
          action: .create,
          kind: 'componentVariant',
          ref: variantRef,
          name: variantName,
          path: '/componentSet/variants/$variantRef',
          changes: const ['componentVariant'],
        ),
      );
      continue;
    }
    final existingId = _string(existing['id']);
    matchedIds.add(existingId);
    final existingPluginData = _pluginData(existing);
    final changes = <String>[
      if (_string(existing['name']) != variantName) 'name',
      if (existingPluginData[mixFigmaPayloadFingerprintKey] != fingerprint)
        'content',
    ];
    operations.add(
      MixFigmaSyncOperation(
        action: changes.length == 1 && changes.single == 'name'
            ? .rename
            : (changes.isEmpty ? .unchanged : .update),
        kind: 'componentVariant',
        ref: variantRef,
        sourceId: existingId,
        name: variantName,
        path: '/componentSet/variants/$variantRef',
        changes: changes,
      ),
    );
  }
  for (final variant in currentVariants) {
    final id = _string(variant['id']);
    if (matchedIds.contains(id)) continue;
    final identity = _pluginIdentity(variant);
    operations.add(
      identity != null && identity.startsWith('$ref.')
          ? MixFigmaSyncOperation(
              action: .delete,
              kind: 'componentVariant',
              ref: identity.substring(ref.length + 1),
              sourceId: id,
              name: _string(variant['name']),
              path: '/componentSet/variants/$identity',
              destructive: true,
              changes: const ['delete'],
            )
          : _preserved(
              kind: 'componentVariant',
              ref: id,
              sourceId: id,
              name: _string(variant['name']),
              path: '/componentSet/variants/$id',
            ),
    );
  }

  return MixFigmaSyncPlan.create(
    direction: .mixToFigma,
    resource: .component,
    current: current,
    desired: desired,
    operations: operations,
    diagnostics: diagnostics,
  );
}

MixFigmaSyncOperation _preserved({
  required String kind,
  required String ref,
  required String sourceId,
  required String name,
  required String path,
}) => .new(
  action: .skip,
  kind: kind,
  ref: ref,
  sourceId: sourceId,
  name: name,
  path: path,
  diagnostics: [
    MixFigmaDiagnostic(
      code: 'unmanaged_resource_preserved',
      severity: .info,
      path: path,
      message: 'Unowned Figma resource "$name" will not be changed or deleted.',
    ),
  ],
);

JsonMap _variantWithoutSyncMetadata(JsonMap variant) {
  final root = jsonObject(variant['root'], path: '/variant/root');

  return {...variant, 'root': _withoutSyncMetadata(root)};
}

JsonMap _withoutSyncMetadata(JsonMap value) => {
  ...value,
  if (value['pluginData'] != null)
    'pluginData': _withoutSyncKeys(_objectOrEmpty(value['pluginData'])),
};

JsonMap _withoutSyncKeys(JsonMap value) => {
  for (final entry in value.entries)
    if (entry.key != _identityKey &&
        entry.key != _kindKey &&
        entry.key != _protocolVersionKey &&
        entry.key != mixFigmaPayloadFingerprintKey)
      entry.key: entry.value,
};

String _variantName(JsonMap properties) {
  final entries = properties.entries.toList()
    ..sort((left, right) => left.key.compareTo(right.key));
  if (entries.isEmpty) return 'Variant=Default';

  return entries
      .map(
        (entry) =>
            '${entry.key}=${entry.value is bool ? (entry.value == true ? 'True' : 'False') : entry.value}',
      )
      .join(', ');
}

String? _pluginIdentity(JsonMap value) =>
    _pluginData(value)[_identityKey] is String
    ? _pluginData(value)[_identityKey]! as String
    : null;

JsonMap _pluginData(JsonMap value) => _objectOrEmpty(value['pluginData']);

JsonMap _objectOrEmpty(Object? value) => value is Map ? value.cast() : {};

List<JsonMap> _objects(Object? value, {required String path}) => jsonList(
  value ?? const <Object?>[],
  path: path,
).map((item) => jsonObject(item, path: path)).toList(growable: false);

String _string(Object? value) {
  if (value is! String) throw const FormatException('Expected a string.');

  return value;
}

T? _firstWhereOrNull<T>(Iterable<T> values, bool Function(T) test) {
  for (final value in values) {
    if (test(value)) return value;
  }

  return null;
}
