import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/registry/styler_registry.dart';
import 'package:mix_schema/src/schema/shared/color_schema.dart';

void main() {
  group('StylerRegistry', () {
    test('decodes transformed custom branches', () {
      final registry = StylerRegistry()
        ..register(
          'demo',
          Ack.codec<Map<String, Object?>, Object>(
            input: Ack.object({'value': Ack.integer()}),
            output: Ack.instance<Object>(),
            decoder: (data) => data['value'] as int,
            encoder: (value) => {'value': value as int},
          ),
        )
        ..freeze();

      final result = registry.decode({'type': 'demo', 'value': 42});

      expect(result.isOk, isTrue);
      expect(result.getOrNull(), 42);
    });

    test('rejects decode before freeze', () {
      final registry = StylerRegistry();

      expect(
        () => registry.decode({'type': 'demo'}),
        throwsA(isA<StateError>()),
      );
    });

    test('supports developer-registered styler schemas', () {
      final builder = MixSchemaContractBuilder()
        ..register(
          'custom_box',
          Ack.codec<Map<String, Object?>, BoxStyler>(
            input: Ack.object({'color': colorCodec.optional()}),
            output: Ack.instance<BoxStyler>(),
            decoder: (data) {
              return BoxStyler(
                decoration: data['color'] == null
                    ? null
                    : BoxDecorationMix(color: data['color'] as Color),
              );
            },
            encoder: (_) => const {},
          ),
        );

      final contract = builder.freeze();
      final result = contract.decode({
        'type': 'custom_box',
        'color': 'rgba(51, 102, 153, 1)',
      });

      expect(result.ok, isTrue);
      expect(result.value, isA<BoxStyler>());
    });

    test('preserves output refinements on registered codecs', () {
      final builder = MixSchemaContractBuilder()
        ..register(
          'demo',
          Ack.codec<Map<String, Object?>, Object>(
            input: Ack.object({'value': Ack.integer()}),
            output: Ack.instance<Object>().refine(
              (value) => value == 7,
              message: 'Demo value must be 7.',
            ),
            decoder: (data) => data['value'] as int,
            encoder: (value) => {'value': value as int},
          ),
        );
      final contract = builder.freeze();

      final validResult = contract.validate({'type': 'demo', 'value': 7});
      final invalidResult = contract.validate({'type': 'demo', 'value': 42});

      expect(validResult.ok, isTrue);
      expect(invalidResult.ok, isFalse);
      expect(
        invalidResult.errors.single.code,
        MixSchemaErrorCode.validationFailed,
      );
      expect(invalidResult.errors.single.message, 'Demo value must be 7.');
    });

    test('rejects custom schemas that are not JsonMap-backed codecs', () {
      expect(
        () => MixSchemaContractBuilder()
          ..register(
            'demo',
            Ack.codec<JsonMap, Object>(
              input: Ack.string() as dynamic,
              output: Ack.instance<Object>(),
              decoder: (value) => value,
              encoder: (_) => const {},
            ),
          ),
        throwsA(isA<TypeError>()),
      );
    });

    test('extends the built-in styler set with custom schemas', () {
      final builder = MixSchemaContractBuilder.builtIn()
        ..register(
          'custom_box',
          Ack.codec<Map<String, Object?>, BoxStyler>(
            input: Ack.object({'color': colorCodec.optional()}),
            output: Ack.instance<BoxStyler>(),
            decoder: (data) {
              return BoxStyler(
                decoration: data['color'] == null
                    ? null
                    : BoxDecorationMix(color: data['color'] as Color),
              );
            },
            encoder: (_) => const {},
          ),
        );

      final contract = builder.freeze();
      final builtInResult = contract.decode({'type': 'box'});
      final customResult = contract.decode({
        'type': 'custom_box',
        'color': 'rgba(51, 102, 153, 1)',
      });

      expect(builtInResult.ok, isTrue);
      expect(builtInResult.value, isA<BoxStyler>());
      expect(customResult.ok, isTrue);
      expect(customResult.value, isA<BoxStyler>());
    });
  });
}
