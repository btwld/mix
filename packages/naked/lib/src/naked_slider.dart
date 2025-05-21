import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A fully customizable slider with no default styling.
///
/// NakedSlider provides interaction behavior and accessibility
/// without imposing any visual styling, allowing complete design freedom.
/// It uses direct callbacks for state changes, giving consumers control over
/// their own state management.
///
/// The component provides enhanced keyboard navigation and focus handling:
/// - Arrow keys for small value adjustments (using [keyboardStep])
/// - Shift + Arrow keys for larger adjustments (using [largeKeyboardStep])
/// - Home/End keys to jump to min/max values
/// - RTL (right-to-left) language support for horizontal sliders
/// - Vertical direction support with appropriate key mappings (up/down arrows)
/// - Vertical sliders use up arrow to increase and down arrow to decrease values
///
/// Example:
/// ```dart
/// class MySlider extends StatefulWidget {
///   @override
///   _MySliderState createState() => _MySliderState();
/// }
///
/// class _MySliderState extends State<MySlider> {
///   double _value = 0.5;
///   bool _isDragging = false;
///   bool _isHovered = false;
///   bool _isFocused = false;
///
///   @override
///   Widget build(BuildContext context) {
///     return NakedSlider(
///       value: _value,
///       onChanged: (newValue) {
///         setState(() {
///           _value = newValue;
///         });
///       },
///       onHoverState: (isHovered) => setState(() => _isHovered = isHovered),
///       onDraggingState: (isDragging) => setState(() => _isDragging = isDragging),
///       onFocusState: (isFocused) => setState(() => _isFocused = isFocused),
///       child: Container(
///         height: 40,
///         width: 200,
///         color: Colors.transparent,
///         child: Stack(
///           children: [
///             // Track
///             Container(
///               margin: EdgeInsets.symmetric(vertical: 18),
///               decoration: BoxDecoration(
///                 color: Colors.grey.shade300,
///                 borderRadius: BorderRadius.circular(2),
///               ),
///               height: 4,
///             ),
///             // Active Track
///             FractionallySizedBox(
///               widthFactor: _value,
///               child: Container(
///                 margin: EdgeInsets.symmetric(vertical: 18),
///                 decoration: BoxDecoration(
///                   color: Colors.blue.shade600,
///                   borderRadius: BorderRadius.circular(2),
///                 ),
///                 height: 4,
///               ),
///             ),
///             // Thumb
///             Positioned(
///               left: _value * 200 - 10,
///               top: 0,
///               child: Container(
///                 height: 20,
///                 width: 20,
///                 decoration: BoxDecoration(
///                   color: _isDragging ? Colors.blue.shade700 :
///                         _isHovered ? Colors.blue.shade600 : Colors.blue.shade500,
///                   borderRadius: BorderRadius.circular(10),
///                   border: Border.all(
///                     color: _isFocused ? Colors.white : Colors.transparent,
///                     width: 2,
///                   ),
///                   boxShadow: [
///                     BoxShadow(
///                       color: Colors.black.withValues(alpha: 0.1),
///                       blurRadius: 4,
///                       offset: Offset(0, 2),
///                     ),
///                   ],
///                 ),
///               ),
///             ),
///           ],
///         ),
///       ),
///     );
///   }
/// }
/// ```
class NakedSlider extends StatefulWidget {
  /// The child widget to display.
  ///
  /// Typically includes a track and thumb visualization.
  final Widget child;

  /// The current value of the slider.
  final double value;

  /// Minimum value of the slider.
  final double min;

  /// Maximum value of the slider.
  final double max;

  /// Called when the slider value changes.
  final ValueChanged<double>? onChanged;

  /// Called when the user starts dragging the slider.
  final VoidCallback? onDragStart;

  /// Called when the user ends dragging the slider.
  final ValueChanged<double>? onDragEnd;

  /// Called when hover state changes.
  final ValueChanged<bool>? onHoverState;

  /// Called when dragging state changes.
  final ValueChanged<bool>? onDraggingState;

  /// Called when focus state changes.
  final ValueChanged<bool>? onFocusState;

  /// Whether the slider is disabled.
  ///
  /// When true, the slider will not respond to user interaction.
  final bool enabled;

  /// Optional semantic label for accessibility.
  ///
  /// This is used by screen readers to describe the slider.
  final String? semanticLabel;

  /// The cursor to show when hovering over the slider.
  final MouseCursor cursor;

  /// Optional focus node to control focus behavior.
  final FocusNode? focusNode;

  /// Direction of the slider.
  ///
  /// Can be horizontal (left to right) or vertical (bottom to top).
  final Axis direction;

  /// Number of discrete divisions.
  ///
  /// If null, the slider will be continuous.
  final int? divisions;

  /// Step size for keyboard navigation.
  ///
  /// This value is used when arrow keys are pressed to increment or decrement
  /// the slider value. Default is 0.01 (1% of the slider range).
  final double keyboardStep;

