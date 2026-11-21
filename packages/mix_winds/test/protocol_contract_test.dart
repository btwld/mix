import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';
import 'package:mix_winds/mix_winds.dart';

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

  final decoded = switch (mixProtocol.decodeStyle<T>(
    encoded,
    options: const MixProtocolDecodeOptions(mode: .strict),
  )) {
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

  expect(
    encoded.length,
    greaterThan(2),
    reason: '$label produced an empty style payload',
  );
  expect(reencoded, encoded, reason: '$label was not canonical');
}

void main() {
  final boxCases = <({String category, String classes})>[
    (category: 'spacing', classes: 'p-4 px-6 mt-2 mx-3'),
    (
      category: 'margin-variants-on-styler-target',
      classes: 'hover:m-4 dark:mx-2',
    ),
    (
      category: 'fixed-min-max-sizing',
      classes: 'w-10 h-12 min-w-4 min-h-6 max-w-40 max-h-48',
    ),
    (category: 'auto-sizing', classes: 'w-auto h-auto'),
    (
      category: 'decoration-border-radius-shadow-overflow',
      classes:
          'bg-blue-500/50 overflow-hidden rounded-t-md shadow-md '
          'border-x-2 border-red-500',
    ),
    (category: 'widget-modifiers', classes: 'opacity-50 blur-sm'),
    (
      category: 'transforms',
      classes: 'scale-105 -rotate-45 translate-x-2 -translate-y-4',
    ),
    (
      category: 'default-typography',
      classes:
          'text-lg text-blue-700 font-bold leading-tight tracking-wide '
          'text-shadow-sm',
    ),
    (
      category: 'gradient-direction-and-stops',
      classes: 'bg-gradient-to-br from-red-500 via-white to-blue-500',
    ),
    (
      category: 'gradient-variant-inheritance',
      classes: 'bg-gradient-to-r from-red-500 to-blue-500 hover:via-white',
    ),
    (
      category: 'state-and-context-variants',
      classes:
          'hover:bg-red-600 focus:border-blue-500 active:scale-105 '
          'disabled:blur-sm enabled:rounded-lg dark:shadow-md light:p-2',
    ),
    (
      category: 'breakpoint-nested-and-not-variants',
      classes: 'sm:p-2 md:hover:scale-105 not-hover:opacity-50',
    ),
  ];
  final flexCases = <({String category, String classes})>[
    (
      category: 'layout-direction-alignment-and-gap',
      classes: 'flex flex-col items-baseline justify-evenly gap-4',
    ),
    (category: 'inline-layout', classes: 'inline-flex'),
    (
      category: 'box-families-on-flex-target',
      classes:
          'flex p-4 m-2 w-40 bg-blue-500 rounded-md border '
          'border-gray-200 shadow-sm scale-105 opacity-75 blur-sm '
          'text-sm font-medium',
    ),
    (
      category: 'target-specific-variants',
      classes: 'flex hover:items-center md:justify-between not-hover:gap-2',
    ),
  ];
  final textCases = <({String category, String classes})>[
    (
      category: 'typography',
      classes:
          'text-lg text-blue-700/50 font-bold leading-tight tracking-wide '
          'text-shadow-sm',
    ),
    (
      category: 'layout-directives-and-height-behavior',
      classes: 'text-center uppercase truncate leading-even leading-trim',
    ),
    (
      category: 'target-specific-variants',
      classes:
          'dark:text-white focus:text-red-500 md:hover:font-semibold '
          'not-hover:uppercase',
    ),
  ];
  final iconCases = <({String category, String classes})>[
    (
      category: 'size-color-and-opacity',
      classes: 'w-6 h-4 text-blue-700/50 opacity-75',
    ),
  ];

  group('canonical Mix Protocol output', () {
    for (final entry in boxCases) {
      test('box/${entry.category}', () {
        final compilation = TwParser().compileBox(entry.classes);

        expect(compilation.diagnostics, isEmpty, reason: entry.classes);
        _expectProtocolRoundTrip<BoxStyler>(
          category: 'box/${entry.category}',
          classes: entry.classes,
          styler: compilation.styler,
        );
      });
    }

    for (final entry in flexCases) {
      test('flex/${entry.category}', () {
        final compilation = TwParser().compileFlex(entry.classes);

        expect(compilation.diagnostics, isEmpty, reason: entry.classes);
        _expectProtocolRoundTrip<FlexBoxStyler>(
          category: 'flex/${entry.category}',
          classes: entry.classes,
          styler: compilation.styler,
        );
      });
    }

    for (final entry in textCases) {
      test('text/${entry.category}', () {
        final compilation = TwParser().compileText(entry.classes);

        expect(compilation.diagnostics, isEmpty, reason: entry.classes);
        _expectProtocolRoundTrip<TextStyler>(
          category: 'text/${entry.category}',
          classes: entry.classes,
          styler: compilation.styler,
        );
      });
    }

    for (final entry in iconCases) {
      test('icon/${entry.category}', () {
        final compilation = TwParser().compileIcon(entry.classes);

        expect(compilation.diagnostics, isEmpty, reason: entry.classes);
        _expectProtocolRoundTrip<IconStyler>(
          category: 'icon/${entry.category}',
          classes: entry.classes,
          styler: compilation.styler,
        );
      });
    }

    test('box/animation', () {
      const classes =
          'bg-blue-500 transition duration-300 ease-in-out delay-100';
      final compilation = TwParser().compileBox(classes);

      expect(compilation.diagnostics, isEmpty);
      expect(compilation.styler.$animation, isNotNull);
      _expectProtocolRoundTrip<BoxStyler>(
        category: 'box/animation',
        classes: classes,
        styler: compilation.styler,
      );
    });
  });

  test('runtime-only families expose a non-empty layout plan', () {
    final parser = TwParser();
    final box = parser.compileBox('w-full');
    final flex = parser.compileFlex('flex gap-x-4');
    final text = parser.compileText('mb-4');
    final icon = parser.compileIcon('me-1');

    expect([
      box.layoutPlan,
      flex.layoutPlan,
      text.layoutPlan,
      icon.layoutPlan,
    ], everyElement(predicate<TwLayoutPlan>((plan) => !plan.isEmpty)));
    expect([
      ...box.diagnostics,
      ...flex.diagnostics,
      ...text.diagnostics,
      ...icon.diagnostics,
    ], isEmpty);
  });

  test('focus-visible uses the additive Mix Protocol v1 selector', () {
    const classes = 'focus-visible:opacity-75';
    final compilation = TwParser().compileBox(classes);
    expect(compilation.diagnostics, isEmpty);
    expect(compilation.requiresWidgetRuntime, isFalse);
    _expectProtocolRoundTrip(
      category: 'focus-visible',
      classes: classes,
      styler: compilation.styler,
    );
  });

  testWidgets('compiled flex items apply the expected Flutter parent data', (
    tester,
  ) async {
    final cases = <String, ({int? flex, FlexFit? fit})>{
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
      'basis-4': (flex: null, fit: null),
    };

    for (final entry in cases.entries) {
      final compilation = TwParser().compileBox(entry.key);
      expect(compilation.diagnostics, isEmpty, reason: entry.key);
      expect(compilation.requiresWidgetRuntime, isTrue, reason: entry.key);
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              Div(
                classNames: entry.key,
                child: const SizedBox(width: 16, height: 16),
              ),
            ],
          ),
        ),
      );

      final row = tester.renderObject<RenderFlex>(find.byType(Row));
      final parentData = row.firstChild!.parentData! as FlexParentData;
      expect(parentData.flex, entry.value.flex, reason: entry.key);
      expect(parentData.fit, entry.value.fit, reason: entry.key);
      expect(tester.takeException(), isNull, reason: entry.key);
    }
  });
}
