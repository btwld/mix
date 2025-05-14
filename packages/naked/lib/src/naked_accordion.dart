import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A fully customizable accordion with no default styling.
///
/// NakedAccordion provides expandable/collapsible sections with accessibility features
/// without imposing any visual styling, giving consumers complete design freedom.
/// It manages the state of expanded sections through an [AccordionController] and provides
/// callbacks for custom state handling.
///
/// This component includes:
/// - [AccordionController]: Manages which sections are expanded/collapsed
/// - [NakedAccordion]: The container for accordion items
/// - [NakedAccordionItem]: Individual collapsible sections
/// - [NakedAccordionTrigger]: Handles user interaction for expanding/collapsing
///
/// Example:
/// ```dart
/// class MyAccordion extends StatefulWidget {
///   @override
///   _MyAccordionState createState() => _MyAccordionState();
/// }
///
/// class _MyAccordionState extends State<MyAccordion> {
///   final AccordionController<String> controller = AccordionController<String>();
///   bool isHovered = false;
///   bool isPressed = false;
///   bool isFocused = false;
///
///   @override
///   Widget build(BuildContext context) {
///     return NakedAccordion<String>(
///       controller: controller,
///       initialExpandedValues: ['section1'],
///       children: [
///         NakedAccordionItem<String>(
///           value: 'section1',
///           trigger: (isExpanded) => NakedAccordionTrigger<String>(
///             onHoverState: (hover) => setState(() => isHovered = hover),
///             onPressedState: (pressed) => setState(() => isPressed = pressed),
///             onFocusState: (focused) => setState(() => isFocused = focused),
///             child: Container(
///               padding: EdgeInsets.all(16),
///               decoration: BoxDecoration(
///                 color: isPressed
///                     ? Colors.blue.shade700
///                     : isHovered
///                         ? Colors.blue.shade600
///                         : Colors.blue.shade500,
///                 borderRadius: BorderRadius.circular(4),
///               ),
///               child: Row(
///                 children: [
///                   Text('Section 1', style: TextStyle(color: Colors.white)),
///                   Spacer(),
///                   Icon(
///                     isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
///                     color: Colors.white,
///                   ),
///                 ],
///               ),
///             ),
///           ),
///           child: Container(
///             padding: EdgeInsets.all(16),
///             child: Text('Content for section 1'),
///           ),
///           transitionBuilder: (child) => AnimatedSwitcher(
///             duration: Duration(milliseconds: 300),
///             child: child,
///           ),
///         ),
///         // Add more NakedAccordionItems as needed
///       ],
///     );
///   }
/// }
/// ```

/// Controller that manages the state of an accordion.
///
/// This controller keeps track of which accordion items are expanded or collapsed
/// and provides methods to open, close, or toggle items. It can also enforce
/// minimum and maximum limits on the number of expanded items.
///
/// Generic type [T] represents the unique identifier for each accordion item.
class AccordionController<T> with ChangeNotifier {
  /// Creates an accordion controller.
  ///
  /// [min] specifies the minimum number of expanded items (default: 0).
  /// [max] specifies the maximum number of expanded items (optional).
  /// When [max] is specified and reached, opening a new item will close the oldest one.
  AccordionController({this.min = 0, this.max});

  /// The minimum number of expanded items allowed.
  final int min;

  /// The maximum number of expanded items allowed.
  /// If null, there is no maximum limit.
  final int? max;

  /// Set of currently expanded values.
  final Set<T> values = {};

  /// Opens the accordion item with the given [value].
  ///
  /// If [max] is specified and the maximum number of expanded items is reached,
  /// this will close the oldest expanded item to maintain the limit.
  void open(T value) {
    if (max != null && values.length >= max!) {
      close(values.first);
      values.add(value);
    } else {
      values.add(value);
    }
    notifyListeners();
  }

  void close(T value) {
    if (min > 0 && values.length <= min) {
      return;
    }
    values.remove(value);
    notifyListeners();
  }

  void toggle(T value) {
    if (values.contains(value)) {
      close(value);
    } else {
      open(value);
    }
    notifyListeners();
  }

  void clear() {
    values.clear();
    notifyListeners();
  }

  void openAll(List<T> newValues) {
    values.addAll(newValues);
    notifyListeners();
  }

  bool contains(T value) => values.contains(value);

