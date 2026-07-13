import 'package:flutter/widgets.dart';

/// A named combination of forced widget states and component props.
///
/// Scenarios are the columns of a component atlas. Widget states
/// (hover, pressed, ...) are forced through normal Mix style resolution;
/// [props] cover structural states that component builders must apply directly
/// (loading, checked, open, ...).
@immutable
class AtlasScenario {
  /// Identifier shown as the column label and recorded in the manifest.
  final String id;

  final String? label;

  /// Widget states forced while resolving styles for this scenario.
  final Set<WidgetState> states;

  /// Component props a cell builder should apply for this scenario.
  final Map<String, Object?> props;

  const AtlasScenario(
    this.id, {
    this.label,
    this.states = const {},
    this.props = const {},
  });
}

/// Standard scenario sets shared across components.
abstract final class AtlasScenarios {
  static const base = AtlasScenario('default');
  static const hovered = AtlasScenario('hovered', states: {.hovered});
  static const pressed = AtlasScenario('pressed', states: {.pressed});
  static const focused = AtlasScenario('focused', states: {.focused});
  static const disabled = AtlasScenario('disabled', states: {.disabled});
  static const selected = AtlasScenario('selected', states: {.selected});
  static const error = AtlasScenario('error', states: {.error});

  /// Scenario set for pointer-interactive components (buttons, links).
  static const interactive = [base, hovered, pressed, focused, disabled];

  /// Scenario set for components with a selected state (checkbox, radio, toggle).
  static const selectable = [
    base,
    hovered,
    pressed,
    focused,
    selected,
    disabled,
  ];
}
