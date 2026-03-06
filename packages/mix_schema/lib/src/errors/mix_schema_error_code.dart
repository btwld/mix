/// Stable public error codes emitted by `mix_schema`.
enum MixSchemaErrorCode {
  typeMismatch('type_mismatch'),
  requiredField('required_field'),
  unknownField('unknown_field'),
  invalidEnum('invalid_enum'),
  constraintViolation('constraint_violation'),
  validationFailed('validation_failed'),
  transformFailed('transform_failed'),
  unknownType('unknown_type'),
  unknownRegistryId('unknown_registry_id'),
  unsupportedValueType('unsupported_value_type');

  const MixSchemaErrorCode(this.wireValue);

  final String wireValue;

  @override
  String toString() => wireValue;
}
