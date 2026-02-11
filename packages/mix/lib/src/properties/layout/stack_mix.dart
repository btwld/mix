import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart' hide Mixable;
import '../../core/prop.dart';
import '../../specs/stack/stack_spec.dart';

part 'stack_mix.g.dart';

/// Mix class for configuring [StackSpec] properties.
///
/// Encapsulates stack layout properties with support for proper Mix framework integration.
@Mixable()
final class StackMix extends Mix<StackSpec>
    with Diagnosticable, _$StackMixMixin {
  @override
  final Prop<AlignmentGeometry>? $alignment;
  @override
  final Prop<StackFit>? $fit;
  @override
  final Prop<TextDirection>? $textDirection;
  @override
  final Prop<Clip>? $clipBehavior;

  /// Main constructor with user-friendly Mix types
  StackMix({
    AlignmentGeometry? alignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? clipBehavior,
  }) : this.create(
         alignment: Prop.maybe(alignment),
         fit: Prop.maybe(fit),
         textDirection: Prop.maybe(textDirection),
         clipBehavior: Prop.maybe(clipBehavior),
       );

  /// Create constructor with `Prop<T>` types for internal use
  const StackMix.create({
    Prop<AlignmentGeometry>? alignment,
    Prop<StackFit>? fit,
    Prop<TextDirection>? textDirection,
    Prop<Clip>? clipBehavior,
  }) : $alignment = alignment,
       $fit = fit,
       $textDirection = textDirection,
       $clipBehavior = clipBehavior;

  /// Constructor that accepts a [StackSpec] value and extracts its properties.
  StackMix.value(StackSpec spec)
    : this(
        alignment: spec.alignment,
        fit: spec.fit,
        textDirection: spec.textDirection,
        clipBehavior: spec.clipBehavior,
      );

  // Factory constructors for common use cases

  /// Alignment factory
  factory StackMix.alignment(AlignmentGeometry value) {
    return StackMix(alignment: value);
  }

  /// Fit factory
  factory StackMix.fit(StackFit value) {
    return StackMix(fit: value);
  }

  /// Text direction factory
  factory StackMix.textDirection(TextDirection value) {
    return StackMix(textDirection: value);
  }

  /// Clip behavior factory
  factory StackMix.clipBehavior(Clip value) {
    return StackMix(clipBehavior: value);
  }

  /// Constructor that accepts a nullable [StackSpec] value.
  ///
  /// Returns null if the input is null, otherwise uses [StackMix.value].
  static StackMix? maybeValue(StackSpec? spec) {
    return spec != null ? StackMix.value(spec) : null;
  }

  // Chainable instance methods

  /// Returns a copy with the specified alignment.
  StackMix alignment(AlignmentGeometry value) {
    return merge(StackMix.alignment(value));
  }

  /// Returns a copy with the specified fit.
  StackMix fit(StackFit value) {
    return merge(StackMix.fit(value));
  }

  /// Returns a copy with the specified text direction.
  StackMix textDirection(TextDirection value) {
    return merge(StackMix.textDirection(value));
  }

  /// Returns a copy with the specified clip behavior.
  StackMix clipBehavior(Clip value) {
    return merge(StackMix.clipBehavior(value));
  }
}
