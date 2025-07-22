import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../attributes/scalar_util.dart';
import '../../attributes/strut_style_mix.dart';
import '../../attributes/strut_style_util.dart';
import '../../attributes/text_height_behavior_mix.dart';
import '../../attributes/text_height_behavior_util.dart';
import '../../attributes/text_style_mix.dart';
import '../../attributes/text_style_util.dart';
import '../../core/animation_config.dart';
import '../../core/directive.dart';
import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import 'text_directives_util.dart';
import 'text_spec.dart';

/// Represents the attributes of a [TextSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [TextSpec].
///
/// Use this class to configure the attributes of a [TextSpec] and pass it to
/// the [TextSpec] constructor.
class TextSpecAttribute extends SpecAttribute<TextSpec> with Diagnosticable {
  final Prop<TextOverflow>? $overflow;
  final Prop<Mix<StrutStyle>>? $strutStyle;
  final Prop<TextAlign>? $textAlign;
  final Prop<TextScaler>? $textScaler;
  final Prop<int>? $maxLines;
  final Prop<Mix<TextStyle>>? $style;
  final Prop<TextWidthBasis>? $textWidthBasis;
  final Prop<Mix<TextHeightBehavior>>? $textHeightBehavior;
  final Prop<TextDirection>? $textDirection;
  final Prop<bool>? $softWrap;
  final List<Prop<MixDirective<String>>>? $directives;

  /// Utility for defining [TextSpecAttribute.overflow]
  final overflow = TextOverflowUtility(
    (prop) => TextSpecAttribute(overflow: prop),
  );

  /// Utility for defining [TextSpecAttribute.strutStyle]
  final strutStyle = StrutStyleUtility(
    (prop) => TextSpecAttribute(strutStyle: prop),
  );

  /// Utility for defining [TextSpecAttribute.textAlign]
  final textAlign = TextAlignUtility(
    (prop) => TextSpecAttribute(textAlign: prop),
  );

  /// Utility for defining [TextSpecAttribute.textScaler]
  final textScaler = TextScalerUtility(
    (prop) => TextSpecAttribute(textScaler: prop),
  );

  /// Utility for defining [TextSpecAttribute.maxLines]
  final maxLines = IntUtility((prop) => TextSpecAttribute(maxLines: prop));

  /// Utility for defining [TextSpecAttribute.style]
  final style = TextStyleUtility((prop) => TextSpecAttribute(style: prop));

  /// Utility for defining [TextSpecAttribute.textWidthBasis]
  final textWidthBasis = TextWidthBasisUtility(
    (prop) => TextSpecAttribute(textWidthBasis: prop),
  );

  /// Utility for defining [TextSpecAttribute.textHeightBehavior]
  final textHeightBehavior = TextHeightBehaviorUtility(
    (prop) => TextSpecAttribute(textHeightBehavior: prop),
  );

  /// Utility for defining [TextSpecAttribute.textDirection]
  final textDirection = TextDirectionUtility(
    (prop) => TextSpecAttribute(textDirection: prop),
  );

  /// Utility for defining [TextSpecAttribute.softWrap]
  final softWrap = BoolUtility((prop) => TextSpecAttribute(softWrap: prop));

  /// Utility for defining [TextSpecAttribute.directive]
  final directive = TextDirectiveUtility(
    (prop) => TextSpecAttribute(directives: [prop]),
  );

  /// Utility for defining [TextSpecAttribute.style.color]
  late final color = style.color;

  /// Utility for defining [TextSpecAttribute.style.fontFamily]
  late final fontFamily = style.fontFamily;

  /// Utility for defining [TextSpecAttribute.style.fontWeight]
  late final fontWeight = style.fontWeight;

  /// Utility for defining [TextSpecAttribute.style.fontStyle]
  late final fontStyle = style.fontStyle;

  /// Utility for defining [TextSpecAttribute.style.fontSize]
  late final fontSize = style.fontSize;

  /// Utility for defining [TextSpecAttribute.style.letterSpacing]
  late final letterSpacing = style.letterSpacing;

  /// Utility for defining [TextSpecAttribute.style.wordSpacing]
  late final wordSpacing = style.wordSpacing;

  /// Utility for defining [TextSpecAttribute.style.textBaseline]
  late final textBaseline = style.textBaseline;

  /// Utility for defining [TextSpecAttribute.style.backgroundColor]
  late final backgroundColor = style.backgroundColor;

  /// Utility for defining [TextSpecAttribute.style.shadows]
  late final shadows = style.shadows;

  /// Utility for defining [TextSpecAttribute.style.fontFeatures]
  late final fontFeatures = style.fontFeatures;

  /// Utility for defining [TextSpecAttribute.style.fontVariations]
  late final fontVariations = style.fontVariations;

