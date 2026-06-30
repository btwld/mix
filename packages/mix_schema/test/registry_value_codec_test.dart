import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/errors/schema_error_mapper.dart';
import 'package:mix_schema/src/registry/registry_value_codec.dart';

void main() {
  test('R-6 registry value codec decodes and encodes registered values', () {
    final value = Object();
    final registry = RegistryBuilder()
        .register(MixSchemaScope.contextVariantBuilder, 'ctx_builder', value)
        .freeze();
    final schema = registryValueCodec<Object>(
      registry,
      MixSchemaScope.contextVariantBuilder,
    );

    expect(schema.safeParse('ctx_builder').getOrThrow(), same(value));
    expect(schema.safeEncode(value).getOrThrow(), 'ctx_builder');
  });

  test('R-6 bad grammar fails before lookup', () {
    final schema = registryValueCodec<Object>(
      RegistryBuilder().freeze(),
      MixSchemaScope.contextVariantBuilder,
    );
    final result = schema.safeParse('bad id');

    expect(result.isFail, isTrue);
    expect(
      mapSchemaError(result.getError()).single.code,
      MixSchemaErrorCode.constraintViolation,
    );
  });

  test('R-6 unknown id maps to unknown_registry_id', () {
    final schema = registryValueCodec<Object>(
      RegistryBuilder().freeze(),
      MixSchemaScope.contextVariantBuilder,
    );
    final result = schema.safeParse('missing');

    expect(result.isFail, isTrue);
    expect(
      mapSchemaError(result.getError()).single.code,
      MixSchemaErrorCode.unknownRegistryId,
    );
  });

  test('R-6 unregistered value maps to unknown_registry_value', () {
    final schema = registryValueCodec<Object>(
      RegistryBuilder().freeze(),
      MixSchemaScope.contextVariantBuilder,
    );
    final result = schema.safeEncode(Object());

    expect(result.isFail, isTrue);
    expect(
      mapSchemaError(result.getError()).single.code,
      MixSchemaErrorCode.unknownRegistryValue,
    );
  });
}
