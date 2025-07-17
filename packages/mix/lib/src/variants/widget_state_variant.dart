import 'package:flutter/widgets.dart';

import '../core/factory/style_mix.dart';
import '../core/variant.dart';
import '../core/widget_state/internal/mouse_region_mix_state.dart';
import '../core/widget_state/widget_state_controller.dart';
import 'context_variant.dart';

@immutable
abstract base class MixWidgetStateVariant<Value> extends ContextVariant {
  const MixWidgetStateVariant();

  ContextVariantBuilder<Value> event(ScopedStyle Function(Value) fn) {
    return ContextVariantBuilder<Value>(
      this,
      (BuildContext context, Value value) => fn(value),
    );
  }

  @protected
  Value builder(BuildContext context);

  @override
  List<Object?> get props => [];
}

abstract base class _ToggleMixStateVariant extends MixWidgetStateVariant<bool> {
  final WidgetState _state;
  const _ToggleMixStateVariant(this._state);

  @override
  bool builder(BuildContext context) => when(context);

  @override
  bool when(BuildContext context) =>
      MixWidgetStateModel.hasStateOf(context, _state);
}

/// Applies styles when widget is hovered over.
base class OnHoverVariant extends MixWidgetStateVariant<PointerPosition?> {
  const OnHoverVariant();

  @override
  PointerPosition builder(BuildContext context) {
    final pointerPosition = MouseRegionMixWidgetState.of(
      context,
    )?.pointerPosition;

    return when(context) && pointerPosition != null
        ? pointerPosition
        : const PointerPosition(
            position: Alignment.center,
            offset: Offset.zero,
          );
  }

  @override
  bool when(BuildContext context) =>
      MixWidgetStateModel.hasStateOf(context, WidgetState.hovered);
}

/// Applies styles when the widget is pressed.
base class OnPressVariant extends _ToggleMixStateVariant {
  const OnPressVariant() : super(WidgetState.pressed);
}


/// Applies styles when the widget is disabled.
base class OnDisabledVariant extends _ToggleMixStateVariant {
  const OnDisabledVariant() : super(WidgetState.disabled);
}

/// Applies styles when the widget has focus.
base class OnFocusedVariant extends _ToggleMixStateVariant {
  const OnFocusedVariant() : super(WidgetState.focused);
}

/// Applies styles when the widget is selected
base class OnSelectedVariant extends _ToggleMixStateVariant {
  const OnSelectedVariant() : super(WidgetState.selected);
}

/// Applies styles when the widget is dragged.
base class OnDraggedVariant extends _ToggleMixStateVariant {
  const OnDraggedVariant() : super(WidgetState.dragged);
}

/// Applies styles when the widget is error.
base class OnErrorVariant extends _ToggleMixStateVariant {
  const OnErrorVariant() : super(WidgetState.error);
}
