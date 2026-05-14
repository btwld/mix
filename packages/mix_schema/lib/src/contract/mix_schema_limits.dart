import '../core/json_map.dart';
import '../errors/mix_schema_error.dart';

/// Structural safety limits applied at the schema contract boundary.
final class MixSchemaLimits {
  final int maxDepth;
  final int maxListLength;
  final int maxStringLength;
  final int maxRegistryIdLength;
  final int maxVariantsPerStyler;
  final int maxModifiersPerStyler;

  const MixSchemaLimits({
    this.maxDepth = 32,
    this.maxListLength = 256,
    this.maxStringLength = 4096,
    this.maxRegistryIdLength = 256,
    this.maxVariantsPerStyler = 64,
    this.maxModifiersPerStyler = 64,
  });

  Map<String, int> toJson() {
    return {
      'maxDepth': maxDepth,
      'maxListLength': maxListLength,
      'maxStringLength': maxStringLength,
      'maxRegistryIdLength': maxRegistryIdLength,
      'maxVariantsPerStyler': maxVariantsPerStyler,
      'maxModifiersPerStyler': maxModifiersPerStyler,
    };
  }
}

List<MixSchemaError> validatePayloadLimits(
  JsonMap payload,
  MixSchemaLimits limits,
) {
  final errors = <MixSchemaError>[];
  _visitPayload(payload, path: '#', depth: 1, limits: limits, errors: errors);

  return List<MixSchemaError>.unmodifiable(errors);
}

void _visitPayload(
  Object? value, {
  required String path,
  required int depth,
  required MixSchemaLimits limits,
  required List<MixSchemaError> errors,
}) {
  if (errors.isNotEmpty) return;

  if (depth > limits.maxDepth) {
    errors.add(
      _limitError(
        path: path,
        message: 'Payload exceeds maximum depth of ${limits.maxDepth}.',
        value: value,
      ),
    );

    return;
  }

  switch (value) {
    case String():
      if (value.length > limits.maxStringLength) {
        errors.add(
          _limitError(
            path: path,
            message:
                'String exceeds maximum length of ${limits.maxStringLength}.',
            value: value,
          ),
        );
      }
    case List<Object?>():
      _validateListLength(value, path: path, limits: limits, errors: errors);
      if (errors.isNotEmpty) return;
      for (var i = 0; i < value.length; i += 1) {
        _visitPayload(
          value[i],
          path: '$path/$i',
          depth: depth + 1,
          limits: limits,
          errors: errors,
        );
        if (errors.isNotEmpty) return;
      }
    case Map<String, Object?>():
      for (final entry in value.entries) {
        _visitPayload(
          entry.value,
          path: '$path/${_escapePath(entry.key)}',
          depth: depth + 1,
          limits: limits,
          errors: errors,
        );
        if (errors.isNotEmpty) return;
      }
    case Map():
      for (final entry in value.entries) {
        _visitPayload(
          entry.value,
          path: '$path/${_escapePath('${entry.key}')}',
          depth: depth + 1,
          limits: limits,
          errors: errors,
        );
        if (errors.isNotEmpty) return;
      }
  }
}

void _validateListLength(
  List<Object?> value, {
  required String path,
  required MixSchemaLimits limits,
  required List<MixSchemaError> errors,
}) {
  final maxLength = switch (_lastPathSegment(path)) {
    'variants' => limits.maxVariantsPerStyler,
    'modifiers' || 'modifierOrder' => limits.maxModifiersPerStyler,
    _ => limits.maxListLength,
  };
  if (value.length <= maxLength) return;

  errors.add(
    _limitError(
      path: path,
      message: 'List exceeds maximum length of $maxLength.',
      value: value,
    ),
  );
}

MixSchemaError _limitError({
  required String path,
  required String message,
  required Object? value,
}) {
  return MixSchemaError(
    code: .payloadLimitExceeded,
    path: path,
    message: message,
    value: value,
  );
}

String _escapePath(String segment) {
  return segment.replaceAll('~', '~0').replaceAll('/', '~1');
}

String _lastPathSegment(String path) {
  final index = path.lastIndexOf('/');

  return index == -1 ? path : path.substring(index + 1);
}
