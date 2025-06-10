// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_spec.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// ignore_for_file: deprecated_member_use_from_same_package

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [TextSpec].
mixin _$TextSpec on Spec<TextSpec> {
  static TextSpec from(MixData mix) {
    return mix.attributeOf<TextSpecAttribute>()?.resolve(mix) ??
        const TextSpec();
  }

  /// {@template text_spec_of}
  /// Retrieves the [TextSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [TextSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [TextSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final textSpec = TextSpec.of(context);
  /// ```
  /// {@endtemplate}
  static TextSpec of(BuildContext context) {
    return ComputedStyle.specOf<TextSpec>(context) ?? const TextSpec();
  }

  /// Creates a copy of this [TextSpec] but with the given fields
  /// replaced with the new values.
  @override
  TextSpec copyWith({
    TextOverflow? overflow,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    double? textScaleFactor,
    TextScaler? textScaler,
    int? maxLines,
    TextStyle? style,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    TextDirection? textDirection,
    bool? softWrap,
    TextDirective? directive,
    AnimatedData? animated,
    WidgetModifiersData? modifiers,
  }) {
    return TextSpec(
      overflow: overflow ?? _$this.overflow,
      strutStyle: strutStyle ?? _$this.strutStyle,
      textAlign: textAlign ?? _$this.textAlign,
      textScaleFactor: textScaleFactor ?? _$this.textScaleFactor,
      textScaler: textScaler ?? _$this.textScaler,
      maxLines: maxLines ?? _$this.maxLines,
      style: style ?? _$this.style,
      textWidthBasis: textWidthBasis ?? _$this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? _$this.textHeightBehavior,
      textDirection: textDirection ?? _$this.textDirection,
      softWrap: softWrap ?? _$this.softWrap,
      directive: directive ?? _$this.directive,
      animated: animated ?? _$this.animated,
      modifiers: modifiers ?? _$this.modifiers,
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
  /// - [MixHelpers.lerpDouble] for [textScaleFactor].
  /// - [MixHelpers.lerpTextStyle] for [style].
  /// For [overflow] and [textAlign] and [textScaler] and [maxLines] and [textWidthBasis] and [textHeightBehavior] and [textDirection] and [softWrap] and [directive] and [animated] and [modifiers], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [TextSpec] is used. Otherwise, the value
  /// from the [other] [TextSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [TextSpec] configurations.
  @override
  TextSpec lerp(TextSpec? other, double t) {
    if (other == null) return _$this;

    return TextSpec(
      overflow: t < 0.5 ? _$this.overflow : other.overflow,
      strutStyle:
          MixHelpers.lerpStrutStyle(_$this.strutStyle, other.strutStyle, t),
      textAlign: t < 0.5 ? _$this.textAlign : other.textAlign,
      textScaleFactor: MixHelpers.lerpDouble(
          _$this.textScaleFactor, other.textScaleFactor, t),
      textScaler: t < 0.5 ? _$this.textScaler : other.textScaler,
      maxLines: t < 0.5 ? _$this.maxLines : other.maxLines,
      style: MixHelpers.lerpTextStyle(_$this.style, other.style, t),
      textWidthBasis: t < 0.5 ? _$this.textWidthBasis : other.textWidthBasis,
      textHeightBehavior:
          t < 0.5 ? _$this.textHeightBehavior : other.textHeightBehavior,
      textDirection: t < 0.5 ? _$this.textDirection : other.textDirection,
      softWrap: t < 0.5 ? _$this.softWrap : other.softWrap,
      directive: t < 0.5 ? _$this.directive : other.directive,
      animated: _$this.animated ?? other.animated,
      modifiers: other.modifiers,
    );
  }

  /// The list of properties that constitute the state of this [TextSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TextSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.overflow,
        _$this.strutStyle,
        _$this.textAlign,
        _$this.textScaleFactor,
        _$this.textScaler,
        _$this.maxLines,
        _$this.style,
        _$this.textWidthBasis,
        _$this.textHeightBehavior,
        _$this.textDirection,
        _$this.softWrap,
        _$this.directive,
        _$this.animated,
        _$this.modifiers,
      ];

  TextSpec get _$this => this as TextSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('overflow', _$this.overflow, defaultValue: null));
    properties.add(DiagnosticsProperty('strutStyle', _$this.strutStyle,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('textAlign', _$this.textAlign, defaultValue: null));
    properties.add(DiagnosticsProperty(
        'textScaleFactor', _$this.textScaleFactor,
        defaultValue: null));
    properties.add(DiagnosticsProperty('textScaler', _$this.textScaler,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('maxLines', _$this.maxLines, defaultValue: null));
    properties
        .add(DiagnosticsProperty('style', _$this.style, defaultValue: null));
    properties.add(DiagnosticsProperty('textWidthBasis', _$this.textWidthBasis,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'textHeightBehavior', _$this.textHeightBehavior,
        defaultValue: null));
    properties.add(DiagnosticsProperty('textDirection', _$this.textDirection,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('softWrap', _$this.softWrap, defaultValue: null));
    properties.add(
        DiagnosticsProperty('directive', _$this.directive, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
  }
}

/// Represents the attributes of a [TextSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [TextSpec].
///
/// Use this class to configure the attributes of a [TextSpec] and pass it to
/// the [TextSpec] constructor.
class TextSpecAttribute extends SpecAttribute<TextSpec> with Diagnosticable {
  final TextOverflow? overflow;
  final StrutStyleDto? strutStyle;
  final TextAlign? textAlign;
  final double? textScaleFactor;
  final TextScaler? textScaler;
  final int? maxLines;
  final TextStyleDto? style;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehaviorDto? textHeightBehavior;
  final TextDirection? textDirection;
  final bool? softWrap;
  final TextDirectiveDto? directive;

  const TextSpecAttribute({
    this.overflow,
    this.strutStyle,
    this.textAlign,
    this.textScaleFactor,
    this.textScaler,
    this.maxLines,
    this.style,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.textDirection,
    this.softWrap,
    this.directive,
    super.animated,
    super.modifiers,
  });

  /// Resolves to [TextSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final textSpec = TextSpecAttribute(...).resolve(mix);
  /// ```
  @override
  TextSpec resolve(MixData mix) {
    return TextSpec(
      overflow: overflow,
      strutStyle: strutStyle?.resolve(mix),
      textAlign: textAlign,
      textScaleFactor: textScaleFactor,
      textScaler: textScaler,
      maxLines: maxLines,
      style: style?.resolve(mix),
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior?.resolve(mix),
      textDirection: textDirection,
      softWrap: softWrap,
      directive: directive?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
      modifiers: modifiers?.resolve(mix),
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
      overflow: other.overflow ?? overflow,
      strutStyle: strutStyle?.merge(other.strutStyle) ?? other.strutStyle,
      textAlign: other.textAlign ?? textAlign,
      textScaleFactor: other.textScaleFactor ?? textScaleFactor,
      textScaler: other.textScaler ?? textScaler,
      maxLines: other.maxLines ?? maxLines,
      style: style?.merge(other.style) ?? other.style,
      textWidthBasis: other.textWidthBasis ?? textWidthBasis,
      textHeightBehavior: textHeightBehavior?.merge(other.textHeightBehavior) ??
          other.textHeightBehavior,
      textDirection: other.textDirection ?? textDirection,
      softWrap: other.softWrap ?? softWrap,
      directive: directive?.merge(other.directive) ?? other.directive,
      animated: animated?.merge(other.animated) ?? other.animated,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
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
        textScaleFactor,
        textScaler,
        maxLines,
        style,
        textWidthBasis,
        textHeightBehavior,
        textDirection,
        softWrap,
        directive,
        animated,
        modifiers,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('overflow', overflow, defaultValue: null));
    properties
        .add(DiagnosticsProperty('strutStyle', strutStyle, defaultValue: null));
    properties
        .add(DiagnosticsProperty('textAlign', textAlign, defaultValue: null));
    properties.add(DiagnosticsProperty('textScaleFactor', textScaleFactor,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty('textScaler', textScaler, defaultValue: null));
    properties
        .add(DiagnosticsProperty('maxLines', maxLines, defaultValue: null));
    properties.add(DiagnosticsProperty('style', style, defaultValue: null));
    properties.add(DiagnosticsProperty('textWidthBasis', textWidthBasis,
        defaultValue: null));
    properties.add(DiagnosticsProperty('textHeightBehavior', textHeightBehavior,
        defaultValue: null));
    properties.add(DiagnosticsProperty('textDirection', textDirection,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty('softWrap', softWrap, defaultValue: null));
    properties
        .add(DiagnosticsProperty('directive', directive, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
  }
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

  /// Utility for defining [TextSpecAttribute.textScaleFactor]
  late final textScaleFactor = DoubleUtility((v) => only(textScaleFactor: v));

  /// Utility for defining [TextSpecAttribute.textScaler]
  late final textScaler = TextScalerUtility((v) => only(textScaler: v));

  /// Utility for defining [TextSpecAttribute.maxLines]
  late final maxLines = IntUtility((v) => only(maxLines: v));

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
  late final textWidthBasis =
      TextWidthBasisUtility((v) => only(textWidthBasis: v));

  /// Utility for defining [TextSpecAttribute.textHeightBehavior]
  late final textHeightBehavior =
      TextHeightBehaviorUtility((v) => only(textHeightBehavior: v));

  /// Utility for defining [TextSpecAttribute.textDirection]
  late final textDirection =
      TextDirectionUtility((v) => only(textDirection: v));

  /// Utility for defining [TextSpecAttribute.softWrap]
  late final softWrap = BoolUtility((v) => only(softWrap: v));

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

  /// Utility for defining [TextSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  /// Utility for defining [TextSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  TextSpecUtility(super.builder, {super.mutable});

  TextSpecUtility<T> get chain =>
      TextSpecUtility(attributeBuilder, mutable: true);

  static TextSpecUtility<TextSpecAttribute> get self =>
      TextSpecUtility((v) => v);

  /// Returns a new [TextSpecAttribute] with the specified properties.
  @override
  T only({
    TextOverflow? overflow,
    StrutStyleDto? strutStyle,
    TextAlign? textAlign,
    double? textScaleFactor,
    TextScaler? textScaler,
    int? maxLines,
    TextStyleDto? style,
    TextWidthBasis? textWidthBasis,
    TextHeightBehaviorDto? textHeightBehavior,
    TextDirection? textDirection,
    bool? softWrap,
    TextDirectiveDto? directive,
    AnimatedDataDto? animated,
    WidgetModifiersDataDto? modifiers,
  }) {
    return builder(TextSpecAttribute(
      overflow: overflow,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textScaleFactor: textScaleFactor,
      textScaler: textScaler,
      maxLines: maxLines,
      style: style,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      textDirection: textDirection,
      softWrap: softWrap,
      directive: directive,
      animated: animated,
      modifiers: modifiers,
    ));
  }
}

/// A tween that interpolates between two [TextSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [TextSpec] specifications.
class TextSpecTween extends Tween<TextSpec?> {
  TextSpecTween({
    super.begin,
    super.end,
  });

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
