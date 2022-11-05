import 'package:flutter/material.dart';

import '../mixer/mix_context.dart';
import '../mixer/mix_context_notifier.dart';
import '../mixer/mix_factory.dart';
import '../variants/variants.dart';
import 'mixable.widget.dart';

typedef WidgetMixBuilder<T> = Widget Function(
  BuildContext context,
  MixContext mixContext,
);

class MixContextBuilder extends MixableWidget {
  const MixContextBuilder({
    required this.builder,
    required Mix mix,
    bool? inherit,
    List<Variant>? variants,
    Key? key,
  }) : super(
          mix,
          key: key,
          inherit: inherit,
          variants: variants,
        );

  final WidgetMixBuilder builder;

  @override
  Widget build(BuildContext context) {
    final mixContext = createMixContext(context);

    return MixContextNotifier(
      mixContext,
      child: builder(
        context,
        mixContext,
      ),
    );
  }
}
