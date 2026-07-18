import 'dart:convert';
import 'dart:typed_data';

import 'artifact_exceptions.dart';

const _maxJsonBytes = 2 * 1024 * 1024;

/// Decodes a UTF-8 JSON object with the component-contract size limit.
Map<String, Object?> decodeJsonObject(Uint8List bytes, {required String path}) {
  if (bytes.length > _maxJsonBytes) {
    throw ArtifactLoadException(
      .malformedJson,
      'JSON artifact exceeds the byte limit.',
      path: path,
    );
  }

  try {
    final decoded = jsonDecode(utf8.decode(bytes, allowMalformed: false));
    if (decoded is! Map) {
      throw ArtifactLoadException(
        .malformedJson,
        'Expected a JSON object.',
        path: path,
      );
    }

    return decoded.cast();
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

/// Rejects absolute, escaped, or non-normalized artifact paths.
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
