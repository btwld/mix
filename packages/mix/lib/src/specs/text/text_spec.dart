import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../attributes/enum/enum_util.dart';
import '../../attributes/scalars/scalar_util.dart';
import '../../attributes/strut_style/strut_style_dto.dart';
import '../../attributes/strut_style/strut_style_util.dart';
import '../../attributes/text_height_behavior/text_height_behavior_dto.dart';
import '../../attributes/text_height_behavior/text_height_behavior_util.dart';
import '../../attributes/text_style/text_style_dto.dart';
import '../../attributes/text_style/text_style_util.dart';
import '../../core/attribute.dart';
import '../../core/directive.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/resolved_style_provider.dart';
import '../../core/spec.dart';
import '../../core/utility.dart';
import 'text_directives_util.dart';

final class TextSpec extends Spec<TextSpec> with Diagnosticable {
  final TextOverflow? overflow;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextWidthBasis? textWidthBasis;
  final TextScaler? textScaler;

  final TextStyle? style;
  final TextDirection? textDirection;
  final bool? softWrap;

  final TextHeightBehavior? textHeightBehavior;

  final TextDirective? directive;

  const TextSpec({
    this.overflow,
    this.strutStyle,
    this.textAlign,
    this.textScaler,
    this.maxLines,
    this.style,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.textDirection,
    this.softWrap,
    this.directive,
  });

  static TextSpec from(BuildContext context) {
    return maybeOf(context) ?? const TextSpec();
  }

  /// Retrieves the [TextSpec] from the nearest [ResolvedStyleProvider] ancestor.
  ///
  /// Returns null if no ancestor [ResolvedStyleProvider] is found.
  static TextSpec? maybeOf(BuildContext context) {
    return ResolvedStyleProvider.of<TextSpec>(context)?.spec;
  }

  /// {@template text_spec_of}
  /// Retrieves the [TextSpec] from the nearest [ResolvedStyleProvider] ancestor in the widget tree.
  ///
  /// This method uses [ResolvedStyleProvider.of] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [TextSpec] changes, not when other specs change.
  /// If no ancestor [ResolvedStyleProvider] is found, this method returns an empty [TextSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final textSpec = TextSpec.of(context);
  /// ```
  /// {@endtemplate}
  static TextSpec of(BuildContext context) {
    return maybeOf(context) ?? const TextSpec();
  }

  /// Creates a copy of this [TextSpec] but with the given fields
  /// replaced with the new values.
  @override
  TextSpec copyWith({
    TextOverflow? overflow,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextScaler? textScaler,
    int? maxLines,
    TextStyle? style,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    TextDirection? textDirection,
    bool? softWrap,
    TextDirective? directive,
  }) {
    return TextSpec(
      overflow: overflow ?? this.overflow,
      strutStyle: strutStyle ?? this.strutStyle,
      textAlign: textAlign ?? this.textAlign,
      textScaler: textScaler ?? this.textScaler,
      maxLines: maxLines ?? this.maxLines,
      style: style ?? this.style,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
      textDirection: textDirection ?? this.textDirection,
      softWrap: softWrap ?? this.softWrap,
      directive: directive ?? this.directive,
    );
  }

