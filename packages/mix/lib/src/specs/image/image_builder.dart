import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/widget_builder.dart';
import 'image_spec.dart';
import 'image_widget.dart';

/// Default [MixWidgetBuilder] for [ImageSpec], producing a [StyledImage].
class StyledImageBuilder extends MixWidgetBuilder<ImageSpec> {
  const StyledImageBuilder();

  @override
  Widget build(
    Style<ImageSpec> style, {
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
    return StyledImage(
      key: key,
      style: style,
      image: image,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      opacity: opacity,
    );
  }
}
