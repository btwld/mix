// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../attributes/text_height_behavior/text_height_behavior_dto.dart';
import '../attributes/text_style/text_style_dto.dart';
import '../core/element.dart';
import '../core/factory/mix_context.dart';
import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/utility.dart';

final class DefaultTextStyleModifierSpec
    extends WidgetModifierSpec<DefaultTextStyleModifierSpec>
    with Diagnosticable {
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  const DefaultTextStyleModifierSpec({
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  /// Creates a copy of this [DefaultTextStyleModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  DefaultTextStyleModifierSpec copyWith({
    TextStyle? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) {
    return DefaultTextStyleModifierSpec(
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      maxLines: maxLines ?? this.maxLines,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
    );
  }

  /// Linearly interpolates between this [DefaultTextStyleModifierSpec] and another [DefaultTextStyleModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [DefaultTextStyleModifierSpec] is returned. When [t] is 1.0, the [other] [DefaultTextStyleModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [DefaultTextStyleModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [DefaultTextStyleModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [DefaultTextStyleModifierSpec] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpTextStyle] for [style].
  /// For [textAlign] and [softWrap] and [overflow] and [maxLines] and [textWidthBasis] and [textHeightBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [DefaultTextStyleModifierSpec] is used. Otherwise, the value
  /// from the [other] [DefaultTextStyleModifierSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [DefaultTextStyleModifierSpec] configurations.
  @override
  DefaultTextStyleModifierSpec lerp(
    DefaultTextStyleModifierSpec? other,
    double t,
  ) {
    if (other == null) return this;

    return DefaultTextStyleModifierSpec(
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

  /// The list of properties that constitute the state of this [DefaultTextStyleModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [DefaultTextStyleModifierSpec] instances for equality.
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

/// Represents the attributes of a [DefaultTextStyleModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [DefaultTextStyleModifierSpec].
///
/// Use this class to configure the attributes of a [DefaultTextStyleModifierSpec] and pass it to
/// the [DefaultTextStyleModifierSpec] constructor.
class DefaultTextStyleModifierSpecAttribute
    extends WidgetModifierSpecAttribute<DefaultTextStyleModifierSpec>
    with Diagnosticable {
  final TextStyleDto? style;
  final TextAlign? textAlign;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehaviorDto? textHeightBehavior;

  const DefaultTextStyleModifierSpecAttribute({
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  /// Resolves to [DefaultTextStyleModifierSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final defaultTextStyleModifierSpec = DefaultTextStyleModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  DefaultTextStyleModifierSpec resolve(MixContext mix) {
    return DefaultTextStyleModifierSpec(
      style: style?.resolve(mix),
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior?.resolve(mix),
    );
  }

  /// Merges the properties of this [DefaultTextStyleModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [DefaultTextStyleModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  DefaultTextStyleModifierSpecAttribute merge(
    DefaultTextStyleModifierSpecAttribute? other,
  ) {
    if (other == null) return this;

    return DefaultTextStyleModifierSpecAttribute(
      style: style?.merge(other.style) ?? other.style,
      textAlign: other.textAlign ?? textAlign,
      softWrap: other.softWrap ?? softWrap,
      overflow: other.overflow ?? overflow,
      maxLines: other.maxLines ?? maxLines,
      textWidthBasis: other.textWidthBasis ?? textWidthBasis,
      textHeightBehavior:
          textHeightBehavior?.merge(other.textHeightBehavior) ??
          other.textHeightBehavior,
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

  /// The list of properties that constitute the state of this [DefaultTextStyleModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [DefaultTextStyleModifierSpecAttribute] instances for equality.
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

/// A tween that interpolates between two [DefaultTextStyleModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [DefaultTextStyleModifierSpec] specifications.
class DefaultTextStyleModifierSpecTween
    extends Tween<DefaultTextStyleModifierSpec?> {
  DefaultTextStyleModifierSpecTween({super.begin, super.end});

  @override
  DefaultTextStyleModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const DefaultTextStyleModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

final class DefaultTextStyleModifierSpecUtility<T extends StyleElement>
    extends MixUtility<T, DefaultTextStyleModifierSpecAttribute> {
  const DefaultTextStyleModifierSpecUtility(super.builder);
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
      DefaultTextStyleModifierSpecAttribute(
        style: style?.toDto(),
        textAlign: textAlign,
        softWrap: softWrap,
        overflow: overflow,
        maxLines: maxLines,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior?.toDto(),
      ),
    );
  }
}
