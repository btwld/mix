import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';

import '../sources/artifact_source.dart';
import 'capture_bundle.dart';
import 'capture_parser.dart';
import 'component_document.dart';
import 'component_parser.dart';

abstract interface class ArtifactCaptureLoader {
  Future<LoadedCapture> load(ArtifactRepositoryRequest request);
}

final class CaptureLoader implements ArtifactCaptureLoader {
  final ArtifactSource _source;

  const CaptureLoader({required ArtifactSource source}) : _source = source;

  @override
  Future<LoadedCapture> load(ArtifactRepositoryRequest request) async {
    validateArtifactPath(request.manifestPath, path: 'manifestPath');
    final source = await _source.resolve(request);
    final manifestBytes = await source.read(
      request.manifestPath,
      maxBytes: CaptureLimits.maxManifestBytes,
    );
    final manifest = parseCaptureManifest(manifestBytes);
    final root = _parentPath(request.manifestPath);
    final files = <String, Uint8List>{};

    for (final entry in manifest.files.values) {
      final bytes = await source.read(
        _join(root, entry.path),
        maxBytes: entry.bytes + 1,
      );
      final actualHash = sha256.convert(bytes).toString();
      if (bytes.length != entry.bytes || actualHash != entry.sha256) {
        throw ArtifactLoadException(
          .integrity,
          'Capture file does not match its byte count and SHA-256.',
          path: entry.path,
        );
      }
      if (entry.path.endsWith('.png') && !_isPng(bytes)) {
        throw ArtifactLoadException(
          .integrity,
          'Capture image does not contain a PNG signature.',
          path: entry.path,
        );
      }
      files[entry.path] = bytes;
    }

    final catalog = parseCapturedCatalog(
      files[manifest.catalogPath]!,
      manifest: manifest,
    );
    final coverage = parseProtocolCoverage(
      files[manifest.protocolCoveragePath]!,
      path: manifest.protocolCoveragePath,
    );
    final themeTokenCounts = <String, int>{};
    final protocolThemes = <String, MixProtocolTheme>{};
    for (final theme in manifest.themes) {
      final payload = decodeJsonObject(
        files[theme.documentPath]!,
        path: theme.documentPath,
      );
      final decoded = mixProtocol.decodeTheme(payload);
      switch (decoded) {
        case MixProtocolSuccess<MixProtocolTheme>(:final value):
          themeTokenCounts[theme.id] = value.tokens.length;
          protocolThemes[theme.id] = value;
        case MixProtocolFailure<MixProtocolTheme>(:final errors):
          throw ArtifactLoadException(
            .invalidProtocol,
            _diagnosticMessage('Theme document failed strict decode', errors),
            path: theme.documentPath,
          );
      }
    }

    final themePaths = manifest.themes
        .map((theme) => theme.documentPath)
        .toSet();
    var validatedStyleDocumentCount = 0;
    final styleDocuments = <String, Object>{};
    for (final entry in manifest.files.values) {
      if (!entry.path.endsWith('.mix.json') ||
          themePaths.contains(entry.path)) {
        continue;
      }
      final payload = decodeJsonObject(files[entry.path]!, path: entry.path);
      final decoded = mixProtocol.decodeStyle<Object>(payload);
      switch (decoded) {
        case MixProtocolSuccess<Object>(:final value):
          validatedStyleDocumentCount += 1;
          styleDocuments[entry.path] = value;
        case MixProtocolFailure<Object>(:final errors):
          throw ArtifactLoadException(
            .invalidProtocol,
            _diagnosticMessage('Style document failed strict decode', errors),
            path: entry.path,
          );
      }
    }

    final componentDocuments = <PortableComponentDocument>[];
    if (manifest.schemaVersion == 2) {
      final catalogIds = catalog.components
          .map((component) => component.id)
          .toSet();
      final documentIds = manifest.componentDocuments
          .map((component) => component.id)
          .toSet();
      if (!catalogIds.containsAll(documentIds)) {
        throw ArtifactLoadException(
          .invalidComponent,
          'Every portable component document must reference a catalog component.',
          path: 'capture.json/components',
        );
      }
      for (final entry in manifest.componentDocuments) {
        final document = parsePortableComponentDocument(
          files[entry.documentPath]!,
          path: entry.documentPath,
        );
        final component = catalog.components.singleWhere(
          (candidate) => candidate.id == entry.id,
        );
        validatedStyleDocumentCount += _validateComponentDocument(
          document,
          entry: entry,
          component: component,
          manifest: manifest,
          protocolThemes: protocolThemes,
          styleDocuments: styleDocuments,
        );
        componentDocuments.add(document);
      }
      _validateNestedComponentGraph(componentDocuments);
    }

    final metadata = <String, CapturedAtlasMetadata>{};
    for (final component in catalog.components) {
      for (final asset in component.assets.values) {
        final value = parseAtlasMetadata(
          files[asset.metadataPath]!,
          path: asset.metadataPath,
          component: component,
          asset: asset,
        );
        metadata['${component.id}/${asset.themeId}'] = value;
      }
    }
    _validatePortableMatrixAlignment(
      componentDocuments,
      catalog: catalog,
      metadata: metadata,
    );

    return LoadedCapture(
      receipt: source.receipt,
      manifest: manifest,
      catalog: catalog,
      protocolCoverage: coverage,
      files: files,
      themeTokenCounts: themeTokenCounts,
      protocolThemes: protocolThemes,
      componentDocuments: componentDocuments,
      styleDocuments: styleDocuments,
      atlasMetadata: metadata,
      validatedStyleDocumentCount: validatedStyleDocumentCount,
    );
  }
}

