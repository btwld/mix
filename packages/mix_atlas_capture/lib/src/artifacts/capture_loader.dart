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
        _validateComponentDocument(
          document,
          entry: entry,
          component: component,
          manifest: manifest,
          styleDocuments: styleDocuments,
        );
        componentDocuments.add(document);
      }
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

void _validateComponentDocument(
  PortableComponentDocument document, {
  required CaptureComponentDocumentEntry entry,
  required CapturedComponent component,
  required CaptureManifest manifest,
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
        .flexBox => style is FlexBoxStyler,
        .text => style is TextStyler,
        .icon => style is IconStyler,
        .spinner => false,
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
