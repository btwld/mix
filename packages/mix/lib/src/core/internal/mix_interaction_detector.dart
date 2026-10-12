import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../pointer_position.dart';
import '../providers/focus_highlight_mode_provider.dart';
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
    this.onPressChange,
    this.managesPressedState = true,
    this.onPointerPositionChange,
  });

  /// The widget states this detector derives from pointer input.
  ///
  /// Deliberately excludes [WidgetState.disabled]: that one is driven by
  /// [enabled], which the caller sets, not by interaction. Every other
  /// [WidgetState] must come from an external controller or an ancestor
  /// [WidgetStateProvider], so installing this detector to satisfy them adds an
  /// opaque hit-test target for no behavioural gain. Callers deciding whether
  /// this detector is worth mounting should check against this set.
  static const Set<WidgetState> pointerDrivenStates = {
    WidgetState.hovered,
    WidgetState.pressed,
  };

  final Widget child;
  final WidgetStatesController? controller;
  final bool enabled;
  final ValueChanged<bool>? onHoverChange;
  final ValueChanged<bool>? onPressChange;

  /// Whether pointer input is written directly to [controller].
  ///
  /// Set this to false when the owner combines pointer presses with another
  /// input source before publishing [WidgetState.pressed].
  final bool managesPressedState;

  final ValueChanged<PointerPosition>? onPointerPositionChange;

  @override
  State<MixInteractionDetector> createState() => _MixInteractionDetectorState();
}

class _MixInteractionDetectorState extends State<MixInteractionDetector> {
  WidgetStatesController? _internalController;
  late final PointerPositionNotifier _cursorPositionNotifier;

  /// Global position of the pointer that owns the current pressed state.
  Offset? _pressOrigin;

  /// Pointer that owns the current pressed state.
  int? _pressPointer;

  /// Distance a pointer may drift before it stops counting as a press.
  ///
  /// Mirrors what [TapGestureRecognizer] uses, so the pressed state and the tap
  /// gesture give up on the same movement.
  double _touchSlop = kTouchSlop;

  @override
  void initState() {
    super.initState();
    _cursorPositionNotifier = PointerPositionNotifier();
    _syncDisabledState();
  }

  /// Creates an internal controller with initial disabled state if needed.
  WidgetStatesController _createInternalController() {
    return WidgetStatesController({if (!widget.enabled) .disabled});
  }

  /// Syncs disabled state and clears transients when disabling.
  void _syncDisabledState() {
    _effectiveController.update(.disabled, !widget.enabled);
    if (!widget.enabled) {
      _effectiveController.update(.hovered, false);
      _clearPressedState(force: true);
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

  /// Clears the pressed state if [pointer] owns it.
  void _clearPressedState({int? pointer, bool force = false}) {
    final pressPointer = _pressPointer;
    if (!force &&
        (pressPointer == null ||
            (pointer != null && pointer != pressPointer))) {
      return;
    }

    final hadPointerPress = pressPointer != null;
    _pressPointer = null;
    _pressOrigin = null;
    if (widget.managesPressedState) {
      _effectiveController.update(.pressed, false);
    }
    if (hadPointerPress) widget.onPressChange?.call(false);
  }

  /// Handles pointer entering the widget bounds.
  void _handlePointerEnter(PointerEnterEvent event) {
    if (!mounted) return;

    _effectiveController.update(.hovered, true);
    widget.onHoverChange?.call(true);
  }

  /// Handles pointer exiting the widget bounds.
  void _handlePointerExit(PointerExitEvent event) {
    if (!mounted) return;

    _effectiveController.update(.hovered, false);
    _cursorPositionNotifier.clearPosition();
    widget.onHoverChange?.call(false);

    // Clear pressed state if active (edge case handling)
    _clearPressedState(pointer: event.pointer);
  }

  /// Handles pointer down events for all pointer types.
  void _handlePointerDown(PointerDownEvent event) {
    if (!mounted) return;

    // Match GestureDetector's primary tap recognizer across device kinds.
    if (_pressPointer != null || event.buttons != kPrimaryButton) return;

    _pressPointer = event.pointer;
    _pressOrigin = event.position;
    if (widget.managesPressedState) {
      _effectiveController.update(.pressed, true);
    }
    widget.onPressChange?.call(true);
  }

  /// Handles pointer up events.
  void _handlePointerUp(PointerUpEvent event) {
    if (!mounted) return;
    _clearPressedState(pointer: event.pointer);
  }

  /// Handles pointer cancel events.
  void _handlePointerCancel(PointerCancelEvent event) {
    if (!mounted) return;
    _clearPressedState(pointer: event.pointer);
  }

  /// Handles pointer move events to track boundary crossings.
  void _handlePointerMove(PointerMoveEvent event) {
    if (!mounted) return;

    if (event.pointer != _pressPointer) return;

    // A pointer that drifts past the tap slop has become a drag or a scroll,
    // so it no longer owns a press. This [Listener] sees raw pointer events
    // rather than arena outcomes, and a scrolled widget travels with the
    // pointer, so bounds alone never notice.
    final pressOrigin = _pressOrigin;
    if (pressOrigin != null &&
        (event.position - pressOrigin).distance > _touchSlop) {
      _clearPressedState(pointer: event.pointer);

      return;
    }

    final size = context.size;
    if (size == null) return;

    // Clear pressed state when moving outside
    if (!size.contains(event.localPosition)) {
      _clearPressedState(pointer: event.pointer);
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _touchSlop =
        MediaQuery.maybeGestureSettingsOf(context)?.touchSlop ?? kTouchSlop;
  }

  @override
  void didUpdateWidget(MixInteractionDetector oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle controller changes
    if (oldWidget.controller != widget.controller) {
      _handleControllerChange(oldWidget);
      _syncDisabledState();
      if (widget.managesPressedState && _pressPointer != null) {
        _effectiveController.update(.pressed, true);
      }
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
    // Build order: FocusHighlightModeProvider -> IgnorePointer -> MouseRegion -> Listener -> PointerPositionProvider -> ListenableBuilder -> WidgetStateProvider
    //
    // The focus-highlight scope is paired with the widget-state scope: any
    // subtree that can resolve widget-state variants can also resolve the
    // focus-visible variant, which needs both signals.
    return FocusHighlightModeProvider(
      child: IgnorePointer(
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
            behavior: .opaque,
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
      ),
    );
  }
}