  /// Utility for defining [TextSpecAttribute.style.decoration]
  late final decoration = style.decoration;

  /// Utility for defining [TextSpecAttribute.style.decorationColor]
  late final decorationColor = style.decorationColor;

  /// Utility for defining [TextSpecAttribute.style.decorationStyle]
  late final decorationStyle = style.decorationStyle;

  /// Utility for defining [TextSpecAttribute.style.debugLabel]
  late final debugLabel = style.debugLabel;

  /// Utility for defining [TextSpecAttribute.style.height]
  late final height = style.height;

  /// Utility for defining [TextSpecAttribute.style.foreground]
  late final foreground = style.foreground;

  /// Utility for defining [TextSpecAttribute.style.background]
  late final background = style.background;

  /// Utility for defining [TextSpecAttribute.style.decorationThickness]
  late final decorationThickness = style.decorationThickness;

  /// Utility for defining [TextSpecAttribute.style.fontFamilyFallback]
  late final fontFamilyFallback = style.fontFamilyFallback;

  /// Utility for defining [TextSpecAttribute.directive.uppercase]
  late final uppercase = directive.uppercase;

  /// Utility for defining [TextSpecAttribute.directive.lowercase]
  late final lowercase = directive.lowercase;

  /// Utility for defining [TextSpecAttribute.directive.capitalize]
  late final capitalize = directive.capitalize;

  /// Utility for defining [TextSpecAttribute.directive.titleCase]
  late final titleCase = directive.titleCase;

  /// Utility for defining [TextSpecAttribute.directive.sentenceCase]
  late final sentenceCase = directive.sentenceCase;

  TextSpecAttribute({
    Prop<TextOverflow>? overflow,
    Prop<Mix<StrutStyle>>? strutStyle,
    Prop<TextAlign>? textAlign,
    Prop<TextScaler>? textScaler,
    Prop<int>? maxLines,
    Prop<Mix<TextStyle>>? style,
    Prop<TextWidthBasis>? textWidthBasis,
    Prop<Mix<TextHeightBehavior>>? textHeightBehavior,
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

  TextSpecAttribute.only({
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
    List<VariantSpecAttribute<TextSpec>>? variants,
  }) : this(
         overflow: Prop.maybe(overflow),
         strutStyle: Prop.maybe(strutStyle),
         textAlign: Prop.maybe(textAlign),
         textScaler: Prop.maybe(textScaler),
         maxLines: Prop.maybe(maxLines),
         style: Prop.maybe(style),
         textWidthBasis: Prop.maybe(textWidthBasis),
         textHeightBehavior: Prop.maybe(textHeightBehavior),
         textDirection: Prop.maybe(textDirection),
         softWrap: Prop.maybe(softWrap),
         directives: directives?.map(Prop.new).toList(),
         animation: animation,
         modifiers: modifiers,
         variants: variants,
       );

  /// Constructor that accepts a [TextSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [TextSpec] instances to [TextSpecAttribute].
  ///
  /// ```dart
  /// const spec = TextSpec(overflow: TextOverflow.ellipsis, maxLines: 2);
  /// final attr = TextSpecAttribute.value(spec);
  /// ```
  TextSpecAttribute.value(TextSpec spec)
    : this.only(
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
  static TextSpecAttribute? maybeValue(TextSpec? spec) {
    return spec != null ? TextSpecAttribute.value(spec) : null;
  }

  /// Convenience method for animating the TextSpec
  TextSpecAttribute animate(AnimationConfig animation) {
    return TextSpecAttribute.only(animation: animation);
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
  TextSpec resolveSpec(BuildContext context) {
    return TextSpec(
      overflow: MixHelpers.resolve(context, $overflow),
      strutStyle: MixHelpers.resolveMix(context, $strutStyle),
      textAlign: MixHelpers.resolve(context, $textAlign),
      textScaler: MixHelpers.resolve(context, $textScaler),
      maxLines: MixHelpers.resolve(context, $maxLines),
      style: MixHelpers.resolveMix(context, $style),
      textWidthBasis: MixHelpers.resolve(context, $textWidthBasis),
      textHeightBehavior: MixHelpers.resolveMix(context, $textHeightBehavior),
      textDirection: MixHelpers.resolve(context, $textDirection),
      softWrap: MixHelpers.resolve(context, $softWrap),
      directives: MixHelpers.resolveList(context, $directives),
    );
  }

  /// Merges the properties of this [TextSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [TextSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  TextSpecAttribute merge(TextSpecAttribute? other) {
    if (other == null) return this;

    return TextSpecAttribute(
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

  /// The list of properties that constitute the state of this [TextSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TextSpecAttribute] instances for equality.
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
  ];
}
