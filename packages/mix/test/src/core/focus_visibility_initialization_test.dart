import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Kept in its own file: once any test reads FocusVisibility, pointer tracking
// stays installed for the rest of the isolate, so this test would pass even
// without ensureInitialized.
void main() {
  testWidgets(
    'ensureInitialized records a pointer press before the first Mix widget',
    (tester) async {
      FocusVisibility.ensureInitialized();
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      await tester.tapAt(const Offset(20, 20), kind: .mouse);
      await tester.pump();

      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Pressable(
            autofocus: true,
            focusNode: focusNode,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isTrue);
      expect(FocusVisibility.isVisible, isFalse);
    },
    variant: const TargetPlatformVariant({.macOS}),
  );
}
