import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

void main() {
  test('box parser emits schema payloads that decode through mix_schema', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final payload = TwParser().parseBoxPayload('bg-blue-500 p-4 rounded-md');

    expect(payload['type'], 'box');
    expect(contract.validate(payload), isA<MixSchemaValidationSuccess>());
    expect(contract.decode<BoxStyler>(payload), isA<MixSchemaDecodeSuccess>());
  });

  test('box parser emits shadow payloads through mix_schema', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final payload = TwParser().parseBoxPayload('shadow-md');
    final decoration = payload['decoration'] as JsonMap;
    final shadows = decoration['boxShadow'] as List;

    expect(shadows, hasLength(2));
    expect(contract.validate(payload), isA<MixSchemaValidationSuccess>());
    expect(contract.decode<BoxStyler>(payload), isA<MixSchemaDecodeSuccess>());
  });

  testWidgets('parseBox shadow-md resolves Tailwind shadows', (tester) async {
    final style = TwParser().parseBox('shadow-md');
    BoxDecoration? decoration;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) {
            decoration =
                style.resolve(context).spec.decoration as BoxDecoration?;
            return const SizedBox();
          },
        ),
      ),
    );

    expect(decoration?.boxShadow, const [
      BoxShadow(
        offset: Offset(0, 4),
        blurRadius: 6,
        spreadRadius: -1,
        color: Color(0x1A000000),
      ),
      BoxShadow(
        offset: Offset(0, 2),
        blurRadius: 4,
        spreadRadius: -2,
        color: Color(0x1A000000),
      ),
    ]);
  });

  test('flex parser emits schema payloads that decode through mix_schema', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final payload = TwParser().parseFlexPayload('flex flex-col gap-4 p-4');

    expect(payload['type'], 'flex_box');
    expect(contract.validate(payload), isA<MixSchemaValidationSuccess>());
    expect(
      contract.decode<FlexBoxStyler>(payload),
      isA<MixSchemaDecodeSuccess>(),
    );
  });

  test('flex parser emits default text shadow payloads through mix_schema', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final payload = TwParser().parseFlexPayload('flex text-shadow-md');
    final modifiers = payload['modifiers'] as List;
    final defaultTextStyle = modifiers.single as JsonMap;
    final style = defaultTextStyle['style'] as JsonMap;

    expect(defaultTextStyle['type'], 'default_text_style');
    expect(style['shadows'], isA<List>());
    expect(contract.validate(payload), isA<MixSchemaValidationSuccess>());
    expect(
      contract.decode<FlexBoxStyler>(payload),
      isA<MixSchemaDecodeSuccess>(),
    );
  });

  test('text parser emits schema payloads that decode through mix_schema', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final payload = TwParser().parseTextPayload(
      'text-lg font-bold text-center leading-tight tracking-wide uppercase text-shadow-sm',
    );

    expect(payload['type'], 'text');
    expect(payload['textAlign'], 'center');
    expect((payload['style'] as JsonMap)['shadows'], isA<List>());
    expect(contract.validate(payload), isA<MixSchemaValidationSuccess>());
    expect(contract.decode<TextStyler>(payload), isA<MixSchemaDecodeSuccess>());
  });

  testWidgets('parseText text-center resolves TextAlign.center', (
    tester,
  ) async {
    final style = TwParser().parseText('text-center');
    TextAlign? textAlign;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) {
            textAlign = style.resolve(context).spec.textAlign;
            return const SizedBox();
          },
        ),
      ),
    );

    expect(textAlign, TextAlign.center);
  });

  testWidgets('rendered text with text-center is centered', (tester) async {
    const value = 'Centered text';
    final style = TwParser().parseText('text-center');

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: StyledText(value, style: style),
      ),
    );

    final text = tester.widget<Text>(find.text(value));
    expect(text.textAlign, TextAlign.center);
  });

  test(
    'direct-only and prefixed tokens still parse without schema payloads',
    () {
      final unsupported = <String>[];
      final parser = TwParser(onUnsupported: unsupported.add);

      expect(
        parser.parseBox('border border-red-500 bg-gradient-to-r from-red-500'),
        isA<BoxStyler>(),
      );
      expect(parser.parseBox('hover:bg-blue-500'), isA<BoxStyler>());
      expect(unsupported, isEmpty);
    },
  );

  test('unsupported Tailwind tokens stay parser diagnostics', () {
    final unsupported = <String>[];
    final style = TwParser(
      onUnsupported: unsupported.add,
    ).parseBox('unknown-token');

    expect(style, isA<BoxStyler>());
    expect(unsupported, contains('unknown-token'));
  });
}
