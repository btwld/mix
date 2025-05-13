part of 'select.dart';

class SelectMenuItem<T> {
  final T value;
  final Widget child;

  const SelectMenuItem({required this.value, required this.child});
}

class Select<T> extends StatefulWidget {
  const Select({
    super.key,
    required this.value,
    required this.onChanged,
    required this.trigger,
    required this.items,
    this.variants = const [],
    this.style,
  });

  /// The currently selected value in the select component.
  final T value;

  /// {@macro remix.component.style}
  final SelectStyle? style;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  /// {@macro remix.component.onChanged}
  final ValueChanged<T> onChanged;

  /// Builder function that creates the button portion of the select component.
  /// When tapped, this button will display the dropdown menu.
  /// This allows customizing how the button is displayed.
  final SelectTrigger trigger;

  /// The list of items to display in the dropdown menu.
  /// Each item contains a value and widget to display.
  final List<SelectMenuItem<T>> items;

  @override
  State<Select> createState() => SelectState<T>();
}

class SelectState<T> extends State<Select<T>> {
  late final WidgetStatesController _menuStateController;

  final _link = LayerLink();

  @override
  void initState() {
    super.initState();

    _menuStateController = WidgetStatesController()..selected = false;
  }

  void openMenu() {
    setState(() {
      _menuStateController.selected = true;
    });
  }

  void closeMenu() {
    setState(() {
      _menuStateController.selected = false;
    });
  }

  @override
  void dispose() {
    _menuStateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? context.remix.components.select;
    final configuration = SpecConfiguration(context, SelectSpecUtility.self);
    final appliedStyle =
        style.makeStyle(configuration).applyVariants(widget.variants);

    final animatedStyle = appliedStyle.cast<AnimatedStyle>();

    return OverlayWrapper(
      target: widget.trigger,
      overlayChild: RepaintBoundary(
        child: SpecBuilder(
          controller: _menuStateController,
          style: appliedStyle,
          builder: (context) {
            final select = SelectSpec.of(context);
            final menu = select.menu;

            final FlexContainer = menu.container.copyWith(
              box: menu.container.box.copyWith(
                width: menu.autoWidth ? _link.leaderSize!.width : null,
              ),
            );

            return FlexContainer(
              direction: Axis.vertical,
              children: widget.items
                  .map(
                    (item) => Pressable(
                      onPress: () {
                        widget.onChanged(item.value);
                        closeMenu();
                      },
                      child: SpecBuilder(
                        style: appliedStyle,
                        builder: (context) {
                          return item.child;
                        },
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
      onTapOutside: closeMenu,
      showOverlay: _menuStateController.selected,
      animationDuration: animatedStyle?.animated.duration ?? Duration.zero,
      link: _link,
    );
  }
}
