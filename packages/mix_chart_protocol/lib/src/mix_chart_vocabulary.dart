import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:mix_protocol/authoring.dart';

/// Version-one wire vocabulary for public `mix_chart` stylers.
final MixProtocolVocabulary mixChartVocabulary = MixProtocolVocabulary(
  id: 'mix_chart',
  wireVersion: 1,
  branches: [
    MixProtocolStylerBranch<BarBackgroundStyler>(
      name: 'bar_background',
      codec: _barBackgroundCodec,
    ),
    MixProtocolStylerBranch<BarChartStyler>(
      name: 'bar_chart',
      codec: _barChartCodec,
    ),
    MixProtocolStylerBranch<BarSegmentStyler>(
      name: 'bar_segment',
      codec: _barSegmentCodec,
    ),
    MixProtocolStylerBranch<BarStyler>(name: 'bar', codec: _barCodec),
    MixProtocolStylerBranch<ChartAreaStyler>(
      name: 'chart_area',
      codec: _chartAreaCodec,
    ),
    MixProtocolStylerBranch<ChartAxisStyler>(
      name: 'chart_axis',
      codec: _chartAxisCodec,
    ),
    MixProtocolStylerBranch<ChartFrameStyler>(
      name: 'chart_frame',
      codec: _chartFrameCodec,
    ),
    MixProtocolStylerBranch<ChartGridStyler>(
      name: 'chart_grid',
      codec: _chartGridCodec,
    ),
    MixProtocolStylerBranch<ChartMarkerStyler>(
      name: 'chart_marker',
      codec: _chartMarkerCodec,
    ),
    MixProtocolStylerBranch<ChartStrokeStyler>(
      name: 'chart_stroke',
      codec: _chartStrokeCodec,
    ),
    MixProtocolStylerBranch<ChartTooltipStyler>(
      name: 'chart_tooltip',
      codec: _chartTooltipCodec,
    ),
    MixProtocolStylerBranch<LineChartStyler>(
      name: 'line_chart',
      codec: _lineChartCodec,
    ),
    MixProtocolStylerBranch<LineSeriesStyler>(
      name: 'line_series',
      codec: _lineSeriesCodec,
    ),
    MixProtocolStylerBranch<PieChartStyler>(
      name: 'pie_chart',
      codec: _pieChartCodec,
    ),
    MixProtocolStylerBranch<PieSliceStyler>(
      name: 'pie_slice',
      codec: _pieSliceCodec,
    ),
  ],
);

MixProtocolStylerCodec<BarBackgroundStyler> _barBackgroundCodec(
  MixProtocolBranchContext context,
) {
  final show = MixProtocolField.value<BarBackgroundStyler, bool>(
    wire: 'show',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$show,
  );
  final fromY = MixProtocolField.value<BarBackgroundStyler, double>(
    wire: 'fromY',
    codec: MixProtocolCodecs.number(),
    read: (value) => value.$fromY,
  );
  final toY = MixProtocolField.value<BarBackgroundStyler, double>(
    wire: 'toY',
    codec: MixProtocolCodecs.number(),
    read: (value) => value.$toY,
  );
  final color = MixProtocolField.value<BarBackgroundStyler, Color>(
    wire: 'color',
    codec: MixProtocolCodecs.color(),
    read: (value) => value.$color,
  );
  final gradient =
      MixProtocolField.mix<BarBackgroundStyler, GradientMix, Gradient>(
        wire: 'gradient',
        codec: MixProtocolCodecs.gradient(),
        read: (value) => value.$gradient,
      );

  return MixProtocolStylerCodec.forStyler<
    BarBackgroundStyler,
    BarBackgroundSpec
  >(
    context: context,
    fields: [show, fromY, toY, color, gradient],
    build: (data, metadata) => BarBackgroundStyler.create(
      show: show.value(data),
      fromY: fromY.value(data),
      toY: toY.value(data),
      color: color.value(data),
      gradient: gradient.value(data),
      variants: metadata.variants(data),
      modifier: metadata.modifier(data),
      animation: metadata.animation(data),
    ),
  );
}

