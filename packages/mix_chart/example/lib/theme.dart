import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

enum DemoThemePreset {
  indigo('Indigo'),
  ocean('Ocean'),
  sunset('Sunset');

  const DemoThemePreset(this.label);
  final String label;
}

const chartSurface = ColorToken('chart.surface');
const chartGrid = ColorToken('chart.grid');
const chartAxisLabel = TextStyleToken('chart.axis.label');
const chartOnSeriesLabel = TextStyleToken('chart.on-series.label');
const chartSeries1 = ColorToken('chart.series.1');
const chartSeries2 = ColorToken('chart.series.2');
const chartSeries3 = ColorToken('chart.series.3');
const chartSeries4 = ColorToken('chart.series.4');

List<Color> get chartTokenPalette => [
  chartSeries1(),
  chartSeries2(),
  chartSeries3(),
  chartSeries4(),
];

List<Color> resolvedChartPalette(BuildContext context) => [
  chartSeries1.resolve(context),
  chartSeries2.resolve(context),
  chartSeries3.resolve(context),
  chartSeries4.resolve(context),
];

Map<MixToken, Object> demoTokens(
  DemoThemePreset preset,
  Brightness brightness,
) {
  final dark = brightness == Brightness.dark;
  final colors = switch ((preset, dark)) {
    (DemoThemePreset.indigo, false) => const [
      Color(0xFF4F46E5),
      Color(0xFF0F766E),
      Color(0xFFB45309),
      Color(0xFFBE185D),
    ],
    (DemoThemePreset.indigo, true) => const [
      Color(0xFF818CF8),
      Color(0xFF2DD4BF),
      Color(0xFFFBBF24),
      Color(0xFFF472B6),
    ],
    (DemoThemePreset.ocean, false) => const [
      Color(0xFF0369A1),
      Color(0xFF0F766E),
      Color(0xFFA16207),
      Color(0xFF7E22CE),
    ],
    (DemoThemePreset.ocean, true) => const [
      Color(0xFF38BDF8),
      Color(0xFF5EEAD4),
      Color(0xFFFACC15),
      Color(0xFFC084FC),
    ],
    (DemoThemePreset.sunset, false) => const [
      Color(0xFFC2410C),
      Color(0xFFBE123C),
      Color(0xFF7E22CE),
      Color(0xFF0369A1),
    ],
    (DemoThemePreset.sunset, true) => const [
      Color(0xFFFB923C),
      Color(0xFFFB7185),
      Color(0xFFC084FC),
      Color(0xFF38BDF8),
    ],
  };

  return {
    chartSurface: dark ? const Color(0xFF171B26) : const Color(0xFFFFFFFF),
    chartGrid: dark ? const Color(0xFF3B4355) : const Color(0xFFD7DEE9),
    chartAxisLabel: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: dark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
    ),
    chartOnSeriesLabel: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: dark ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF),
    ),
    chartSeries1: colors[0],
    chartSeries2: colors[1],
    chartSeries3: colors[2],
    chartSeries4: colors[3],
  };
}

ThemeData galleryMaterialTheme(DemoThemePreset preset, Brightness brightness) {
  final seed = switch (preset) {
    DemoThemePreset.indigo => const Color(0xFF4F46E5),
    DemoThemePreset.ocean => const Color(0xFF0369A1),
    DemoThemePreset.sunset => const Color(0xFFC2410C),
  };

  return ThemeData(
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: brightness),
    useMaterial3: true,
  );
}

BoxStyler demoCardStyler() => BoxStyler()
    .color(chartSurface())
    .borderRounded(18)
    .paddingAll(20)
    .shadow(BoxShadowMix(blurRadius: 24, color: const Color(0x11000000)))
    .onDark(BoxStyler().color(chartSurface()));
