library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class GlassCardBuilder extends MixWidgetBuilder<BoxSpec> {
  const GlassCardBuilder();

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

@MixWidget(widgetBuilder: GlassCardBuilder())
final glassCardStyle = BoxStyler();
