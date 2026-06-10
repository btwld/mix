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

  test('R-11 decodes named variant with lazy nested style', () {
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

  test('R-11 decodes widget state, enabled, brightness, and breakpoint', () {
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

  test('R-11 decodes flat context_all_of and rejects nested all_of', () {
    final ok = contract().validate({
      'type': 'box',
      'variants': [
        {
          'kind': 'context_all_of',
          'conditions': [
            {'kind': 'enabled'},
            {'kind': 'context_brightness', 'brightness': 'light'},
          ],
          'style': {'type': 'box'},
        },
      ],
    });
    expect(ok, isA<MixSchemaValidationSuccess>());

    final nested = contract().validate({
      'type': 'box',
      'variants': [
        {
          'kind': 'context_all_of',
          'conditions': [
            {'kind': 'context_all_of', 'conditions': []},
          ],
          'style': {'type': 'box'},
        },
      ],
    });

    expect(nested, isA<MixSchemaValidationFailure>());
  });

  test('R-11 encodes variants through lazy nested style', () {
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

  test('R-6/R-11 context variant builders use registry ids', () {
    BoxStyler responsiveBox(BuildContext context) {
      return BoxStyler(clipBehavior: Clip.hardEdge);
    }

    final builder = MixSchemaContractBuilder()
      ..registry.contextVariantBuilder('responsive_box', responsiveBox);
    final contract = builder.builtIn().freeze();

    final decoded = contract.decode<BoxStyler>({
      'type': 'box',
      'variants': [
        {'kind': 'context_variant_builder', 'builder': 'responsive_box'},
      ],
    });
    final style = switch (decoded) {
      MixSchemaDecodeSuccess<BoxStyler>(:final value) => value,
      MixSchemaDecodeFailure<BoxStyler>(:final errors) => fail('$errors'),
    };

    expect(style.$variants!.single.variant, isA<ContextVariantBuilder>());

    final encoded = contract.encode(style);
    final payload = switch (encoded) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };

    expect(payload['variants'], [
      {'kind': 'context_variant_builder', 'builder': 'responsive_box'},
    ]);
  });
}
