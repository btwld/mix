import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_atlas_capture/src/artifacts/capture_loader.dart';
import 'package:mix_atlas_capture/src/portable_component_renderer.dart';

import 'artifact_fixture.dart';

void main() {
  testWidgets('renders only the whitelisted Mix anatomy and activates safely', (
    tester,
  ) async {
    final fixture = ArtifactFixture.create()..addPortableButtonCapture();
    final capture = await CaptureLoader(
      source: fixture.source(),
    ).load(fixtureRequest);
    var activations = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: PortableComponentRenderer(
            capture: capture,
            component: capture.componentDocuments.single,
            selection: const PortableComponentSelection(
              recipeId: 'solid-size1',
              stateId: 'hovered',
              themeId: 'light',
              properties: {'label': 'Review Button'},
            ),
            onActivate: () => activations += 1,
          ),
        ),
      ),
    );

    expect(find.byType(FlexBox), findsOneWidget);
    final container = tester.widget<FlexBox>(find.byType(FlexBox));
    expect(
      container.children,
      hasLength(1),
      reason: 'Absent optional icon slots must not create spacing children.',
    );
    expect(find.widgetWithText(StyledText, 'Review Button'), findsOneWidget);
    final stateOverride = tester.widget<WidgetStateStyleOverride>(
      find.byType(WidgetStateStyleOverride),
    );
    expect(stateOverride.states, {WidgetState.hovered});
    final semantics = tester.getSemantics(
      find.byKey(const ValueKey('portable-component-button')),
    );
    expect(semantics.label, 'Review Button');
    expect(semantics.flagsCollection.isButton, isTrue);
    expect(semantics.flagsCollection.isEnabled.toBoolOrNull(), isTrue);

    await tester.tap(find.byKey(const ValueKey('portable-component-button')));
    await tester.pump();

    expect(activations, 1);
  });

  testWidgets('reports the unsupported spinner instead of inventing one', (
    tester,
  ) async {
    final fixture = ArtifactFixture.create()..addPortableButtonCapture();
    final capture = await CaptureLoader(
      source: fixture.source(),
    ).load(fixtureRequest);
    var activations = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: PortableComponentRenderer(
            capture: capture,
            component: capture.componentDocuments.single,
            selection: const PortableComponentSelection(
              recipeId: 'solid-size1',
              stateId: 'loading',
              themeId: 'dark',
              properties: {'label': 'Saving'},
            ),
            onActivate: () => activations += 1,
          ),
        ),
      ),
    );

    expect(find.text('Unsupported · spinner'), findsOneWidget);
    final semantics = tester.getSemantics(
      find.byKey(const ValueKey('portable-component-button')),
    );
    expect(semantics.label, 'Saving');
    expect(semantics.flagsCollection.isEnabled.toBoolOrNull(), isFalse);
    expect(semantics.flagsCollection.isLiveRegion, isTrue);

    await tester.tap(find.byKey(const ValueKey('portable-component-button')));
    await tester.pump();

    expect(activations, 0);
  });

  testWidgets('retains an activation semantic when callbacks are omitted', (
    tester,
  ) async {
    final fixture = ArtifactFixture.create()..addPortableButtonCapture();
    final capture = await CaptureLoader(
      source: fixture.source(),
    ).load(fixtureRequest);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: PortableComponentRenderer(
            capture: capture,
            component: capture.componentDocuments.single,
            selection: const PortableComponentSelection(
              recipeId: 'solid-size1',
              stateId: 'default',
              themeId: 'light',
            ),
          ),
        ),
      ),
    );

    final semantics = tester.getSemantics(
      find.byKey(const ValueKey('portable-component-button')),
    );
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
  });
}
