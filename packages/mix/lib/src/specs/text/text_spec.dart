import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/directive.dart';
import '../../core/helpers.dart';
import '../../core/resolved_style_provider.dart';
import '../../core/spec.dart';

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

  final List<MixDirective<String>>? directives;

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
    this.directives,
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
      DiagnosticsProperty('directive', directives, defaultValue: null),
    );
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
    List<MixDirective<String>>? directives,
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
      directives: directives ?? this.directives,
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
  /// For [overflow] and [textAlign] and [textScaler] and [maxLines] and [textWidthBasis] and [textHeightBehavior] and [textDirection] and [softWrap] and [directives], the interpolation is performed using a step function.
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
      directives: t < 0.5 ? directives : other.directives,
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
    directives,
  ];
}
