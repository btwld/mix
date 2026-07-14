import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:mix_atlas_capture/src/artifacts/capture_bundle.dart';
import 'package:mix_atlas_capture/src/sources/artifact_source.dart';

const fixtureRequest = ArtifactRepositoryRequest(
  repository: 'btwld/remix',
  ref: 'main',
  manifestPath: 'atlas/fortal/capture.json',
);

const fixtureCommit = '0123456789abcdef0123456789abcdef01234567';

final class ArtifactFixture {
  ArtifactFixture._({required this.files, required this.manifest});

  factory ArtifactFixture.create() {
    final files = <String, Uint8List>{
      'catalog.json': _jsonBytes({
        'schema': 'mix_atlas/catalog/v1',
        'id': 'fortal',
        'label': 'Fortal Design System',
        'themes': [
          {'id': 'light', 'label': 'Light', 'brightness': 'light'},
          {'id': 'dark', 'label': 'Dark', 'brightness': 'dark'},
        ],
        'atlases': [
          {
            'id': 'button',
            'label': 'Button',
            'files': [
              {
                'theme': 'light',
                'image': 'light/button.png',
                'metadata': 'light/button.json',
              },
              {
                'theme': 'dark',
                'image': 'dark/button.png',
                'metadata': 'dark/button.json',
              },
            ],
          },
        ],
      }),
      'light/button.json': _atlasMetadata('light', 'Light'),
      'dark/button.json': _atlasMetadata('dark', 'Dark'),
      'light/button.png': Uint8List.fromList(_onePixelPng),
      'dark/button.png': Uint8List.fromList(_onePixelPng),
      'protocol/coverage.json': _jsonBytes({
        'schema': 'mix_atlas/protocol-coverage/v1',
        'mixProtocolVersion': '1.0.0',
        'mixProtocolFormat': 1,
        'themes': [
          {'id': 'light', 'status': 'supported', 'rawDiagnostics': <Object?>[]},
          {'id': 'dark', 'status': 'supported', 'rawDiagnostics': <Object?>[]},
        ],
        'styles': [
          {
            'id': 'fortal-tokenized-flex-box-fixture',
            'status': 'supported',
            'diagnostics': <Object?>[],
          },
          {
            'id': 'fortal-button',
            'status': 'unsupported',
            'diagnostics': [
              {
                'code': 'unsupported_encode_value',
                'severity': 'error',
                'path': '',
                'message': 'Expected a built-in styler, got RemixButtonStyler.',
              },
            ],
          },
        ],
      }),
      'protocol/fixtures/fortal-button.mix.json': _jsonBytes({
        'v': 1,
        'type': 'box',
      }),
      'themes/light.mix.json': _theme('#3D63DD'),
      'themes/dark.mix.json': _theme('#8DA4EF'),
    };
    final manifest = <String, Object?>{
      'schema': 'mix_atlas/capture/v1',
      'id': 'fortal',
      'producer': {
        'atlas': '0.1.0',
        'mixProtocolVersion': '1.0.0',
        'mixProtocolFormat': 1,
        'flutter': '3.44.0',
      },
      'catalog': 'catalog.json',
      'themes': [
        {'id': 'light', 'document': 'themes/light.mix.json'},
        {'id': 'dark', 'document': 'themes/dark.mix.json'},
      ],
      'protocolCoverage': 'protocol/coverage.json',
      'files': <Object?>[],
    };
    final fixture = ArtifactFixture._(files: files, manifest: manifest);
    fixture.rehash();

    return fixture;
  }

  final Map<String, Uint8List> files;
  final Map<String, Object?> manifest;

  void addRenderedComponent({required String id, required String label}) {
    final catalog =
        jsonDecode(utf8.decode(files['catalog.json']!)) as Map<String, Object?>;
    final atlases = catalog['atlases']! as List<Object?>;
    atlases.add({
      'id': id,
      'label': label,
      'files': [
        for (final theme in const [('light', 'Light'), ('dark', 'Dark')])
          {
            'theme': theme.$1,
            'image': '${theme.$1}/$id.png',
            'metadata': '${theme.$1}/$id.json',
          },
      ],
    });
    for (final theme in const [('light', 'Light'), ('dark', 'Dark')]) {
      files['${theme.$1}/$id.png'] = Uint8List.fromList(
        files['${theme.$1}/button.png']!,
      );
      files['${theme.$1}/$id.json'] = _atlasMetadata(
        theme.$1,
        theme.$2,
        component: id,
        componentLabel: label,
      );
    }
    replaceJson('catalog.json', catalog, rehash: false);
    rehash();
  }

