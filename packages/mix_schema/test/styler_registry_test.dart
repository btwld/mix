import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/schema/shared/color_schema.dart';

void main() {
  group('MixSchemaContractBuilder registration', () {
    test('decodes transformed custom branches', () {
      final contract =
          (MixSchemaContractBuilder()..register('demo', _demoSchema('demo')))
              .freeze();

      final result = contract.decode({'type': 'demo', 'value': 42});

      expect(result.ok, isTrue);
      expect(result.value, 42);
    });

    test('supports developer-registered styler schemas', () {
      final builder = MixSchemaContractBuilder()
        ..register(
          'custom_box',
          Ack.codec<JsonMap, JsonMap, BoxStyler>(
            input: Ack.object({'color': colorCodec.optional()}),
            output: Ack.instance<BoxStyler>(),
            decode: (data) => BoxStyler(
              decoration: data['color'] == null
                  ? null
                  : BoxDecorationMix(color: data['color']! as Color),
            ),
            encode: (_) => const {'type': 'custom_box'},
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
          Ack.codec<JsonMap, JsonMap, Object>(
            input: Ack.object({'value': Ack.integer()}),
            output: Ack.instance<Object>().refine(
              (value) => value == 7,
              message: 'Demo value must be 7.',
            ),
            decode: (data) => data['value']! as int,
            encode: (value) => {'type': 'demo', 'value': value as int},
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

    test('rejects custom styler type names that are not wire ids', () {
      for (final type in [
        '',
        '   ',
        'CustomBox',
        'custom-box',
        'custom box',
        '_custom',
        ' custom',
        'custom ',
      ]) {
        expect(
          () => MixSchemaContractBuilder().register(type, _demoSchema(type)),
          throwsArgumentError,
          reason: type,
        );
      }
    });

    test('rejects duplicate registration of the same type', () {
      final builder = MixSchemaContractBuilder()
        ..register('demo', _demoSchema('demo'));

      expect(
        () => builder.register('demo', _demoSchema('demo')),
        throwsA(isA<StateError>()),
      );
    });

    test('reserves built-in styler type names for built-in schemas', () {
      expect(
        () => MixSchemaContractBuilder().register('box', _demoSchema('box')),
        throwsArgumentError,
      );
      expect(MixSchemaContractBuilder.builtIn, returnsNormally);
    });

    test('extends the built-in styler set with custom schemas', () {
      final builder = MixSchemaContractBuilder.builtIn()
        ..register(
          'custom_box',
          Ack.codec<JsonMap, JsonMap, BoxStyler>(
            input: Ack.object({'color': colorCodec.optional()}),
            output: Ack.instance<BoxStyler>(),
            decode: (data) => BoxStyler(
              decoration: data['color'] == null
                  ? null
                  : BoxDecorationMix(color: data['color']! as Color),
            ),
            encode: (_) => const {'type': 'custom_box'},
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

CodecSchema<JsonMap, Object> _demoSchema(String type) {
  return Ack.codec<JsonMap, JsonMap, Object>(
    input: Ack.object({'value': Ack.integer()}),
    output: Ack.instance<Object>(),
    decode: (data) => data['value']! as int,
    encode: (value) => {'type': type, 'value': value as int},
  );
}
