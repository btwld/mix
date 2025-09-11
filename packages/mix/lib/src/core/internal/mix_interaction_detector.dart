import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../pointer_position.dart';
import '../providers/widget_state_provider.dart';

/// A widget that detects user interactions and provides state tracking with automatic mouse position tracking.
///
/// This widget wraps its child with a MouseRegion and Listener to track hover, press states
/// and automatically tracks mouse position when widgets are listening for it.
///
/// This widget respects [enabled]: when false it sets [WidgetState.disabled],
/// gates interactions, and clears transient hover/press states. When true, it tracks these.
@internal
class MixInteractionDetector extends StatefulWidget {
  const MixInteractionDetector({
    super.key,
    required this.child,
    this.controller,
    this.enabled = true,
    this.onHoverChange,
    this.onPointerPositionChange,
  });

  final Widget child;
  final WidgetStatesController? controller;
  final bool enabled;
  final ValueChanged<bool>? onHoverChange;
  final ValueChanged<PointerPosition>? onPointerPositionChange;

  @override
  State<MixInteractionDetector> createState() => _MixInteractionDetectorState();
}

class _MixInteractionDetectorState extends State<MixInteractionDetector> {
  WidgetStatesController? _internalController;
  late final PointerPositionNotifier _cursorPositionNotifier;

  @override
  void initState() {
    super.initState();
    _cursorPositionNotifier = PointerPositionNotifier();
    _syncDisabledState();
  }

  /// Creates an internal controller with initial disabled state if needed.
  WidgetStatesController _createInternalController() {
    return WidgetStatesController({if (!widget.enabled) WidgetState.disabled});
  }

  /// Syncs disabled state and clears transients when disabling.
  void _syncDisabledState() {
    _effectiveController.update(WidgetState.disabled, !widget.enabled);
    if (!widget.enabled) {
      _effectiveController.update(WidgetState.hovered, false);
      _effectiveController.update(WidgetState.pressed, false);
      _cursorPositionNotifier.clearPosition();
      widget.onHoverChange?.call(false);
    }
  }

  /// Handles state controller changes between external and internal.
  void _handleControllerChange(MixInteractionDetector oldWidget) {
    if (widget.controller == null) {
      _internalController ??= WidgetStatesController(
        oldWidget.controller?.value ?? {},
      );
    } else {
      _internalController?.dispose();
      _internalController = null;
    }
  }

  /// Clears the pressed state and notifies listeners.
  void _clearPressedState() {
    if (!_effectiveController.value.contains(WidgetState.pressed)) return;
    _effectiveController.update(WidgetState.pressed, false);
  }

  /// Handles pointer entering the widget bounds.
  void _handlePointerEnter(PointerEnterEvent event) {
    if (!mounted) return;

    _effectiveController.update(WidgetState.hovered, true);
    widget.onHoverChange?.call(true);
  }

  /// Handles pointer exiting the widget bounds.
  void _handlePointerExit(PointerExitEvent event) {
    if (!mounted) return;

    _effectiveController.update(WidgetState.hovered, false);
    _cursorPositionNotifier.clearPosition();
    widget.onHoverChange?.call(false);

    // Clear pressed state if active (edge case handling)
    _clearPressedState();
  }

  /// Handles pointer down events for all pointer types.
  void _handlePointerDown(PointerDownEvent event) {
    if (!mounted) return;
    // Only treat primary mouse button as "pressed" for mouse; all other kinds count.
    if (event.kind == PointerDeviceKind.mouse &&
        (event.buttons & kPrimaryMouseButton) == 0) {
      return;
    }
    _effectiveController.update(WidgetState.pressed, true);
  }

  /// Handles pointer up events.
  void _handlePointerUp(PointerUpEvent event) {
    if (!mounted) return;
    _effectiveController.update(WidgetState.pressed, false);
  }

  /// Handles pointer cancel events.
  void _handlePointerCancel(PointerCancelEvent event) {
    if (!mounted) return;
    _effectiveController.update(WidgetState.pressed, false);
  }

  /// Handles pointer move events to track boundary crossings.
  void _handlePointerMove(PointerMoveEvent event) {
    if (!mounted) return;

    final size = context.size;
    if (size == null) return;

    final isInside = size.contains(event.localPosition);

    // Clear pressed state when moving outside
    if (!isInside) {
      _clearPressedState();
    }
  }

  /// Handles hover events for position tracking.
  void _handleOnPointerHover(PointerHoverEvent event) {
    if (!mounted) return;

    final shouldNotifyProvider = _cursorPositionNotifier.shouldTrack;
    // If neither provider listeners nor callback are present, skip work.
    if (!shouldNotifyProvider && widget.onPointerPositionChange == null) return;

    final size = context.size;
    if (size == null || size.width <= 0 || size.height <= 0) return;

    final localPosition = event.localPosition;

    // Calculate normalized alignment safely
    final ax = (localPosition.dx / size.width).clamp(0.0, 1.0);
    final ay = (localPosition.dy / size.height).clamp(0.0, 1.0);
    final alignment = Alignment(
      ((ax - 0.5) * 2).clamp(-1.0, 1.0),
      ((ay - 0.5) * 2).clamp(-1.0, 1.0),
    );

    if (shouldNotifyProvider) {
      _cursorPositionNotifier.updatePosition(alignment, localPosition);
    }
    widget.onPointerPositionChange?.call(
      PointerPosition(position: alignment, offset: localPosition),
    );
  }

  WidgetStatesController get _effectiveController =>
      widget.controller ??
      (_internalController ??= _createInternalController());

  @override
  void didUpdateWidget(MixInteractionDetector oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle controller changes
    if (oldWidget.controller != widget.controller) {
      _handleControllerChange(oldWidget);
      _syncDisabledState();
    }

    // Handle enabled state changes
    if (oldWidget.enabled != widget.enabled) {
      _syncDisabledState();
    }
  }

  @override
  void dispose() {
    _internalController?.dispose();
    _cursorPositionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build order: IgnorePointer -> MouseRegion -> Listener -> PointerPositionProvider -> ListenableBuilder -> WidgetStateProvider
    return IgnorePointer(
      ignoring: !widget.enabled,
      child: MouseRegion(
        onEnter: _handlePointerEnter,
        onExit: _handlePointerExit,
        onHover: _handleOnPointerHover,
        child: Listener(
          onPointerDown: _handlePointerDown,
          onPointerMove: _handlePointerMove,
          onPointerUp: _handlePointerUp,
          onPointerCancel: _handlePointerCancel,
          behavior: HitTestBehavior.opaque,
          child: PointerPositionProvider(
            notifier: _cursorPositionNotifier,
            child: ListenableBuilder(
              listenable: _effectiveController,
              builder: (context, _) {
                return WidgetStateProvider(
                  states: _effectiveController.value,
                  child: widget.child,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
