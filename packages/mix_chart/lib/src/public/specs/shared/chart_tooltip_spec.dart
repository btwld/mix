import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'chart_tooltip_spec.g.dart';

/// Resolved presentation for built-in chart tooltips.
@MixableSpec()
@immutable
final class ChartTooltipSpec with _$ChartTooltipSpec {
  /// Tooltip background color.
  @override
  final Color? backgroundColor;

  /// Tooltip border.
  @override
  final BorderSide? border;

  /// Tooltip corner radius.
  @override
  final BorderRadius? borderRadius;

  /// Tooltip inner padding.
  @override
  final EdgeInsets? padding;

  /// Distance between the tooltip and the mark.
  @override
  final double? margin;

  /// Maximum tooltip width.
  @override
  final double? maxWidth;

  /// Whether horizontal overflow is corrected.
  @override
  final bool? fitHorizontally;

  /// Whether vertical overflow is corrected.
  @override
  final bool? fitVertically;

  /// Tooltip text presentation.
  @override
  final StyleSpec<TextSpec>? text;

  const ChartTooltipSpec({
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.padding,
    this.margin,
    this.maxWidth,
    this.fitHorizontally,
    this.fitVertically,
    this.text,
  });
}
