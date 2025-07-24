import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Selective Rebuild Optimization', () {
    testWidgets('Pressable child should not rebuild on state changes', (
      WidgetTester tester,
    ) async {
      int childBuildCount = 0;
      int containerBuildCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Pressable(
                onPress: () {
                  // Empty callback for testing
                },
                child: Builder(
                  builder: (context) {
                    childBuildCount++;

                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.blue,
                      child: Builder(
                        builder: (context) {
                          containerBuildCount++;

                          return const Text('Press me');
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Initial build
      expect(childBuildCount, 1);
      expect(containerBuildCount, 1);

      // Hover over the button
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(Pressable)));
      await tester.pump();

      // Child should NOT rebuild on hover
      expect(
        childBuildCount,
        1,
        reason: 'Child should not rebuild on hover state change',
      );
      expect(
        containerBuildCount,
        1,
        reason: 'Container content should not rebuild on hover state change',
      );

      // Press the button
      await tester.tapAt(tester.getCenter(find.byType(Pressable)));
      await tester.pump();

      // Child should NOT rebuild on press
      expect(
        childBuildCount,
        1,
        reason: 'Child should not rebuild on press state change',
      );
      expect(
        containerBuildCount,
        1,
        reason: 'Container content should not rebuild on press state change',
      );

      // Move away to remove hover
      await gesture.moveTo(Offset.zero);
      await tester.pump();

      // Child should still NOT rebuild
      expect(
        childBuildCount,
        1,
        reason: 'Child should not rebuild when hover state is removed',
      );
      expect(
        containerBuildCount,
        1,
        reason:
            'Container content should not rebuild when hover state is removed',
      );
    });

    testWidgets('Interactable child should not rebuild on state changes', (
      WidgetTester tester,
    ) async {
      int childBuildCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Interactable(
                child: Builder(
                  builder: (context) {
                    childBuildCount++;

                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.green,
                      child: const Text('Interact with me'),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Initial build
      expect(childBuildCount, 1);

      // Hover over the interactable
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(Interactable)));
      await tester.pump();

      // Child should NOT rebuild on hover
      expect(
        childBuildCount,
        1,
        reason: 'Interactable child should not rebuild on hover state change',
      );
    });
  });
}
