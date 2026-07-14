import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_atlas_example/artifacts/capture_loader.dart';
import 'package:mix_atlas_example/portable_component_renderer.dart';

import 'artifact_fixture.dart';

void main() {
  testWidgets('validates the canonical 240-cell Button matrix', (tester) async {
    const variants = ['solid', 'soft', 'surface', 'outline', 'ghost'];
    const sizes = ['size1', 'size2', 'size3', 'size4'];
    const stateIds = [
      'default',
      'hovered',
      'pressed',
      'focused',
      'disabled',
      'loading',
    ];
    const themeIds = ['light', 'dark'];
    final recipes = [
      for (final variant in variants)
        for (final size in sizes)
          portableButtonRecipe(
            id: '$variant-$size',
            variant: variant,
            size: size,
          ),
    ];
    final fixture = ArtifactFixture.create()
      ..addPortableButtonCapture(
        document: validButtonComponentDocument(recipes: recipes),
      );
    final capture = await CaptureLoader(
      source: fixture.source(),
    ).load(fixtureRequest);
    final component = capture.componentDocuments.single;
    var semanticsCells = 0;
    var behaviorCells = 0;
    var visualComparableCells = 0;
    var loadingUnsupportedCells = 0;
    var activations = 0;

    for (final recipe in component.recipes) {
      for (final stateId in stateIds) {
        for (final themeId in themeIds) {
          final beforeActivation = activations;
          await tester.pumpWidget(
            MaterialApp(
              home: Center(
                child: PortableComponentRenderer(
                  capture: capture,
                  component: component,
                  selection: PortableComponentSelection(
                    recipeId: recipe.id,
                    stateId: stateId,
                    themeId: themeId,
                    properties: const {'label': 'Button', 'leadingIcon': 'add'},
                  ),
                  onActivate: () => activations += 1,
                ),
              ),
            ),
          );

          final root = find.byKey(const ValueKey('portable-component-button'));
          final semantics = tester.getSemantics(root);
          final canActivate = stateId != 'disabled' && stateId != 'loading';
          expect(semantics.label, 'Button');
          expect(semantics.flagsCollection.isButton, isTrue);
          expect(
            semantics.flagsCollection.isEnabled.toBoolOrNull(),
            canActivate,
          );
          expect(semantics.flagsCollection.isLiveRegion, stateId == 'loading');
          semanticsCells += 1;

          final override = tester.widget<WidgetStateStyleOverride>(
            find.byType(WidgetStateStyleOverride),
          );
          expect(override.states, _expectedStates(stateId));

          await tester.tap(root, warnIfMissed: false);
          await tester.pump();
          expect(
            activations,
            canActivate ? beforeActivation + 1 : beforeActivation,
          );
          behaviorCells += 1;

          if (stateId == 'loading') {
            expect(find.text('Unsupported · spinner'), findsOneWidget);
            loadingUnsupportedCells += 1;
          } else {
            expect(find.textContaining('Unsupported ·'), findsNothing);
            visualComparableCells += 1;
          }
          expect(tester.takeException(), isNull);
        }
      }
    }

    expect(semanticsCells, 240);
    expect(behaviorCells, 240);
    expect(visualComparableCells, 200);
    expect(loadingUnsupportedCells, 40);
    expect(activations, 160);
  });
}

Set<WidgetState> _expectedStates(String stateId) => switch (stateId) {
  'default' => const {},
  'hovered' => const {WidgetState.hovered},
  'pressed' => const {WidgetState.pressed},
  'focused' => const {WidgetState.focused},
  'disabled' || 'loading' => const {WidgetState.disabled},
  _ => throw StateError('Unknown test state $stateId.'),
};
