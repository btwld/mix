enum MixSchemaErrorCode {
  unknownField('unknown_field'),
  unsupportedSchemaVersion('unsupported_schema_version'),
  unknownRegistryId('unknown_registry_id'),
  invalidValue('invalid_value'),
  unsupportedStylerType('unsupported_styler_type'),
  unsupportedMetadata('unsupported_metadata');

  const MixSchemaErrorCode(this.code);
  final String code;
}

final class MixSchemaError implements Comparable<MixSchemaError> {
  final String code;
  final String path;
  final String message;
  final Object? value;

  const MixSchemaError({
    required this.code,
    required this.path,
    required this.message,
    this.value,
  });

  factory MixSchemaError.fromCode({
    required MixSchemaErrorCode code,
    required String path,
    required String message,
    Object? value,
  }) {
    return MixSchemaError(
      code: code.code,
      path: path,
      message: message,
      value: value,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'code': code,
      'path': path,
      'message': message,
      if (value != null) 'value': value,
    };
  }

  @override
  int compareTo(MixSchemaError other) {
    final pathCompare = path.compareTo(other.path);
    if (pathCompare != 0) return pathCompare;

    return code.compareTo(other.code);
  }
}
