import 'package:flutter/material.dart';

import '../../core/directive.dart';
import '../../core/style_builder.dart';
import '../../core/style_widget.dart';
import '../../core/widget_spec.dart';
import 'text_spec.dart';
import 'text_style.dart';

/// Displays text with Mix styling.
///
/// Applies [TextSpec] for custom text appearance.
class StyledText extends StyleWidget<TextSpec> {
  /// Creates a [StyledText] with required [text] and optional [style].
  const StyledText(
    this.text, {
    super.style = const TextStyling.create(),
    super.key,
  });

  /// The text to display.
  final String text;

  @override
  Widget build(BuildContext context, TextSpec spec) {
    return createTextSpecWidget(spec: spec, text: text);
  }
}

/// Creates a [Text] widget from a [TextSpec] and text content.
Text createTextSpecWidget({required TextSpec spec, required String text}) {
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

/// Extension to convert [TextSpec] directly to a [Text] widget.
extension TextSpecWidget on TextSpec {
  Text call(String text) {
    return createTextSpecWidget(spec: this, text: text);
  }
}

extension TextSpecWrappedWidget on StyleSpec<TextSpec> {
  Widget call(String text) {
    return StyleSpecBuilder(
      builder: (context, spec) {
        return createTextSpecWidget(spec: spec, text: text);
      },
      wrappedSpec: this,
    );
  }
}
