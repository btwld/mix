import 'dart:convert';
import 'dart:typed_data';

import 'package:mix_protocol/mix_protocol.dart';

import 'capture_bundle.dart';

abstract final class CaptureLimits {
  static const maxManifestBytes = 1024 * 1024;
  static const maxJsonBytes = 2 * 1024 * 1024;
  static const maxFileBytes = 20 * 1024 * 1024;
  static const maxTotalBytes = 50 * 1024 * 1024;
  static const maxFiles = 256;
  static const maxComponentDocuments = 64;
}

CaptureManifest parseCaptureManifest(Uint8List bytes) {
  final root = decodeJsonObject(bytes, path: 'capture.json');
  final schema = root['schema'];
  final schemaVersion = switch (schema) {
    'mix_atlas/capture/v1' => 1,
    'mix_atlas/capture/v2' => 2,
    _ => throw ArtifactLoadException(
      .unsupportedSchema,
      'Expected schema to be "mix_atlas/capture/v1" or '
      '"mix_atlas/capture/v2".',
      path: 'capture.json/schema',
    ),
  };
  _expectKeys(root, {
    'schema',
    'id',
    'producer',
    'catalog',
    'themes',
    'protocolCoverage',
    'files',
    if (schemaVersion == 2) 'components',
  }, path: 'capture.json');

  final id = _requiredString(root, 'id', path: 'capture.json/id');
  final producerJson = _requiredObject(
    root,
    'producer',
    path: 'capture.json/producer',
  );
  _expectKeys(producerJson, const {
    'atlas',
    'mixProtocolVersion',
    'mixProtocolFormat',
    'flutter',
  }, path: 'capture.json/producer');
  final producer = CaptureProducer(
    atlasVersion: _requiredString(
      producerJson,
      'atlas',
      path: 'capture.json/producer/atlas',
    ),
    mixProtocolVersion: _requiredString(
      producerJson,
      'mixProtocolVersion',
      path: 'capture.json/producer/mixProtocolVersion',
    ),
    mixProtocolFormat: _requiredInt(
      producerJson,
      'mixProtocolFormat',
      path: 'capture.json/producer/mixProtocolFormat',
    ),
    flutterVersion: _requiredString(
      producerJson,
      'flutter',
      path: 'capture.json/producer/flutter',
    ),
  );
  if (producer.mixProtocolVersion != mixProtocolVersion ||
      producer.mixProtocolFormat != mixProtocolFormatVersion) {
    throw ArtifactLoadException(
      .invalidProtocol,
      'Capture protocol ${producer.mixProtocolVersion} '
      '(format ${producer.mixProtocolFormat}) is not supported by this app.',
      path: 'capture.json/producer',
    );
  }

  final catalogPath = _requiredArtifactPath(
    root,
    'catalog',
    path: 'capture.json/catalog',
  );
  final coveragePath = _requiredArtifactPath(
    root,
    'protocolCoverage',
    path: 'capture.json/protocolCoverage',
  );
  final themesJson = _requiredList(root, 'themes', path: 'capture.json/themes');
  final themeIds = <String>{};
  final themes = <CaptureThemeEntry>[];
  for (var index = 0; index < themesJson.length; index += 1) {
    final path = 'capture.json/themes/$index';
    final value = _asObject(themesJson[index], path: path);
    _expectKeys(value, const {'id', 'document'}, path: path);
    final themeId = _requiredString(value, 'id', path: '$path/id');
    if (!themeIds.add(themeId)) {
      throw ArtifactLoadException(
        .malformedJson,
        'Theme identifiers must be unique.',
        path: '$path/id',
      );
    }
    themes.add(
      CaptureThemeEntry(
        id: themeId,
        documentPath: _requiredArtifactPath(
          value,
          'document',
          path: '$path/document',
        ),
      ),
    );
  }
  if (themes.isEmpty) {
    throw const ArtifactLoadException(
      .malformedJson,
      'Capture must contain at least one theme.',
      path: 'capture.json/themes',
    );
  }

  final componentDocuments = <CaptureComponentDocumentEntry>[];
  if (schemaVersion == 2) {
    final componentsJson = _requiredList(
      root,
      'components',
      path: 'capture.json/components',
    );
    if (componentsJson.isEmpty ||
        componentsJson.length > CaptureLimits.maxComponentDocuments) {
      throw ArtifactLoadException(
        .malformedJson,
        'Capture component document count must be between 1 and '
        '${CaptureLimits.maxComponentDocuments}.',
        path: 'capture.json/components',
      );
    }
    final componentIds = <String>{};
    for (var index = 0; index < componentsJson.length; index += 1) {
      final path = 'capture.json/components/$index';
      final value = _asObject(componentsJson[index], path: path);
      _expectKeys(value, const {'id', 'document'}, path: path);
      final componentId = _requiredString(value, 'id', path: '$path/id');
      if (!componentIds.add(componentId)) {
        throw ArtifactLoadException(
          .malformedJson,
          'Component document identifiers must be unique.',
          path: '$path/id',
        );
      }
      componentDocuments.add(
        CaptureComponentDocumentEntry(
          id: componentId,
          documentPath: _requiredArtifactPath(
            value,
            'document',
            path: '$path/document',
          ),
        ),
      );
    }
  }

  final filesJson = _requiredList(root, 'files', path: 'capture.json/files');
  if (filesJson.isEmpty || filesJson.length > CaptureLimits.maxFiles) {
    throw ArtifactLoadException(
      .malformedJson,
      'Capture file count must be between 1 and ${CaptureLimits.maxFiles}.',
      path: 'capture.json/files',
    );
  }
  final files = <String, CaptureFileEntry>{};
  var totalBytes = 0;
  for (var index = 0; index < filesJson.length; index += 1) {
    final path = 'capture.json/files/$index';
    final value = _asObject(filesJson[index], path: path);
    _expectKeys(value, const {'path', 'sha256', 'bytes'}, path: path);
    final filePath = _requiredArtifactPath(value, 'path', path: '$path/path');
    final hash = _requiredString(value, 'sha256', path: '$path/sha256');
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(hash)) {
      throw ArtifactLoadException(
        .malformedJson,
        'SHA-256 must be 64 lowercase hexadecimal characters.',
        path: '$path/sha256',
      );
    }
    final byteCount = _requiredInt(value, 'bytes', path: '$path/bytes');
    if (byteCount < 0 || byteCount > CaptureLimits.maxFileBytes) {
      throw ArtifactLoadException(
        .malformedJson,
        'File size exceeds the capture limit.',
        path: '$path/bytes',
      );
    }
    totalBytes += byteCount;
    if (totalBytes > CaptureLimits.maxTotalBytes) {
      throw const ArtifactLoadException(
        .malformedJson,
        'Capture exceeds the total byte limit.',
        path: 'capture.json/files',
      );
    }
    if (files.containsKey(filePath)) {
      throw ArtifactLoadException(
        .malformedJson,
        'Capture file paths must be unique.',
        path: '$path/path',
      );
    }
    files[filePath] = CaptureFileEntry(
      path: filePath,
      sha256: hash,
      bytes: byteCount,
    );
  }

  for (final requiredPath in [
    catalogPath,
    coveragePath,
    ...themes.map((theme) => theme.documentPath),
    ...componentDocuments.map((component) => component.documentPath),
  ]) {
    if (!files.containsKey(requiredPath)) {
      throw ArtifactLoadException(
        .integrity,
        'Manifest does not index a required capture file.',
        path: requiredPath,
      );
    }
  }

  return CaptureManifest(
    id: id,
    schemaVersion: schemaVersion,
    producer: producer,
    catalogPath: catalogPath,
    themes: List.unmodifiable(themes),
    componentDocuments: List.unmodifiable(componentDocuments),
    protocolCoveragePath: coveragePath,
    files: files,
  );
}

