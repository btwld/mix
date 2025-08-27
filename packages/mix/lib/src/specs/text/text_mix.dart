import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/directive.dart';
import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import '../../properties/typography/strut_style_mix.dart';
import '../../properties/typography/text_height_behavior_mix.dart';
import '../../properties/typography/text_style_mix.dart';
import 'text_spec.dart';
import 'text_style.dart';

/// Mix class for configuring [TextSpec] properties.
///
/// Encapsulates text properties with support for proper Mix framework integration.
/// Combines both per-text and ambient text styling capabilities.
final class TextMix extends Mix<TextSpec> with Diagnosticable {
  final Prop<TextOverflow>? $overflow;
  final Prop<StrutStyle>? $strutStyle;
  final Prop<TextAlign>? $textAlign;
  final Prop<TextScaler>? $textScaler;
  final Prop<int>? $maxLines;
  final Prop<TextStyle>? $style;
  final Prop<TextWidthBasis>? $textWidthBasis;
  final Prop<TextHeightBehavior>? $textHeightBehavior;
  final Prop<TextDirection>? $textDirection;
  final Prop<bool>? $softWrap;
  final List<Directive<String>>? $textDirectives;
  final Prop<Color>? $selectionColor;
  final Prop<String>? $semanticsLabel;
  final Prop<Locale>? $locale;

  /// Main constructor with user-friendly Mix types
  TextMix({
    TextOverflow? overflow,
    StrutStyleMix? strutStyle,
    TextAlign? textAlign,
    TextScaler? textScaler,
    int? maxLines,
    TextStyleMix? style,
    TextWidthBasis? textWidthBasis,
    TextHeightBehaviorMix? textHeightBehavior,
    TextDirection? textDirection,
    bool? softWrap,
    List<Directive<String>>? textDirectives,
    Color? selectionColor,
    String? semanticsLabel,
    Locale? locale,
  }) : this.create(
         overflow: Prop.maybe(overflow),
         strutStyle: Prop.maybeMix(strutStyle),
         textAlign: Prop.maybe(textAlign),
         textScaler: Prop.maybe(textScaler),
         maxLines: Prop.maybe(maxLines),
         style: Prop.maybeMix(style),
         textWidthBasis: Prop.maybe(textWidthBasis),
         textHeightBehavior: Prop.maybeMix(textHeightBehavior),
         textDirection: Prop.maybe(textDirection),
         softWrap: Prop.maybe(softWrap),
         textDirectives: textDirectives,
         selectionColor: Prop.maybe(selectionColor),
         semanticsLabel: Prop.maybe(semanticsLabel),
         locale: Prop.maybe(locale),
       );

  /// Create constructor with `Prop<T>` types for internal use
  const TextMix.create({
    Prop<TextOverflow>? overflow,
    Prop<StrutStyle>? strutStyle,
    Prop<TextAlign>? textAlign,
    Prop<TextScaler>? textScaler,
    Prop<int>? maxLines,
    Prop<TextStyle>? style,
    Prop<TextWidthBasis>? textWidthBasis,
    Prop<TextHeightBehavior>? textHeightBehavior,
    Prop<TextDirection>? textDirection,
    Prop<bool>? softWrap,
    List<Directive<String>>? textDirectives,
    Prop<Color>? selectionColor,
    Prop<String>? semanticsLabel,
    Prop<Locale>? locale,
  }) : $overflow = overflow,
       $strutStyle = strutStyle,
       $textAlign = textAlign,
       $textScaler = textScaler,
       $maxLines = maxLines,
       $style = style,
       $textWidthBasis = textWidthBasis,
       $textHeightBehavior = textHeightBehavior,
       $textDirection = textDirection,
       $softWrap = softWrap,
       $textDirectives = textDirectives,
       $selectionColor = selectionColor,
       $semanticsLabel = semanticsLabel,
       $locale = locale;

  /// Factory constructor to create TextMix from TextSpec.
  static TextMix value(TextSpec spec) {
    return TextMix(
      overflow: spec.overflow,
      strutStyle: StrutStyleMix.maybeValue(spec.strutStyle),
      textAlign: spec.textAlign,
      textScaler: spec.textScaler,
      maxLines: spec.maxLines,
      style: TextStyleMix.maybeValue(spec.style),
      textWidthBasis: spec.textWidthBasis,
      textHeightBehavior: TextHeightBehaviorMix.maybeValue(spec.textHeightBehavior),
      textDirection: spec.textDirection,
      softWrap: spec.softWrap,
      textDirectives: spec.textDirectives,
      selectionColor: spec.selectionColor,
      semanticsLabel: spec.semanticsLabel,
      locale: spec.locale,
    );
  }

  /// Constructor that accepts a nullable [TextSpec] value.
  ///
  /// Returns null if the input is null, otherwise uses [TextMix.value].
  static TextMix? maybeValue(TextSpec? spec) {
    return spec != null ? TextMix.value(spec) : null;
  }

  // Chainable instance methods

  /// Returns a copy with the specified overflow.
  TextMix overflow(TextOverflow value) {
    return merge(TextMix(overflow: value));
  }

  /// Returns a copy with the specified strut style.
  TextMix strutStyle(StrutStyleMix value) {
    return merge(TextMix(strutStyle: value));
  }

  /// Returns a copy with the specified text align.
  TextMix textAlign(TextAlign value) {
    return merge(TextMix(textAlign: value));
  }

