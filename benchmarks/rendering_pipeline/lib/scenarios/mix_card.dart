import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../src/benchmark_border_geometry.dart';
import 'card_grid.dart';

const Color _baseBorderColor = Color(0xffc7ccd4);
const Color _hoverBackgroundColor = Color(0xffeef4ff);
const Color _hoverBorderColor = Color(0xff4d74d1);
const Color _selectedBorderColor = Color(0xff2457c5);

const CurveAnimationConfig _animationConfig = CurveAnimationConfig.easeInOut(
  benchmarkAnimationDuration,
);

typedef _CardStyles = ({
  BoxStyler base,
  BoxStyler pressed,
  BoxStyler allStates,
  BoxStyler animatedBase,
  BoxStyler animatedPressed,
  BoxStyler animatedAllStates,
});

final _CardStyles _physicalStyles = _createCardStyles(.physical);
final _CardStyles _directionalStyles = _createCardStyles(.directional);

_CardStyles _createCardStyles(BenchmarkBorderGeometry borderGeometry) {
  final base =
      _withBorder(
            BoxStyler().paddingAll(16),
            borderGeometry,
            color: _baseBorderColor,
            width: 1,
          )
          .borderRadius(BorderRadiusMix.circular(12))
          .shadowOnly(
            color: const Color(0x14000000),
            offset: const Offset(0, 3),
            blurRadius: 8,
          )
          .scale(1)
          .onBuilder(
            (BuildContext context) => BoxStyler().color(
              Theme.of(context).colorScheme.surfaceContainerLowest,
            ),
          );
  final pressed = base.onPressed(BoxStyler().scale(0.98));
  final allStates = pressed
      .onHovered(
        _withBorder(
          BoxStyler().color(_hoverBackgroundColor),
          borderGeometry,
          color: _hoverBorderColor,
          width: 1,
        ),
      )
      .variant(
        ContextVariant.widgetState(WidgetState.selected),
        _withBorder(
          BoxStyler(),
          borderGeometry,
          color: _selectedBorderColor,
          width: 2,
        ),
      )
      .onDisabled(BoxStyler().wrap(WidgetModifierConfig.opacity(0.45)));

  return (
    base: base,
    pressed: pressed,
    allStates: allStates,
    animatedBase: base.animate(_animationConfig),
    animatedPressed: pressed.animate(_animationConfig),
    animatedAllStates: allStates.animate(_animationConfig),
  );
}

BoxStyler _withBorder(
  BoxStyler style,
  BenchmarkBorderGeometry borderGeometry, {
  required Color color,
  required double width,
}) {
  final side = BorderSideMix(color: color, width: width);
  return switch (borderGeometry) {
    BenchmarkBorderGeometry.physical => style.border(BorderMix.all(side)),
    BenchmarkBorderGeometry.directional => style.border(
      BorderDirectionalMix.all(side),
    ),
  };
}

class MixIsolationCard extends StatelessWidget {
  const MixIsolationCard({
    super.key,
    required this.data,
    required this.controller,
    required this.profile,
    this.borderGeometry = BenchmarkBorderGeometry.physical,
    this.child = const SizedBox.shrink(),
    this.animated = false,
    this.counters,
  });

  final ProductCardData data;
  final WidgetStatesController controller;
  final CardStateProfile profile;
  final BenchmarkBorderGeometry borderGeometry;
  final Widget child;
  final bool animated;
  final PipelineCounters? counters;

  @override
  Widget build(BuildContext context) {
    final baseStyle = styleForCard(
      profile,
      animated: animated,
      borderGeometry: borderGeometry,
    );
    final style = counters == null
        ? baseStyle
        : _CountingBoxStyle(
            delegate: baseStyle,
            cardId: data.id,
            counters: counters!,
          );

    return StyleBuilder<BoxSpec>(
      controller: controller,
      style: style,
      builder: (BuildContext context, BoxSpec spec) {
        counters?.incrementCardBuild(data.id);

        return SharedCardRenderer(
          data: data,
          spec: spec,
          counters: counters,
          child: child,
        );
      },
    );
  }
}

class MixIdiomaticCard extends StatelessWidget {
  const MixIdiomaticCard({
    super.key,
    required this.data,
    required this.controller,
    required this.profile,
    required this.child,
    this.borderGeometry = BenchmarkBorderGeometry.physical,
    this.animated = false,
    this.counters,
  });

  final ProductCardData data;
  final WidgetStatesController controller;
  final CardStateProfile profile;
  final BenchmarkBorderGeometry borderGeometry;
  final Widget child;
  final bool animated;
  final PipelineCounters? counters;

  @override
  Widget build(BuildContext context) {
    final baseStyle = styleForCard(
      profile,
      animated: animated,
      borderGeometry: borderGeometry,
    );
    final style = counters == null
        ? baseStyle
        : _CountingBoxStyle(
            delegate: baseStyle,
            cardId: data.id,
            counters: counters!,
          );

    Widget box = Box(style: style, child: child);
    final pipelineCounters = counters;
    if (pipelineCounters != null) {
      box = PipelineProbe(
        cardId: data.id,
        counters: pipelineCounters,
        child: box,
      );
    }

    return KeyedSubtree(
      key: ValueKey<String>('card-hit-target-${data.id}'),
      child: Pressable(
        controller: controller,
        enabled: !data.disabled,
        mouseCursor: data.disabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        semanticButtonLabel: 'Open ${data.title}',
        onPress: data.disabled ? null : () {},
        child: box,
      ),
    );
  }
}

BoxStyler styleForCard(
  CardStateProfile profile, {
  required bool animated,
  BenchmarkBorderGeometry borderGeometry = BenchmarkBorderGeometry.physical,
}) {
  final styles = switch (borderGeometry) {
    BenchmarkBorderGeometry.physical => _physicalStyles,
    BenchmarkBorderGeometry.directional => _directionalStyles,
  };

  return switch ((profile, animated)) {
    (CardStateProfile.stateFree, false) => styles.base,
    (CardStateProfile.pressedOnly, false) => styles.pressed,
    (CardStateProfile.all, false) => styles.allStates,
    (CardStateProfile.stateFree, true) => styles.animatedBase,
    (CardStateProfile.pressedOnly, true) => styles.animatedPressed,
    (CardStateProfile.all, true) => styles.animatedAllStates,
  };
}

final class _CountingBoxStyle extends Style<BoxSpec> {
  _CountingBoxStyle({
    required this.delegate,
    required this.cardId,
    required this.counters,
  }) : super(
         variants: delegate.$variants,
         modifier: delegate.$modifier,
         animation: delegate.$animation,
       );

  final BoxStyler delegate;
  final int cardId;
  final PipelineCounters counters;

  @override
  StyleSpec<BoxSpec> resolve(BuildContext context) {
    counters.incrementMixResolution(cardId);
    return delegate.resolve(context);
  }

  @override
  _CountingBoxStyle merge(covariant Style<BoxSpec>? other) {
    final otherDelegate = switch (other) {
      null => null,
      _CountingBoxStyle(:final delegate) => delegate,
      BoxStyler style => style,
      _ => throw ArgumentError.value(other, 'other', 'Unsupported box style'),
    };

    return _CountingBoxStyle(
      delegate: delegate.merge(otherDelegate),
      cardId: cardId,
      counters: counters,
    );
  }

  @override
  List<Object?> get props => <Object?>[delegate, cardId];
}