int _validateComponentDocument(
  PortableComponentDocument document, {
  required CaptureComponentDocumentEntry entry,
  required CapturedComponent component,
  required CaptureManifest manifest,
  required Map<String, MixProtocolTheme> protocolThemes,
  required Map<String, Object> styleDocuments,
}) {
  if (document.id != entry.id || document.id != component.id) {
    throw ArtifactLoadException(
      .invalidComponent,
      'Component document, manifest, and catalog identifiers must match.',
      path: entry.documentPath,
    );
  }
  if (document.oracles.length != component.assets.length ||
      !document.oracles.keys.toSet().containsAll(component.assets.keys)) {
    throw ArtifactLoadException(
      .invalidComponent,
      'Component visual oracles must cover every catalog theme.',
      path: entry.documentPath,
    );
  }
  for (final asset in component.assets.values) {
    final oracle = document.oracles[asset.themeId]!;
    if (oracle.imagePath != asset.imagePath ||
        oracle.metadataPath != asset.metadataPath) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Component visual oracle must reference its catalog asset.',
        path: entry.documentPath,
      );
    }
  }

  if (document.schema == .v2) {
    final count = _validateV2Styles(
      document,
      path: entry.documentPath,
      styleDocuments: styleDocuments,
    );
    _validateV2Bindings(
      document,
      path: entry.documentPath,
      manifest: manifest,
      protocolThemes: protocolThemes,
    );

    return count;
  }

  for (final recipe in document.recipes) {
    for (final slot in document.slots.values) {
      final styleReference = recipe.styleFor(slot.id);
      if (!styleReference.isSupported) continue;
      if (slot.kind == .spinner) {
        throw ArtifactLoadException(
          .invalidComponent,
          'Spinner must remain unsupported until a neutral primitive exists.',
          path: '${entry.documentPath}/${recipe.id}/${slot.id}',
        );
      }
      final stylePath = styleReference.documentPath!;
      if (!stylePath.endsWith('.mix.json') ||
          !manifest.files.containsKey(stylePath)) {
        throw ArtifactLoadException(
          .integrity,
          'Supported slot style must be an indexed Mix protocol document.',
          path: stylePath,
        );
      }
      final style = styleDocuments[stylePath];
      final correctType = switch (slot.kind) {
        .box => style is BoxStyler,
        .flexBox => style is FlexBoxStyler,
        .stackBox => style is StackBoxStyler,
        .text => style is TextStyler,
        .icon => style is IconStyler,
        .image => style is ImageStyler,
        .spinner || .fractionalPosition || .nestedComponent => false,
      };
      if (!correctType) {
        throw ArtifactLoadException(
          .invalidProtocol,
          'Slot "${slot.id}" did not decode to its declared Mix type.',
          path: stylePath,
        );
      }
    }
  }

  return 0;
}

