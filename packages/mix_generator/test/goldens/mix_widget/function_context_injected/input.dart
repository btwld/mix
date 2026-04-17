library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

typedef VoidCallback = void Function();

class ContextButtonSpec {
  const ContextButtonSpec();
}

class ContextButtonStyle extends Style<ContextButtonSpec> {
  final bool compact;

  const ContextButtonStyle({this.compact = false});

  ContextButtonStyle merge(ContextButtonStyle? other) => this;

  ContextButton call({
    required String label,
    required VoidCallback? onPressed,
    bool loading = false,
  }) {
    return ContextButton(
      label: label,
      onPressed: onPressed,
      loading: loading,
      style: this,
    );
  }
}

class ContextButton extends Widget {
  final Key? key;
  final ContextButtonStyle style;
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  const ContextButton({
    this.key,
    this.style = const ContextButtonStyle(),
    required this.label,
    required this.onPressed,
    this.loading = false,
  });
}

@MixWidget(styleable: true)
ContextButtonStyle contextualButtonStyle(
  BuildContext context, {
  bool compact = false,
}) {
  return ContextButtonStyle(compact: compact);
}
