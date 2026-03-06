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
        results.addAll(_mapTransformErrors(error));
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

  Iterable<MixSchemaError> _mapTransformErrors(SchemaTransformError error) {
    final cause = error.cause;
    switch (cause) {
      case NestedSchemaErrorsException():
        return cause.errors.map((nestedError) {
          return MixSchemaError(
            code: nestedError.code,
            path: _prefixPath(error.path, nestedError.path),
            message: nestedError.message,
            value: nestedError.value,
          );
        });
      case RegistryLookupError():
        return [
          MixSchemaError(
            code: MixSchemaErrorCode.unknownRegistryId,
            path: error.path,
            message: cause.toString(),
            value: error.value,
          ),
        ];
      case RegistryTypeMismatchError():
        return [
          MixSchemaError(
            code: MixSchemaErrorCode.transformFailed,
            path: error.path,
            message: cause.toString(),
            value: error.value,
          ),
        ];
      case UnsupportedValueError():
        return [
          MixSchemaError(
            code: MixSchemaErrorCode.unsupportedValueType,
            path: error.path,
            message: cause.toString(),
            value: error.value,
          ),
        ];
      default:
        return [
          MixSchemaError(
            code: MixSchemaErrorCode.transformFailed,
            path: error.path,
            message: cause?.toString() ?? error.message,
            value: error.value,
          ),
        ];
    }
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

  String _prefixPath(String prefix, String nestedPath) {
    if (nestedPath == '#') {
      return prefix;
    }

    if (prefix == '#') {
      return nestedPath;
    }

    return '$prefix${nestedPath.substring(1)}';
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
