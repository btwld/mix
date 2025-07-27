import 'dart:async';

import 'package:flutter/widgets.dart';

import '../core/widget_state/internal/mix_hoverable_region.dart';
import '../core/widget_state/widget_state_provider.dart';
import '../core/internal/constants.dart';
import '../specs/box/box_attribute.dart';
import '../specs/box/box_widget.dart';

// It expects Style? but Box requires StyleAttribute<BoxSpec>
// Need to redesign how Style interacts with typed widgets

/// A pressable widget that wraps content in a [Box] with gesture handling.
///
/// Provides press, long press, and focus interactions with customizable styling.
class PressableBox extends StatelessWidget {
  const PressableBox({
    super.key,
    this.style,
    this.onLongPress,
    this.focusNode,
    required this.child,
    this.autofocus = false,
    this.enableFeedback = false,
    this.unpressDelay = kDefaultAnimationDuration,
    this.onFocusChange,
    this.onPress,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.enabled = true,
  });

  /// Should gestures provide audible and/or haptic feedback
  ///
  /// On platforms like Android, enabling feedback will result in audible and tactile
  /// responses to certain actions. For example, a tap may produce a clicking sound,
  /// while a long-press may trigger a short vibration.
  final bool enableFeedback;

  /// The callback that is called when the box is tapped or otherwise activated.
  ///
  /// If this callback and [onLongPress] are null, then it will be disabled automatically.
  final VoidCallback? onPress;

  /// The callback that is called when long-pressed.
  ///
  /// If this callback and [onPress] are null, then `PressableBox` will be disabled automatically.
  final VoidCallback? onLongPress;

  final BoxSpecAttribute? style;
  final Widget child;
  final bool enabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final Duration unpressDelay;
  final Function(bool focus)? onFocusChange;

  final HitTestBehavior hitTestBehavior;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      enabled: enabled,
      onPress: onPress,
      hitTestBehavior: hitTestBehavior,
      onLongPress: onLongPress,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      focusNode: focusNode,
      unpressDelay: unpressDelay,
      child: Box(style: style, child: child),
    );
  }
}

/// A widget that handles press gestures and provides visual feedback.
///
/// Supports press detection, hover states, and focus management with
/// configurable hit test behavior and feedback options.
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
    this.onKey,
    this.canRequestFocus = true,
    this.excludeFromSemantics = false,
    this.semanticButtonLabel,
    this.onKeyEvent,
    this.unpressDelay = kDefaultAnimationDuration,
    this.controller,
    this.actions,
    required this.child,
  });

  final Widget child;

  final bool enabled;

  final MouseCursor? mouseCursor;

  final String? semanticButtonLabel;

  final bool excludeFromSemantics;

  final bool canRequestFocus;

  /// Should gestures provide audible and/or haptic feedback
  ///
  /// On platforms like Android, enabling feedback will result in audible and tactile
  /// responses to certain actions. For example, a tap may produce a clicking sound,
  /// while a long-press may trigger a short vibration.
  final bool enableFeedback;

  /// The callback that is called when the box is tapped or otherwise activated.
  ///
  /// If this callback and [onLongPress] are null, then it will be disabled automatically.
  final VoidCallback? onPress;

  /// The callback that is called when long-pressed.
  ///
  /// If this callback and [onPress] are null, then `PressableBox` will be disabled automatically.
  final VoidCallback? onLongPress;

  /// Called when the focus state of the [Focus] changes.
  ///
  /// Called with true when the [Focus] node gains focus
  /// and false when the [Focus] node loses focus.
  final ValueChanged<bool>? onFocusChange;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.onKey}
  final FocusOnKeyEventCallback? onKey;

  /// {@macro flutter.widgets.Focus.onKeyEvent}
  final FocusOnKeyEventCallback? onKeyEvent;

  /// {@macro flutter.widgets.GestureDetector.hitTestBehavior}
  final HitTestBehavior hitTestBehavior;

  /// Actions to be bound to the widget
  final Map<Type, Action<Intent>>? actions;

  final WidgetStatesController? controller;

  /// The duration to wait after the press is released before the state of pressed is removed
  final Duration unpressDelay;

  @override
  State createState() => PressableWidgetState();
}

@visibleForTesting
class PressableWidgetState extends State<Pressable> {
  late final WidgetStatesController _controller;
  int _pressCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? WidgetStatesController();
  }

  void _handlePress(bool value) {
    _controller.pressed = value;
    if (value) {
      _pressCount++;
      final initialPressCount = _pressCount;
      _unpressAfterDelay(initialPressCount);
    }
  }

  void _unpressAfterDelay(int initialPressCount) {
    void unpressCallback() {
      if (_controller.has(WidgetState.pressed) &&
          _pressCount == initialPressCount) {
        _controller.pressed = false;
      }
    }

    _timer?.cancel();

    final delay = widget.unpressDelay;

    if (delay != Duration.zero) {
      _timer = Timer(delay, unpressCallback);
    } else {
      unpressCallback();
    }
  }

  void _onTap() {
    _handlePress(true);
    widget.onPress?.call();
    if (widget.enableFeedback) Feedback.forTap(context);
  }

  void _onLongPress() {
    widget.onLongPress?.call();
    if (widget.enableFeedback) Feedback.forLongPress(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
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

  /// Binds the [ActivateIntent] from the Flutter SDK to the onPressed callback by default.
  /// This enables SPACE and ENTER key activation on most platforms.
  /// Additional actions can be provided externally to extend functionality.
  Map<Type, Action<Intent>> get actions {
    return {
      ActivateIntent: CallbackAction<Intent>(
        onInvoke: (_) => widget.onPress?.call(),
      ),
      ...?widget.actions,
    };
  }

  @override
  Widget build(BuildContext context) {
    Widget current = GestureDetector(
      onTap: widget.enabled && widget.onPress != null ? _onTap : null,
      onLongPress: widget.enabled && widget.onLongPress != null
          ? _onLongPress
          : null,
      behavior: widget.hitTestBehavior,
      excludeFromSemantics: widget.excludeFromSemantics,
      child: MouseRegion(
        cursor: mouseCursor,
        child: Actions(
          actions: actions,
          child: Focus(
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            onFocusChange: (hasFocus) {
              if (widget.enabled) {
                setState(() {
                  _controller.focused = hasFocus;
                });
              }
              widget.onFocusChange?.call(hasFocus);
            },
            onKeyEvent: widget.onKeyEvent ?? widget.onKey,
            canRequestFocus: widget.canRequestFocus && widget.enabled,
            child: MixHoverableRegion(
              controller: _controller,
              enabled: widget.enabled,
              child: widget.child,
            ),
          ),
        ),
      ),
    );

    if (!widget.excludeFromSemantics) {
      current = Semantics(
        button: true,
        label: widget.semanticButtonLabel,
        onTap: widget.onPress,
        child: current,
      );
    }

    return current;
  }
}