int _validateV2Styles(
  PortableComponentDocument document, {
  required String path,
  required Map<String, Object> styleDocuments,
}) {
  final decoded = <String, Object>{};
  for (final entry in document.styleLibrary.values) {
    final result = mixProtocol.decodeStyle<Object>(entry.document);
    switch (result) {
      case MixProtocolSuccess<Object>(:final value):
        decoded[entry.id] = value;
        styleDocuments[componentStyleDocumentKey(document.id, entry.id)] =
            value;
      case MixProtocolFailure<Object>(:final errors):
        throw ArtifactLoadException(
          .invalidProtocol,
          _diagnosticMessage('Embedded style failed strict decode', errors),
          path: '$path/styles/${entry.id}',
        );
    }
  }

  final usedStyles = <String>{};
  for (final recipe in document.recipes) {
    for (final styleEntry in recipe.styles.entries) {
      final reference = styleEntry.value;
      if (!reference.isSupported ||
          reference.documentPath != null ||
          reference.styleId == null) {
        throw ArtifactLoadException(
          .invalidComponent,
          'Component-v2 recipes must use embedded supported styles.',
          path: '$path/recipes/${recipe.id}/styles/${styleEntry.key}',
        );
      }
      final styleId = reference.styleId!;
      final style = decoded[styleId];
      final slot = document.slots[styleEntry.key];
      if (style == null ||
          slot == null ||
          !_styleMatchesSlot(style, slot.kind)) {
        throw ArtifactLoadException(
          .invalidProtocol,
          'Embedded style did not decode to its declared slot type.',
          path: '$path/styles/$styleId',
        );
      }
      usedStyles.add(styleId);
    }
  }
  final unusedStyles = document.styleLibrary.keys.toSet().difference(
    usedStyles,
  );
  if (unusedStyles.isNotEmpty) {
    throw ArtifactLoadException(
      .invalidComponent,
      'Component-v2 style libraries cannot contain unreferenced styles.',
      path: '$path/styles/${unusedStyles.first}',
    );
  }

  return decoded.length;
}

bool _styleMatchesSlot(Object style, ComponentSlotKind kind) => switch (kind) {
  .box => style is BoxStyler,
  .flexBox => style is FlexBoxStyler,
  .stackBox => style is StackBoxStyler,
  .text => style is TextStyler,
  .icon => style is IconStyler,
  .image => style is ImageStyler,
  .spinner || .fractionalPosition || .nestedComponent => false,
};

void _validateV2Bindings(
  PortableComponentDocument document, {
  required String path,
  required CaptureManifest manifest,
  required Map<String, MixProtocolTheme> protocolThemes,
}) {
  final bindings = <AtlasPortableBinding>[
    for (final node in document.anatomy.nodes.values) ...[
      ...node.bindings.values,
      ?node.recipeBinding,
      ?node.stateBinding,
      ...node.propertyBindings.values,
    ],
    ...document.semantics.bindings.values,
  ];
  for (final binding in bindings.where((item) => item.kind == .token)) {
    for (final theme in protocolThemes.entries) {
      final found = theme.value.tokens.keys.any(
        (token) =>
            token.name == binding.tokenName &&
            _portableTokenKind(token) == binding.tokenKind,
      );
      if (!found) {
        throw ArtifactLoadException(
          .invalidComponent,
          'Token binding must exist in every captured theme.',
          path: '$path/token/${binding.tokenKind!}/${binding.tokenName!}',
        );
      }
    }
  }

  for (final node in document.anatomy.nodes.values) {
    for (final entry in node.bindings.entries) {
      final values = _possibleRuntimeBindingValues(
        entry.value,
        document: document,
        protocolThemes: protocolThemes,
      );
      if (values.isEmpty ||
          values.any(
            (value) => !_isRenderableNodeBinding(
              entry.key,
              value,
              binding: entry.value,
              manifest: manifest,
            ),
          )) {
        throw ArtifactLoadException(
          entry.key == 'source' ? .integrity : .invalidComponent,
          'Node bindings must resolve only to values accepted by their '
          'portable primitive.',
          path: '$path/anatomy/${node.id}/${entry.key}',
        );
      }
    }
  }
}

