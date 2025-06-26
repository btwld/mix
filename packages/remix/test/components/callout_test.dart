import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

import '../utils/interaction_tests.dart';

void main() {
  group('RxCallout', () {
    group('Constructor', () {
      const text = 'This is a callout message!';
      const icon = Icons.info;
      const variants = [Variant('warning')];
      final style = RxCalloutStyle()..container.color.red();

      testWidgets('should initialize with correct properties',
          (WidgetTester tester) async {
        final widget = RxCallout(
          text: text,
          icon: icon,
          variants: variants,
          style: style,
        );

        await tester.pumpRxWidget(widget);

        expect(widget.variants, variants);
        expect(widget.style, style);
      });

      testWidgets('Raw should initialize with correct properties',
          (WidgetTester tester) async {
        const child = SizedBox(
          width: 100,
          height: 100,
          child: Icon(icon),
        );

        final widget = RxCallout.raw(
          variants: variants,
          style: style,
          child: child,
        );

        await tester.pumpRxWidget(widget);

        expect(widget.child, child);
        expect(widget.variants, variants);
        expect(widget.style, style);
      });
    });
  });
}
