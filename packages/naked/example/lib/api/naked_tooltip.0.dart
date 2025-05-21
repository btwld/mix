import 'package:flutter/material.dart';
import 'package:naked/naked.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: MyTooltip(),
        ),
      ),
    );
  }
}

class MyTooltip extends StatefulWidget {
  const MyTooltip({super.key});

  @override
  State<MyTooltip> createState() => _MyTooltipState();
}

class _MyTooltipState extends State<MyTooltip>
    with SingleTickerProviderStateMixin {
  late final _controller = OverlayPortalController();
  late final _animationController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeOutCubic,
  );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NakedTooltip(
      targetAnchor: Alignment.topCenter,
      followerAnchor: Alignment.bottomCenter,
      offset: const Offset(0, -4),
      tooltipBuilder: (context) => FadeTransition(
        opacity: _animation,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[700],
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
          _controller.show();
          _animationController.forward();
        },
        onExit: (_) {
          _animationController.reverse().then((_) {
            _controller.hide();
          });
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF3D3D3D),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text('Hover me', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
