import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/schema/common_codecs.dart';

void main() {
  MixSchemaContract contract() => MixSchemaContractBuilder().builtIn().freeze();

  test('text styler decodes representable typography fields', () {
    final result = contract().decode<TextStyler>({
      'type': 'text',
      'textAlign': 'center',
      'maxLines': 2,
      'style': {
        'color': '#FF0000',
        'fontSize': 16,
        'fontWeight': 'w700',
        'fontStyle': 'italic',
        'fontFamily': 'Inter',
      },
    });

    final text = switch (result) {
      MixSchemaDecodeSuccess<TextStyler>(:final value) => value,
      MixSchemaDecodeFailure<TextStyler>(:final errors) => fail('$errors'),
    };
    final style = singleMixProp<TextStyleMix, TextStyle>(text.$style, 'style');

    expect(singleValueProp(text.$textAlign, 'textAlign'), TextAlign.center);
    expect(singleValueProp(text.$maxLines, 'maxLines'), 2);
    expect(singleValueProp(style!.$fontWeight, 'fontWeight'), FontWeight.w700);
  });

  test('text styler encodes representable typography fields', () {
    final result = contract().encode(
      TextStyler(
        textAlign: TextAlign.end,
        softWrap: false,
        selectionColor: const Color(0x800000FF),
        style: TextStyleMix(
          color: const Color(0xFF112233),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
      ),
    );

    final payload = switch (result) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };

    expect(payload, {
      'v': 1,
      'type': 'text',
      'textAlign': 'end',
      'style': {
        'color': '#112233',
        'fontSize': 14.0,
        'fontWeight': 'w600',
        'decoration': 'underline',
      },
      'softWrap': false,
      'selectionColor': '#800000FF',
    });
  });

  test('text styler encodes supported text directives', () {
    final result = contract().encode(TextStyler.uppercase());

    final payload = switch (result) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };

    expect(payload, {
      'v': 1,
      'type': 'text',
      'textDirectives': ['uppercase'],
    });
  });

  test('text directives decode and re-encode symmetrically', () {
    final payload = {
      'v': 1,
      'type': 'text',
      'textDirectives': [
        'uppercase',
        'lowercase',
        'capitalize',
        'title_case',
        'sentence_case',
      ],
    };
    final decoded = switch (contract().decode<TextStyler>(payload)) {
      MixSchemaDecodeSuccess<TextStyler>(:final value) => value,
      MixSchemaDecodeFailure<TextStyler>(:final errors) => fail('$errors'),
    };
    final encoded = switch (contract().encode(decoded)) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };

    expect(encoded, payload);
  });

  test('lineThrough text decoration uses line_through wire value', () {
    final payload = {
      'v': 1,
      'type': 'text',
      'style': {'decoration': 'line_through'},
    };
    final decoded = switch (contract().decode<TextStyler>(payload)) {
      MixSchemaDecodeSuccess<TextStyler>(:final value) => value,
      MixSchemaDecodeFailure<TextStyler>(:final errors) => fail('$errors'),
    };
    final encoded = switch (contract().encode(decoded)) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };

    expect(encoded, payload);
  });
}
