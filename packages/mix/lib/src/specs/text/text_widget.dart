import 'package:flutter/material.dart';

import '../../core/spec_widget.dart';
import '../../core/animated_spec_widget.dart';
import '../../core/styled_widget.dart';
import '../../modifiers/internal/render_widget_modifier.dart';
import 'text_spec.dart';

/// [StyledText] - A styled widget for displaying text with a mix of styles.
///
/// This widget extends [StyledWidget] and provides a way to display text with
/// styles defined in a `Style`. It is ideal for creating text elements in your
/// UI where the text styling needs to be dynamic and controlled through a styling system.
///
/// The [StyledText] is particularly useful when you need text elements that adapt
/// their styles based on different conditions or states, providing a more flexible
/// and maintainable approach compared to static styling.
///
/// Parameters:
///   - [text]: The text string to display.
///   - [semanticsLabel]: An optional semantics label for the text, used by screen readers.
///   - [style]: The [Style] to be applied to the text. Inherits from [StyledWidget].
///   - [key]: The key for the widget. Inherits from [StyledWidget].
///   - [inherit]: Determines whether the [StyledText] should inherit styles from its ancestors.
///     Default is `true`. Inherits from [StyledWidget].
///   - [locale]: The locale used for the text, affecting how it is displayed.
///
/// Example usage:
/// ```dart
/// StyledText(
///   'content',
///   style: myStyle,
/// )
/// ```
///
/// This example shows a `StyledText` widget displaying the string 'content'
/// with the styles defined in `myStyle`.
class StyledText extends StyledWidget {
  const StyledText(
    this.text, {
    this.semanticsLabel,
    super.style,
    super.key,
    super.inherit = true,
    this.locale,
    super.orderOfModifiers = const [],
  });

  final String text;
  final String? semanticsLabel;
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return withMix(context, (contextNew) {
      final spec = TextSpec.of(contextNew);

      return spec(text, semanticsLabel: semanticsLabel, locale: locale);
    });
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
        // ignore: deprecated_member_use, deprecated_member_use_from_same_package
        textScaleFactor: spec?.textScaleFactor,
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
