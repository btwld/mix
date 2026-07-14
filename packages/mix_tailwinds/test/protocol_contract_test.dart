import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';
import 'package:mix_tailwinds/src/tw_flex_item.dart';

void _expectProtocolRoundTrip<T extends Object>({
  required String category,
  required String classes,
  required T styler,
}) {
  final label = '$category: `$classes`';
  final encoded = switch (mixProtocol.encodeStyle(styler)) {
    MixProtocolSuccess<JsonMap>(:final value) => value,
    MixProtocolFailure<JsonMap>(:final errors) => fail(
      '$label failed encode: $errors',
    ),
  };

  final decoded = switch (mixProtocol.decodeStyle<T>(encoded)) {
    MixProtocolSuccess<T>(:final value) => value,
    MixProtocolFailure<T>(:final errors) => fail(
      '$label failed strict decode: $errors',
    ),
  };
  final reencoded = switch (mixProtocol.encodeStyle(decoded)) {
    MixProtocolSuccess<JsonMap>(:final value) => value,
    MixProtocolFailure<JsonMap>(:final errors) => fail(
      '$label failed re-encode: $errors',
    ),
  };

  expect(reencoded, encoded, reason: '$label was not canonical');
}

void main() {
  final parser = TwParser();

  test('Tailwinds output is canonical mix_protocol input', () {
    final boxCases = <({String category, String classes})>[
      (category: 'box/sizing-and-spacing', classes: 'w-10 min-h-4 p-4 mx-2'),
      (
        category: 'box/decoration-borders-shadows',
        classes: 'bg-blue-500 rounded-md shadow-md border-2 border-red-500',
      ),
      (category: 'box/modifiers', classes: 'opacity-50 blur-sm'),
      (
        category: 'box/transforms',
        classes: 'scale-105 rotate-45 translate-x-2',
      ),
      (
        category: 'box/gradient-horizontal',
        classes: 'bg-gradient-to-r from-red-500 via-white to-blue-500',
      ),
      (
        category: 'box/gradient-default-diagonal-css-corner',
        classes: 'bg-gradient-to-br from-red-500 via-white to-blue-500',
      ),
      (category: 'box/state-variant', classes: 'hover:bg-red-600'),
      (category: 'box/nested-variant', classes: 'md:hover:scale-105'),
      (category: 'box/breakpoints', classes: 'sm:bg-red-600 md:p-6'),
    ];

    for (final entry in boxCases) {
      _expectProtocolRoundTrip<BoxStyler>(
        category: entry.category,
        classes: entry.classes,
        styler: parser.parseBox(entry.classes),
      );
    }

    const flexClasses =
        'flex flex-col items-center justify-between gap-4 p-4 '
        'border border-gray-200 text-shadow-md';
    _expectProtocolRoundTrip<FlexBoxStyler>(
      category: 'flex/layout',
      classes: flexClasses,
      styler: parser.parseFlex(flexClasses),
    );

    const textClasses =
        'text-lg font-bold text-center leading-tight tracking-wide '
        'uppercase text-shadow-sm';
    _expectProtocolRoundTrip<TextStyler>(
      category: 'text/typography',
      classes: textClasses,
      styler: parser.parseText(textClasses),
    );

    const iconClasses = 'w-6 text-blue-700 opacity-50';
    _expectProtocolRoundTrip<IconStyler>(
      category: 'icon/size-color-opacity',
      classes: iconClasses,
      styler: parser.parseIcon(iconClasses),
    );
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
