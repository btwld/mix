import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/mix_element.dart';
import '../core/prop.dart';
import '../properties/typography/text_style_mix.dart';
import 'typography_spec.dart';

/// Mix class for configuring [TypographySpec] properties.
///
/// Encapsulates typography properties with support for proper Mix framework integration.
/// Based on Flutter's DefaultTextStyle properties but designed to work with Mix's
/// token system, merging, and resolution pipeline.
final class TypographySpecMix extends Mix<TypographySpec> with Diagnosticable {
  final Prop<TextStyle>? $style;
  final Prop<TextAlign>? $textAlign;
  final Prop<bool>? $softWrap;
  final Prop<TextOverflow>? $overflow;
  final Prop<int>? $maxLines;
  final Prop<TextWidthBasis>? $textWidthBasis;
  final Prop<TextHeightBehavior>? $textHeightBehavior;

  /// Main constructor with user-friendly Mix types
  TypographySpecMix({
    TextStyleMix? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) : this.create(
         style: Prop.maybeMix(style),
         textAlign: Prop.maybe(textAlign),
         softWrap: Prop.maybe(softWrap),
         overflow: Prop.maybe(overflow),
         maxLines: Prop.maybe(maxLines),
         textWidthBasis: Prop.maybe(textWidthBasis),
         textHeightBehavior: Prop.maybe(textHeightBehavior),
       );

  /// Create constructor with Prop\<T\> types for internal use
  const TypographySpecMix.create({
    Prop<TextStyle>? style,
    Prop<TextAlign>? textAlign,
    Prop<bool>? softWrap,
    Prop<TextOverflow>? overflow,
    Prop<int>? maxLines,
    Prop<TextWidthBasis>? textWidthBasis,
    Prop<TextHeightBehavior>? textHeightBehavior,
  }) : $style = style,
       $textAlign = textAlign,
       $softWrap = softWrap,
       $overflow = overflow,
       $maxLines = maxLines,
       $textWidthBasis = textWidthBasis,
       $textHeightBehavior = textHeightBehavior;

  /// Constructor that accepts a [TypographySpec] value and extracts its properties.
  TypographySpecMix.value(TypographySpec spec)
    : this(
        style: TextStyleMix.maybeValue(spec.style),
        textAlign: spec.textAlign,
        softWrap: spec.softWrap,
        overflow: spec.overflow,
        maxLines: spec.maxLines,
        textWidthBasis: spec.textWidthBasis,
        textHeightBehavior: spec.textHeightBehavior,
      );

  // Factory constructors for common use cases

  /// Style factory
  factory TypographySpecMix.style(TextStyleMix value) {
    return TypographySpecMix(style: value);
  }

  /// Text align factory
  factory TypographySpecMix.textAlign(TextAlign value) {
    return TypographySpecMix(textAlign: value);
  }

  /// Soft wrap factory
  factory TypographySpecMix.softWrap(bool value) {
    return TypographySpecMix(softWrap: value);
  }

  /// Overflow factory
  factory TypographySpecMix.overflow(TextOverflow value) {
    return TypographySpecMix(overflow: value);
  }

  /// Max lines factory
  factory TypographySpecMix.maxLines(int value) {
    return TypographySpecMix(maxLines: value);
  }

  /// Text width basis factory
  factory TypographySpecMix.textWidthBasis(TextWidthBasis value) {
    return TypographySpecMix(textWidthBasis: value);
  }

  /// Text height behavior factory
  factory TypographySpecMix.textHeightBehavior(TextHeightBehavior value) {
    return TypographySpecMix(textHeightBehavior: value);
  }

  // Common text style shortcuts

  /// Font size factory
  factory TypographySpecMix.fontSize(double value) {
    return TypographySpecMix(style: TextStyleMix(fontSize: value));
  }

  /// Font weight factory
  factory TypographySpecMix.fontWeight(FontWeight value) {
    return TypographySpecMix(style: TextStyleMix(fontWeight: value));
  }

  /// Color factory
  factory TypographySpecMix.color(Color value) {
    return TypographySpecMix(style: TextStyleMix(color: value));
  }

  /// Font family factory
  factory TypographySpecMix.fontFamily(String value) {
    return TypographySpecMix(style: TextStyleMix(fontFamily: value));
  }

  /// Constructor that accepts a nullable [TypographySpec] value.
  ///
  /// Returns null if the input is null, otherwise uses [TypographySpecMix.value].
  static TypographySpecMix? maybeValue(TypographySpec? spec) {
    return spec != null ? TypographySpecMix.value(spec) : null;
  }

  // Chainable instance methods

  /// Returns a copy with the specified style.
  TypographySpecMix style(TextStyleMix value) {
    return merge(TypographySpecMix.style(value));
  }

  /// Returns a copy with the specified text align.
  TypographySpecMix textAlign(TextAlign value) {
    return merge(TypographySpecMix.textAlign(value));
  }

  /// Returns a copy with the specified soft wrap.
  TypographySpecMix softWrap(bool value) {
    return merge(TypographySpecMix.softWrap(value));
  }

  /// Returns a copy with the specified overflow.
  TypographySpecMix overflow(TextOverflow value) {
    return merge(TypographySpecMix.overflow(value));
  }

  /// Returns a copy with the specified max lines.
  TypographySpecMix maxLines(int value) {
    return merge(TypographySpecMix.maxLines(value));
  }

  /// Returns a copy with the specified text width basis.
  TypographySpecMix textWidthBasis(TextWidthBasis value) {
    return merge(TypographySpecMix.textWidthBasis(value));
  }

  /// Returns a copy with the specified text height behavior.
  TypographySpecMix textHeightBehavior(TextHeightBehavior value) {
    return merge(TypographySpecMix.textHeightBehavior(value));
  }

  /// Returns a copy with the specified font size.
  TypographySpecMix fontSize(double value) {
    return merge(TypographySpecMix.fontSize(value));
  }

  /// Returns a copy with the specified font weight.
  TypographySpecMix fontWeight(FontWeight value) {
    return merge(TypographySpecMix.fontWeight(value));
  }

  /// Returns a copy with the specified color.
  TypographySpecMix color(Color value) {
    return merge(TypographySpecMix.color(value));
  }

  /// Returns a copy with the specified font family.
  TypographySpecMix fontFamily(String value) {
    return merge(TypographySpecMix.fontFamily(value));
  }

  /// Resolves to [TypographySpec] using the provided [BuildContext].
  @override
  TypographySpec resolve(BuildContext context) {
    return TypographySpec(
      style: MixOps.resolve(context, $style),
      textAlign: MixOps.resolve(context, $textAlign),
      softWrap: MixOps.resolve(context, $softWrap),
      overflow: MixOps.resolve(context, $overflow),
      maxLines: MixOps.resolve(context, $maxLines),
      textWidthBasis: MixOps.resolve(context, $textWidthBasis),
      textHeightBehavior: MixOps.resolve(context, $textHeightBehavior),
    );
  }

  /// Merges the properties of this [TypographySpecMix] with the properties of [other].
  @override
  TypographySpecMix merge(TypographySpecMix? other) {
    if (other == null) return this;

    return TypographySpecMix.create(
      style: MixOps.merge($style, other.$style),
      textAlign: MixOps.merge($textAlign, other.$textAlign),
      softWrap: MixOps.merge($softWrap, other.$softWrap),
      overflow: MixOps.merge($overflow, other.$overflow),
      maxLines: MixOps.merge($maxLines, other.$maxLines),
      textWidthBasis: MixOps.merge($textWidthBasis, other.$textWidthBasis),
      textHeightBehavior: MixOps.merge($textHeightBehavior, other.$textHeightBehavior),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('style', $style))
      ..add(DiagnosticsProperty('textAlign', $textAlign))
      ..add(DiagnosticsProperty('softWrap', $softWrap))
      ..add(DiagnosticsProperty('overflow', $overflow))
      ..add(DiagnosticsProperty('maxLines', $maxLines))
      ..add(DiagnosticsProperty('textWidthBasis', $textWidthBasis))
      ..add(DiagnosticsProperty('textHeightBehavior', $textHeightBehavior));
  }

  @override
  List<Object?> get props => [
    $style,
    $textAlign,
    $softWrap,
    $overflow,
    $maxLines,
    $textWidthBasis,
    $textHeightBehavior,
  ];
}