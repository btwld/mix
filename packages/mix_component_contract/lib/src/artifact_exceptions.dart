/// Failure categories emitted while loading portable component artifacts.
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

/// Structured failure raised for an invalid portable component artifact.
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
