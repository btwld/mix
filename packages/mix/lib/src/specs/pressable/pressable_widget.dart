import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../core/internal/mix_interaction_detector.dart';
import '../../core/providers/widget_state_provider.dart';
import '../box/box_spec.dart';
import '../box/box_widget.dart';

/// The accessibility role exposed by a [Pressable].
enum PressableSemanticsRole {
  /// Exposes the control as a button.
  button,

  /// Exposes the control as a link.
  ///
  /// Activates with Enter but not Space, matching platform link convention.
  link,

  /// Adds no button or link role while preserving other semantics.
  none,
}

/// Combines [Box] styling with gesture handling.
///
/// Provides press, long press, and focus interactions.
class PressableBox extends StatelessWidget {
  const PressableBox({
    super.key,
    this.style,
    this.onLongPress,
    this.focusNode,
    required this.child,
    this.autofocus = false,
    this.enableFeedback = false,
    this.onFocusChange,
    this.onPress,
    this.mouseCursor,
    this.canRequestFocus = true,
    this.excludeFromSemantics = false,
    this.semanticsLabel,
    this.semanticsRole = PressableSemanticsRole.button,
    this.onKeyEvent,
    this.controller,
    this.actions,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.enabled = true,
  });

  /// Enables audible/haptic feedback for gestures.
  final bool enableFeedback;

  /// Called when the box is pressed.
  final VoidCallback? onPress;

  /// Called when the box is long-pressed.
  final VoidCallback? onLongPress;

  final BoxStyler? style;
  final Widget child;
  final bool enabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final ValueChanged<bool>? onFocusChange;

  final MouseCursor? mouseCursor;
  final bool canRequestFocus;
  final bool excludeFromSemantics;
  final String? semanticsLabel;
  final PressableSemanticsRole semanticsRole;

  /// Handles key events before built-in activation while enabled.
  final FocusOnKeyEventCallback? onKeyEvent;
  final WidgetStatesController? controller;
  final Map<Type, Action<Intent>>? actions;

  final HitTestBehavior hitTestBehavior;

  @override
  Widget build(BuildContext context) {
    final style = this.style;

    return Pressable(
      enabled: enabled,
      enableFeedback: enableFeedback,
      onPress: onPress,
      hitTestBehavior: hitTestBehavior,
      onLongPress: onLongPress,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      focusNode: focusNode,
      mouseCursor: mouseCursor,
      canRequestFocus: canRequestFocus,
      excludeFromSemantics: excludeFromSemantics,
      semanticsLabel: semanticsLabel,
      semanticsRole: semanticsRole,
      onKeyEvent: onKeyEvent,
      controller: controller,
      actions: actions,
      child: style == null
          ? Box(child: child)
          : Box(style: style, child: child),
    );
  }
}

/// Base widget for handling press gestures and states.
///
/// Manages press, hover, and focus states with configurable behavior.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    this.enabled = true,
    this.enableFeedback = false,
    this.onPress,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.onLongPress,
    this.onFocusChange,
    this.autofocus = false,
    this.focusNode,
    this.mouseCursor,
    this.canRequestFocus = true,
    this.excludeFromSemantics = false,
    this.semanticsLabel,
    this.semanticsRole = PressableSemanticsRole.button,
    this.onKeyEvent,
    this.controller,
    this.actions,
    required this.child,
  });

  final Widget child;

  final bool enabled;

  final MouseCursor? mouseCursor;

  final String? semanticsLabel;

  final PressableSemanticsRole semanticsRole;

  final bool excludeFromSemantics;

  final bool canRequestFocus;

  /// Enables audible/haptic feedback for gestures.
  final bool enableFeedback;

  /// Called when the box is pressed.
  final VoidCallback? onPress;

  /// Called when the box is long-pressed.
  final VoidCallback? onLongPress;

  /// Called when focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// Handles key events before built-in activation while [enabled].
  final FocusOnKeyEventCallback? onKeyEvent;

  /// {@macro flutter.widgets.GestureDetector.hitTestBehavior}
  final HitTestBehavior hitTestBehavior;

  /// Custom actions bound to the widget.
  final Map<Type, Action<Intent>>? actions;

  final WidgetStatesController? controller;

  @override
  State<Pressable> createState() => PressableWidgetState();
}

