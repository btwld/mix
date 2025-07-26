import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../widget_state_controller.dart';
import '../widget_state_provider.dart';

/// A comprehensive interaction state detector that consolidates focus, hover,
/// and mouse position tracking into a single performant widget.
///
/// This widget uses [FocusableActionDetector] for focus/hover management
/// and optionally adds mouse position tracking when needed.
class MixInteractable extends StatefulWidget {
  const MixInteractable({
    super.key,
    required this.child,
    this.controller,
    this.cursorPositionController,
    this.enabled = true,
    // Focus & hover
    this.focusNode,
    this.autofocus = false,
    this.descendantsAreFocusable = true,
    this.descendantsAreTraversable = true,
    this.onFocusChange,
    this.onShowFocusHighlight,
    this.onShowHoverHighlight,
    // Actions & shortcuts
    this.shortcuts,
    this.actions,
    // Mouse
    this.mouseCursor = MouseCursor.defer,
    this.trackMousePosition = false,
    this.onMousePositionChanged,
    // Semantics
    this.includeFocusSemantics = true,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Controller for widget states (focused, hovered, pressed, etc).
  /// An internal controller will be created if not provided.
  final WidgetStatesController? controller;

  /// Controller for cursor position tracking.
  /// An internal controller will be created if not provided and
  /// [trackMousePosition] is true.
  final CursorPositionController? cursorPositionController;

  /// Whether this widget should respond to focus and hover.
  final bool enabled;

  /// An optional focus node to use for managing focus.
  /// If null, [FocusableActionDetector] will create and manage its own.
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.Focus.descendantsAreFocusable}
  final bool descendantsAreFocusable;

  /// {@macro flutter.widgets.Focus.descendantsAreTraversable}
  final bool descendantsAreTraversable;

  /// Called when the focus changes.
  final ValueChanged<bool>? onFocusChange;

  /// Called when the focus highlight should be shown or hidden.
  final ValueChanged<bool>? onShowFocusHighlight;

  /// Called when the hover highlight should be shown or hidden.
  final ValueChanged<bool>? onShowHoverHighlight;

  /// {@macro flutter.widgets.Shortcuts.shortcuts}
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// {@macro flutter.widgets.Actions.actions}
  final Map<Type, Action<Intent>>? actions;

  /// The mouse cursor for this widget.
  final MouseCursor mouseCursor;

  /// Whether to track mouse position for advanced hover effects.
  final bool trackMousePosition;

  /// Called when the mouse position changes (only if [trackMousePosition] is true).
  final ValueChanged<PointerPosition?>? onMousePositionChanged;

  /// {@macro flutter.widgets.Focus.includeFocusSemantics}
  final bool includeFocusSemantics;

  @override
  State<MixInteractable> createState() => _MixInteractableState();
}

class _MixInteractableState extends State<MixInteractable> {
  late final WidgetStatesController _controller;
  CursorPositionController? _internalCursorController;

  CursorPositionController? get _cursorController {
    if (!widget.trackMousePosition) return widget.cursorPositionController;

    return widget.cursorPositionController ??
        (_internalCursorController ??= CursorPositionController());
  }

  @override
  void initState() {
    super.initState();
    // Always create internal controller if not provided
    _controller = widget.controller ?? WidgetStatesController();
    _updateEnabledState();
    _setupCursorListener();
  }

  void _updateEnabledState() {
    _controller.disabled = !widget.enabled;
  }

  void _setupCursorListener() {
    _cursorController?.addListener(_onMousePositionUpdate);
  }

  void _onMousePositionUpdate() {
    widget.onMousePositionChanged?.call(_cursorController?.value);
  }

  void _handleFocusHighlight(bool hasFocus) {
    _controller.focused = hasFocus;
    widget.onShowFocusHighlight?.call(hasFocus);
  }

  void _handleHoverHighlight(bool isHovered) {
    _controller.hovered = isHovered;
    widget.onShowHoverHighlight?.call(isHovered);
  }

  void _handleMouseHover(PointerHoverEvent event) {
    final size = context.size;
    if (size != null) {
      _cursorController?.updatePosition(event.localPosition, size);
    }
  }

  void _handleMouseExit(PointerExitEvent event) {
    _cursorController?.clear();
  }

  @override
  void didUpdateWidget(MixInteractable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.enabled != oldWidget.enabled) {
      _updateEnabledState();
    }

    if (widget.cursorPositionController != oldWidget.cursorPositionController ||
        widget.trackMousePosition != oldWidget.trackMousePosition) {
      // Remove old listener
      _cursorController?.removeListener(_onMousePositionUpdate);

      // Dispose internal controller if switching to external
      if (oldWidget.cursorPositionController == null &&
          _internalCursorController != null &&
          widget.cursorPositionController != null) {
        _internalCursorController?.dispose();
        _internalCursorController = null;
      }

      // Setup new listener
      _setupCursorListener();

      // Clear position if stopping tracking
      if (!widget.trackMousePosition) {
        _cursorController?.clear();
      }
    }
  }

  @override
  void dispose() {
    _cursorController?.removeListener(_onMousePositionUpdate);

    // Only dispose if we created the controller
    if (widget.controller == null) {
      _controller.dispose();
    }

    _internalCursorController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = widget.child;

    // FocusableActionDetector handles focus, hover, actions, and shortcuts
    result = FocusableActionDetector(
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      descendantsAreFocusable: widget.descendantsAreFocusable,
      descendantsAreTraversable: widget.descendantsAreTraversable,
      shortcuts: widget.shortcuts,
      actions: widget.actions,
      onShowFocusHighlight: _handleFocusHighlight,
      onShowHoverHighlight: _handleHoverHighlight,
      onFocusChange: widget.onFocusChange,
      mouseCursor: widget.mouseCursor,
      includeFocusSemantics: widget.includeFocusSemantics,
      child: result,
    );

    // Add mouse position tracking if enabled
    if (widget.trackMousePosition) {
      result = MouseRegion(
        onExit: _handleMouseExit,
        onHover: _handleMouseHover,
        opaque: false,
        child: result,
      );
    }

    // Always wrap with state provider
    return WidgetStateBuilder(
      controller: _controller,
      cursorPositionController: _cursorController,
      builder: (_) => result,
    );
  }
}
