import 'package:flutter/widgets.dart';
import 'package:mix/experimental.dart';
import 'package:mix/mix.dart';

class RemixBuilder extends StatelessWidget {
  const RemixBuilder({
    super.key,
    required this.builder,
    required this.style,
    required this.mixController,
  });

  final WidgetBuilder builder;
  final Style style;
  final WidgetStatesController mixController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: mixController,
      builder: (_, __) {
        return MixWidgetState.fromSet(
          states: mixController.value,
          child: MixBuilder(style: style, builder: builder),
        );
      },
    );
  }
}
