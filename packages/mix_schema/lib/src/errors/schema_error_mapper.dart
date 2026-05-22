import 'package:ack/ack.dart';

import '../core/branch_codec.dart' show kUnsupportedBranchSubtypePrefix;
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
        results.add(_mapValidationError(error));
      case SchemaTransformError():
        results.addAll(_mapTransformErrors(error));
      case SchemaEncodeError():
        results.add(_mapEncodeError(error));
      default:
        results.add(
          _mapValidationMessage(
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
      case RegistryLookupError():
        return [
          MixSchemaError(
            code: .unknownRegistryId,
            path: error.path,
            message: cause.toString(),
            value: error.value,
          ),
        ];
      case RegistryTypeMismatchError():
        return [
          MixSchemaError(
            code: .transformFailed,
            path: error.path,
            message: cause.toString(),
            value: error.value,
          ),
        ];
      case RegistryValueLookupError():
        return [
          MixSchemaError(
            code: .unknownRegistryValue,
            path: error.path,
            message: cause.toString(),
            value: cause.value,
          ),
        ];
      case UnsupportedError():
        return [
          MixSchemaError(
            code: .transformFailed,
            path: error.path,
            message: cause.message ?? cause.toString(),
            value: error.value,
          ),
        ];
      default:
        return [
          MixSchemaError(
            code: .transformFailed,
            path: error.path,
            message: cause?.toString() ?? error.message,
            value: error.value,
          ),
        ];
    }
  }

  MixSchemaError _mapValidationError(SchemaValidationError error) {
    return _mapValidationMessage(
      path: error.path,
      message: error.message,
      value: error.value,
    );
  }

  MixSchemaError _mapEncodeError(SchemaEncodeError error) {
    final cause = error.cause;

    return switch (cause) {
      RegistryValueLookupError() => MixSchemaError(
        code: .unknownRegistryValue,
        path: error.path,
        message: cause.toString(),
        value: cause.value,
      ),
      UnsupportedEncodeValueError()
          when _isRequiredEncodeMessage(cause.reason) =>
        MixSchemaError(
          code: .requiredField,
          path: error.path,
          message: cause.toString(),
          value: cause.value ?? error.value,
        ),
      UnsupportedEncodeValueError() => MixSchemaError(
        code: .unsupportedEncodeValue,
        path: error.path,
        message: cause.toString(),
        value: cause.value ?? error.value,
      ),
      UnsupportedError() => MixSchemaError(
        code: .unsupportedEncodeValue,
        path: error.path,
        message: cause.message ?? cause.toString(),
        value: error.value,
      ),
      ArgumentError() => MixSchemaError(
        code: .unsupportedEncodeValue,
        path: error.path,
        message: cause.message ?? cause.toString(),
        value: error.value,
      ),
      _ => _mapValidationMessage(
        path: error.path,
        message: error.message,
        value: error.value,
      ),
    };
  }

  // Bridge for Ack `SchemaValidationError`s whose `message` carries an
  // encoder failure that was not surfaced as a typed `SchemaEncodeError.cause`.
  // The typed encode-path already covers `RegistryValueLookupError`,
  // `UnsupportedEncodeValueError`, `UnsupportedError`, and `ArgumentError`; the
  // string prefixes below stay as defensive carve-outs for nested encoders
  // whose throws Ack re-wraps as validation messages during input revalidation,
  // plus the [kUnsupportedBranchSubtypePrefix] sentinel from `branch_codec.dart`
  // for failed branch refinements on the encode path.
  MixSchemaError _mapValidationMessage({
    required String path,
    required String message,
    required Object? value,
  }) {
    if (message.startsWith('Encoder threw: No registry id found')) {
      return MixSchemaError(
        code: .unknownRegistryValue,
        path: path,
        message: message,
        value: value,
      );
    }

    if (_isRequiredEncodeMessage(message) ||
        (message.startsWith('Encoder threw:') &&
            message.contains('Field "') &&
            message.contains('" is required.'))) {
      return MixSchemaError(
        code: .requiredField,
        path: path,
        message: message,
        value: value,
      );
    }

    if (message.startsWith('Encoder threw: Unsupported operation:') ||
        message.startsWith('Encoder threw: Invalid argument(s):') ||
        message.startsWith(kUnsupportedBranchSubtypePrefix)) {
      return MixSchemaError(
        code: .unsupportedEncodeValue,
        path: path,
        message: message,
        value: value,
      );
    }

    return MixSchemaError(
      code: .validationFailed,
      path: path,
      message: message,
      value: value,
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
      'core_invalid_type' => .typeMismatch,
      'string_enum' || 'enum_value' => .invalidEnum,
      // Max-length/max-items constraints are produced by MixSchemaLimits and
      // codec-level grammar caps such as registryValueCodec/kMaxRegistryIdLength.
      'string_max_length' || 'list_max_items' => .payloadLimitExceeded,
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

  /// Maps an encode-path [SchemaError] and surfaces the primary
  /// representability failure when the discriminated encoder produces noisy
  /// branch errors.
  List<MixSchemaError> mapEncode(SchemaError error) {
    final mapped = map(error);
    // Discriminated encode can produce branch noise; surface the primary
    // representability failure when one is present.
    for (final code in const [
      MixSchemaErrorCode.requiredField,
      MixSchemaErrorCode.unknownRegistryValue,
      MixSchemaErrorCode.unsupportedEncodeValue,
    ]) {
      final match = mapped.firstWhere(
        (error) => error.code == code,
        orElse: () => _noMatch,
      );
      if (!identical(match, _noMatch)) {
        return List<MixSchemaError>.unmodifiable([match]);
      }
    }

    return mapped;
  }
}

const MixSchemaError _noMatch = MixSchemaError(
  code: .validationFailed,
  path: '',
  message: '',
);

bool _isRequiredEncodeMessage(String message) {
  return message.startsWith('Field "') && message.endsWith('" is required.');
}
