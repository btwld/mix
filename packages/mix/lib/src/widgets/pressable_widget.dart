import 'package:flutter/material.dart';

import '../core/factory/style_mix.dart';
import '../core/widget_state/internal/gesture_mix_state.dart';
import '../core/widget_state/internal/interactive_mix_state.dart';
import '../core/widget_state/internal/mix_widget_state_builder.dart';
import '../core/widget_state/internal/mouse_region_mix_state.dart';
import '../core/widget_state/widget_state_controller.dart';
import '../internal/constants.dart';
import '../specs/box/box_widget.dart';

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

  final Style? style;
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

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? WidgetStatesController();
  }

  @override
  void dispose() {
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
      ActivateIntent:
          CallbackAction<Intent>(onInvoke: (_) => widget.onPress?.call()),
      ...?widget.actions,
    };
  }

  @override
  Widget build(BuildContext context) {
    Widget current = GestureMixStateWidget(
      enableFeedback: widget.enableFeedback,
      controller: _controller,
      onTap: widget.enabled ? widget.onPress?.call : null,
      onLongPress: widget.enabled ? widget.onLongPress?.call : null,
      excludeFromSemantics: widget.excludeFromSemantics,
      hitTestBehavior: widget.hitTestBehavior,
      unpressDelay: widget.unpressDelay,
      child: InteractiveMixStateWidget(
        enabled: widget.enabled,
        onFocusChange: widget.onFocusChange,
        autofocus: widget.autofocus,
        focusNode: widget.focusNode,
        onKey: widget.onKey,
        onKeyEvent: widget.onKeyEvent,
        canRequestFocus: widget.canRequestFocus,
        mouseCursor: mouseCursor,
        controller: _controller,
        actions: actions,
        child: MouseRegionMixStateWidget(
          child: MixWidgetStateBuilder(
            controller: _controller,
            builder: (_) => widget.child,
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

class Interactable extends StatefulWidget {
  const Interactable({
    super.key,
    required this.child,
    this.enabled = true,
    this.onFocusChange,
    this.autofocus = false,
    this.focusNode,
    this.onKey,
    this.onShowFocusHighlight,
    this.onShowHoverHighlight,
    this.onKeyEvent,
    this.canRequestFocus = true,
    this.mouseCursor = MouseCursor.defer,
    this.shortcuts,
    this.controller,
    this.actions,
  });

  final bool enabled;
  final MouseCursor mouseCursor;

  final WidgetStatesController? controller;

  final bool canRequestFocus;

  final Widget child;
  final Function(bool focus)? onShowFocusHighlight;
  final Function(bool hover)? onShowHoverHighlight;

  final ValueChanged<bool>? onFocusChange;

  final Map<ShortcutActivator, Intent>? shortcuts;

  final bool autofocus;

  final FocusNode? focusNode;

  final FocusOnKeyEventCallback? onKey;

  final FocusOnKeyEventCallback? onKeyEvent;

  final Map<Type, Action<Intent>>? actions;

  @override
  State<Interactable> createState() => _InteractableState();
}

class _InteractableState extends State<Interactable> {
  late final WidgetStatesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? WidgetStatesController();

    _controller.disabled = !widget.enabled;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveMixStateWidget(
      enabled: widget.enabled,
      onFocusChange: widget.onFocusChange,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      onKey: widget.onKey,
      onShowFocusHighlight: widget.onShowFocusHighlight,
      onShowHoverHighlight: widget.onShowHoverHighlight,
      onKeyEvent: widget.onKeyEvent,
      canRequestFocus: widget.canRequestFocus,
      mouseCursor: widget.mouseCursor,
      shortcuts: widget.shortcuts,
      controller: _controller,
      actions: widget.actions,
      child: MouseRegionMixStateWidget(
        child: MixWidgetStateBuilder(
          controller: _controller,
          builder: (context) => widget.child,
        ),
      ),
    );
  }
}
