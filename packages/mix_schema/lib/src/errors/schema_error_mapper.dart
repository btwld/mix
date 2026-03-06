import 'package:ack/ack.dart';

import 'mix_schema_error.dart';
import 'mix_schema_error_code.dart';
import 'schema_transform_exceptions.dart';

final class SchemaErrorMapper {
  const SchemaErrorMapper();

  void _collect(SchemaError error, List<MixSchemaError> results) {
    switch (error) {
      case SchemaNestedError():
        for (final nested in error.errors) {
          _collect(nested, results);
        }
      case TypeMismatchError():
        results.add(
          MixSchemaError(
            code: .typeMismatch,
            path: error.path,
            message: error.message,
            value: error.value,
          ),
        );
      case SchemaConstraintsError():
        for (final constraint in error.constraints) {
          results.add(
            MixSchemaError(
              code: _mapConstraint(error.path, constraint.constraintKey),
              path: error.path,
              message: constraint.message,
              value: error.value,
            ),
          );
        }
      case SchemaValidationError():
        results.add(
          MixSchemaError(
            code: .validationFailed,
            path: error.path,
            message: error.message,
            value: error.value,
          ),
        );
      case SchemaTransformError():
        results.add(_mapTransformError(error));
      default:
        results.add(
          MixSchemaError(
            code: .validationFailed,
            path: error.path,
            message: error.message,
            value: error.value,
          ),
        );
    }
  }

  MixSchemaError _mapTransformError(SchemaTransformError error) {
    final cause = error.cause;
    final code = switch (cause) {
      RegistryLookupError() => MixSchemaErrorCode.unknownRegistryId,
      RegistryTypeMismatchError() => MixSchemaErrorCode.transformFailed,
      UnsupportedValueError() => MixSchemaErrorCode.unsupportedValueType,
      _ => MixSchemaErrorCode.transformFailed,
    };

    return MixSchemaError(
      code: code,
      path: error.path,
      message: cause?.toString() ?? error.message,
      value: error.value,
    );
  }

  MixSchemaErrorCode _mapConstraint(String path, String constraintKey) {
    if (_isDiscriminatorPath(path) &&
        (constraintKey == 'string_enum' || constraintKey == 'enum_value')) {
      return .unknownType;
    }

    return switch (constraintKey) {
      'object_required_property_missing' => .requiredField,
      'object_additional_properties_disallowed' => .unknownField,
      'string_enum' || 'enum_value' => .invalidEnum,
      _ => .constraintViolation,
    };
  }

  bool _isDiscriminatorPath(String path) {
    return path == '#/type' || path.endsWith('/type');
  }

  List<MixSchemaError> map(SchemaError error) {
    final results = <MixSchemaError>[];
    _collect(error, results);
    results.sort((left, right) {
      final pathComparison = left.path.compareTo(right.path);
      if (pathComparison != 0) {
        return pathComparison;
      }

      return left.code.wireValue.compareTo(right.code.wireValue);
    });

    return List<MixSchemaError>.unmodifiable(results);
  }
}