  /// Returns a copy with the specified text scaler.
  TextMix textScaler(TextScaler value) {
    return merge(TextMix(textScaler: value));
  }

  /// Returns a copy with the specified max lines.
  TextMix maxLines(int value) {
    return merge(TextMix(maxLines: value));
  }

  /// Returns a copy with the specified style.
  TextMix style(TextStyleMix value) {
    return merge(TextMix(style: value));
  }

  /// Returns a copy with the specified text width basis.
  TextMix textWidthBasis(TextWidthBasis value) {
    return merge(TextMix(textWidthBasis: value));
  }

  /// Returns a copy with the specified text height behavior.
  TextMix textHeightBehavior(TextHeightBehaviorMix value) {
    return merge(TextMix(textHeightBehavior: value));
  }

  /// Returns a copy with the specified text direction.
  TextMix textDirection(TextDirection value) {
    return merge(TextMix(textDirection: value));
  }

  /// Returns a copy with the specified soft wrap.
  TextMix softWrap(bool value) {
    return merge(TextMix(softWrap: value));
  }

  /// Returns a copy with the specified text directives.
  TextMix textDirectives(List<Directive<String>> value) {
    return merge(TextMix(textDirectives: value));
  }

  /// Returns a copy with the specified selection color.
  TextMix selectionColor(Color value) {
    return merge(TextMix(selectionColor: value));
  }

  /// Returns a copy with the specified semantics label.
  TextMix semanticsLabel(String value) {
    return merge(TextMix(semanticsLabel: value));
  }

  /// Returns a copy with the specified locale.
  TextMix locale(Locale value) {
    return merge(TextMix(locale: value));
  }

  /// Resolves to [TextSpec] using the provided [BuildContext].
  @override
  TextSpec resolve(BuildContext context) {
    return TextSpec(
      overflow: MixOps.resolve(context, $overflow),
      strutStyle: MixOps.resolve(context, $strutStyle),
      textAlign: MixOps.resolve(context, $textAlign),
      textScaler: MixOps.resolve(context, $textScaler),
      maxLines: MixOps.resolve(context, $maxLines),
      style: MixOps.resolve(context, $style),
      textWidthBasis: MixOps.resolve(context, $textWidthBasis),
      textHeightBehavior: MixOps.resolve(context, $textHeightBehavior),
      textDirection: MixOps.resolve(context, $textDirection),
      softWrap: MixOps.resolve(context, $softWrap),
      textDirectives: $textDirectives,
      selectionColor: MixOps.resolve(context, $selectionColor),
      semanticsLabel: MixOps.resolve(context, $semanticsLabel),
      locale: MixOps.resolve(context, $locale),
    );
  }

  /// Merges the properties of this [TextMix] with the properties of [other].
  @override
  TextMix merge(TextMix? other) {
    if (other == null) return this;

    return TextMix.create(
      overflow: MixOps.merge($overflow, other.$overflow),
      strutStyle: MixOps.merge($strutStyle, other.$strutStyle),
      textAlign: MixOps.merge($textAlign, other.$textAlign),
      textScaler: MixOps.merge($textScaler, other.$textScaler),
      maxLines: MixOps.merge($maxLines, other.$maxLines),
      style: MixOps.merge($style, other.$style),
      textWidthBasis: MixOps.merge($textWidthBasis, other.$textWidthBasis),
      textHeightBehavior: MixOps.merge($textHeightBehavior, other.$textHeightBehavior),
      textDirection: MixOps.merge($textDirection, other.$textDirection),
      softWrap: MixOps.merge($softWrap, other.$softWrap),
      textDirectives: other.$textDirectives ?? $textDirectives,
      selectionColor: MixOps.merge($selectionColor, other.$selectionColor),
      semanticsLabel: MixOps.merge($semanticsLabel, other.$semanticsLabel),
      locale: MixOps.merge($locale, other.$locale),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('overflow', $overflow))
      ..add(DiagnosticsProperty('strutStyle', $strutStyle))
      ..add(DiagnosticsProperty('textAlign', $textAlign))
      ..add(DiagnosticsProperty('textScaler', $textScaler))
      ..add(DiagnosticsProperty('maxLines', $maxLines))
      ..add(DiagnosticsProperty('style', $style))
      ..add(DiagnosticsProperty('textWidthBasis', $textWidthBasis))
      ..add(DiagnosticsProperty('textHeightBehavior', $textHeightBehavior))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('softWrap', $softWrap))
      ..add(DiagnosticsProperty('textDirectives', $textDirectives))
      ..add(DiagnosticsProperty('selectionColor', $selectionColor))
      ..add(DiagnosticsProperty('semanticsLabel', $semanticsLabel))
      ..add(DiagnosticsProperty('locale', $locale));
  }

  @override
  List<Object?> get props => [
    $overflow,
    $strutStyle,
    $textAlign,
    $textScaler,
    $maxLines,
    $style,
    $textWidthBasis,
    $textHeightBehavior,
    $textDirection,
    $softWrap,
    $textDirectives,
    $selectionColor,
    $semanticsLabel,
    $locale,
  ];
}

/// Extension to provide toStyle() method for TextMix
extension TextMixToStyle on TextMix {
  /// Converts this TextMix to a TextStyling
  TextStyling toStyle() => TextStyling.from(this);
}