MixProtocolStylerCodec<BarChartStyler> _barChartCodec(
  MixProtocolBranchContext context,
) {
  final frame = MixProtocolField.style<BarChartStyler, ChartFrameSpec>(
    wire: 'frame',
    context: context,
    read: (value) => value.$frame,
  );
  final axis = MixProtocolField.style<BarChartStyler, ChartAxisSpec>(
    wire: 'axis',
    context: context,
    read: (value) => value.$axis,
  );
  final xAxis = MixProtocolField.style<BarChartStyler, ChartAxisSpec>(
    wire: 'xAxis',
    context: context,
    read: (value) => value.$xAxis,
  );
  final yAxis = MixProtocolField.style<BarChartStyler, ChartAxisSpec>(
    wire: 'yAxis',
    context: context,
    read: (value) => value.$yAxis,
  );
  final topAxis = MixProtocolField.style<BarChartStyler, ChartAxisSpec>(
    wire: 'topAxis',
    context: context,
    read: (value) => value.$topAxis,
  );
  final rightAxis = MixProtocolField.style<BarChartStyler, ChartAxisSpec>(
    wire: 'rightAxis',
    context: context,
    read: (value) => value.$rightAxis,
  );
  final grid = MixProtocolField.style<BarChartStyler, ChartGridSpec>(
    wire: 'grid',
    context: context,
    read: (value) => value.$grid,
  );
  final bar = MixProtocolField.style<BarChartStyler, BarSpec>(
    wire: 'bar',
    context: context,
    read: (value) => value.$bar,
  );
  final segment = MixProtocolField.style<BarChartStyler, BarSegmentSpec>(
    wire: 'segment',
    context: context,
    read: (value) => value.$segment,
  );
  final palette = MixProtocolField.value<BarChartStyler, List<Color>>(
    wire: 'palette',
    codec: MixProtocolCodecs.list(MixProtocolCodecs.color()),
    read: (value) => value.$palette,
  );
  final groupSpacing = MixProtocolField.value<BarChartStyler, double>(
    wire: 'groupSpacing',
    codec: MixProtocolCodecs.nonNegativeNumber(),
    read: (value) => value.$groupSpacing,
  );
  final barSpacing = MixProtocolField.value<BarChartStyler, double>(
    wire: 'barSpacing',
    codec: MixProtocolCodecs.nonNegativeNumber(),
    read: (value) => value.$barSpacing,
  );
  final alignment = MixProtocolField.value<BarChartStyler, BarAlignment>(
    wire: 'alignment',
    codec: MixProtocolCodecs.enumName(BarAlignment.values),
    read: (value) => value.$alignment,
  );
  final tooltip = MixProtocolField.style<BarChartStyler, ChartTooltipSpec>(
    wire: 'tooltip',
    context: context,
    read: (value) => value.$tooltip,
  );

  return MixProtocolStylerCodec.forStyler<BarChartStyler, BarChartSpec>(
    context: context,
    fields: [
      frame,
      axis,
      xAxis,
      yAxis,
      topAxis,
      rightAxis,
      grid,
      bar,
      segment,
      palette,
      groupSpacing,
      barSpacing,
      alignment,
      tooltip,
    ],
    build: (data, metadata) => BarChartStyler.create(
      frame: frame.value(data),
      axis: axis.value(data),
      xAxis: xAxis.value(data),
      yAxis: yAxis.value(data),
      topAxis: topAxis.value(data),
      rightAxis: rightAxis.value(data),
      grid: grid.value(data),
      bar: bar.value(data),
      segment: segment.value(data),
      palette: palette.value(data),
      groupSpacing: groupSpacing.value(data),
      barSpacing: barSpacing.value(data),
      alignment: alignment.value(data),
      tooltip: tooltip.value(data),
      variants: metadata.variants(data),
      modifier: metadata.modifier(data),
      animation: metadata.animation(data),
    ),
  );
}

MixProtocolStylerCodec<BarSegmentStyler> _barSegmentCodec(
  MixProtocolBranchContext context,
) {
  final color = MixProtocolField.value<BarSegmentStyler, Color>(
    wire: 'color',
    codec: MixProtocolCodecs.color(),
    read: (value) => value.$color,
  );
  final gradient =
      MixProtocolField.mix<BarSegmentStyler, GradientMix, Gradient>(
        wire: 'gradient',
        codec: MixProtocolCodecs.gradient(),
        read: (value) => value.$gradient,
      );
  final border =
      MixProtocolField.mix<BarSegmentStyler, BorderSideMix, BorderSide>(
        wire: 'border',
        codec: MixProtocolCodecs.borderSide(),
        read: (value) => value.$border,
      );
  final label = MixProtocolField.style<BarSegmentStyler, TextSpec>(
    wire: 'label',
    context: context,
    read: (value) => value.$label,
  );

  return MixProtocolStylerCodec.forStyler<BarSegmentStyler, BarSegmentSpec>(
    context: context,
    fields: [color, gradient, border, label],
    build: (data, metadata) => BarSegmentStyler.create(
      color: color.value(data),
      gradient: gradient.value(data),
      border: border.value(data),
      label: label.value(data),
      variants: metadata.variants(data),
      modifier: metadata.modifier(data),
      animation: metadata.animation(data),
    ),
  );
}