Set<Object?> _possibleRuntimeBindingValues(
  AtlasPortableBinding binding, {
  required PortableComponentDocument document,
  required Map<String, MixProtocolTheme> protocolThemes,
}) {
  if (binding.kind != .token) {
    return _possibleBindingValues(binding, document);
  }

  return {
    for (final theme in protocolThemes.values)
      for (final token in theme.tokens.entries)
        if (token.key.name == binding.tokenName &&
            _portableTokenKind(token.key) == binding.tokenKind)
          token.value,
  };
}

bool _isRenderableNodeBinding(
  String name,
  Object? value, {
  required AtlasPortableBinding binding,
  required CaptureManifest manifest,
}) {
  if (value == null) return name != 'source';

  return switch (name) {
    'text' => value is String || value is num,
    'icon' => atlasPortableIconIdentities.contains(value),
    'source' => value is String && manifest.files.containsKey(value),
    'value' => value is num && value.isFinite && value >= 0 && value <= 1,
    'strokeWidth' ||
    'trackStrokeWidth' => value is num && value.isFinite && value > 0,
    'size' ||
    'widthFactor' ||
    'heightFactor' => value is num && value.isFinite && value >= 0,
    'color' || 'backgroundColor' || 'trackColor' =>
      binding.kind == .token ||
          (value is String && _portableColorPattern.hasMatch(value)),
    'duration' => value is int && value > 0,
    'alignment' => value is String && _portableAlignments.contains(value),
    _ => false,
  };
}

Set<Object?> _possibleBindingValues(
  AtlasPortableBinding binding,
  PortableComponentDocument document,
) => switch (binding.kind) {
  .literal => {binding.literalValue},
  .property => {
    document.properties[binding.propertyId]!.defaultValue,
    for (final recipe in document.recipes)
      if (recipe.properties.containsKey(binding.propertyId))
        recipe.properties[binding.propertyId],
    for (final state in document.states.values)
      if (state.propertyOverrides.containsKey(binding.propertyId))
        state.propertyOverrides[binding.propertyId],
  },
  .token => const {},
};

String? _portableTokenKind(MixToken token) => switch (token) {
  ColorToken() => 'color',
  SpaceToken() => 'space',
  DoubleToken() => 'double',
  RadiusToken() => 'radius',
  TextStyleToken() => 'textStyle',
  ShadowToken() => 'shadow',
  BoxShadowToken() => 'boxShadow',
  BorderSideToken() => 'border',
  FontWeightToken() => 'fontWeight',
  BreakpointToken() => 'breakpoint',
  DurationToken() => 'duration',
  _ => null,
};

