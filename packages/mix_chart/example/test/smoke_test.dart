import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:mix_chart_example/main.dart';
import 'package:mix_chart_example/theme.dart';

void main() {
  Future<void> pumpGallery(
    WidgetTester tester, {
    Size size = const Size(700, 1400),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(() {
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    });
    await tester.pumpWidget(const GalleryApp());
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> selectDestination(WidgetTester tester, IconData icon) async {
    await tester.tap(find.byIcon(icon).last);
    await tester.pump(const Duration(milliseconds: 350));
  }

  testWidgets('uses one responsive navigation mode', (tester) async {
    await pumpGallery(tester);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);

    await pumpGallery(tester, size: const Size(1100, 1400));
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('all five destinations render Mix-owned chart widgets', (
    tester,
  ) async {
    await pumpGallery(tester);

    expect(find.byType(LineChart), findsWidgets);
    await selectDestination(tester, Icons.bar_chart);
    expect(find.byType(BarChart), findsWidgets);

    await selectDestination(tester, Icons.pie_chart);
    expect(find.byType(PieChart), findsWidgets);

    await selectDestination(tester, Icons.tune);
    expect(find.byKey(const Key('line-playground-chart')), findsOneWidget);
    await tester.tap(find.widgetWithText(Tab, 'Bar'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('bar-playground-chart')), findsOneWidget);
    await tester.tap(find.widgetWithText(Tab, 'Pie'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('pie-playground-chart')), findsOneWidget);

    await selectDestination(tester, Icons.dashboard);
    expect(find.byType(LineChart), findsOneWidget);
    expect(find.byType(PieChart), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Monthly performance'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byType(BarChart), findsOneWidget);
  });

  testWidgets('playground controls rebuild the generated Styler', (
    tester,
  ) async {
    await pumpGallery(tester);
    await selectDestination(tester, Icons.tune);

    final chartFinder = find.byKey(const Key('line-playground-chart'));
    final before = tester.widget<LineChart>(chartFinder).style;
    final slider = find.byKey(const Key('slider-stroke-width'));
    final sliderRect = tester.getRect(slider);
    await tester.tapAt(Offset(sliderRect.right - 12, sliderRect.center.dy));
    await tester.pumpAndSettle();

    expect(tester.widget<Slider>(slider).value, greaterThan(3));
    expect(tester.widget<LineChart>(chartFinder).style, isNot(equals(before)));
  });

  testWidgets('theme controls keep charts mounted', (tester) async {
    await pumpGallery(tester);

    await tester.tap(find.byIcon(Icons.dark_mode));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byIcon(Icons.light_mode), findsOneWidget);

    await tester.tap(find.byKey(const Key('theme-preset-switcher')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ocean').last);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(LineChart), findsWidgets);
  });

  test('consumer token palettes retain readable on-series contrast', () {
    double contrast(Color foreground, Color background) {
      final foregroundLuminance = foreground.computeLuminance();
      final backgroundLuminance = background.computeLuminance();
      final lighter = foregroundLuminance > backgroundLuminance
          ? foregroundLuminance
          : backgroundLuminance;
      final darker = foregroundLuminance > backgroundLuminance
          ? backgroundLuminance
          : foregroundLuminance;
      return (lighter + .05) / (darker + .05);
    }

    for (final preset in DemoThemePreset.values) {
      for (final brightness in Brightness.values) {
        final tokens = demoTokens(preset, brightness);
        final label = tokens[chartOnSeriesLabel]! as TextStyle;
        for (final token in [
          chartSeries1,
          chartSeries2,
          chartSeries3,
          chartSeries4,
        ]) {
          expect(
            contrast(label.color!, tokens[token]! as Color),
            greaterThanOrEqualTo(4.5),
          );
        }
      }
    }
  });
}
