import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naked/naked.dart';

class NakedTooltipExample extends StatefulWidget {
  const NakedTooltipExample({super.key});

  @override
  State<NakedTooltipExample> createState() => _NakedTooltipExampleState();
}

class _NakedTooltipExampleState extends State<NakedTooltipExample> {
  Timer? _hoverTimer;
  final controller = OverlayPortalController();

  @override
  void dispose() {
    _hoverTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            MyTooltip(),
          ],
        ),
      ),
    );
  }
}

class MyTooltip extends StatefulWidget {
  const MyTooltip({super.key});

  @override
  MyTooltipState createState() => MyTooltipState();
}

class MyTooltipState extends State<MyTooltip>
    with SingleTickerProviderStateMixin {
  late final _controller = OverlayPortalController();
  late final animationController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final CurvedAnimation _animation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NakedTooltip(
      fallbackAlignments: const [
        AlignmentPair(
          target: Alignment.topCenter,
          follower: Alignment.bottomCenter,
          offset: Offset(0, -8),
        ),
      ],
      targetAnchor: Alignment.bottomCenter,
      followerAnchor: Alignment.topCenter,
      offset: const Offset(0, 8),
      tooltipWidgetBuilder: (context) => FadeTransition(
        opacity: _animation,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'This is a tooltip',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      controller: _controller,
      child: MouseRegion(
        onEnter: (_) {
          _timer?.cancel();
          _timer = Timer(const Duration(seconds: 2), () {
            _controller.show();
            animationController.forward();
          });
        },
        onExit: (_) {
          _timer?.cancel();
          animationController.reverse().then((_) {
            _controller.hide();
          });
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text('Hover me', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