CapturedCatalog parseCapturedCatalog(
  Uint8List bytes, {
  required CaptureManifest manifest,
}) {
  final root = decodeJsonObject(bytes, path: manifest.catalogPath);
  _expectKeys(root, const {
    'schema',
    'id',
    'label',
    'themes',
    'atlases',
  }, path: manifest.catalogPath);
  _expectValue(
    root,
    'schema',
    'mix_atlas/catalog/v1',
    kind: .unsupportedSchema,
    path: '${manifest.catalogPath}/schema',
  );
  final id = _requiredString(root, 'id', path: '${manifest.catalogPath}/id');
  if (id != manifest.id) {
    throw ArtifactLoadException(
      .invalidCatalog,
      'Catalog and capture identifiers do not match.',
      path: '${manifest.catalogPath}/id',
    );
  }
  final themesJson = _requiredList(
    root,
    'themes',
    path: '${manifest.catalogPath}/themes',
  );
  final themes = <CapturedCatalogTheme>[];
  final themeIds = <String>{};
  for (var index = 0; index < themesJson.length; index += 1) {
    final path = '${manifest.catalogPath}/themes/$index';
    final value = _asObject(themesJson[index], path: path);
    _expectKeys(value, const {'id', 'label', 'brightness'}, path: path);
    final themeId = _requiredString(value, 'id', path: '$path/id');
    final brightness = _requiredString(
      value,
      'brightness',
      path: '$path/brightness',
    );
    if (!themeIds.add(themeId) ||
        (brightness != 'light' && brightness != 'dark')) {
      throw ArtifactLoadException(
        .invalidCatalog,
        'Catalog theme identifier or brightness is invalid.',
        path: path,
      );
    }
    themes.add(
      CapturedCatalogTheme(
        id: themeId,
        label: _optionalString(value, 'label') ?? themeId,
        brightness: brightness,
      ),
    );
  }
  final manifestThemeIds = manifest.themes.map((theme) => theme.id).toSet();
  if (themeIds.length != manifestThemeIds.length ||
      !themeIds.containsAll(manifestThemeIds)) {
    throw ArtifactLoadException(
      .invalidCatalog,
      'Catalog themes do not match capture theme documents.',
      path: '${manifest.catalogPath}/themes',
    );
  }

  final atlasesJson = _requiredList(
    root,
    'atlases',
    path: '${manifest.catalogPath}/atlases',
  );
  if (atlasesJson.isEmpty) {
    throw ArtifactLoadException(
      .invalidCatalog,
      'Catalog must contain at least one component.',
      path: '${manifest.catalogPath}/atlases',
    );
  }
  final componentIds = <String>{};
  final components = <CapturedComponent>[];
  for (var index = 0; index < atlasesJson.length; index += 1) {
    final path = '${manifest.catalogPath}/atlases/$index';
    final value = _asObject(atlasesJson[index], path: path);
    _expectKeys(value, const {'id', 'label', 'files'}, path: path);
    final componentId = _requiredString(value, 'id', path: '$path/id');
    if (!componentIds.add(componentId)) {
      throw ArtifactLoadException(
        .invalidCatalog,
        'Component identifiers must be unique.',
        path: '$path/id',
      );
    }
    final assetsJson = _requiredList(value, 'files', path: '$path/files');
    final assets = <String, CapturedComponentAsset>{};
    for (var assetIndex = 0; assetIndex < assetsJson.length; assetIndex += 1) {
      final assetPath = '$path/files/$assetIndex';
      final asset = _asObject(assetsJson[assetIndex], path: assetPath);
      _expectKeys(asset, const {'theme', 'image', 'metadata'}, path: assetPath);
      final themeId = _requiredString(asset, 'theme', path: '$assetPath/theme');
      final imagePath = _requiredArtifactPath(
        asset,
        'image',
        path: '$assetPath/image',
      );
      final metadataPath = _requiredArtifactPath(
        asset,
        'metadata',
        path: '$assetPath/metadata',
      );
      if (!themeIds.contains(themeId) ||
          !manifest.files.containsKey(imagePath) ||
          !manifest.files.containsKey(metadataPath) ||
          assets.containsKey(themeId)) {
        throw ArtifactLoadException(
          .invalidCatalog,
          'Component asset does not match the capture manifest.',
          path: assetPath,
        );
      }
      assets[themeId] = CapturedComponentAsset(
        themeId: themeId,
        imagePath: imagePath,
        metadataPath: metadataPath,
      );
    }
    if (assets.length != themes.length) {
      throw ArtifactLoadException(
        .invalidCatalog,
        'Each component must provide one asset for every capture theme.',
        path: '$path/files',
      );
    }
    components.add(
      CapturedComponent(
        id: componentId,
        label: _optionalString(value, 'label') ?? componentId,
        assets: assets,
      ),
    );
  }

  return CapturedCatalog(
    id: id,
    label: _optionalString(root, 'label') ?? id,
    themes: List.unmodifiable(themes),
    components: List.unmodifiable(components),
  );
}

