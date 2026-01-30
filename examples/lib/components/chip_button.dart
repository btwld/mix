import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mix/mix.dart';

final chipButtonLabel = TextStyler(
  textAlign: .center,
  style: TextStyleMix(color: Colors.white, fontSize: 12, fontWeight: .w500),
);

final chipButtonContainer = BoxStyler()
    .height(40)
    .width(120)
    .color(Colors.blue)
    .borderRounded(20)
    .onHovered(BoxStyler().color(Colors.blue.shade700))
    .variant(
      ContextVariant.widgetState(.selected),
      BoxStyler().color(Colors.black),
    )
    .alignment(.center)
    .animate(.easeInOut(300.ms));

class FilterChipButton extends StatefulWidget {
  const FilterChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  State<FilterChipButton> createState() => _FilterChipButtonState();
}

class _FilterChipButtonState extends State<FilterChipButton> {
  late final WidgetStatesController controller;

  @override
  void initState() {
    super.initState();
    controller = WidgetStatesController();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.selected = widget.selected;
    });
  }

  @override
  void didUpdateWidget(FilterChipButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      controller.selected = widget.selected;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPress: widget.onPressed,
      controller: controller,
      child: chipButtonContainer(child: chipButtonLabel(widget.label)),
    );
  }
}
