import 'package:ack/ack.dart';

import 'mix_schema_error.dart';

List<MixSchemaError> mapSchemaError(SchemaError error) {
  final errors = <MixSchemaError>[];

  void flatten(SchemaError current) {
    if (current is SchemaNestedError) {
      for (final child in current.errors) {
        flatten(child);
      }

      return;
    }

    errors.add(_mapSingleSchemaError(current));
  }

  flatten(error);
  errors.sort((a, b) => a.path.compareTo(b.path));

  return errors;
}

MixSchemaError _mapSingleSchemaError(SchemaError error) {
  final cause = error.cause;
  if (cause is UnsupportedEncodeValueError) {
    return MixSchemaError(
      code: MixSchemaErrorCode.unsupportedEncodeValue,
      path: _normalizePath(error.path),
      message: cause.reason,
      value: cause.value,
    );
  }
  if (cause is InvalidTokenNameError) {
    return MixSchemaError(
      code: MixSchemaErrorCode.invalidTokenName,
      path: _normalizePath(error.path),
      message: cause.reason,
      value: cause.name,
    );
  }
  if (cause is SchemaInventorySkewError) {
    return MixSchemaError(
      code: MixSchemaErrorCode.inventorySkew,
      path: _normalizePath(error.path),
      message: cause.toString(),
      value: cause.toJson(),
    );
  }
  if (cause is UnknownRegistryIdError) {
    return MixSchemaError(
      code: MixSchemaErrorCode.unknownRegistryId,
      path: _normalizePath(error.path),
      message: cause.toString(),
      value: cause.id,
    );
  }
  if (cause is UnknownRegistryValueError) {
    return MixSchemaError(
      code: MixSchemaErrorCode.unknownRegistryValue,
      path: _normalizePath(error.path),
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
    path: _normalizePath(error.path),
    message: error.message,
    value: error.value,
  );
}

String _normalizePath(String path) {
  if (path.startsWith('#/')) return path.substring(1);
  if (path == '#') return '';

  return path;
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
