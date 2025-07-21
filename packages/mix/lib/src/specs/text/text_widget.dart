import 'package:flutter/material.dart';

import '../../core/style_widget.dart';
import 'text_spec.dart';

/// A styled text widget for displaying text with Mix styling.
///
/// Applies [TextSpec] styling to display text with custom appearance.
/// Supports style inheritance from ancestor [StyleWidget]s.
///
/// Example:
/// ```dart
/// StyledText(
///   'Hello World',
///   style: Style(
///     $text.color.red(),
///     $text.fontSize(16),
///   ),
/// )
/// ```
class StyledText extends StyleWidget<TextSpec> {
  /// Creates a styled text widget.
  const StyledText(
    this.text, {
    this.semanticsLabel,
    super.style = const TextStyling(),
    super.key,

    this.locale,
    super.orderOfModifiers,
  });

  /// Text content to display.
  final String text;

  /// Alternative semantics label for accessibility.
  final String? semanticsLabel;

  /// Locale for text rendering and formatting.
  final Locale? locale;

  @override
  Widget build(BuildContext context, TextSpec spec) {
    return Text(
      spec.directives?.apply(text) ?? text,
      style: spec.style,
      strutStyle: spec.strutStyle,
      textAlign: spec.textAlign,
      textDirection: spec.textDirection,
      locale: locale,
      softWrap: spec.softWrap,
      overflow: spec.overflow,
      textScaler: spec.textScaler,
      maxLines: spec.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: spec.textWidthBasis,
      textHeightBehavior: spec.textHeightBehavior,
    );
  }
}
