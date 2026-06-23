import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  MixSchemaContract contract() => MixSchemaContractBuilder().builtIn().freeze();

  BoxStyler decodeBox(JsonMap payload) {
    final result = contract().decode<BoxStyler>(payload);

    return switch (result) {
      MixSchemaDecodeSuccess<BoxStyler>(:final value) => value,
      MixSchemaDecodeFailure<BoxStyler>(:final errors) => fail('$errors'),
    };
  }

  test('decodes named variant with lazy nested style', () {
    final box = decodeBox({
      'type': 'box',
      'variants': [
        {
          'kind': 'named',
          'name': 'primary',
          'style': {
            'type': 'box',
            'padding': {'top': 8},
          },
        },
      ],
    });

    expect(box.$variants, hasLength(1));
    expect(box.$variants!.single.variant, const NamedVariant('primary'));
    expect(box.$variants!.single.value, isA<BoxStyler>());
  });

  test('decodes widget state, enabled, brightness, and breakpoint', () {
    final box = decodeBox({
      'type': 'box',
      'variants': [
        {
          'kind': 'widget_state',
          'state': 'hovered',
          'style': {'type': 'box'},
        },
        {
          'kind': 'enabled',
          'style': {'type': 'box'},
        },
        {
          'kind': 'context_brightness',
          'brightness': 'dark',
          'style': {'type': 'box'},
        },
        {
          'kind': 'context_breakpoint',
          'minWidth': 768,
          'maxWidth': 1023,
          'style': {'type': 'box'},
        },
      ],
    });

    final keys = box.$variants!.map((variant) => variant.variant.key).toList();

    expect(keys, [
      'widget_state_hovered',
      'not_widget_state_disabled',
      'media_query_platform_brightness_dark',
      'breakpoint_768.0_1023.0',
    ]);
  });

  test('removed context variant hacks fail as unknown variant kinds', () {
    for (final kind in ['context_all_of', 'context_variant_builder']) {
      final errors = _validationErrors(
        contract().validate({
          'type': 'box',
          'variants': [
            {
              'kind': kind,
              'style': {'type': 'box'},
            },
          ],
        }),
      );

      expect(errors.single.code, MixSchemaErrorCode.invalidEnum);
    }
  });

  test('breakpoint variants without bounds fail as constraints', () {
    final errors = _validationErrors(
      contract().validate({
        'type': 'box',
        'variants': [
          {
            'kind': 'context_breakpoint',
            'style': {'type': 'box'},
          },
        ],
      }),
    );
    final codes = errors.map((error) => error.code);

    expect(codes, contains(MixSchemaErrorCode.constraintViolation));
    expect(codes, isNot(contains(MixSchemaErrorCode.transformFailed)));
    expect(codes, isNot(contains(MixSchemaErrorCode.unsupportedEncodeValue)));
  });

  test('non-box variants encode through lazy nested style', () {
    final result = contract().encode(
      TextStyler().variant(const NamedVariant('body'), TextStyler(maxLines: 1)),
    );
    final payload = switch (result) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };

    expect(payload['variants'], [
      {
        'kind': 'named',
        'name': 'body',
        'style': {'type': 'text', 'maxLines': 1},
      },
    ]);
  });

  test('encodes variants through lazy nested style', () {
    final style = BoxStyler().variant(
      const NamedVariant('primary'),
      BoxStyler(clipBehavior: Clip.hardEdge),
    );

    final result = contract().encode(style);
    final payload = switch (result) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };

    expect(payload['variants'], [
      {
        'kind': 'named',
        'name': 'primary',
        'style': {'type': 'box', 'clipBehavior': 'hardEdge'},
      },
    ]);
  });

  test('encodes typed context variants without parsing keys', () {
    final style = BoxStyler(
      variants: [
        VariantStyle(
          ContextVariant.brightness(Brightness.light),
          BoxStyler(clipBehavior: Clip.hardEdge),
        ),
        VariantStyle(
          ContextVariant.breakpoint(const Breakpoint(maxWidth: 600)),
          BoxStyler(clipBehavior: Clip.antiAlias),
        ),
        VariantStyle(
          ContextVariant.not(ContextVariant.widgetState(WidgetState.pressed)),
          BoxStyler(clipBehavior: Clip.antiAliasWithSaveLayer),
        ),
      ],
    );

    final encoded = contract().encode(style);
    final payload = switch (encoded) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };

    expect(payload['variants'], [
      {
        'kind': 'context_brightness',
        'brightness': 'light',
        'style': {'type': 'box', 'clipBehavior': 'hardEdge'},
      },
      {
        'kind': 'context_breakpoint',
        'maxWidth': 600.0,
        'style': {'type': 'box', 'clipBehavior': 'antiAlias'},
      },
      {
        'kind': 'context_not_widget_state',
        'state': 'pressed',
        'style': {'type': 'box', 'clipBehavior': 'antiAliasWithSaveLayer'},
      },
    ]);
  });
}

List<MixSchemaError> _validationErrors(MixSchemaValidationResult result) {
  return switch (result) {
    MixSchemaValidationFailure(:final errors) => errors,
    MixSchemaValidationSuccess() => fail('expected validation failure'),
  };
}
