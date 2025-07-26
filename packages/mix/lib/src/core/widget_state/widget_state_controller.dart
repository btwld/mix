import "package:flutter/material.dart";

extension WidgetStateControllerExtension on WidgetStatesController {
  set disabled(bool value) => update(WidgetState.disabled, value);

  set hovered(bool value) => update(WidgetState.hovered, value);

  set pressed(bool value) => update(WidgetState.pressed, value);

  set focused(bool value) => update(WidgetState.focused, value);

  set selected(bool value) => update(WidgetState.selected, value);
  set dragged(bool value) => update(WidgetState.dragged, value);
  set scrolledUnder(bool value) => update(WidgetState.scrolledUnder, value);
  set error(bool value) => update(WidgetState.error, value);

  bool get disabled => value.contains(WidgetState.disabled);
  bool get hovered => value.contains(WidgetState.hovered);
  bool get pressed => value.contains(WidgetState.pressed);
  bool get focused => value.contains(WidgetState.focused);
  bool get selected => value.contains(WidgetState.selected);
  bool get dragged => value.contains(WidgetState.dragged);
  bool get scrolledUnder => value.contains(WidgetState.scrolledUnder);
  bool get error => value.contains(WidgetState.error);

  /// Checks if the controller has a specific widget state.
  bool has(WidgetState state) => value.contains(state);
}

