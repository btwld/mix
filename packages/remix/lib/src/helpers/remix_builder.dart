import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:mix/experimental.dart';
import 'package:mix/mix.dart';

@internal
class RemixBuilder extends StatelessWidget {
  const RemixBuilder({
    super.key,
    required this.builder,
    required this.style,
    required this.controller,
  });

  final WidgetBuilder builder;
  final BaseStyle<SpecAttribute> style;
  final WidgetStatesController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (_, __) {
        return MixWidgetStateModel.fromSet(
          states: controller.value,
          child: MixBuilder(style: Style(style), builder: builder),
        );
      },
    );
  }
}
