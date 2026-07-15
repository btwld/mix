import 'dart:convert';

import '../artifacts/capture_bundle.dart';
import '../index/capture_index.dart';

/// How one capture-backed record differs between two compatible revisions.
enum AtlasDeclaredChangeKind { added, removed, modified }

/// The evidence family represented by a declared capture change.
enum AtlasDeclaredChangeCategory {
  component,
  recipe,
  theme,
  slot,
  styleTerm,
  tokenDefinition,
  tokenReference,
  diagnostic,
  visualOracle,
}

/// One deterministic, contextual change between compatible captures.
final class AtlasDeclaredChange {
  final AtlasDeclaredChangeKind kind;

  final AtlasDeclaredChangeCategory category;
  final String id;
  final String? componentId;
  final String? recipeId;
  final String? selector;
  final String? themeId;
  final String? slotId;
  final String? property;
  final String? tokenKind;
  final String? tokenName;
  final String? sourcePath;
  final String? jsonPointer;
  final Object? baselineValue;
  final Object? currentValue;
  const AtlasDeclaredChange({
    required this.kind,
    required this.category,
    required this.id,
    this.componentId,
    this.recipeId,
    this.selector,
    this.themeId,
    this.slotId,
    this.property,
    this.tokenKind,
    this.tokenName,
    this.sourcePath,
    this.jsonPointer,
    this.baselineValue,
    this.currentValue,
  });

  Map<String, Object?> toJson() => {
    'kind': kind.name,
    'category': category.name,
    'id': id,
    'component': ?componentId,
    'recipe': ?recipeId,
    'selector': ?selector,
    'theme': ?themeId,
    'slot': ?slotId,
    'property': ?property,
    'tokenKind': ?tokenKind,
    'tokenName': ?tokenName,
    'source': ?sourcePath,
    'pointer': ?jsonPointer,
    if (kind != .added) 'baseline': baselineValue,
    if (kind != .removed) 'current': currentValue,
  };
}

/// Aggregated comparison of every bounded evidence family Atlas understands.
final class AtlasCaptureComparison {
  final AtlasCaptureCompatibility compatibility;

  final List<AtlasDeclaredChange> changes;

  AtlasCaptureComparison._({
    required this.compatibility,
    required List<AtlasDeclaredChange> changes,
  }) : changes = List.unmodifiable(changes);

  factory AtlasCaptureComparison.compare(
    LoadedCapture baseline,
    LoadedCapture current, {
    AtlasCaptureIndex? baselineIndex,
    AtlasCaptureIndex? currentIndex,
  }) {
    final compatibility = AtlasCaptureCompatibility.evaluate(baseline, current);
    if (!compatibility.isCompatible) {
      return AtlasCaptureComparison._(
        compatibility: compatibility,
        changes: const [],
      );
    }
    final beforeIndex = baselineIndex ?? AtlasCaptureIndex.build(baseline);
    final afterIndex = currentIndex ?? AtlasCaptureIndex.build(current);
    final changes = <AtlasDeclaredChange>[];
    _appendDiff(
      changes,
      _componentSnapshots(baseline),
      _componentSnapshots(current),
    );
    _appendDiff(changes, _recipeSnapshots(baseline), _recipeSnapshots(current));
    _appendDiff(changes, _themeSnapshots(baseline), _themeSnapshots(current));
    _appendDiff(changes, _slotSnapshots(baseline), _slotSnapshots(current));
    _appendDiff(
      changes,
      _styleTermSnapshots(beforeIndex),
      _styleTermSnapshots(afterIndex),
    );
    _appendDiff(
      changes,
      _tokenDefinitionSnapshots(beforeIndex),
      _tokenDefinitionSnapshots(afterIndex),
    );
    _appendDiff(
      changes,
      _tokenReferenceSnapshots(beforeIndex),
      _tokenReferenceSnapshots(afterIndex),
    );
    _appendDiff(
      changes,
      _diagnosticSnapshots(baseline),
      _diagnosticSnapshots(current),
    );
    _appendDiff(
      changes,
      _visualOracleSnapshots(baseline),
      _visualOracleSnapshots(current),
    );
    changes.sort(
      (left, right) => _changeKey(left).compareTo(_changeKey(right)),
    );

    return AtlasCaptureComparison._(
      compatibility: compatibility,
      changes: changes,
    );
  }

  bool get hasChanges => changes.isNotEmpty;

  int count({
    AtlasDeclaredChangeKind? kind,
    AtlasDeclaredChangeCategory? category,
  }) => changes.where((change) {
    if (kind != null && change.kind != kind) return false;
    if (category != null && change.category != category) return false;

    return true;
  }).length;

  String toCanonicalJson() =>
      jsonEncode(changes.map((change) => change.toJson()).toList());
}

final class _Snapshot {
  final AtlasDeclaredChangeCategory category;

