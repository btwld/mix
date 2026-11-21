import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:mix_chart_protocol/mix_chart_protocol.dart';

import '../../mix_protocol/tool/styler_surface.dart' as inventory;

void main() {
  test('vocabulary and generated metadata cover every mix_chart styler', () {
    final surface = inventory.collectStylerSurface(
      sourceRoot: Directory('../mix_chart/lib/src'),
    );
    final vocabularyTypes = {
      for (final branch in mixChartVocabulary.branches)
        branch.valueType.toString(),
    };

    expect(vocabularyTypes, surface.stylerNames);
    expect(
      Map.fromEntries([
        _generatedFields(BarBackgroundStyler()),
        _generatedFields(BarChartStyler()),
        _generatedFields(BarSegmentStyler()),
        _generatedFields(BarStyler()),
        _generatedFields(ChartAreaStyler()),
        _generatedFields(ChartAxisStyler()),
        _generatedFields(ChartFrameStyler()),
        _generatedFields(ChartGridStyler()),
        _generatedFields(ChartMarkerStyler()),
        _generatedFields(ChartStrokeStyler()),
        _generatedFields(ChartTooltipStyler()),
        _generatedFields(LineChartStyler()),
        _generatedFields(LineSeriesStyler()),
        _generatedFields(PieChartStyler()),
        _generatedFields(PieSliceStyler()),
      ]),
      surface.fieldsByStyler,
    );
  });
}

MapEntry<String, Set<String>> _generatedFields<S extends Spec<S>>(
  Style<S> styler,
) {
  final metadata = switch (styler) {
    StylerFieldMetadata metadata => metadata,
    _ => throw StateError(
      '${styler.runtimeType} has no generated field metadata.',
    ),
  };

  return MapEntry(styler.runtimeType.toString(), metadata.$stylerFieldNames);
}
