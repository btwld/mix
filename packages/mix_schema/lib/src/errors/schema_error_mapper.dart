import 'package:ack/ack.dart';

import 'mix_schema_error.dart';

List<MixSchemaError> mapSchemaError(SchemaError error) {
  final errors = <MixSchemaError>[];

  void flatten(SchemaError current, {String? pathPrefix}) {
    if (current is SchemaNestedError) {
      for (final child in current.errors) {
        flatten(child, pathPrefix: pathPrefix);
      }

      return;
    }

    if ((current is SchemaTransformError || current is SchemaEncodeError) &&
        current.cause is SchemaError) {
      final nestedPrefix = _joinErrorPaths(pathPrefix, current.path);
      flatten(current.cause! as SchemaError, pathPrefix: nestedPrefix);

      return;
    }

    errors.add(_mapSingleSchemaError(current, pathPrefix: pathPrefix));
  }

  flatten(error);
  errors.sort((a, b) => a.path.compareTo(b.path));

  return errors;
}

MixSchemaError _mapSingleSchemaError(SchemaError error, {String? pathPrefix}) {
  final path = _joinErrorPaths(pathPrefix, error.path);
  final cause = error.cause;
  if (cause is SchemaPathError) {
    return MixSchemaError(
      code: cause.code,
      path: _joinErrorPaths(path, cause.relativePath),
      message: cause.reason,
      value: cause.value,
    );
  }
  if (cause is UnsupportedEncodeValueError) {
    return MixSchemaError(
      code: MixSchemaErrorCode.unsupportedEncodeValue,
      path: path,
      message: cause.reason,
      value: cause.value,
    );
  }
  if (cause is InvalidTokenNameError) {
    return MixSchemaError(
      code: MixSchemaErrorCode.invalidTokenName,
      path: path,
      message: cause.reason,
      value: cause.name,
    );
  }
  if (cause is SchemaInventorySkewError) {
    return MixSchemaError(
      code: MixSchemaErrorCode.inventorySkew,
      path: path,
      message: cause.toString(),
      value: cause.toJson(),
    );
  }
  if (cause is UnresolvedIdentityNameError) {
    return MixSchemaError(
      code: MixSchemaErrorCode.unresolvedIdentityName,
      path: path,
      message: cause.toString(),
      value: cause.name,
    );
  }
  if (cause is UnresolvedIdentityValueError) {
    return MixSchemaError(
      code: MixSchemaErrorCode.unresolvedIdentityValue,
      path: path,
      message: cause.toString(),
      value: cause.value,
    );
  }
  if (cause is UnknownRegistryIdError) {
    return MixSchemaError(
      code: MixSchemaErrorCode.unresolvedIdentityName,
      path: path,
      message: cause.toString(),
      value: cause.id,
    );
  }
  if (cause is UnknownRegistryValueError) {
    return MixSchemaError(
      code: MixSchemaErrorCode.unresolvedIdentityValue,
      path: path,
      message: cause.toString(),
      value: cause.value,
    );
  }

  final code = switch (error) {
    TypeMismatchError() => MixSchemaErrorCode.typeMismatch,
    SchemaTransformError() => MixSchemaErrorCode.transformFailed,
    SchemaEncodeError(kind: final kind) => switch (kind) {
      SchemaEncodeFailureKind.nonNullable => MixSchemaErrorCode.requiredField,
      SchemaEncodeFailureKind.typeMismatch => MixSchemaErrorCode.typeMismatch,
      SchemaEncodeFailureKind.oneWayTransform =>
        MixSchemaErrorCode.unsupportedEncodeValue,
      SchemaEncodeFailureKind.encoderThrew =>
        MixSchemaErrorCode.unsupportedEncodeValue,
      SchemaEncodeFailureKind.missingRequiredProperty =>
        MixSchemaErrorCode.requiredField,
      SchemaEncodeFailureKind.unexpectedProperty =>
        MixSchemaErrorCode.unknownField,
    },
    SchemaConstraintsError(:final constraints) => _mapConstraintCode(
      constraints,
      error.path,
      error.name,
    ),
    SchemaValidationError() => MixSchemaErrorCode.validationFailed,
    _ => MixSchemaErrorCode.validationFailed,
  };

  return MixSchemaError(
    code: code,
    path: path,
    message: error.message,
    value: error.value,
  );
}

String _normalizePath(String path) {
  if (path.startsWith('#/')) return path.substring(1);
  if (path == '#') return '';

  return path;
}

String _joinErrorPaths(String? prefix, String path) {
  final normalizedPath = _normalizePath(path);
  if (prefix == null || prefix.isEmpty) return normalizedPath;
  final normalizedPrefix = _normalizePath(prefix);
  if (normalizedPath.isEmpty) return normalizedPrefix;
  if (normalizedPath == normalizedPrefix ||
      normalizedPath.startsWith('$normalizedPrefix/')) {
    return normalizedPath;
  }

  return '$normalizedPrefix$normalizedPath';
}

MixSchemaErrorCode _mapConstraintCode(
  List<ConstraintError> constraints,
  String path,
  String name,
) {
  final keys = constraints.map((e) => e.constraint.constraintKey).toSet();
  if (keys.contains('object_required_property_missing') ||
      keys.contains('core_non_nullable')) {
    return MixSchemaErrorCode.requiredField;
  }
  if (keys.contains('object_additional_properties_disallowed')) {
    return MixSchemaErrorCode.unknownField;
  }
  final isEnumConstraint =
      keys.contains('string_enum') || keys.contains('enum_value');
  if (isEnumConstraint &&
      (path == '/type' || path == 'type' || name == 'type')) {
    return MixSchemaErrorCode.unknownType;
  }
  if (isEnumConstraint) {
    return MixSchemaErrorCode.invalidEnum;
  }
  if (keys.contains('mix_schema_token_name')) {
    return MixSchemaErrorCode.invalidTokenName;
  }
  if (keys.contains('core_invalid_type')) {
    return MixSchemaErrorCode.typeMismatch;
  }

  return MixSchemaErrorCode.constraintViolation;
}