  final String id;
  final Object? value;
  final String? componentId;
  final String? recipeId;
  final String? selector;
  final String? themeId;
  final String? slotId;
  final String? property;
  final String? tokenKind;
  final String? tokenName;
  final String? sourcePath;
  final String? jsonPointer;
  const _Snapshot({
    required this.category,
    required this.id,
    required this.value,
    this.componentId,
    this.recipeId,
    this.selector,
    this.themeId,
    this.slotId,
    this.property,
    this.tokenKind,
    this.tokenName,
    this.sourcePath,
    this.jsonPointer,
  });
}

Map<String, _Snapshot> _componentSnapshots(LoadedCapture capture) {
  final documents = {
    for (final component in capture.componentDocuments) component.id: component,
  };

  return {
    for (final catalogComponent in capture.catalog.components)
      catalogComponent.id: _Snapshot(
        category: .component,
        id: catalogComponent.id,
        value: {
          'label': catalogComponent.label,
          'portable': documents.containsKey(catalogComponent.id),
          if (documents[catalogComponent.id] case final component?) ...{
            'schema': component.schema.name,
            'semantics': {
              'role': component.semantics.role,
              'bindings': {
                for (final binding in component.semantics.bindings.entries)
                  binding.key: binding.value.toJson(),
              },
            },
          },
        },
        componentId: catalogComponent.id,
      ),
  };
}

Map<String, _Snapshot> _recipeSnapshots(LoadedCapture capture) => {
  for (final component in capture.componentDocuments)
    for (final recipe in component.recipes)
      '${component.id}|${recipe.id}': _Snapshot(
        category: .recipe,
        id: '${component.id} / ${recipe.id}',
        value: {
          'properties': recipe.properties,
          'styles': {
            for (final style in recipe.styles.entries)
              style.key: {
                'status': style.value.status.name,
                'evidence': style.value.evidence.name,
                if (style.value.documentPath != null)
                  'document': style.value.documentPath,
                if (style.value.styleId != null) 'style': style.value.styleId,
              },
          },
        },
        componentId: component.id,
        recipeId: recipe.id,
      ),
};

Map<String, _Snapshot> _themeSnapshots(LoadedCapture capture) => {
  for (final theme in capture.catalog.themes)
    theme.id: _Snapshot(
      category: .theme,
      id: theme.id,
      value: {'label': theme.label, 'brightness': theme.brightness},
      themeId: theme.id,
      sourcePath: capture.manifest.themes
          .where((entry) => entry.id == theme.id)
          .firstOrNull
          ?.documentPath,
    ),
};

Map<String, _Snapshot> _slotSnapshots(LoadedCapture capture) => {
  for (final component in capture.componentDocuments)
    for (final slot in component.slots.values)
      '${component.id}|${slot.id}': _Snapshot(
        category: .slot,
        id: '${component.id} / ${slot.id}',
        value: slot.kind.name,
        componentId: component.id,
        slotId: slot.id,
      ),
};

Map<String, _Snapshot> _styleTermSnapshots(AtlasCaptureIndex index) {
  final result = <String, _Snapshot>{};
  for (final evidence in index.propertyEvidence) {
    final key = [
      evidence.componentId,
      evidence.recipeId,
      evidence.selector,
      evidence.slotId,
      evidence.property,
      evidence.sourcePath,
      evidence.jsonPointer,
      evidence.mergeSource,
    ].join('|');
    result.putIfAbsent(
      key,
      () => _Snapshot(
        category: .styleTerm,
        id:
            '${evidence.componentId} / ${evidence.recipeId} / '
            '${evidence.slotId} · ${evidence.property} (${evidence.selector})',
        value: {
          'mergeSource': ?evidence.mergeSource,
          'literal': ?evidence.literalValue,
          'tokenKind': ?evidence.tokenKind,
          'tokenName': ?evidence.tokenName,
        },
        componentId: evidence.componentId,
        recipeId: evidence.recipeId,
        selector: evidence.selector,
        slotId: evidence.slotId,
        property: evidence.property,
        sourcePath: evidence.sourcePath,
        jsonPointer: evidence.jsonPointer,
      ),
    );
  }

  return result;
}

Map<String, _Snapshot> _tokenDefinitionSnapshots(AtlasCaptureIndex index) => {
  for (final definition in index.tokenDefinitions)
    '${definition.themeId}|${definition.kind}|${definition.name}': _Snapshot(
      category: .tokenDefinition,
      id: '${definition.themeId} · ${definition.kind}/${definition.name}',
      value: {
        'declaration': definition.declaration.name,
        'declaredValue': definition.declaredValue,
        'aliasChain': definition.aliasChain,
        'resolvedValue': definition.resolvedValue,
      },
      themeId: definition.themeId,
      tokenKind: definition.kind,
      tokenName: definition.name,
      sourcePath: definition.sourcePath,
      jsonPointer: definition.jsonPointer,
    ),
};

