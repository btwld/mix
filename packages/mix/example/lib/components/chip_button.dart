import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mix/mix.dart';

final chipButtonLabel = TextStyler(
  style: TextStyleMix(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  ),
  textAlign: TextAlign.center,
);

final chipButtonContainer = BoxStyler()
    .height(40)
    .width(120)
    .color(Colors.blue)
    .borderRounded(20)
    .onHovered(BoxStyler().color(Colors.blue.shade700))
    .onSelected(BoxStyler().color(Colors.black))
    .alignment(Alignment.center)
    .wrap(WidgetModifierConfig.defaultText(chipButtonLabel))
    .animate(AnimationConfig.easeInOut(300.ms));

class FilterChipButton extends StatefulWidget {
  final String label;

  final bool selected;
  final VoidCallback onPressed;
  const FilterChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

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
      child: Box(style: chipButtonContainer, child: Text(widget.label)),
    );
  }
}
