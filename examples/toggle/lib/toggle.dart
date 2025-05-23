import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

part 'toggle.style.dart';

class Toggle extends StatefulWidget {
  const Toggle({super.key});

  @override
  State<Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {

  late MixWidgetStateController controller;

  @override
  void initState() {
    super.initState();
    controller = MixWidgetStateController()..selected = false;
  }

  void _handleToggle() {
    setState(() {
      controller.selected = !controller.selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Pressable(
      controller: controller,
      onPress: _handleToggle,
      child: Box(
        style: _containerStyle(),
        child: Box(
          style: _outerCircleStyle(),
          child: Box(
            style: _innerCircleStyle(),
          ),
        ),
      ),
    );
  }
}