MixProtocolStylerCodec<BarStyler> _barCodec(MixProtocolBranchContext context) {
  final color = MixProtocolField.value<BarStyler, Color>(
    wire: 'color',
    codec: MixProtocolCodecs.color(),
    read: (value) => value.$color,
  );
  final gradient = MixProtocolField.mix<BarStyler, GradientMix, Gradient>(
    wire: 'gradient',
    codec: MixProtocolCodecs.gradient(),
    read: (value) => value.$gradient,
  );
  final width = MixProtocolField.value<BarStyler, double>(
    wire: 'width',
    codec: MixProtocolCodecs.nonNegativeNumber(),
    read: (value) => value.$width,
  );
  final borderRadius =
      MixProtocolField.mix<BarStyler, BorderRadiusMix, BorderRadius>(
        wire: 'borderRadius',
        codec: MixProtocolCodecs.borderRadius(),
        read: (value) => value.$borderRadius,
      );
  final border = MixProtocolField.mix<BarStyler, BorderSideMix, BorderSide>(
    wire: 'border',
    codec: MixProtocolCodecs.borderSide(),
    read: (value) => value.$border,
  );
  final borderDashArray = MixProtocolField.value<BarStyler, List<int>>(
    wire: 'borderDashArray',
    codec: MixProtocolCodecs.list(MixProtocolCodecs.integer(min: 1)),
    read: (value) => value.$borderDashArray,
  );
  final background = MixProtocolField.style<BarStyler, BarBackgroundSpec>(
    wire: 'background',
    context: context,
    read: (value) => value.$background,
  );
  final label = MixProtocolField.style<BarStyler, TextSpec>(
    wire: 'label',
    context: context,
    read: (value) => value.$label,
  );
  final labelOffset = MixProtocolField.value<BarStyler, Offset>(
    wire: 'labelOffset',
    codec: MixProtocolCodecs.offset(),
    read: (value) => value.$labelOffset,
  );
  final labelAngle = MixProtocolField.value<BarStyler, double>(
    wire: 'labelAngle',
    codec: MixProtocolCodecs.number(),
    read: (value) => value.$labelAngle,
  );

  return MixProtocolStylerCodec.forStyler<BarStyler, BarSpec>(
    context: context,
    fields: [
      color,
      gradient,
      width,
      borderRadius,
      border,
      borderDashArray,
      background,
      label,
      labelOffset,
      labelAngle,
    ],
    build: (data, metadata) => BarStyler.create(
      color: color.value(data),
      gradient: gradient.value(data),
      width: width.value(data),
      borderRadius: borderRadius.value(data),
      border: border.value(data),
      borderDashArray: borderDashArray.value(data),
      background: background.value(data),
      label: label.value(data),
      labelOffset: labelOffset.value(data),
      labelAngle: labelAngle.value(data),
      variants: metadata.variants(data),
      modifier: metadata.modifier(data),
      animation: metadata.animation(data),
    ),
  );
}

MixProtocolStylerCodec<ChartAreaStyler> _chartAreaCodec(
  MixProtocolBranchContext context,
) {
  final show = MixProtocolField.value<ChartAreaStyler, bool>(
    wire: 'show',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$show,
  );
  final color = MixProtocolField.value<ChartAreaStyler, Color>(
    wire: 'color',
    codec: MixProtocolCodecs.color(),
    read: (value) => value.$color,
  );
  final gradient = MixProtocolField.mix<ChartAreaStyler, GradientMix, Gradient>(
    wire: 'gradient',
    codec: MixProtocolCodecs.gradient(),
    read: (value) => value.$gradient,
  );
  final cutoffY = MixProtocolField.value<ChartAreaStyler, double>(
    wire: 'cutoffY',
    codec: MixProtocolCodecs.number(),
    read: (value) => value.$cutoffY,
  );
  final applyCutoff = MixProtocolField.value<ChartAreaStyler, bool>(
    wire: 'applyCutoff',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$applyCutoff,
  );

  return MixProtocolStylerCodec.forStyler<ChartAreaStyler, ChartAreaSpec>(
    context: context,
    fields: [show, color, gradient, cutoffY, applyCutoff],
    build: (data, metadata) => ChartAreaStyler.create(
      show: show.value(data),
      color: color.value(data),
      gradient: gradient.value(data),
      cutoffY: cutoffY.value(data),
      applyCutoff: applyCutoff.value(data),
      variants: metadata.variants(data),
      modifier: metadata.modifier(data),
      animation: metadata.animation(data),
    ),
  );
}

MixProtocolStylerCodec<ChartFrameStyler> _chartFrameCodec(
  MixProtocolBranchContext context,
) {
  final backgroundColor = MixProtocolField.value<ChartFrameStyler, Color>(
    wire: 'backgroundColor',
    codec: MixProtocolCodecs.color(),
    read: (value) => value.$backgroundColor,
  );
  final border = MixProtocolField.mix<ChartFrameStyler, BorderMix, Border>(
    wire: 'border',
    codec: MixProtocolCodecs.border(),
    read: (value) => value.$border,
  );
  final showBorder = MixProtocolField.value<ChartFrameStyler, bool>(
    wire: 'showBorder',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$showBorder,
  );
  final clip = MixProtocolField.value<ChartFrameStyler, bool>(
    wire: 'clip',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$clip,
  );
  final rotationQuarterTurns = MixProtocolField.value<ChartFrameStyler, int>(
    wire: 'rotationQuarterTurns',
    codec: MixProtocolCodecs.integer(),
    read: (value) => value.$rotationQuarterTurns,
  );

  return MixProtocolStylerCodec.forStyler<ChartFrameStyler, ChartFrameSpec>(
    context: context,
    fields: [backgroundColor, border, showBorder, clip, rotationQuarterTurns],
    build: (data, metadata) => ChartFrameStyler.create(
      backgroundColor: backgroundColor.value(data),
      border: border.value(data),
      showBorder: showBorder.value(data),
      clip: clip.value(data),
      rotationQuarterTurns: rotationQuarterTurns.value(data),
      variants: metadata.variants(data),
      modifier: metadata.modifier(data),
      animation: metadata.animation(data),
    ),
  );
}

