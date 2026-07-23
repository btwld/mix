import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../models/chart_enums.dart';

part 'chart_marker_spec.g.dart';

/// Resolved presentation for line-chart point markers.
@MixableSpec()
@immutable
final class ChartMarkerSpec with _$ChartMarkerSpec {
  /// Whether markers are visible.
  @override
  final bool? show;

  /// Built-in marker shape.
  @override
  final ChartMarkerShape? shape;

  /// Marker fill color.
  @override
  final Color? color;

  /// Marker radius. Square and cross markers use twice this value as size.
  @override
  final double? radius;

  /// Marker outline color.
  @override
  final Color? borderColor;

  /// Marker outline width.
  @override
  final double? borderWidth;

  /// Optional marker shadow.
  @override
  final Shadow? shadow;

  const ChartMarkerSpec({
    this.show,
    this.shape,
    this.color,
    this.radius,
    this.borderColor,
    this.borderWidth,
    this.shadow,
  });
}
