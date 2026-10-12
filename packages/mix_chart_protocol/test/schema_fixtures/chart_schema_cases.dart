import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:mix_chart_protocol/mix_chart_protocol.dart';

/// One populated instance of every chart styler branch.
///
/// Their canonical encodings are written to `schema/fixtures/style.json` as
/// accept documents, which pins the declared chart v1 wire and lets Ajv
/// validate it against the exported schema.
List<Object> populatedChartStyles() {
  final gradient = const LinearGradient(
    colors: [Color(0xff112233), Color(0xff445566)],
  );
  final borderSide = const BorderSide(color: Color(0xff778899), width: 2);
  return <Object>[
    BarBackgroundStyler(
      show: true,
      fromY: -4,
      toY: 8,
      color: const Color(0xff102030),
      gradient: gradient,
    ),
    BarChartStyler(
      frame: ChartFrameStyler(showBorder: true),
      axis: ChartAxisStyler(showLabels: true),
      xAxis: ChartAxisStyler(labelSpace: 4),
      yAxis: ChartAxisStyler(reservedSize: 24),
      topAxis: ChartAxisStyler(fitInside: true),
      rightAxis: ChartAxisStyler(drawBelowEverything: false),
      grid: ChartGridStyler(show: true),
      bar: BarStyler(width: 12),
      segment: BarSegmentStyler(color: const Color(0xff203040)),
      palette: const [Color(0xff304050), Color(0xff405060)],
      groupSpacing: 8,
      barSpacing: 2,
      alignment: BarAlignment.values.first,
      tooltip: ChartTooltipStyler(margin: 6),
    ),
    BarSegmentStyler(
      color: const Color(0xff506070),
      gradient: gradient,
      border: borderSide,
      label: TextStyler(maxLines: 1),
    ),
    BarStyler(
      color: const Color(0xff607080),
      gradient: gradient,
      width: 16,
      borderRadius: BorderRadius.circular(5),
      border: borderSide,
      borderDashArray: const [2, 4],
      background: BarBackgroundStyler(show: true),
      label: TextStyler.fontSize(11),
      labelOffset: const Offset(1, 2),
      labelAngle: 0.25,
    ),
    ChartAreaStyler(
      show: true,
      color: const Color(0xff708090),
      gradient: gradient,
      cutoffY: -1,
      applyCutoff: true,
    ),
    ChartAxisStyler(
      showLabels: true,
      label: TextStyler.fontSize(10),
      reservedSize: 30,
      labelSpace: 5,
      labelAngle: 0.5,
      fitInside: true,
      fitInsideDistance: 3,
      nameSize: 12,
      drawBelowEverything: false,
      alignment: ChartAxisLabelAlignment.values.first,
    ),
    ChartFrameStyler(
      backgroundColor: const Color(0xff8090a0),
      border: Border.all(color: const Color(0xff90a0b0)),
      showBorder: true,
      clip: true,
      rotationQuarterTurns: 1,
    ),
    ChartGridStyler(
      show: true,
      showHorizontal: true,
      showVertical: false,
      horizontalInterval: 2,
      verticalInterval: 4,
      stroke: ChartStrokeStyler(width: 1),
    ),
    ChartMarkerStyler(
      show: true,
      shape: ChartMarkerShape.values.first,
      color: const Color(0xffa0b0c0),
      radius: 5,
      borderColor: const Color(0xffb0c0d0),
      borderWidth: 1,
      shadow: ShadowMix(
        color: const Color(0x44000000),
        offset: const Offset(1, 1),
        blurRadius: 3,
      ),
    ),
    ChartStrokeStyler(
      color: const Color(0xffc0d0e0),
      gradient: gradient,
      width: 3,
      dashArray: const [3, 2],
      opacity: 0.8,
    ),
    ChartTooltipStyler(
      backgroundColor: const Color(0xffd0e0f0),
      border: borderSide,
      borderRadius: BorderRadius.circular(6),
      padding: const EdgeInsets.all(8),
      margin: 4,
      maxWidth: 240,
      fitHorizontally: true,
      fitVertically: false,
      text: TextStyler(maxLines: 2),
    ),
    LineChartStyler(
      frame: ChartFrameStyler(clip: true),
      axis: ChartAxisStyler(showLabels: true),
      xAxis: ChartAxisStyler(labelSpace: 2),
      yAxis: ChartAxisStyler(reservedSize: 20),
      topAxis: ChartAxisStyler(showLabels: false),
      rightAxis: ChartAxisStyler(fitInside: true),
      grid: ChartGridStyler(show: true),
      series: LineSeriesStyler(show: true),
      palette: const [Color(0xffe0f001)],
      tooltip: ChartTooltipStyler(maxWidth: 180),
    ),
    LineSeriesStyler(
      show: true,
      stroke: ChartStrokeStyler(width: 2),
      curve: LineCurve.values.first,
      smoothness: 0.4,
      preventCurveOvershooting: true,
      curveOvershootingThreshold: 3,
      roundStrokeCap: true,
      roundStrokeJoin: false,
      marker: ChartMarkerStyler(radius: 4),
      belowArea: ChartAreaStyler(show: true),
      aboveArea: ChartAreaStyler(show: false),
      shadow: ShadowMix(blurRadius: 2),
    ),
    PieChartStyler(
      frame: ChartFrameStyler(showBorder: true),
      slice: PieSliceStyler(radius: 80),
      selectedSliceRadiusOffset: 6,
      palette: const [Color(0xfff00112), Color(0xff011223)],
      centerRadius: 30,
      centerColor: const Color(0xff122334),
      sliceSpacing: 2,
      startAngle: -1.5,
      sunbeamLabels: true,
      tooltip: ChartTooltipStyler(margin: 3),
    ),
    PieSliceStyler(
      color: const Color(0xff233445),
      gradient: gradient,
      radius: 90,
      showLabel: true,
      label: TextStyler.fontSize(12),
      labelPosition: 0.7,
      border: borderSide,
      cornerRadius: 4,
      badgePosition: 0.9,
    ),
  ];
}

/// Field-level documents with the expected verdict for each chart branch.
const List<(String, JsonMap, bool)> chartFieldCases = [
  ('chart_stroke', {'width': 2}, true),
  (
    'chart_stroke',
    {
      'width': {r'$token': 'stroke.width', 'kind': 'double'},
    },
    true,
  ),
  ('chart_stroke', {'width': true}, false),
  ('chart_stroke', {'opacity': 1.1}, false),
  ('chart_grid', {'horizontalInterval': 0}, false),
  ('chart_marker', {'radius': -1}, false),
  (
    'chart_tooltip',
    {
      'padding': {'left': 8, 'top': 4},
    },
    true,
  ),
  (
    'chart_tooltip',
    {
      'padding': {r'$token': 'space.padding', 'kind': 'space'},
    },
    true,
  ),
  ('chart_tooltip', {'padding': true}, false),
  (
    'chart_tooltip',
    {
      'padding': {r'$token': 'color.padding', 'kind': 'color'},
    },
    false,
  ),
];

JsonMap chartFieldPayload(String branch, JsonMap fields) => {
  'v': 1,
  'type': 'mix_chart.v1.$branch',
  ...fields,
};
