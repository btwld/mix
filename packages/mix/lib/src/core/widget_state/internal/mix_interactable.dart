import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widget_state_provider.dart';

class MixInteractable extends StatefulWidget {
  const MixInteractable({
    super.key,
    required this.child,
    this.controller,
    this.enabled = true,
    this.onFocusChange,
    this.onHoverChange,
    this.trackMousePosition = false,
  });

  final Widget child;
  final WidgetStatesController? controller;
  final bool enabled;
  final ValueChanged<bool>? onFocusChange;
  final ValueChanged<bool>? onHoverChange;
  final bool trackMousePosition;

  @override
  State<MixInteractable> createState() => _MixInteractableState();
}

class _MixInteractableState extends State<MixInteractable> {
  late final WidgetStatesController _controller;
  late final ValueNotifier<PointerPosition?> _pointerPositionNotifier;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? WidgetStatesController();
    _controller.disabled = !widget.enabled;
    _pointerPositionNotifier = ValueNotifier<PointerPosition?>(null);
  }

  void _handleFocusChange(bool hasFocus) {
    if (!widget.enabled) return;
    setState(() {
      _controller.focused = hasFocus;
    });
    widget.onFocusChange?.call(hasFocus);
  }

  void _handleHoverEnter(PointerEnterEvent event) {
    if (!widget.enabled) return;
    setState(() {
      _controller.hovered = true;
    });
    widget.onHoverChange?.call(true);
  }

  void _handleHoverExit(PointerExitEvent event) {
    if (!widget.enabled) return;
    setState(() {
      _controller.hovered = false;
      _pointerPositionNotifier.value = null;
    });
    widget.onHoverChange?.call(false);
  }

  void _handleMouseMove(PointerHoverEvent event) {
    if (!widget.enabled || !widget.trackMousePosition) return;

    // Only update position, no setState - avoids rebuilds
    final box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      final size = box.size;
      final localPosition = event.localPosition;

      // Calculate normalized alignment
      final ax = localPosition.dx / size.width;
      final ay = localPosition.dy / size.height;
      final alignment = Alignment(
        ((ax - 0.5) * 2).clamp(-1.0, 1.0),
        ((ay - 0.5) * 2).clamp(-1.0, 1.0),
      );

      _pointerPositionNotifier.value = PointerPosition(
        position: alignment,
        offset: localPosition,
      );
    }
  }

  @override
  void didUpdateWidget(MixInteractable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      _controller.disabled = !widget.enabled;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _pointerPositionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MouseRegion at the top - no rebuilds on mouse events
    return MouseRegion(
      // Allows events to pass through
      onEnter: _handleHoverEnter,
      onExit: _handleHoverExit,
      onHover: widget.trackMousePosition ? _handleMouseMove : null,
      opaque: false,
      child: Focus(
        onFocusChange: _handleFocusChange,
        canRequestFocus: widget.enabled,
        skipTraversal: !widget.enabled,
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return WidgetStateScope(
              states: _controller.value,
              cursorPosition: _pointerPositionNotifier.value,
              child: widget.child,
            );
          },
        ),
      ),
    );
  }
}
