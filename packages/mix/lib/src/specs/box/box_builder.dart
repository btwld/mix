import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/widget_builder.dart';
import 'box_spec.dart';
import 'box_widget.dart';

/// Default [MixWidgetBuilder] for [BoxSpec], producing a [Box].
class BoxBuilder extends MixWidgetBuilder<BoxSpec> {
  const BoxBuilder();

  @override
  Widget build(
    Style<BoxSpec> style, {
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
    return Box(key: key, style: style, child: child);
  }
}
