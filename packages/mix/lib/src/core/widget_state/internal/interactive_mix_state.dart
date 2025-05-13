import 'package:flutter/material.dart';

import '../widget_state_controller.dart';

class InteractiveMixStateWidget extends StatefulWidget {
  const InteractiveMixStateWidget({
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
  State createState() => _InteractiveStateBuilderState();
}

class _InteractiveStateBuilderState extends State<InteractiveMixStateWidget> {
  late final WidgetStatesController _controller;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? WidgetStatesController();

    _controller.disabled = !widget.enabled;
  }

  void _onShowFocusHighlight(bool hasFocus) {
    _controller.focused = hasFocus;
    widget.onShowFocusHighlight?.call(hasFocus);
  }

  void _onShowHoverHighlight(bool isHovered) {
    _controller.hovered = isHovered;
    widget.onShowHoverHighlight?.call(isHovered);
  }

  @override
  void dispose() {
    // Only dispose if its being managed internally
    if (widget.controller == null) _controller.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(InteractiveMixStateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      _controller.disabled = !widget.enabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      shortcuts: widget.shortcuts,
      actions: widget.actions,
      onShowFocusHighlight: _onShowFocusHighlight,
      onShowHoverHighlight: _onShowHoverHighlight,
      onFocusChange: widget.onFocusChange,
      mouseCursor: widget.mouseCursor,
      includeFocusSemantics: false,
      child: widget.child,
    );
  }
}
