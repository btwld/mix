import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mix/mix.dart';

import 'flutter_card.dart';
import 'mix_card.dart';
import '../src/benchmark_border_geometry.dart';

const int benchmarkCardCount = 60;
const int stateFreeCardId = 0;
const int pressedOnlyCardId = 1;
const int targetCardId = 2;
const int siblingCardId = 3;
const Size benchmarkViewportSize = Size(1200, 800);
const Duration benchmarkAnimationDuration = Duration(milliseconds: 150);
const Curve benchmarkAnimationCurve = Curves.easeInOut;

enum BenchmarkImplementation { flutter, mix }

enum BenchmarkTrack { isolation, idiomatic }

enum CardStateProfile { stateFree, pressedOnly, all }

extension BenchmarkImplementationName on BenchmarkImplementation {
  String get label => name;
}

extension BenchmarkTrackName on BenchmarkTrack {
  String get label => name;
}

List<BenchmarkImplementation> benchmarkImplementationOrder(String orderLabel) {
  return switch (orderLabel) {
    'flutter-first' => <BenchmarkImplementation>[
      BenchmarkImplementation.flutter,
      BenchmarkImplementation.mix,
    ],
    'mix-first' => <BenchmarkImplementation>[
      BenchmarkImplementation.mix,
      BenchmarkImplementation.flutter,
    ],
    _ => throw ArgumentError.value(
      orderLabel,
      'orderLabel',
      'Expected flutter-first or mix-first',
    ),
  };
}

CardStateProfile stateProfileForCard(int cardId) {
  return switch (cardId) {
    stateFreeCardId => CardStateProfile.stateFree,
    pressedOnlyCardId => CardStateProfile.pressedOnly,
    _ => CardStateProfile.all,
  };
}

final class PipelineCounters {
  int screenBuilds = 0;
  final Map<int, int> cardBuilds = <int, int>{};
  final Map<int, int> mixResolutions = <int, int>{};
  final Map<int, int> layouts = <int, int>{};
  final Map<int, int> paints = <int, int>{};

  int cardBuildsFor(int cardId) => cardBuilds[cardId] ?? 0;
  int mixResolutionsFor(int cardId) => mixResolutions[cardId] ?? 0;
  int layoutsFor(int cardId) => layouts[cardId] ?? 0;
  int paintsFor(int cardId) => paints[cardId] ?? 0;

  void incrementCardBuild(int cardId) {
    cardBuilds.update(cardId, (int value) => value + 1, ifAbsent: () => 1);
  }

  void incrementMixResolution(int cardId) {
    mixResolutions.update(cardId, (int value) => value + 1, ifAbsent: () => 1);
  }

  void incrementLayout(int cardId) {
    layouts.update(cardId, (int value) => value + 1, ifAbsent: () => 1);
  }

  void incrementPaint(int cardId) {
    paints.update(cardId, (int value) => value + 1, ifAbsent: () => 1);
  }

  void reset() {
    screenBuilds = 0;
    cardBuilds.clear();
    mixResolutions.clear();
    layouts.clear();
    paints.clear();
  }
}

@immutable
final class ProductCardData {
  const ProductCardData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.disabled,
  });

  final int id;
  final String title;
  final String subtitle;
  final String badge;
  final bool disabled;
}

const ProductCardData contractCardData = ProductCardData(
  id: 0,
  title: 'Product 00',
  subtitle: 'Deterministic benchmark content',
  badge: 'NEW',
  disabled: false,
);

List<ProductCardData> createBenchmarkCards() {
  const badges = <String>['NEW', 'SALE', 'PRO', 'PLUS'];

  return List<ProductCardData>.generate(
    benchmarkCardCount,
    (int index) => ProductCardData(
      id: index,
      title: 'Product ${index.toString().padLeft(2, '0')}',
      subtitle: 'Deterministic benchmark content',
      badge: badges[index % badges.length],
      disabled: index > targetCardId && index % 17 == 0,
    ),
    growable: false,
  );
}

final class BenchmarkControllerSet {
  BenchmarkControllerSet(List<ProductCardData> cards)
    : controllers = List<WidgetStatesController>.generate(
        cards.length,
        (int index) => WidgetStatesController(<WidgetState>{
          if (cards[index].disabled) WidgetState.disabled,
        }),
        growable: false,
      );

  final List<WidgetStatesController> controllers;
  final ValueNotifier<int> themeVariant = ValueNotifier<int>(0);

  WidgetStatesController operator [](int cardId) => controllers[cardId];

  void setState(int cardId, WidgetState state, bool enabled) {
    controllers[cardId].update(state, enabled);
  }

  void toggleTheme() {
    themeVariant.value = themeVariant.value == 0 ? 1 : 0;
  }

  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    themeVariant.dispose();
  }
}

class PipelineProbe extends SingleChildRenderObjectWidget {
  const PipelineProbe({
    super.key,
    required this.cardId,
    required this.counters,
    required super.child,
  });

  final int cardId;
  final PipelineCounters? counters;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderPipelineProbe(cardId: cardId, counters: counters);
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _RenderPipelineProbe)
      ..cardId = cardId
      ..counters = counters;
  }
}

final class _RenderPipelineProbe extends RenderProxyBox {
  _RenderPipelineProbe({
    required int cardId,
    required PipelineCounters? counters,
  }) : _cardId = cardId,
       _counters = counters;

  int _cardId;
  PipelineCounters? _counters;

  set cardId(int value) => _cardId = value;
  set counters(PipelineCounters? value) => _counters = value;

  @override
  void performLayout() {
    _counters?.incrementLayout(_cardId);
    super.performLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _counters?.incrementPaint(_cardId);
    super.paint(context, offset);
  }
}

