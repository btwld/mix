import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/errors/schema_error_mapper.dart';
import 'package:mix_schema/src/registry/registry_value_codec.dart';

void main() {
  test('registry value codec decodes and encodes registered values', () {
    const value = IconData(0xe145, fontFamily: 'MaterialIcons');
    final registry = RegistryBuilder().iconData('add', value).freeze();
    final schema = registryValueCodec<IconData>(
      () => registry,
      MixSchemaScope.iconData,
    );

    expect(schema.safeParse('add').getOrThrow(), value);
    expect(schema.safeEncode(value).getOrThrow(), 'add');
  });

  test('bad grammar fails before lookup', () {
    final registry = RegistryBuilder().freeze();
    final schema = registryValueCodec<IconData>(
      () => registry,
      MixSchemaScope.iconData,
    );
    final result = schema.safeParse('bad id');

    expect(result.isFail, isTrue);
    expect(
      mapSchemaError(result.getError()).single.code,
      MixSchemaErrorCode.constraintViolation,
    );
  });

  test('unknown id maps to unknown_registry_id', () {
    final registry = RegistryBuilder().freeze();
    final schema = registryValueCodec<IconData>(
      () => registry,
      MixSchemaScope.iconData,
    );
    final result = schema.safeParse('missing');

    expect(result.isFail, isTrue);
    expect(
      mapSchemaError(result.getError()).single.code,
      MixSchemaErrorCode.unknownRegistryId,
    );
  });

  test('unregistered value maps to unknown_registry_value', () {
    final registry = RegistryBuilder().freeze();
    final schema = registryValueCodec<IconData>(
      () => registry,
      MixSchemaScope.iconData,
    );
    final result = schema.safeEncode(
      const IconData(0xe15b, fontFamily: 'MaterialIcons'),
    );

    expect(result.isFail, isTrue);
    expect(
      mapSchemaError(result.getError()).single.code,
      MixSchemaErrorCode.unknownRegistryValue,
    );
  });

  test('equal but non-identical values do not match registry ids', () {
    const registered = IconData(0xe15b, fontFamily: 'MaterialIcons');
    final equalValue = IconData(0xe15b, fontFamily: 'MaterialIcons');
    final registry = RegistryBuilder()
        .iconData('registered', registered)
        .freeze();
    final schema = registryValueCodec<IconData>(
      () => registry,
      MixSchemaScope.iconData,
    );

    expect(equalValue, registered);
    expect(identical(equalValue, registered), isFalse);

    final result = schema.safeEncode(equalValue);

    expect(result.isFail, isTrue);
    expect(
      mapSchemaError(result.getError()).single.code,
      MixSchemaErrorCode.unknownRegistryValue,
    );
  });
}
