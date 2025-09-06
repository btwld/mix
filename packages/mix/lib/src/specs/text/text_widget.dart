import 'package:flutter/material.dart';

import '../../core/animated_spec_widget.dart';
import '../../core/spec_widget.dart';
import '../../core/styled_widget.dart';
import '../../modifiers/internal/render_widget_modifier.dart';
import 'text_spec.dart';

/// A styled text widget for displaying text with Mix styling.
///
/// Applies [TextSpec] styling to display text with custom appearance.
/// Supports style inheritance from ancestor [StyledWidget]s.
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
class StyledText extends StyledWidget {
  /// Creates a styled text widget.
  const StyledText(
    this.text, {
    this.semanticsLabel,
    super.style,
    super.key,
    super.inherit = true,
    this.locale,
    super.orderOfModifiers = const [],
  });

  /// Text content to display.
  final String text;

  /// Alternative semantics label for accessibility.
  final String? semanticsLabel;

  /// Locale for text rendering and formatting.
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return SpecBuilder(
      inherit: inherit,
      style: style,
      orderOfModifiers: orderOfModifiers,
      builder: (context) {
        final spec = TextSpec.of(context);

        return spec(text, semanticsLabel: semanticsLabel, locale: locale);
      },
    );
  }
}

class TextSpecWidget extends SpecWidget<TextSpec> {
  const TextSpecWidget(
    this.text, {
    super.spec,
    this.semanticsLabel,
    this.locale,
    this.orderOfModifiers = const [],
    super.key,
  });

  final String text;
  final String? semanticsLabel;
  final Locale? locale;
  final List<Type> orderOfModifiers;

  @override
  Widget build(BuildContext context) {
    // The Text widget is used here, applying the resolved styles and properties from TextSpec.
    return RenderSpecModifiers(
      spec: spec ?? const TextSpec(),
      orderOfModifiers: orderOfModifiers,
      child: Text(
        spec?.directive?.apply(text) ?? text,
        style: spec?.style,
        strutStyle: spec?.strutStyle,
        textAlign: spec?.textAlign,
        textDirection: spec?.textDirection,
        locale: locale,
        softWrap: spec?.softWrap,
        overflow: spec?.overflow,
        textScaler: spec?.textScaler,
        maxLines: spec?.maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: spec?.textWidthBasis,
        textHeightBehavior: spec?.textHeightBehavior,
      ),
    );
  }
}

class AnimatedTextSpecWidget extends ImplicitlyAnimatedSpecWidget<TextSpec> {
  const AnimatedTextSpecWidget(
    this.text, {
    required super.spec,
    this.semanticsLabel,
    this.locale,
    this.orderOfModifiers = const [],
    super.key,
    required super.duration,
    super.curve = Curves.linear,
    super.onEnd,
  });

  final String text;
  final String? semanticsLabel;
  final Locale? locale;
  final List<Type> orderOfModifiers;

  @override
  Widget build(BuildContext context, TextSpec animatedSpec) {
    return TextSpecWidget(
      text,
      spec: animatedSpec,
      semanticsLabel: semanticsLabel,
      locale: locale,
      orderOfModifiers: orderOfModifiers,
    );
  }
}
