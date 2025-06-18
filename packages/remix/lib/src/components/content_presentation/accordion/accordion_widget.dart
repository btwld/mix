part of 'accordion.dart';

class RxAccordion<T> extends StatefulWidget {
  const RxAccordion({
    super.key,
    required this.children,
    this.initialExpandedValues = const [],
    this.controller,
    this.style,
    this.defaultTrailingIcon = Icons.keyboard_arrow_down_rounded,
  });

  final List<RxAccordionItem<T>> children;
  final List<T> initialExpandedValues;
  final NakedAccordionController<T>? controller;
  final RxAccordionStyle? style;
  final IconData defaultTrailingIcon;

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
  });

  static _InheritedAccordionStyle of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedAccordionStyle>()!;
  }

  final RxAccordionStyle style;
  final IconData? defaultTrailingIcon;

  @override
  bool updateShouldNotify(_InheritedAccordionStyle oldWidget) {
    return style != oldWidget.style;
  }
}

class RxAccordionItem<T> extends StatefulWidget implements Disableable {
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

  const RxAccordionItem.raw({
    super.key,
    required this.header,
    required this.child,
    required this.value,
    this.focusNode,
    this.enabled = true,
    this.trailingIconBuilder,
  });

  final Widget header;
  final Widget child;
  @override
  final bool enabled;
  final T value;
  final FocusNode? focusNode;
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
      style: Style(data.style),
      mixController: mixController,
    );
  }
}

const _kAnimationDuration = Duration(milliseconds: 100);
const _kAnimationCurve = Curves.easeInOut;
