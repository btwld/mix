import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

import '../utils/interaction_tests.dart';

extension _WidgetTesterX on WidgetTester {
  Future<TestGesture> simulateHoverOnTooltip(Key key,
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

    return gesture;
  }
}

void main() {
  group('RxTooltip', () {
    const tooltipText = 'This is a tooltip';
    const childText = 'Hover over me';
    const tooltipChild = Text(tooltipText);
    const child = Text(childText);
    const showDuration = Duration(seconds: 1);
    const waitDuration = Duration(seconds: 0);
    const variants = [Variant('primary')];
    final style = RxTooltipStyle();

    testWidgets('should initialize with correct properties', (tester) async {
      final tooltip = RxTooltip(
        tooltipChild: tooltipChild,
        showDuration: showDuration,
        waitDuration: waitDuration,
        style: style,
        variants: variants,
        child: child,
      );

      await tester.pumpRxWidget(tooltip);

      expect(tooltip.tooltipChild, tooltipChild);
      expect(tooltip.child, child);
      expect(tooltip.showDuration, showDuration);
      expect(tooltip.waitDuration, waitDuration);
      expect(tooltip.style, style);
      expect(tooltip.variants, variants);
    });

    testWidgets('should display tooltip on hover', (tester) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;

      final tooltipKey = UniqueKey();
      final childKey = UniqueKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RxTooltip(
              tooltipChild: Text(tooltipText, key: tooltipKey),
              child: Text(childText, key: childKey),
            ),
          ),
        ),
      );

      final childFinder = find.text(childText);
      expect(childFinder, findsOneWidget);

      await tester.simulateHoverOnTooltip(childKey, onHover: () {
        final tooltipFinder = find.text(tooltipText);
        expect(tooltipFinder, findsOneWidget);
      });
    });
  });
}