CapturedAtlasMetadata parseAtlasMetadata(
  Uint8List bytes, {
  required String path,
  required CapturedComponent component,
  required CapturedComponentAsset asset,
}) {
  final root = decodeJsonObject(bytes, path: path);
  _expectKeys(root, const {
    'schema',
    'component',
    'componentLabel',
    'theme',
    'themeLabel',
    'brightness',
    'file',
    'rowAxes',
    'rows',
    'columns',
  }, path: path);
  _expectValue(
    root,
    'schema',
    'mix_atlas/atlas/v1',
    kind: .unsupportedSchema,
    path: '$path/schema',
  );
  final componentId = _requiredString(
    root,
    'component',
    path: '$path/component',
  );
  final themeId = _requiredString(root, 'theme', path: '$path/theme');
  final imageFile = _requiredString(root, 'file', path: '$path/file');
  final expectedImageFile = asset.imagePath.split('/').last;
  if (componentId != component.id ||
      themeId != asset.themeId ||
      imageFile != expectedImageFile) {
    throw ArtifactLoadException(
      .invalidCatalog,
      'Atlas metadata coordinate does not match its catalog asset.',
      path: path,
    );
  }
  final rawAxes = _requiredList(root, 'rowAxes', path: '$path/rowAxes');
  if (rawAxes.length > 16) {
    throw ArtifactLoadException(
      .invalidCatalog,
      'Atlas metadata exceeds the row-axis limit.',
      path: '$path/rowAxes',
    );
  }
  final axes = <CapturedAtlasAxis>[];
  final axisIds = <String>{};
  for (var index = 0; index < rawAxes.length; index += 1) {
    final axisPath = '$path/rowAxes/$index';
    final value = _asObject(rawAxes[index], path: axisPath);
    _expectKeys(value, const {'id', 'label'}, path: axisPath);
    final id = _atlasIdentifier(value, 'id', path: '$axisPath/id');
    if (!axisIds.add(id)) {
      throw ArtifactLoadException(
        .invalidCatalog,
        'Atlas row-axis identifiers must be unique.',
        path: '$axisPath/id',
      );
    }
    axes.add(
      CapturedAtlasAxis(
        id: id,
        label: _requiredString(value, 'label', path: '$axisPath/label'),
      ),
    );
  }

  final rawRows = _requiredList(root, 'rows', path: '$path/rows');
  final rawColumns = _requiredList(root, 'columns', path: '$path/columns');
  if (rawRows.isEmpty ||
      rawRows.length > 512 ||
      rawColumns.isEmpty ||
      rawColumns.length > 64) {
    throw ArtifactLoadException(
      .invalidCatalog,
      'Atlas metadata must contain bounded rows and columns.',
      path: path,
    );
  }
  final rows = <CapturedAtlasRow>[];
  final rowIds = <String>{};
  for (var index = 0; index < rawRows.length; index += 1) {
    final rowPath = '$path/rows/$index';
    final value = _asObject(rawRows[index], path: rowPath);
    _expectKeys(value, const {'id', 'label', 'values'}, path: rowPath);
    final id = _atlasIdentifier(value, 'id', path: '$rowPath/id');
    if (!rowIds.add(id)) {
      throw ArtifactLoadException(
        .invalidCatalog,
        'Atlas row identifiers must be unique.',
        path: '$rowPath/id',
      );
    }
    final rawValues = _requiredObject(value, 'values', path: '$rowPath/values');
    if (rawValues.keys.toSet().difference(axisIds).isNotEmpty ||
        axisIds.difference(rawValues.keys.toSet()).isNotEmpty) {
      throw ArtifactLoadException(
        .invalidCatalog,
        'Every row must declare exactly one value for every row axis.',
        path: '$rowPath/values',
      );
    }
    final values = <String, CapturedAtlasAxisValue>{};
    for (final axis in axes) {
      final valuePath = '$rowPath/values/${axis.id}';
      final coordinate = _asObject(rawValues[axis.id], path: valuePath);
      _expectKeys(coordinate, const {'id', 'label'}, path: valuePath);
      values[axis.id] = CapturedAtlasAxisValue(
        id: _atlasIdentifier(coordinate, 'id', path: '$valuePath/id'),
        label: _requiredString(coordinate, 'label', path: '$valuePath/label'),
      );
    }
    rows.add(
      CapturedAtlasRow(
        id: id,
        label: _optionalString(value, 'label'),
        values: values,
      ),
    );
  }

  const allowedWidgetStates = {
    'hovered',
    'focused',
    'pressed',
    'dragged',
    'selected',
    'scrolledUnder',
    'disabled',
    'error',
  };
  final scenarios = <CapturedAtlasScenario>[];
  final scenarioIds = <String>{};
  for (var index = 0; index < rawColumns.length; index += 1) {
    final scenarioPath = '$path/columns/$index';
    final value = _asObject(rawColumns[index], path: scenarioPath);
    _expectKeys(value, const {
      'id',
      'label',
      'states',
      'props',
    }, path: scenarioPath);
    final id = _atlasIdentifier(value, 'id', path: '$scenarioPath/id');
    if (!scenarioIds.add(id)) {
      throw ArtifactLoadException(
        .invalidCatalog,
        'Atlas scenario identifiers must be unique.',
        path: '$scenarioPath/id',
      );
    }
    final rawStates = value.containsKey('states')
        ? _asList(value['states'], path: '$scenarioPath/states')
        : const <Object?>[];
    final states = <String>{};
    for (var stateIndex = 0; stateIndex < rawStates.length; stateIndex += 1) {
      final state = rawStates[stateIndex];
      if (state is! String ||
          !allowedWidgetStates.contains(state) ||
          !states.add(state)) {
        throw ArtifactLoadException(
          .invalidCatalog,
          'Atlas widget states must be supported and unique.',
          path: '$scenarioPath/states/$stateIndex',
        );
      }
    }
    final properties = value.containsKey('props')
        ? _asObject(value['props'], path: '$scenarioPath/props')
        : const <String, Object?>{};
    scenarios.add(
      CapturedAtlasScenario(
        id: id,
        label: _optionalString(value, 'label'),
        widgetStates: states,
        properties: properties,
      ),
    );
  }

  return CapturedAtlasMetadata(
    componentId: componentId,
    themeId: themeId,
    rowAxes: axes,
    rows: rows,
    scenarios: scenarios,
    rowCount: rows.length,
    columnCount: scenarios.length,
  );
}

