import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import '../../specs/stack/stack_spec.dart';

/// Mix class for configuring [StackSpec] properties.
///
/// Encapsulates stack layout properties with support for proper Mix framework integration.
final class StackMix extends Mix<StackSpec> with Diagnosticable {
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<StackFit>? $fit;
  final Prop<TextDirection>? $textDirection;
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

  /// Resolves to [StackSpec] using the provided [BuildContext].
  @override
  StackSpec resolve(BuildContext context) {
    return StackSpec(
      alignment: MixOps.resolve(context, $alignment),
      fit: MixOps.resolve(context, $fit),
      textDirection: MixOps.resolve(context, $textDirection),
      clipBehavior: MixOps.resolve(context, $clipBehavior),
    );
  }

  /// Merges the properties of this [StackMix] with the properties of [other].
  @override
  StackMix merge(StackMix? other) {
    if (other == null) return this;

    return StackMix.create(
      alignment: MixOps.merge($alignment, other.$alignment),
      fit: MixOps.merge($fit, other.$fit),
      textDirection: MixOps.merge($textDirection, other.$textDirection),
      clipBehavior: MixOps.merge($clipBehavior, other.$clipBehavior),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('alignment', $alignment))
      ..add(DiagnosticsProperty('fit', $fit))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior));
  }

  @override
  List<Object?> get props => [$alignment, $fit, $textDirection, $clipBehavior];
}
