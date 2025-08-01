import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Default parameters for ZBox matches Container+Stack', () {
    testWidgets('should have the same default parameters', (tester) async {
      const zBoxKey = Key('zbox');
      const containerKey = Key('container');
      const stackKey = Key('stack');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ZBox(key: zBoxKey, children: const []),
                Container(
                  key: containerKey,
                  child: Stack(key: stackKey, children: const []),
                ),
              ],
            ),
          ),
        ),
      );

      /// Get widgets by key
      final zBoxFinder = find.byKey(zBoxKey);
      final containerFinder = find.byKey(containerKey);
      final stackFinder = find.byKey(stackKey);

      /// Find the Container and Stack widgets inside the ZBox widget
      final styledContainer = tester.widget<Container>(
        find.descendant(of: zBoxFinder, matching: find.byType(Container)),
      );
      final styledStack = tester.widget<Stack>(
        find.descendant(of: zBoxFinder, matching: find.byType(Stack)),
      );

      final container = tester.widget<Container>(containerFinder);
      final stack = tester.widget<Stack>(stackFinder);

      /// Compare Container default parameters
      expect(styledContainer.alignment, container.alignment);
      expect(styledContainer.padding, container.padding);
      expect(styledContainer.decoration, container.decoration);
      expect(
        styledContainer.foregroundDecoration,
        container.foregroundDecoration,
      );
      expect(styledContainer.constraints, container.constraints);
      expect(styledContainer.margin, container.margin);
      expect(styledContainer.transform, container.transform);
      expect(styledContainer.transformAlignment, container.transformAlignment);
      expect(styledContainer.clipBehavior, container.clipBehavior);

      /// Compare Stack default parameters with detailed error messages
      expect(
        styledStack.alignment,
        stack.alignment,
        reason:
            'ZBox Stack alignment (${styledStack.alignment}) should match Stack alignment (${stack.alignment})',
      );
      expect(
        styledStack.textDirection,
        stack.textDirection,
        reason:
            'ZBox Stack textDirection (${styledStack.textDirection}) should match Stack textDirection (${stack.textDirection})',
      );
      expect(
        styledStack.fit,
        stack.fit,
        reason:
            'ZBox Stack fit (${styledStack.fit}) should match Stack fit (${stack.fit})',
      );
      expect(
        styledStack.clipBehavior,
        stack.clipBehavior,
        reason:
            'ZBox Stack clipBehavior (${styledStack.clipBehavior}) should match Stack clipBehavior (${stack.clipBehavior})',
      );
    });

    testWidgets('should verify Stack defaults match Flutter Stack defaults', (
      tester,
    ) async {
      const zBoxKey = Key('zbox');
      const stackKey = Key('stack');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ZBox(key: zBoxKey, children: const []),
                Stack(key: stackKey, children: const []),
              ],
            ),
          ),
        ),
      );

      /// Get widgets by key
      final zBoxFinder = find.byKey(zBoxKey);
      final stackFinder = find.byKey(stackKey);

      /// Find the Stack widget inside the ZBox widget
      final styledStack = tester.widget<Stack>(
        find.descendant(of: zBoxFinder, matching: find.byType(Stack)),
      );
      final stack = tester.widget<Stack>(stackFinder);

      /// Verify specific defaults
      expect(
        styledStack.alignment,
        AlignmentDirectional.topStart,
        reason: 'ZBox Stack should default to AlignmentDirectional.topStart',
      );
      expect(
        stack.alignment,
        AlignmentDirectional.topStart,
        reason: 'Flutter Stack should default to AlignmentDirectional.topStart',
      );

      expect(
        styledStack.fit,
        StackFit.loose,
        reason: 'ZBox Stack should default to StackFit.loose',
      );
      expect(
        stack.fit,
        StackFit.loose,
        reason: 'Flutter Stack should default to StackFit.loose',
      );

      expect(
        styledStack.clipBehavior,
        Clip.hardEdge,
        reason: 'ZBox Stack should default to Clip.hardEdge',
      );
      expect(
        stack.clipBehavior,
        Clip.hardEdge,
        reason: 'Flutter Stack should default to Clip.hardEdge',
      );
    });
  });
}