  /// Step size for large keyboard navigation.
  ///
  /// This value is used when arrow keys are pressed while holding Shift.
  /// Default is 0.1 (10% of the slider range).
  final double largeKeyboardStep;

  /// Creates a naked slider.
  ///
  /// The [child] and [value] parameters are required.
  /// The [min] must be less than [max].
  const NakedSlider({
    super.key,
    required this.child,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    this.onChanged,
    this.onDragStart,
    this.onDragEnd,
    this.onHoverState,
    this.onDraggingState,
    this.onFocusState,
    this.enabled = true,
    this.semanticLabel,
    this.cursor = SystemMouseCursors.click,
    this.focusNode,
    this.direction = Axis.horizontal,
    this.divisions,
    this.keyboardStep = 0.01,
    this.largeKeyboardStep = 0.1,
  }) : assert(min < max, 'min must be less than max');

  @override
  State<NakedSlider> createState() => _NakedSliderState();
}

class _NakedSliderState extends State<NakedSlider> {
  bool _isDragging = false;

  Offset? _dragStartPosition;
  double? _dragStartValue;

  Map<ShortcutActivator, Intent> get _shortcuts {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    const arrowLeft = LogicalKeyboardKey.arrowLeft;
    const arrowRight = LogicalKeyboardKey.arrowRight;
    const arrowUp = LogicalKeyboardKey.arrowUp;
    const arrowDown = LogicalKeyboardKey.arrowDown;
    const home = LogicalKeyboardKey.home;
    const end = LogicalKeyboardKey.end;

    final decrementIntent = SingleActivator(isRTL ? arrowRight : arrowLeft);
    final incrementIntent = SingleActivator(isRTL ? arrowLeft : arrowRight);

    final shiftDecrementIntent =
        SingleActivator(isRTL ? arrowRight : arrowLeft, shift: true);
    final shiftIncrementIntent =
        SingleActivator(isRTL ? arrowLeft : arrowRight, shift: true);

    return {
      // Horizontal
      incrementIntent: const _SliderIncrementIntent(),
      decrementIntent: const _SliderDecrementIntent(),
      shiftDecrementIntent: const _SliderShiftDecrementIntent(),
      shiftIncrementIntent: const _SliderShiftIncrementIntent(),

      // Vertical
      const SingleActivator(arrowUp): const _SliderIncrementIntent(),
      const SingleActivator(arrowUp, shift: true):
          const _SliderShiftIncrementIntent(),

      const SingleActivator(arrowDown): const _SliderDecrementIntent(),
      const SingleActivator(arrowDown, shift: true):
          const _SliderShiftDecrementIntent(),

      // Home/End
      const SingleActivator(home): const _SliderSetToMinIntent(),
      const SingleActivator(end): const _SliderSetToMaxIntent(),
    };
  }

  Map<Type, Action<Intent>> get _actions {
    return {
      _SliderIncrementIntent: _SliderIncrementAction(this),
      _SliderDecrementIntent: _SliderDecrementAction(this),
      _SliderShiftDecrementIntent:
          _SliderDecrementAction(this, isShiftPressed: true),
      _SliderShiftIncrementIntent:
          _SliderIncrementAction(this, isShiftPressed: true),
      _SliderSetToMinIntent: _SliderSetToMinAction(this),
      _SliderSetToMaxIntent: _SliderSetToMaxAction(this),
    };
  }

  void _callOnChangeIfNeeded(double value) {
    if (value != widget.value) {
      widget.onChanged?.call(value);
    }
  }

  double _normalizeValue(double value) {
    // Ensure value is within bounds
    double normalizedValue = value.clamp(widget.min, widget.max);

    // Apply divisions if specified
    if (widget.divisions != null) {
      double step = (widget.max - widget.min) / widget.divisions!;
      int steps = ((normalizedValue - widget.min) / step).round();
      normalizedValue = widget.min + steps * step;
    }

    return normalizedValue;
  }

  void _handleDragStart(DragStartDetails details) {
    if (!widget.enabled || widget.onChanged == null) return;

    setState(() {
      _isDragging = true;
      _dragStartPosition = details.globalPosition;
      _dragStartValue = widget.value;
    });

    widget.onDraggingState?.call(true);
    widget.onDragStart?.call();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isDragging || !widget.enabled || widget.onChanged == null) return;

    // Calculate the drag delta in the proper direction
    final Offset currentPosition = details.globalPosition;
    final Offset dragDelta = currentPosition - _dragStartPosition!;

    // Get the RenderBox of the slider
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    // Convert the drag delta to a value change
    double dragExtent =
        widget.direction == Axis.horizontal ? box.size.width : box.size.height;

    double dragDistance = widget.direction == Axis.horizontal
        ? dragDelta.dx
        : -dragDelta.dy; // Invert for vertical slider (up is positive)

    double valueDelta = dragDistance / dragExtent * (widget.max - widget.min);
    double newValue = _normalizeValue(_dragStartValue! + valueDelta);

