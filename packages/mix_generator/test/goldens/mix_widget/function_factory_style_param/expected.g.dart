// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'input.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

class Chip extends StatelessWidget {
  const Chip({super.key, required this.color, this.style, this.child});

  final Color color;

  final BoxStyler? style;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return chipStyle(color: color, style: style).call(key: key, child: child);
  }
}
