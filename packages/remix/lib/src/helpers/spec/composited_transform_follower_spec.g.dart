// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'composited_transform_follower_spec.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [CompositedTransformFollowerSpec].
mixin _$CompositedTransformFollowerSpec
    on Spec<CompositedTransformFollowerSpec> {
  static CompositedTransformFollowerSpec from(MixData mix) {
    return mix
            .attributeOf<CompositedTransformFollowerSpecAttribute>()
            ?.resolve(mix) ??
        const CompositedTransformFollowerSpec();
  }

  /// {@template composited_transform_follower_spec_of}
  /// Retrieves the [CompositedTransformFollowerSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [CompositedTransformFollowerSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [CompositedTransformFollowerSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final compositedTransformFollowerSpec = CompositedTransformFollowerSpec.of(context);
  /// ```
  /// {@endtemplate}
  static CompositedTransformFollowerSpec of(BuildContext context) {
    return ComputedStyle.specOf<CompositedTransformFollowerSpec>(context) ??
        const CompositedTransformFollowerSpec();
  }

  /// Creates a copy of this [CompositedTransformFollowerSpec] but with the given fields
  /// replaced with the new values.
  @override
  CompositedTransformFollowerSpec copyWith({
    Offset? offset,
    AlignmentGeometry? targetAnchor,
    AlignmentGeometry? followerAnchor,
    WidgetModifiersData? modifiers,
    AnimatedData? animated,
  }) {
    return CompositedTransformFollowerSpec(
      offset: offset ?? _$this.offset,
      targetAnchor: targetAnchor ?? _$this.targetAnchor,
      followerAnchor: followerAnchor ?? _$this.followerAnchor,
      modifiers: modifiers ?? _$this.modifiers,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [CompositedTransformFollowerSpec] and another [CompositedTransformFollowerSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [CompositedTransformFollowerSpec] is returned. When [t] is 1.0, the [other] [CompositedTransformFollowerSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [CompositedTransformFollowerSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [CompositedTransformFollowerSpec] instance.
  ///
  /// The interpolation is performed on each property of the [CompositedTransformFollowerSpec] using the appropriate
  /// interpolation method:
  /// - [Offset.lerp] for [offset].
  /// - [AlignmentGeometry.lerp] for [targetAnchor] and [followerAnchor].
  /// For [modifiers] and [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [CompositedTransformFollowerSpec] is used. Otherwise, the value
  /// from the [other] [CompositedTransformFollowerSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [CompositedTransformFollowerSpec] configurations.
  @override
  CompositedTransformFollowerSpec lerp(
      CompositedTransformFollowerSpec? other, double t) {
    if (other == null) return _$this;

    return CompositedTransformFollowerSpec(
      offset: Offset.lerp(_$this.offset, other.offset, t)!,
      targetAnchor:
          AlignmentGeometry.lerp(_$this.targetAnchor, other.targetAnchor, t)!,
      followerAnchor: AlignmentGeometry.lerp(
          _$this.followerAnchor, other.followerAnchor, t)!,
      modifiers: other.modifiers,
      animated: _$this.animated ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [CompositedTransformFollowerSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [CompositedTransformFollowerSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.offset,
        _$this.targetAnchor,
        _$this.followerAnchor,
        _$this.modifiers,
        _$this.animated,
      ];

  CompositedTransformFollowerSpec get _$this =>
      this as CompositedTransformFollowerSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
        .add(DiagnosticsProperty('offset', _$this.offset, defaultValue: null));
    properties.add(DiagnosticsProperty('targetAnchor', _$this.targetAnchor,
        defaultValue: null));
    properties.add(DiagnosticsProperty('followerAnchor', _$this.followerAnchor,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
  }
}

/// Represents the attributes of a [CompositedTransformFollowerSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [CompositedTransformFollowerSpec].
///
/// Use this class to configure the attributes of a [CompositedTransformFollowerSpec] and pass it to
/// the [CompositedTransformFollowerSpec] constructor.
class CompositedTransformFollowerSpecAttribute
    extends SpecAttribute<CompositedTransformFollowerSpec> with Diagnosticable {
  final Offset? offset;
  final AlignmentGeometry? targetAnchor;
  final AlignmentGeometry? followerAnchor;

  const CompositedTransformFollowerSpecAttribute({
    this.offset,
    this.targetAnchor,
    this.followerAnchor,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [CompositedTransformFollowerSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final compositedTransformFollowerSpec = CompositedTransformFollowerSpecAttribute(...).resolve(mix);
  /// ```
  @override
  CompositedTransformFollowerSpec resolve(MixData mix) {
    return CompositedTransformFollowerSpec(
      offset: offset,
      targetAnchor: targetAnchor,
      followerAnchor: followerAnchor,
      modifiers: modifiers?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [CompositedTransformFollowerSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [CompositedTransformFollowerSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  CompositedTransformFollowerSpecAttribute merge(
      CompositedTransformFollowerSpecAttribute? other) {
    if (other == null) return this;

    return CompositedTransformFollowerSpecAttribute(
      offset: other.offset ?? offset,
      targetAnchor: other.targetAnchor ?? targetAnchor,
      followerAnchor: other.followerAnchor ?? followerAnchor,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [CompositedTransformFollowerSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [CompositedTransformFollowerSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        offset,
        targetAnchor,
        followerAnchor,
        modifiers,
        animated,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('offset', offset, defaultValue: null));
    properties.add(
        DiagnosticsProperty('targetAnchor', targetAnchor, defaultValue: null));
    properties.add(DiagnosticsProperty('followerAnchor', followerAnchor,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
  }
}

/// Utility class for configuring [CompositedTransformFollowerSpec] properties.
///
/// This class provides methods to set individual properties of a [CompositedTransformFollowerSpec].
/// Use the methods of this class to configure specific properties of a [CompositedTransformFollowerSpec].
class CompositedTransformFollowerSpecUtility<T extends Attribute>
    extends SpecUtility<T, CompositedTransformFollowerSpecAttribute> {
  /// Utility for defining [CompositedTransformFollowerSpecAttribute.offset]
  late final offset = OffsetUtility((v) => only(offset: v));

  /// Utility for defining [CompositedTransformFollowerSpecAttribute.targetAnchor]
  late final targetAnchor =
      AlignmentGeometryUtility((v) => only(targetAnchor: v));

  /// Utility for defining [CompositedTransformFollowerSpecAttribute.followerAnchor]
  late final followerAnchor =
      AlignmentGeometryUtility((v) => only(followerAnchor: v));

  /// Utility for defining [CompositedTransformFollowerSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [CompositedTransformFollowerSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  CompositedTransformFollowerSpecUtility(
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
  CompositedTransformFollowerSpecUtility<T> get chain =>
      CompositedTransformFollowerSpecUtility(attributeBuilder);

  static CompositedTransformFollowerSpecUtility<
          CompositedTransformFollowerSpecAttribute>
      get self => CompositedTransformFollowerSpecUtility((v) => v);

  /// Returns a new [CompositedTransformFollowerSpecAttribute] with the specified properties.
  @override
  T only({
    Offset? offset,
    AlignmentGeometry? targetAnchor,
    AlignmentGeometry? followerAnchor,
    WidgetModifiersDataDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(CompositedTransformFollowerSpecAttribute(
      offset: offset,
      targetAnchor: targetAnchor,
      followerAnchor: followerAnchor,
      modifiers: modifiers,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [CompositedTransformFollowerSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [CompositedTransformFollowerSpec] specifications.
class CompositedTransformFollowerSpecTween
    extends Tween<CompositedTransformFollowerSpec?> {
  CompositedTransformFollowerSpecTween({
    super.begin,
    super.end,
  });

  @override
  CompositedTransformFollowerSpec lerp(double t) {
    if (begin == null && end == null) {
      return const CompositedTransformFollowerSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
