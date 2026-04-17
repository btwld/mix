import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/widget_builder.dart';
import 'text_spec.dart';
import 'text_widget.dart';

/// Default [MixWidgetBuilder] for [TextSpec], producing a [StyledText].
///
/// The source styler's `call(String text)` surfaces `text` as a required
/// positional parameter; the generator forwards it as a named `text:`
/// argument into [build].
class StyledTextBuilder extends MixWidgetBuilder<TextSpec> {
  const StyledTextBuilder();

  @override
  Widget build(
    Style<TextSpec> style, {
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
    assert(text != null, 'StyledTextBuilder requires a non-null text.');
    return StyledText(text!, key: key, style: style);
  }
}