MixProtocolStylerCodec<ChartMarkerStyler> _chartMarkerCodec(
  MixProtocolBranchContext context,
) {
  final show = MixProtocolField.value<ChartMarkerStyler, bool>(
    wire: 'show',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$show,
  );
  final shape = MixProtocolField.value<ChartMarkerStyler, ChartMarkerShape>(
    wire: 'shape',
    codec: MixProtocolCodecs.enumName(ChartMarkerShape.values),
    read: (value) => value.$shape,
  );
  final color = MixProtocolField.value<ChartMarkerStyler, Color>(
    wire: 'color',
    codec: MixProtocolCodecs.color(),
    read: (value) => value.$color,
  );
  final radius = MixProtocolField.value<ChartMarkerStyler, double>(
    wire: 'radius',
    codec: MixProtocolCodecs.nonNegativeNumber(),
    read: (value) => value.$radius,
  );
  final borderColor = MixProtocolField.value<ChartMarkerStyler, Color>(
    wire: 'borderColor',
    codec: MixProtocolCodecs.color(),
    read: (value) => value.$borderColor,
  );
  final borderWidth = MixProtocolField.value<ChartMarkerStyler, double>(
    wire: 'borderWidth',
    codec: MixProtocolCodecs.nonNegativeNumber(),
    read: (value) => value.$borderWidth,
  );
  final shadow = MixProtocolField.mix<ChartMarkerStyler, ShadowMix, Shadow>(
    wire: 'shadow',
    codec: MixProtocolCodecs.shadow(),
    read: (value) => value.$shadow,
  );

  return MixProtocolStylerCodec.forStyler<ChartMarkerStyler, ChartMarkerSpec>(
    context: context,
    fields: [show, shape, color, radius, borderColor, borderWidth, shadow],
    build: (data, metadata) => ChartMarkerStyler.create(
      show: show.value(data),
      shape: shape.value(data),
      color: color.value(data),
      radius: radius.value(data),
      borderColor: borderColor.value(data),
      borderWidth: borderWidth.value(data),
      shadow: shadow.value(data),
      variants: metadata.variants(data),
      modifier: metadata.modifier(data),
      animation: metadata.animation(data),
    ),
  );
}

MixProtocolStylerCodec<ChartTooltipStyler> _chartTooltipCodec(
  MixProtocolBranchContext context,
) {
  final backgroundColor = MixProtocolField.value<ChartTooltipStyler, Color>(
    wire: 'backgroundColor',
    codec: MixProtocolCodecs.color(),
    read: (value) => value.$backgroundColor,
  );
  final border =
      MixProtocolField.mix<ChartTooltipStyler, BorderSideMix, BorderSide>(
        wire: 'border',
        codec: MixProtocolCodecs.borderSide(),
        read: (value) => value.$border,
      );
  final borderRadius =
      MixProtocolField.mix<ChartTooltipStyler, BorderRadiusMix, BorderRadius>(
        wire: 'borderRadius',
        codec: MixProtocolCodecs.borderRadius(),
        read: (value) => value.$borderRadius,
      );
  final padding =
      MixProtocolField.mix<ChartTooltipStyler, EdgeInsetsMix, EdgeInsets>(
        wire: 'padding',
        codec: MixProtocolCodecs.edgeInsets(),
        read: (value) => value.$padding,
      );
  final margin = MixProtocolField.value<ChartTooltipStyler, double>(
    wire: 'margin',
    codec: MixProtocolCodecs.nonNegativeNumber(),
    read: (value) => value.$margin,
  );
  final maxWidth = MixProtocolField.value<ChartTooltipStyler, double>(
    wire: 'maxWidth',
    codec: MixProtocolCodecs.nonNegativeNumber(),
    read: (value) => value.$maxWidth,
  );
  final fitHorizontally = MixProtocolField.value<ChartTooltipStyler, bool>(
    wire: 'fitHorizontally',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$fitHorizontally,
  );
  final fitVertically = MixProtocolField.value<ChartTooltipStyler, bool>(
    wire: 'fitVertically',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$fitVertically,
  );
  final text = MixProtocolField.style<ChartTooltipStyler, TextSpec>(
    wire: 'text',
    context: context,
    read: (value) => value.$text,
  );

  return MixProtocolStylerCodec.forStyler<ChartTooltipStyler, ChartTooltipSpec>(
    context: context,
    fields: [
      backgroundColor,
      border,
      borderRadius,
      padding,
      margin,
      maxWidth,
      fitHorizontally,
      fitVertically,
      text,
    ],
    build: (data, metadata) => ChartTooltipStyler.create(
      backgroundColor: backgroundColor.value(data),
      border: border.value(data),
      borderRadius: borderRadius.value(data),
      padding: padding.value(data),
      margin: margin.value(data),
      maxWidth: maxWidth.value(data),
      fitHorizontally: fitHorizontally.value(data),
      fitVertically: fitVertically.value(data),
      text: text.value(data),
      variants: metadata.variants(data),
      modifier: metadata.modifier(data),
      animation: metadata.animation(data),
    ),
  );
}