final class _PressableActivateAction extends CallbackAction<Intent> {
  final bool Function() _isEnabled;

  _PressableActivateAction({
    required bool Function() isEnabled,
    required super.onInvoke,
  }) : _isEnabled = isEnabled;

  @override
  bool isEnabled(Intent intent) => _isEnabled();
}

@visibleForTesting
class PressableWidgetState extends State<Pressable> {
  late WidgetStatesController _controller;
  late bool _ownsController;
  LogicalKeyboardKey? _heldActivationKey;
  bool _hovered = false;
  bool _focused = false;
  bool _pointerPressed = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController([Set<WidgetState>? initialStates]) {
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? WidgetStatesController(initialStates);
  }

  void _onTap() {
    if (!widget.enabled || widget.onPress == null) return;

    widget.onPress!();
    if (widget.enableFeedback) Feedback.forTap(context);
  }

  void _onLongPress() {
    if (!widget.enabled || widget.onLongPress == null) return;

    widget.onLongPress!();
    if (widget.enableFeedback) Feedback.forLongPress(context);
  }

  void _onFocusChange(bool hasFocus) {
    if (!hasFocus) _cancelHeldActivation();
    _focused = hasFocus;
    _controller.focused = hasFocus;
    widget.onFocusChange?.call(hasFocus);
  }

  void _onHoverChange(bool isHovered) {
    _hovered = isHovered;
  }

  /// Keys Pressable supports for direct keyboard/game-controller activation.
  bool _isActivationKey(LogicalKeyboardKey key) {
    // Links follow platform convention: Enter activates, Space scrolls.
    if (widget.semanticsRole == .link && key == .space) return false;

    return key == .space ||
        key == .enter ||
        key == .numpadEnter ||
        key == .select ||
        key == .gameButtonA;
  }

  bool get _hasActivationModifier {
    final keyboard = HardwareKeyboard.instance;

    return keyboard.isAltPressed ||
        keyboard.isControlPressed ||
        keyboard.isMetaPressed ||
        keyboard.isShiftPressed;
  }

  void _syncPressedState() {
    _controller.pressed = _pointerPressed || _heldActivationKey != null;
  }

  void _syncInteractionStates() {
    _controller.hovered = _hovered;
    _controller.focused = _focused;
    _syncPressedState();
  }

  void _onPointerPressChange(bool isPressed) {
    _pointerPressed = isPressed;
    _syncPressedState();
  }

  /// Releases a held keyboard activation.
  ///
  /// Guarded so keyboard bookkeeping never clears a pointer-owned press, which
  /// [MixInteractionDetector] owns.
  void _cancelHeldActivation() {
    if (_heldActivationKey == null) return;

    _heldActivationKey = null;
    _syncPressedState();
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (!widget.enabled) {
      _cancelHeldActivation();

      return .ignored;
    }

    final customResult = widget.onKeyEvent?.call(node, event) ?? .ignored;

    if (customResult != .ignored) {
      if (event is KeyUpEvent && event.logicalKey == _heldActivationKey) {
        _cancelHeldActivation();
      }

      return customResult;
    }

    if (!_isActivationKey(event.logicalKey)) {
      return .ignored;
    }

    // [FocusNode.hasFocus] is also true while a descendant holds primary focus,
    // so only the focused Pressable itself may claim activation keys. Claiming
    // them any wider would swallow Space and Enter before a nested text field
    // (or app shortcuts) ever sees them.
    if (!node.hasPrimaryFocus || widget.onPress == null) {
      _cancelHeldActivation();

      return .ignored;
    }

    // A focused Pressable owns activation keys while it can activate, so a
    // second activation key pressed during a hold is absorbed rather than
    // starting a competing activation.
    if (event is KeyDownEvent) {
      if (_heldActivationKey == null) {
        // Leave modified key chords to application shortcuts.
        if (_hasActivationModifier) return .ignored;

        _heldActivationKey = event.logicalKey;
        _syncPressedState();
      }

      return .handled;
    }

    // Keep all events from a competing activation key contained while the
    // original key is held. Otherwise its repeat can escape to an ancestor
    // shortcut even though its key-down was handled here.
    if (event.logicalKey != _heldActivationKey) {
      return _heldActivationKey == null ? .ignored : .handled;
    }

    if (event is KeyUpEvent) {
      _cancelHeldActivation();
      _onTap();
    }

    return .handled;
  }

