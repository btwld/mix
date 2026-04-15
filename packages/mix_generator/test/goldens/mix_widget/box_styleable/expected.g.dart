// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'input.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

class Card extends StatelessWidget {
  final Widget? child;
  final BoxStyler? style;

  const Card({super.key, this.child, this.style});

  @override
  Widget build(BuildContext context) {
    final baseStyle = cardStyle;
    final effectiveStyle = baseStyle.merge(style);
    return Box(child: child, key: key, style: effectiveStyle);
  }
}