MixProtocolStylerCodec<LineChartStyler> _lineChartCodec(
  MixProtocolBranchContext context,
) {
  final frame = MixProtocolField.style<LineChartStyler, ChartFrameSpec>(
    wire: 'frame',
    context: context,
    read: (value) => value.$frame,
  );
  final axis = MixProtocolField.style<LineChartStyler, ChartAxisSpec>(
    wire: 'axis',
    context: context,
    read: (value) => value.$axis,
  );
  final xAxis = MixProtocolField.style<LineChartStyler, ChartAxisSpec>(
    wire: 'xAxis',
    context: context,
    read: (value) => value.$xAxis,
  );
  final yAxis = MixProtocolField.style<LineChartStyler, ChartAxisSpec>(
    wire: 'yAxis',
    context: context,
    read: (value) => value.$yAxis,
  );
  final topAxis = MixProtocolField.style<LineChartStyler, ChartAxisSpec>(
    wire: 'topAxis',
    context: context,
    read: (value) => value.$topAxis,
  );
  final rightAxis = MixProtocolField.style<LineChartStyler, ChartAxisSpec>(
    wire: 'rightAxis',
    context: context,
    read: (value) => value.$rightAxis,
  );
  final grid = MixProtocolField.style<LineChartStyler, ChartGridSpec>(
    wire: 'grid',
    context: context,
    read: (value) => value.$grid,
  );
  final series = MixProtocolField.style<LineChartStyler, LineSeriesSpec>(
    wire: 'series',
    context: context,
    read: (value) => value.$series,
  );
  final palette = MixProtocolField.value<LineChartStyler, List<Color>>(
    wire: 'palette',
    codec: MixProtocolCodecs.list(MixProtocolCodecs.color()),
    read: (value) => value.$palette,
  );
  final tooltip = MixProtocolField.style<LineChartStyler, ChartTooltipSpec>(
    wire: 'tooltip',
    context: context,
    read: (value) => value.$tooltip,
  );

  return MixProtocolStylerCodec.forStyler<LineChartStyler, LineChartSpec>(
    context: context,
    fields: [
      frame,
      axis,
      xAxis,
      yAxis,
      topAxis,
      rightAxis,
      grid,
      series,
      palette,
      tooltip,
    ],
    build: (data, metadata) => LineChartStyler.create(
      frame: frame.value(data),
      axis: axis.value(data),
      xAxis: xAxis.value(data),
      yAxis: yAxis.value(data),
      topAxis: topAxis.value(data),
      rightAxis: rightAxis.value(data),
      grid: grid.value(data),
      series: series.value(data),
      palette: palette.value(data),
      tooltip: tooltip.value(data),
      variants: metadata.variants(data),
      modifier: metadata.modifier(data),
      animation: metadata.animation(data),
    ),
  );
}

