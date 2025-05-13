part of 'dropdown_menu.dart';

class DropdownMenu extends StatefulWidget {
  const DropdownMenu({
    super.key,
    this.variants = const [],
    this.style,
    required this.trigger,
    required this.items,
    this.offset = const Offset(0, 4),
    this.targetAnchor = Alignment.bottomCenter,
    this.followerAnchor = Alignment.topCenter,
    required this.open,
    this.onPressOutside,
  });

  /// {@macro remix.component.style}
  final DropdownMenuStyle? style;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  /// The trigger widget that opens the dropdown menu.
  /// It is a builder that returns a widget and a callback to open the menu
  final Widget trigger;

  /// The list of items to display in the dropdown menu.
  /// Each item contains a value and widget to display.
  final List<DropdownMenuItem> items;

  /// The offset of the dropdown menu relative to the trigger widget.
  final Offset offset;

  /// The anchor point on the trigger widget that the dropdown menu should be aligned to.
  final Alignment targetAnchor;

  /// The anchor point on the dropdown menu that the trigger widget should be aligned to.
  final Alignment followerAnchor;

  final bool open;

  final VoidCallback? onPressOutside;

  @override
  State<DropdownMenu> createState() => DropdownMenuState();
}

class DropdownMenuState extends State<DropdownMenu> {
  late final WidgetStatesController _menuStateController;

  final _link = LayerLink();

  @override
  void initState() {
    super.initState();

    _menuStateController = WidgetStatesController()..selected = widget.open;
  }

  @override
  void didUpdateWidget(DropdownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.open != oldWidget.open) {
      _menuStateController.selected = widget.open;
    }
  }

  @override
  void dispose() {
    _menuStateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dropdownMenuStyle =
        widget.style ?? context.remix.components.dropdownMenu;
    final configuration =
        SpecConfiguration(context, DropdownMenuSpecUtility.self);
    final appliedStyle = dropdownMenuStyle
        .makeStyle(configuration)
        .applyVariants(widget.variants);

    final animatedStyle = appliedStyle.cast<AnimatedStyle>();

    return OverlayWrapper(
      target: RepaintBoundary(child: widget.trigger),
      overlayChild: SpecBuilder(
        controller: _menuStateController,
        style: appliedStyle,
        builder: (context) {
          final menu = DropdownMenuSpec.of(context).menu;

          final FlexContainer = menu.container.copyWith(
            box: menu.container.box.copyWith(
              width: menu.autoWidth ? _link.leaderSize!.width : null,
            ),
          );

          return FlexContainer(
            direction: Axis.vertical,
            children: List.generate(widget.items.length, (index) {
              final item = widget.items[index];

              return item;
            }),
          );
        },
      ),
      onTapOutside: widget.onPressOutside,
      showOverlay: widget.open,
      animationDuration: animatedStyle?.animated.duration ?? Duration.zero,
      link: _link,
    );
  }
}
