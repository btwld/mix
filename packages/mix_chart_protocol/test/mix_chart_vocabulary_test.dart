import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:mix_chart_protocol/mix_chart_protocol.dart';

import 'schema_fixtures/chart_schema_cases.dart';

void main() {
  final protocol = mixChartProtocol;

  test('ready-to-use chart protocol does not widen the core singleton', () {
    final style = LineChartStyler();

    expect(protocol.encodeStyle(style), isA<MixProtocolSuccess<JsonMap>>());
    expect(mixProtocol.encodeStyle(style), isA<MixProtocolFailure<JsonMap>>());
  });

  test('covers every public mix_chart styler', () {
    final expectedBranches = <String, Object>{
      'bar_background': BarBackgroundStyler(),
      'bar_chart': BarChartStyler(),
      'bar_segment': BarSegmentStyler(),
      'bar': BarStyler(),
      'chart_area': ChartAreaStyler(),
      'chart_axis': ChartAxisStyler(),
      'chart_frame': ChartFrameStyler(),
      'chart_grid': ChartGridStyler(),
      'chart_marker': ChartMarkerStyler(),
      'chart_stroke': ChartStrokeStyler(),
      'chart_tooltip': ChartTooltipStyler(),
      'line_chart': LineChartStyler(),
      'line_series': LineSeriesStyler(),
      'pie_chart': PieChartStyler(),
      'pie_slice': PieSliceStyler(),
    };

    expect(
      mixChartVocabulary.branches.map((branch) => branch.name).toSet(),
      expectedBranches.keys.toSet(),
    );

    for (final entry in expectedBranches.entries) {
      final encodedResult = protocol.encodeStyle(entry.value);
      expect(encodedResult, isA<MixProtocolSuccess<JsonMap>>());
      final encoded = (encodedResult as MixProtocolSuccess<JsonMap>).value;

      expect(encoded['type'], 'mix_chart.v1.${entry.key}');
      expect(
        protocol.decodeStyle<Object>(encoded),
        isA<MixProtocolSuccess<Object>>().having(
          (result) => result.value,
          'value',
          entry.value,
        ),
      );
    }
  });

  test('round-trips a line chart with nested chart and core stylers', () {
    final style = LineChartStyler()
        .axis(ChartAxisStyler.label(TextStyler.fontSize(11)))
        .grid(ChartGridStyler.stroke(ChartStrokeStyler.width(1)))
        .series(
          LineSeriesStyler.stroke(
            ChartStrokeStyler(
              color: const ColorToken('color.chart.line')(),
              width: 3,
            ),
          ),
        );

    final encoded = protocol.encodeStyle(style);
    expect(encoded, isA<MixProtocolSuccess<JsonMap>>());
    final payload = (encoded as MixProtocolSuccess<JsonMap>).value;
    expect(payload['type'], 'mix_chart.v1.line_chart');

    expect(
      protocol.decodeStyle<LineChartStyler>(payload),
      isA<MixProtocolSuccess<LineChartStyler>>().having(
        (result) => result.value,
        'value',
        style,
      ),
    );
  });

  test('canonicalizes ordinary Flutter values used by chart mix fields', () {
    final styles = <Object>[
      ChartFrameStyler(
        border: Border.all(color: const Color(0xff112233), width: 2),
      ),
      ChartMarkerStyler(
        shadow: ShadowMix(
          color: Color(0x66000000),
          offset: Offset(1, 2),
          blurRadius: 4,
        ),
      ),
      ChartMarkerStyler.create(
        shadow: Prop.value(
          const Shadow(
            color: Color(0x55000000),
            offset: Offset(2, 3),
            blurRadius: 5,
          ),
        ),
      ),
      ChartTooltipStyler(
        border: const BorderSide(color: Color(0xff445566), width: 1),
        borderRadius: BorderRadius.circular(8),
        padding: const EdgeInsets.all(6),
      ),
      ChartStrokeStyler(
        gradient: const LinearGradient(
          colors: [Color(0xff112233), Color(0xff445566)],
        ),
      ),
      ChartStrokeStyler(dashArray: const []),
      BarStyler(
        gradient: const LinearGradient(
          colors: [Color(0xff778899), Color(0xffaabbcc)],
        ),
        borderRadius: BorderRadius.circular(4),
        border: const BorderSide(color: Color(0xff010203)),
      ),
      BarStyler(borderDashArray: const []),
    ];

    for (final style in styles) {
      final encodedResult = protocol.encodeStyle(style);
      expect(
        encodedResult,
        isA<MixProtocolSuccess<JsonMap>>(),
        reason: '$style',
      );
      final encoded = (encodedResult as MixProtocolSuccess<JsonMap>).value;
      final decodedResult = protocol.decodeStyle<Object>(encoded);
      expect(
        decodedResult,
        isA<MixProtocolSuccess<Object>>(),
        reason: '$style',
      );
      final decoded = (decodedResult as MixProtocolSuccess<Object>).value;

      expect(
        protocol.encodeStyle(decoded),
        isA<MixProtocolSuccess<JsonMap>>().having(
          (result) => result.value,
          'value',
          encoded,
        ),
      );
    }
  });

  test('round-trips border-side token references', () {
    const token = BorderSideToken('border.chart');
    final style = BarStyler(border: token());

    final encoded = protocol.encodeStyle(style);
    expect(
      encoded,
      isA<MixProtocolSuccess<JsonMap>>().having(
        (result) => result.value['border'],
        'border',
        {r'$token': token.name},
      ),
    );

    final payload = (encoded as MixProtocolSuccess<JsonMap>).value;
    expect(
      protocol.decodeStyle<BarStyler>(payload),
      isA<MixProtocolSuccess<BarStyler>>().having(
        (result) => result.value,
        'value',
        style,
      ),
    );
  });

  test('ordinary Flutter encoding ignores global converter mutations', () {
    const border = Border.fromBorderSide(
      BorderSide(color: Color(0xff112233), width: 2),
    );
    final style = ChartFrameStyler(border: border);
    final before = protocol.encodeStyle(style);
    expect(before, isA<MixProtocolSuccess<JsonMap>>());
    final beforePayload = (before as MixProtocolSuccess<JsonMap>).value;

    final registry = MixConverterRegistry.instance;
    registry.tryConvert<Border>(border);
    final previous = registry.get<Border>()!;
    registry.register<Border>(const _HostileBorderConverter());
    try {
      expect(
        protocol.encodeStyle(style),
        isA<MixProtocolSuccess<JsonMap>>().having(
          (result) => result.value,
          'value',
          beforePayload,
        ),
      );
    } finally {
      registry.register<Border>(previous);
    }
  });

  test('enforces chart numeric boundaries', () {
    for (final style in <Object>[
      ChartTooltipStyler(maxWidth: 0),
      ChartStrokeStyler(opacity: 0),
      ChartStrokeStyler(opacity: 1),
      ChartGridStyler(horizontalInterval: 0.1),
      ChartMarkerStyler(radius: 0),
    ]) {
      expect(
        protocol.encodeStyle(style),
        isA<MixProtocolSuccess<JsonMap>>(),
        reason: '$style',
      );
    }

    for (final style in <Object>[
      ChartStrokeStyler(opacity: 1.1),
      ChartGridStyler(horizontalInterval: 0),
      ChartMarkerStyler(radius: -1),
      ChartStrokeStyler(dashArray: const [0]),
      ChartAreaStyler(cutoffY: double.nan),
    ]) {
      expect(
        protocol.encodeStyle(style),
        isA<MixProtocolFailure<JsonMap>>(),
        reason: '$style',
      );
    }
  });

  test('reports a wrong known nested style at the chart field', () {
    final result = protocol.decodeStyle<ChartAxisStyler>({
      'v': 1,
      'type': 'mix_chart.v1.chart_axis',
      'label': {'type': 'box', 'padding': 4},
    });

    expect(result, isA<MixProtocolFailure<ChartAxisStyler>>());
    final failure = result as MixProtocolFailure<ChartAxisStyler>;
    expect(failure.errors, hasLength(1));
    expect(failure.errors.single.code, MixProtocolErrorCode.typeMismatch);
    expect(failure.errors.single.path, '/label');
  });

  test('round-trips extension variants, modifiers, and animation', () {
    final style = ChartStrokeStyler(
      width: 2,
      variants: [
        VariantStyle(
          const NamedVariant('muted'),
          ChartStrokeStyler(opacity: 0.5),
        ),
      ],
      modifier: WidgetModifierConfig.opacity(0.75),
      animation: CurveAnimationConfig.easeInOut(
        const Duration(milliseconds: 120),
      ),
    );

    final encoded = protocol.encodeStyle(style);
    expect(encoded, isA<MixProtocolSuccess<JsonMap>>());
    final payload = (encoded as MixProtocolSuccess<JsonMap>).value;

    expect(
      protocol.decodeStyle<ChartStrokeStyler>(payload),
      isA<MixProtocolSuccess<ChartStrokeStyler>>().having(
        (result) => result.value,
        'value',
        style,
      ),
    );
  });

  test('keeps canonical wire stable for every populated chart branch', () {
    final styles = populatedChartStyles();
    final encodedDocuments = <JsonMap>[];

    for (final style in styles) {
      final encodedResult = protocol.encodeStyle(style);
      if (encodedResult case MixProtocolFailure<JsonMap>(:final errors)) {
        fail('$style failed to encode: $errors');
      }
      final encoded = (encodedResult as MixProtocolSuccess<JsonMap>).value;
      encodedDocuments.add(encoded);
      final decodedResult = protocol.decodeStyle<Object>(encoded);
      if (decodedResult case MixProtocolFailure<Object>(:final errors)) {
        fail('$style failed to decode: $errors');
      }
      final decoded = (decodedResult as MixProtocolSuccess<Object>).value;

      expect(
        protocol.encodeStyle(decoded),
        isA<MixProtocolSuccess<JsonMap>>().having(
          (result) => result.value,
          'value',
          encoded,
        ),
        reason: style.runtimeType.toString(),
      );
    }

    // The checked-in schema/fixtures/style.json pins these documents; a wire
    // change shows up there as a reviewable diff.
    expect(encodedDocuments, hasLength(styles.length));
  });

  test('lenient mode derives extension list repair from field semantics', () {
    final payload = <String, Object?>{
      'v': 1,
      'type': 'mix_chart.v1.line_chart',
      'palette': [
        {r'$token': 'color.chart.primary'},
        {r'$token': 'color.chart.future', 'kind': 'future'},
      ],
    };

    final result = protocol.decodeStyle<LineChartStyler>(
      payload,
      options: const MixProtocolDecodeOptions(
        mode: MixProtocolDecodeMode.lenient,
      ),
    );

    if (result case MixProtocolFailure<LineChartStyler>(:final errors)) {
      fail('errors: $errors; warnings: ${result.warnings}');
    }
    expect(result, isA<MixProtocolSuccess<LineChartStyler>>());
    final success = result as MixProtocolSuccess<LineChartStyler>;
    expect(success.warnings, hasLength(1));
    expect(success.warnings.single.path, '/palette/1/kind');
    expect(
      protocol.encodeStyle(success.value),
      isA<MixProtocolSuccess<JsonMap>>().having(
        (encoded) => encoded.value,
        'value',
        {
          'type': 'mix_chart.v1.line_chart',
          'palette': [
            {r'$token': 'color.chart.primary'},
          ],
          'v': 1,
        },
      ),
    );
  });

  test('declares the chart vocabulary in exported schema metadata', () {
    // schema/style.schema.json is the checked-in export; a schema change
    // shows up there as a reviewable diff instead of a fingerprint.
    final schema = protocol.exportStyleJsonSchema();

    expect(schema['x-mix-protocol-vocabularies'], [
      {'id': 'mix_chart', 'wireVersion': 1},
    ]);
    final chartBranches = <String, Map<String, Object?>>{
      for (final branch in _branches(schema))
        if (_branchType(branch).startsWith('mix_chart.'))
          _branchType(branch): branch,
    };
    expect(chartBranches.keys.toSet(), {
      for (final branch in mixChartVocabulary.branches)
        'mix_chart.v1.${branch.name}',
    });
  });

  test('exported chart schemas preserve field types and numeric limits', () {
    for (final (branch, fields, valid) in chartFieldCases) {
      final payload = chartFieldPayload(branch, fields);
      expect(
        protocol.decodeStyle<Object>(payload),
        valid
            ? isA<MixProtocolSuccess<Object>>()
            : isA<MixProtocolFailure<Object>>(),
        reason: '$payload',
      );
    }
  });
}

final class _HostileBorderConverter implements MixConverter<Border> {
  const _HostileBorderConverter();

  @override
  Mix<Border> toMix(Border value, ConversionContext context) {
    return BorderMix.value(
      Border.all(color: const Color(0xffff0000), width: 99),
    );
  }
}

List<Map<String, Object?>> _branches(Map<String, Object?> schema) {
  return (schema['anyOf']! as List<Object?>).cast<Map<String, Object?>>();
}

String _branchType(Map<String, Object?> branch) {
  return (_properties(branch)['type']! as Map<String, Object?>)['const']!
      as String;
}

Map<String, Object?> _properties(Map<String, Object?> branch) {
  return (branch['properties']! as Map<Object?, Object?>).cast();
}