MixProtocolStylerCodec<ChartAxisStyler> _chartAxisCodec(
  MixProtocolBranchContext context,
) {
  final showLabels = MixProtocolField.value<ChartAxisStyler, bool>(
    wire: 'showLabels',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$showLabels,
  );
  final label = MixProtocolField.style<ChartAxisStyler, TextSpec>(
    wire: 'label',
    context: context,
    read: (value) => value.$label,
  );
  final reservedSize = MixProtocolField.value<ChartAxisStyler, double>(
    wire: 'reservedSize',
    codec: MixProtocolCodecs.nonNegativeNumber(),
    read: (value) => value.$reservedSize,
  );
  final labelSpace = MixProtocolField.value<ChartAxisStyler, double>(
    wire: 'labelSpace',
    codec: MixProtocolCodecs.nonNegativeNumber(),
    read: (value) => value.$labelSpace,
  );
  final labelAngle = MixProtocolField.value<ChartAxisStyler, double>(
    wire: 'labelAngle',
    codec: MixProtocolCodecs.number(),
    read: (value) => value.$labelAngle,
  );
  final fitInside = MixProtocolField.value<ChartAxisStyler, bool>(
    wire: 'fitInside',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$fitInside,
  );
  final fitInsideDistance = MixProtocolField.value<ChartAxisStyler, double>(
    wire: 'fitInsideDistance',
    codec: MixProtocolCodecs.nonNegativeNumber(),
    read: (value) => value.$fitInsideDistance,
  );
  final nameSize = MixProtocolField.value<ChartAxisStyler, double>(
    wire: 'nameSize',
    codec: MixProtocolCodecs.nonNegativeNumber(),
    read: (value) => value.$nameSize,
  );
  final drawBelowEverything = MixProtocolField.value<ChartAxisStyler, bool>(
    wire: 'drawBelowEverything',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$drawBelowEverything,
  );
  final alignment =
      MixProtocolField.value<ChartAxisStyler, ChartAxisLabelAlignment>(
        wire: 'alignment',
        codec: MixProtocolCodecs.enumName(ChartAxisLabelAlignment.values),
        read: (value) => value.$alignment,
      );

  return MixProtocolStylerCodec.forStyler<ChartAxisStyler, ChartAxisSpec>(
    context: context,
    fields: [
      showLabels,
      label,
      reservedSize,
      labelSpace,
      labelAngle,
      fitInside,
      fitInsideDistance,
      nameSize,
      drawBelowEverything,
      alignment,
    ],
    build: (data, metadata) => ChartAxisStyler.create(
      showLabels: showLabels.value(data),
      label: label.value(data),
      reservedSize: reservedSize.value(data),
      labelSpace: labelSpace.value(data),
      labelAngle: labelAngle.value(data),
      fitInside: fitInside.value(data),
      fitInsideDistance: fitInsideDistance.value(data),
      nameSize: nameSize.value(data),
      drawBelowEverything: drawBelowEverything.value(data),
      alignment: alignment.value(data),
      variants: metadata.variants(data),
      modifier: metadata.modifier(data),
      animation: metadata.animation(data),
    ),
  );
}

MixProtocolStylerCodec<ChartGridStyler> _chartGridCodec(
  MixProtocolBranchContext context,
) {
  final show = MixProtocolField.value<ChartGridStyler, bool>(
    wire: 'show',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$show,
  );
  final showHorizontal = MixProtocolField.value<ChartGridStyler, bool>(
    wire: 'showHorizontal',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$showHorizontal,
  );
  final showVertical = MixProtocolField.value<ChartGridStyler, bool>(
    wire: 'showVertical',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$showVertical,
  );
  final horizontalInterval = MixProtocolField.value<ChartGridStyler, double>(
    wire: 'horizontalInterval',
    codec: MixProtocolCodecs.positiveNumber(),
    read: (value) => value.$horizontalInterval,
  );
  final verticalInterval = MixProtocolField.value<ChartGridStyler, double>(
    wire: 'verticalInterval',
    codec: MixProtocolCodecs.positiveNumber(),
    read: (value) => value.$verticalInterval,
  );
  final stroke = MixProtocolField.style<ChartGridStyler, ChartStrokeSpec>(
    wire: 'stroke',
    context: context,
    read: (value) => value.$stroke,
  );

  return MixProtocolStylerCodec.forStyler<ChartGridStyler, ChartGridSpec>(
    context: context,
    fields: [
      show,
      showHorizontal,
      showVertical,
      horizontalInterval,
      verticalInterval,
      stroke,
    ],
    build: (data, metadata) => ChartGridStyler.create(
      show: show.value(data),
      showHorizontal: showHorizontal.value(data),
      showVertical: showVertical.value(data),
      horizontalInterval: horizontalInterval.value(data),
      verticalInterval: verticalInterval.value(data),
      stroke: stroke.value(data),
      variants: metadata.variants(data),
      modifier: metadata.modifier(data),
      animation: metadata.animation(data),
    ),
  );
}

MixProtocolStylerCodec<ChartStrokeStyler> _chartStrokeCodec(
  MixProtocolBranchContext context,
) {
  final color = MixProtocolField.value<ChartStrokeStyler, Color>(
    wire: 'color',
    codec: MixProtocolCodecs.color(),
    read: (value) => value.$color,
  );
  final gradient =
      MixProtocolField.mix<ChartStrokeStyler, GradientMix, Gradient>(
        wire: 'gradient',
        codec: MixProtocolCodecs.gradient(),
        read: (value) => value.$gradient,
      );
  final width = MixProtocolField.value<ChartStrokeStyler, double>(
    wire: 'width',
    codec: MixProtocolCodecs.nonNegativeNumber(),
    read: (value) => value.$width,
  );
  final dashArray = MixProtocolField.value<ChartStrokeStyler, List<int>>(
    wire: 'dashArray',
    codec: MixProtocolCodecs.list(MixProtocolCodecs.integer(min: 1)),
    read: (value) => value.$dashArray,
  );
  final opacity = MixProtocolField.value<ChartStrokeStyler, double>(
    wire: 'opacity',
    codec: MixProtocolCodecs.unitNumber(),
    read: (value) => value.$opacity,
  );

  return MixProtocolStylerCodec.forStyler<ChartStrokeStyler, ChartStrokeSpec>(
    context: context,
    fields: [color, gradient, width, dashArray, opacity],
    build: (data, metadata) => ChartStrokeStyler.create(
      color: color.value(data),
      gradient: gradient.value(data),
      width: width.value(data),
      dashArray: dashArray.value(data),
      opacity: opacity.value(data),
      variants: metadata.variants(data),
      modifier: metadata.modifier(data),
      animation: metadata.animation(data),
    ),
  );
}

