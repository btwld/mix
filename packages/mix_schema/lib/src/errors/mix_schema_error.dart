import 'package:ack/ack.dart';

import '../contract/mix_schema_limits.dart';

enum MixSchemaErrorCode {
  typeMismatch('type_mismatch'),
  requiredField('required_field'),
  unknownField('unknown_field'),
  invalidEnum('invalid_enum'),
  constraintViolation('constraint_violation'),
  payloadLimitExceeded('payload_limit_exceeded'),
  unsupportedEncodeValue('unsupported_encode_value'),
  unknownType('unknown_type'),
  unknownRegistryId('unknown_registry_id'),
  unknownRegistryValue('unknown_registry_value'),
  validationFailed('validation_failed'),
  transformFailed('transform_failed');

  const MixSchemaErrorCode(this.wireValue);

  final String wireValue;
}

final class MixSchemaError {
  const MixSchemaError({
    required this.code,
    required this.path,
    required this.message,
    this.value,
  });

  final MixSchemaErrorCode code;
  final String path;
  final String message;
  final Object? value;

  JsonMap toJson() => {
    'code': code.wireValue,
    'path': path,
    'message': message,
    if (value != null) 'value': value,
  };

  @override
  String toString() => '${code.wireValue} at "$path": $message';
}

sealed class MixSchemaValidationResult {
  const MixSchemaValidationResult();
}

final class MixSchemaValidationSuccess extends MixSchemaValidationResult {
  const MixSchemaValidationSuccess();
}

final class MixSchemaValidationFailure extends MixSchemaValidationResult {
  const MixSchemaValidationFailure(this.errors);

  final List<MixSchemaError> errors;
}

sealed class MixSchemaDecodeResult<T extends Object> {
  const MixSchemaDecodeResult();
}

final class MixSchemaDecodeSuccess<T extends Object>
    extends MixSchemaDecodeResult<T> {
  const MixSchemaDecodeSuccess(this.value);

  final T value;
}

final class MixSchemaDecodeFailure<T extends Object>
    extends MixSchemaDecodeResult<T> {
  const MixSchemaDecodeFailure(this.errors);

  final List<MixSchemaError> errors;
}

sealed class MixSchemaEncodeResult {
  const MixSchemaEncodeResult();
}

final class MixSchemaEncodeSuccess extends MixSchemaEncodeResult {
  const MixSchemaEncodeSuccess(this.value);

  final JsonMap value;
}

final class MixSchemaEncodeFailure extends MixSchemaEncodeResult {
  const MixSchemaEncodeFailure(this.errors);

  final List<MixSchemaError> errors;
}

final class UnsupportedEncodeValueError implements Exception {
  const UnsupportedEncodeValueError(this.value, this.reason);

  final Object? value;
  final String reason;

  @override
  String toString() => 'Unsupported encode value: $reason';
}

final class UnknownRegistryIdError implements Exception {
  const UnknownRegistryIdError(this.scope, this.id);

  final Object scope;
  final String id;

  @override
  String toString() => 'Unknown registry id "$id" in $scope.';
}

final class UnknownRegistryValueError implements Exception {
  const UnknownRegistryValueError(this.scope, this.value);

  final Object scope;
  final Object value;

  @override
  String toString() => 'Unknown registry value ${value.runtimeType} in $scope.';
}

List<MixSchemaError> validatePayloadLimits(
  Object? value,
  MixSchemaLimits limits,
) {
  final errors = <MixSchemaError>[];

  void visit(Object? node, String path, int depth) {
    if (depth > limits.maxDepth) {
      errors.add(
        MixSchemaError(
          code: MixSchemaErrorCode.payloadLimitExceeded,
          path: path,
          message: 'Payload depth exceeds ${limits.maxDepth}.',
          value: node,
        ),
      );

      return;
    }

    if (node is String && node.length > limits.maxStringLength) {
      errors.add(
        MixSchemaError(
          code: MixSchemaErrorCode.payloadLimitExceeded,
          path: path,
          message: 'String length exceeds ${limits.maxStringLength}.',
          value: node,
        ),
      );
    } else if (node is List) {
      if (node.length > limits.maxListLength) {
        errors.add(
          MixSchemaError(
            code: MixSchemaErrorCode.payloadLimitExceeded,
            path: path,
            message: 'List length exceeds ${limits.maxListLength}.',
            value: node.length,
          ),
        );
      }
      for (var i = 0; i < node.length; i++) {
        visit(node[i], '$path/$i', depth + 1);
      }
    } else if (node is Map) {
      final variants = node['variants'];
      if (variants is List && variants.length > limits.maxVariantsPerStyler) {
        errors.add(
          MixSchemaError(
            code: MixSchemaErrorCode.payloadLimitExceeded,
            path: '$path/variants',
            message: 'Variant count exceeds ${limits.maxVariantsPerStyler}.',
            value: variants.length,
          ),
        );
      }
      final modifiers = node['modifiers'];
      if (modifiers is List &&
          modifiers.length > limits.maxModifiersPerStyler) {
        errors.add(
          MixSchemaError(
            code: MixSchemaErrorCode.payloadLimitExceeded,
            path: '$path/modifiers',
            message: 'Modifier count exceeds ${limits.maxModifiersPerStyler}.',
            value: modifiers.length,
          ),
        );
      }
      for (final entry in node.entries) {
        final key = entry.key;
        visit(entry.value, '$path/$key', depth + 1);
      }
    }
  }

  visit(value, '', 0);
  errors.sort((a, b) => a.path.compareTo(b.path));

  return errors;
}
