import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/directive.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/typography/strut_style_mix.dart';
import '../../properties/typography/text_height_behavior_mix.dart';
import '../../properties/typography/text_style_mix.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'text_spec.dart';

/// Represents the attributes of a [TextSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [TextSpec].
///
/// Use this class to configure the attributes of a [TextSpec] and pass it to
/// the [TextSpec] constructor.
class TextMix extends Style<TextSpec>
    with
        Diagnosticable,
        StyleModifierMixin<TextMix, TextSpec>,
        StyleVariantMixin<TextMix, TextSpec> {
  final Prop<TextOverflow>? $overflow;
  final MixProp<StrutStyle>? $strutStyle;
  final Prop<TextAlign>? $textAlign;
  final Prop<TextScaler>? $textScaler;
  final Prop<int>? $maxLines;
  final MixProp<TextStyle>? $style;
  final Prop<TextWidthBasis>? $textWidthBasis;
  final MixProp<TextHeightBehavior>? $textHeightBehavior;
  final Prop<TextDirection>? $textDirection;
  final Prop<bool>? $softWrap;
  final List<Prop<MixDirective<String>>>? $directives;

  const TextMix.raw({
    Prop<TextOverflow>? overflow,
    MixProp<StrutStyle>? strutStyle,
    Prop<TextAlign>? textAlign,
    Prop<TextScaler>? textScaler,
    Prop<int>? maxLines,
    MixProp<TextStyle>? style,
    Prop<TextWidthBasis>? textWidthBasis,
    MixProp<TextHeightBehavior>? textHeightBehavior,
    Prop<TextDirection>? textDirection,
    Prop<bool>? softWrap,
    List<Prop<MixDirective<String>>>? directives,
    super.animation,
    super.modifiers,
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
       $directives = directives;

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
    List<MixDirective<String>>? directives,
    AnimationConfig? animation,
    List<ModifierAttribute>? modifiers,
    List<VariantStyleAttribute<TextSpec>>? variants,
  }) : this.raw(
         overflow: Prop.maybe(overflow),
         strutStyle: MixProp.maybe(strutStyle),
         textAlign: Prop.maybe(textAlign),
         textScaler: Prop.maybe(textScaler),
         maxLines: Prop.maybe(maxLines),
         style: MixProp.maybe(style),
         textWidthBasis: Prop.maybe(textWidthBasis),
         textHeightBehavior: MixProp.maybe(textHeightBehavior),
         textDirection: Prop.maybe(textDirection),
         softWrap: Prop.maybe(softWrap),
         directives: directives?.map(Prop.new).toList(),
         animation: animation,
         modifiers: modifiers,
         variants: variants,
       );

  /// Constructor that accepts a [TextSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [TextSpec] instances to [TextMix].
  ///
  /// ```dart
  /// const spec = TextSpec(overflow: TextOverflow.ellipsis, maxLines: 2);
  /// final attr = TextSpecAttribute.value(spec);
  /// ```
  TextMix.value(TextSpec spec)
    : this(
        overflow: spec.overflow,
        strutStyle: StrutStyleMix.maybeValue(spec.strutStyle),
        textAlign: spec.textAlign,
        textScaler: spec.textScaler,
        maxLines: spec.maxLines,
        style: TextStyleMix.maybeValue(spec.style),
        textWidthBasis: spec.textWidthBasis,
        textHeightBehavior: TextHeightBehaviorMix.maybeValue(
          spec.textHeightBehavior,
        ),
        textDirection: spec.textDirection,
        softWrap: spec.softWrap,
        directives: spec.directives,
      );

  /// Constructor that accepts a nullable [TextSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [TextSpecAttribute.value].
  ///
  /// ```dart
  /// const TextSpec? spec = TextSpec(overflow: TextOverflow.ellipsis, maxLines: 2);
  /// final attr = TextSpecAttribute.maybeValue(spec); // Returns TextSpecAttribute or null
  /// ```
  static TextMix? maybeValue(TextSpec? spec) {
    return spec != null ? TextMix.value(spec) : null;
  }

  /// Convenience method for animating the TextSpec
  TextMix animate(AnimationConfig animation) {
    return TextMix(animation: animation);
  }

  @override
  TextMix variants(List<VariantStyleAttribute<TextSpec>> variants) {
    return merge(TextMix(variants: variants));
  }

  @override
  TextMix modifiers(List<ModifierAttribute> modifiers) {
    return merge(TextMix(modifiers: modifiers));
  }

  /// Resolves to [TextSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final textSpec = TextSpecAttribute(...).resolve(mix);
  /// ```
  @override
  TextSpec resolve(BuildContext context) {
    return TextSpec(
      overflow: MixHelpers.resolve(context, $overflow),
      strutStyle: MixHelpers.resolve(context, $strutStyle),
      textAlign: MixHelpers.resolve(context, $textAlign),
      textScaler: MixHelpers.resolve(context, $textScaler),
      maxLines: MixHelpers.resolve(context, $maxLines),
      style: MixHelpers.resolve(context, $style),
      textWidthBasis: MixHelpers.resolve(context, $textWidthBasis),
      textHeightBehavior: MixHelpers.resolve(context, $textHeightBehavior),
      textDirection: MixHelpers.resolve(context, $textDirection),
      softWrap: MixHelpers.resolve(context, $softWrap),
      directives: MixHelpers.resolveList(context, $directives),
    );
  }

  /// Merges the properties of this [TextMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [TextMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  TextMix merge(TextMix? other) {
    if (other == null) return this;

    return TextMix.raw(
      overflow: MixHelpers.merge($overflow, other.$overflow),
      strutStyle: MixHelpers.merge($strutStyle, other.$strutStyle),
      textAlign: MixHelpers.merge($textAlign, other.$textAlign),
      textScaler: MixHelpers.merge($textScaler, other.$textScaler),
      maxLines: MixHelpers.merge($maxLines, other.$maxLines),
      style: MixHelpers.merge($style, other.$style),
      textWidthBasis: MixHelpers.merge($textWidthBasis, other.$textWidthBasis),
      textHeightBehavior: MixHelpers.merge(
        $textHeightBehavior,
        other.$textHeightBehavior,
      ),
      textDirection: MixHelpers.merge($textDirection, other.$textDirection),
      softWrap: MixHelpers.merge($softWrap, other.$softWrap),
      directives: MixHelpers.mergeList(
        $directives,
        other.$directives,
        strategy: ListMergeStrategy.append,
      ),
      animation: other.$animation ?? $animation,
      modifiers: mergeModifierLists($modifiers, other.$modifiers),
      variants: mergeVariantLists($variants, other.$variants),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('overflow', $overflow, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('strutStyle', $strutStyle, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('textAlign', $textAlign, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('textScaler', $textScaler, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('maxLines', $maxLines, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('style', $style, defaultValue: null));
    properties.add(
      DiagnosticsProperty(
        'textWidthBasis',
        $textWidthBasis,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty(
        'textHeightBehavior',
        $textHeightBehavior,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('textDirection', $textDirection, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('softWrap', $softWrap, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('directive', $directives, defaultValue: null),
    );

    properties.add(
      DiagnosticsProperty('directives', $directives, defaultValue: null),
    );
  }

  @override
  TextMix variant(Variant variant, TextMix style) {
    return merge(TextMix(variants: [VariantStyleAttribute(variant, style)]));
  }

  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TextMix] instances for equality.
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
    $directives,
    $animation,
    $modifiers,
    $variants,
  ];
}
