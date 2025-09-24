import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Default parameters for Box matches Container', () {
    testWidgets('should have the same default parameters', (tester) async {
      const boxKey = Key('box');
      const containerKey = Key('container');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Box(style: null, styleSpec: StyleSpec(spec: const BoxSpec()), key: boxKey),
                Container(key: containerKey),
              ],
            ),
          ),
        ),
      );

      /// Get widgets by key
      final boxFinder = find.byKey(boxKey);
      final containerFinder = find.byKey(containerKey);

      /// Find the Container widget inside the Box widget
      final styledContainer = tester.widget<Container>(
        find.descendant(of: boxFinder, matching: find.byType(Container)),
      );
      final container = tester.widget<Container>(containerFinder);

      /// Compare the default parameters with detailed error messages
      expect(
        styledContainer.alignment,
        container.alignment,
        reason:
            'Box alignment (${styledContainer.alignment}) should match Container alignment (${container.alignment})',
      );
      expect(
        styledContainer.padding,
        container.padding,
        reason:
            'Box padding (${styledContainer.padding}) should match Container padding (${container.padding})',
      );
      expect(
        styledContainer.decoration,
        container.decoration,
        reason:
            'Box decoration (${styledContainer.decoration}) should match Container decoration (${container.decoration})',
      );
      expect(
        styledContainer.foregroundDecoration,
        container.foregroundDecoration,
        reason:
            'Box foregroundDecoration (${styledContainer.foregroundDecoration}) should match Container foregroundDecoration (${container.foregroundDecoration})',
      );
      expect(
        styledContainer.constraints,
        container.constraints,
        reason:
            'Box constraints (${styledContainer.constraints}) should match Container constraints (${container.constraints})',
      );
      expect(
        styledContainer.margin,
        container.margin,
        reason:
            'Box margin (${styledContainer.margin}) should match Container margin (${container.margin})',
      );
      expect(
        styledContainer.transform,
        container.transform,
        reason:
            'Box transform (${styledContainer.transform}) should match Container transform (${container.transform})',
      );
      expect(
        styledContainer.transformAlignment,
        container.transformAlignment,
        reason:
            'Box transformAlignment (${styledContainer.transformAlignment}) should match Container transformAlignment (${container.transformAlignment})',
      );
      expect(
        styledContainer.clipBehavior,
        container.clipBehavior,
        reason:
            'Box clipBehavior (${styledContainer.clipBehavior}) should match Container clipBehavior (${container.clipBehavior})',
      );
      expect(
        styledContainer.child,
        container.child,
        reason:
            'Box child (${styledContainer.child}) should match Container child (${container.child})',
      );
    });

    testWidgets('should verify clipBehavior default specifically', (
      tester,
    ) async {
      const boxKey = Key('box');
      const containerKey = Key('container');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Box(style: null, styleSpec: StyleSpec(spec: const BoxSpec()), key: boxKey),
                Container(key: containerKey),
              ],
            ),
          ),
        ),
      );

      /// Get widgets by key
      final boxFinder = find.byKey(boxKey);
      final containerFinder = find.byKey(containerKey);

      /// Find the Container widget inside the Box widget
      final styledContainer = tester.widget<Container>(
        find.descendant(of: boxFinder, matching: find.byType(Container)),
      );
      final container = tester.widget<Container>(containerFinder);

      /// Verify clipBehavior specifically
      expect(
        styledContainer.clipBehavior,
        Clip.none,
        reason: 'Box should default to Clip.none',
      );
      expect(
        container.clipBehavior,
        Clip.none,
        reason: 'Container should default to Clip.none',
      );
      expect(
        styledContainer.clipBehavior,
        container.clipBehavior,
        reason: 'Box and Container clipBehavior should match',
      );
    });
  });
}
