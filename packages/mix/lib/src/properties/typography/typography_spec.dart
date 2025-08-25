import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/spec.dart';
import '../../specs/text/text_widget.dart';

/// Specification for typography properties based on DefaultTextStyle.
///
/// Provides typography configuration that can be applied to establish
/// default text styling context, similar to Flutter's DefaultTextStyle widget.
/// Unlike TextSpec which extends WidgetSpec, this extends Spec directly
/// for use in contexts where widget-level metadata is not needed.
final class TypographySpec extends Spec<TypographySpec> with Diagnosticable {
  /// The text style to apply to descendant Text widgets.
  final TextStyle? style;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// Whether the text should break at soft line breaks.
  final bool? softWrap;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  /// An optional maximum number of lines for the text to span.
  final int? maxLines;

  /// The strategy to use when calculating the width of the text.
  final TextWidthBasis? textWidthBasis;

  /// Defines how the paragraph will apply TextStyle.height to the ascent of the first line and descent of the last line.
  final TextHeightBehavior? textHeightBehavior;

  const TypographySpec({
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  /// Creates a copy of this [TypographySpec] but with the given fields
  /// replaced with the new values.
  @override
  TypographySpec copyWith({
    TextStyle? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) {
    return TypographySpec(
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      maxLines: maxLines ?? this.maxLines,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
    );
  }

  /// Linearly interpolates between this [TypographySpec] and another [TypographySpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [TypographySpec] is returned. When [t] is 1.0, the [other] [TypographySpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [TypographySpec] is returned.
  ///
  /// If [other] is null, this method returns the current [TypographySpec] instance.
  ///
  /// The interpolation is performed on each property of the [TypographySpec] using the appropriate
  /// interpolation method:
  /// - [MixOps.lerp] for [style].
  /// For [textAlign], [softWrap], [overflow], [maxLines], [textWidthBasis], and [textHeightBehavior],
  /// the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [TypographySpec] is used. Otherwise, the value
  /// from the [other] [TypographySpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [TypographySpec] configurations.
  @override
  TypographySpec lerp(TypographySpec? other, double t) {
    if (other == null) return this;

    return TypographySpec(
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
    properties
      ..add(DiagnosticsProperty('style', style))
      ..add(EnumProperty<TextAlign>('textAlign', textAlign))
      ..add(
        FlagProperty(
          'softWrap',
          value: softWrap,
          ifTrue: 'wrapping at word boundaries',
        ),
      )
      ..add(EnumProperty<TextOverflow>('overflow', overflow))
      ..add(IntProperty('maxLines', maxLines))
      ..add(EnumProperty<TextWidthBasis>('textWidthBasis', textWidthBasis))
      ..add(DiagnosticsProperty('textHeightBehavior', textHeightBehavior));
  }

  /// The list of properties that constitute the state of this [TypographySpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TypographySpec] instances for equality.
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

/// Creates a [DefaultTextStyle] widget from a [TypographySpec] with [StyledText] as child.
DefaultTextStyle createTypographySpecWidget({
  required TypographySpec spec,
  required String text,
}) {
  return DefaultTextStyle(
    style: spec.style ?? const TextStyle(),
    textAlign: spec.textAlign,
    softWrap: spec.softWrap ?? true,
    overflow: spec.overflow ?? TextOverflow.clip,
    maxLines: spec.maxLines,
    textWidthBasis: spec.textWidthBasis ?? TextWidthBasis.parent,
    textHeightBehavior: spec.textHeightBehavior,
    child: StyledText(text),
  );
}

/// Extension to convert [TypographySpec] directly to a [DefaultTextStyle] widget.
extension TypographySpecWidget on TypographySpec {
  DefaultTextStyle call(String text) {
    return createTypographySpecWidget(spec: this, text: text);
  }
}
