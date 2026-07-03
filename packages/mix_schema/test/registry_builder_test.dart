import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/src/errors/mix_schema_error.dart';
import 'package:mix_schema/src/registry/registry.dart';

final class _EqualValue {
  const _EqualValue(this.id);

  final int id;

  @override
  bool operator ==(Object other) => other is _EqualValue && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

void main() {
  test('registry builder freezes scoped identity values', () {
    const icon = IconData(0xe145, fontFamily: 'MaterialIcons');
    final registry = RegistryBuilder().iconData('add', icon).freeze();

    expect(registry.lookup<IconData>(MixSchemaScope.iconData, 'add'), icon);
    expect(registry.idFor(MixSchemaScope.iconData, icon), 'add');
  });

  test('registry reverse lookup requires registered identity', () {
    final registered = _EqualValue(1);
    final equalButDifferent = _EqualValue(1);
    final registry = RegistryBuilder()
        .register(MixSchemaScope.iconData, 'value', registered)
        .freeze();

    expect(
      () => registry.idFor(MixSchemaScope.iconData, equalButDifferent),
      throwsA(isA<UnknownRegistryValueError>()),
    );
  });

  test('invalid registry ids are rejected by the builder', () {
    expect(
      () => RegistryBuilder().register(
        MixSchemaScope.iconData,
        'bad id',
        Object(),
      ),
      throwsArgumentError,
    );
  });

  test('unknown ids and values throw typed exceptions', () {
    final registry = RegistryBuilder().freeze();

    expect(
      () => registry.lookup<Object>(MixSchemaScope.iconData, 'missing'),
      throwsA(isA<UnknownRegistryIdError>()),
    );
    expect(
      () => registry.idFor(MixSchemaScope.iconData, Object()),
      throwsA(isA<UnknownRegistryValueError>()),
    );
  });

  test('registry builder cannot register or freeze twice after freeze', () {
    const icon = IconData(0xe145, fontFamily: 'MaterialIcons');
    final builder = RegistryBuilder().iconData('add', icon);
    final registry = builder.freeze();

    expect(registry.lookup<IconData>(MixSchemaScope.iconData, 'add'), icon);
    expect(
      () => builder.iconData(
        'remove',
        const IconData(0xe15b, fontFamily: 'MaterialIcons'),
      ),
      throwsStateError,
    );
    expect(builder.freeze, throwsStateError);
  });
}
