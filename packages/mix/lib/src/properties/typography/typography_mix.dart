import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import 'text_style_mix.dart';
import 'typography_spec.dart';

/// Mix class for configuring [TypographySpec] properties.
///
/// Encapsulates typography properties with support for proper Mix framework integration.
/// Based on Flutter's DefaultTextStyle properties but designed to work with Mix's
/// token system, merging, and resolution pipeline.
final class TypographyMix extends Mix<TypographySpec> with Diagnosticable {
  final Prop<TextStyle>? $style;
  final Prop<TextAlign>? $textAlign;
  final Prop<bool>? $softWrap;
  final Prop<TextOverflow>? $overflow;
  final Prop<int>? $maxLines;
  final Prop<TextWidthBasis>? $textWidthBasis;
  final Prop<TextHeightBehavior>? $textHeightBehavior;

  /// Main constructor with user-friendly Mix types
  TypographyMix({
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
  const TypographyMix.create({
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
  TypographyMix.value(TypographySpec spec)
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
  factory TypographyMix.style(TextStyleMix value) {
    return TypographyMix(style: value);
  }

  /// Text align factory
  factory TypographyMix.textAlign(TextAlign value) {
    return TypographyMix(textAlign: value);
  }

  /// Soft wrap factory
  factory TypographyMix.softWrap(bool value) {
    return TypographyMix(softWrap: value);
  }

  /// Overflow factory
  factory TypographyMix.overflow(TextOverflow value) {
    return TypographyMix(overflow: value);
  }

  /// Max lines factory
  factory TypographyMix.maxLines(int value) {
    return TypographyMix(maxLines: value);
  }

  /// Text width basis factory
  factory TypographyMix.textWidthBasis(TextWidthBasis value) {
    return TypographyMix(textWidthBasis: value);
  }

  /// Text height behavior factory
  factory TypographyMix.textHeightBehavior(TextHeightBehavior value) {
    return TypographyMix(textHeightBehavior: value);
  }

  // Common text style shortcuts

  /// Font size factory
  factory TypographyMix.fontSize(double value) {
    return TypographyMix(style: TextStyleMix(fontSize: value));
  }

  /// Font weight factory
  factory TypographyMix.fontWeight(FontWeight value) {
    return TypographyMix(style: TextStyleMix(fontWeight: value));
  }

  /// Color factory
  factory TypographyMix.color(Color value) {
    return TypographyMix(style: TextStyleMix(color: value));
  }

  /// Font family factory
  factory TypographyMix.fontFamily(String value) {
    return TypographyMix(style: TextStyleMix(fontFamily: value));
  }

  /// Constructor that accepts a nullable [TypographySpec] value.
  ///
  /// Returns null if the input is null, otherwise uses [TypographyMix.value].
  static TypographyMix? maybeValue(TypographySpec? spec) {
    return spec != null ? TypographyMix.value(spec) : null;
  }

  // Chainable instance methods

  /// Returns a copy with the specified style.
  TypographyMix style(TextStyleMix value) {
    return merge(TypographyMix.style(value));
  }

  /// Returns a copy with the specified text align.
  TypographyMix textAlign(TextAlign value) {
    return merge(TypographyMix.textAlign(value));
  }

  /// Returns a copy with the specified soft wrap.
  TypographyMix softWrap(bool value) {
    return merge(TypographyMix.softWrap(value));
  }

  /// Returns a copy with the specified overflow.
  TypographyMix overflow(TextOverflow value) {
    return merge(TypographyMix.overflow(value));
  }

  /// Returns a copy with the specified max lines.
  TypographyMix maxLines(int value) {
    return merge(TypographyMix.maxLines(value));
  }

  /// Returns a copy with the specified text width basis.
  TypographyMix textWidthBasis(TextWidthBasis value) {
    return merge(TypographyMix.textWidthBasis(value));
  }

  /// Returns a copy with the specified text height behavior.
  TypographyMix textHeightBehavior(TextHeightBehavior value) {
    return merge(TypographyMix.textHeightBehavior(value));
  }

  /// Returns a copy with the specified font size.
  TypographyMix fontSize(double value) {
    return merge(TypographyMix.fontSize(value));
  }

  /// Returns a copy with the specified font weight.
  TypographyMix fontWeight(FontWeight value) {
    return merge(TypographyMix.fontWeight(value));
  }

  /// Returns a copy with the specified color.
  TypographyMix color(Color value) {
    return merge(TypographyMix.color(value));
  }

  /// Returns a copy with the specified font family.
  TypographyMix fontFamily(String value) {
    return merge(TypographyMix.fontFamily(value));
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

  /// Merges the properties of this [TypographyMix] with the properties of [other].
  @override
  TypographyMix merge(TypographyMix? other) {
    if (other == null) return this;

    return TypographyMix.create(
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