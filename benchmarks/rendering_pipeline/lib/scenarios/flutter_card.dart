import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'card_grid.dart';

const Color _baseBorderColor = Color(0xffc7ccd4);
const Color _hoverBackgroundColor = Color(0xffeef4ff);
const Color _hoverBorderColor = Color(0xff4d74d1);
const Color _selectedBorderColor = Color(0xff2457c5);
const List<BoxShadow> _cardShadows = <BoxShadow>[
  BoxShadow(color: Color(0x14000000), offset: Offset(0, 3), blurRadius: 8),
];

typedef _InteractionState = ({
  bool disabled,
  bool hovered,
  bool pressed,
  bool selected,
});

const _InteractionState _emptyState = (
  disabled: false,
  hovered: false,
  pressed: false,
  selected: false,
);

class FlutterIsolationCard extends StatelessWidget {
  const FlutterIsolationCard({
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
    return _RelevantWidgetStateBuilder(
      controller: controller,
      profile: profile,
      builder: (BuildContext context, _InteractionState state) {
        counters?.incrementCardBuild(data.id);

        return _FlutterCardVisual(
          data: data,
          state: state,
          animated: animated,
          counters: counters,
          child: child,
        );
      },
    );
  }
}

class FlutterIdiomaticCard extends StatefulWidget {
  const FlutterIdiomaticCard({
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
  State<FlutterIdiomaticCard> createState() => _FlutterIdiomaticCardState();
}

class _FlutterIdiomaticCardState extends State<FlutterIdiomaticCard> {
  void _setState(WidgetState state, bool value) {
    widget.controller.update(state, value);
  }

  void _onTapDown(TapDownDetails details) => _setState(.pressed, true);
  void _onTapUp(TapUpDetails details) => _setState(.pressed, false);
  void _onTapCancel() => _setState(.pressed, false);

  @override
  Widget build(BuildContext context) {
    final enabled = !widget.data.disabled;
    final visual = _RelevantWidgetStateBuilder(
      controller: widget.controller,
      profile: widget.profile,
      builder: (BuildContext context, _InteractionState state) {
        widget.counters?.incrementCardBuild(widget.data.id);

        return _FlutterCardVisual(
          data: widget.data,
          state: state,
          animated: widget.animated,
          counters: widget.counters,
          child: widget.child,
        );
      },
    );

    Widget current = GestureDetector(
      onTapDown: enabled ? _onTapDown : null,
      onTapUp: enabled ? _onTapUp : null,
      onTapCancel: enabled ? _onTapCancel : null,
      onTap: enabled ? () {} : null,
      behavior: HitTestBehavior.opaque,
      child: MouseRegion(
        cursor: enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        onEnter: enabled ? (_) => _setState(.hovered, true) : null,
        onExit: enabled ? (_) => _setState(.hovered, false) : null,
        child: Actions(
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<Intent>(onInvoke: (_) => null),
          },
          child: Focus(
            canRequestFocus: enabled,
            onFocusChange: (bool value) => _setState(.focused, value),
            child: visual,
          ),
        ),
      ),
    );

    current = Semantics(
      button: true,
      label: 'Open ${widget.data.title}',
      onTap: enabled ? () {} : null,
      child: current,
    );

    return KeyedSubtree(
      key: ValueKey<String>('card-hit-target-${widget.data.id}'),
      child: current,
    );
  }
}

class _RelevantWidgetStateBuilder extends StatefulWidget {
  const _RelevantWidgetStateBuilder({
    required this.controller,
    required this.profile,
    required this.builder,
  });

  final WidgetStatesController controller;
  final CardStateProfile profile;
  final Widget Function(BuildContext context, _InteractionState state) builder;

