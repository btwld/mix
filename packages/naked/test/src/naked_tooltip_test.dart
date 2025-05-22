import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked/naked.dart';

import 'helpers/simulate_hover.dart';

extension _WidgetTesterX on WidgetTester {
  Future<void> simulateHoverOnTooltip(Key key,
      {required VoidCallback? onHover}) async {
    final gesture = await createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await pumpAndSettle();

    await gesture.moveTo(getCenter(find.byKey(key)));
    await pumpAndSettle();

    onHover?.call();

    await gesture.moveTo(Offset.zero);
    await pumpAndSettle();
  }
}

void _expectDistance(Offset offset1, Offset offset2, double expectedDistance) {
  final distance = (offset1 - offset2).distance;
  expect(distance, equals(expectedDistance));
}

void main() {
  group('Basic Functionality', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        NakedTooltip(
          tooltipBuilder: (context) => const Text('Tooltip Content'),
          child: const Text('Hover Me'),
        ),
      );

      expect(find.text('Hover Me'), findsOneWidget);
      expect(find.text('Tooltip Content'), findsNothing);
    });

    testWidgets('shows and hides tooltip on hover',
        (WidgetTester tester) async {
      final targetKey = GlobalKey();
      await tester.pumpMaterialWidget(
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: NakedTooltip(
            key: targetKey,
            tooltipBuilder: (context) => const Text('Tooltip Content'),
            waitDuration: Duration.zero,
            showDuration: Duration.zero,
            removalDelay: Duration.zero,
            child: const Text('Hover Me'),
          ),
        ),
      );

      expect(find.text('Tooltip Content'), findsNothing);

      await tester.simulateHoverOnTooltip(targetKey, onHover: () {
        expect(find.text('Tooltip Content'), findsOneWidget);
      });

      expect(find.text('Tooltip Content'), findsNothing);
    });
  });

  group('Positioning', () {
    testWidgets('positions tooltip based on anchors',
        (WidgetTester tester) async {
      final targetKey = GlobalKey();
      final tooltipKey = GlobalKey();

      await tester.pumpMaterialWidget(
        Center(
          child: NakedTooltip(
            tooltipBuilder: (context) => SizedBox(
              key: tooltipKey,
              width: 100,
              height: 50,
              child: const Text('tooltip'),
            ),
            waitDuration: Duration.zero,
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

      await tester.simulateHoverOnTooltip(targetKey, onHover: () {
        expect(find.text('tooltip'), findsOneWidget);
      });
      await tester.pump();

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

      await tester.pumpMaterialWidget(
        Center(
          child: NakedTooltip(
            tooltipBuilder: (context) => SizedBox(
              key: tooltipKey,
              width: 100,
              height: 50,
              child: const Text('Tooltip Content'),
            ),
            waitDuration: Duration.zero,
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

      await tester.simulateHoverOnTooltip(targetKey, onHover: () {
        expect(find.text('Tooltip Content'), findsOneWidget);
      });
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

  group('Timing and State Changes', () {
    testWidgets('waitDuration delays tooltip appearance',
        (WidgetTester tester) async {
      final targetKey = GlobalKey();
      final stateChanges = <OverlayChildLifecycleState>[];

      await tester.pumpMaterialWidget(
        Center(
          child: NakedTooltip(
            key: targetKey,
            tooltipBuilder: (context) => const Text('Tooltip Content'),
            waitDuration: const Duration(milliseconds: 50),
            showDuration: Duration.zero,
            removalDelay: Duration.zero,
            onStateChange: stateChanges.add,
            child: const Text('Hover Me'),
          ),
        ),
      );

      // Create gesture without pumpAndSettle
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();

      // Move to hover but don't settle (to test timing precisely)
      await gesture.moveTo(tester.getCenter(find.byKey(targetKey)));
      await tester.pump();

      // Tooltip should not be visible immediately
      expect(find.text('Tooltip Content'), findsNothing);
      expect(stateChanges, isEmpty);

      // Wait for half the wait duration - should still not be visible
      await tester.pump(const Duration(milliseconds: 25));
      expect(find.text('Tooltip Content'), findsNothing);
      expect(stateChanges, isEmpty);

      // Wait for the full wait duration - should now be visible
      await tester.pump(const Duration(milliseconds: 25));
      await tester.pump();
      expect(find.text('Tooltip Content'), findsOneWidget);
      expect(stateChanges, [OverlayChildLifecycleState.present]);

      await gesture.moveTo(Offset.zero);
      await tester.pumpAndSettle();
    });

    testWidgets('showDuration auto-hides tooltip', (WidgetTester tester) async {
      final targetKey = GlobalKey();
      final stateChanges = <OverlayChildLifecycleState>[];

      await tester.pumpMaterialWidget(
        Center(
          child: NakedTooltip(
            key: targetKey,
            tooltipBuilder: (context) => const Text('Tooltip Content'),
            waitDuration: Duration.zero,
            showDuration: const Duration(milliseconds: 50),
            removalDelay: Duration.zero,
            onStateChange: stateChanges.add,
            child: const Text('Hover Me'),
          ),
        ),
      );

      // Custom hover simulation to control timing
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();

      // Move to hover position
      await gesture.moveTo(tester.getCenter(find.byKey(targetKey)));
      await tester.pumpAndSettle();

      expect(find.text('Tooltip Content'), findsOneWidget);
      expect(stateChanges, [OverlayChildLifecycleState.present]);

      // Move mouse away - tooltip should still be visible
      await gesture.moveTo(Offset.zero);
      await tester.pump();
      expect(find.text('Tooltip Content'), findsOneWidget);

      // Wait for half the show duration - tooltip should still be visible
      await tester.pump(const Duration(milliseconds: 25));
      expect(find.text('Tooltip Content'), findsOneWidget);

      // Wait for the full show duration - tooltip should be hidden
      await tester.pump(const Duration(milliseconds: 25));
      await tester.pump();
      expect(find.text('Tooltip Content'), findsNothing);
      expect(stateChanges, [
        OverlayChildLifecycleState.present,
        OverlayChildLifecycleState.pendingRemoval,
        OverlayChildLifecycleState.removed
      ]);
    });

    testWidgets('removalDelay delays removing tooltip from overlay',
        (WidgetTester tester) async {
      final targetKey = GlobalKey();
      final stateChanges = <OverlayChildLifecycleState>[];

      await tester.pumpMaterialWidget(
        Center(
          child: NakedTooltip(
            key: targetKey,
            tooltipBuilder: (context) => const Text('Tooltip Content'),
            waitDuration: Duration.zero,
            showDuration: Duration.zero,
            removalDelay: const Duration(milliseconds: 500),
            onStateChange: stateChanges.add,
            child: const Text('Hover Me'),
          ),
        ),
      );

      // Custom hover simulation to control timing
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();

      // Move to hover position
      await gesture.moveTo(tester.getCenter(find.byKey(targetKey)));
      await tester.pumpAndSettle();

      expect(find.text('Tooltip Content'), findsOneWidget);
      expect(stateChanges, [OverlayChildLifecycleState.present]);

      // Move mouse away - tooltip should still be visible
      await gesture.moveTo(Offset.zero);
      await tester.pumpAndSettle();

      expect(stateChanges, [
        OverlayChildLifecycleState.present,
        OverlayChildLifecycleState.pendingRemoval,
      ]);
      // Wait for half the show duration - tooltip should still be visible
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('Tooltip Content'), findsOneWidget);

      // Wait for the full show duration - tooltip should be hidden
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pump();

      expect(stateChanges, [
        OverlayChildLifecycleState.present,
        OverlayChildLifecycleState.pendingRemoval,
        OverlayChildLifecycleState.removed
      ]);
    });
  });
}
