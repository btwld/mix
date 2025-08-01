import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Default parameters for StyledIcon matches Icon', () {
    testWidgets('should have the same default parameters', (tester) async {
      const testIcon = Icons.star;
      const styledIconKey = Key('styled-icon');
      const iconKey = Key('icon');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                StyledIcon(testIcon, key: styledIconKey),
                Icon(testIcon, key: iconKey),
              ],
            ),
          ),
        ),
      );

      /// Get widgets by key
      final styledIconFinder = find.byKey(styledIconKey);
      final iconFinder = find.byKey(iconKey);

      /// Find the Icon widget inside the StyledIcon widget
      final styledIcon = tester.widget<Icon>(
        find.descendant(of: styledIconFinder, matching: find.byType(Icon)),
      );
      final icon = tester.widget<Icon>(iconFinder);

      /// Compare the default parameters
      expect(styledIcon.size, icon.size);
      expect(styledIcon.fill, icon.fill);
      expect(styledIcon.weight, icon.weight);
      expect(styledIcon.grade, icon.grade);
      expect(styledIcon.opticalSize, icon.opticalSize);
      expect(styledIcon.color, icon.color);
      expect(styledIcon.shadows, icon.shadows);
      expect(styledIcon.semanticLabel, icon.semanticLabel);
      expect(styledIcon.textDirection, icon.textDirection);
      expect(styledIcon.icon, icon.icon);
    });
  });
}
