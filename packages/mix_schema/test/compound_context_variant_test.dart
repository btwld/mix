import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('compound context variants', () {
    test('decodes context_all_of and canonicalizes condition ordering', () {
      final decoder = MixSchemaDecoder.builtIn();

      final firstResult = decoder.decode(
        _boxPayloadWithConditions([
          {'type': 'context_breakpoint', 'minWidth': 768.0},
          {'type': 'widget_state', 'state': 'hovered'},
        ]),
      );
      final secondResult = decoder.decode(
        _boxPayloadWithConditions([
          {'type': 'widget_state', 'state': 'hovered'},
          {'type': 'context_breakpoint', 'minWidth': 768.0},
        ]),
      );

      expect(
        firstResult.ok,
        isTrue,
        reason: firstResult.errors
            .map(
              (error) =>
                  '${error.code.wireValue} ${error.path} ${error.message}',
            )
            .join('\n'),
      );
      expect(
        secondResult.ok,
        isTrue,
        reason: secondResult.errors
            .map(
              (error) =>
                  '${error.code.wireValue} ${error.path} ${error.message}',
            )
            .join('\n'),
      );

      final firstStyle = firstResult.value! as BoxStyler;
      final secondStyle = secondResult.value! as BoxStyler;

      expect(firstStyle.$variants, hasLength(1));
      expect(secondStyle.$variants, hasLength(1));
      expect(
        firstStyle.$variants!.single.variant.key,
        secondStyle.$variants!.single.variant.key,
      );
    });

    test(
      'flattens nested context_all_of conditions into one canonical key',
      () {
        final decoder = MixSchemaDecoder.builtIn();

        final nestedResult = decoder.decode(
          _boxPayloadWithConditions([
            {
              'type': 'context_all_of',
              'conditions': [
                {'type': 'context_breakpoint', 'minWidth': 768.0},
                {'type': 'context_brightness', 'brightness': 'dark'},
              ],
            },
            {'type': 'widget_state', 'state': 'hovered'},
          ]),
        );
        final flatResult = decoder.decode(
          _boxPayloadWithConditions([
            {'type': 'context_brightness', 'brightness': 'dark'},
            {'type': 'widget_state', 'state': 'hovered'},
            {'type': 'context_breakpoint', 'minWidth': 768.0},
          ]),
        );

        expect(
          nestedResult.ok,
          isTrue,
          reason: nestedResult.errors
              .map(
                (error) =>
                    '${error.code.wireValue} ${error.path} ${error.message}',
              )
              .join('\n'),
        );
        expect(
          flatResult.ok,
          isTrue,
          reason: flatResult.errors
              .map(
                (error) =>
                    '${error.code.wireValue} ${error.path} ${error.message}',
              )
              .join('\n'),
        );

        final nestedStyle = nestedResult.value! as BoxStyler;
        final flatStyle = flatResult.value! as BoxStyler;

        expect(
          nestedStyle.$variants!.single.variant.key,
          flatStyle.$variants!.single.variant.key,
        );
      },
    );

    test('rejects invalid compound condition payloads with stable paths', () {
      final decoder = MixSchemaDecoder.builtIn();
      final result = decoder.decode({
        'type': 'box',
        'variants': [
          {
            'type': 'context_all_of',
            'conditions': [
              {'type': 'named', 'name': 'primary'},
              {'type': 'context_variant_builder', 'id': 'builder'},
              {'type': 'context_brightness', 'brightness': 'missing'},
            ],
            'style': _widthStyle(200),
          },
        ],
      });

      expect(result.ok, isFalse);
      expect(
        result.errors.map((error) => (error.code, error.path)).toList(),
        containsAll(<(MixSchemaErrorCode, String)>[
          (MixSchemaErrorCode.unknownType, '#/variants/0/conditions/0/type'),
          (MixSchemaErrorCode.unknownType, '#/variants/0/conditions/1/type'),
          (
            MixSchemaErrorCode.invalidEnum,
            '#/variants/0/conditions/2/brightness',
          ),
        ]),
      );
    });

    test('rejects metadata inside compound variant styles', () {
      final decoder = MixSchemaDecoder.builtIn();
      final result = decoder.decode({
        'type': 'box',
        'variants': [
          {
            'type': 'context_all_of',
            'conditions': [
              {'type': 'context_breakpoint', 'minWidth': 768.0},
              {'type': 'widget_state', 'state': 'hovered'},
            ],
            'style': {
              'animation': {'duration': 200, 'curve': 'easeIn'},
              'modifiers': [
                {'type': 'opacity', 'value': 0.5},
              ],
              'variants': [
                {
                  'type': 'widget_state',
                  'state': 'hovered',
                  'style': {'clipBehavior': 'hardEdge'},
                },
              ],
            },
          },
        ],
      });

      expect(result.ok, isFalse);
      expect(
        result.errors.map((error) => (error.code, error.path)).toList(),
        containsAll(<(MixSchemaErrorCode, String)>[
          (MixSchemaErrorCode.unknownField, '#/variants/0/style/animation'),
          (MixSchemaErrorCode.unknownField, '#/variants/0/style/modifiers'),
          (MixSchemaErrorCode.unknownField, '#/variants/0/style/variants'),
        ]),
      );
    });

    test('requires at least two conditions', () {
      final decoder = MixSchemaDecoder.builtIn();

      final emptyResult = decoder.decode(_boxPayloadWithConditions([]));
      final singleResult = decoder.decode(
        _boxPayloadWithConditions([
          {'type': 'widget_state', 'state': 'hovered'},
        ]),
      );

      expect(emptyResult.ok, isFalse);
      expect(
        emptyResult.errors.single.code,
        MixSchemaErrorCode.validationFailed,
      );
      expect(emptyResult.errors.single.path, '#/variants/0/conditions');

      expect(singleResult.ok, isFalse);
      expect(
        singleResult.errors.single.code,
        MixSchemaErrorCode.validationFailed,
      );
      expect(singleResult.errors.single.path, '#/variants/0/conditions');
    });

    test(
      'accepts sparse breakpoint payloads at top level and inside conditions',
      () {
        final decoder = MixSchemaDecoder.builtIn();

        final topLevelResult = decoder.decode(
          _boxPayloadWithVariant({
            'type': 'context_breakpoint',
            'maxWidth': 640.0,
            'style': _widthStyle(120),
          }),
        );
        final compoundResult = decoder.decode(
          _boxPayloadWithConditions([
            {'type': 'context_breakpoint', 'maxWidth': 640.0},
            {'type': 'widget_state', 'state': 'hovered'},
          ]),
        );

        expect(
          topLevelResult.ok,
          isTrue,
          reason: topLevelResult.errors
              .map(
                (error) =>
                    '${error.code.wireValue} ${error.path} ${error.message}',
              )
              .join('\n'),
        );
        expect(
          compoundResult.ok,
          isTrue,
          reason: compoundResult.errors
              .map(
                (error) =>
                    '${error.code.wireValue} ${error.path} ${error.message}',
              )
              .join('\n'),
        );
      },
    );

    test(
      'rejects not(disabled) the same way at top level and inside conditions',
      () {
        final decoder = MixSchemaDecoder.builtIn();

        final topLevelResult = decoder.decode(
          _boxPayloadWithVariant({
            'type': 'context_not_widget_state',
            'state': 'disabled',
            'style': _widthStyle(120),
          }),
        );
        final compoundResult = decoder.decode(
          _boxPayloadWithConditions([
            {'type': 'context_not_widget_state', 'state': 'disabled'},
            {'type': 'widget_state', 'state': 'hovered'},
          ]),
        );

        expect(topLevelResult.ok, isFalse);
        expect(compoundResult.ok, isFalse);

        final topLevelError = topLevelResult.errors.single;
        final compoundError = compoundResult.errors.single;

        expect(topLevelError.code, MixSchemaErrorCode.validationFailed);
        expect(compoundError.code, MixSchemaErrorCode.validationFailed);
        expect(topLevelError.message, 'Use enabled for not(disabled).');
        expect(compoundError.message, 'Use enabled for not(disabled).');
        expect(topLevelError.path, '#/variants/0');
        expect(compoundError.path, '#/variants/0/conditions/0');
      },
    );

    test(
      'surfaces matching invalid enum errors at top level and inside conditions',
      () {
        final decoder = MixSchemaDecoder.builtIn();

        final topLevelResult = decoder.decode(
          _boxPayloadWithVariant({
            'type': 'widget_state',
            'state': 'missing',
            'style': _widthStyle(120),
          }),
        );
        final compoundResult = decoder.decode(
          _boxPayloadWithConditions([
            {'type': 'widget_state', 'state': 'missing'},
            {'type': 'enabled'},
          ]),
        );

        expect(topLevelResult.ok, isFalse);
        expect(compoundResult.ok, isFalse);

        final topLevelError = topLevelResult.errors.single;
        final compoundError = compoundResult.errors.single;

        expect(topLevelError.code, MixSchemaErrorCode.invalidEnum);
        expect(compoundError.code, MixSchemaErrorCode.invalidEnum);
        expect(topLevelError.path, '#/variants/0/state');
        expect(compoundError.path, '#/variants/0/conditions/0/state');
      },
    );

    testWidgets('applies compound style only when every condition is active', (
      tester,
    ) async {
      final decoder = MixSchemaDecoder.builtIn();
      final result = decoder.decode(
        _boxPayloadWithConditions([
          {'type': 'context_breakpoint', 'minWidth': 768.0},
          {'type': 'widget_state', 'state': 'hovered'},
        ]),
      );

      expect(
        result.ok,
        isTrue,
        reason: result.errors
            .map(
              (error) =>
                  '${error.code.wireValue} ${error.path} ${error.message}',
            )
            .join('\n'),
      );
      final style = result.value! as BoxStyler;

      final bothActiveConstraints = await _resolveConstraints(
        tester,
        style,
        size: const Size(1024, 800),
        states: const {WidgetState.hovered},
      );
      final onlyHoverConstraints = await _resolveConstraints(
        tester,
        style,
        size: const Size(600, 800),
        states: const {WidgetState.hovered},
      );

      expect(
        bothActiveConstraints,
        const BoxConstraints(minWidth: 200, maxWidth: 200),
      );
      expect(onlyHoverConstraints, isNull);
    });

    testWidgets(
      'compound variants keep widget state precedence with simple variants',
      (tester) async {
        final decoder = MixSchemaDecoder.builtIn();
        final result = decoder.decode({
          'type': 'box',
          'variants': [
            {
              'type': 'context_all_of',
              'conditions': [
                {'type': 'context_breakpoint', 'minWidth': 768.0},
                {'type': 'widget_state', 'state': 'hovered'},
              ],
              'style': _widthStyle(200),
            },
            {
              'type': 'widget_state',
              'state': 'hovered',
              'style': _widthStyle(300),
            },
          ],
        });

        expect(
          result.ok,
          isTrue,
          reason: result.errors
              .map(
                (error) =>
                    '${error.code.wireValue} ${error.path} ${error.message}',
              )
              .join('\n'),
        );
        final style = result.value! as BoxStyler;
        final constraints = await _resolveConstraints(
          tester,
          style,
          size: const Size(1024, 800),
          states: const {WidgetState.hovered},
        );

        expect(constraints, const BoxConstraints(minWidth: 300, maxWidth: 300));
      },
    );
  });
}

Map<String, Object?> _boxPayloadWithVariant(Map<String, Object?> variant) {
  return {
    'type': 'box',
    'variants': [variant],
  };
}

Map<String, Object?> _boxPayloadWithConditions(
  List<Map<String, Object?>> conditions,
) {
  return _boxPayloadWithVariant({
    'type': 'context_all_of',
    'conditions': conditions,
    'style': _widthStyle(200),
  });
}

Map<String, Object?> _widthStyle(double width) {
  return {
    'constraints': {'minWidth': width, 'maxWidth': width},
  };
}

Future<BoxConstraints?> _resolveConstraints(
  WidgetTester tester,
  BoxStyler style, {
  required Size size,
  required Set<WidgetState> states,
}) async {
  late BoxConstraints? constraints;

  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: size),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: WidgetStateProvider(
          states: states,
          child: Builder(
            builder: (context) {
              constraints = style.build(context).spec.constraints;
              return const SizedBox();
            },
          ),
        ),
      ),
    ),
  );

  return constraints;
}
