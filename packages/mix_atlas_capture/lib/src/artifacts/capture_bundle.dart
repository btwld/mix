import 'dart:typed_data';

import 'package:mix_protocol/mix_protocol.dart';

import 'component_document.dart';

enum ArtifactFailureKind {
  invalidRequest,
  network,
  rateLimited,
  notFound,
  sourceRejected,
  malformedJson,
  unsupportedSchema,
  unsafePath,
  integrity,
  invalidCatalog,
  invalidComponent,
  invalidProtocol,
}

enum ArtifactSourceKind { local, github }

final class ArtifactLoadException implements Exception {
  final ArtifactFailureKind kind;

  final String message;
  final String? path;
  final int? statusCode;
  final Object? cause;
  const ArtifactLoadException(
    this.kind,
    this.message, {
    this.path,
    this.statusCode,
    this.cause,
  });

  @override
  String toString() {
    final location = path == null ? '' : ' ($path)';

    return 'ArtifactLoadException.${kind.name}$location: $message';
  }
}

final class ArtifactRepositoryRequest {
  final String repository;

  final String ref;
  final String manifestPath;
  const ArtifactRepositoryRequest({
    required this.repository,
    required this.ref,
    required this.manifestPath,
  });
}

final class ArtifactSourceReceipt {
  final String repository;

  final String requestedRef;
  final String resolvedCommit;
  final ArtifactSourceKind kind;
  const ArtifactSourceReceipt({
    required this.repository,
    required this.requestedRef,
    required this.resolvedCommit,
    this.kind = ArtifactSourceKind.github,
  });
}

final class CaptureProducer {
  final String atlasVersion;

  final String mixProtocolVersion;
  final int mixProtocolFormat;
  final String flutterVersion;
  const CaptureProducer({
    required this.atlasVersion,
    required this.mixProtocolVersion,
    required this.mixProtocolFormat,
    required this.flutterVersion,
  });
}

final class CaptureFileEntry {
  final String path;

  final String sha256;
  final int bytes;
  const CaptureFileEntry({
    required this.path,
    required this.sha256,
    required this.bytes,
  });
}

final class CaptureThemeEntry {
  final String id;

  final String documentPath;
  const CaptureThemeEntry({required this.id, required this.documentPath});
}

final class CaptureComponentDocumentEntry {
  final String id;

  final String documentPath;
  const CaptureComponentDocumentEntry({
    required this.id,
    required this.documentPath,
  });
}

final class CaptureManifest {
  final String id;

  final int schemaVersion;
  final CaptureProducer producer;
  final String catalogPath;
  final List<CaptureThemeEntry> themes;
  final List<CaptureComponentDocumentEntry> componentDocuments;
  final String protocolCoveragePath;
  final Map<String, CaptureFileEntry> files;
  CaptureManifest({
    required this.id,
    required this.schemaVersion,
    required this.producer,
    required this.catalogPath,
    required this.themes,
    required this.componentDocuments,
    required this.protocolCoveragePath,
    required Map<String, CaptureFileEntry> files,
  }) : files = Map.unmodifiable(files);
}

final class CapturedCatalogTheme {
  final String id;

  final String label;
  final String brightness;
  const CapturedCatalogTheme({
    required this.id,
    required this.label,
    required this.brightness,
  });
}

final class CapturedComponentAsset {
  final String themeId;

  final String imagePath;
  final String metadataPath;
  const CapturedComponentAsset({
    required this.themeId,
    required this.imagePath,
    required this.metadataPath,
  });
}

final class CapturedComponent {
  final String id;

  final String label;
  final Map<String, CapturedComponentAsset> assets;
  CapturedComponent({
    required this.id,
    required this.label,
    required Map<String, CapturedComponentAsset> assets,
  }) : assets = Map.unmodifiable(assets);
}

final class CapturedCatalog {
  final String id;

  final String label;
  final List<CapturedCatalogTheme> themes;
  final List<CapturedComponent> components;
  const CapturedCatalog({
    required this.id,
    required this.label,
    required this.themes,
    required this.components,
  });
}

final class CapturedAtlasMetadata {
  final String componentId;

