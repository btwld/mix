library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class ContextButtonStyle extends Style<BoxSpec> {
  final bool compact;

  const ContextButtonStyle({this.compact = false});

  ContextButtonStyle merge(ContextButtonStyle? other) => this;

  Box call({Key? key, Widget? child}) {
    return Box(key: key, style: this, child: child);
  }
}

@MixWidget()
ContextButtonStyle contextualButtonStyle(
  BuildContext context, {
  bool compact = false,
  ContextButtonStyle? style,
}) {
  return ContextButtonStyle(compact: compact).merge(style);
}
