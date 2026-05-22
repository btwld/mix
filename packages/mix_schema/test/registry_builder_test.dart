import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('RegistryBuilder', () {
    test('exposes stable built-in scope wire values', () {
      expect(MixSchemaScope.values.map((scope) => scope.wireValue), const [
        'animation_on_end',
        'icon_data',
        'image_provider',
        'context_variant_builder',
      ]);
    });

    test('creates built-in scope registries from MixSchemaScope', () {
      final builder = RegistryBuilder<String>.builtIn(
        scope: MixSchemaScope.imageProvider,
      );

      expect(builder.scope, 'image_provider');
    });

    test('freezes values for lookup', () {
      final builder = RegistryBuilder<String>(scope: 'demo')
        ..register('primary', 'value');

      final frozen = builder.freeze();

      expect(frozen.lookup('primary'), 'value');
      expect(frozen.ids, contains('primary'));
    });

    test('rejects duplicate ids', () {
      final builder = RegistryBuilder<String>(scope: 'demo')
        ..register('primary', 'value');

      expect(
        () => builder.register('primary', 'other'),
        throwsA(isA<StateError>()),
      );
    });

    test('rejects mutation after freeze', () {
      final builder = RegistryBuilder<String>(scope: 'demo');
      builder.freeze();

      expect(
        () => builder.register('primary', 'value'),
        throwsA(isA<StateError>()),
      );
      expect(() => builder.freeze(), throwsA(isA<StateError>()));
    });

    test('rejects scopes that fail the wire grammar', () {
      expect(
        () => RegistryBuilder<String>(scope: ''),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => RegistryBuilder<String>(scope: 'Demo'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => RegistryBuilder<String>(scope: 'demo scope'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => RegistryBuilder<String>(scope: 'demo-scope'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects ids that fail the wire grammar', () {
      final builder = RegistryBuilder<String>(scope: 'demo');

      expect(
        () => builder.register('', 'value'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => builder.register(' primary', 'value'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => builder.register('primary id', 'value'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('accepts id grammar that includes ., :, -, _', () {
      final builder = RegistryBuilder<String>(scope: 'demo')
        ..register('app.heroImage', 'a')
        ..register('ns:bar', 'b')
        ..register('with-hyphen', 'c')
        ..register('with_underscore', 'd');

      final frozen = builder.freeze();
      expect(frozen.lookup('app.heroImage'), 'a');
      expect(frozen.lookup('ns:bar'), 'b');
      expect(frozen.lookup('with-hyphen'), 'c');
      expect(frozen.lookup('with_underscore'), 'd');
    });
  });
}
