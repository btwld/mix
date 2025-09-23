import 'package:flutter/material.dart';

import '../../core/directive.dart';
import '../../core/style_builder.dart';
import '../../core/style_spec.dart';
import '../../core/style_widget.dart';
import 'text_spec.dart';

/// Displays text with Mix styling.
///
/// Applies [TextSpec] for custom text appearance.
class StyledText extends StyleWidget<TextSpec> {
  /// The text to display.
  final String text;

  /// Creates a [StyledText] with required [text] and optional [style] or [spec].
  const StyledText(this.text, {super.style, super.spec, super.key});

  /// Builder pattern for `StyleSpec<TextSpec>` with custom builder function.
  static Widget builder(
    StyleSpec<TextSpec> styleSpec,
    Widget Function(BuildContext context, TextSpec spec) builder,
  ) {
    return StyleSpecBuilder<TextSpec>(builder: builder, styleSpec: styleSpec);
  }

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

/// Extension to convert [TextSpec] directly to a [StyledText] widget.
extension TextSpecWidget on TextSpec {
  /// Creates a [StyledText] widget from this [TextSpec].
  @Deprecated('Use StyledText(text, spec: this) instead')
  Widget createWidget(String text) {
    return StyledText(text, spec: this);
  }

  @Deprecated('Use StyledText(text, spec: this) instead')
  Widget call(String text) {
    return createWidget(text);
  }
}

extension TextSpecWrappedWidget on StyleSpec<TextSpec> {
  /// Creates a widget that resolves this [StyleSpec<TextSpec>] with context.
  @Deprecated(
    'Use StyledText.builder(styleSpec, builder) for custom logic, or styleSpec(text) for simple cases',
  )
  Widget createWidget(String text) {
    return StyledText.builder(this, (context, spec) {
      return StyledText(text, spec: spec);
    });
  }

  /// Convenient shorthand for creating a StyledText widget with this StyleSpec.
  Widget call(String text) {
    return createWidget(text);
  }
}
