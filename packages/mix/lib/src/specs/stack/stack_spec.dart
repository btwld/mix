import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../attributes/enum/enum_util.dart';
import '../../attributes/scalars/scalar_util.dart';
import '../../core/attribute.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/resolved_style_provider.dart';
import '../../core/spec.dart';
import '../../core/utility.dart';

final class StackSpec extends Spec<StackSpec> with Diagnosticable {
  final AlignmentGeometry? alignment;
  final StackFit? fit;
  final TextDirection? textDirection;
  final Clip? clipBehavior;

  const StackSpec({
    this.alignment,
    this.fit,
    this.textDirection,
    this.clipBehavior,
  });

  static StackSpec from(BuildContext context) {
    return maybeOf(context) ?? const StackSpec();
  }

  /// Retrieves the [StackSpec] from the nearest [ResolvedStyleProvider] ancestor.
  ///
  /// Returns null if no ancestor [ResolvedStyleProvider] is found.
  static StackSpec? maybeOf(BuildContext context) {
    return ResolvedStyleProvider.of<StackSpec>(context)?.spec;
  }

  /// {@template stack_spec_of}
  /// Retrieves the [StackSpec] from the nearest [ResolvedStyleProvider] ancestor in the widget tree.
  ///
  /// This method uses [ResolvedStyleProvider.of] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [StackSpec] changes, not when other specs change.
  /// If no ancestor [ResolvedStyleProvider] is found, this method returns an empty [StackSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final stackSpec = StackSpec.of(context);
  /// ```
  /// {@endtemplate}
  static StackSpec of(BuildContext context) {
    return maybeOf(context) ?? const StackSpec();
  }

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
      DiagnosticsProperty('alignment', alignment, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('fit', fit, defaultValue: null));
    properties.add(
      DiagnosticsProperty('textDirection', textDirection, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
  }

  /// Creates a copy of this [StackSpec] but with the given fields
  /// replaced with the new values.
  @override
  StackSpec copyWith({
    AlignmentGeometry? alignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? clipBehavior,
  }) {
    return StackSpec(
      alignment: alignment ?? this.alignment,
      fit: fit ?? this.fit,
      textDirection: textDirection ?? this.textDirection,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [StackSpec] and another [StackSpec] based on the given parameter [t].
  @override
  StackSpec lerp(StackSpec? other, double t) {
    if (other == null) return this;

    return StackSpec(
      alignment: AlignmentGeometry.lerp(alignment, other.alignment, t),
      fit: t < 0.5 ? fit : other.fit,
      textDirection: t < 0.5 ? textDirection : other.textDirection,
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  /// The list of properties that constitute the state of this [StackSpec].
  @override
  List<Object?> get props => [alignment, fit, textDirection, clipBehavior];
}

/// Represents the attributes of a [StackSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [StackSpec].
///
/// Use this class to configure the attributes of a [StackSpec] and pass it to
/// the [StackSpec] constructor.
class StackSpecAttribute extends SpecAttribute<StackSpec> with Diagnosticable {
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<StackFit>? $fit;
  final Prop<TextDirection>? $textDirection;
  final Prop<Clip>? $clipBehavior;

  const StackSpecAttribute({
    Prop<AlignmentGeometry>? alignment,
    Prop<StackFit>? fit,
    Prop<TextDirection>? textDirection,
    Prop<Clip>? clipBehavior,
    super.animation,
    super.modifiers,
    super.variants,
  }) : $alignment = alignment,
       $fit = fit,
       $textDirection = textDirection,
       $clipBehavior = clipBehavior;

  StackSpecAttribute.only({
    AlignmentGeometry? alignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? clipBehavior,
    AnimationConfig? animation,
    List<ModifierSpecAttribute>? modifiers,
    List<VariantAttribute<StackSpec>>? variants,
  }) : this(
         alignment: Prop.maybe(alignment),
         fit: Prop.maybe(fit),
         textDirection: Prop.maybe(textDirection),
         clipBehavior: Prop.maybe(clipBehavior),
         animation: animation,
         modifiers: modifiers,
         variants: variants,
       );

  StackSpecAttribute.alignment(AlignmentGeometry value)
    : this.only(alignment: value);

  StackSpecAttribute.fit(StackFit value) : this.only(fit: value);

  StackSpecAttribute.textDirection(TextDirection value)
    : this.only(textDirection: value);

  StackSpecAttribute.clipBehavior(Clip value) : this.only(clipBehavior: value);

  /// Constructor that accepts a [StackSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [StackSpec] instances to [StackSpecAttribute].
  ///
  /// ```dart
  /// const spec = StackSpec(alignment: AlignmentDirectional.topStart, fit: StackFit.loose);
  /// final attr = StackSpecAttribute.value(spec);
  /// ```
  static StackSpecAttribute value(StackSpec spec) {
    return StackSpecAttribute.only(
      alignment: spec.alignment,
      fit: spec.fit,
      textDirection: spec.textDirection,
      clipBehavior: spec.clipBehavior,
    );
  }

  /// Constructor that accepts a nullable [StackSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [StackSpecAttribute.value].
  ///
  /// ```dart
  /// const StackSpec? spec = StackSpec(alignment: AlignmentDirectional.topStart, fit: StackFit.loose);
  /// final attr = StackSpecAttribute.maybeValue(spec); // Returns StackSpecAttribute or null
  /// ```
  static StackSpecAttribute? maybeValue(StackSpec? spec) {
    return spec != null ? StackSpecAttribute.value(spec) : null;
  }

  StackSpecAttribute alignment(AlignmentGeometry value) {
    return StackSpecAttribute.only(alignment: value);
  }

  StackSpecAttribute fit(StackFit value) {
    return StackSpecAttribute.only(fit: value);
  }

  StackSpecAttribute textDirection(TextDirection value) {
    return StackSpecAttribute.only(textDirection: value);
  }

  StackSpecAttribute clipBehavior(Clip value) {
    return StackSpecAttribute.only(clipBehavior: value);
  }

  /// Resolves to [StackSpec] using the provided [MixContext].
  @override
  StackSpec resolve(BuildContext context) {
    return StackSpec(
      alignment: MixHelpers.resolve(context, $alignment),
      fit: MixHelpers.resolve(context, $fit),
      textDirection: MixHelpers.resolve(context, $textDirection),
      clipBehavior: MixHelpers.resolve(context, $clipBehavior),
    );
  }

  /// Merges the properties of this [StackSpecAttribute] with the properties of [other].
  @override
  StackSpecAttribute merge(StackSpecAttribute? other) {
    if (other == null) return this;

    return StackSpecAttribute(
      alignment: MixHelpers.merge($alignment, other.$alignment),
      fit: MixHelpers.merge($fit, other.$fit),
      textDirection: MixHelpers.merge($textDirection, other.$textDirection),
      clipBehavior: MixHelpers.merge($clipBehavior, other.$clipBehavior),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('alignment', $alignment, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('fit', $fit, defaultValue: null));
    properties.add(
      DiagnosticsProperty('textDirection', $textDirection, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('clipBehavior', $clipBehavior, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [StackSpecAttribute].
  @override
  List<Object?> get props => [$alignment, $fit, $textDirection, $clipBehavior];
}

/// Utility class for configuring [StackSpec] properties.
///
/// This class provides methods to set individual properties of a [StackSpec].
/// Use the methods of this class to configure specific properties of a [StackSpec].
class StackSpecUtility extends SpecUtility<StackSpec> {
  @override
  final StackSpecAttribute attribute;

  /// Utility for defining [StackSpecAttribute.alignment]
  late final alignment = AlignmentGeometryUtility(
    (v) => build(StackSpecAttribute(alignment: v)),
  );

  /// Utility for defining [StackSpecAttribute.fit]
  late final fit = StackFitUtility((v) => build(StackSpecAttribute(fit: v)));

  /// Utility for defining [StackSpecAttribute.textDirection]
  late final textDirection = TextDirectionUtility(
    (v) => build(StackSpecAttribute(textDirection: v)),
  );

  /// Utility for defining [StackSpecAttribute.clipBehavior]
  late final clipBehavior = ClipUtility(
    (v) => build(StackSpecAttribute(clipBehavior: v)),
  );

  StackSpecUtility({this.attribute = const StackSpecAttribute()});

  static StackSpecUtility get self => StackSpecUtility();

  StackSpecUtility build(StackSpecAttribute attribute) {
    return StackSpecUtility(attribute: this.attribute.merge(attribute));
  }
}
