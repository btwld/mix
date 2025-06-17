import 'package:flutter/widgets.dart';

/// Controller that manages the state of an accordion.
///
/// This controller keeps track of which accordion items are expanded or collapsed
/// and provides methods to open, close, or toggle items. It can also enforce
/// minimum and maximum limits on the number of expanded items.
///
/// Generic type [T] represents the unique identifier for each accordion item.
/// This could be a String, int, or any other type that can uniquely identify sections.
class NakedAccordionController<T> with ChangeNotifier {
  /// Creates an accordion controller.
  ///
  /// [min] specifies the minimum number of expanded items (default: 0).
  /// [max] specifies the maximum number of expanded items (optional).
  /// When [max] is specified and reached, opening a new item will close the oldest one.
  NakedAccordionController({this.min = 0, this.max})
      : assert(min >= 0, 'min must be greater than or equal to 0'),
        assert(
          max == null || max >= min,
          'max must be greater than or equal to min',
        );

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
      values.remove(values.first);
      values.add(value);
    } else {
      values.add(value);
    }
    notifyListeners();
  }

  /// Closes the accordion item with the given [value].
  ///
  /// Will not close if doing so would violate the [min] constraint.
  void close(T value) {
    if (min > 0 && values.length <= min) {
      return;
    }
    values.remove(value);
    notifyListeners();
  }

  /// Toggles the accordion item with the given [value].
  ///
  /// If the item is expanded, it will be closed (subject to [min] constraint).
  /// If the item is collapsed, it will be opened (subject to [max] constraint).
  void toggle(T value) {
    if (values.contains(value)) {
      close(value);
    } else {
      open(value);
    }
    notifyListeners();
  }

  /// Removes all expanded values.
  ///
  /// Note that if [min] is greater than 0, this operation may not be allowed.
  void clear() {
    values.clear();
    notifyListeners();
  }

  /// Opens all accordion items with the given [newValues].
  ///
  /// Note that if [max] is specified, only the first [max] items will be opened.
  void openAll(List<T> newValues) {
    values.addAll(newValues);
    notifyListeners();
  }

  /// Checks if an item with the given [value] is currently expanded.
  bool contains(T value) => values.contains(value);
}

/// A fully customizable accordion with no default styling.
///
/// NakedAccordion provides expandable/collapsible sections without imposing any visual styling,
/// giving consumers complete design freedom. It manages the state of expanded sections through
/// an [NakedAccordionController].
///
/// This component includes:
/// - [NakedAccordionController]: Manages which sections are expanded/collapsed
/// - [NakedAccordion]: The container for accordion items
/// - [NakedAccordionItem]: Individual collapsible sections
///
/// Example:
/// ```dart
/// final controller = AccordionController<String>();
///
/// NakedAccordion<String>(
///   controller: controller,
///   initialExpandedValues: ['section1'],
///   children: [
///     NakedAccordionItem<String>(
///       value: 'section1',
///       trigger: (context, isExpanded, toggle) {
///         return TextButton(
///           onPressed: toggle,
///           child: Text(isExpanded ? 'Close' : 'Open'),
///         );
///       },
///       child: Text('Content for section 1'),
///       transitionBuilder: (child) => AnimatedSwitcher(
///         duration: Duration(milliseconds: 300),
///         child: child,
///       ),
///     ),
///   ],
/// )
/// ```
class NakedAccordion<T> extends StatefulWidget {
  /// The accordion items to display.
  final List<Widget> children;

  /// The controller that manages which items are expanded or collapsed.
  final NakedAccordionController<T> controller;

  /// Values that should be expanded when the accordion is first built.
  final List<T> initialExpandedValues;

  /// Creates a naked accordion.
  ///
  /// The [children] should be [NakedAccordionItem] widgets with the same
  /// generic type [T] as the [controller].
  const NakedAccordion({
    super.key,
    required this.children,
    required this.controller,
    this.initialExpandedValues = const [],
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

typedef NakedAccordionTriggerBuilder = Widget Function(
  BuildContext context,
  bool isExpanded,
  VoidCallback toggle,
);

/// An individual item in a [NakedAccordion].
///
/// Each item consists of a trigger widget that toggles expansion state
/// and content that is shown when expanded. The [transitionBuilder] can be
/// used to customize how content appears/disappears.
///
/// Generic type [T] should match the type used in the [NakedAccordionController].
class NakedAccordionItem<T> extends StatefulWidget {
  /// Builder function that creates the trigger widget.
  ///
  /// The builder provides:
  /// - [BuildContext] for accessing theme and other data
  /// - [bool] indicating if the item is expanded
  /// - [VoidCallback] to toggle expansion state
  final NakedAccordionTriggerBuilder trigger;

  /// Optional builder to customize the transition when expanding/collapsing.
  ///
  /// If not provided, content will appear/disappear instantly.
  final Widget Function(Widget child)? transitionBuilder;

  /// The content displayed when this item is expanded.
  final Widget child;

  /// The unique identifier for this accordion item.
  ///
  /// This value is used by the [NakedAccordionController] to track expansion state.
  final T value;

  /// Optional semantic label describing the section for screen readers.
  final String? semanticLabel;

  /// Optional callback to handle focus state changes.
  final ValueChanged<bool>? onFocusState;

  /// Whether the item should be focused when the accordion is opened.
  final bool autoFocus;

  /// The focus node for the item.
  final FocusNode? focusNode;

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
    this.onFocusState,
    this.autoFocus = false,
    this.focusNode,
  });

  @override
  State<NakedAccordionItem<T>> createState() => _NakedAccordionItemState<T>();
}

class _NakedAccordionItemState<T> extends State<NakedAccordionItem<T>> {
  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_NakedAccordionState<T>>();
    return FocusableActionDetector(
      onFocusChange: widget.onFocusState,
      autofocus: widget.autoFocus,
      focusNode: widget.focusNode,
      child: ListenableBuilder(
        listenable: state!._controller,
        builder: (context, child) {
          final isExpanded = state._controller.contains(widget.value);
          final child = isExpanded ? widget.child : const SizedBox.shrink();

          return Semantics(
            container: true,
            label: widget.semanticLabel,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.trigger(
                  context,
                  isExpanded,
                  () => state._controller.toggle(widget.value),
                ),
                widget.transitionBuilder != null
                    ? widget.transitionBuilder!(child)
                    : child,
              ],
            ),
          );
        },
      ),
    );
  }
}
