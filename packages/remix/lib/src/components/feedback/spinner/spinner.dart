import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'spinner.g.dart';
part 'spinner_painter.dart';
part 'spinner_style.dart';
part 'spinner_widget.dart';

enum SpinnerTypeStyle {
  solid,
  dotted,
}

@MixableSpec()
final class SpinnerSpec extends Spec<SpinnerSpec>
    with _$SpinnerSpec, Diagnosticable {
  /// Size of the spinner
  final double size;

  /// Width of the stroke of the line
  /// Needs to be a double between 0 and 1
  final double? strokeWidth;

  /// Color of the spinner line
  final Color color;

  /// Duration of a full cycle of spin
  final Duration duration;

  @MixableField(
    utilities: [MixableFieldUtility(type: SpinnerTypeStyleUtility)],
  )
  final SpinnerTypeStyle style;

  /// {@macro spinner_spec_of}
  static const of = _$SpinnerSpec.of;
  static const from = _$SpinnerSpec.from;

  const SpinnerSpec({
    double? size,
    this.strokeWidth,
    Color? color,
    Duration? duration,
    SpinnerTypeStyle? style,
    super.modifiers,
    super.animated,
  })  : size = size ?? 24,
        color = color ?? Colors.white,
        style = style ?? SpinnerTypeStyle.solid,
        duration = duration ?? const Duration(milliseconds: 500);

  Widget call() => SpinnerSpecWidget(spec: this);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}

final class SpinnerTypeStyleUtility<T extends StyleElement>
    extends ScalarUtility<T, SpinnerTypeStyle> {
  const SpinnerTypeStyleUtility(super.builder);

  T dotted() => call(SpinnerTypeStyle.dotted);
  T solid() => call(SpinnerTypeStyle.solid);
}
