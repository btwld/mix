import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/widget_builder.dart';
import 'flexbox_spec.dart';
import 'flexbox_widget.dart';

/// Default [MixWidgetBuilder] for [FlexBoxSpec], producing a [FlexBox].
class FlexBoxBuilder extends MixWidgetBuilder<FlexBoxSpec> {
  const FlexBoxBuilder();

  @override
  Widget build(
    Style<FlexBoxSpec> style, {
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
    return FlexBox(key: key, style: style, children: children);
  }
}
