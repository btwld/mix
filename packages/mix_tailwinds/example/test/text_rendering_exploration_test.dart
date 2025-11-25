import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

/// Exploration test to find optimal text rendering configuration.
///
/// This test creates minimal text-only widgets with different configurations
/// and generates goldens that can be compared against Tailwind CSS output.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testWidth = 400.0;
  const testHeight = 600.0;

  Future<void> pumpWidget(WidgetTester tester, Widget child) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(testWidth, testHeight);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(testWidth, testHeight)),
          child: ColoredBox(
            color: const Color(0xFFF3F4F6),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Creates a text sample widget using the given text style configuration
  Widget createTextSample({
    required String label,
    double? height,
    TextLeadingDistribution? leadingDistribution,
    bool? applyHeightToFirstAscent,
    bool? applyHeightToLastDescent,
  }) {
    final textHeightBehavior = (leadingDistribution != null ||
            applyHeightToFirstAscent != null ||
            applyHeightToLastDescent != null)
        ? TextHeightBehavior(
            leadingDistribution:
                leadingDistribution ?? TextLeadingDistribution.proportional,
            applyHeightToFirstAscent: applyHeightToFirstAscent ?? true,
            applyHeightToLastDescent: applyHeightToLastDescent ?? true,
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label for this configuration
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // text-sm (14px, Tailwind line-height: 20px = 1.429)
        DefaultTextStyle(
          style: TextStyle(
            fontSize: 14,
            height: height,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D4ED8),
          ),
          textHeightBehavior: textHeightBehavior,
          child: const Text('CAMPAIGN HEALTH'),
        ),
        const SizedBox(height: 4),
        // text-3xl (30px, Tailwind line-height: 36px = 1.2)
        DefaultTextStyle(
          style: TextStyle(
            fontSize: 30,
            height: height != null ? (height * 14 / 30).clamp(1.0, 1.5) : null,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
          textHeightBehavior: textHeightBehavior,
          child: const Text('November brand push'),
        ),
        const SizedBox(height: 4),
        // text-base (16px, Tailwind line-height: 24px = 1.5)
        DefaultTextStyle(
          style: TextStyle(
            fontSize: 16,
            height: height,
            color: const Color(0xFF6B7280),
          ),
          textHeightBehavior: textHeightBehavior,
          child: const Text('Live performance snapshot for paid channels.'),
        ),
        const SizedBox(height: 8),
        // text-2xl (24px, Tailwind line-height: 32px = 1.333)
        DefaultTextStyle(
          style: TextStyle(
            fontSize: 24,
            height: height != null ? (height * 14 / 24).clamp(1.0, 1.5) : null,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
          textHeightBehavior: textHeightBehavior,
          child: const Text('\$241.18M'),
        ),
      ],
    );
  }

  group('Text Rendering Exploration', () {
    // Experiment A: Flutter default (no height specified)
    testWidgets('A: Flutter default (no height)', (tester) async {
      await pumpWidget(
        tester,
        createTextSample(label: 'A: Flutter default'),
      );
      await expectLater(
        find.byType(ColoredBox),
        matchesGoldenFile('goldens/exploration/exp-a-flutter-default.png'),
      );
    });

    // Experiment B1: Tailwind heights with proportional distribution (default)
    testWidgets('B1: Tailwind heights + proportional', (tester) async {
      await pumpWidget(
        tester,
        createTextSample(
          label: 'B1: TW heights + proportional',
          height: 1.429, // Tailwind text-sm
        ),
      );
      await expectLater(
        find.byType(ColoredBox),
        matchesGoldenFile('goldens/exploration/exp-b1-tw-proportional.png'),
      );
    });

    // Experiment B2: Tailwind heights with even distribution
    testWidgets('B2: Tailwind heights + even', (tester) async {
      await pumpWidget(
        tester,
        createTextSample(
          label: 'B2: TW heights + even',
          height: 1.429,
          leadingDistribution: TextLeadingDistribution.even,
        ),
      );
      await expectLater(
        find.byType(ColoredBox),
        matchesGoldenFile('goldens/exploration/exp-b2-tw-even.png'),
      );
    });

    // Experiment C1: Even distribution, no height to first ascent
    testWidgets('C1: Even + no first ascent', (tester) async {
      await pumpWidget(
        tester,
        createTextSample(
          label: 'C1: Even + no 1st ascent',
          height: 1.429,
          leadingDistribution: TextLeadingDistribution.even,
          applyHeightToFirstAscent: false,
        ),
      );
      await expectLater(
        find.byType(ColoredBox),
        matchesGoldenFile('goldens/exploration/exp-c1-even-no-first.png'),
      );
    });

    // Experiment C2: Even distribution, no height to last descent
    testWidgets('C2: Even + no last descent', (tester) async {
      await pumpWidget(
        tester,
        createTextSample(
          label: 'C2: Even + no last desc',
          height: 1.429,
          leadingDistribution: TextLeadingDistribution.even,
          applyHeightToLastDescent: false,
        ),
      );
      await expectLater(
        find.byType(ColoredBox),
        matchesGoldenFile('goldens/exploration/exp-c2-even-no-last.png'),
      );
    });

    // Experiment C3: Even distribution, no height to either
    testWidgets('C3: Even + no first/last', (tester) async {
      await pumpWidget(
        tester,
        createTextSample(
          label: 'C3: Even + no 1st/last',
          height: 1.429,
          leadingDistribution: TextLeadingDistribution.even,
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
      );
      await expectLater(
        find.byType(ColoredBox),
        matchesGoldenFile('goldens/exploration/exp-c3-even-no-both.png'),
      );
    });

    // Experiment D1: Smaller height (90% of Tailwind)
    testWidgets('D1: 90% of Tailwind height', (tester) async {
      await pumpWidget(
        tester,
        createTextSample(
          label: 'D1: 90% TW height',
          height: 1.429 * 0.9,
          leadingDistribution: TextLeadingDistribution.even,
        ),
      );
      await expectLater(
        find.byType(ColoredBox),
        matchesGoldenFile('goldens/exploration/exp-d1-90pct-height.png'),
      );
    });

    // Experiment D2: Even smaller height (80% of Tailwind)
    testWidgets('D2: 80% of Tailwind height', (tester) async {
      await pumpWidget(
        tester,
        createTextSample(
          label: 'D2: 80% TW height',
          height: 1.429 * 0.8,
          leadingDistribution: TextLeadingDistribution.even,
        ),
      );
      await expectLater(
        find.byType(ColoredBox),
        matchesGoldenFile('goldens/exploration/exp-d2-80pct-height.png'),
      );
    });

    // Experiment E: Height 1.0 (tight) with even distribution
    testWidgets('E: Height 1.0 + even', (tester) async {
      await pumpWidget(
        tester,
        createTextSample(
          label: 'E: Height 1.0 + even',
          height: 1.0,
          leadingDistribution: TextLeadingDistribution.even,
        ),
      );
      await expectLater(
        find.byType(ColoredBox),
        matchesGoldenFile('goldens/exploration/exp-e-tight-even.png'),
      );
    });
  });

  // Also create a Tailwind-like reference using Div/Span
  group('Mix Tailwinds Comparison', () {
    testWidgets('Reference: Current mix_tailwinds output', (tester) async {
      await pumpWidget(
        tester,
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Span(
              text: 'CAMPAIGN HEALTH',
              classNames: 'text-sm font-semibold uppercase text-blue-700',
            ),
            SizedBox(height: 4),
            Span(
              text: 'November brand push',
              classNames: 'text-3xl font-semibold text-gray-700',
            ),
            SizedBox(height: 4),
            Span(
              text: 'Live performance snapshot for paid channels.',
              classNames: 'text-base text-gray-500',
            ),
            SizedBox(height: 8),
            Span(
              text: r'$241.18M',
              classNames: 'text-2xl font-semibold text-gray-700',
            ),
          ],
        ),
      );
      await expectLater(
        find.byType(ColoredBox),
        matchesGoldenFile('goldens/exploration/mix-tailwinds-current.png'),
      );
    });
  });
}