  /// Linearly interpolates between this [TextSpec] and another [TextSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [TextSpec] is returned. When [t] is 1.0, the [other] [TextSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [TextSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [TextSpec] instance.
  ///
  /// The interpolation is performed on each property of the [TextSpec] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpStrutStyle] for [strutStyle].
  /// - [MixHelpers.lerpTextStyle] for [style].
  /// For [overflow] and [textAlign] and [textScaler] and [maxLines] and [textWidthBasis] and [textHeightBehavior] and [textDirection] and [softWrap] and [directive], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [TextSpec] is used. Otherwise, the value
  /// from the [other] [TextSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [TextSpec] configurations.
  @override
  TextSpec lerp(TextSpec? other, double t) {
    if (other == null) return this;

    return TextSpec(
      overflow: t < 0.5 ? overflow : other.overflow,
      strutStyle: MixHelpers.lerpStrutStyle(strutStyle, other.strutStyle, t),
      textAlign: t < 0.5 ? textAlign : other.textAlign,
      textScaler: t < 0.5 ? textScaler : other.textScaler,
      maxLines: t < 0.5 ? maxLines : other.maxLines,
      style: MixHelpers.lerpTextStyle(style, other.style, t),
      textWidthBasis: t < 0.5 ? textWidthBasis : other.textWidthBasis,
      textHeightBehavior: t < 0.5
          ? textHeightBehavior
          : other.textHeightBehavior,
      textDirection: t < 0.5 ? textDirection : other.textDirection,
      softWrap: t < 0.5 ? softWrap : other.softWrap,
      directive: t < 0.5 ? directive : other.directive,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('overflow', overflow, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('strutStyle', strutStyle, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('textAlign', textAlign, defaultValue: null),
    );

    properties.add(
      DiagnosticsProperty('textScaler', textScaler, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('maxLines', maxLines, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('style', style, defaultValue: null));
    properties.add(
      DiagnosticsProperty('textWidthBasis', textWidthBasis, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'textHeightBehavior',
        textHeightBehavior,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('textDirection', textDirection, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('softWrap', softWrap, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('directive', directive, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [TextSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TextSpec] instances for equality.
  @override
  List<Object?> get props => [
    overflow,
    strutStyle,
    textAlign,
    textScaler,
    maxLines,
    style,
    textWidthBasis,
    textHeightBehavior,
    textDirection,
    softWrap,
    directive,
  ];
}

/// Represents the attributes of a [TextSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [TextSpec].
///
/// Use this class to configure the attributes of a [TextSpec] and pass it to
/// the [TextSpec] constructor.
class TextSpecAttribute extends SpecAttribute<TextSpec> with Diagnosticable {
  final Prop<TextOverflow>? overflow;
  final MixProp<StrutStyle, StrutStyleDto>? strutStyle;
  final Prop<TextAlign>? textAlign;
  final Prop<TextScaler>? textScaler;
  final Prop<int>? maxLines;
  final MixProp<TextStyle, TextStyleDto>? style;
  final Prop<TextWidthBasis>? textWidthBasis;
  final MixProp<TextHeightBehavior, TextHeightBehaviorDto>? textHeightBehavior;
  final Prop<TextDirection>? textDirection;
  final Prop<bool>? softWrap;
  final MixProp<TextDirective, TextDirectiveDto>? directive;

  factory TextSpecAttribute({
    TextOverflow? overflow,
    StrutStyleDto? strutStyle,
    TextAlign? textAlign,
    TextScaler? textScaler,
    int? maxLines,
    TextStyleDto? style,
    TextWidthBasis? textWidthBasis,
    TextHeightBehaviorDto? textHeightBehavior,
    TextDirection? textDirection,
    bool? softWrap,
    TextDirectiveDto? directive,
  }) {
    return TextSpecAttribute.props(
      overflow: Prop.maybeValue(overflow),
      strutStyle: MixProp.maybeValue(strutStyle),
      textAlign: Prop.maybeValue(textAlign),
      textScaler: Prop.maybeValue(textScaler),
      maxLines: Prop.maybeValue(maxLines),
      style: MixProp.maybeValue(style),
      textWidthBasis: Prop.maybeValue(textWidthBasis),
      textHeightBehavior: MixProp.maybeValue(textHeightBehavior),
      textDirection: Prop.maybeValue(textDirection),
      softWrap: Prop.maybeValue(softWrap),
      directive: MixProp.maybeValue(directive),
    );
  }

  /// Constructor that accepts Prop values directly
  const TextSpecAttribute.props({
    this.overflow,
    this.strutStyle,
    this.textAlign,
    this.textScaler,
    this.maxLines,
    this.style,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.textDirection,
    this.softWrap,
    this.directive,
  });

  /// Constructor that accepts a [TextSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [TextSpec] instances to [TextSpecAttribute].
  ///
  /// ```dart
  /// const spec = TextSpec(overflow: TextOverflow.ellipsis, maxLines: 2);
  /// final attr = TextSpecAttribute.value(spec);
  /// ```
  static TextSpecAttribute value(TextSpec spec) {
    return TextSpecAttribute(
      overflow: spec.overflow,
      strutStyle: StrutStyleDto.maybeValue(spec.strutStyle),
      textAlign: spec.textAlign,
      textScaler: spec.textScaler,
      maxLines: spec.maxLines,
      style: TextStyleDto.maybeValue(spec.style),
      textWidthBasis: spec.textWidthBasis,
      textHeightBehavior: TextHeightBehaviorDto.maybeValue(
        spec.textHeightBehavior,
      ),
      textDirection: spec.textDirection,
      softWrap: spec.softWrap,
      directive: TextDirectiveDto.maybeValue(spec.directive),
    );
  }

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
      overflow: MixHelpers.resolve(context, overflow),
      strutStyle: MixHelpers.resolve(context, strutStyle),
      textAlign: MixHelpers.resolve(context, textAlign),
      textScaler: MixHelpers.resolve(context, textScaler),
      maxLines: MixHelpers.resolve(context, maxLines),
      style: MixHelpers.resolve(context, style),
      textWidthBasis: MixHelpers.resolve(context, textWidthBasis),
      textHeightBehavior: MixHelpers.resolve(context, textHeightBehavior),
      textDirection: MixHelpers.resolve(context, textDirection),
      softWrap: MixHelpers.resolve(context, softWrap),
      directive: MixHelpers.resolve(context, directive),
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

    return TextSpecAttribute.props(
      overflow: MixHelpers.merge(overflow, other.overflow),
      strutStyle: MixHelpers.merge(strutStyle, other.strutStyle),
      textAlign: MixHelpers.merge(textAlign, other.textAlign),
      textScaler: MixHelpers.merge(textScaler, other.textScaler),
      maxLines: MixHelpers.merge(maxLines, other.maxLines),
      style: MixHelpers.merge(style, other.style),
      textWidthBasis: MixHelpers.merge(textWidthBasis, other.textWidthBasis),
      textHeightBehavior: MixHelpers.merge(
        textHeightBehavior,
        other.textHeightBehavior,
      ),
      textDirection: MixHelpers.merge(textDirection, other.textDirection),
      softWrap: MixHelpers.merge(softWrap, other.softWrap),
      directive: MixHelpers.merge(directive, other.directive),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('overflow', overflow, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('strutStyle', strutStyle, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('textAlign', textAlign, defaultValue: null),
    );

    properties.add(
      DiagnosticsProperty('textScaler', textScaler, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('maxLines', maxLines, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('style', style, defaultValue: null));
    properties.add(
      DiagnosticsProperty('textWidthBasis', textWidthBasis, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'textHeightBehavior',
        textHeightBehavior,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('textDirection', textDirection, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('softWrap', softWrap, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('directive', directive, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [TextSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TextSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
    overflow,
    strutStyle,
    textAlign,
    textScaler,
    maxLines,
    style,
    textWidthBasis,
    textHeightBehavior,
    textDirection,
    softWrap,
    directive,
  ];
}

/// Utility class for configuring [TextSpec] properties.
///
/// This class provides methods to set individual properties of a [TextSpec].
/// Use the methods of this class to configure specific properties of a [TextSpec].
class TextSpecUtility<T extends Attribute>
    extends SpecUtility<T, TextSpecAttribute> {
  /// Utility for defining [TextSpecAttribute.overflow]
  late final overflow = TextOverflowUtility((v) => only(overflow: v));

  /// Utility for defining [TextSpecAttribute.strutStyle]
  late final strutStyle = StrutStyleUtility((v) => only(strutStyle: v));

  /// Utility for defining [TextSpecAttribute.textAlign]
  late final textAlign = TextAlignUtility((v) => only(textAlign: v));

  /// Utility for defining [TextSpecAttribute.textScaler]
  late final textScaler = TextScalerUtility((v) => only(textScaler: v));

  /// Utility for defining [TextSpecAttribute.maxLines]
  late final maxLines = IntUtility(
    (prop) => builder(TextSpecAttribute.props(maxLines: prop)),
  );

  /// Utility for defining [TextSpecAttribute.style]
  late final style = TextStyleUtility((v) => only(style: v));

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

  /// Utility for defining [TextSpecAttribute.textWidthBasis]
  late final textWidthBasis = TextWidthBasisUtility(
    (v) => only(textWidthBasis: v),
  );

  /// Utility for defining [TextSpecAttribute.textHeightBehavior]
  late final textHeightBehavior = TextHeightBehaviorUtility(
    (v) => only(textHeightBehavior: v),
  );

  /// Utility for defining [TextSpecAttribute.textDirection]
  late final textDirection = TextDirectionUtility(
    (v) => only(textDirection: v),
  );

  /// Utility for defining [TextSpecAttribute.softWrap]
  late final softWrap = BoolUtility(
    (prop) => builder(TextSpecAttribute.props(softWrap: prop)),
  );

  /// Utility for defining [TextSpecAttribute.directive]
  late final directive = TextDirectiveUtility((v) => only(directive: v));

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

  TextSpecUtility(super.attributeBuilder);

  static TextSpecUtility<TextSpecAttribute> get self =>
      TextSpecUtility((v) => v);

  /// Returns a new [TextSpecAttribute] with the specified properties.
  @override
  T only({
    TextOverflow? overflow,
    StrutStyleDto? strutStyle,
    TextAlign? textAlign,
    TextScaler? textScaler,
    int? maxLines,
    TextStyleDto? style,
    TextWidthBasis? textWidthBasis,
    TextHeightBehaviorDto? textHeightBehavior,
    TextDirection? textDirection,
    bool? softWrap,
    TextDirectiveDto? directive,
  }) {
    return builder(
      TextSpecAttribute(
        overflow: overflow,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textScaler: textScaler,
        maxLines: maxLines,
        style: style,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        textDirection: textDirection,
        softWrap: softWrap,
        directive: directive,
      ),
    );
  }
}

/// A tween that interpolates between two [TextSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [TextSpec] specifications.
class TextSpecTween extends Tween<TextSpec?> {
  TextSpecTween({super.begin, super.end});

  @override
  TextSpec lerp(double t) {
    if (begin == null && end == null) {
      return const TextSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
