part of 'segmented_control.dart';

const selectedItem = Variant('selectedItem');

// TODO: Try out the divider using CustomPainter
class SegmentedControl extends StatefulWidget {
  const SegmentedControl({
    super.key,
    this.index = 0,
    this.variants = const [],
    this.style,
    required this.buttons,
    required this.onIndexChanged,
  });

  /// The currently selected index.
  final int index;

  /// Callback that is called when a segment is selected.
  /// The index of the selected segment is passed as an argument.
  final ValueChanged<int> onIndexChanged;

  /// {@macro remix.component.style}
  final SegmentedControlStyle? style;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  /// The list of widgets to display as segments.
  /// Each widget represents one segment in the control.
  final List<SegmentButton> buttons;

  @override
  State<SegmentedControl> createState() => _SegmentedControlState();
}

class _SegmentedControlState extends State<SegmentedControl> {
  late final WidgetStatesController controller;

  @override
  void initState() {
    super.initState();
    controller = WidgetStatesController()..selected = true;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? context.remix.components.segmentedControl;

    final configuration =
        SpecConfiguration(context, SegmentedControlSpecUtility.self);

    final lastIndex = widget.buttons.length - 1;

    return SpecBuilder(
      style: style.makeStyle(configuration).applyVariants(widget.variants),
      builder: (context) {
        final spec = SegmentedControlSpec.of(context);

        return spec.container(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              spec.flex(
                direction: Axis.vertical,
                children: [
                  for (int i = 0; i < widget.buttons.length; i++)
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Pressable(
                          onPress: () => widget.onIndexChanged(i),
                          child: SpecBuilder(
                            controller: i == widget.index ? controller : null,
                            style: style.makeStyle(configuration),
                            builder: (_) {
                              return widget.buttons[i];
                            },
                          ),
                        ),
                        if (i < lastIndex &&
                            spec.showDivider &&
                            widget.index != i &&
                            widget.index - 1 != i)
                          spec.divider(),
                      ],
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
