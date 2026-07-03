import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';
import 'package:mix_tailwinds/src/tw_flex_item.dart';
import 'package:mix_tailwinds/src/translate/tw_translator.dart';

JsonMap _encode(Object styler) {
  return switch (builtInMixSchemaContract.encode(styler)) {
    MixSchemaEncodeSuccess(:final value) => value,
    MixSchemaEncodeFailure(:final errors) => throw TestFailure('$errors'),
  };
}

void _expectContractRoundTrip<T extends Object>(T styler) {
  final payload = _encode(styler);

  expect(
    builtInMixSchemaContract.validate(payload),
    isA<MixSchemaValidationSuccess>(),
  );
  expect(
    builtInMixSchemaContract.decode<T>(payload),
    isA<MixSchemaDecodeSuccess<T>>(),
  );
}

void main() {
  test('box translator output encodes through mix_schema', () {
    final style = TwParser().parseBox(
      'bg-blue-500 p-4 rounded-md shadow-md opacity-50 blur-sm '
      'w-10 min-h-4 border-2 border-red-500 '
      'bg-gradient-to-r from-red-500 to-blue-500 hover:bg-red-600',
    );
    final payload = _encode(style);

    expect(payload['type'], 'box');
    expect(payload['decoration'], isA<JsonMap>());
    expect(payload['modifiers'], isA<List>());
    _expectContractRoundTrip<BoxStyler>(style);
  });

  test('flex translator output encodes through mix_schema', () {
    final style = TwParser().parseFlex(
      'flex flex-col gap-4 p-4 items-baseline text-shadow-md',
    );
    final payload = _encode(style);

    expect(payload['type'], 'flex_box');
    expect(payload['modifiers'], isA<List>());
    _expectContractRoundTrip<FlexBoxStyler>(style);
  });

  test('text translator output encodes through mix_schema', () {
    final style = TwParser().parseText(
      'text-lg font-bold text-center leading-tight tracking-wide '
      'uppercase text-shadow-sm',
    );
    final payload = _encode(style);

    expect(payload['type'], 'text');
    expect(payload['style'], isA<JsonMap>());
    _expectContractRoundTrip<TextStyler>(style);
  });

  test('icon translator output encodes through mix_schema', () {
    final style = TwTranslator(
      config: TwConfig.standard(),
    ).translateIcon('w-6 text-blue-700 opacity-50');
    final payload = _encode(style);

    expect(payload['type'], 'icon');
    expect(payload['size'], 24);
    expect(payload['opacity'], 0.5);
    _expectContractRoundTrip<IconStyler>(style);
  });

  testWidgets('flex item helper builds FlexibleModifierMix directly', (
    tester,
  ) async {
    final cases = <String, ({int flex, FlexFit fit})>{
      'flex-1': (flex: 1, fit: FlexFit.tight),
      'flex-auto': (flex: 1, fit: FlexFit.loose),
      'flex-initial': (flex: 0, fit: FlexFit.loose),
      'flex-none': (flex: 0, fit: FlexFit.loose),
      'flex-shrink': (flex: 1, fit: FlexFit.tight),
      'flex-shrink-0': (flex: 0, fit: FlexFit.loose),
      'shrink': (flex: 1, fit: FlexFit.tight),
      'shrink-0': (flex: 0, fit: FlexFit.loose),
      'grow': (flex: 1, fit: FlexFit.tight),
      'grow-0': (flex: 0, fit: FlexFit.loose),
    };

    for (final entry in cases.entries) {
      final modifier = twFlexibleModifierForFlexItem(entry.key);
      expect(modifier, isNotNull, reason: entry.key);

      FlexibleModifier? resolved;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              resolved = modifier!.resolve(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolved!.flex, entry.value.flex, reason: entry.key);
      expect(resolved!.fit, entry.value.fit, reason: entry.key);
    }

    expect(twFlexibleModifierForFlexItem('basis-4'), isNull);
  });
}
