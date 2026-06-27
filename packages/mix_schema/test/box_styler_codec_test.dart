import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/schema/common_codecs.dart';

void main() {
  MixSchemaContract contract() => MixSchemaContractBuilder().builtIn().freeze();

  test('decodes box without branch-owned type field', () {
    final result = contract().decode<BoxStyler>({
      'type': 'box',
      'padding': {'top': 8},
    });

    final box = switch (result) {
      MixSchemaDecodeSuccess<BoxStyler>(:final value) => value,
      MixSchemaDecodeFailure<BoxStyler>(:final errors) => fail('$errors'),
    };

    final padding = singleMixProp<EdgeInsetsMix, EdgeInsetsGeometry>(
      box.$padding,
      'padding',
    );
    expect(singleValueProp(padding!.$top, 'top'), 8);
    expect(box.$margin, isNull);
  });

  test('Ack root injects box discriminator on encode', () {
    final encoded = contract().encode(
      BoxStyler(
        alignment: Alignment.center,
        padding: EdgeInsetsMix(top: 8),
        decoration: BoxDecorationMix(color: const Color(0xCC336699)),
        clipBehavior: Clip.hardEdge,
      ),
    );

    final payload = switch (encoded) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };

    expect(payload, {
      'type': 'box',
      'alignment': 'center',
      'padding': {'top': 8.0},
      'clipBehavior': 'hardEdge',
      'decoration': {'color': '#CC336699'},
    });
  });

  test('unsupported box runtime values fail encode explicitly', () {
    final style = BoxStyler(
      padding: EdgeInsetsMix(top: 4),
    ).merge(BoxStyler(padding: EdgeInsetsMix(top: 8)));

    final result = contract().encode(style);

    final errors = switch (result) {
      MixSchemaEncodeFailure(:final errors) => errors,
      MixSchemaEncodeSuccess() => fail('expected failure'),
    };

    expect(
      errors,
      contains(
        isA<MixSchemaError>()
            .having(
              (error) => error.code,
              'code',
              MixSchemaErrorCode.unsupportedEncodeValue,
            )
            .having((error) => error.message, 'message', contains('padding')),
      ),
    );
  });

  test('unsupported decoration runtime values fail encode explicitly', () {
    final cases = [
      (
        style: BoxStyler(
          decoration: BoxDecorationMix(
            image: DecorationImageMix.image(
              const NetworkImage('https://example.com/image.png'),
            ),
          ),
        ),
        field: 'decoration.image',
      ),
      (
        style: BoxStyler(
          decoration: BoxDecorationMix(
            gradient: LinearGradientMix(
              colors: const [Color(0xFF000000), Color(0xFFFFFFFF)],
            ),
          ),
        ),
        field: 'decoration.gradient',
      ),
      (
        style: BoxStyler.create(
          decoration: Prop.mix(
            BoxDecorationMix.create(
              color: Prop.value(
                const Color(0xFF000000),
              ).directives([OpacityColorDirective(0.5)]),
            ),
          ),
        ),
        field: 'decoration.color',
      ),
    ];

    for (final (:style, :field) in cases) {
      final result = contract().encode(style);

      final errors = switch (result) {
        MixSchemaEncodeFailure(:final errors) => errors,
        MixSchemaEncodeSuccess() => fail('expected failure for $style'),
      };

      expect(
        errors,
        contains(
          isA<MixSchemaError>()
              .having(
                (error) => error.code,
                'code',
                MixSchemaErrorCode.unsupportedEncodeValue,
              )
              .having((error) => error.message, 'message', contains(field)),
        ),
      );
    }
  });

  test('registeredTypes includes box built-in branch', () {
    expect(contract().registeredTypes, contains('box'));
  });
}
