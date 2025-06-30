import 'package:flutter/widgets.dart';

import '../core/factory/style_mix.dart';
import '../core/variant.dart';
import '../core/widget_state/internal/gesture_mix_state.dart';
import '../core/widget_state/internal/mouse_region_mix_state.dart';
import '../core/widget_state/widget_state_controller.dart';
import 'context_variant.dart';

@immutable
abstract class MixWidgetStateVariant<Value> extends ContextVariant {
  @override
  final priority = VariantPriority.highest;

  const MixWidgetStateVariant();

  ContextVariantBuilder event(Style Function(Value) fn) {
    return ContextVariantBuilder(
      (BuildContext context) => fn(builder(context)),
      this,
    );
  }

  @protected
  Value builder(BuildContext context);
}

abstract class _ToggleMixStateVariant extends MixWidgetStateVariant<bool> {
  final WidgetState _state;
  const _ToggleMixStateVariant(this._state);

  @override
  bool builder(BuildContext context) => when(context);

  @override
  bool when(BuildContext context) =>
      MixWidgetStateModel.hasStateOf(context, _state);
}

/// Applies styles when widget is hovered over.
class OnHoverVariant extends MixWidgetStateVariant<PointerPosition?> {
  const OnHoverVariant();

  @override
  PointerPosition builder(BuildContext context) {
    final pointerPosition =
        MouseRegionMixWidgetState.of(context)?.pointerPosition;

    return when(context) && pointerPosition != null
        ? pointerPosition
        : const PointerPosition(
            position: Alignment.center,
            offset: Offset.zero,
          );
  }

  @override
  bool when(BuildContext context) => MixWidgetStateModel.hasStateOf(
        context,
        WidgetState.hovered,
      );
}

/// Applies styles when the widget is pressed.
class OnPressVariant extends _ToggleMixStateVariant {
  const OnPressVariant() : super(WidgetState.pressed);
}

/// Applies styles when the widget is long pressed.
class OnLongPressVariant extends ContextVariant {
  @override
  final priority = VariantPriority.highest;

  @Deprecated(
    'The longPress variant has been removed. Please implement your own context variant for it',
  )
  const OnLongPressVariant();

  ContextVariantBuilder event(Style Function(bool) fn) {
    return ContextVariantBuilder(
      (BuildContext context) => fn(when(context)),
      this,
    );
  }

  @override
  bool when(BuildContext context) {
    return LongPressInheritedState.of(context).longPressed;
  }
}

/// Applies styles when the widget is disabled.
class OnDisabledVariant extends _ToggleMixStateVariant {
  const OnDisabledVariant() : super(WidgetState.disabled);
}

/// Applies styles when the widget has focus.
class OnFocusedVariant extends _ToggleMixStateVariant {
  const OnFocusedVariant() : super(WidgetState.focused);
}

/// Applies styles when the widget is selected
class OnSelectedVariant extends _ToggleMixStateVariant {
  const OnSelectedVariant() : super(WidgetState.selected);
}

/// Applies styles when the widget is dragged.
class OnDraggedVariant extends _ToggleMixStateVariant {
  const OnDraggedVariant() : super(WidgetState.dragged);
}

/// Applies styles when the widget is error.
class OnErrorVariant extends _ToggleMixStateVariant {
  const OnErrorVariant() : super(WidgetState.error);
}
