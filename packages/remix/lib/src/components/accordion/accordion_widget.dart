part of 'accordion.dart';

class Accordion extends StatefulWidget {
  const Accordion({
    super.key,
    required this.header,
    required this.content,
    this.onChanged,
    this.expanded = true,
    this.variants = const [],
    this.style,
  });

  final WidgetSpecBuilder<AccordionHeaderSpec> header;
  final Widget content;
  final AccordionStyle? style;
  final bool expanded;
  final List<Variant> variants;
  final void Function(bool)? onChanged;

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  late WidgetStatesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WidgetStatesController()..selected = widget.expanded;
  }

  void _handleTap() {
    _controller.selected = !_controller.selected;
    widget.onChanged?.call(widget.expanded);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Accordionstyle = widget.style ?? context.remix.components.accordion;
    final configuration = SpecConfiguration(context, AccordionSpecUtility.self);

    final style =
        Accordionstyle.makeStyle(configuration).applyVariants(widget.variants);

    return RepaintBoundary(
      child: SpecBuilder(
        style: style,
        builder: (context) {
          final spec = AccordionSpec.of(context);

          return spec.container(
            direction: Axis.vertical,
            children: [
              Pressable(
                onPress: _handleTap,
                controller: _controller,
                child: SpecBuilder(
                  style: style,
                  builder: (context) {
                    final spec = AccordionSpec.of(context);

                    return widget.header(spec.header);
                  },
                ),
              ),
              AnimatedAlign(
                alignment: Alignment.topCenter,
                heightFactor: widget.expanded ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: spec.contentContainer(child: widget.content),
              ),
            ],
          );
        },
      ),
    );
  }
}
