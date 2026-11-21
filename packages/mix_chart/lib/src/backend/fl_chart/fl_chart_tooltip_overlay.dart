import 'package:flutter/widgets.dart';

import '../../public/models/chart_hit.dart';

/// Places a widget tooltip above a chart hit, fitting each axis by default.
Widget flWrapTooltipOverlay({
  required Widget child,
  required ChartHit? hit,
  required ChartTooltipBuilder? builder,
  double margin = 12,
  bool fitHorizontally = true,
  bool fitVertically = true,
}) {
  if (hit == null || builder == null) return child;

  return Builder(
    builder: (context) => Stack(
      fit: .expand,
      clipBehavior: fitHorizontally && fitVertically ? .hardEdge : .none,
      children: [
        child,
        Positioned.fill(
          child: CustomSingleChildLayout(
            delegate: _ChartTooltipLayoutDelegate(
              target: hit.localPosition,
              margin: margin,
              fitHorizontally: fitHorizontally,
              fitVertically: fitVertically,
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
  final bool fitHorizontally;
  final bool fitVertically;

  const _ChartTooltipLayoutDelegate({
    required this.target,
    required this.margin,
    required this.fitHorizontally,
    required this.fitVertically,
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
      fitHorizontally ? preferredLeft.clamp(0.0, maxLeft) : preferredLeft,
      fitVertically ? preferredTop.clamp(0.0, maxTop) : preferredTop,
    );
  }

  @override
  bool shouldRelayout(_ChartTooltipLayoutDelegate oldDelegate) =>
      target != oldDelegate.target ||
      margin != oldDelegate.margin ||
      fitHorizontally != oldDelegate.fitHorizontally ||
      fitVertically != oldDelegate.fitVertically;
}
