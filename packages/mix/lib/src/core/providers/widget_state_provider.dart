import 'package:flutter/widgets.dart'
    show WidgetState, InheritedModel, BuildContext, WidgetStatesController;

extension on Set<WidgetState> {
  bool get hasDisabled => contains(WidgetState.disabled);
  bool get hasHovered => contains(WidgetState.hovered);
  bool get hasFocused => contains(WidgetState.focused);
  bool get hasPressed => contains(WidgetState.pressed);
  bool get hasDragged => contains(WidgetState.dragged);
  bool get hasSelected => contains(WidgetState.selected);
  bool get hasError => contains(WidgetState.error);
}

class WidgetStateProvider extends InheritedModel<WidgetState> {
  WidgetStateProvider({
    super.key,
    required Set<WidgetState> states,
    required super.child,
  }) : disabled = states.hasDisabled,
       hovered = states.hasHovered,
       focused = states.hasFocused,
       pressed = states.hasPressed,
       dragged = states.hasDragged,
       selected = states.hasSelected,
       error = states.hasError;

  static WidgetStateProvider? of(BuildContext context, [WidgetState? state]) {
    return InheritedModel.inheritFrom<WidgetStateProvider>(
      context,
      aspect: state,
    );
  }

  static bool hasStateOf(BuildContext context, WidgetState state) {
    final model = of(context, state);
    if (model == null) {
      return false;
    }

    return switch (state) {
      WidgetState.disabled => model.disabled,
      WidgetState.hovered => model.hovered,
      WidgetState.focused => model.focused,
      WidgetState.pressed => model.pressed,
      WidgetState.dragged => model.dragged,
      WidgetState.selected => model.selected,
      WidgetState.error => model.error,
      WidgetState.scrolledUnder => false,
    };
  }

  final bool disabled;
  final bool hovered;
  final bool focused;
  final bool pressed;
  final bool dragged;
  final bool selected;
  final bool error;

  @override
  bool updateShouldNotify(WidgetStateProvider oldWidget) {
    return oldWidget.disabled != disabled ||
        oldWidget.hovered != hovered ||
        oldWidget.focused != focused ||
        oldWidget.pressed != pressed ||
        oldWidget.dragged != dragged ||
        oldWidget.selected != selected ||
        oldWidget.error != error;
  }

  @override
  bool updateShouldNotifyDependent(
    WidgetStateProvider oldWidget,
    Set<WidgetState> dependencies,
  ) {
    return oldWidget.disabled != disabled && dependencies.hasDisabled ||
        oldWidget.hovered != hovered && dependencies.hasHovered ||
        oldWidget.focused != focused && dependencies.hasFocused ||
        oldWidget.pressed != pressed && dependencies.hasPressed ||
        oldWidget.dragged != dragged && dependencies.hasDragged ||
        oldWidget.selected != selected && dependencies.hasSelected ||
        oldWidget.error != error && dependencies.hasError;
  }
}

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
