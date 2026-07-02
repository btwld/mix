import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/schema/common_codecs.dart';

void main() {
  MixSchemaContract contract() => MixSchemaContractBuilder().builtIn().freeze();

  test('modifiers decode in payload order', () {
    final decoded = contract().decode<BoxStyler>({
      'type': 'box',
      'modifiers': [
        {'type': 'opacity', 'opacity': 0.5},
        {'type': 'blur', 'sigma': 2},
        {
          'type': 'default_text_style',
          'style': {'color': '#112233'},
          'textAlign': 'center',
          'softWrap': false,
          'overflow': 'ellipsis',
          'maxLines': 2,
        },
      ],
    });

    final style = switch (decoded) {
      MixSchemaDecodeSuccess<BoxStyler>(:final value) => value,
      MixSchemaDecodeFailure<BoxStyler>(:final errors) => fail('$errors'),
    };
    final modifiers = style.$modifier!.$modifiers!;

    expect(modifiers, [
      isA<OpacityModifierMix>(),
      isA<BlurModifierMix>(),
      isA<DefaultTextStyleModifierMix>(),
    ]);
    expect(
      singleValueProp((modifiers[0] as OpacityModifierMix).opacity, 'opacity'),
      0.5,
    );
  });

  test('modifiers encode in config order', () {
    final encoded = contract().encode(
      BoxStyler(
        modifier: WidgetModifierConfig.modifiers([
          OpacityModifierMix(opacity: 0.5),
          BlurModifierMix(sigma: 2),
          DefaultTextStyleModifierMix(
            style: TextStyleMix(color: const Color(0xFF112233)),
            textAlign: TextAlign.center,
            softWrap: false,
          ),
        ]),
      ),
    );

    final payload = switch (encoded) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };

    expect(payload, {
      'v': 1,
      'type': 'box',
      'modifiers': [
        {'type': 'opacity', 'opacity': 0.5},
        {'type': 'blur', 'sigma': 2.0},
        {
          'type': 'default_text_style',
          'style': {'color': '#112233'},
          'textAlign': 'center',
          'softWrap': false,
        },
      ],
    });
  });

  test('flexible modifier decodes flex parent-data intent', () {
    final decoded = contract().decode<BoxStyler>({
      'type': 'box',
      'modifiers': [
        {'type': 'flexible', 'flex': 1, 'fit': 'tight'},
      ],
    });

    final style = switch (decoded) {
      MixSchemaDecodeSuccess<BoxStyler>(:final value) => value,
      MixSchemaDecodeFailure<BoxStyler>(:final errors) => fail('$errors'),
    };
    final modifier = style.$modifier!.$modifiers!.single;

    expect(modifier, isA<FlexibleModifierMix>());
    final flexible = modifier as FlexibleModifierMix;
    expect(singleValueProp(flexible.flex, 'flex'), 1);
    expect(singleValueProp(flexible.fit, 'fit'), FlexFit.tight);
  });

  test('flexible modifier encodes flex parent-data intent', () {
    final encoded = contract().encode(
      BoxStyler(
        modifier: WidgetModifierConfig.flexible(flex: 1, fit: FlexFit.tight),
      ),
    );

    final payload = switch (encoded) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };

    expect(payload, {
      'v': 1,
      'type': 'box',
      'modifiers': [
        {'type': 'flexible', 'flex': 1, 'fit': 'tight'},
      ],
    });
  });

  test('flexible modifier rejects invalid fit', () {
    final result = contract().validate({
      'type': 'box',
      'modifiers': [
        {'type': 'flexible', 'fit': 'fixed'},
      ],
    });

    final errors = switch (result) {
      MixSchemaValidationFailure(:final errors) => errors,
      MixSchemaValidationSuccess() => fail('expected failure'),
    };

    expect(
      errors.map((error) => error.code),
      contains(MixSchemaErrorCode.invalidEnum),
    );
  });

  test('custom modifier order fails encode explicitly', () {
    final result = contract().encode(
      BoxStyler(
        modifier: WidgetModifierConfig.orderOfModifiers([BlurModifier]),
      ),
    );

    final errors = switch (result) {
      MixSchemaEncodeFailure(:final errors) => errors,
      MixSchemaEncodeSuccess() => fail('expected failure'),
    };

    expect(
      errors.map((error) => error.code),
      contains(MixSchemaErrorCode.unsupportedEncodeValue),
    );
  });
}
