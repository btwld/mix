import "package:flutter/material.dart";

import "../widget_state_controller.dart";

class MixWidgetStateBuilder extends StatelessWidget {
  const MixWidgetStateBuilder({
    super.key,
    required this.controller,
    required this.builder,
  });

  final WidgetStatesController controller;

  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return MixWidgetStateModel.fromSet(
          states: controller.value,
          child: Builder(builder: builder),
        );
      },
    );
  }
}