  void addPortableButtonCapture({Map<String, Object?>? document}) {
    final component = document ?? validButtonComponentDocument();
    manifest['schema'] = 'mix_atlas/capture/v2';
    manifest['components'] = [
      {'id': 'button', 'document': 'components/button.component.json'},
    ];
    replaceJson('components/button.component.json', component, rehash: false);
    final recipes = component['recipes']! as List<Object?>;
    for (final recipeValue in recipes) {
      final recipe = recipeValue! as Map<String, Object?>;
      final styles = recipe['styles']! as Map<String, Object?>;
      for (final entry in styles.entries) {
        final reference = entry.value! as Map<String, Object?>;
        if (reference['status'] != 'supported') continue;
        final path = reference['document']! as String;
        final type = switch (entry.key) {
          'container' => 'flex_box',
          'label' => 'text',
          'leadingIcon' || 'trailingIcon' => 'icon',
          'spinner' => 'box',
          _ => throw StateError('Unsupported fixture slot ${entry.key}.'),
        };
        replaceJson(path, {'v': 1, 'type': type}, rehash: false);
      }
    }
    rehash();
  }

  void replaceJson(String path, Object? value, {bool rehash = true}) {
    files[path] = _jsonBytes(value);
    if (rehash) this.rehash();
  }

  void rehash() {
    final entries = files.entries.toList()
      ..sort((left, right) => left.key.compareTo(right.key));
    manifest['files'] = [
      for (final entry in entries)
        {
          'path': entry.key,
          'sha256': sha256.convert(entry.value).toString(),
          'bytes': entry.value.length,
        },
    ];
  }

  ArtifactSource source() {
    final repositoryFiles = <String, Uint8List>{
      fixtureRequest.manifestPath: _jsonBytes(manifest),
      for (final entry in files.entries)
        'atlas/fortal/${entry.key}': entry.value,
    };

    return MemoryArtifactSource(repositoryFiles);
  }
}

Map<String, Object?> validButtonComponentDocument({
  List<Map<String, Object?>>? recipes,
}) => {
  'schema': 'mix_atlas/component/v1',
  'id': 'button',
  'label': 'Button',
  'properties': [
    {
      'id': 'variant',
      'kind': 'enum',
      'values': ['solid', 'soft', 'surface', 'outline', 'ghost'],
      'default': 'solid',
    },
    {
      'id': 'size',
      'kind': 'enum',
      'values': ['size1', 'size2', 'size3', 'size4'],
      'default': 'size2',
    },
    {'id': 'label', 'kind': 'string', 'default': 'Button'},
    {'id': 'leadingIcon', 'kind': 'icon', 'required': false},
    {'id': 'trailingIcon', 'kind': 'icon', 'required': false},
    {'id': 'enabled', 'kind': 'boolean', 'default': true},
    {'id': 'loading', 'kind': 'boolean', 'default': false},
  ],
  'states': [
    {
      'id': 'default',
      'widgetStates': <Object?>[],
      'properties': <String, Object?>{},
    },
    {
      'id': 'hovered',
      'widgetStates': ['hovered'],
      'properties': <String, Object?>{},
    },
    {
      'id': 'pressed',
      'widgetStates': ['pressed'],
      'properties': <String, Object?>{},
    },
    {
      'id': 'focused',
      'widgetStates': ['focused'],
      'properties': <String, Object?>{},
    },
    {
      'id': 'disabled',
      'widgetStates': ['disabled'],
      'properties': {'enabled': false},
    },
    {
      'id': 'loading',
      'widgetStates': ['disabled'],
      'properties': {'enabled': false, 'loading': true},
    },
  ],
  'slots': [
    {'id': 'container', 'kind': 'flex_box'},
    {'id': 'label', 'kind': 'text'},
    {'id': 'leadingIcon', 'kind': 'icon'},
    {'id': 'trailingIcon', 'kind': 'icon'},
    {'id': 'spinner', 'kind': 'spinner'},
  ],
  'anatomy': {
    'root': 'root',
    'nodes': [
      {
        'id': 'root',
        'kind': 'stack',
        'alignment': 'center',
        'children': ['content', 'spinner'],
      },
      {
        'id': 'content',
        'kind': 'slot',
        'slot': 'container',
        'children': ['leadingIcon', 'label', 'trailingIcon'],
        'visibleWhen': {
          'property': 'loading',
          'operator': 'equals',
          'value': false,
        },
        'maintain': ['size', 'state', 'animation'],
      },
      {
        'id': 'leadingIcon',
        'kind': 'slot',
        'slot': 'leadingIcon',
        'children': <Object?>[],
        'visibleWhen': {'property': 'leadingIcon', 'operator': 'present'},
      },
      {'id': 'label', 'kind': 'slot', 'slot': 'label', 'children': <Object?>[]},
      {
        'id': 'trailingIcon',
        'kind': 'slot',
        'slot': 'trailingIcon',
        'children': <Object?>[],
        'visibleWhen': {'property': 'trailingIcon', 'operator': 'present'},
      },
      {
        'id': 'spinner',
        'kind': 'slot',
        'slot': 'spinner',
        'children': <Object?>[],
        'visibleWhen': {
          'property': 'loading',
          'operator': 'equals',
          'value': true,
        },
      },
    ],
  },
  'recipes': recipes ?? [portableButtonRecipe(id: 'solid-size1')],
  'semantics': {
    'role': 'button',
    'labelProperty': 'label',
    'enabledProperty': 'enabled',
    'loadingProperty': 'loading',
  },
  'oracles': [
    {
      'theme': 'light',
      'image': 'light/button.png',
      'metadata': 'light/button.json',
      'evidence': 'rendered',
    },
    {
      'theme': 'dark',
      'image': 'dark/button.png',
      'metadata': 'dark/button.json',
      'evidence': 'rendered',
    },
  ],
};

