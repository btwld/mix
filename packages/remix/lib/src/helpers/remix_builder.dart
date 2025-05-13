import 'package:flutter/widgets.dart';
import 'package:mix/experimental.dart';
import 'package:mix/mix.dart';

class RemixBuilder extends StatelessWidget {
  const RemixBuilder({
    super.key,
    required this.builder,
    required this.style,
    required this.states,
  });

  final WidgetBuilder builder;
  final Style style;
  final Set<WidgetState> states;

  @override
  Widget build(BuildContext context) {
    return MixWidgetState.fromSet(
      states: states,
      child: MixBuilder(
        style: style,
        builder: builder,
      ),
    );
  }
}
