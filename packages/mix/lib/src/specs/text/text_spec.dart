import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../core/directive.dart';
import '../../core/helpers.dart';
import '../../core/spec.dart';

part 'text_spec.g.dart';

/// Specification for text styling and layout properties.
///
/// Provides comprehensive text styling including overflow behavior, structure styling,
/// alignment, line limits, text direction, and string directive support.
@MixableSpec()
@immutable
final class TextSpec extends Spec<TextSpec>
    with Diagnosticable, _$TextSpecMethods {
  /// How visual overflow should be handled.
  @override
  final TextOverflow? overflow;

  /// The strut style to use for the text.
  @override
  final StrutStyle? strutStyle;

  /// How the text should be aligned horizontally.
  @override
  final TextAlign? textAlign;

  /// The maximum number of lines to display.
  @override
  final int? maxLines;

  /// Defines how to measure the width of the text.
  @override
  final TextWidthBasis? textWidthBasis;

  /// How text should be scaled.
  @override
  final TextScaler? textScaler;

  /// The style to use for the text.
  @override
  final TextStyle? style;

  /// The directionality of the text.
  @override
  final TextDirection? textDirection;

  /// Whether the text should break at soft line breaks.
  @override
  final bool? softWrap;

  /// Defines how the height of the text should be calculated.
  @override
  final TextHeightBehavior? textHeightBehavior;

  /// Directives to transform the text string.
  @override
  final List<Directive<String>>? textDirectives;

  /// The color to use when painting the selection.
  @override
  final Color? selectionColor;

  /// Alternative semantics label for accessibility.
  @override
  final String? semanticsLabel;

  /// Locale for text rendering and formatting.
  @override
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
    this.textDirectives,
    this.selectionColor,
    this.semanticsLabel,
    this.locale,
  });
}
