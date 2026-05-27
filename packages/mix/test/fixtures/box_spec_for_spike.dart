// ignore_for_file: annotate_overrides

import 'package:flutter/painting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'box_spec_for_spike.g.dart';

@MixableSpec()
final class BoxSpecForSpike with _$BoxSpecForSpike {
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxConstraints? constraints;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  @MixableField(skipMixin: true)
  final Matrix4? transform;
  @MixableField(skipMixin: true)
  final AlignmentGeometry? transformAlignment;
  final Clip? clipBehavior;

  const BoxSpecForSpike({
    this.alignment,
    this.padding,
    this.margin,
    this.constraints,
    this.decoration,
    this.foregroundDecoration,
    this.transform,
    this.transformAlignment,
    this.clipBehavior,
  });
}
