import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widget_state_provider.dart';

/// A widget that provides hover state and mouse position tracking.
///
/// This widget wraps its child with a MouseRegion to track hover state
/// and optionally track the mouse position relative to the widget bounds.
class MixHoverableRegion extends StatefulWidget {
  const MixHoverableRegion({
    super.key,
    required this.child,
    this.controller,
    this.enabled = true,
    this.onHoverChange,
    this.trackMousePosition = false,
  });

  final Widget child;
  final WidgetStatesController? controller;
  final bool enabled;
  final ValueChanged<bool>? onHoverChange;
  final bool trackMousePosition;

  @override
  State<MixHoverableRegion> createState() => _MixHoverableRegionState();
}

class _MixHoverableRegionState extends State<MixHoverableRegion> {
  late final WidgetStatesController _controller;
  late final ValueNotifier<PointerPosition?> _pointerPositionNotifier;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? WidgetStatesController();
    _controller.disabled = !widget.enabled;
    _pointerPositionNotifier = ValueNotifier<PointerPosition?>(null);
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
    _pointerPositionNotifier.value = null;
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
    _pointerPositionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MouseRegion for hover tracking - no rebuilds on mouse events
    return MouseRegion(
      onEnter: _handleHoverEnter,
      onExit: _handleHoverExit,
      onHover: widget.trackMousePosition ? _handleMouseMove : null,
      opaque: false,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return WidgetStateScope(
            states: _controller.value,
            pointerPosition: _pointerPositionNotifier.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}
