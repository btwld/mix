import 'package:flutter/material.dart';
import 'package:naked/naked.dart';

/// A fully customizable tooltip with no default styling.
///
/// NakedTooltip provides core tooltip behavior and accessibility
/// without imposing any visual styling, giving consumers complete design freedom.
///
/// This component handles showing and hiding tooltips, positioning the tooltip
/// relative to the target widget, and automatically dismissing the tooltip
/// after a specified duration.
///
/// Example:
/// ```dart
// class MyTooltip extends StatefulWidget {
//   @override
//   _MyTooltipState createState() => _MyTooltipState();
// }

// class _MyTooltipState extends State<MyTooltip>
//     with SingleTickerProviderStateMixin {
//   late final _controller = OverlayPortalController();
//   late final animationController = AnimationController(
//     duration: const Duration(milliseconds: 2000),
//     vsync: this,
//   );
//   late final CurvedAnimation _animation;

//   @override
//   void initState() {
//     super.initState();
//     _animation = CurvedAnimation(
//       parent: animationController,
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   void dispose() {
//     animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return NakedTooltip(
//       fallbackAlignments: [
//         AlignmentPair(
//           target: Alignment.topCenter,
//           follower: Alignment.bottomCenter,
//           offset: const Offset(0, -8),
//         ),
//       ],
//       targetAnchor: Alignment.bottomCenter,
//       followerAnchor: Alignment.topCenter,
//       offset: const Offset(0, 8),
//       tooltipWidgetBuilder:
//           (context) => FadeTransition(
//             opacity: _animation,
//             child: Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.grey[800],
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Text(
//                 'This is a tooltip',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//       controller: _controller,
//       child: MouseRegion(
//         onEnter: (_) {
//           _controller.show();
//           animationController.forward();
//         },
//         onExit: (_) {
//           animationController.reverse().then((_) {
//             _controller.hide();
//           });
//         },
//         child: Container(
//           padding: EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: const Color(0xFF2196F3),
//             borderRadius: BorderRadius.circular(4),
//           ),
//           child: Text('Hover me', style: TextStyle(color: Colors.white)),
//         ),
//       ),
//     );
//   }
// }
/// ```

class NakedTooltip extends StatefulWidget {
  /// The widget that triggers the tooltip.
  final Widget child;

  /// The widget to display in the tooltip.
  final WidgetBuilder tooltipWidgetBuilder;

  /// Whether the tooltip is currently visible.
  final OverlayPortalController controller;

  /// The anchor point on the tooltip that should be aligned with the target.
  final Alignment followerAnchor;

  /// The anchor point on the target that the tooltip should be aligned to.
  final Alignment targetAnchor;

  /// The offset of the tooltip from the target widget.
  final Offset offset;

  /// Optional semantic label for accessibility.
  final String? semanticLabel;

  /// The fallback alignments for the tooltip.
  final List<PositionConfig> fallbackAlignments;

  /// Creates a naked tooltip.
  ///
  /// The [child] and [tooltipWidget] parameters are required.
  const NakedTooltip({
    super.key,
    required this.child,
    required this.tooltipWidgetBuilder,
    required this.controller,
    this.followerAnchor = Alignment.bottomCenter,
    this.targetAnchor = Alignment.topCenter,
    this.offset = const Offset(0, -8),
    this.semanticLabel,
    this.fallbackAlignments = const [],
  });

  @override
  State<NakedTooltip> createState() => _NakedTooltipState();
}

class _NakedTooltipState extends State<NakedTooltip> {
  @override
  void dispose() {
    if (widget.controller.isShowing) {
      widget.controller.hide();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: NakedPortal(
        alignment: PositionConfig(
          target: widget.targetAnchor,
          follower: widget.followerAnchor,
          offset: widget.offset,
        ),
        fallbackAlignments: widget.fallbackAlignments,
        overlayChildBuilder: widget.tooltipWidgetBuilder,
        controller: widget.controller,
        child: widget.child,
      ),
    );
  }
}
