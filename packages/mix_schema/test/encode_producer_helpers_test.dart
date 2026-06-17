import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/encode.dart';
import 'package:mix_schema/mix_schema.dart';

void _expectDecodes<T extends Object>(JsonMap payload) {
  final result = builtInMixSchemaContract.decode<T>(payload);
  expect(
    result,
    isA<MixSchemaDecodeSuccess<T>>(),
    reason: switch (result) {
      MixSchemaDecodeFailure<T>(:final errors) => '$errors',
      _ => null,
    },
  );
}

void main() {
  test('builtInMixSchemaContract registers the built-in stylers', () {
    expect(
      builtInMixSchemaContract.registeredTypes,
      containsAll(<String>['box', 'text', 'flex_box', 'icon']),
    );
  });

  test('payloadStyler/payloadModifier discriminators are exported', () {
    expect(payloadStyler(SchemaStyler.box), {'type': 'box'});
    expect(payloadStyler(SchemaStyler.flexBox), {'type': 'flex_box'});
    expect(payloadModifier(SchemaModifier.opacity, {'opacity': 0.5}), {
      'type': 'opacity',
      'opacity': 0.5,
    });
    expect(payloadModifier(SchemaModifier.defaultTextStyle), {
      'type': 'default_text_style',
    });
    expect(payloadVariant(SchemaVariant.widgetState, {'state': 'hovered'}), {
      'kind': 'widget_state',
      'state': 'hovered',
    });
  });

  test('payloadEnum returns the Dart enum name', () {
    expect(payloadEnum(Axis.vertical), 'vertical');
    expect(payloadEnum(MainAxisAlignment.spaceBetween), 'spaceBetween');
    expect(payloadEnum(FlexFit.tight), 'tight');
    expect(payloadEnum(BorderStyle.solid), 'solid');
  });

  test('payloadWidgetState returns schema widget-state wire values', () {
    expect(payloadWidgetState(WidgetState.hovered), 'hovered');
    expect(payloadWidgetState(WidgetState.focused), 'focused');
    expect(payloadWidgetState(WidgetState.pressed), 'pressed');
    expect(payloadWidgetState(WidgetState.scrolledUnder), 'scrolled_under');
    expect(payloadWidgetState(WidgetState.disabled), 'disabled');
  });

  test('payloadFontWeight returns schema font-weight wire values', () {
    expect(payloadFontWeight(FontWeight.w100), 'w100');
    expect(payloadFontWeight(FontWeight.w700), 'w700');
    expect(payloadFontWeight(FontWeight.w900), 'w900');
  });

  test('opacity/blur modifier payloads decode through the box styler', () {
    _expectDecodes<BoxStyler>(
      payloadStyler(SchemaStyler.box, {
        'modifiers': [
          payloadModifier(SchemaModifier.opacity, {'opacity': 0.5}),
          payloadModifier(SchemaModifier.blur, {'sigma': 4.0}),
        ],
      }),
    );
  });

  test('flexible modifier payload decodes through the box styler', () {
    _expectDecodes<BoxStyler>(
      payloadStyler(SchemaStyler.box, {
        'modifiers': [
          payloadModifier(SchemaModifier.flexible, {
            'flex': 1,
            'fit': payloadEnum(FlexFit.tight),
          }),
        ],
      }),
    );
  });

  test('constraints payload decodes through the box styler', () {
    _expectDecodes<BoxStyler>(
      payloadStyler(SchemaStyler.box, {
        'constraints': payloadConstraints(
          minWidth: 10,
          maxWidth: 20,
          minHeight: 5,
        ),
      }),
    );
  });

  test('border side/border and radius payloads decode through decoration', () {
    _expectDecodes<BoxStyler>(
      payloadStyler(SchemaStyler.box, {
        'decoration': payloadDecoration(
          color: const Color(0xFF112233),
          border: payloadBorder(
            top: payloadBorderSide(
              color: const Color(0xFF445566),
              width: 2,
              style: BorderStyle.solid,
            ),
            bottom: payloadBorderSide(width: 0, style: BorderStyle.none),
          ),
          borderRadius: payloadBorderRadius(topLeft: 4, topRight: 4),
        ),
      }),
    );
  });

  test('flex enum fields decode through the flex_box styler', () {
    _expectDecodes<FlexBoxStyler>(
      payloadStyler(SchemaStyler.flexBox, {
        'direction': payloadEnum(Axis.vertical),
        'mainAxisAlignment': payloadEnum(MainAxisAlignment.spaceBetween),
        'crossAxisAlignment': payloadEnum(CrossAxisAlignment.stretch),
        'mainAxisSize': payloadEnum(MainAxisSize.min),
        'textBaseline': payloadEnum(TextBaseline.alphabetic),
      }),
    );
  });

  test(
    'text style + height behavior payloads decode through the text styler',
    () {
      _expectDecodes<TextStyler>(
        payloadStyler(SchemaStyler.text, {
          'textAlign': payloadEnum(TextAlign.center),
          'style': payloadTextStyle(
            color: const Color(0xFF111111),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.5,
            letterSpacing: 0.4,
          ),
          'textHeightBehavior': payloadTextHeightBehavior(
            leadingDistribution: TextLeadingDistribution.even,
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        }),
      );
    },
  );

  test(
    'default_text_style modifier payload decodes through the box styler',
    () {
      _expectDecodes<BoxStyler>(
        payloadStyler(SchemaStyler.box, {
          'modifiers': [
            payloadModifier(SchemaModifier.defaultTextStyle, {
              'style': payloadTextStyle(fontSize: 14, height: 1.4),
            }),
          ],
        }),
      );
    },
  );
}
