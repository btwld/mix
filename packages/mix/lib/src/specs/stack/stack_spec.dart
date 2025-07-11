import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../attributes/animation/animated_config_dto.dart';
import '../../attributes/animation/animated_util.dart';
import '../../attributes/animation/animation_config.dart';
import '../../attributes/enum/enum_util.dart';
import '../../attributes/modifiers/widget_modifiers_config.dart';
import '../../attributes/modifiers/widget_modifiers_config_dto.dart';
import '../../attributes/modifiers/widget_modifiers_util.dart';
import '../../attributes/scalars/scalar_util.dart';
import '../../core/computed_style/computed_style.dart';
import '../../core/factory/mix_context.dart';
import '../../core/factory/style_mix.dart';
import '../../core/spec.dart';
import 'stack_widget.dart';

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
    super.animated,
    super.modifiers,
  });

  static StackSpec from(MixContext mix) {
    return mix.attributeOf<StackSpecAttribute>()?.resolve(mix) ??
        const StackSpec();
  }

  /// {@template stack_spec_of}
  /// Retrieves the [StackSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [StackSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [StackSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final stackSpec = StackSpec.of(context);
  /// ```
  /// {@endtemplate}
  static StackSpec of(BuildContext context) {
    return ComputedStyle.specOf(context) ?? const StackSpec();
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
    properties.add(
      DiagnosticsProperty('animated', animated, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('modifiers', modifiers, defaultValue: null),
    );
  }

  Widget call({List<Widget> children = const []}) {
    return isAnimated
        ? AnimatedStackSpecWidget(
            spec: this,
            curve: animated!.curve,
            duration: animated!.duration,
            children: children,
          )
        : StackSpecWidget(spec: this, children: children);
  }

  /// Creates a copy of this [StackSpec] but with the given fields
  /// replaced with the new values.
  @override
  StackSpec copyWith({
    AlignmentGeometry? alignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? clipBehavior,
    AnimationConfig? animated,
    WidgetModifiersConfig? modifiers,
  }) {
    return StackSpec(
      alignment: alignment ?? this.alignment,
      fit: fit ?? this.fit,
      textDirection: textDirection ?? this.textDirection,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      animated: animated ?? this.animated,
      modifiers: modifiers ?? this.modifiers,
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
      animated: animated ?? other.animated,
      modifiers: other.modifiers,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  /// The list of properties that constitute the state of this [StackSpec].
  @override
  List<Object?> get props => [
    alignment,
    fit,
    textDirection,
    clipBehavior,
    animated,
    modifiers,
  ];
}

/// Represents the attributes of a [StackSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [StackSpec].
///
/// Use this class to configure the attributes of a [StackSpec] and pass it to
/// the [StackSpec] constructor.
class StackSpecAttribute extends SpecAttribute<StackSpec> with Diagnosticable {
  final AlignmentGeometry? alignment;
  final StackFit? fit;
  final TextDirection? textDirection;
  final Clip? clipBehavior;

  const StackSpecAttribute({
    this.alignment,
    this.fit,
    this.textDirection,
    this.clipBehavior,
    super.animated,
    super.modifiers,
  });

  /// Constructor that accepts a [StackSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [StackSpec] instances to [StackSpecAttribute].
  ///
  /// ```dart
  /// const spec = StackSpec(alignment: AlignmentDirectional.topStart, fit: StackFit.loose);
  /// final attr = StackSpecAttribute.value(spec);
  /// ```
  static StackSpecAttribute value(StackSpec spec) {
    return StackSpecAttribute(
      alignment: spec.alignment,
      fit: spec.fit,
      textDirection: spec.textDirection,
      clipBehavior: spec.clipBehavior,
      animated: AnimationConfigDto.maybeValue(spec.animated),
      modifiers: WidgetModifiersConfigDto.maybeValue(spec.modifiers),
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

  /// Resolves to [StackSpec] using the provided [MixContext].
  @override
  StackSpec resolve(MixContext context) {
    return StackSpec(
      alignment: alignment,
      fit: fit,
      textDirection: textDirection,
      clipBehavior: clipBehavior,
      animated: animated?.resolve(context),
      modifiers: modifiers?.resolve(context),
    );
  }

  /// Merges the properties of this [StackSpecAttribute] with the properties of [other].
  @override
  StackSpecAttribute merge(StackSpecAttribute? other) {
    if (other == null) return this;

    return StackSpecAttribute(
      alignment: other.alignment ?? alignment,
      fit: other.fit ?? fit,
      textDirection: other.textDirection ?? textDirection,
      clipBehavior: other.clipBehavior ?? clipBehavior,
      animated: animated?.merge(other.animated) ?? other.animated,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
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
    properties.add(
      DiagnosticsProperty('animated', animated, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('modifiers', modifiers, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [StackSpecAttribute].
  @override
  List<Object?> get props => [
    alignment,
    fit,
    textDirection,
    clipBehavior,
    animated,
    modifiers,
  ];
}

/// Utility class for configuring [StackSpec] properties.
///
/// This class provides methods to set individual properties of a [StackSpec].
/// Use the methods of this class to configure specific properties of a [StackSpec].
class StackSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, StackSpecAttribute> {
  /// Utility for defining [StackSpecAttribute.alignment]
  late final alignment = AlignmentGeometryUtility((v) => only(alignment: v));

  /// Utility for defining [StackSpecAttribute.fit]
  late final fit = StackFitUtility((v) => only(fit: v));

  /// Utility for defining [StackSpecAttribute.textDirection]
  late final textDirection = TextDirectionUtility(
    (v) => only(textDirection: v),
  );

  /// Utility for defining [StackSpecAttribute.clipBehavior]
  late final clipBehavior = ClipUtility((v) => only(clipBehavior: v));

  /// Utility for defining [StackSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  /// Utility for defining [StackSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  StackSpecUtility(
    super.attributeBuilder, {
    @Deprecated(
      'mutable parameter is no longer used. All SpecUtilities are now mutable by default.',
    )
    bool? mutable,
  });

  @Deprecated(
    'Use "this" instead of "chain" for method chaining. '
    'The chain getter will be removed in a future version.',
  )
  StackSpecUtility<T> get chain => StackSpecUtility(attributeBuilder);

  static StackSpecUtility<StackSpecAttribute> get self =>
      StackSpecUtility((v) => v);

  /// Returns a new [StackSpecAttribute] with the specified properties.
  @override
  T only({
    AlignmentGeometry? alignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? clipBehavior,
    AnimationConfigDto? animated,
    WidgetModifiersConfigDto? modifiers,
  }) {
    return builder(
      StackSpecAttribute(
        alignment: alignment,
        fit: fit,
        textDirection: textDirection,
        clipBehavior: clipBehavior,
        animated: animated,
        modifiers: modifiers,
      ),
    );
  }
}

/// A tween that interpolates between two [StackSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [StackSpec] specifications.
class StackSpecTween extends Tween<StackSpec?> {
  StackSpecTween({super.begin, super.end});

  @override
  StackSpec lerp(double t) {
    if (begin == null && end == null) {
      return const StackSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
