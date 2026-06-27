import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/encode.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/schema/common_codecs.dart';

/// Characterization tests that pin the wire vocabulary now owned by a single
/// source — `primitive_wire.dart` (`widgetStateWireValues` /
/// `fontWeightWireValues`) — and consumed by both the codec path
/// (`variant_codec.dart`, `text_styler_codec.dart`) and the producer path
/// (`encode.dart`). They guard the two paths against silently drifting apart if
/// that shared table ever changes.
///
/// Also covers two previously-untested behaviors: `validate` rejecting unknown
/// wire fields, and the `matrix4` transform round-trip.
void main() {
  JsonMap encodeStyler(Object styler) {
    final result = builtInMixSchemaContract.encode(styler);
    return switch (result) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };
  }

  T decodeStyler<T extends Object>(JsonMap payload) {
    final result = builtInMixSchemaContract.decode<T>(payload);
    return switch (result) {
      MixSchemaDecodeSuccess<T>(:final value) => value,
      MixSchemaDecodeFailure<T>(:final errors) => fail('$errors'),
    };
  }

  group('fontWeight wire vocabulary (codec ⇄ producer)', () {
    final weights = <FontWeight, String>{
      FontWeight.w100: 'w100',
      FontWeight.w200: 'w200',
      FontWeight.w300: 'w300',
      FontWeight.w400: 'w400',
      FontWeight.w500: 'w500',
      FontWeight.w600: 'w600',
      FontWeight.w700: 'w700',
      FontWeight.w800: 'w800',
      FontWeight.w900: 'w900',
    };

    weights.forEach((weight, wire) {
      test('producer encodes $weight as "$wire"', () {
        expect(payloadFontWeight(weight), wire);
      });

      test('codec round-trips fontWeight "$wire"', () {
        final decoded = decodeStyler<TextStyler>({
          'type': 'text',
          'style': {'fontWeight': wire},
        });
        final style = singleMixProp<TextStyleMix, TextStyle>(
          decoded.$style,
          'style',
        );
        expect(singleValueProp(style!.$fontWeight, 'fontWeight'), weight);

        final reencoded = encodeStyler(decoded);
        expect((reencoded['style'] as Map)['fontWeight'], wire);
      });
    });
  });

  group('widget_state wire vocabulary (codec ⇄ producer)', () {
    const states = <WidgetState, String>{
      WidgetState.hovered: 'hovered',
      WidgetState.focused: 'focused',
      WidgetState.pressed: 'pressed',
      WidgetState.dragged: 'dragged',
      WidgetState.selected: 'selected',
      WidgetState.scrolledUnder: 'scrolled_under',
      WidgetState.disabled: 'disabled',
      WidgetState.error: 'error',
    };

    states.forEach((state, wire) {
      test('producer encodes $state as "$wire"', () {
        expect(payloadWidgetState(state), wire);
      });

      test('codec decodes "$wire" to $state and re-encodes the token', () {
        final decoded = decodeStyler<BoxStyler>({
          'type': 'box',
          'variants': [
            {
              'kind': 'widget_state',
              'state': wire,
              'style': {'type': 'box'},
            },
          ],
        });
        // Decode resolves the wire token to the correct WidgetState...
        final variant = decoded.$variants!.single.variant;
        expect((variant as WidgetStateVariant).state, state);
        // ...and encode emits the same token back.
        final reencoded = encodeStyler(decoded);
        final encodedVariant = (reencoded['variants'] as List).single as Map;
        expect(encodedVariant['kind'], 'widget_state');
        expect(encodedVariant['state'], wire);
      });
    });
  });

  group('validate rejects unknown wire fields', () {
    test('an unexpected field fails validation with unknownField', () {
      final result = builtInMixSchemaContract.validate({
        'type': 'box',
        'bogusField': 1,
      });
      final errors = switch (result) {
        MixSchemaValidationSuccess() => fail('expected validation failure'),
        MixSchemaValidationFailure(:final errors) => errors,
      };
      expect(
        errors.map((error) => error.code),
        contains(MixSchemaErrorCode.unknownField),
      );
    });
  });

  group('matrix4 transform round-trip', () {
    test('box transform survives encode → decode → encode', () {
      final transform = Matrix4.fromList(<double>[
        2, 0, 0, 0, //
        0, 2, 0, 0, //
        0, 0, 1, 0, //
        10, 20, 0, 1, //
      ]);

      final payload = encodeStyler(BoxStyler(transform: transform));
      expect(payload['transform'], transform.storage.toList());
      expect(payload['transform'], hasLength(16));

      final reencoded = encodeStyler(decodeStyler<BoxStyler>(payload));
      expect(reencoded['transform'], payload['transform']);
    });
  });
}
