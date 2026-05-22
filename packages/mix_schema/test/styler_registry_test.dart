import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/schema/shared/color_schema.dart';

void main() {
  group('MixSchemaContractBuilder registration', () {
    test('decodes transformed custom branches', () {
      final builder = MixSchemaContractBuilder();
      _registerDemo(builder, 'demo');
      final contract = builder.freeze();

      final result = contract.decode({'type': 'demo', 'value': 42});

      expect(result.ok, isTrue);
      expect(result.value, 42);
    });

    test('supports developer-registered styler schemas', () {
      final builder = MixSchemaContractBuilder();
      _registerCustomBox(builder, 'custom_box');

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
        ..register<Object>(
          'demo',
          input: Ack.object({'value': Ack.integer()}),
          output: Ack.instance<Object>().refine(
            (value) => value == 7,
            message: 'Demo value must be 7.',
          ),
          decode: (data) => data['value']! as int,
          encode: (value) => {'value': value as int},
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

    test('injects the discriminator even when producer encode omits it', () {
      final builder = MixSchemaContractBuilder()
        ..register<int>(
          'demo',
          input: Ack.object({'value': Ack.integer()}),
          decode: (data) => data['value']! as int,
          // Encoder intentionally omits "type" — the builder must inject it.
          encode: (value) => {'value': value},
        );
      final contract = builder.freeze();

      final encoded = contract.encode(42);

      expect(encoded.ok, isTrue, reason: encoded.errors.join('\n'));
      expect(encoded.value, {'type': 'demo', 'value': 42});
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
          () => _registerDemo(MixSchemaContractBuilder(), type),
          throwsArgumentError,
          reason: type,
        );
      }
    });

    test('rejects duplicate registration of the same type', () {
      final builder = MixSchemaContractBuilder();
      _registerDemo(builder, 'demo');

      expect(() => _registerDemo(builder, 'demo'), throwsA(isA<StateError>()));
    });

    test('reserves built-in styler type names for built-in schemas', () {
      expect(
        () => _registerDemo(MixSchemaContractBuilder(), 'box'),
        throwsArgumentError,
      );
      expect(MixSchemaContractBuilder.builtIn, returnsNormally);
    });

    test('extends the built-in styler set with custom schemas', () {
      final builder = MixSchemaContractBuilder.builtIn();
      _registerCustomBox(builder, 'custom_box');

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

void _registerDemo(MixSchemaContractBuilder builder, String type) {
  builder.register<int>(
    type,
    input: Ack.object({'value': Ack.integer()}),
    decode: (data) => data['value']! as int,
    encode: (value) => {'value': value},
  );
}

void _registerCustomBox(MixSchemaContractBuilder builder, String type) {
  builder.register<BoxStyler>(
    type,
    input: Ack.object({'color': colorCodec.optional()}),
    output: Ack.instance<BoxStyler>(),
    decode: (data) => BoxStyler(
      decoration: data['color'] == null
          ? null
          : BoxDecorationMix(color: data['color']! as Color),
    ),
    encode: (_) => const {},
  );
}
