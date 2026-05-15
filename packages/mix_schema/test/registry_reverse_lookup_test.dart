import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/src/core/mix_schema_scope.dart';
import 'package:mix_schema/src/registry/registry_builder.dart';
import 'package:mix_schema/src/registry/registry_catalog.dart';
import 'package:mix_schema/src/schema/styler_catalog.dart';

void main() {
  group('registry reverse lookup', () {
    test(
      'frozen registries and catalogs resolve ids for registered values',
      () {
        final builder = RegistryBuilder<String>(scope: 'demo')
          ..register('primary', 'value');
        final registry = builder.freeze();
        final catalog = RegistryCatalog([registry]);

        expect(registry.keyOf('value'), 'primary');
        expect(catalog.keyOf<String>('demo', 'value'), 'primary');
        expect(catalog.keyOf<String>('demo', 'missing'), isNull);
        expect(catalog.keyOf<String>('missing_scope', 'value'), isNull);
      },
    );

    test('rejects the same value under different ids', () {
      final builder = RegistryBuilder<String>(scope: 'demo')
        ..register('primary', 'value');

      expect(
        () => builder.register('secondary', 'value'),
        throwsA(isA<StateError>()),
      );
    });

    test('image provider schema encodes registered providers', () {
      final image = MemoryImage(Uint8List.fromList([0, 0, 0, 0]));
      final images = RegistryBuilder<ImageProvider<Object>>.builtIn(
        scope: MixSchemaScope.imageProvider,
      )..register('hero', image);
      final catalog = StylerCatalog(
        registries: RegistryCatalog([images.freeze()]),
      );

      expect(catalog.imageProviderCodec.encode(image), 'hero');
      expect(catalog.imageProviderCodec.parse('hero'), same(image));
    });

    test('animation schema encodes registered onEnd callbacks', () {
      void onEnd() {}

      final callbacks = RegistryBuilder<VoidCallback>.builtIn(
        scope: MixSchemaScope.animationOnEnd,
      )..register('done', onEnd);
      final catalog = StylerCatalog(
        registries: RegistryCatalog([callbacks.freeze()]),
      );
      final config = CurveAnimationConfig(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        delay: const Duration(milliseconds: 50),
        onEnd: onEnd,
      );
      final wire = {
        'duration': 200,
        'curve': 'easeIn',
        'delay': 50,
        'onEnd': 'done',
      };

      expect(catalog.metadata.animationCodec.encode(config), wire);
      expect(catalog.metadata.animationCodec.parse(wire), config);
    });
  });
}
