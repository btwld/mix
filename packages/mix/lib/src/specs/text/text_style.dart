import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../animation/animation_config.dart';
import '../../core/directive.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/style_spec.dart';
import '../../modifiers/widget_modifier_config.dart';
import '../../properties/typography/strut_style_mix.dart';
import '../../properties/typography/text_height_behavior_mix.dart';
import '../../properties/typography/text_style_mix.dart';
import '../../style/mixins/animation_style_mixin.dart';
import '../../style/mixins/text_style_mixin.dart';
import '../../style/mixins/variant_style_mixin.dart';
import '../../style/mixins/widget_modifier_style_mixin.dart';
import '../../style/mixins/widget_state_variant_mixin.dart';
import 'text_mutable_style.dart';
import 'text_spec.dart';
import 'text_widget.dart';

part 'text_style.g.dart';

@Deprecated('Use TextStyler instead')
typedef TextMix = TextStyler;

/// Represents the attributes of a [TextSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [TextSpec].
///
/// Use this class to configure the attributes of a [TextSpec] and pass it to
/// the [TextSpec] constructor.
@MixableStyler()
class TextStyler extends Style<TextSpec>
    with
        Diagnosticable,
        WidgetModifierStyleMixin<TextStyler, TextSpec>,
        VariantStyleMixin<TextStyler, TextSpec>,
        WidgetStateVariantMixin<TextStyler, TextSpec>,
        TextStyleMixin<TextStyler>,
        AnimationStyleMixin<TextStyler, TextSpec>,
        _$TextStylerMixin {
  @override
  final Prop<TextOverflow>? $overflow;
  @override
  final Prop<StrutStyle>? $strutStyle;
  @override
  final Prop<TextAlign>? $textAlign;
  @override
  final Prop<TextScaler>? $textScaler;
  @override
  final Prop<int>? $maxLines;
  @override
  final Prop<TextStyle>? $style;
  @override
  final Prop<TextWidthBasis>? $textWidthBasis;
  @override
  final Prop<TextHeightBehavior>? $textHeightBehavior;
  @override
  final Prop<TextDirection>? $textDirection;
  @override
  final Prop<bool>? $softWrap;
  @override
  final List<Directive<String>>? $textDirectives;
  @override
  final Prop<Color>? $selectionColor;
  @override
  final Prop<String>? $semanticsLabel;
  @override
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
    WidgetModifierConfig? modifier,
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

  static TextMutableStyler get chain => TextMutableStyler(TextStyler());

  StyledText call(String text) {
    return StyledText(text, style: this);
  }

  /// Sets a text directive. It will be applied to the text before it is displayed.
  TextStyler textDirective(Directive<String> value) {
    return merge(TextStyler(textDirectives: [value]));
  }

  /// Adds a text directive
  TextStyler directive(Directive<String> value) {
    return merge(TextStyler(textDirectives: [value]));
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
  TextStyler titlecase() {
    return merge(
      TextStyler(textDirectives: [const TitleCaseStringDirective()]),
    );
  }

  /// Applies sentence case directive
  TextStyler sentencecase() {
    return merge(
      TextStyler(textDirectives: [const SentenceCaseStringDirective()]),
    );
  }

  /// Sets the widget modifier.
  TextStyler modifier(WidgetModifierConfig value) {
    return merge(TextStyler(modifier: value));
  }
}
