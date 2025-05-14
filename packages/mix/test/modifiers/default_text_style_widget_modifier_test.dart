import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('DefaultTextStyleModifierSpec', () {
    testWidgets('should wrap the widget with DefaultTextStyle', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Box(
            style: Style(
              $with.defaultTextStyle(
                style: const TextStyle(fontSize: 20, color: Colors.red),
              ),
            ),
            child: const Text('Hello, world!'),
          ),
        ),
      );

      final context = tester.element(find.text('Hello, world!'));
      final defaultTextStyle = DefaultTextStyle.of(context);

      expect(defaultTextStyle.style.fontSize, 20);
      expect(defaultTextStyle.style.color, Colors.red);
    });
  });
}
