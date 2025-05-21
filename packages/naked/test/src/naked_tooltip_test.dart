import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked/naked.dart';

extension _WidgetTesterX on WidgetTester {
  Future<void> pumpTooltip(Widget widget) async {
    await pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: [OverlayEntry(builder: (context) => widget)],
      ),
    ));
  }
}

void _expectDistance(Offset offset1, Offset offset2, double expectedDistance) {
  final distance = (offset1 - offset2).distance;
  expect(distance, equals(expectedDistance));
}

void main() {
  group('Basic Functionality', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpTooltip(
        NakedTooltip(
          controller: OverlayPortalController(),
          tooltipBuilder: (context) => const Text('Tooltip Content'),
          child: const Text('Hover Me'),
        ),
      );

      expect(find.text('Hover Me'), findsOneWidget);
      expect(find.text('Tooltip Content'), findsNothing);
    });

    testWidgets('shows tooltip when controller.show is called',
        (WidgetTester tester) async {
      final controller = OverlayPortalController();

      await tester.pumpTooltip(
        NakedTooltip(
          tooltipBuilder: (context) => const Text('Tooltip Content'),
          controller: controller,
          child: const Text('Hover Me'),
        ),
      );

      controller.show();
      await tester.pump();
      expect(find.text('Tooltip Content'), findsOneWidget);
    });

    testWidgets('hides tooltip when controller.hide is called',
        (WidgetTester tester) async {
      final controller = OverlayPortalController();

      await tester.pumpTooltip(
        NakedTooltip(
          tooltipBuilder: (context) => const Text('Tooltip Content'),
          controller: controller,
          child: const Text('Hover Me'),
        ),
      );

      controller.show();
      await tester.pump();
      expect(find.text('Tooltip Content'), findsOneWidget);

      controller.hide();
      await tester.pump();
      expect(find.text('Tooltip Content'), findsNothing);
    });
  });

  group('Positioning', () {
    testWidgets('positions tooltip based on anchors',
        (WidgetTester tester) async {
      final targetKey = GlobalKey();
      final tooltipKey = GlobalKey();
      final controller = OverlayPortalController();

      await tester.pumpTooltip(
        Center(
          child: NakedTooltip(
            tooltipBuilder: (context) => SizedBox(
              key: tooltipKey,
              width: 100,
              height: 50,
              child: const Text('tooltip'),
            ),
            controller: controller,
            targetAnchor: Alignment.topLeft,
            followerAnchor: Alignment.bottomLeft,
            offset: Offset.zero,
            child: SizedBox(
              key: targetKey,
              width: 100,
              height: 50,
              child: const Text('target'),
            ),
          ),
        ),
      );

      controller.show();
      await tester.pump(const Duration(milliseconds: 100));

      final targetFinder = find.byKey(targetKey);
      final tooltipFinder = find.byKey(tooltipKey);

      expect(tooltipFinder, findsOneWidget);

      _expectDistance(
        tester.getTopLeft(targetFinder),
        tester.getBottomLeft(tooltipFinder),
        0,
      );

      _expectDistance(
        tester.getTopLeft(tooltipFinder),
        tester.getTopLeft(targetFinder),
        50,
      );
    });

    testWidgets('applies offset correctly', (WidgetTester tester) async {
      final targetKey = GlobalKey();
      final tooltipKey = GlobalKey();
      final controller = OverlayPortalController();

      await tester.pumpTooltip(
        Center(
          child: NakedTooltip(
            tooltipBuilder: (context) => SizedBox(
              key: tooltipKey,
              width: 100,
              height: 50,
              child: const Text('Tooltip Content'),
            ),
            controller: controller,
            targetAnchor: Alignment.topLeft,
            followerAnchor: Alignment.bottomLeft,
            offset: const Offset(0, 10),
            child: SizedBox(
              key: targetKey,
              width: 100,
              height: 50,
              child: const Text('Hover Me'),
            ),
          ),
        ),
      );

      controller.show();
      await tester.pump();

      final targetFinder = find.byKey(targetKey);
      final tooltipFinder = find.byKey(tooltipKey);

      _expectDistance(
        tester.getTopLeft(targetFinder),
        tester.getBottomLeft(tooltipFinder),
        10,
      );
    });
  });

  group('Controller', () {
    testWidgets('controller toggles tooltip visibility',
        (WidgetTester tester) async {
      final controller = OverlayPortalController();

      await tester.pumpTooltip(
        NakedTooltip(
          tooltipBuilder: (context) => const Text('Tooltip Content'),
          controller: controller,
          child: const Text('Hover Me'),
        ),
      );

      expect(find.text('Tooltip Content'), findsNothing);

      controller.show();
      await tester.pump();
      expect(find.text('Tooltip Content'), findsOneWidget);

      controller.hide();
      await tester.pump();
      expect(find.text('Tooltip Content'), findsNothing);
    });
  });
}
