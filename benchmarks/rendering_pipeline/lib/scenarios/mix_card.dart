import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'card_grid.dart';

const Color _baseBorderColor = Color(0xffc7ccd4);
const Color _hoverBackgroundColor = Color(0xffeef4ff);
const Color _hoverBorderColor = Color(0xff4d74d1);
const Color _selectedBorderColor = Color(0xff2457c5);

final BoxStyler _baseStyle = BoxStyler()
    .paddingAll(16)
    .borderAll(color: _baseBorderColor, width: 1)
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

final BoxStyler _pressedStyle = _baseStyle.onPressed(BoxStyler().scale(0.98));

final BoxStyler _allStatesStyle = _pressedStyle
    .onHovered(
      BoxStyler()
          .color(_hoverBackgroundColor)
          .borderAll(color: _hoverBorderColor, width: 1),
    )
    .variant(
      ContextVariant.widgetState(WidgetState.selected),
      BoxStyler().borderAll(color: _selectedBorderColor, width: 2),
    )
    .onDisabled(BoxStyler().wrap(WidgetModifierConfig.opacity(0.45)));

const CurveAnimationConfig _animationConfig = CurveAnimationConfig.easeInOut(
  benchmarkAnimationDuration,
);

final BoxStyler _animatedBaseStyle = _baseStyle.animate(_animationConfig);
final BoxStyler _animatedPressedStyle = _pressedStyle.animate(_animationConfig);
final BoxStyler _animatedAllStatesStyle = _allStatesStyle.animate(
  _animationConfig,
);

class MixIsolationCard extends StatelessWidget {
  const MixIsolationCard({
    super.key,
    required this.data,
    required this.controller,
    required this.profile,
    this.child = const SizedBox.shrink(),
    this.animated = false,
    this.counters,
  });

  final ProductCardData data;
  final WidgetStatesController controller;
  final CardStateProfile profile;
  final Widget child;
  final bool animated;
  final PipelineCounters? counters;

  @override
  Widget build(BuildContext context) {
    final baseStyle = styleForCard(profile, animated: animated);
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
    this.animated = false,
    this.counters,
  });

  final ProductCardData data;
  final WidgetStatesController controller;
  final CardStateProfile profile;
  final Widget child;
  final bool animated;
  final PipelineCounters? counters;

  @override
  Widget build(BuildContext context) {
    final baseStyle = styleForCard(profile, animated: animated);
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

BoxStyler styleForCard(CardStateProfile profile, {required bool animated}) {
  return switch ((profile, animated)) {
    (CardStateProfile.stateFree, false) => _baseStyle,
    (CardStateProfile.pressedOnly, false) => _pressedStyle,
    (CardStateProfile.all, false) => _allStatesStyle,
    (CardStateProfile.stateFree, true) => _animatedBaseStyle,
    (CardStateProfile.pressedOnly, true) => _animatedPressedStyle,
    (CardStateProfile.all, true) => _animatedAllStatesStyle,
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
