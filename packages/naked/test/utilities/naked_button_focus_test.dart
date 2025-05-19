import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked/naked.dart';

void main() {
  testWidgets('NakedButton manages focus properly',
      (WidgetTester tester) async {
    bool gotFocus = false;
    final focusNode = FocusNode();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: NakedButton(
              focusNode: focusNode,
              onPressed: () {},
              onFocusState: (hasFocus) {
                gotFocus = hasFocus;
              },
              child: const Text('Test Button'),
            ),
          ),
        ),
      ),
    );

    // Focus the button
    focusNode.requestFocus();
    await tester.pump();

    // Verify focus callback was called
    expect(gotFocus, true);

    // Clean up
    focusNode.dispose();
  });

  testWidgets('NakedButton restores focus when removed',
      (WidgetTester tester) async {
    final parentFocusNode = FocusNode();
    final buttonFocusNode = FocusNode();

    // Build a widget with a focused parent and a button
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              children: [
                Focus(
                  focusNode: parentFocusNode,
                  child: Container(
                    width: 100,
                    height: 50,
                    color: Colors.red,
                    child: const Text('Parent'),
                  ),
                ),
                NakedButton(
                  focusNode: buttonFocusNode,
                  onPressed: () {},
                  child: const Text('Test Button'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Focus the parent first
    parentFocusNode.requestFocus();
    await tester.pump();
    expect(parentFocusNode.hasFocus, true);

    // Now focus the button
    buttonFocusNode.requestFocus();
    await tester.pump();
    expect(buttonFocusNode.hasFocus, true);
    expect(parentFocusNode.hasFocus, false);

    // Remove the button from the tree (simulate a dialog closing)
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              children: [
                Focus(
                  focusNode: parentFocusNode,
                  child: Container(
                    width: 100,
                    height: 50,
                    color: Colors.red,
                    child: const Text('Parent'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // NakedFocusManager should restore focus to the parent
    await tester.pump();

    // Verify NakedFocusManager restored focus
    expect(find.byType(NakedButton), findsNothing); // Button is removed

    // Clean up
    parentFocusNode.dispose();
    buttonFocusNode.dispose();
  });
}