String _atlasIdentifier(
  Map<String, Object?> value,
  String key, {
  required String path,
}) {
  final id = _requiredString(value, key, path: path);
  if (!RegExp(r'^[A-Za-z][A-Za-z0-9_-]{0,63}$').hasMatch(id)) {
    throw ArtifactLoadException(
      .invalidCatalog,
      'Expected a stable Atlas identifier.',
      path: path,
    );
  }

  return id;
}

ProtocolCoverageSummary parseProtocolCoverage(
  Uint8List bytes, {
  required String path,
}) {
  final root = decodeJsonObject(bytes, path: path);
  _expectValue(
    root,
    'schema',
    'mix_atlas/protocol-coverage/v1',
    kind: .unsupportedSchema,
    path: '$path/schema',
  );
  final version = _requiredString(
    root,
    'mixProtocolVersion',
    path: '$path/mixProtocolVersion',
  );
  final format = _requiredInt(
    root,
    'mixProtocolFormat',
    path: '$path/mixProtocolFormat',
  );
  if (version != mixProtocolVersion || format != mixProtocolFormatVersion) {
    throw ArtifactLoadException(
      .invalidProtocol,
      'Coverage protocol $version (format $format) is unsupported.',
      path: path,
    );
  }

  final items = <ProtocolCoverageItem>[];
  final themes = _requiredList(root, 'themes', path: '$path/themes');
  for (var index = 0; index < themes.length; index += 1) {
    final itemPath = '$path/themes/$index';
    final value = _asObject(themes[index], path: itemPath);
    final id = _requiredString(value, 'id', path: '$itemPath/id');
    items.add(
      ProtocolCoverageItem(
        id: id,
        kind: 'theme',
        status: _requiredString(value, 'status', path: '$itemPath/status'),
        diagnostics: _parseDiagnostics(
          value['rawDiagnostics'],
          probeId: id,
          path: '$itemPath/rawDiagnostics',
        ),
      ),
    );
  }
  final styles = _requiredList(root, 'styles', path: '$path/styles');
  for (var index = 0; index < styles.length; index += 1) {
    final itemPath = '$path/styles/$index';
    final value = _asObject(styles[index], path: itemPath);
    final id = _requiredString(value, 'id', path: '$itemPath/id');
    items.add(
      ProtocolCoverageItem(
        id: id,
        kind: 'style',
        status: _requiredString(value, 'status', path: '$itemPath/status'),
        diagnostics: _parseDiagnostics(
          value['diagnostics'],
          probeId: id,
          path: '$itemPath/diagnostics',
        ),
      ),
    );
  }

  return ProtocolCoverageSummary(
    protocolVersion: version,
    protocolFormat: format,
    items: List.unmodifiable(items),
  );
}

