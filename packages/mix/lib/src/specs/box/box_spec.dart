import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../core/helpers.dart';
import '../../core/spec.dart';

part 'box_spec.g.dart';

/// Specification for box styling and layout properties.
///
/// Provides comprehensive box styling including alignment, padding, margin, constraints,
/// decoration, transformation, and clipping behavior. Used as the resolved form
/// of [BoxStyle] styling attributes.
@MixableSpec()
@immutable
final class BoxSpec extends Spec<BoxSpec>
    with Diagnosticable, _$BoxSpecMethods {
  /// Aligns the child within the box.
  @override
  final AlignmentGeometry? alignment;

  /// Adds empty space inside the box.
  @override
  final EdgeInsetsGeometry? padding;

  /// Adds empty space around the box.
  @override
  final EdgeInsetsGeometry? margin;

  /// Applies additional constraints to the child.
  @override
  final BoxConstraints? constraints;

  /// Paints a decoration behind the child.
  @override
  final Decoration? decoration;

  /// Paints a decoration in front of the child.
  @override
  final Decoration? foregroundDecoration;

  /// Applies a transformation matrix before painting the box.
  @override
  final Matrix4? transform;

  /// Aligns the origin of the coordinate system for the [transform].
  @override
  final AlignmentGeometry? transformAlignment;

  /// Defines the clip behavior for the box when content overflows.
  @override
  final Clip? clipBehavior;

  const BoxSpec({
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
