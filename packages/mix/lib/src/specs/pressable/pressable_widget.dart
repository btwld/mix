import 'package:flutter/widgets.dart';

import '../../core/internal/mix_interaction_detector.dart';
import '../../core/providers/widget_state_provider.dart';
import '../box/box_style.dart';
import '../box/box_widget.dart';

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
      child: Box(style: style ?? const BoxStyler.create(), child: child),
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
    this.onKey,
    this.canRequestFocus = true,
    this.excludeFromSemantics = false,
    this.semanticButtonLabel,
    this.onKeyEvent,
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

  /// {@macro flutter.widgets.Focus.onKey}
  final FocusOnKeyEventCallback? onKey;

  /// {@macro flutter.widgets.Focus.onKeyEvent}
  final FocusOnKeyEventCallback? onKeyEvent;

  /// {@macro flutter.widgets.GestureDetector.hitTestBehavior}
  final HitTestBehavior hitTestBehavior;

  /// Custom actions bound to the widget.
  final Map<Type, Action<Intent>>? actions;

  final WidgetStatesController? controller;

  @override
  State createState() => PressableWidgetState();
}

@visibleForTesting
class PressableWidgetState extends State<Pressable> {
  late WidgetStatesController _controller;

  /// Tracks whether we created the controller internally (and thus own it)
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = WidgetStatesController();
      _ownsController = true;
    }
  }

  @override
  void didUpdateWidget(covariant Pressable oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle controller changes
    if (oldWidget.controller != widget.controller) {
      _handleControllerChange(oldWidget);
    }
  }

  void _handleControllerChange(Pressable oldWidget) {
    // Dispose old internal controller if we owned it
    if (_ownsController) {
      _controller.dispose();
    }

    // Set up new controller
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      // Create internal controller, preserving state from old external controller
      _controller = WidgetStatesController(oldWidget.controller?.value ?? {});
      _ownsController = true;
    }
  }

  void _onTap() {
    widget.onPress?.call();
    if (widget.enableFeedback) Feedback.forTap(context);
  }

  void _onTapUp() => _controller.pressed = false;

  void _onTapDown() => _controller.pressed = true;

  void _onLongPress() {
    widget.onLongPress?.call();
    if (widget.enableFeedback) Feedback.forLongPress(context);
  }

  void _onFocusChange(bool hasFocus) {
    _controller.focused = hasFocus;
    widget.onFocusChange?.call(hasFocus);
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

  /// Binds [ActivateIntent] for keyboard activation (SPACE/ENTER).
  Map<Type, Action<Intent>> get actions {
    return {
      ActivateIntent: CallbackAction<Intent>(
        onInvoke: (_) => widget.onPress?.call(),
      ),
      ...?widget.actions,
    };
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget gestureChild = Actions(
      actions: actions,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onFocusChange: _onFocusChange,
        onKeyEvent: widget.onKeyEvent ?? widget.onKey,
        canRequestFocus: widget.canRequestFocus && widget.enabled,
        child: MixInteractionDetector(
          controller: _controller,
          enabled: widget.enabled,
          child: widget.child,
        ),
      ),
    );

    Widget current = GestureDetector(
      onTapDown: widget.enabled ? (_) => _onTapDown() : null,
      onTapUp: widget.enabled ? (_) => _onTapUp() : null,
      onTap: widget.enabled && widget.onPress != null ? _onTap : null,
      onTapCancel: widget.enabled ? () => _onTapUp() : null,
      onLongPress: widget.enabled && widget.onLongPress != null
          ? _onLongPress
          : null,
      behavior: widget.hitTestBehavior,
      excludeFromSemantics: widget.excludeFromSemantics,
      child: MouseRegion(
        cursor: mouseCursor,
        child: gestureChild,
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
