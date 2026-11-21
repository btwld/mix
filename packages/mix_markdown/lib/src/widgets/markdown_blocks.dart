import 'package:flutter/widgets.dart';

class MarkdownBlocks extends StatelessWidget {
  const MarkdownBlocks({super.key, this.spacing, required this.children});

  final double? spacing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: spacing ?? 0,
    children: children,
  );
}
