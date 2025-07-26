import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../cursor_position_provider.dart';
import '../widget_state_provider.dart';

/// A widget that provides hover state and automatic mouse position tracking.
///
/// This widget wraps its child with a MouseRegion to track hover state
/// and automatically tracks mouse position when widgets are listening for it.
class MixHoverableRegion extends StatefulWidget {
  const MixHoverableRegion({
    super.key,
    required this.child,
    this.controller,
    this.enabled = true,
    this.onHoverChange,
  });

  final Widget child;
  final WidgetStatesController? controller;
  final bool enabled;
  final ValueChanged<bool>? onHoverChange;

  @override
  State<MixHoverableRegion> createState() => _MixHoverableRegionState();
}

class _MixHoverableRegionState extends State<MixHoverableRegion> {
  late final WidgetStatesController _controller;
  late final CursorPositionNotifier _cursorPositionNotifier;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? WidgetStatesController();
    _controller.disabled = !widget.enabled;
    _cursorPositionNotifier = CursorPositionNotifier();
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
    });
    _cursorPositionNotifier.clearPosition();
    widget.onHoverChange?.call(false);
  }

  void _handleMouseMove(PointerHoverEvent event) {
    if (!widget.enabled) return;

    // Only update position if there are listeners
    if (!_cursorPositionNotifier.shouldTrack) return;

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

      _cursorPositionNotifier.updatePosition(alignment, localPosition);
    }
  }

  @override
  void didUpdateWidget(MixHoverableRegion oldWidget) {
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
    _cursorPositionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MouseRegion for hover tracking - no rebuilds on mouse events
    return MouseRegion(
      onEnter: _handleHoverEnter,
      onExit: _handleHoverExit,
      onHover: _handleMouseMove,
      opaque: false,
      child: CursorPositionProvider(
        notifier: _cursorPositionNotifier,
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return WidgetStateScope(
              states: _controller.value,
              child: widget.child,
            );
          },
        ),
      ),
    );
  }
}