void _validateNestedComponentGraph(List<PortableComponentDocument> documents) {
  final byId = {for (final document in documents) document.id: document};
  final edges = <String, Set<String>>{
    for (final document in documents) document.id: <String>{},
  };
  for (final document in documents.where((item) => item.schema == .v2)) {
    for (final node in document.anatomy.nodes.values) {
      if (node.kind != .nestedComponent) continue;
      final targetId = node.componentId!;
      final target = byId[targetId];
      if (target == null || target.schema != .v2) {
        throw ArtifactLoadException(
          .invalidComponent,
          'Nested component references must target component-v2 documents.',
          path: '${document.id}/nodes/${node.id}/component',
        );
      }
      final unknownProperties = node.propertyBindings.keys.toSet().difference(
        target.properties.keys.toSet(),
      );
      if (unknownProperties.isNotEmpty) {
        throw ArtifactLoadException(
          .invalidComponent,
          'Nested component binding references an unknown target property.',
          path: '${document.id}/nodes/${node.id}/properties',
        );
      }
      for (final binding in node.propertyBindings.entries) {
        final targetProperty = target.properties[binding.key]!;
        final values = _possibleBindingValues(binding.value, document);
        if (values.isEmpty ||
            values.any(
              (value) => !_isPortablePropertyValue(targetProperty, value),
            )) {
          throw ArtifactLoadException(
            .invalidComponent,
            'Nested component property bindings must resolve only to values '
            'accepted by the target property.',
            path: '${document.id}/nodes/${node.id}/properties/${binding.key}',
          );
        }
      }
      _validateNestedCoordinateBinding(
        node.recipeBinding!,
        source: document,
        allowed: target.recipes.map((recipe) => recipe.id).toSet(),
        path: '${document.id}/nodes/${node.id}/recipe',
      );
      _validateNestedCoordinateBinding(
        node.stateBinding!,
        source: document,
        allowed: target.states.keys.toSet(),
        path: '${document.id}/nodes/${node.id}/state',
      );
      edges[document.id]!.add(targetId);
    }
  }

  final visiting = <String>{};
  final visited = <String>{};
  void visit(String id) {
    if (!visiting.add(id)) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Nested component references must not contain cycles.',
        path: id,
      );
    }
    for (final target in edges[id]!) {
      if (!visited.contains(target)) visit(target);
    }
    visiting.remove(id);
    visited.add(id);
  }

  for (final id in edges.keys) {
    if (!visited.contains(id)) visit(id);
  }
}

void _validateNestedCoordinateBinding(
  AtlasPortableBinding binding, {
  required PortableComponentDocument source,
  required Set<String> allowed,
  required String path,
}) {
  final possible = _possibleBindingValues(binding, source);
  if (possible.isEmpty ||
      possible.any((value) => value is! String || !allowed.contains(value))) {
    throw ArtifactLoadException(
      .invalidComponent,
      'Nested recipe and state bindings must resolve only to known IDs.',
      path: path,
    );
  }
}

bool _isPortablePropertyValue(
  ComponentPropertyDefinition definition,
  Object? value,
) =>
    (!definition.isRequired && value == null) ||
    switch (definition.kind) {
      .enumeration => value is String && definition.values.contains(value),
      .string => value is String,
      .boolean => value is bool,
      .number => value is num && value.isFinite,
      .duration => value is int && value >= 0,
      .icon => atlasPortableIconIdentities.contains(value),
    };

void _validatePortableMatrixAlignment(
  List<PortableComponentDocument> documents, {
  required CapturedCatalog catalog,
  required Map<String, CapturedAtlasMetadata> metadata,
}) {
  for (final document in documents) {
    // Component-v1 captures predate the one-to-one matrix contract. They are
    // translated for rendering but retain their historically partial row and
    // scenario metadata.
    if (document.schema == .v1) continue;
    final component = catalog.components.singleWhere(
      (candidate) => candidate.id == document.id,
    );
    CapturedAtlasMetadata? reference;
    for (final theme in catalog.themes) {
      final current = metadata['${component.id}/${theme.id}']!;
      final recipeIds = document.recipes.map((recipe) => recipe.id).toList();
      final rowIds = current.rows.map((row) => row.id).toList();
      final stateIds = document.states.keys.toList();
      final scenarioIds = current.scenarios
          .map((scenario) => scenario.id)
          .toList();
      if (!_sameList(recipeIds, rowIds) || !_sameList(stateIds, scenarioIds)) {
        throw ArtifactLoadException(
          .invalidComponent,
          'Portable recipes and states must align one-to-one with ordered '
          'atlas rows and scenarios.',
          path: component.assets[theme.id]!.metadataPath,
        );
      }
      for (var index = 0; index < current.rows.length; index += 1) {
        final row = current.rows[index];
        final recipe = document.recipes[index];
        for (final axis in current.rowAxes) {
          if (recipe.properties[axis.id] != row.values[axis.id]!.id) {
            throw ArtifactLoadException(
              .invalidComponent,
              'Portable recipe coordinates must match atlas row axes.',
              path: component.assets[theme.id]!.metadataPath,
            );
          }
        }
      }
      for (var index = 0; index < current.scenarios.length; index += 1) {
        final scenario = current.scenarios[index];
        final state = document.states.values.elementAt(index);
        if (!_sameSet(scenario.widgetStates, state.widgetStates) ||
            !_sameMap(scenario.properties, state.propertyOverrides)) {
          throw ArtifactLoadException(
            .invalidComponent,
            'Component-v2 states must exactly match captured scenarios.',
            path: component.assets[theme.id]!.metadataPath,
          );
        }
      }
      if (reference != null && !_sameMetadataMatrix(reference, current)) {
        throw ArtifactLoadException(
          .invalidCatalog,
          'Every theme must preserve the same ordered atlas matrix.',
          path: component.assets[theme.id]!.metadataPath,
        );
      }
      reference = current;
    }
  }
}

