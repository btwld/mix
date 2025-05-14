import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naked/src/utilities/naked_focus_manager.dart';

export 'naked_slider.dart' show NakedSliderState;

/// Direction of the slider (horizontal or vertical).
enum SliderDirection {
  /// Horizontal slider (left to right)
  horizontal,

  /// Vertical slider (bottom to top)
  vertical,
}

/// A fully customizable slider with no default styling.
///
/// NakedSlider provides interaction behavior and accessibility
/// without imposing any visual styling, allowing complete design freedom.
/// It uses direct callbacks for state changes, giving consumers control over
/// their own state management.
///
/// The component integrates with [NakedFocusManager] to provide enhanced
/// keyboard navigation and focus handling. This includes:
/// - Arrow keys for small value adjustments
/// - Page Up/Down for larger adjustments
/// - Home/End keys to jump to min/max values
/// - RTL (right-to-left) language support for horizontal sliders
/// - Vertical direction support with appropriate key mappings
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
  final SliderDirection direction;

  /// Number of discrete divisions.
  ///
  /// If null, the slider will be continuous.
  final int? divisions;

  /// Step size for keyboard navigation.
  ///
  /// This value is used when arrow keys are pressed to increment or decrement
  /// the slider value. Default is 0.01 (1% of the slider range).
  /// Used by [NakedFocusManager] for keyboard navigation.
  final double keyboardStep;

  /// Step size for large keyboard navigation (e.g., Page Up/Down).
  ///
  /// This value is used when Page Up/Down keys are pressed, or when arrow keys
  /// are pressed while holding Shift. Default is 0.1 (10% of the slider range).
  /// Used by [NakedFocusManager] for keyboard navigation.
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
    this.direction = SliderDirection.horizontal,
    this.divisions,
    this.keyboardStep = 0.01,
    this.largeKeyboardStep = 0.1,
  }) : assert(min < max, 'min must be less than max');

  @override
  State<NakedSlider> createState() => _NakedSliderState();
}

/// Provides state information to the slider's child widget.
class NakedSliderState extends InheritedWidget {
  /// Whether the slider is currently being hovered.
  final bool isHovered;

  /// Whether the slider is currently focused.
  final bool isFocused;

  /// Whether the slider is currently being dragged.
  final bool isDragging;

  /// Creates a naked slider state.
  const NakedSliderState({
    super.key,
    required super.child,
    required this.isHovered,
    required this.isFocused,
    required this.isDragging,
  });

  /// Gets the current slider state from the context.
  static NakedSliderState of(BuildContext context) {
    final state =
        context.dependOnInheritedWidgetOfExactType<NakedSliderState>();
    assert(state != null, 'No NakedSliderState found in context');
    return state!;
  }

  @override
  bool updateShouldNotify(NakedSliderState oldWidget) {
    return isHovered != oldWidget.isHovered ||
        isFocused != oldWidget.isFocused ||
        isDragging != oldWidget.isDragging;
  }
}

class _NakedSliderState extends State<NakedSlider> {
  late FocusNode _focusNode;
  bool _isDragging = false;
  bool _isHovered = false;
  bool _isFocused = false;
  Offset? _dragStartPosition;
  double? _dragStartValue;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
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
    double dragExtent = widget.direction == SliderDirection.horizontal
        ? box.size.width
        : box.size.height;

    double dragDistance = widget.direction == SliderDirection.horizontal
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

  void _handleKeyEvent(KeyEvent event) {
    if (!widget.enabled || widget.onChanged == null) return;

    double step = HardwareKeyboard.instance.isShiftPressed
        ? widget.largeKeyboardStep
        : widget.keyboardStep;

    if (widget.divisions != null) {
      final divisionStep = (widget.max - widget.min) / widget.divisions!;
      step = divisionStep;
    }

    double newValue = widget.value;

    // Get text direction for horizontal sliders
    final TextDirection textDirection = Directionality.of(context);
    final bool isRTL = textDirection == TextDirection.rtl;

    if (event is KeyDownEvent) {
      if (widget.direction == SliderDirection.horizontal) {
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          // In RTL, right arrow decreases value
          newValue += isRTL ? -step : step;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          // In RTL, left arrow increases value
          newValue += isRTL ? step : -step;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          newValue += step;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          newValue -= step;
        } else if (event.logicalKey == LogicalKeyboardKey.home) {
          newValue = widget.min;
        } else if (event.logicalKey == LogicalKeyboardKey.end) {
          newValue = widget.max;
        }
      } else {
        // Vertical slider has inverted up/down controls
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          newValue += step;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          newValue -= step;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          newValue += step;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          newValue -= step;
        } else if (event.logicalKey == LogicalKeyboardKey.home) {
          newValue = widget.min;
        } else if (event.logicalKey == LogicalKeyboardKey.end) {
          newValue = widget.max;
        }
      }

      newValue = _normalizeValue(newValue);

      if (newValue != widget.value) {
        widget.onChanged?.call(newValue);
      }
    }
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
      child: Focus(
        focusNode: _focusNode,
        skipTraversal: false,
        onKeyEvent: (node, event) {
          if (!isInteractive) return KeyEventResult.ignored;
          if (event.logicalKey == LogicalKeyboardKey.tab) {
            return KeyEventResult.ignored;
          }
          _handleKeyEvent(event);
          return KeyEventResult.handled;
        },
        onFocusChange: (focused) {
          setState(() => _isFocused = focused);
          widget.onFocusState?.call(focused);
        },
        child: MouseRegion(
          cursor: isInteractive ? widget.cursor : SystemMouseCursors.forbidden,
          onEnter: isInteractive
              ? (_) {
                  setState(() => _isHovered = true);
                  widget.onHoverState?.call(true);
                }
              : null,
          onExit: isInteractive
              ? (_) {
                  setState(() => _isHovered = false);
                  widget.onHoverState?.call(false);
                }
              : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart:
                widget.direction == SliderDirection.horizontal && isInteractive
                    ? _handleDragStart
                    : null,
            onHorizontalDragUpdate:
                widget.direction == SliderDirection.horizontal && isInteractive
                    ? _handleDragUpdate
                    : null,
            onHorizontalDragEnd:
                widget.direction == SliderDirection.horizontal && isInteractive
                    ? _handleDragEnd
                    : null,
            onVerticalDragStart:
                widget.direction == SliderDirection.vertical && isInteractive
                    ? _handleDragStart
                    : null,
            onVerticalDragUpdate:
                widget.direction == SliderDirection.vertical && isInteractive
                    ? _handleDragUpdate
                    : null,
            onVerticalDragEnd:
                widget.direction == SliderDirection.vertical && isInteractive
                    ? _handleDragEnd
                    : null,
            child: NakedSliderState(
              isHovered: _isHovered,
              isFocused: _isFocused,
              isDragging: _isDragging,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
