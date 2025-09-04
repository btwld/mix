import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../animation/animation_mixin.dart';
import '../../core/directive.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/style_spec.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/typography/strut_style_mix.dart';
import '../../properties/typography/text_height_behavior_mix.dart';
import '../../properties/typography/text_style_mix.dart';
import '../../properties/typography/text_style_mixin.dart';
import '../../variants/variant_util.dart';
import 'text_spec.dart';
import 'text_util.dart';
import 'text_widget.dart';

typedef TextMix = TextStyler;

/// Represents the attributes of a [TextSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [TextSpec].
///
/// Use this class to configure the attributes of a [TextSpec] and pass it to
/// the [TextSpec] constructor.
class TextStyler extends Style<TextSpec>
    with
        Diagnosticable,
        StyleModifierMixin<TextStyler, TextSpec>,
        StyleVariantMixin<TextStyler, TextSpec>,
        TextStyleMixin<TextStyler>,
        StyleAnimationMixin<TextSpec, TextStyler> {
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

  const TextStyler.create({
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
    super.animation,
    super.modifier,
    super.variants,
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

  TextStyler({
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
    AnimationConfig? animation,
    ModifierConfig? modifier,
    List<VariantStyle<TextSpec>>? variants,
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
         animation: animation,
         modifier: modifier,
         variants: variants,
       );

  factory TextStyler.builder(TextStyler Function(BuildContext) fn) {
    return TextStyler().builder(fn);
  }

  static TextSpecUtility get chain => TextSpecUtility(TextStyler());

  StyledText call(String text) {
    return StyledText(text, style: this);
  }

  TextStyler textDirective(Directive<String> value) {
    return merge(TextStyler(textDirectives: [value]));
  }

  /// Sets text overflow behavior
  TextStyler overflow(TextOverflow value) {
    return merge(TextStyler(overflow: value));
  }

  /// Sets strut style
  TextStyler strutStyle(StrutStyleMix value) {
    return merge(TextStyler(strutStyle: value));
  }

  /// Sets text alignment
  TextStyler textAlign(TextAlign value) {
    return merge(TextStyler(textAlign: value));
  }

  /// Sets text scaler
  TextStyler textScaler(TextScaler value) {
    return merge(TextStyler(textScaler: value));
  }

  /// Sets maximum number of lines
  TextStyler maxLines(int value) {
    return merge(TextStyler(maxLines: value));
  }

  /// Sets text width basis
  TextStyler textWidthBasis(TextWidthBasis value) {
    return merge(TextStyler(textWidthBasis: value));
  }

  /// Sets text height behavior
  TextStyler textHeightBehavior(TextHeightBehaviorMix value) {
    return merge(TextStyler(textHeightBehavior: value));
  }

  /// Sets text direction
  TextStyler textDirection(TextDirection value) {
    return merge(TextStyler(textDirection: value));
  }

  /// Sets soft wrap behavior
  TextStyler softWrap(bool value) {
    return merge(TextStyler(softWrap: value));
  }

  /// Adds a text directive
  TextStyler directive(Directive<String> value) {
    return merge(TextStyler(textDirectives: [value]));
  }

  /// Sets selection color
  TextStyler selectionColor(Color value) {
    return merge(TextStyler(selectionColor: value));
  }

  /// Sets semantics label
  TextStyler semanticsLabel(String value) {
    return merge(TextStyler(semanticsLabel: value));
  }

  /// Sets locale
  TextStyler locale(Locale value) {
    return merge(TextStyler(locale: value));
  }

  /// Applies uppercase directive
  TextStyler uppercase() {
    return merge(
      TextStyler(textDirectives: [const UppercaseStringDirective()]),
    );
  }

  /// Applies lowercase directive
  TextStyler lowercase() {
    return merge(
      TextStyler(textDirectives: [const LowercaseStringDirective()]),
    );
  }

  /// Applies capitalize directive
  TextStyler capitalize() {
    return merge(
      TextStyler(textDirectives: [const CapitalizeStringDirective()]),
    );
  }

  /// Applies title case directive
  TextStyler titleCase() {
    return merge(
      TextStyler(textDirectives: [const TitleCaseStringDirective()]),
    );
  }

  /// Applies sentence case directive
  TextStyler sentenceCase() {
    return merge(
      TextStyler(textDirectives: [const SentenceCaseStringDirective()]),
    );
  }

  TextStyler modifier(ModifierConfig value) {
    return merge(TextStyler(modifier: value));
  }

  /// Mixin implementation for text styling
  @override
  TextStyler style(TextStyleMix value) {
    return merge(TextStyler(style: value));
  }

  /// Convenience method for animating the TextSpec
  @override
  TextStyler animate(AnimationConfig animation) {
    return merge(TextStyler(animation: animation));
  }

  @override
  TextStyler variants(List<VariantStyle<TextSpec>> variants) {
    return merge(TextStyler(variants: variants));
  }

  /// Resolves to [TextSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final textSpec = TextStyle(...).resolve(context);
  /// ```
  @override
  StyleSpec<TextSpec> resolve(BuildContext context) {
    final textSpec = TextSpec(
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

    return StyleSpec(
      spec: textSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  /// Merges the properties of this [TextStyle] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [TextStyle] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  TextStyler merge(TextStyler? other) {
    return TextStyler.create(
      overflow: MixOps.merge($overflow, other?.$overflow),
      strutStyle: MixOps.merge($strutStyle, other?.$strutStyle),
      textAlign: MixOps.merge($textAlign, other?.$textAlign),
      textScaler: MixOps.merge($textScaler, other?.$textScaler),
      maxLines: MixOps.merge($maxLines, other?.$maxLines),
      style: MixOps.merge($style, other?.$style),
      textWidthBasis: MixOps.merge($textWidthBasis, other?.$textWidthBasis),
      textHeightBehavior: MixOps.merge(
        $textHeightBehavior,
        other?.$textHeightBehavior,
      ),
      textDirection: MixOps.merge($textDirection, other?.$textDirection),
      softWrap: MixOps.merge($softWrap, other?.$softWrap),
      textDirectives: MixOps.mergeList($textDirectives, other?.$textDirectives),
      selectionColor: MixOps.merge($selectionColor, other?.$selectionColor),
      semanticsLabel: MixOps.merge($semanticsLabel, other?.$semanticsLabel),
      locale: MixOps.merge($locale, other?.$locale),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      variants: MixOps.mergeVariants($variants, other?.$variants),
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
      ..add(DiagnosticsProperty('selectionColor', $selectionColor))
      ..add(DiagnosticsProperty('semanticsLabel', $semanticsLabel))
      ..add(DiagnosticsProperty('locale', $locale))
      ..add(DiagnosticsProperty('directives', $textDirectives));
  }


  @override
  TextStyler wrap(ModifierConfig value) {
    return modifier(value);
  }

  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TextStyle] instances for equality.
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
    $animation,
    $modifier,
    $variants,
  ];
}
