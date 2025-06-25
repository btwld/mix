import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

import '../utils/interaction_tests.dart';

void main() {
  group('RxCard', () {
    const childText = 'Hello, World!';
    const variants = [Variant('primary')];
    final style = RxCardStyle();

    testWidgets('should initialize with correct properties',
        (WidgetTester tester) async {
      final widget = RxCard(
        style: style,
        variants: variants,
        child: const Text(childText),
      );

      await tester.pumpRxWidget(widget);

      expect(widget.child, isA<Text>());
      expect(widget.style, style);
      expect(widget.variants, variants);

      expect(find.text(childText), findsOneWidget);
    });

    testWidgets('should apply style correctly', (WidgetTester tester) async {
      final style = RxCardStyle()..container.color.red();

      final widget = RxCard(
        style: style,
        child: const Text(childText),
      );

      await tester.pumpRxWidget(widget);

      final containerFinder = find.byType(Container);
      final containerWidget = tester.widget<Container>(containerFinder);
      final boxDecoration = containerWidget.decoration as BoxDecoration;
      expect(boxDecoration.color, Colors.red);
    });

    group('interactions', () {
      testHoverWidget('should handle hover state', () {
        return RxCard(
          style: RxCardStyle()..on.hover(RxCardStyle()..container.color.red()),
          child: const Text(childText),
        );
      }, shouldExpectHover: true);
    });
  });
}