bool _sameMetadataMatrix(
  CapturedAtlasMetadata left,
  CapturedAtlasMetadata right,
) {
  if (!_sameList(
        left.rowAxes.map((axis) => '${axis.id}:${axis.label}').toList(),
        right.rowAxes.map((axis) => '${axis.id}:${axis.label}').toList(),
      ) ||
      left.rows.length != right.rows.length ||
      left.scenarios.length != right.scenarios.length) {
    return false;
  }
  for (var index = 0; index < left.rows.length; index += 1) {
    final before = left.rows[index];
    final after = right.rows[index];
    if (before.id != after.id ||
        before.label != after.label ||
        !_sameMap(
          before.values.map((key, value) => MapEntry(key, value.id)),
          after.values.map((key, value) => MapEntry(key, value.id)),
        )) {
      return false;
    }
  }
  for (var index = 0; index < left.scenarios.length; index += 1) {
    final before = left.scenarios[index];
    final after = right.scenarios[index];
    if (before.id != after.id ||
        before.label != after.label ||
        !_sameSet(before.widgetStates, after.widgetStates) ||
        !_sameMap(before.properties, after.properties)) {
      return false;
    }
  }

  return true;
}

bool _sameList(List<Object?> left, List<Object?> right) {
  if (left.length != right.length) return false;
  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) return false;
  }

  return true;
}

bool _sameSet(Set<String> left, Set<String> right) =>
    left.length == right.length && left.containsAll(right);

bool _sameMap(Map<String, Object?> left, Map<String, Object?> right) {
  if (left.length != right.length ||
      !left.keys.toSet().containsAll(right.keys)) {
    return false;
  }
  for (final key in left.keys) {
    if (left[key] != right[key]) return false;
  }

  return true;
}

String _diagnosticMessage(String prefix, List<MixProtocolError> errors) {
  final details = errors
      .map((error) => '${error.code.wireValue} ${error.path}: ${error.message}')
      .join('; ');

  return '$prefix: $details';
}

String _parentPath(String path) {
  final separator = path.lastIndexOf('/');

  return separator == -1 ? '' : path.substring(0, separator);
}

String _join(String root, String path) => root.isEmpty ? path : '$root/$path';

bool _isPng(Uint8List bytes) {
  const signature = [137, 80, 78, 71, 13, 10, 26, 10];
  if (bytes.length < signature.length) return false;
  for (var index = 0; index < signature.length; index += 1) {
    if (bytes[index] != signature[index]) return false;
  }

  return true;
}

final _portableColorPattern = RegExp(r'^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$');
const _portableAlignments = {
  'topLeft',
  'topCenter',
  'topRight',
  'centerLeft',
  'center',
  'centerRight',
  'bottomLeft',
  'bottomCenter',
  'bottomRight',
};
