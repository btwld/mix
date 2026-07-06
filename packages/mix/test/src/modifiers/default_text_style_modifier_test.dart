import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('DefaultTextStyleModifier', () {
    testWidgets('merges partial overrides with the ambient text style', (
      tester,
    ) async {
      const parentStyle = TextStyle(
        fontFamily: 'ParentFont',
        fontSize: 16,
        height: 1.5,
        color: Colors.red,
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: DefaultTextStyle(
            style: parentStyle,
            child: Box(
              style: BoxStyler(
                modifier: WidgetModifierConfig.modifier(
                  DefaultTextStyleModifierMix(
                    style: TextStyleMix(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              child: Text('hello'),
            ),
          ),
        ),
      );

      final inherited = DefaultTextStyle.of(tester.element(find.text('hello')));

      expect(inherited.style.fontFamily, 'ParentFont');
      expect(inherited.style.fontSize, 16);
      expect(inherited.style.height, 1.5);
      expect(inherited.style.color, Colors.red);
      expect(inherited.style.fontWeight, FontWeight.w500);
    });
  });
}
