import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naked/src/utilities/pressed_state_region.dart';

/// A fully customizable checkbox with no default styling.
///
/// NakedCheckbox provides core interaction behavior and accessibility
/// without imposing any visual styling, giving consumers complete design freedom.
/// It integrates with [FocusableActionDetector] to provide enhanced keyboard accessibility,
/// hover detection, and focus management.
///
/// This component uses direct callbacks for state changes instead of managing its
/// own state, giving consumers control over their state management approach.
///
/// Example:
/// ```dart
/// class MyCheckbox extends StatefulWidget {
///   @override
///   _MyCheckboxState createState() => _MyCheckboxState();
/// }
///
/// class _MyCheckboxState extends State<MyCheckbox> {
///   bool _isChecked = false;
///   bool _isHovered = false;
///   bool _isPressed = false;
///   bool _isFocused = false;
///
///   @override
///   Widget build(BuildContext context) {
///     return NakedCheckbox(
///       value: _isChecked,
///       onChanged: (value) {
///         setState(() {
///           _isChecked = value!;
///         });
///       },
///       onHoverState: (isHovered) => setState(() => _isHovered = isHovered),
///       onPressedState: (isPressed) => setState(() => _isPressed = isPressed),
///       onFocusState: (isFocused) => setState(() => _isFocused = isFocused),
///       child: Container(
///         height: 20,
///         width: 20,
///         decoration: BoxDecoration(
///           border: Border.all(
///             color: _isFocused
///                 ? Colors.blue.shade400
///                 : _isHovered || _isPressed
///                     ? Colors.blue.shade300
///                     : Colors.grey.shade300,
///             width: 2,
///           ),
///           borderRadius: BorderRadius.circular(4),
///           color: _isChecked ? Colors.blue.shade500 : Colors.transparent,
///         ),
///         child: _isChecked
///             ? Icon(
///                 Icons.check,
///                 size: 16,
///                 color: Colors.white,
///               )
///             : null,
///       ),
///     );
///   }
/// }
/// ```
///
/// See also:
///
///  * [NakedButton], a component that allows users to trigger actions.
///  * The Flutter `Checkbox` widget, which provides a similar functionality with
///    Material Design styling.
///  * The Naked library documentation for more examples and customization options.
class NakedCheckbox extends StatefulWidget {
  /// The child widget to display.
  ///
  /// This widget should represent the visual appearance of the checkbox.
  /// You're responsible for rendering different visual states based on
  /// the callback properties (value, onHoverState, etc.).
  final Widget child;

  /// Whether this checkbox is checked.
  ///
  /// When [tristate] is true, a value of null corresponds to the mixed state.
  /// When [tristate] is false, this value must not be null.
  final bool? value;

  /// If true the checkbox's [value] can be true, false, or null.
  ///
  /// When a tri-state checkbox ([tristate] is true) is tapped, its [onChanged]
  /// callback will be applied to true if the current value is false, to null if
  /// value is true, and to false if value is null (i.e. it cycles through false
  /// => true => null => false when tapped).
  ///
  /// If tristate is false (the default), [value] must not be null.
  final bool tristate;

  /// Called when the checkbox is toggled.
  ///
  /// The callback provides the new state of the checkbox (true for checked, false for unchecked).
  /// If null, the checkbox will be considered disabled and will not respond to user interaction.
  final ValueChanged<bool?>? onChanged;

  /// Callback triggered when the checkbox's hover state changes.
  ///
  /// Passes `true` when the pointer enters the checkbox bounds, and `false`
  /// when it exits. Useful for implementing hover effects.
  final ValueChanged<bool>? onHoverState;

  /// Callback triggered when the checkbox is pressed or released.
  ///
  /// Passes `true` when the checkbox is pressed down, and `false` when released.
  /// Useful for implementing press effects.
  final ValueChanged<bool>? onPressedState;

  /// Callback triggered when the checkbox gains or loses focus.
  ///
  /// Passes `true` when the checkbox gains focus, and `false` when it loses focus.
  /// Useful for implementing focus indicators.
  final ValueChanged<bool>? onFocusState;

  /// Whether the checkbox is disabled.
  ///
  /// When true, the checkbox will not respond to user interaction
  /// and should be styled accordingly.
  final bool enabled;

  /// Optional semantic label for accessibility.
  ///
  /// Provides a description of the checkbox's purpose for screen readers.
  /// If not provided, screen readers will use a default description.
  final String? semanticLabel;

  /// The cursor to show when hovering over the checkbox.
  ///
  /// Defaults to [SystemMouseCursors.click] when enabled,
  /// or [SystemMouseCursors.forbidden] when disabled.
  final MouseCursor cursor;

  /// Whether to provide haptic feedback on tap.
  ///
  /// When true (the default), the device will produce a haptic feedback effect
  /// when the checkbox is toggled.
  final bool enableHapticFeedback;

  /// Optional focus node to control focus behavior.
  ///
  /// If not provided, the checkbox will create its own focus node.
  final FocusNode? focusNode;

  /// Whether the checkbox should be autofocused when the widget is created.
  ///
  /// Defaults to false.
  final bool autofocus;

  /// Creates a naked checkbox.
  ///
  /// The [child] parameter is required and represents the visual appearance
  /// of the checkbox in all states.
  const NakedCheckbox({
    super.key,
    required this.child,
    this.value = false,
    this.tristate = false,
    this.onChanged,
    this.onHoverState,
    this.onPressedState,
    this.onFocusState,
    this.enabled = true,
    this.semanticLabel,
    this.cursor = SystemMouseCursors.click,
    this.enableHapticFeedback = true,
    this.focusNode,
    this.autofocus = false,
  }) : assert((tristate || value != null),
            'Checkbox cannot be both checked and indeterminate');

  @override
  State<NakedCheckbox> createState() => _NakedCheckboxState();
}

class _NakedCheckboxState extends State<NakedCheckbox> {
  void toggleValue([Intent? _]) {
    if (!_isInteractive) return;

    if (widget.enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }

    switch (widget.value) {
      case false:
        widget.onChanged!(true);
      case true:
        widget.onChanged!(widget.tristate ? null : false);
      case null:
        widget.onChanged!(false);
    }
  }

  bool get _isInteractive => widget.enabled && widget.onChanged != null;

  late final Map<Type, Action<Intent>> _actionMap = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: toggleValue),
  };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      checked: widget.value ?? false,
      enabled: _isInteractive,
      mixed: widget.tristate ? widget.value == null : null,
      child: FocusableActionDetector(
        focusNode: widget.focusNode,
        onFocusChange: widget.onFocusState,
        actions: _actionMap,
        enabled: _isInteractive,
        mouseCursor:
            _isInteractive ? widget.cursor : SystemMouseCursors.forbidden,
        onShowFocusHighlight: widget.onFocusState,
        onShowHoverHighlight: widget.onHoverState,
        autofocus: widget.autofocus,
        child: PressedStateRegion(
          enabled: _isInteractive,
          onPressedState: widget.onPressedState,
          onTap: toggleValue,
          child: widget.child,
        ),
      ),
    );
  }
}