  final String themeId;
  final List<CapturedAtlasAxis> rowAxes;
  final List<CapturedAtlasRow> rows;
  final List<CapturedAtlasScenario> scenarios;
  final int rowCount;
  final int columnCount;
  CapturedAtlasMetadata({
    required this.componentId,
    required this.themeId,
    List<CapturedAtlasAxis> rowAxes = const [],
    List<CapturedAtlasRow> rows = const [],
    List<CapturedAtlasScenario> scenarios = const [],
    required this.rowCount,
    required this.columnCount,
  }) : rowAxes = List.unmodifiable(rowAxes),
       rows = List.unmodifiable(rows),
       scenarios = List.unmodifiable(scenarios);
}

final class CapturedAtlasAxis {
  final String id;
  final String label;

  const CapturedAtlasAxis({required this.id, required this.label});
}

final class CapturedAtlasAxisValue {
  final String id;
  final String label;

  const CapturedAtlasAxisValue({required this.id, required this.label});
}

final class CapturedAtlasRow {
  final String id;
  final String? label;
  final Map<String, CapturedAtlasAxisValue> values;

  CapturedAtlasRow({
    required this.id,
    this.label,
    required Map<String, CapturedAtlasAxisValue> values,
  }) : values = Map.unmodifiable(values);
}

final class CapturedAtlasScenario {
  final String id;
  final String? label;
  final Set<String> widgetStates;
  final Map<String, Object?> properties;

  CapturedAtlasScenario({
    required this.id,
    this.label,
    required Set<String> widgetStates,
    required Map<String, Object?> properties,
  }) : widgetStates = Set.unmodifiable(widgetStates),
       properties = Map.unmodifiable(properties);
}

final class ProtocolDiagnostic {
  final String probeId;

  final String code;
  final String severity;
  final String path;
  final String message;
  const ProtocolDiagnostic({
    required this.probeId,
    required this.code,
    required this.severity,
    required this.path,
    required this.message,
  });
}

final class ProtocolCoverageItem {
  final String id;

  final String kind;
  final String status;
  final List<ProtocolDiagnostic> diagnostics;
  const ProtocolCoverageItem({
    required this.id,
    required this.kind,
    required this.status,
    required this.diagnostics,
  });
}

final class ProtocolCoverageSummary {
  final String protocolVersion;

  final int protocolFormat;
  final List<ProtocolCoverageItem> items;
  const ProtocolCoverageSummary({
    required this.protocolVersion,
    required this.protocolFormat,
    required this.items,
  });

  int get supportedCount =>
      items.where((item) => item.status == 'supported').length;

  int get unsupportedCount =>
      items.where((item) => item.status == 'unsupported').length;

  Iterable<ProtocolDiagnostic> get diagnostics =>
      items.expand((item) => item.diagnostics);
}

final class LoadedCapture {
  final ArtifactSourceReceipt receipt;

  final CaptureManifest manifest;
  final CapturedCatalog catalog;
  final ProtocolCoverageSummary protocolCoverage;
  final Map<String, Uint8List> files;
  final Map<String, int> themeTokenCounts;
  final Map<String, MixProtocolTheme> protocolThemes;
  final List<PortableComponentDocument> componentDocuments;
  final Map<String, Object> styleDocuments;
  final Map<String, CapturedAtlasMetadata> atlasMetadata;
  final int validatedStyleDocumentCount;
  LoadedCapture({
    required this.receipt,
    required this.manifest,
    required this.catalog,
    required this.protocolCoverage,
    required Map<String, Uint8List> files,
    required Map<String, int> themeTokenCounts,
    required Map<String, MixProtocolTheme> protocolThemes,
    required List<PortableComponentDocument> componentDocuments,
    required Map<String, Object> styleDocuments,
    required Map<String, CapturedAtlasMetadata> atlasMetadata,
    required this.validatedStyleDocumentCount,
  }) : files = Map.unmodifiable(files),
       themeTokenCounts = Map.unmodifiable(themeTokenCounts),
       protocolThemes = Map.unmodifiable(protocolThemes),
       componentDocuments = List.unmodifiable(componentDocuments),
       styleDocuments = Map.unmodifiable(styleDocuments),
       atlasMetadata = Map.unmodifiable(atlasMetadata);

  Uint8List file(String path) {
    final value = files[path];
    if (value == null) {
      throw ArtifactLoadException(
        .integrity,
        'The validated capture does not contain the requested file.',
        path: path,
      );
    }

    return value;
  }
}