  @override
  bool operator ==(Object other) {
    return other is AccordionController &&
        runtimeType == other.runtimeType &&
        setEquals(values, other.values);
  }

  @override
  int get hashCode => values.hashCode;
}

/// A container widget for accordion items with no default styling.
///
/// NakedAccordion provides the structure for organizing collapsible sections
/// but leaves the visual styling entirely to the consumer. It uses an
/// [AccordionController] to manage which sections are expanded or collapsed.
///
/// Generic type [T] should match the type used in the [AccordionController].
class NakedAccordion<T> extends StatefulWidget {
  /// The accordion items to display.
  final List<Widget> children;

  /// The controller that manages which items are expanded or collapsed.
  final AccordionController<T> controller;

  /// Values that should be expanded when the accordion is first built.
  final List<T> initialExpandedValues;

  /// Called when an accordion trigger is pressed.
  ///
  /// This callback receives the value of the item whose trigger was pressed.
  final void Function(T value)? onTriggerPressed;

  /// Creates a naked accordion.
  ///
  /// The [children] should be [NakedAccordionItem] widgets with the same
  /// generic type [T] as the [controller].
  const NakedAccordion({
    super.key,
    required this.children,
    required this.controller,
    this.initialExpandedValues = const [],
    this.onTriggerPressed,
  });

  @override
  State<NakedAccordion<T>> createState() => _NakedAccordionState<T>();
}

class _NakedAccordionState<T> extends State<NakedAccordion<T>> {
  late final _controller = widget.controller;

  @override
  void initState() {
    super.initState();
    _controller.values.addAll(widget.initialExpandedValues);
  }

  @override
  void didUpdateWidget(covariant NakedAccordion<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialExpandedValues != widget.initialExpandedValues) {
      _controller.clear();
      _controller.openAll(widget.initialExpandedValues);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.children,
    );
  }
}

typedef BooleanWidgetBuilder = Widget Function(bool isExpanded);

/// An individual item in a [NakedAccordion].
///
/// Each item consists of a trigger widget that toggles expansion state
/// and content that is shown when expanded. The [transitionBuilder] can be
/// used to customize how content appears/disappears.
///
/// Generic type [T] should match the type used in the [AccordionController].
class NakedAccordionItem<T> extends StatefulWidget {
  /// Builder function that creates the trigger widget.
  ///
  /// The boolean parameter indicates whether the item is currently expanded.
  final BooleanWidgetBuilder trigger;

  /// Optional builder to customize the transition when expanding/collapsing.
  ///
  /// If not provided, content will appear/disappear instantly.
  final Widget Function(Widget child)? transitionBuilder;

  /// The content displayed when this item is expanded.
  final Widget child;

  /// The unique identifier for this accordion item.
  ///
  /// This value is used by the [AccordionController] to track expansion state.
  final T value;

  /// Optional semantic label describing the section for screen readers.
  final String? semanticLabel;

  /// Whether this accordion item can be interacted with.
  ///
  /// When false, the trigger cannot be used to expand/collapse the item.
  final bool enabled;

  /// Creates a naked accordion item.
  ///
  /// The [trigger] and [child] parameters are required.
  /// The [value] must be unique among all items controlled by the same controller.
  const NakedAccordionItem({
    super.key,
    required this.trigger,
    required this.value,
    required this.child,
    this.transitionBuilder,
    this.semanticLabel,
    this.enabled = true,
  });

  @override
  State<NakedAccordionItem<T>> createState() => _NakedAccordionItemState<T>();
}

