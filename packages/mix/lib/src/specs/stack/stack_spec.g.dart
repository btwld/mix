// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_spec.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [StackSpec].
mixin _$StackSpec on Spec<StackSpec> {
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
    return ComputedStyle.specOf<StackSpec>(context) ?? const StackSpec();
  }

  /// Creates a copy of this [StackSpec] but with the given fields
  /// replaced with the new values.
  @override
  StackSpec copyWith({
    AlignmentGeometry? alignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? clipBehavior,
    AnimatedData? animated,
    WidgetModifiersConfig? modifiers,
  }) {
    return StackSpec(
      alignment: alignment ?? _$this.alignment,
      fit: fit ?? _$this.fit,
      textDirection: textDirection ?? _$this.textDirection,
      clipBehavior: clipBehavior ?? _$this.clipBehavior,
      animated: animated ?? _$this.animated,
      modifiers: modifiers ?? _$this.modifiers,
    );
  }

  /// Linearly interpolates between this [StackSpec] and another [StackSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [StackSpec] is returned. When [t] is 1.0, the [other] [StackSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [StackSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [StackSpec] instance.
  ///
  /// The interpolation is performed on each property of the [StackSpec] using the appropriate
  /// interpolation method:
  /// - [AlignmentGeometry.lerp] for [alignment].
  /// For [fit] and [textDirection] and [clipBehavior] and [animated] and [modifiers], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [StackSpec] is used. Otherwise, the value
  /// from the [other] [StackSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [StackSpec] configurations.
  @override
  StackSpec lerp(StackSpec? other, double t) {
    if (other == null) return _$this;

    return StackSpec(
      alignment: AlignmentGeometry.lerp(_$this.alignment, other.alignment, t),
      fit: t < 0.5 ? _$this.fit : other.fit,
      textDirection: t < 0.5 ? _$this.textDirection : other.textDirection,
      clipBehavior: t < 0.5 ? _$this.clipBehavior : other.clipBehavior,
      animated: _$this.animated ?? other.animated,
      modifiers: other.modifiers,
    );
  }

  /// The list of properties that constitute the state of this [StackSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [StackSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.alignment,
        _$this.fit,
        _$this.textDirection,
        _$this.clipBehavior,
        _$this.animated,
        _$this.modifiers,
      ];

  StackSpec get _$this => this as StackSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('alignment', _$this.alignment, defaultValue: null));
    properties.add(DiagnosticsProperty('fit', _$this.fit, defaultValue: null));
    properties.add(DiagnosticsProperty('textDirection', _$this.textDirection,
        defaultValue: null));
    properties.add(DiagnosticsProperty('clipBehavior', _$this.clipBehavior,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
  }
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

  /// Resolves to [StackSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final stackSpec = StackSpecAttribute(...).resolve(mix);
  /// ```
  @override
  StackSpec resolve(MixContext mix) {
    return StackSpec(
      alignment: alignment,
      fit: fit,
      textDirection: textDirection,
      clipBehavior: clipBehavior,
      animated: animated?.resolve(mix) ?? mix.animation,
      modifiers: modifiers?.resolve(mix),
    );
  }

  /// Merges the properties of this [StackSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [StackSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
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

  /// The list of properties that constitute the state of this [StackSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [StackSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        alignment,
        fit,
        textDirection,
        clipBehavior,
        animated,
        modifiers,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('alignment', alignment, defaultValue: null));
    properties.add(DiagnosticsProperty('fit', fit, defaultValue: null));
    properties.add(DiagnosticsProperty('textDirection', textDirection,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
  }
}

/// Utility class for configuring [StackSpec] properties.
///
/// This class provides methods to set individual properties of a [StackSpec].
/// Use the methods of this class to configure specific properties of a [StackSpec].
class StackSpecUtility<T extends StyleElement>
    extends SpecUtility<T, StackSpecAttribute> {
  /// Utility for defining [StackSpecAttribute.alignment]
  late final alignment = AlignmentGeometryUtility((v) => only(alignment: v));

  /// Utility for defining [StackSpecAttribute.fit]
  late final fit = StackFitUtility((v) => only(fit: v));

  /// Utility for defining [StackSpecAttribute.textDirection]
  late final textDirection =
      TextDirectionUtility((v) => only(textDirection: v));

  /// Utility for defining [StackSpecAttribute.clipBehavior]
  late final clipBehavior = ClipUtility((v) => only(clipBehavior: v));

  /// Utility for defining [StackSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  /// Utility for defining [StackSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  StackSpecUtility(
    super.builder, {
    @Deprecated(
      'mutable parameter is no longer used. All SpecUtilities are now mutable by default.',
    )
    super.mutable,
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
    AnimatedDataDto? animated,
    WidgetModifiersConfigDto? modifiers,
  }) {
    return builder(StackSpecAttribute(
      alignment: alignment,
      fit: fit,
      textDirection: textDirection,
      clipBehavior: clipBehavior,
      animated: animated,
      modifiers: modifiers,
    ));
  }
}

/// A tween that interpolates between two [StackSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [StackSpec] specifications.
class StackSpecTween extends Tween<StackSpec?> {
  StackSpecTween({
    super.begin,
    super.end,
  });

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