class SharedCardRenderer extends StatelessWidget {
  const SharedCardRenderer({
    super.key,
    required this.data,
    required this.spec,
    required this.child,
    this.counters,
  });

  final ProductCardData data;
  final BoxSpec spec;
  final Widget child;
  final PipelineCounters? counters;

  @override
  Widget build(BuildContext context) {
    final container = Container(
      key: ValueKey<String>('card-surface-${data.id}'),
      alignment: spec.alignment,
      padding: spec.padding,
      decoration: spec.decoration,
      foregroundDecoration: spec.foregroundDecoration,
      constraints: spec.constraints,
      margin: spec.margin,
      transform: spec.transform,
      transformAlignment: spec.transformAlignment,
      clipBehavior: spec.clipBehavior ?? Clip.none,
      child: child,
    );
    final pipelineCounters = counters;

    return pipelineCounters == null
        ? container
        : PipelineProbe(
            cardId: data.id,
            counters: pipelineCounters,
            child: container,
          );
  }
}

class ProductCardContent extends StatelessWidget {
  const ProductCardContent({super.key, required this.data});

  final ProductCardData data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(Icons.inventory_2_outlined, size: 28, color: colorScheme.primary),
        const Spacer(),
        Text(
          data.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          data.subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 10),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: const BorderRadius.all(Radius.circular(999)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            child: Text(
              data.badge,
              style: TextStyle(
                color: colorScheme.onSecondaryContainer,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BenchmarkGrid extends StatefulWidget {
  const BenchmarkGrid({
    super.key,
    required this.implementation,
    required this.track,
    required this.cards,
    required this.controllers,
    this.borderGeometry = BenchmarkBorderGeometry.physical,
    this.animated = false,
    this.counters,
  });

  final BenchmarkImplementation implementation;
  final BenchmarkTrack track;
  final List<ProductCardData> cards;
  final BenchmarkControllerSet controllers;
  final BenchmarkBorderGeometry borderGeometry;
  final bool animated;
  final PipelineCounters? counters;

  @override
  State<BenchmarkGrid> createState() => BenchmarkGridState();
}

class BenchmarkGridState extends State<BenchmarkGrid> {
  late final List<Widget> _cachedChildren;

  @override
  void initState() {
    super.initState();
    _cachedChildren = widget.cards
        .map<Widget>((ProductCardData data) => ProductCardContent(data: data))
        .toList(growable: false);
  }

  void rebuildScreen() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    widget.counters?.screenBuilds++;

    return GridView.builder(
      key: const ValueKey<String>('benchmark-grid'),
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisExtent: 176,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: widget.cards.length,
      itemBuilder: (BuildContext context, int index) {
        final data = widget.cards[index];
        final controller = widget.controllers[index];
        final profile = stateProfileForCard(data.id);
        final child = _cachedChildren[index];
        final card = switch ((widget.implementation, widget.track)) {
          (BenchmarkImplementation.flutter, BenchmarkTrack.isolation) =>
            FlutterIsolationCard(
              data: data,
              controller: controller,
              profile: profile,
              borderGeometry: widget.borderGeometry,
              animated: widget.animated,
              counters: widget.counters,
              child: child,
            ),
          (BenchmarkImplementation.flutter, BenchmarkTrack.idiomatic) =>
            FlutterIdiomaticCard(
              data: data,
              controller: controller,
              profile: profile,
              borderGeometry: widget.borderGeometry,
              animated: widget.animated,
              counters: widget.counters,
              child: child,
            ),
          (BenchmarkImplementation.mix, BenchmarkTrack.isolation) =>
            MixIsolationCard(
              data: data,
              controller: controller,
              profile: profile,
              borderGeometry: widget.borderGeometry,
              animated: widget.animated,
              counters: widget.counters,
              child: child,
            ),
          (BenchmarkImplementation.mix, BenchmarkTrack.idiomatic) =>
            MixIdiomaticCard(
              data: data,
              controller: controller,
              profile: profile,
              borderGeometry: widget.borderGeometry,
              animated: widget.animated,
              counters: widget.counters,
              child: child,
            ),
        };

        return RepaintBoundary(
          key: ValueKey<String>('card-boundary-${data.id}'),
          child: card,
        );
      },
    );
  }
}

class BenchmarkApp extends StatelessWidget {
  const BenchmarkApp({
    super.key,
    required this.implementation,
    required this.track,
    required this.cards,
    required this.controllers,
    this.borderGeometry = BenchmarkBorderGeometry.physical,
    this.gridKey,
    this.animated = false,
    this.counters,
  });

  final BenchmarkImplementation implementation;
  final BenchmarkTrack track;
  final List<ProductCardData> cards;
  final BenchmarkControllerSet controllers;
  final BenchmarkBorderGeometry borderGeometry;
  final GlobalKey<BenchmarkGridState>? gridKey;
  final bool animated;
  final PipelineCounters? counters;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: controllers.themeVariant,
      builder: (BuildContext context, int themeVariant, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: const Locale('en', 'US'),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: themeVariant == 0
                  ? const Color(0xff315da8)
                  : const Color(0xff75449a),
            ),
            useMaterial3: true,
          ),
          home: Scaffold(
            body: ColoredBox(
              color: const Color(0xffe9ebef),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox.fromSize(
                    size: benchmarkViewportSize,
                    child: MediaQuery.withClampedTextScaling(
                      minScaleFactor: 1,
                      maxScaleFactor: 1,
                      child: BenchmarkGrid(
                        key: gridKey,
                        implementation: implementation,
                        track: track,
                        cards: cards,
                        controllers: controllers,
                        borderGeometry: borderGeometry,
                        animated: animated,
                        counters: counters,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
