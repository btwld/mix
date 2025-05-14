// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'divider.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [DividerSpec].
mixin _$DividerSpec on Spec<DividerSpec> {
  static DividerSpec from(MixData mix) {
    return mix.attributeOf<DividerSpecAttribute>()?.resolve(mix) ??
        const DividerSpec();
  }

  /// {@template divider_spec_of}
  /// Retrieves the [DividerSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [DividerSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [DividerSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final dividerSpec = DividerSpec.of(context);
  /// ```
  /// {@endtemplate}
  static DividerSpec of(BuildContext context) {
    return _$DividerSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [DividerSpec] but with the given fields
  /// replaced with the new values.
  @override
  DividerSpec copyWith({
    BoxSpec? container,
    AnimatedData? animated,
    WidgetModifiersData? modifiers,
  }) {
    return DividerSpec(
      container: container ?? _$this.container,
      animated: animated ?? _$this.animated,
      modifiers: modifiers ?? _$this.modifiers,
    );
  }

  /// Linearly interpolates between this [DividerSpec] and another [DividerSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [DividerSpec] is returned. When [t] is 1.0, the [other] [DividerSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [DividerSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [DividerSpec] instance.
  ///
  /// The interpolation is performed on each property of the [DividerSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [container].
  /// For [animated] and [modifiers], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [DividerSpec] is used. Otherwise, the value
  /// from the [other] [DividerSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [DividerSpec] configurations.
  @override
  DividerSpec lerp(DividerSpec? other, double t) {
    if (other == null) return _$this;

    return DividerSpec(
      container: _$this.container.lerp(other.container, t),
      animated: t < 0.5 ? _$this.animated : other.animated,
      modifiers: other.modifiers,
    );
  }

  /// The list of properties that constitute the state of this [DividerSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [DividerSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.animated,
        _$this.modifiers,
      ];

  DividerSpec get _$this => this as DividerSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('container', _$this.container, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
  }
}

/// Represents the attributes of a [DividerSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [DividerSpec].
///
/// Use this class to configure the attributes of a [DividerSpec] and pass it to
/// the [DividerSpec] constructor.
class DividerSpecAttribute extends SpecAttribute<DividerSpec>
    with Diagnosticable {
  final BoxSpecAttribute? container;

  const DividerSpecAttribute({
    this.container,
    super.animated,
    super.modifiers,
  });

  /// Resolves to [DividerSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final dividerSpec = DividerSpecAttribute(...).resolve(mix);
  /// ```
  @override
  DividerSpec resolve(MixData mix) {
    return DividerSpec(
      container: container?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
      modifiers: modifiers?.resolve(mix),
    );
  }

  /// Merges the properties of this [DividerSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [DividerSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  DividerSpecAttribute merge(DividerSpecAttribute? other) {
    if (other == null) return this;

    return DividerSpecAttribute(
      container: container?.merge(other.container) ?? other.container,
      animated: animated?.merge(other.animated) ?? other.animated,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
    );
  }

  /// The list of properties that constitute the state of this [DividerSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [DividerSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        container,
        animated,
        modifiers,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
  }
}

/// Utility class for configuring [DividerSpec] properties.
///
/// This class provides methods to set individual properties of a [DividerSpec].
/// Use the methods of this class to configure specific properties of a [DividerSpec].
class DividerSpecUtility<T extends Attribute>
    extends SpecUtility<T, DividerSpecAttribute> {
  /// Utility for defining [DividerSpecAttribute.container]
  late final container = BoxSpecUtility((v) => only(container: v));

  /// Utility for defining [DividerSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  /// Utility for defining [DividerSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  DividerSpecUtility(super.builder, {super.mutable});

  DividerSpecUtility<T> get chain =>
      DividerSpecUtility(attributeBuilder, mutable: true);

  static DividerSpecUtility<DividerSpecAttribute> get self =>
      DividerSpecUtility((v) => v);

  /// Returns a new [DividerSpecAttribute] with the specified properties.
  @override
  T only({
    BoxSpecAttribute? container,
    AnimatedDataDto? animated,
    WidgetModifiersDataDto? modifiers,
  }) {
    return builder(DividerSpecAttribute(
      container: container,
      animated: animated,
      modifiers: modifiers,
    ));
  }
}

/// A tween that interpolates between two [DividerSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [DividerSpec] specifications.
class DividerSpecTween extends Tween<DividerSpec?> {
  DividerSpecTween({
    super.begin,
    super.end,
  });

  @override
  DividerSpec lerp(double t) {
    if (begin == null && end == null) {
      return const DividerSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
