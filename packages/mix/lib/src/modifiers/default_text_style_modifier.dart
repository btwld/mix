import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../properties/typography/text_height_behavior_mix.dart';
import '../properties/typography/text_style_mix.dart';

final class DefaultTextStyleModifier
    extends Modifier<DefaultTextStyleModifier>
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
  /// - [MixOps.lerp] for [style].
  /// For [textAlign] and [softWrap] and [overflow] and [maxLines] and [textWidthBasis] and [textHeightBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [DefaultTextStyleModifier] is used. Otherwise, the value
  /// from the [other] [DefaultTextStyleModifier] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [DefaultTextStyleModifier] configurations.
  @override
  DefaultTextStyleModifier lerp(
    DefaultTextStyleModifier? other,
    double t,
  ) {
    if (other == null) return this;

    return DefaultTextStyleModifier(
      style: MixOps.lerp(style, other.style, t),
      textAlign: MixOps.lerpSnap(textAlign, other.textAlign, t),
      softWrap: MixOps.lerpSnap(softWrap, other.softWrap, t),
      overflow: MixOps.lerpSnap(overflow, other.overflow, t),
      maxLines: MixOps.lerpSnap(maxLines, other.maxLines, t),
      textWidthBasis: MixOps.lerpSnap(textWidthBasis, other.textWidthBasis, t),
      textHeightBehavior: MixOps.lerpSnap(
        textHeightBehavior,
        other.textHeightBehavior,
        t,
      ),
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
class DefaultTextStyleModifierMix
    extends ModifierMix<DefaultTextStyleModifier> {
  final MixProp<TextStyle>? style;
  final Prop<TextAlign>? textAlign;
  final Prop<bool>? softWrap;
  final Prop<TextOverflow>? overflow;
  final Prop<int>? maxLines;
  final Prop<TextWidthBasis>? textWidthBasis;
  final MixProp<TextHeightBehavior>? textHeightBehavior;

  const DefaultTextStyleModifierMix.create({
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  DefaultTextStyleModifierMix({
    TextStyleMix? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehaviorMix? textHeightBehavior,
  }) : this.create(
         style: MixProp.maybe(style),
         textAlign: Prop.maybe(textAlign),
         softWrap: Prop.maybe(softWrap),
         overflow: Prop.maybe(overflow),
         maxLines: Prop.maybe(maxLines),
         textWidthBasis: Prop.maybe(textWidthBasis),
         textHeightBehavior: MixProp.maybe(textHeightBehavior),
       );

  /// Resolves to [DefaultTextStyleModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final defaultTextStyleModifier = DefaultTextStyleModifierMix(...).resolve(mix);
  /// ```
  @override
  DefaultTextStyleModifier resolve(BuildContext context) {
    return DefaultTextStyleModifier(
      style: MixOps.resolve(context, style),
      textAlign: MixOps.resolve(context, textAlign),
      softWrap: MixOps.resolve(context, softWrap),
      overflow: MixOps.resolve(context, overflow),
      maxLines: MixOps.resolve(context, maxLines),
      textWidthBasis: MixOps.resolve(context, textWidthBasis),
      textHeightBehavior: MixOps.resolve(context, textHeightBehavior),
    );
  }

  /// Merges the properties of this [DefaultTextStyleModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [DefaultTextStyleModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  DefaultTextStyleModifierMix merge(
    DefaultTextStyleModifierMix? other,
  ) {
    if (other == null) return this;

    return DefaultTextStyleModifierMix.create(
      style: style.tryMerge(other.style),
      textAlign: textAlign.tryMerge(other.textAlign),
      softWrap: softWrap.tryMerge(other.softWrap),
      overflow: overflow.tryMerge(other.overflow),
      maxLines: maxLines.tryMerge(other.maxLines),
      textWidthBasis: textWidthBasis.tryMerge(other.textWidthBasis),
      textHeightBehavior: textHeightBehavior.tryMerge(other.textHeightBehavior),
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

final class DefaultTextStyleModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, DefaultTextStyleModifierMix> {
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
      DefaultTextStyleModifierMix(
        style: TextStyleMix.maybeValue(style),
        textAlign: textAlign,
        softWrap: softWrap,
        overflow: overflow,
        maxLines: maxLines,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: TextHeightBehaviorMix.maybeValue(
          textHeightBehavior,
        ),
      ),
    );
  }
}