class _NakedAccordionItemState<T> extends State<NakedAccordionItem<T>> {
  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_NakedAccordionState<T>>();
    return ListenableBuilder(
      listenable: state!._controller,
      builder: (context, child) {
        final isExpanded = state._controller.contains(widget.value);
        final child = isExpanded ? widget.child : const SizedBox.shrink();

        return AccordionItemScope(
          expanded: isExpanded,
          child: Semantics(
            container: true,
            label: widget.semanticLabel,
            explicitChildNodes: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.trigger(isExpanded),
                Semantics(
                  container: true,
                  liveRegion: true,
                  child: widget.transitionBuilder != null
                      ? widget.transitionBuilder!(child)
                      : child,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AccordionItemScope extends InheritedWidget {
  final bool expanded;

  const AccordionItemScope({
    super.key,
    required this.expanded,
    required super.child,
  });

  static AccordionItemScope of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AccordionItemScope>()!;
  }

  @override
  bool updateShouldNotify(AccordionItemScope oldWidget) {
    return expanded != oldWidget.expanded;
  }
}

/// A trigger widget for expanding and collapsing a [NakedAccordionItem].
///
/// This widget provides interaction handling and accessibility features
/// without imposing any visual styling. It supports mouse hover, press,
/// and keyboard focus states with callbacks to allow custom styling.
///
/// Generic type [T] should match the type used in the [AccordionController].
class NakedAccordionTrigger<T> extends StatefulWidget {
  /// The child widget to display.
  ///
  /// This widget should represent the visual appearance of the trigger.
  final Widget child;

  /// Called when hover state changes.
  ///
  /// Provides the current hover state (true when hovered, false otherwise).
  final ValueChanged<bool>? onHoverState;

  /// Called when pressed state changes.
  ///
  /// Provides the current pressed state (true when pressed, false otherwise).
  final ValueChanged<bool>? onPressedState;

  /// Optional semantic label for accessibility.
  ///
  /// If not provided, the system will attempt to infer a label from the child.
  final String? semanticLabel;

  /// Optional focus node for the trigger.
  ///
  /// If provided, the trigger will use this focus node.
  final FocusNode? focusNode;

  /// Called when focus state changes.
  ///
  /// Provides the current focus state (true when focused, false otherwise).
  final ValueChanged<bool>? onFocusState;

  /// Creates a naked accordion trigger.
  ///
  /// The [child] parameter is required and represents the visual appearance
  /// of the trigger in all states.
  const NakedAccordionTrigger({
    super.key,
    required this.child,
    this.onHoverState,
    this.onPressedState,
    this.semanticLabel,
    this.focusNode,
    this.onFocusState,
  });

  @override
  State<NakedAccordionTrigger<T>> createState() =>
      _NakedAccordionTriggerState<T>();
}

class _NakedAccordionTriggerState<T> extends State<NakedAccordionTrigger<T>> {
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accordionScope =
        context.findAncestorStateOfType<_NakedAccordionState<T>>();

    final itemScope =
        context.findAncestorStateOfType<_NakedAccordionItemState<T>>()!;
    final isExpanded = AccordionItemScope.of(context).expanded;
    final isInteractive = itemScope.widget.enabled;

    void handleTap() {
      accordionScope?.widget.onTriggerPressed?.call(itemScope.widget.value);
    }

    return Focus(
      focusNode: widget.focusNode,
      canRequestFocus: isInteractive,
      onKeyEvent: (node, event) {
        if (!isInteractive) return KeyEventResult.ignored;

        if (event is KeyDownEvent && event.logicalKey.isSpaceOrEnter) {
          widget.onPressedState?.call(true);

          return KeyEventResult.handled;
        } else if (event is KeyUpEvent && event.logicalKey.isSpaceOrEnter) {
          widget.onPressedState?.call(false);
          handleTap();

          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      onFocusChange: (focused) {
        if (focused) {
          widget.onFocusState?.call(true);
        } else {
          widget.onFocusState?.call(false);
        }
      },
      child: MouseRegion(
        onEnter: isInteractive ? (_) => widget.onHoverState?.call(true) : null,
        onExit: isInteractive ? (_) => widget.onHoverState?.call(false) : null,
        cursor: isInteractive
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        child: GestureDetector(
          onTap: isInteractive ? handleTap : null,
          onTapDown:
              isInteractive ? (_) => widget.onPressedState?.call(true) : null,
          onTapUp:
              isInteractive ? (_) => widget.onPressedState?.call(false) : null,
          onTapCancel:
              isInteractive ? () => widget.onPressedState?.call(false) : null,
          child: Semantics(
            button: true,
            label: widget.semanticLabel,
            excludeSemantics: widget.semanticLabel != null,
            onTap: isInteractive ? handleTap : null,
            toggled: isExpanded,
            hint: isExpanded ? 'Collapse' : 'Expand',
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

extension on LogicalKeyboardKey {
  bool get isSpaceOrEnter =>
      this == LogicalKeyboardKey.space || this == LogicalKeyboardKey.enter;
}