  bool get hasOnPress => widget.onPress != null;

  MouseCursor get mouseCursor {
    if (widget.mouseCursor != null) {
      return widget.mouseCursor!;
    }

    if (!widget.enabled) {
      return SystemMouseCursors.forbidden;
    }

    return hasOnPress ? SystemMouseCursors.click : MouseCursor.defer;
  }

  @override
  void didUpdateWidget(Pressable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      final oldController = _controller;
      final ownedOldController = _ownsController;
      // A held key belongs to the outgoing controller and never survives a
      // controller swap.
      _heldActivationKey = null;
      // Live pointer, hover, and focus sources do survive. Remove their values
      // from the outgoing controller before publishing them to the new one.
      oldController
        ..hovered = false
        ..focused = false
        ..pressed = false;
      _initController(
        widget.controller == null ? {...oldController.value} : null,
      );
      _syncInteractionStates();
      if (ownedOldController) oldController.dispose();
    }

    final heldKey = _heldActivationKey;
    if (!widget.enabled ||
        widget.onPress == null ||
        (heldKey != null && !_isActivationKey(heldKey))) {
      _cancelHeldActivation();
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    } else {
      // Detaching must not leave phantom interaction states on a controller
      // the caller keeps using.
      _controller
        ..hovered = false
        ..focused = false
        ..pressed = false;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget focusable = Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onFocusChange: _onFocusChange,
      onKeyEvent: _onKeyEvent,
      canRequestFocus: widget.canRequestFocus && widget.enabled,
      includeSemantics: !widget.excludeFromSemantics,
      child: MixInteractionDetector(
        controller: _controller,
        enabled: widget.enabled,
        onHoverChange: _onHoverChange,
        onPressChange: _onPointerPressChange,
        managesPressedState: false,
        child: widget.child,
      ),
    );

    // Keep the subtree shape stable when enabled changes while withholding
    // custom actions from disabled controls.
    focusable = Actions(
      actions: widget.enabled
          ? {
              // Reserved keys are claimed raw before Shortcuts, so this binding
              // only fires for remapped shortcuts and programmatic intents.
              ActivateIntent: _PressableActivateAction(
                // Flutter maps Space to ActivateIntent by default, so this
                // binding reports disabled whenever activation cannot happen —
                // no onPress, or link-role Space — and the key stays unhandled
                // for scrolling and other fallback handlers.
                isEnabled: () =>
                    widget.onPress != null &&
                    (widget.semanticsRole != .link ||
                        !HardwareKeyboard.instance.logicalKeysPressed.contains(
                          LogicalKeyboardKey.space,
                        )),
                onInvoke: (_) => _onTap(),
              ),
              ...?widget.actions,
            }
          : const {},
      child: focusable,
    );

    Widget current = GestureDetector(
      onTap: widget.enabled && widget.onPress != null ? _onTap : null,
      onLongPress: widget.enabled && widget.onLongPress != null
          ? _onLongPress
          : null,
      behavior: widget.hitTestBehavior,
      excludeFromSemantics: true,
      child: MouseRegion(cursor: mouseCursor, child: focusable),
    );

    if (!widget.excludeFromSemantics) {
      // Only claim an enabled/disabled state for something that can be
      // disabled: a role, or an activation callback. A bare `none` wrapper is
      // not a control, so it should not be announced as one.
      final hasEnabledState =
          widget.semanticsRole != .none ||
          widget.onPress != null ||
          widget.onLongPress != null;

      current = Semantics(
        container: hasEnabledState || widget.semanticsLabel != null,
        enabled: hasEnabledState ? widget.enabled : null,
        button: widget.semanticsRole == .button ? true : null,
        link: widget.semanticsRole == .link ? true : null,
        label: widget.semanticsLabel,
        onTap: widget.enabled && widget.onPress != null ? _onTap : null,
        onLongPress: widget.enabled && widget.onLongPress != null
            ? _onLongPress
            : null,
        child: current,
      );
    }

    return current;
  }
}
