import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rendering_pipeline/scenarios/card_grid.dart';
import 'package:rendering_pipeline/scenarios/flutter_card.dart';
import 'package:rendering_pipeline/scenarios/mix_card.dart';

const ProductCardData _targetData = ProductCardData(
  id: targetCardId,
  title: 'Product 02',
  subtitle: 'Deterministic benchmark content',
  badge: 'PRO',
  disabled: false,
);

const ProductCardData _siblingData = ProductCardData(
  id: siblingCardId,
  title: 'Product 03',
  subtitle: 'Deterministic benchmark content',
  badge: 'PLUS',
  disabled: false,
);

const Widget _cachedChild = SizedBox.expand();

void main() {
  group('Mix widget-state dependency contracts', () {
    testWidgets('hover does not resolve a state-free card', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();
      final counters = PipelineCounters();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _ContractScreen(
          counters: counters,
          children: <Widget>[
            MixIsolationCard(
              data: contractCardData,
              controller: controller,
              profile: CardStateProfile.stateFree,
              counters: counters,
              child: _cachedChild,
            ),
          ],
        ),
      );

      counters.reset();
      controller.update(WidgetState.hovered, true);
      await tester.pump();

      _expectNoPipelineWork(counters, contractCardData.id);
      expect(counters.screenBuilds, 0);
    });

    testWidgets('hover does not resolve a pressed-only card', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();
      final counters = PipelineCounters();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _ContractScreen(
          counters: counters,
          children: <Widget>[
            MixIsolationCard(
              data: const ProductCardData(
                id: pressedOnlyCardId,
                title: 'Product 01',
                subtitle: 'Deterministic benchmark content',
                badge: 'SALE',
                disabled: false,
              ),
              controller: controller,
              profile: CardStateProfile.pressedOnly,
              counters: counters,
              child: _cachedChild,
            ),
          ],
        ),
      );

      counters.reset();
      controller.update(WidgetState.hovered, true);
      await tester.pump();

      _expectNoPipelineWork(counters, pressedOnlyCardId);
      expect(counters.screenBuilds, 0);
    });

    testWidgets('declared state resolves and paints only the target card', (
      WidgetTester tester,
    ) async {
      final targetController = WidgetStatesController();
      final siblingController = WidgetStatesController();
      final counters = PipelineCounters();
      addTearDown(targetController.dispose);
      addTearDown(siblingController.dispose);

      await tester.pumpWidget(
        _ContractScreen(
          counters: counters,
          children: <Widget>[
            MixIsolationCard(
              data: _targetData,
              controller: targetController,
              profile: CardStateProfile.all,
              counters: counters,
              child: _cachedChild,
            ),
            MixIsolationCard(
              data: _siblingData,
              controller: siblingController,
              profile: CardStateProfile.all,
              counters: counters,
              child: _cachedChild,
            ),
          ],
        ),
      );

      counters.reset();
      targetController.update(WidgetState.pressed, true);
      await tester.pump();

      expect(counters.screenBuilds, 0);
      expect(counters.mixResolutionsFor(targetCardId), 1);
      expect(counters.cardBuildsFor(targetCardId), 1);
      expect(counters.layoutsFor(targetCardId), 0);
      expect(counters.paintsFor(targetCardId), greaterThan(0));
      _expectNoPipelineWork(counters, siblingCardId);
    });

    testWidgets('external controller does not rebuild unrelated siblings', (
      WidgetTester tester,
    ) async {
      final targetController = WidgetStatesController();
      final siblingController = WidgetStatesController();
      final counters = PipelineCounters();
      addTearDown(targetController.dispose);
      addTearDown(siblingController.dispose);

      await tester.pumpWidget(
        _ContractScreen(
          counters: counters,
          children: <Widget>[
            MixIsolationCard(
              data: _targetData,
              controller: targetController,
              profile: CardStateProfile.all,
              counters: counters,
              child: _cachedChild,
            ),
            MixIsolationCard(
              data: _siblingData,
              controller: siblingController,
              profile: CardStateProfile.all,
              counters: counters,
              child: _cachedChild,
            ),
          ],
        ),
      );

      counters.reset();
      targetController.update(WidgetState.selected, true);
      await tester.pump();

      expect(counters.screenBuilds, 0);
      expect(counters.mixResolutionsFor(targetCardId), 1);
      expect(counters.cardBuildsFor(targetCardId), 1);
      _expectNoPipelineWork(counters, siblingCardId);
    });
  });

  group('Mix idiomatic widget-state dependency contracts', () {
    testWidgets('hover does not resolve a state-free card', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();
      final counters = PipelineCounters();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _ContractScreen(
          counters: counters,
          children: <Widget>[
            MixIdiomaticCard(
              data: contractCardData,
              controller: controller,
              profile: CardStateProfile.stateFree,
              counters: counters,
              child: _cachedChild,
            ),
          ],
        ),
      );

      counters.reset();
      controller.update(WidgetState.hovered, true);
      await tester.pump();

      _expectNoPipelineWork(counters, contractCardData.id);
      expect(counters.screenBuilds, 0);
    });

    testWidgets('hover does not resolve a pressed-only card', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();
      final counters = PipelineCounters();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _ContractScreen(
          counters: counters,
          children: <Widget>[
            MixIdiomaticCard(
              data: const ProductCardData(
                id: pressedOnlyCardId,
                title: 'Product 01',
                subtitle: 'Deterministic benchmark content',
                badge: 'SALE',
                disabled: false,
              ),
              controller: controller,
              profile: CardStateProfile.pressedOnly,
              counters: counters,
              child: _cachedChild,
            ),
          ],
        ),
      );

      counters.reset();
      controller.update(WidgetState.hovered, true);
      await tester.pump();

      _expectNoPipelineWork(counters, pressedOnlyCardId);
      expect(counters.screenBuilds, 0);
    });
  });

  group('State transition diagnostic contracts', () {
    testWidgets('S2 coalesces two notifications into one Mix resolution', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();
      final counters = PipelineCounters();
      var notifications = 0;
      controller.addListener(() => notifications++);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _ContractScreen(
          counters: counters,
          children: <Widget>[
            MixIsolationCard(
              data: _targetData,
              controller: controller,
              profile: CardStateProfile.all,
              counters: counters,
              child: _cachedChild,
            ),
          ],
        ),
      );

      counters.reset();
      notifications = 0;
      controller
        ..update(WidgetState.pressed, true)
        ..update(WidgetState.selected, true);
      await tester.pump();

      expect(notifications, 2);
      expect(counters.mixResolutionsFor(targetCardId), 1);
      expect(counters.cardBuildsFor(targetCardId), 1);
    });

    testWidgets('idiomatic press resolves once per pressed transition', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();
      final counters = PipelineCounters();
      var pressedTransitions = 0;
      var wasPressed = false;
      controller.addListener(() {
        final isPressed = controller.value.contains(WidgetState.pressed);
        if (isPressed != wasPressed) {
          pressedTransitions++;
          wasPressed = isPressed;
        }
      });
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _ContractScreen(
          counters: counters,
          children: <Widget>[
            MixIdiomaticCard(
              data: _targetData,
              controller: controller,
              profile: CardStateProfile.all,
              counters: counters,
              child: _cachedChild,
            ),
          ],
        ),
      );

      counters.reset();
      final hitTarget = find.byKey(
        const ValueKey<String>('card-hit-target-$targetCardId'),
      );
      final gesture = await tester.startGesture(tester.getCenter(hitTarget));
      await tester.pump();

      expect(pressedTransitions, 1);
      expect(counters.mixResolutionsFor(targetCardId), 1);

      counters.reset();
      await gesture.up();
      await tester.pump();

      expect(pressedTransitions, 2);
      expect(counters.mixResolutionsFor(targetCardId), 1);
    });
  });

  group('Flutter isolation baseline contracts', () {
    testWidgets('hover does not rebuild a pressed-only mapper', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();
      final counters = PipelineCounters();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _ContractScreen(
          counters: counters,
          children: <Widget>[
            FlutterIsolationCard(
              data: const ProductCardData(
                id: pressedOnlyCardId,
                title: 'Product 01',
                subtitle: 'Deterministic benchmark content',
                badge: 'SALE',
                disabled: false,
              ),
              controller: controller,
              profile: CardStateProfile.pressedOnly,
              counters: counters,
              child: _cachedChild,
            ),
          ],
        ),
      );

      counters.reset();
      controller.update(WidgetState.hovered, true);
      await tester.pump();

      _expectNoPipelineWork(counters, pressedOnlyCardId);
      expect(counters.screenBuilds, 0);
    });

    testWidgets('declared state rebuilds and paints only the target mapper', (
      WidgetTester tester,
    ) async {
      final targetController = WidgetStatesController();
      final siblingController = WidgetStatesController();
      final counters = PipelineCounters();
      addTearDown(targetController.dispose);
      addTearDown(siblingController.dispose);

      await tester.pumpWidget(
        _ContractScreen(
          counters: counters,
          children: <Widget>[
            FlutterIsolationCard(
              data: _targetData,
              controller: targetController,
              profile: CardStateProfile.all,
              counters: counters,
              child: _cachedChild,
            ),
            FlutterIsolationCard(
              data: _siblingData,
              controller: siblingController,
              profile: CardStateProfile.all,
              counters: counters,
              child: _cachedChild,
            ),
          ],
        ),
      );

      counters.reset();
      targetController.update(WidgetState.pressed, true);
      await tester.pump();

      expect(counters.screenBuilds, 0);
      expect(counters.cardBuildsFor(targetCardId), 1);
      expect(counters.layoutsFor(targetCardId), 0);
      expect(counters.paintsFor(targetCardId), greaterThan(0));
      _expectNoPipelineWork(counters, siblingCardId);
    });
  });

  testWidgets('S0 screen rebuild exercises visible cards in both pipelines', (
    WidgetTester tester,
  ) async {
    final cards = createBenchmarkCards();
    for (final implementation in BenchmarkImplementation.values) {
      final counters = PipelineCounters();
      final controllers = BenchmarkControllerSet(cards);
      final gridKey = GlobalKey<BenchmarkGridState>();
      addTearDown(controllers.dispose);

      await tester.pumpWidget(
        BenchmarkApp(
          implementation: implementation,
          track: BenchmarkTrack.isolation,
          cards: cards,
          controllers: controllers,
          counters: counters,
          gridKey: gridKey,
        ),
      );

      counters.reset();
      gridKey.currentState!.rebuildScreen();
      await tester.pump();

      expect(counters.screenBuilds, 1, reason: implementation.label);
      expect(counters.cardBuildsFor(targetCardId), 1);
      expect(counters.cardBuildsFor(siblingCardId), 1);
      final expectedMixResolutions =
          implementation == BenchmarkImplementation.mix ? 1 : 0;
      expect(counters.mixResolutionsFor(targetCardId), expectedMixResolutions);
      expect(counters.mixResolutionsFor(siblingCardId), expectedMixResolutions);
    }
  });
}

void _expectNoPipelineWork(PipelineCounters counters, int cardId) {
  expect(counters.mixResolutionsFor(cardId), 0);
  expect(counters.cardBuildsFor(cardId), 0);
  expect(counters.layoutsFor(cardId), 0);
  expect(counters.paintsFor(cardId), 0);
}

class _ContractScreen extends StatelessWidget {
  const _ContractScreen({required this.counters, required this.children});

  final PipelineCounters counters;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    counters.screenBuilds++;

    return MaterialApp(
      home: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: children
              .map<Widget>(
                (Widget child) => RepaintBoundary(
                  child: SizedBox(width: 180, height: 160, child: child),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}
