import 'package:flutter/material.dart';
import 'package:mix/mix.dart';


final chipButtonLabel = Style.text()
    .fontSize(16)
    .fontWeight(FontWeight.w500)
    .color(Colors.pink);

final chipButtonContainer = Style.box()
    .height(40)
    .width(100)
    .color(Colors.blue)
    .borderRadius(.circular(20))
    .onHovered(.color(Colors.blue.shade700))
    .onPressed(.color(Colors.blue.shade900))
    .wrap(
      .defaultText(chipButtonLabel),
    );

final filterChipContainer = Style.box()
    .height(36)
    .color(Colors.grey.shade200)
    .borderRadius(.circular(18))
    .padding(.symmetric(horizontal: 16, vertical: 8))
    .onHovered(.color(Colors.grey.shade300))
    .onPressed(.color(Colors.grey.shade400))
    .wrap(
      .defaultText(
        Style.text()
            .fontSize(14)
            .fontWeight(FontWeight.w500)
            .color(Colors.grey.shade700),
      ),
    );

final filterChipSelectedContainer = Style.box()
    .height(36)
    .color(Colors.blue.shade100)
    .borderRadius(.circular(18))
    .padding(.symmetric(horizontal: 16, vertical: 8))
    .onHovered(.color(Colors.blue.shade200))
    .onPressed(.color(Colors.blue.shade300))
    .wrap(
      .defaultText(
        Style.text()
            .fontSize(14)
            .fontWeight(FontWeight.w500)
            .color(Colors.blue.shade800),
      ),
    );

 
class ChipButton extends StatelessWidget {
  const ChipButton({
    super.key,
    required this.label,
    required this.onPress,
  });

  final String label;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return PressableBox(
      onPress: onPress,
      style: chipButtonContainer,
      child: Text(label),
    );
  }
}

class FilterChipButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return PressableBox(
      onPress: onPressed,
      style: selected ? filterChipSelectedContainer : filterChipContainer,
      child: Text(label),
    );
  }
}