  @override
  State<_RelevantWidgetStateBuilder> createState() =>
      _RelevantWidgetStateBuilderState();
}

class _RelevantWidgetStateBuilderState
    extends State<_RelevantWidgetStateBuilder> {
  late _InteractionState _state;

  @override
  void initState() {
    super.initState();
    _state = _selectState();
    if (widget.profile != CardStateProfile.stateFree) {
      widget.controller.addListener(_handleControllerChange);
    }
  }

  @override
  void didUpdateWidget(_RelevantWidgetStateBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller ||
        oldWidget.profile != widget.profile) {
      if (oldWidget.profile != CardStateProfile.stateFree) {
        oldWidget.controller.removeListener(_handleControllerChange);
      }
      _state = _selectState();
      if (widget.profile != CardStateProfile.stateFree) {
        widget.controller.addListener(_handleControllerChange);
      }
    }
  }

  @override
  void dispose() {
    if (widget.profile != CardStateProfile.stateFree) {
      widget.controller.removeListener(_handleControllerChange);
    }
    super.dispose();
  }

  _InteractionState _selectState() {
    final states = widget.controller.value;

    return switch (widget.profile) {
      CardStateProfile.stateFree => _emptyState,
      CardStateProfile.pressedOnly => (
        disabled: false,
        hovered: false,
        pressed: states.contains(WidgetState.pressed),
        selected: false,
      ),
      CardStateProfile.all => (
        disabled: states.contains(WidgetState.disabled),
        hovered: states.contains(WidgetState.hovered),
        pressed: states.contains(WidgetState.pressed),
        selected: states.contains(WidgetState.selected),
      ),
    };
  }

  void _handleControllerChange() {
    final nextState = _selectState();
    if (nextState != _state) {
      setState(() {
        _state = nextState;
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _state);
}

class _FlutterCardVisual extends StatelessWidget {
  const _FlutterCardVisual({
    required this.data,
    required this.state,
    required this.animated,
    required this.counters,
    required this.child,
  });

  final ProductCardData data;
  final _InteractionState state;
  final bool animated;
  final PipelineCounters? counters;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final targetSpec = _boxSpecFor(context, state);

    Widget current;
    if (animated) {
      current = TweenAnimationBuilder<BoxSpec>(
        duration: benchmarkAnimationDuration,
        curve: benchmarkAnimationCurve,
        tween: _BoxSpecTween(end: targetSpec),
        builder: (BuildContext context, BoxSpec value, Widget? cachedChild) {
          return SharedCardRenderer(
            data: data,
            spec: value,
            counters: counters,
            child: cachedChild!,
          );
        },
        child: child,
      );
    } else {
      current = SharedCardRenderer(
        data: data,
        spec: targetSpec,
        counters: counters,
        child: child,
      );
    }

    if (state.disabled) {
      current = animated
          ? AnimatedOpacity(
              opacity: 0.45,
              duration: benchmarkAnimationDuration,
              curve: benchmarkAnimationCurve,
              child: current,
            )
          : Opacity(opacity: 0.45, child: current);
    }

    return current;
  }
}

final class _BoxSpecTween extends Tween<BoxSpec> {
  _BoxSpecTween({required super.end});

  @override
  BoxSpec lerp(double t) => begin?.lerp(end, t) ?? end!;
}

BoxSpec _boxSpecFor(BuildContext context, _InteractionState state) {
  final colorScheme = Theme.of(context).colorScheme;
  final backgroundColor = state.hovered
      ? _hoverBackgroundColor
      : colorScheme.surfaceContainerLowest;
  final borderColor = state.selected
      ? _selectedBorderColor
      : state.hovered
      ? _hoverBorderColor
      : _baseBorderColor;
  final borderWidth = state.selected ? 2.0 : 1.0;
  final scale = state.pressed ? 0.98 : 1.0;

  return BoxSpec(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: backgroundColor,
      border: Border.all(color: borderColor, width: borderWidth),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      boxShadow: _cardShadows,
    ),
    transform: Matrix4.diagonal3Values(scale, scale, 1),
    transformAlignment: Alignment.center,
  );
}
