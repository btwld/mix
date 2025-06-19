part of 'accordion.dart';

/// A collapsible accordion component that can contain multiple expandable items.
///
/// The [RxAccordion] is a customizable widget that can be used to create collapsible content sections.
/// It supports various configurations such as applying style variants, custom controllers, and initial expanded states.
///
/// ## Example
///
/// ```dart
/// RxAccordion<String>(
///   children: [
///     RxAccordionItem(
///       title: 'Section 1',
///       value: 'section1',
///       child: Text('Content for section 1'),
///     ),
///     RxAccordionItem(
///       title: 'Section 2',
///       value: 'section2',
///       child: Text('Content for section 2'),
///     ),
///   ],
///   initialExpandedValues: ['section1'],
///   variants: [Variant.primary],
///   style: RxAccordionStyle(),
/// )
/// ```
///
class RxAccordion<T> extends StatefulWidget {
  const RxAccordion({
    super.key,
    required this.children,
    this.initialExpandedValues = const [],
    this.controller,
    this.style,
    this.variants = const [],
    this.defaultTrailingIcon = Icons.keyboard_arrow_down_rounded,
  });

  /// A list of accordion items to display.
  final List<RxAccordionItem<T>> children;

  /// A list of values that should be initially expanded.
  final List<T> initialExpandedValues;

  /// Optional controller to manage accordion state.
  final NakedAccordionController<T>? controller;

  /// {@macro remix.component.style}
  final RxAccordionStyle? style;

  /// The default icon to display for expand/collapse.
  final IconData defaultTrailingIcon;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  @override
  State<RxAccordion<T>> createState() => _RxAccordionState<T>();
}

class _RxAccordionState<T> extends State<RxAccordion<T>> {
  late final NakedAccordionController<T> _controller =
      widget.controller ?? NakedAccordionController<T>();

  RxAccordionStyle get style => RxAccordionStyle._default().merge(
        widget.style ?? RxAccordionStyle(),
      );

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedAccordionStyle(
      style: style,
      defaultTrailingIcon: widget.defaultTrailingIcon,
      variants: widget.variants,
      child: NakedAccordion<T>(
        controller: _controller,
        initialExpandedValues: widget.initialExpandedValues,
        children: widget.children,
      ),
    );
  }
}

class _InheritedAccordionStyle extends InheritedWidget {
  const _InheritedAccordionStyle({
    required super.child,
    required this.style,
    required this.defaultTrailingIcon,
    required this.variants,
  });

  static _InheritedAccordionStyle of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedAccordionStyle>()!;
  }

  final RxAccordionStyle style;
  final IconData? defaultTrailingIcon;
  final List<Variant> variants;

  @override
  bool updateShouldNotify(_InheritedAccordionStyle oldWidget) {
    return style != oldWidget.style;
  }
}

/// A single item within an accordion component.
///
/// The [RxAccordionItem] represents a collapsible section within an accordion.
/// It supports various configurations such as enabling/disabling the item, custom headers, and trailing icons.
///
/// ## Example
///
/// ```dart
/// RxAccordionItem<String>(
///   title: 'My Section',
///   value: 'my-section',
///   child: Text('This is the content of my section'),
///   leadingIcon: Icons.info,
///   enabled: true,
/// )
/// ```
///
/// ## Parameters
///
/// - [title]: The text to display as the section header.
/// - [value]: The unique value associated with this accordion item.
/// - [child]: The content to display when the section is expanded.
/// - [leadingIcon]: Optional icon to display before the title.
/// - [focusNode]: Optional focus node to control focus behavior.
/// - [enabled]: Whether the accordion item is enabled.
/// - [trailingIconBuilder]: Optional builder for custom trailing icons.
/// - [header]: Custom header widget (when using .raw constructor).
class RxAccordionItem<T> extends StatefulWidget implements Disableable {
  /// Creates a Remix accordion item.
  ///
  /// The [title], [child], and [value] parameters are required.
  /// Other parameters allow customizing the item's appearance and behavior.
  RxAccordionItem({
    super.key,
    required String title,
    required this.child,
    required this.value,
    this.focusNode,
    this.enabled = true,
    this.trailingIconBuilder,
    IconData? leadingIcon,
  }) : header = RxLabel(title, icon: leadingIcon);

  /// Creates a Remix accordion item with custom header.
  ///
  /// This constructor allows for custom header content beyond the default layout.
  /// The [header], [child], and [value] parameters must be provided.
  ///
  /// Example:
  /// ```dart
  /// RxAccordionItem.raw(
  ///   header: Row(
  ///     children: [
  ///       Icon(Icons.star),
  ///       Text('Custom Header'),
  ///     ],
  ///   ),
  ///   child: Text('Content'),
  ///   value: 'custom-section',
  /// )
  /// ```
  const RxAccordionItem.raw({
    super.key,
    required this.header,
    required this.child,
    required this.value,
    this.focusNode,
    this.enabled = true,
    this.trailingIconBuilder,
  });

  /// The header widget to display for this accordion item.
  final Widget header;

  /// The content to display when the section is expanded.
  final Widget child;

  /// {@macro remix.component.enabled}
  @override
  final bool enabled;

  /// The unique value associated with this accordion item.
  final T value;

  /// Optional focus node to control focus behavior.
  final FocusNode? focusNode;

  /// Optional builder for custom trailing icons.
  final Widget Function(bool)? trailingIconBuilder;

  @override
  State<RxAccordionItem<T>> createState() => _RxAccordionItemState<T>();
}

class _RxAccordionItemState<T> extends State<RxAccordionItem<T>>
    with MixControllerMixin, DisableableMixin {
  @override
  Widget build(BuildContext context) {
    final data = _InheritedAccordionStyle.of(context);

    return RemixBuilder(
      builder: (context) {
        final spec = AccordionSpec.of(context);

        return spec.itemContainer(
          child: NakedAccordionItem<T>(
            trigger: (_, isExpanded, toggle) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                mixController.selected = isExpanded;
              });

              return NakedButton(
                onPressed: toggle,
                onHoverState: (state) {
                  mixController.hovered = state;
                },
                onPressedState: (state) {
                  mixController.pressed = state;
                },
                onFocusState: (state) {
                  mixController.focused = state;
                },
                enabled: widget.enabled,
                focusNode: widget.focusNode,
                child: IconTheme(
                  data: spec.leadingIcon,
                  child: DefaultTextStyle(
                    style: spec.titleStyle,
                    child: spec.headerContainer(
                      direction: Axis.horizontal,
                      children: [
                        widget.header,
                        const Spacer(),
                        if (widget.trailingIconBuilder != null)
                          widget.trailingIconBuilder!(isExpanded)
                        else
                          spec.trailingIcon(data.defaultTrailingIcon),
                      ],
                    ),
                  ),
                ),
              );
            },
            value: widget.value,
            transitionBuilder: (child) => AnimatedSwitcher(
              duration: spec.contentContainer.animated?.duration ??
                  _kAnimationDuration,
              switchInCurve:
                  spec.contentContainer.animated?.curve ?? _kAnimationCurve,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    axis: Axis.vertical,
                    sizeFactor: animation,
                    axisAlignment: -1,
                    child: child,
                  ),
                );
              },
              child: child,
            ),
            child: DefaultTextStyle(
              style: spec.contentStyle,
              child: spec.contentContainer(child: widget.child),
            ),
          ),
        );
      },
      style: Style(data.style).applyVariants(data.variants),
      controller: mixController,
    );
  }
}

const _kAnimationDuration = Duration(milliseconds: 100);
const _kAnimationCurve = Curves.easeInOut;