Map<String, Object?> decodeJsonObject(Uint8List bytes, {required String path}) {
  if (bytes.length > CaptureLimits.maxJsonBytes) {
    throw ArtifactLoadException(
      .malformedJson,
      'JSON artifact exceeds the byte limit.',
      path: path,
    );
  }
  try {
    final decoded = jsonDecode(utf8.decode(bytes, allowMalformed: false));

    return _asObject(decoded, path: path);
  } on ArtifactLoadException {
    rethrow;
  } on Object catch (error, stackTrace) {
    Error.throwWithStackTrace(
      ArtifactLoadException(
        .malformedJson,
        'Artifact is not valid UTF-8 JSON.',
        path: path,
        cause: error,
      ),
      stackTrace,
    );
  }
}

void validateArtifactPath(String value, {required String path}) {
  final uri = Uri.tryParse(value);
  final segments = value.split('/');
  if (value.isEmpty ||
      value.length > 512 ||
      value.startsWith('/') ||
      value.contains(r'\') ||
      uri == null ||
      uri.hasScheme ||
      segments.any(
        (segment) => segment.isEmpty || segment == '.' || segment == '..',
      )) {
    throw ArtifactLoadException(
      .unsafePath,
      'Artifact paths must be normalized repository-relative paths.',
      path: path,
    );
  }
}

List<ProtocolDiagnostic> _parseDiagnostics(
  Object? value, {
  required String probeId,
  required String path,
}) {
  if (value == null) return const [];
  final values = _asList(value, path: path);

  return List.unmodifiable([
    for (var index = 0; index < values.length; index += 1)
      _diagnostic(
        _asObject(values[index], path: '$path/$index'),
        probeId: probeId,
        path: '$path/$index',
      ),
  ]);
}

ProtocolDiagnostic _diagnostic(
  Map<String, Object?> value, {
  required String probeId,
  required String path,
}) {
  return ProtocolDiagnostic(
    probeId: probeId,
    code: _requiredString(value, 'code', path: '$path/code'),
    severity: _requiredString(value, 'severity', path: '$path/severity'),
    path: _requiredString(value, 'path', path: '$path/path', allowEmpty: true),
    message: _requiredString(value, 'message', path: '$path/message'),
  );
}

Map<String, Object?> _requiredObject(
  Map<String, Object?> map,
  String key, {
  required String path,
}) => _asObject(map[key], path: path);

List<Object?> _requiredList(
  Map<String, Object?> map,
  String key, {
  required String path,
}) => _asList(map[key], path: path);

Map<String, Object?> _asObject(Object? value, {required String path}) {
  if (value is! Map<Object?, Object?>) {
    throw ArtifactLoadException(
      .malformedJson,
      'Expected a JSON object.',
      path: path,
    );
  }
  final result = <String, Object?>{};
  for (final entry in value.entries) {
    if (entry.key is! String) {
      throw ArtifactLoadException(
        .malformedJson,
        'JSON object keys must be strings.',
        path: path,
      );
    }
    result[entry.key as String] = entry.value;
  }

  return result;
}

List<Object?> _asList(Object? value, {required String path}) {
  if (value is! List<Object?>) {
    throw ArtifactLoadException(
      .malformedJson,
      'Expected a JSON list.',
      path: path,
    );
  }

  return value;
}

String _requiredString(
  Map<String, Object?> map,
  String key, {
  required String path,
  bool allowEmpty = false,
}) {
  final value = map[key];
  if (value is! String || (!allowEmpty && value.trim().isEmpty)) {
    throw ArtifactLoadException(
      .malformedJson,
      'Expected a${allowEmpty ? '' : ' non-empty'} string.',
      path: path,
    );
  }

  return value;
}

String? _optionalString(Map<String, Object?> map, String key) {
  final value = map[key];
  if (value == null) return null;
  if (value is String && value.trim().isNotEmpty) return value;
  throw ArtifactLoadException(
    .malformedJson,
    'Expected a non-empty string when present.',
    path: key,
  );
}

int _requiredInt(Map<String, Object?> map, String key, {required String path}) {
  final value = map[key];
  if (value is! int) {
    throw ArtifactLoadException(
      .malformedJson,
      'Expected an integer.',
      path: path,
    );
  }

  return value;
}

String _requiredArtifactPath(
  Map<String, Object?> map,
  String key, {
  required String path,
}) {
  final value = _requiredString(map, key, path: path);
  validateArtifactPath(value, path: path);

  return value;
}

void _expectValue(
  Map<String, Object?> map,
  String key,
  Object expected, {
  required ArtifactFailureKind kind,
  required String path,
}) {
  if (map[key] != expected) {
    throw ArtifactLoadException(
      kind,
      'Expected $key to be "$expected".',
      path: path,
    );
  }
}

void _expectKeys(
  Map<String, Object?> map,
  Set<String> allowed, {
  required String path,
}) {
  final unknown = map.keys.toSet().difference(allowed);
  if (unknown.isNotEmpty) {
    throw ArtifactLoadException(
      .malformedJson,
      'Unknown fields: ${unknown.toList()..sort()}.',
      path: path,
    );
  }
}