    if (newValue != widget.value) {
      widget.onChanged?.call(newValue);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isDragging) return;

    setState(() {
      _isDragging = false;
      _dragStartPosition = null;
      _dragStartValue = null;
    });

    widget.onDraggingState?.call(false);
    widget.onDragEnd?.call(widget.value);
  }

  double _calculateStep(bool isShiftPressed) {
    final divisions = widget.divisions;
    if (divisions != null) return (widget.max - widget.min) / divisions;

    return isShiftPressed ? widget.largeKeyboardStep : widget.keyboardStep;
  }

  @override
  Widget build(BuildContext context) {
    final isInteractive = widget.enabled && widget.onChanged != null;

    // Calculate percentage for accessibility
    final double percentage = widget.max > widget.min
        ? ((widget.value - widget.min) / (widget.max - widget.min)) * 100
        : 0.0;

    // Calculate value change for accessibility notifications
    final double step = widget.keyboardStep;
    final double increasedValue = _normalizeValue(widget.value + step);
    final double decreasedValue = _normalizeValue(widget.value - step);

    return Semantics(
      slider: true,
      label: widget.semanticLabel,
      value: '${percentage.round()}%',
      increasedValue:
          '${((increasedValue - widget.min) / (widget.max - widget.min) * 100).round()}%',
      decreasedValue:
          '${((decreasedValue - widget.min) / (widget.max - widget.min) * 100).round()}%',
      enabled: isInteractive,
      excludeSemantics: true,
      child: FocusableActionDetector(
        shortcuts: _shortcuts,
        actions: _actions,
        descendantsAreTraversable: false,
        focusNode: widget.focusNode,
        onFocusChange: widget.onFocusState,
        enabled: isInteractive,
        mouseCursor:
            isInteractive ? widget.cursor : SystemMouseCursors.forbidden,
        onShowHoverHighlight: widget.onHoverState,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart:
              widget.direction == Axis.horizontal && isInteractive
                  ? _handleDragStart
                  : null,
          onHorizontalDragUpdate:
              widget.direction == Axis.horizontal && isInteractive
                  ? _handleDragUpdate
                  : null,
          onHorizontalDragEnd:
              widget.direction == Axis.horizontal && isInteractive
                  ? _handleDragEnd
                  : null,
          onVerticalDragStart:
              widget.direction == Axis.vertical && isInteractive
                  ? _handleDragStart
                  : null,
          onVerticalDragUpdate:
              widget.direction == Axis.vertical && isInteractive
                  ? _handleDragUpdate
                  : null,
          onVerticalDragEnd: widget.direction == Axis.vertical && isInteractive
              ? _handleDragEnd
              : null,
          child: widget.child,
        ),
      ),
    );
  }
}

class _SliderShiftIncrementIntent extends _SliderIncrementIntent {
  const _SliderShiftIncrementIntent();
}

class _SliderShiftDecrementIntent extends _SliderDecrementIntent {
  const _SliderShiftDecrementIntent();
}

class _SliderIncrementIntent extends Intent {
  const _SliderIncrementIntent();
}

class _SliderDecrementIntent extends Intent {
  const _SliderDecrementIntent();
}

class _SliderSetToMinIntent extends Intent {
  const _SliderSetToMinIntent();
}

class _SliderSetToMaxIntent extends Intent {
  const _SliderSetToMaxIntent();
}

// Create actions that respond to these intents

class _SliderIncrementAction extends Action<_SliderIncrementIntent> {
  _SliderIncrementAction(this.state, {this.isShiftPressed = false});

  final _NakedSliderState state;
  final bool isShiftPressed;

  @override
  void invoke(_SliderIncrementIntent intent) {
    final step = state._calculateStep(isShiftPressed);

    final newValue = state._normalizeValue(state.widget.value + step);
    state._callOnChangeIfNeeded(newValue);
  }
}

class _SliderDecrementAction extends Action<_SliderDecrementIntent> {
  _SliderDecrementAction(this.state, {this.isShiftPressed = false});

  final _NakedSliderState state;
  final bool isShiftPressed;
  @override
  void invoke(_SliderDecrementIntent intent) {
    final step = state._calculateStep(isShiftPressed);

    final newValue = state._normalizeValue(state.widget.value - step);
    state._callOnChangeIfNeeded(newValue);
  }
}

class _SliderSetToMinAction extends Action<_SliderSetToMinIntent> {
  _SliderSetToMinAction(this.state);

  final _NakedSliderState state;

  @override
  void invoke(_SliderSetToMinIntent intent) {
    state._callOnChangeIfNeeded(state.widget.min);
  }
}

class _SliderSetToMaxAction extends Action<_SliderSetToMaxIntent> {
  _SliderSetToMaxAction(this.state);

  final _NakedSliderState state;

  @override
  void invoke(_SliderSetToMaxIntent intent) {
    state._callOnChangeIfNeeded(state.widget.max);
  }
}
