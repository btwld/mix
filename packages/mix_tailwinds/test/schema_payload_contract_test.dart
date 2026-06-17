import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/encode.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';
import 'package:mix_tailwinds/src/tw_flex_item.dart';
import 'package:mix_tailwinds/src/translate/tw_translator.dart';

JsonMap _boxPayload(String classNames) =>
    TwTranslator(config: TwConfig.standard()).payloadBox(classNames);

JsonMap _flexPayload(String classNames) =>
    TwTranslator(config: TwConfig.standard()).payloadFlex(classNames);

JsonMap _textPayload(String classNames) =>
    TwTranslator(config: TwConfig.standard()).payloadText(classNames);

JsonMap _iconPayload(String classNames) =>
    TwTranslator(config: TwConfig.standard()).payloadIcon(classNames);

void main() {
  test('box parser emits schema payloads that decode through mix_schema', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final payload = _boxPayload('bg-blue-500 p-4 rounded-md');

    expect(payload['type'], 'box');
    expect(contract.validate(payload), isA<MixSchemaValidationSuccess>());
    expect(contract.decode<BoxStyler>(payload), isA<MixSchemaDecodeSuccess>());
  });

  test('box parser emits shadow payloads through mix_schema', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final payload = _boxPayload('shadow-md');
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
    final payload = _flexPayload('flex flex-col gap-4 p-4');

    expect(payload['type'], 'flex_box');
    expect(contract.validate(payload), isA<MixSchemaValidationSuccess>());
    expect(
      contract.decode<FlexBoxStyler>(payload),
      isA<MixSchemaDecodeSuccess>(),
    );
  });

  test('flex parser emits default text shadow payloads through mix_schema', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final payload = _flexPayload('flex text-shadow-md');
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

  testWidgets('flex item helper maps supported tokens through mix_schema', (
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

  test('text parser emits schema payloads that decode through mix_schema', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final payload = _textPayload(
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
    'direct-only and prefixed tokens still parse without unsupported warnings',
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

  test('box parser emits widget-state variant payloads through mix_schema', () {
    final payload = _boxPayload('hover:bg-red-600');
    final variants = (payload['variants'] as List).cast<JsonMap>();
    final hover = variants.single;
    final style = hover['style'] as JsonMap;
    final decoration = style['decoration'] as JsonMap;

    expect(hover['kind'], 'widget_state');
    expect(hover['state'], 'hovered');
    expect(decoration['color'], '#DC2626');
    expect(
      builtInMixSchemaContract.decode<BoxStyler>(payload),
      isA<MixSchemaDecodeSuccess>(),
    );
  });

  test('box parser emits brightness variant payloads through mix_schema', () {
    final payload = _boxPayload('dark:bg-gray-700');
    final variants = (payload['variants'] as List).cast<JsonMap>();
    final dark = variants.single;
    final style = dark['style'] as JsonMap;
    final decoration = style['decoration'] as JsonMap;

    expect(dark['kind'], 'context_brightness');
    expect(dark['brightness'], 'dark');
    expect(decoration['color'], '#374151');
    expect(
      builtInMixSchemaContract.decode<BoxStyler>(payload),
      isA<MixSchemaDecodeSuccess>(),
    );
  });

  test('box parser emits nested breakpoint/state variants through schema', () {
    final payload = _boxPayload('md:hover:bg-blue-500');
    final variants = (payload['variants'] as List).cast<JsonMap>();
    final breakpoint = variants.single;
    final breakpointStyle = breakpoint['style'] as JsonMap;
    final nestedVariants = (breakpointStyle['variants'] as List)
        .cast<JsonMap>();
    final hover = nestedVariants.single;
    final hoverStyle = hover['style'] as JsonMap;
    final decoration = hoverStyle['decoration'] as JsonMap;

    expect(breakpoint['kind'], 'context_breakpoint');
    expect(breakpoint['minWidth'], 768);
    expect(hover['kind'], 'widget_state');
    expect(hover['state'], 'hovered');
    expect(decoration['color'], '#3B82F6');
    expect(
      builtInMixSchemaContract.decode<BoxStyler>(payload),
      isA<MixSchemaDecodeSuccess>(),
    );
  });

  test('box parser emits not-hover variant payloads through mix_schema', () {
    final payload = _boxPayload('not-hover:opacity-50');
    final variants = (payload['variants'] as List).cast<JsonMap>();
    final notHover = variants.single;
    final style = notHover['style'] as JsonMap;
    final modifiers = (style['modifiers'] as List).cast<JsonMap>();

    expect(notHover['kind'], 'context_not_widget_state');
    expect(notHover['state'], 'hovered');
    expect(modifiers.single['type'], 'opacity');
    expect(modifiers.single['opacity'], 0.5);
    expect(
      builtInMixSchemaContract.decode<BoxStyler>(payload),
      isA<MixSchemaDecodeSuccess>(),
    );
  });

  test('unsupported Tailwind tokens stay parser diagnostics', () {
    final unsupported = <String>[];
    final style = TwParser(
      onUnsupported: unsupported.add,
    ).parseBox('unknown-token');

    expect(style, isA<BoxStyler>());
    expect(unsupported, contains('unknown-token'));
  });

  test('flex parser emits payloadEnum wire values for layout fields', () {
    final payload = _flexPayload('flex-col items-center justify-between');

    expect(payload['direction'], 'vertical');
    expect(payload['crossAxisAlignment'], 'center');
    expect(payload['mainAxisAlignment'], 'spaceBetween');
    expect(
      builtInMixSchemaContract.decode<FlexBoxStyler>(payload),
      isA<MixSchemaDecodeSuccess>(),
    );
  });

  test('flex items-baseline emits cross alignment and text baseline', () {
    final payload = _flexPayload('flex items-baseline');

    expect(payload['crossAxisAlignment'], 'baseline');
    expect(payload['textBaseline'], 'alphabetic');
    expect(
      builtInMixSchemaContract.decode<FlexBoxStyler>(payload),
      isA<MixSchemaDecodeSuccess>(),
    );
  });

  test('box parser emits opacity and blur modifier payloads', () {
    final payload = _boxPayload('opacity-50 blur-sm');
    final modifiers = (payload['modifiers'] as List).cast<JsonMap>();

    expect(
      modifiers.any((m) => m['type'] == 'opacity' && m['opacity'] == 0.5),
      isTrue,
    );
    expect(modifiers.any((m) => m['type'] == 'blur'), isTrue);
    expect(
      builtInMixSchemaContract.decode<BoxStyler>(payload),
      isA<MixSchemaDecodeSuccess>(),
    );
  });

  test('box parser emits constraints payload via payloadConstraints', () {
    final payload = _boxPayload('w-10 min-h-4');
    final constraints = payload['constraints'] as JsonMap;

    expect(constraints['minWidth'], 40);
    expect(constraints['maxWidth'], 40);
    expect(constraints['minHeight'], 16);
    expect(constraints.containsKey('maxHeight'), isFalse);
    expect(
      builtInMixSchemaContract.decode<BoxStyler>(payload),
      isA<MixSchemaDecodeSuccess>(),
    );
  });

  test('box parser emits border side/border and radius payloads', () {
    final payload = _boxPayload('border-2 border-red-500 rounded-lg');
    final decoration = payload['decoration'] as JsonMap;
    final border = decoration['border'] as JsonMap;
    final top = border['top'] as JsonMap;

    expect(top['width'], 2);
    expect(top['style'], 'solid');
    expect(top['color'], '#EF4444');

    final radius = decoration['borderRadius'] as JsonMap;
    expect(radius['topLeft'], 8);
    expect(radius['bottomRight'], 8);
    expect(
      builtInMixSchemaContract.decode<BoxStyler>(payload),
      isA<MixSchemaDecodeSuccess>(),
    );
  });

  test('text parser emits text style + height behavior payloads', () {
    final payload = _textPayload('text-blue-500 font-bold leading-even');
    final style = payload['style'] as JsonMap;
    final heightBehavior = payload['textHeightBehavior'] as JsonMap;

    expect(style['color'], '#3B82F6');
    expect(style['fontWeight'], 'w700');
    expect(heightBehavior['leadingDistribution'], 'even');
    expect(
      builtInMixSchemaContract.decode<TextStyler>(payload),
      isA<MixSchemaDecodeSuccess>(),
    );
  });

  test('icon parser emits schema payloads that decode through mix_schema', () {
    final payload = _iconPayload('w-6 text-blue-700 opacity-50');

    expect(payload['type'], 'icon');
    expect(payload['size'], 24);
    expect(payload['color'], '#1D4ED8');
    expect(payload['opacity'], 0.5);
    expect(
      builtInMixSchemaContract.decode<IconStyler>(payload),
      isA<MixSchemaDecodeSuccess>(),
    );
  });

  test('icon parser takes the min of width and height for size', () {
    expect(_iconPayload('w-3 h-3')['size'], 12);
    expect(_iconPayload('w-8 h-4')['size'], 16);
    expect(_iconPayload('h-6')['size'], 24);
  });

  test('icon parser ignores variant-prefixed utilities as base', () {
    expect(_iconPayload('hover:text-red-500'), {'type': 'icon'});
    expect(_iconPayload('dark:text-white'), {'type': 'icon'});
    expect(_iconPayload('md:w-6'), {'type': 'icon'});
  });
}
