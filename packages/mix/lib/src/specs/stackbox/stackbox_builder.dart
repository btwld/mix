import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/widget_builder.dart';
import 'stackbox_spec.dart';
import 'stackbox_widget.dart';

/// Default [MixWidgetBuilder] for [StackBoxSpec], producing a [StackBox].
class StackBoxBuilder extends MixWidgetBuilder<StackBoxSpec> {
  const StackBoxBuilder();

  @override
  Widget build(
    Style<StackBoxSpec> style, {
    Key? key,
    Widget? child,
    List<Widget> children = const <Widget>[],
    String? text,
    IconData? icon,
    String? semanticLabel,
    ImageProvider? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return StackBox(key: key, style: style, children: children);
  }
}
