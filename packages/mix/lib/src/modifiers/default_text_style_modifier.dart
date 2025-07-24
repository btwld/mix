// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../attributes/text_height_behavior_mix.dart';
import '../attributes/text_style_mix.dart';
import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

final class DefaultTextStyleModifier extends Modifier<DefaultTextStyleModifier>
    with Diagnosticable {
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  const DefaultTextStyleModifier({
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  /// Creates a copy of this [DefaultTextStyleModifier] but with the given fields
  /// replaced with the new values.
  @override
  DefaultTextStyleModifier copyWith({
    TextStyle? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) {
    return DefaultTextStyleModifier(
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      maxLines: maxLines ?? this.maxLines,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
    );
  }

  /// Linearly interpolates between this [DefaultTextStyleModifier] and another [DefaultTextStyleModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [DefaultTextStyleModifier] is returned. When [t] is 1.0, the [other] [DefaultTextStyleModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [DefaultTextStyleModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [DefaultTextStyleModifier] instance.
  ///
  /// The interpolation is performed on each property of the [DefaultTextStyleModifier] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpTextStyle] for [style].
  /// For [textAlign] and [softWrap] and [overflow] and [maxLines] and [textWidthBasis] and [textHeightBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [DefaultTextStyleModifier] is used. Otherwise, the value
  /// from the [other] [DefaultTextStyleModifier] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [DefaultTextStyleModifier] configurations.
  @override
  DefaultTextStyleModifier lerp(DefaultTextStyleModifier? other, double t) {
    if (other == null) return this;

    return DefaultTextStyleModifier(
      style: MixHelpers.lerpTextStyle(style, other.style, t),
      textAlign: t < 0.5 ? textAlign : other.textAlign,
      softWrap: t < 0.5 ? softWrap : other.softWrap,
      overflow: t < 0.5 ? overflow : other.overflow,
      maxLines: t < 0.5 ? maxLines : other.maxLines,
      textWidthBasis: t < 0.5 ? textWidthBasis : other.textWidthBasis,
      textHeightBehavior: t < 0.5
          ? textHeightBehavior
          : other.textHeightBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('style', style, defaultValue: null));
    properties.add(
      DiagnosticsProperty('textAlign', textAlign, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('softWrap', softWrap, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('overflow', overflow, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('maxLines', maxLines, defaultValue: null),
    );
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
  }

  /// The list of properties that constitute the state of this [DefaultTextStyleModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [DefaultTextStyleModifier] instances for equality.
  @override
  List<Object?> get props => [
    style,
    textAlign,
    softWrap,
    overflow,
    maxLines,
    textWidthBasis,
    textHeightBehavior,
  ];

  @override
  Widget build(Widget child) {
    return DefaultTextStyle(
      style: style ?? const TextStyle(),
      textAlign: textAlign,
      softWrap: softWrap ?? true,
      overflow: overflow ?? TextOverflow.clip,
      maxLines: maxLines,
      textWidthBasis: textWidthBasis ?? TextWidthBasis.parent,
      textHeightBehavior: textHeightBehavior,
      child: child,
    );
  }
}

/// Represents the attributes of a [DefaultTextStyleModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [DefaultTextStyleModifier].
///
/// Use this class to configure the attributes of a [DefaultTextStyleModifier] and pass it to
/// the [DefaultTextStyleModifier] constructor.
class DefaultTextStyleModifierAttribute
    extends ModifierAttribute<DefaultTextStyleModifier> {
  final MixProp<TextStyle>? style;
  final Prop<TextAlign>? textAlign;
  final Prop<bool>? softWrap;
  final Prop<TextOverflow>? overflow;
  final Prop<int>? maxLines;
  final Prop<TextWidthBasis>? textWidthBasis;
  final MixProp<TextHeightBehavior>? textHeightBehavior;

  const DefaultTextStyleModifierAttribute({
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  DefaultTextStyleModifierAttribute.only({
    TextStyleMix? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehaviorMix? textHeightBehavior,
  }) : this(
         style: MixProp.maybe(style),
         textAlign: Prop.maybe(textAlign),
         softWrap: Prop.maybe(softWrap),
         overflow: Prop.maybe(overflow),
         maxLines: Prop.maybe(maxLines),
         textWidthBasis: Prop.maybe(textWidthBasis),
         textHeightBehavior: MixProp.maybe(textHeightBehavior),
       );

  /// Resolves to [DefaultTextStyleModifier] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final defaultTextStyleModifierSpec = DefaultTextStyleModifierAttribute(...).resolve(mix);
  /// ```
  @override
  DefaultTextStyleModifier resolve(BuildContext context) {
    return DefaultTextStyleModifier(
      style: MixHelpers.resolve(context, style),
      textAlign: MixHelpers.resolve(context, textAlign),
      softWrap: MixHelpers.resolve(context, softWrap),
      overflow: MixHelpers.resolve(context, overflow),
      maxLines: MixHelpers.resolve(context, maxLines),
      textWidthBasis: MixHelpers.resolve(context, textWidthBasis),
      textHeightBehavior: MixHelpers.resolve(context, textHeightBehavior),
    );
  }

  /// Merges the properties of this [DefaultTextStyleModifierAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [DefaultTextStyleModifierAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  DefaultTextStyleModifierAttribute merge(
    DefaultTextStyleModifierAttribute? other,
  ) {
    if (other == null) return this;

    return DefaultTextStyleModifierAttribute(
      style: MixHelpers.merge(style, other.style),
      textAlign: MixHelpers.merge(textAlign, other.textAlign),
      softWrap: MixHelpers.merge(softWrap, other.softWrap),
      overflow: MixHelpers.merge(overflow, other.overflow),
      maxLines: MixHelpers.merge(maxLines, other.maxLines),
      textWidthBasis: MixHelpers.merge(textWidthBasis, other.textWidthBasis),
      textHeightBehavior: MixHelpers.merge(
        textHeightBehavior,
        other.textHeightBehavior,
      ),
    );
  }

  @override
  List<Object?> get props => [
    style,
    textAlign,
    softWrap,
    overflow,
    maxLines,
    textWidthBasis,
    textHeightBehavior,
  ];
}

final class DefaultTextStyleModifierUtility<T extends SpecStyle<Object?>>
    extends MixUtility<T, DefaultTextStyleModifierAttribute> {
  const DefaultTextStyleModifierUtility(super.builder);
  T call({
    TextStyle? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) {
    return builder(
      DefaultTextStyleModifierAttribute(
        style: MixProp.maybe(TextStyleMix.maybeValue(style)),
        textAlign: Prop.maybe(textAlign),
        softWrap: Prop.maybe(softWrap),
        overflow: Prop.maybe(overflow),
        maxLines: Prop.maybe(maxLines),
        textWidthBasis: Prop.maybe(textWidthBasis),
        textHeightBehavior: MixProp.maybe(
          TextHeightBehaviorMix.maybeValue(textHeightBehavior),
        ),
      ),
    );
  }
}
