import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/modifier.dart';
import '../../core/spec.dart';

/// Specification for text styling and layout properties.
///
/// Provides comprehensive text styling including overflow behavior, structure styling,
/// alignment, line limits, text direction, and string modifier support.
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

  final List<Modifier<String>>? textModifiers;

  final Color? selectionColor;

  /// Alternative semantics label for accessibility.
  final String? semanticsLabel;

  /// Locale for text rendering and formatting.
  final Locale? locale;

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
    this.textModifiers,
    this.selectionColor,
    this.semanticsLabel,
    this.locale,
  });

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
      DiagnosticsProperty('textModifiers', textModifiers, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('selectionColor', selectionColor, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('semanticsLabel', semanticsLabel, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('locale', locale, defaultValue: null));
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
    List<Modifier<String>>? textModifiers,
    Color? selectionColor,
    String? semanticsLabel,
    Locale? locale,
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
      textModifiers: textModifiers ?? this.textModifiers,
      selectionColor: selectionColor ?? this.selectionColor,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      locale: locale ?? this.locale,
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
  /// - [MixOps.lerpStrutStyle] for [strutStyle].
  /// - [MixOps.lerp] for [style].
  /// For [overflow] and [textAlign] and [textScaler] and [maxLines] and [textWidthBasis] and [textHeightBehavior] and [textDirection] and [softWrap] and [textModifiers], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [TextSpec] is used. Otherwise, the value
  /// from the [other] [TextSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [TextSpec] configurations.
  @override
  TextSpec lerp(TextSpec? other, double t) {
    if (other == null) return this;

    return TextSpec(
      overflow: MixOps.lerpSnap(overflow, other.overflow, t),
      strutStyle: MixOps.lerp(strutStyle, other.strutStyle, t),
      textAlign: MixOps.lerpSnap(textAlign, other.textAlign, t),
      textScaler: MixOps.lerpSnap(textScaler, other.textScaler, t),
      maxLines: MixOps.lerpSnap(maxLines, other.maxLines, t),
      style: MixOps.lerp(style, other.style, t),
      textWidthBasis: MixOps.lerpSnap(textWidthBasis, other.textWidthBasis, t),
      textHeightBehavior: MixOps.lerpSnap(
        textHeightBehavior,
        other.textHeightBehavior,
        t,
      ),
      textDirection: MixOps.lerpSnap(textDirection, other.textDirection, t),
      softWrap: MixOps.lerpSnap(softWrap, other.softWrap, t),
      textModifiers: MixOps.lerpSnap(textModifiers, other.textModifiers, t),
      selectionColor: MixOps.lerp(selectionColor, other.selectionColor, t),
      semanticsLabel: MixOps.lerpSnap(semanticsLabel, other.semanticsLabel, t),
      locale: MixOps.lerpSnap(locale, other.locale, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
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
    textModifiers,
    selectionColor,
    semanticsLabel,
    locale,
  ];
}
