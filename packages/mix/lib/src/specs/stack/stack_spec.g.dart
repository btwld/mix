// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_spec.dart';

// **************************************************************************
// Generator: SpecDefinitionBuilder
// **************************************************************************

mixin StackSpecMixable on Spec<StackSpec> {
  /// Retrieves the [StackSpec] from a MixData.
  static StackSpec from(MixData mix) {
    return mix.attributeOf<StackSpecAttribute>()?.resolve(mix) ??
        const StackSpec();
  }

  /// Retrieves the [StackSpec] from the nearest [Mix] ancestor.
  ///
  /// If no ancestor is found, returns [StackSpec].
  static StackSpec of(BuildContext context) {
    return StackSpecMixable.from(Mix.of(context));
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
  }) {
    return StackSpec(
      alignment: alignment ?? _$this.alignment,
      fit: fit ?? _$this.fit,
      textDirection: textDirection ?? _$this.textDirection,
      clipBehavior: clipBehavior ?? _$this.clipBehavior,
      animated: animated ?? _$this.animated,
    );
  }

  @override
  StackSpec lerp(
    StackSpec? other,
    double t,
  ) {
    if (other == null) return _$this;

    return StackSpec(
      alignment: AlignmentGeometry.lerp(
        _$this.alignment,
        other._$this.alignment,
        t,
      ),
      fit: t < 0.5 ? _$this.fit : other._$this.fit,
      textDirection:
          t < 0.5 ? _$this.textDirection : other._$this.textDirection,
      clipBehavior: t < 0.5 ? _$this.clipBehavior : other._$this.clipBehavior,
      animated: t < 0.5 ? _$this.animated : other._$this.animated,
    );
  }

  /// The list of properties that constitute the state of this [StackSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [StackSpec] instances for equality.
  @override
  List<Object?> get props {
    return [
      _$this.alignment,
      _$this.fit,
      _$this.textDirection,
      _$this.clipBehavior,
      _$this.animated,
    ];
  }

  StackSpec get _$this => this as StackSpec;
}

/// Represents the attributes of a [StackSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [StackSpec].
///
/// Use this class to configure the attributes of a [StackSpec] and pass it to
/// the [StackSpec] constructor.
class StackSpecAttribute extends SpecAttribute<StackSpec> {
  const StackSpecAttribute({
    this.alignment,
    this.fit,
    this.textDirection,
    this.clipBehavior,
    super.animated,
  });

  final AlignmentGeometry? alignment;

  final StackFit? fit;

  final TextDirection? textDirection;

  final Clip? clipBehavior;

  @override
  StackSpec resolve(MixData mix) {
    return StackSpec(
      alignment: alignment,
      fit: fit,
      textDirection: textDirection,
      clipBehavior: clipBehavior,
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  @override
  StackSpecAttribute merge(StackSpecAttribute? other) {
    if (other == null) return this;

    return StackSpecAttribute(
      alignment: other.alignment ?? alignment,
      fit: other.fit ?? fit,
      textDirection: other.textDirection ?? textDirection,
      clipBehavior: other.clipBehavior ?? clipBehavior,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [StackSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [StackSpecAttribute] instances for equality.
  @override
  List<Object?> get props {
    return [
      alignment,
      fit,
      textDirection,
      clipBehavior,
      animated,
    ];
  }
}

/// Utility class for configuring [StackSpecAttribute] properties.
///
/// This class provides methods to set individual properties of a [StackSpecAttribute].
///
/// Use the methods of this class to configure specific properties of a [StackSpecAttribute].
class StackSpecUtility<T extends Attribute>
    extends SpecUtility<T, StackSpecAttribute> {
  StackSpecUtility(super.builder);

  /// Utility for defining [StackSpecAttribute.alignment]
  late final alignment = AlignmentUtility((v) => only(alignment: v));

  /// Utility for defining [StackSpecAttribute.fit]
  late final fit = StackFitUtility((v) => only(fit: v));

  /// Utility for defining [StackSpecAttribute.textDirection]
  late final textDirection =
      TextDirectionUtility((v) => only(textDirection: v));

  /// Utility for defining [StackSpecAttribute.clipBehavior]
  late final clipBehavior = ClipUtility((v) => only(clipBehavior: v));

  /// Utility for defining [StackSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  /// Returns a new [StackSpecAttribute] with the specified properties.
  @override
  T only({
    AlignmentGeometry? alignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? clipBehavior,
    AnimatedDataDto? animated,
  }) {
    return builder(
      StackSpecAttribute(
        alignment: alignment,
        fit: fit,
        textDirection: textDirection,
        clipBehavior: clipBehavior,
        animated: animated,
      ),
    );
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
    if (begin == null && end == null) return const StackSpec();
    if (begin == null) return end!;

    return begin!.lerp(end!, t);
  }
}
