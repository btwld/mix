import 'package:flutter/widgets.dart';

import '../../public/models/chart_hit.dart';

/// Places a custom widget tooltip above a chart hit and keeps it in bounds.
Widget flWrapTooltipOverlay({
  required Widget child,
  required ChartHit? hit,
  required ChartTooltipBuilder? builder,
  double margin = 12,
}) {
  if (hit == null || builder == null) return child;

  return Builder(
    builder: (context) => Stack(
      fit: .expand,
      clipBehavior: .hardEdge,
      children: [
        child,
        Positioned.fill(
          child: CustomSingleChildLayout(
            delegate: _ChartTooltipLayoutDelegate(
              target: hit.localPosition,
              margin: margin,
            ),
            child: IgnorePointer(child: builder(context, hit)),
          ),
        ),
      ],
    ),
  );
}

final class _ChartTooltipLayoutDelegate extends SingleChildLayoutDelegate {
  final Offset target;
  final double margin;

  const _ChartTooltipLayoutDelegate({
    required this.target,
    required this.margin,
  });

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final preferredLeft = target.dx - childSize.width / 2;
    final preferredTop = target.dy - childSize.height - margin;
    final maxLeft = (size.width - childSize.width).clamp(0.0, double.infinity);
    final maxTop = (size.height - childSize.height).clamp(0.0, double.infinity);

    return Offset(
      preferredLeft.clamp(0.0, maxLeft),
      preferredTop.clamp(0.0, maxTop),
    );
  }

  @override
  bool shouldRelayout(_ChartTooltipLayoutDelegate oldDelegate) =>
      target != oldDelegate.target || margin != oldDelegate.margin;
}
