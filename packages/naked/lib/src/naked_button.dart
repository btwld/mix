import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'utilities/pressed_state_region.dart';

/// A fully customizable button with no default styling.
///
/// NakedButton provides interaction behavior and accessibility features
/// without imposing any visual styling, giving consumers complete design freedom.
/// It integrates with [FocusableActionDetector] to provide enhanced keyboard accessibility,
/// hover detection, and focus management.
///
/// This component handles various interaction states (hover, pressed, focused, disabled, loading)
/// and provides direct callbacks to allow consumers to manage their own visual state.
///
/// Example:
/// ```dart
/// class MyButton extends StatefulWidget {
///   @override
///   _MyButtonState createState() => _MyButtonState();
/// }
///
/// class _MyButtonState extends State<MyButton> {
///   bool _isHovered = false;
///   bool _isPressed = false;
///   bool _isFocused = false;
///
///   @override
///   Widget build(BuildContext context) {
///     return NakedButton(
///       onPressed: () {
///         print('Button pressed!');
///       },
///       onHoverState: (isHovered) => setState(() => _isHovered = isHovered),
///       onPressedState: (isPressed) => setState(() => _isPressed = isPressed),
///       onFocusState: (isFocused) => setState(() => _isFocused = isFocused),
///       child: Container(
///         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
///         decoration: BoxDecoration(
///           color: _isPressed
///               ? Colors.blue.shade700
///               : _isHovered
///                   ? Colors.blue.shade600
///                   : Colors.blue.shade500,
///           borderRadius: BorderRadius.circular(4),
///           border: Border.all(
///             color: _isFocused ? Colors.white : Colors.transparent,
///             width: 2,
///           ),
///         ),
///         child: Text(
///           'Click Me',
///           style: TextStyle(color: Colors.white),
///         ),
///       ),
///     );
///   }
/// }
/// ```
class NakedButton extends StatefulWidget {
  /// The child widget to display.
  ///
  /// This widget should represent the visual appearance of the button.
  /// You're responsible for styling this widget based on the button's state
  /// using the provided callback properties.
  final Widget child;

  /// Called when the button is tapped or activated via keyboard.
  ///
  /// If null, the button will be considered disabled and will not respond
  /// to user interaction.
  final VoidCallback? onPressed;

  /// Called when hover state changes.
  ///
  /// Provides the current hover state (true when hovered, false otherwise).
  /// Use this to update the visual appearance when the user hovers over the button.
  final ValueChanged<bool>? onHoverState;

  /// Called when pressed state changes.
  ///
  /// Provides the current pressed state (true when pressed, false otherwise).
  /// Use this to update the visual appearance when the user presses the button.
  final ValueChanged<bool>? onPressedState;

  /// Called when focus state changes.
  ///
  /// Provides the current focus state (true when focused, false otherwise).
  /// Use this to update the visual appearance when the button receives or loses focus.
  final ValueChanged<bool>? onFocusState;

  /// Called when disabled state changes.
  ///
  /// Provides the current disabled state (true when disabled, false otherwise).
  /// Use this to update the visual appearance when the button is disabled.
  final ValueChanged<bool>? onDisabledState;

  /// Whether the button is disabled.
  ///
  /// When true, the button will not respond to user interaction regardless of
  /// whether [onPressed] is provided.
  final bool enabled;

  /// Whether the button should be treated as a semantic button.
  ///
  /// When true, the button will be treated as a semantic button and will
  /// have a semantic label and hint.
  final bool isSemanticButton;

  /// The semantic label for the button.
  ///
  /// This label will be used to describe the button to users of assistive technologies.
  final String? semanticLabel;

  /// The cursor to show when hovering over the button.
  ///
  /// Defaults to [SystemMouseCursors.click] when enabled,
  /// or [SystemMouseCursors.forbidden] when disabled.
  final MouseCursor cursor;

  /// Whether to provide haptic feedback on press.
  ///
  /// When true (the default), the device will produce a haptic feedback
  /// effect when the button is pressed.
  final bool enableHapticFeedback;

  /// Optional focus node to control focus behavior.
  ///
  /// If not provided, the button will create its own focus node.
  final FocusNode? focusNode;

  /// Whether the button should be focused when first built.
  ///
  /// When true, the button will receive focus when it is first built.
  /// This is useful for making the button the initial focus target in a form or dialog.
  final bool autofocus;

  /// Creates a naked button.
  ///
  /// The [child] parameter is required and represents the visual appearance
  /// of the button in all states.
  const NakedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onHoverState,
    this.onPressedState,
    this.onFocusState,
    this.onDisabledState,
    this.enabled = true,
    this.isSemanticButton = true,
    this.semanticLabel,
    this.cursor = SystemMouseCursors.click,
    this.enableHapticFeedback = true,
    this.focusNode,
    this.autofocus = false,
  });

  bool get _isEnabled => enabled && onPressed != null;

  @override
  State<NakedButton> createState() => _NakedButtonState();
}

class _NakedButtonState extends State<NakedButton> {
  late final Map<Type, Action<Intent>> _actionMap = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: handleTap),
    ButtonActivateIntent:
        CallbackAction<ButtonActivateIntent>(onInvoke: handleTap),
  };

  void handleTap([Intent? intent]) {
    if (!widget._isEnabled) return;
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    widget.onPressed?.call();
  }

  @override
  void didUpdateWidget(NakedButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._isEnabled != widget._isEnabled) {
      widget.onDisabledState?.call(!widget._isEnabled);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDisabledState?.call(!widget._isEnabled);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      enabled: widget._isEnabled,
      container: true,
      button: widget.isSemanticButton,
      excludeSemantics: true,
      child: FocusableActionDetector(
        actions: _actionMap,
        onFocusChange: widget.onFocusState,
        focusNode: widget.focusNode,
        enabled: widget._isEnabled,
        autofocus: widget.autofocus,
        onShowHoverHighlight: widget.onHoverState,
        mouseCursor:
            widget._isEnabled ? widget.cursor : SystemMouseCursors.forbidden,
        child: PressedStateRegion(
          enabled: widget._isEnabled,
          onPressedState: widget.onPressedState,
          onTap: handleTap,
          child: widget.child,
        ),
      ),
    );
  }
}
