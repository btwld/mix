// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'input.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

class Chip extends StatelessWidget {
  const Chip({super.key, required this.color, this.child, this.style});

  final Color color;

  final Widget? child;

  final BoxStyler? style;

  @override
  Widget build(BuildContext context) {
    final baseStyle = chipStyle(color: color);
    final effectiveStyle = baseStyle.merge(style);
    return const BoxBuilder().build(effectiveStyle, key: key, child: child);
  }
}
