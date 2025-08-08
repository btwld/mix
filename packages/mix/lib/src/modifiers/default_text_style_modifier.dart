import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../properties/typography/text_height_behavior_mix.dart';
import '../properties/typography/text_style_mix.dart';

final class DefaultTextStyleWidgetModifier
    extends Modifier<DefaultTextStyleWidgetModifier>
    with Diagnosticable {
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  const DefaultTextStyleWidgetModifier({
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  /// Creates a copy of this [DefaultTextStyleWidgetModifier] but with the given fields
  /// replaced with the new values.
  @override
  DefaultTextStyleWidgetModifier copyWith({
    TextStyle? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) {
    return DefaultTextStyleWidgetModifier(
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      maxLines: maxLines ?? this.maxLines,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
    );
  }

  /// Linearly interpolates between this [DefaultTextStyleWidgetModifier] and another [DefaultTextStyleWidgetModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [DefaultTextStyleWidgetModifier] is returned. When [t] is 1.0, the [other] [DefaultTextStyleWidgetModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [DefaultTextStyleWidgetModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [DefaultTextStyleWidgetModifier] instance.
  ///
  /// The interpolation is performed on each property of the [DefaultTextStyleWidgetModifier] using the appropriate
  /// interpolation method:
  /// - [MixOps.lerp] for [style].
  /// For [textAlign] and [softWrap] and [overflow] and [maxLines] and [textWidthBasis] and [textHeightBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [DefaultTextStyleWidgetModifier] is used. Otherwise, the value
  /// from the [other] [DefaultTextStyleWidgetModifier] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [DefaultTextStyleWidgetModifier] configurations.
  @override
  DefaultTextStyleWidgetModifier lerp(
    DefaultTextStyleWidgetModifier? other,
    double t,
  ) {
    if (other == null) return this;

    return DefaultTextStyleWidgetModifier(
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

  /// The list of properties that constitute the state of this [DefaultTextStyleWidgetModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [DefaultTextStyleWidgetModifier] instances for equality.
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

/// Represents the attributes of a [DefaultTextStyleWidgetModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [DefaultTextStyleWidgetModifier].
///
/// Use this class to configure the attributes of a [DefaultTextStyleWidgetModifier] and pass it to
/// the [DefaultTextStyleWidgetModifier] constructor.
class DefaultTextStyleWidgetModifierMix
    extends WidgetModifierMix<DefaultTextStyleWidgetModifier> {
  final MixProp<TextStyle>? style;
  final Prop<TextAlign>? textAlign;
  final Prop<bool>? softWrap;
  final Prop<TextOverflow>? overflow;
  final Prop<int>? maxLines;
  final Prop<TextWidthBasis>? textWidthBasis;
  final MixProp<TextHeightBehavior>? textHeightBehavior;

  const DefaultTextStyleWidgetModifierMix.create({
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  DefaultTextStyleWidgetModifierMix({
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

  /// Resolves to [DefaultTextStyleWidgetModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final defaultTextStyleWidgetModifier = DefaultTextStyleWidgetModifierMix(...).resolve(mix);
  /// ```
  @override
  DefaultTextStyleWidgetModifier resolve(BuildContext context) {
    return DefaultTextStyleWidgetModifier(
      style: MixOps.resolve(context, style),
      textAlign: MixOps.resolve(context, textAlign),
      softWrap: MixOps.resolve(context, softWrap),
      overflow: MixOps.resolve(context, overflow),
      maxLines: MixOps.resolve(context, maxLines),
      textWidthBasis: MixOps.resolve(context, textWidthBasis),
      textHeightBehavior: MixOps.resolve(context, textHeightBehavior),
    );
  }

  /// Merges the properties of this [DefaultTextStyleWidgetModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [DefaultTextStyleWidgetModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  DefaultTextStyleWidgetModifierMix merge(
    DefaultTextStyleWidgetModifierMix? other,
  ) {
    if (other == null) return this;

    return DefaultTextStyleWidgetModifierMix.create(
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

final class DefaultTextStyleWidgetModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, DefaultTextStyleWidgetModifierMix> {
  const DefaultTextStyleWidgetModifierUtility(super.builder);
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
      DefaultTextStyleWidgetModifierMix(
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
