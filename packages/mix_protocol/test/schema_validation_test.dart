import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';

import 'schema_fixtures/core_schema_cases.dart';

/// The runtime decoder must agree with every checked-in schema fixture.
///
/// `tool/schema-check` validates the same documents against the exported
/// JSON Schema with Ajv, so together these keep the schema and the decoder
/// from drifting apart.
void main() {
  test('accepted style fixtures decode strictly', () {
    for (final fixture in styleAcceptCases) {
      expect(
        mixProtocol.decodeStyle<Object>(fixture.payload),
        isA<MixProtocolSuccess<Object>>(),
        reason: fixture.name,
      );
    }
  });

  test('rejected style fixtures fail strict decoding', () {
    for (final fixture in styleRejectCases) {
      expect(
        mixProtocol.decodeStyle<Object>(fixture.payload),
        isA<MixProtocolFailure<Object>>(),
        reason: fixture.name,
      );
    }
  });

  test('theme fixtures agree with the theme decoder', () {
    for (final fixture in themeAcceptCases) {
      expect(
        mixProtocol.decodeTheme(fixture.payload),
        isA<MixProtocolSuccess<MixProtocolTheme>>(),
        reason: fixture.name,
      );
    }
    for (final fixture in themeRejectCases) {
      expect(
        mixProtocol.decodeTheme(fixture.payload),
        isA<MixProtocolFailure<MixProtocolTheme>>(),
        reason: fixture.name,
      );
    }
  });

  test('breakpoint selector alternatives decode as typed box stylers', () {
    for (final (fields, valid) in breakpointSelectorFields) {
      for (final nested in [false, true]) {
        final payload = breakpointSelectorPayload(fields, nested: nested);
        expect(
          mixProtocol.decodeStyle<BoxStyler>(payload),
          valid
              ? isA<MixProtocolSuccess<BoxStyler>>()
              : isA<MixProtocolFailure<BoxStyler>>(),
          reason: '$payload',
        );
      }
    }
  });

  test('canonical padding terms decode as typed box stylers', () {
    for (final value in canonicalPaddingTerms) {
      expect(
        mixProtocol.decodeStyle<BoxStyler>({
          'v': 1,
          'type': 'box',
          'padding': value,
        }),
        isA<MixProtocolSuccess<BoxStyler>>(),
        reason: '$value',
      );
    }
  });
}