MixProtocolStylerCodec<LineSeriesStyler> _lineSeriesCodec(
  MixProtocolBranchContext context,
) {
  final show = MixProtocolField.value<LineSeriesStyler, bool>(
    wire: 'show',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$show,
  );
  final stroke = MixProtocolField.style<LineSeriesStyler, ChartStrokeSpec>(
    wire: 'stroke',
    context: context,
    read: (value) => value.$stroke,
  );
  final curve = MixProtocolField.value<LineSeriesStyler, LineCurve>(
    wire: 'curve',
    codec: MixProtocolCodecs.enumName(LineCurve.values),
    read: (value) => value.$curve,
  );
  final smoothness = MixProtocolField.value<LineSeriesStyler, double>(
    wire: 'smoothness',
    codec: MixProtocolCodecs.unitNumber(),
    read: (value) => value.$smoothness,
  );
  final preventCurveOvershooting =
      MixProtocolField.value<LineSeriesStyler, bool>(
        wire: 'preventCurveOvershooting',
        codec: MixProtocolCodecs.boolean(),
        read: (value) => value.$preventCurveOvershooting,
      );
  final curveOvershootingThreshold =
      MixProtocolField.value<LineSeriesStyler, double>(
        wire: 'curveOvershootingThreshold',
        codec: MixProtocolCodecs.nonNegativeNumber(),
        read: (value) => value.$curveOvershootingThreshold,
      );
  final roundStrokeCap = MixProtocolField.value<LineSeriesStyler, bool>(
    wire: 'roundStrokeCap',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$roundStrokeCap,
  );
  final roundStrokeJoin = MixProtocolField.value<LineSeriesStyler, bool>(
    wire: 'roundStrokeJoin',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$roundStrokeJoin,
  );
  final marker = MixProtocolField.style<LineSeriesStyler, ChartMarkerSpec>(
    wire: 'marker',
    context: context,
    read: (value) => value.$marker,
  );
  final belowArea = MixProtocolField.style<LineSeriesStyler, ChartAreaSpec>(
    wire: 'belowArea',
    context: context,
    read: (value) => value.$belowArea,
  );
  final aboveArea = MixProtocolField.style<LineSeriesStyler, ChartAreaSpec>(
    wire: 'aboveArea',
    context: context,
    read: (value) => value.$aboveArea,
  );
  final shadow = MixProtocolField.mix<LineSeriesStyler, ShadowMix, Shadow>(
    wire: 'shadow',
    codec: MixProtocolCodecs.shadow(),
    read: (value) => value.$shadow,
  );

  return MixProtocolStylerCodec.forStyler<LineSeriesStyler, LineSeriesSpec>(
    context: context,
    fields: [
      show,
      stroke,
      curve,
      smoothness,
      preventCurveOvershooting,
      curveOvershootingThreshold,
      roundStrokeCap,
      roundStrokeJoin,
      marker,
      belowArea,
      aboveArea,
      shadow,
    ],
    build: (data, metadata) => LineSeriesStyler.create(
      show: show.value(data),
      stroke: stroke.value(data),
      curve: curve.value(data),
      smoothness: smoothness.value(data),
      preventCurveOvershooting: preventCurveOvershooting.value(data),
      curveOvershootingThreshold: curveOvershootingThreshold.value(data),
      roundStrokeCap: roundStrokeCap.value(data),
      roundStrokeJoin: roundStrokeJoin.value(data),
      marker: marker.value(data),
      belowArea: belowArea.value(data),
      aboveArea: aboveArea.value(data),
      shadow: shadow.value(data),
      variants: metadata.variants(data),
      modifier: metadata.modifier(data),
      animation: metadata.animation(data),
    ),
  );
}

