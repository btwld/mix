import 'package:flutter/material.dart';

import '../../core/directive.dart';
import '../../core/style_builder.dart';
import '../../core/style_spec.dart';
import '../../core/style_widget.dart';
import 'text_spec.dart';
import 'text_style.dart';

/// Displays text with Mix styling.
///
/// Applies [TextSpec] for custom text appearance.
class StyledText extends StyleWidget<TextSpec> {
  /// Creates a [StyledText] with required [text] and optional [style] or [spec].
  const StyledText(
    this.text, {
    super.style = const TextStyler.create(),
    super.styleSpec,
    super.key,
  });


  /// The text to display.
  final String text;

  @override
  Widget build(BuildContext context, TextSpec spec) {
    return Text(
      spec.textDirectives?.apply(text) ?? text,
      style: spec.style,
      strutStyle: spec.strutStyle,
      textAlign: spec.textAlign,
      textDirection: spec.textDirection,
      locale: spec.locale,
      softWrap: spec.softWrap,
      overflow: spec.overflow,
      textScaler: spec.textScaler,
      maxLines: spec.maxLines,
      semanticsLabel: spec.semanticsLabel,
      textWidthBasis: spec.textWidthBasis,
      textHeightBehavior: spec.textHeightBehavior,
      selectionColor: spec.selectionColor,
    );
  }
}

extension TextSpecWrappedWidget on StyleSpec<TextSpec> {
  /// Creates a widget that resolves this [StyleSpec<TextSpec>] with context.
  @Deprecated('Use StyledText(text, styleSpec: styleSpec) instead')
  Widget createWidget(String text) {
    return call(text);
  }

  /// Convenient shorthand for creating a StyledText widget with this StyleSpec.
  @Deprecated('Use StyledText(text, styleSpec: styleSpec) instead')
  Widget call(String text) {
    return StyledText(text, styleSpec: this);
  }
}