Map<String, _Snapshot> _tokenReferenceSnapshots(AtlasCaptureIndex index) => {
  for (final use in index.tokenUses)
    '${use.referenceId}|${use.themeId}': _Snapshot(
      category: .tokenReference,
      id:
          '${use.componentId} / ${use.recipeId} / ${use.slotId} · '
          '${use.property} → ${use.tokenKind}/${use.tokenName}',
      value: use.referenceType.name,
      componentId: use.componentId,
      recipeId: use.recipeId,
      selector: use.selector,
      themeId: use.themeId,
      slotId: use.slotId,
      property: use.property,
      tokenKind: use.tokenKind,
      tokenName: use.tokenName,
      sourcePath: use.sourcePath,
      jsonPointer: use.jsonPointer,
    ),
};

Map<String, _Snapshot> _diagnosticSnapshots(LoadedCapture capture) {
  final result = <String, _Snapshot>{};
  for (final item in capture.protocolCoverage.items) {
    for (final diagnostic in item.diagnostics) {
      final key = [
        'protocol',
        diagnostic.probeId,
        diagnostic.code,
        diagnostic.path,
        diagnostic.message,
      ].join('|');
      result[key] = _Snapshot(
        category: .diagnostic,
        id: '${diagnostic.probeId} · ${diagnostic.code}',
        value: {'severity': diagnostic.severity, 'message': diagnostic.message},
        sourcePath: capture.manifest.protocolCoveragePath,
        jsonPointer: diagnostic.path,
      );
    }
  }
  for (final component in capture.componentDocuments) {
    for (final diagnostic in component.diagnostics) {
      final key = [
        'component',
        component.id,
        diagnostic.code,
        diagnostic.path,
        diagnostic.message,
      ].join('|');
      result[key] = _Snapshot(
        category: .diagnostic,
        id: '${component.id} · ${diagnostic.code}',
        value: {'severity': diagnostic.severity, 'message': diagnostic.message},
        componentId: component.id,
        jsonPointer: diagnostic.path,
      );
    }
    for (final recipe in component.recipes) {
      for (final style in recipe.styles.entries) {
        for (final diagnostic in style.value.diagnostics) {
          final key = [
            'component',
            component.id,
            recipe.id,
            style.key,
            diagnostic.code,
            diagnostic.path,
            diagnostic.message,
          ].join('|');
          result[key] = _Snapshot(
            category: .diagnostic,
            id:
                '${component.id} / ${recipe.id} / ${style.key} · '
                '${diagnostic.code}',
            value: {
              'severity': diagnostic.severity,
              'message': diagnostic.message,
            },
            componentId: component.id,
            recipeId: recipe.id,
            slotId: style.key,
            jsonPointer: diagnostic.path,
          );
        }
      }
    }
  }

  return result;
}

Map<String, _Snapshot> _visualOracleSnapshots(LoadedCapture capture) => {
  for (final component in capture.catalog.components)
    for (final asset in component.assets.values)
      '${component.id}|${asset.themeId}': _Snapshot(
        category: .visualOracle,
        id: '${component.id} / ${asset.themeId} contact sheet',
        value: {
          'image': asset.imagePath,
          'imageHash': capture.manifest.files[asset.imagePath]?.sha256,
          'metadata': asset.metadataPath,
          'metadataHash': capture.manifest.files[asset.metadataPath]?.sha256,
          'evidence': 'rendered',
        },
        componentId: component.id,
        themeId: asset.themeId,
        sourcePath: asset.imagePath,
      ),
};

void _appendDiff(
  List<AtlasDeclaredChange> changes,
  Map<String, _Snapshot> baseline,
  Map<String, _Snapshot> current,
) {
  final keys = {...baseline.keys, ...current.keys}.toList()..sort();
  for (final key in keys) {
    final before = baseline[key];
    final after = current[key];
    if (before == null) {
      changes.add(_change(.added, after!));
    } else if (after == null) {
      changes.add(_change(.removed, before));
    } else if (!_equal(before.value, after.value)) {
      changes.add(_change(.modified, after, baselineValue: before.value));
    }
  }
}

AtlasDeclaredChange _change(
  AtlasDeclaredChangeKind kind,
  _Snapshot snapshot, {
  Object? baselineValue,
}) => .new(
  kind: kind,
  category: snapshot.category,
  id: snapshot.id,
  componentId: snapshot.componentId,
  recipeId: snapshot.recipeId,
  selector: snapshot.selector,
  themeId: snapshot.themeId,
  slotId: snapshot.slotId,
  property: snapshot.property,
  tokenKind: snapshot.tokenKind,
  tokenName: snapshot.tokenName,
  sourcePath: snapshot.sourcePath,
  jsonPointer: snapshot.jsonPointer,
  baselineValue: kind == .removed ? snapshot.value : baselineValue,
  currentValue: kind == .removed ? null : snapshot.value,
);

bool _equal(Object? left, Object? right) =>
    jsonEncode(left) == jsonEncode(right);

String _changeKey(AtlasDeclaredChange change) =>
    '${change.category.index}|${change.id}|${change.kind.index}';