MixProtocolStylerCodec<PieChartStyler> _pieChartCodec(
  MixProtocolBranchContext context,
) {
  final frame = MixProtocolField.style<PieChartStyler, ChartFrameSpec>(
    wire: 'frame',
    context: context,
    read: (value) => value.$frame,
  );
  final slice = MixProtocolField.style<PieChartStyler, PieSliceSpec>(
    wire: 'slice',
    context: context,
    read: (value) => value.$slice,
  );
  final selectedSliceRadiusOffset =
      MixProtocolField.value<PieChartStyler, double>(
        wire: 'selectedSliceRadiusOffset',
        codec: MixProtocolCodecs.nonNegativeNumber(),
        read: (value) => value.$selectedSliceRadiusOffset,
      );
  final palette = MixProtocolField.value<PieChartStyler, List<Color>>(
    wire: 'palette',
    codec: MixProtocolCodecs.list(MixProtocolCodecs.color()),
    read: (value) => value.$palette,
  );
  final centerRadius = MixProtocolField.value<PieChartStyler, double>(
    wire: 'centerRadius',
    codec: MixProtocolCodecs.nonNegativeNumber(),
    read: (value) => value.$centerRadius,
  );
  final centerColor = MixProtocolField.value<PieChartStyler, Color>(
    wire: 'centerColor',
    codec: MixProtocolCodecs.color(),
    read: (value) => value.$centerColor,
  );
  final sliceSpacing = MixProtocolField.value<PieChartStyler, double>(
    wire: 'sliceSpacing',
    codec: MixProtocolCodecs.nonNegativeNumber(),
    read: (value) => value.$sliceSpacing,
  );
  final startAngle = MixProtocolField.value<PieChartStyler, double>(
    wire: 'startAngle',
    codec: MixProtocolCodecs.number(),
    read: (value) => value.$startAngle,
  );
  final sunbeamLabels = MixProtocolField.value<PieChartStyler, bool>(
    wire: 'sunbeamLabels',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$sunbeamLabels,
  );
  final tooltip = MixProtocolField.style<PieChartStyler, ChartTooltipSpec>(
    wire: 'tooltip',
    context: context,
    read: (value) => value.$tooltip,
  );

  return MixProtocolStylerCodec.forStyler<PieChartStyler, PieChartSpec>(
    context: context,
    fields: [
      frame,
      slice,
      selectedSliceRadiusOffset,
      palette,
      centerRadius,
      centerColor,
      sliceSpacing,
      startAngle,
      sunbeamLabels,
      tooltip,
    ],
    build: (data, metadata) => PieChartStyler.create(
      frame: frame.value(data),
      slice: slice.value(data),
      selectedSliceRadiusOffset: selectedSliceRadiusOffset.value(data),
      palette: palette.value(data),
      centerRadius: centerRadius.value(data),
      centerColor: centerColor.value(data),
      sliceSpacing: sliceSpacing.value(data),
      startAngle: startAngle.value(data),
      sunbeamLabels: sunbeamLabels.value(data),
      tooltip: tooltip.value(data),
      variants: metadata.variants(data),
      modifier: metadata.modifier(data),
      animation: metadata.animation(data),
    ),
  );
}

MixProtocolStylerCodec<PieSliceStyler> _pieSliceCodec(
  MixProtocolBranchContext context,
) {
  final color = MixProtocolField.value<PieSliceStyler, Color>(
    wire: 'color',
    codec: MixProtocolCodecs.color(),
    read: (value) => value.$color,
  );
  final gradient = MixProtocolField.mix<PieSliceStyler, GradientMix, Gradient>(
    wire: 'gradient',
    codec: MixProtocolCodecs.gradient(),
    read: (value) => value.$gradient,
  );
  final radius = MixProtocolField.value<PieSliceStyler, double>(
    wire: 'radius',
    codec: MixProtocolCodecs.nonNegativeNumber(),
    read: (value) => value.$radius,
  );
  final showLabel = MixProtocolField.value<PieSliceStyler, bool>(
    wire: 'showLabel',
    codec: MixProtocolCodecs.boolean(),
    read: (value) => value.$showLabel,
  );
  final label = MixProtocolField.style<PieSliceStyler, TextSpec>(
    wire: 'label',
    context: context,
    read: (value) => value.$label,
  );
  final labelPosition = MixProtocolField.value<PieSliceStyler, double>(
    wire: 'labelPosition',
    codec: MixProtocolCodecs.unitNumber(),
    read: (value) => value.$labelPosition,
  );
  final border =
      MixProtocolField.mix<PieSliceStyler, BorderSideMix, BorderSide>(
        wire: 'border',
        codec: MixProtocolCodecs.borderSide(),
        read: (value) => value.$border,
      );
  final cornerRadius = MixProtocolField.value<PieSliceStyler, double>(
    wire: 'cornerRadius',
    codec: MixProtocolCodecs.nonNegativeNumber(),
    read: (value) => value.$cornerRadius,
  );
  final badgePosition = MixProtocolField.value<PieSliceStyler, double>(
    wire: 'badgePosition',
    codec: MixProtocolCodecs.unitNumber(),
    read: (value) => value.$badgePosition,
  );

  return MixProtocolStylerCodec.forStyler<PieSliceStyler, PieSliceSpec>(
    context: context,
    fields: [
      color,
      gradient,
      radius,
      showLabel,
      label,
      labelPosition,
      border,
      cornerRadius,
      badgePosition,
    ],
    build: (data, metadata) => PieSliceStyler.create(
      color: color.value(data),
      gradient: gradient.value(data),
      radius: radius.value(data),
      showLabel: showLabel.value(data),
      label: label.value(data),
      labelPosition: labelPosition.value(data),
      border: border.value(data),
      cornerRadius: cornerRadius.value(data),
      badgePosition: badgePosition.value(data),
      variants: metadata.variants(data),
      modifier: metadata.modifier(data),
      animation: metadata.animation(data),
    ),
  );
}
