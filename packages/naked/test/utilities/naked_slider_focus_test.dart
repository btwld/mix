import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked/naked.dart';

void main() {
  group('NakedSlider with NakedFocusManager', () {
    testWidgets('responds to keyboard events for horizontal slider',
        (WidgetTester tester) async {
      double value = 0.5;
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('Value: ${value.toStringAsFixed(2)}'),
                    const SizedBox(height: 50),
                    NakedSlider(
                      value: value,
                      focusNode: focusNode,
                      onChanged: (newValue) {
                        setState(() {
                          value = newValue;
                        });
                      },
                      child: Container(
                        width: 200,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Ensure focus is active
      focusNode.requestFocus();
      await tester.pump();

      // Verify focus is set
      expect(focusNode.hasFocus, isTrue);

      // Initial value
      expect(find.text('Value: 0.50'), findsOneWidget);

      // Create a keyboard event
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();

      // Value should have increased
      expect(value > 0.5, isTrue,
          reason: 'Value should increase with right arrow key');

      // Store the value after right arrow
      final valueAfterRight = value;

      // Press left arrow to decrease value
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      expect(value < valueAfterRight, isTrue,
          reason: 'Value should decrease with left arrow key');

      // Press Home to go to minimum
      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pump();
      expect(value, equals(0.0),
          reason: 'Value should be minimum after Home key');

      // Press End to go to maximum
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      expect(value, equals(1.0),
          reason: 'Value should be maximum after End key');
    });

    testWidgets('responds to keyboard events for vertical slider',
        (WidgetTester tester) async {
      double value = 0.5;
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('Value: ${value.toStringAsFixed(2)}'),
                    const SizedBox(height: 50),
                    NakedSlider(
                      value: value,
                      focusNode: focusNode,
                      direction: SliderDirection.vertical,
                      onChanged: (newValue) {
                        setState(() {
                          value = newValue;
                        });
                      },
                      child: Container(
                        width: 30,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Ensure focus is active
      focusNode.requestFocus();
      await tester.pump();

      // Verify focus is set
      expect(focusNode.hasFocus, isTrue);

      // Initial value
      expect(find.text('Value: 0.50'), findsOneWidget);

      // Press up arrow to increase value (vertical slider)
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(value > 0.5, isTrue,
          reason:
              'Value should increase with up arrow key for vertical slider');

      // Store the value after up arrow
      final valueAfterUp = value;

      // Press down arrow to decrease value
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(value < valueAfterUp, isTrue,
          reason:
              'Value should decrease with down arrow key for vertical slider');
    });

    testWidgets('handles RTL direction correctly for horizontal slider',
        (WidgetTester tester) async {
      double value = 0.5;
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          // Use RTL direction
          theme: ThemeData(
            platform: TargetPlatform.android,
          ),
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      Text('Value: ${value.toStringAsFixed(2)}'),
                      const SizedBox(height: 50),
                      NakedSlider(
                        value: value,
                        focusNode: focusNode,
                        onChanged: (newValue) {
                          setState(() {
                            value = newValue;
                          });
                        },
                        child: Container(
                          width: 200,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Ensure focus is active
      focusNode.requestFocus();
      await tester.pump();

      // Verify focus is set
      expect(focusNode.hasFocus, isTrue);

      // Initial value
      expect(find.text('Value: 0.50'), findsOneWidget);

      // In RTL, right arrow should DECREASE value
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(value < 0.5, isTrue,
          reason: 'Value should decrease with right arrow key in RTL');

      // Store the value after right arrow
      final valueAfterRight = value;

      // In RTL, left arrow should INCREASE value
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      expect(value > valueAfterRight, isTrue,
          reason: 'Value should increase with left arrow key in RTL');
    });
  });
}
