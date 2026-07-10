import 'package:ack/ack.dart';

import 'mix_protocol_error.dart';

List<MixProtocolError> mapSchemaError(SchemaError error) {
  final errors = <MixProtocolError>[];

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

MixProtocolError _mapSingleSchemaError(
  SchemaError error, {
  String? pathPrefix,
}) {
  final path = _joinErrorPaths(pathPrefix, error.path);
  final cause = error.cause;
  if (cause is SchemaPathError) {
    return MixProtocolError(
      code: cause.code,
      path: _joinErrorPaths(path, cause.relativePath),
      message: cause.reason,
      value: cause.value,
    );
  }
  if (cause is UnsupportedEncodeValueError) {
    return MixProtocolError(
      code: MixProtocolErrorCode.unsupportedEncodeValue,
      path: path,
      message: cause.reason,
      value: cause.value,
    );
  }
  if (cause is InvalidTokenNameError) {
    return MixProtocolError(
      code: MixProtocolErrorCode.invalidTokenName,
      path: path,
      message: cause.reason,
      value: cause.name,
    );
  }
  if (cause is SchemaInventorySkewError) {
    return MixProtocolError(
      code: MixProtocolErrorCode.inventorySkew,
      path: path,
      message: cause.toString(),
      value: cause.toJson(),
    );
  }
  if (cause is UnresolvedIdentityNameError) {
    return MixProtocolError(
      code: MixProtocolErrorCode.unresolvedIdentityName,
      path: path,
      message: cause.toString(),
      value: cause.name,
    );
  }
  if (cause is UnresolvedIdentityValueError) {
    return MixProtocolError(
      code: MixProtocolErrorCode.unresolvedIdentityValue,
      path: path,
      message: cause.toString(),
      value: cause.value,
    );
  }
  final code = switch (error) {
    TypeMismatchError() => MixProtocolErrorCode.typeMismatch,
    SchemaTransformError() => MixProtocolErrorCode.transformFailed,
    SchemaEncodeError(kind: final kind) => switch (kind) {
      SchemaEncodeFailureKind.nonNullable => MixProtocolErrorCode.requiredField,
      SchemaEncodeFailureKind.typeMismatch => MixProtocolErrorCode.typeMismatch,
      SchemaEncodeFailureKind.oneWayTransform =>
        MixProtocolErrorCode.unsupportedEncodeValue,
      SchemaEncodeFailureKind.encoderThrew =>
        MixProtocolErrorCode.unsupportedEncodeValue,
      SchemaEncodeFailureKind.missingRequiredProperty =>
        MixProtocolErrorCode.requiredField,
      SchemaEncodeFailureKind.unexpectedProperty =>
        MixProtocolErrorCode.unknownField,
    },
    SchemaConstraintsError(:final constraints) => _mapConstraintCode(
      constraints,
      error.path,
      error.name,
    ),
    SchemaValidationError() => MixProtocolErrorCode.validationFailed,
    _ => MixProtocolErrorCode.validationFailed,
  };

  return MixProtocolError(
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

MixProtocolErrorCode _mapConstraintCode(
  List<ConstraintError> constraints,
  String path,
  String name,
) {
  final keys = constraints.map((e) => e.constraint.constraintKey).toSet();
  if (keys.contains('object_required_property_missing') ||
      keys.contains('core_non_nullable')) {
    return MixProtocolErrorCode.requiredField;
  }
  if (keys.contains('object_additional_properties_disallowed')) {
    return MixProtocolErrorCode.unknownField;
  }
  final isEnumConstraint =
      keys.contains('string_enum') || keys.contains('enum_value');
  if (isEnumConstraint &&
      (path == '/type' || path == 'type' || name == 'type')) {
    return MixProtocolErrorCode.unknownType;
  }
  if (isEnumConstraint) {
    return MixProtocolErrorCode.invalidEnum;
  }
  if (keys.contains('mix_protocol_token_name')) {
    return MixProtocolErrorCode.invalidTokenName;
  }
  if (keys.contains('core_invalid_type')) {
    return MixProtocolErrorCode.typeMismatch;
  }

  return MixProtocolErrorCode.constraintViolation;
}