Map<String, Object?> portableButtonRecipe({
  required String id,
  String variant = 'solid',
  String size = 'size1',
}) => {
  'id': id,
  'properties': {'variant': variant, 'size': size},
  'styles': {
    'container': _supportedStyle('styles/button/$id/container.mix.json'),
    'label': _supportedStyle('styles/button/$id/label.mix.json'),
    'leadingIcon': _supportedStyle('styles/button/$id/icon.mix.json'),
    'trailingIcon': _supportedStyle('styles/button/$id/icon.mix.json'),
    'spinner': {
      'status': 'unsupported',
      'evidence': 'declared',
      'diagnostics': [
        {
          'code': 'unsupported_slot_primitive',
          'severity': 'error',
          'path': 'spinner',
          'message': 'RemixSpinner has no neutral Mix protocol primitive.',
        },
      ],
    },
  },
};

Map<String, Object?> _supportedStyle(String document) => {
  'status': 'supported',
  'evidence': 'declared',
  'document': document,
};

final class MemoryArtifactSource implements ArtifactSource {
  const MemoryArtifactSource(this.files);

  final Map<String, Uint8List> files;

  @override
  Future<ResolvedArtifactSource> resolve(
    ArtifactRepositoryRequest request,
  ) async {
    return _ResolvedMemoryArtifactSource(files);
  }
}

final class _ResolvedMemoryArtifactSource implements ResolvedArtifactSource {
  const _ResolvedMemoryArtifactSource(this.files);

  final Map<String, Uint8List> files;

  @override
  ArtifactSourceReceipt get receipt => const ArtifactSourceReceipt(
    repository: 'btwld/remix',
    requestedRef: 'main',
    resolvedCommit: fixtureCommit,
  );

  @override
  Future<Uint8List> read(
    String repositoryRelativePath, {
    required int maxBytes,
  }) async {
    final bytes = files[repositoryRelativePath];
    if (bytes == null) {
      throw ArtifactLoadException(
        ArtifactFailureKind.notFound,
        'Fixture file not found.',
        path: repositoryRelativePath,
        statusCode: 404,
      );
    }
    if (bytes.length > maxBytes) {
      throw ArtifactLoadException(
        ArtifactFailureKind.sourceRejected,
        'Fixture file exceeds the read limit.',
        path: repositoryRelativePath,
      );
    }

    return bytes;
  }
}

Uint8List _atlasMetadata(
  String theme,
  String label, {
  String component = 'button',
  String componentLabel = 'Button',
}) => _jsonBytes({
  'schema': 'mix_atlas/atlas/v1',
  'component': component,
  'componentLabel': componentLabel,
  'theme': theme,
  'themeLabel': label,
  'brightness': theme,
  'file': '$component.png',
  'rowAxes': [
    {'id': 'variant', 'label': 'Variant'},
  ],
  'rows': [
    {
      'id': 'solid',
      'values': {
        'variant': {'id': 'solid', 'label': 'Solid'},
      },
    },
  ],
  'columns': [
    {'id': 'default', 'label': 'Default'},
  ],
});

Uint8List _theme(String accent) => _jsonBytes({
  'v': 1,
  'type': 'theme',
  'colors': {'fortal.accent.9': accent},
  'spaces': {'fortal.space.2': 8.0},
});

Uint8List _jsonBytes(Object? value) =>
    Uint8List.fromList(utf8.encode(jsonEncode(value)));

final _onePixelPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJ'
  'AAAADUlEQVR42mNk+M/wHwAF/gL+X2NDWQAAAABJRU5ErkJggg==',
);
