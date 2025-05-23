part of 'accordion.dart';

class RxAccordion<T> extends StatefulWidget {
  const RxAccordion({
    super.key,
    required this.children,
    this.initialExpandedValues = const [],
    this.controller,
    this.style = const AccordionStyle(),
    this.defaultTrailingIcon = Icons.keyboard_arrow_down_rounded,
  });

  final List<RxAccordionItem<T>> children;
  final List<T> initialExpandedValues;
  final AccordionController<T>? controller;
  final AccordionStyle style;
  final IconData defaultTrailingIcon;

  @override
  State<RxAccordion<T>> createState() => _RxAccordionState<T>();
}

class _RxAccordionState<T> extends State<RxAccordion<T>> {
  late final AccordionController<T> _controller =
      widget.controller ?? AccordionController<T>();

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
      style: widget.style,
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

  final AccordionStyle style;
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

    return MixWidgetState.fromSet(
      states: mixController.value,
      child: MixBuilder(
        style: data.style.makeStyle(
          SpecConfiguration(context, AccordionSpecUtility.self),
        ),
        builder: (context) {
          final spec = AccordionSpec.of(context);

          return spec.itemContainer(
            child: NakedAccordionItem<T>(
              trigger: (_, isExpanded, toogle) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  mixController.update(WidgetState.selected, isExpanded);
                });

                return NakedButton(
                  onPressed: toogle,
                  onHoverState: (state) {
                    setState(() {
                      mixController.hovered = state;
                    });
                  },
                  onPressedState: (state) {
                    setState(() {
                      mixController.pressed = state;
                    });
                  },
                  onFocusState: (state) {
                    setState(() {
                      mixController.focused = state;
                    });
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
                          IconTheme(
                            data: spec.trailingIcon,
                            child: widget.trailingIconBuilder != null
                                ? widget.trailingIconBuilder!(isExpanded)
                                : Icon(data.defaultTrailingIcon),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              value: widget.value,
              transitionBuilder: (child) => AnimatedSwitcher(
                duration: spec.contentContainer.animated?.duration ??
                    kAnimationDuration,
                switchInCurve:
                    spec.contentContainer.animated?.curve ?? kAnimationCurve,
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
      ),
    );
  }
}

const kAnimationDuration = Duration(milliseconds: 100);
const kAnimationCurve = Curves.easeInOut;
