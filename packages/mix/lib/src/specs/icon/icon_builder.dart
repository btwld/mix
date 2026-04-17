import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/widget_builder.dart';
import 'icon_spec.dart';
import 'icon_widget.dart';

/// Default [MixWidgetBuilder] for [IconSpec], producing a [StyledIcon].
class StyledIconBuilder extends MixWidgetBuilder<IconSpec> {
  const StyledIconBuilder();

  @override
  Widget build(
    Style<IconSpec> style, {
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
    return StyledIcon(
      key: key,
      style: style,
      icon: icon,
      semanticLabel: semanticLabel,
    );
  }
}
