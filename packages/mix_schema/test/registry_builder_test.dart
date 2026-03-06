import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('RegistryBuilder', () {
    test('exposes stable built-in scope wire values', () {
      expect(MixSchemaScope.values.map((scope) => scope.wireValue), const [
        'animation_on_end',
        'image_provider',
        'modifier_shader',
        'modifier_clipper',
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
  });
}
