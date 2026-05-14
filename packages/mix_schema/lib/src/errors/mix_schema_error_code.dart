/// Stable public error codes emitted by `mix_schema`.
enum MixSchemaErrorCode {
  typeMismatch('type_mismatch'),
  requiredField('required_field'),
  unknownField('unknown_field'),
  invalidEnum('invalid_enum'),
  constraintViolation('constraint_violation'),
  validationFailed('validation_failed'),
  transformFailed('transform_failed'),
  unsupportedEncodeValue('unsupported_encode_value'),
  unknownType('unknown_type'),
  unknownRegistryId('unknown_registry_id'),
  unknownRegistryValue('unknown_registry_value');

  const MixSchemaErrorCode(this.wireValue);

  final String wireValue;

  @override
  String toString() => wireValue;
}
