// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scaffold.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [ScaffoldSpec].
mixin _$ScaffoldSpec on Spec<ScaffoldSpec> {
  static ScaffoldSpec from(MixData mix) {
    return mix.attributeOf<ScaffoldSpecAttribute>()?.resolve(mix) ??
        const ScaffoldSpec();
  }

  /// {@template scaffold_spec_of}
  /// Retrieves the [ScaffoldSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [ScaffoldSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [ScaffoldSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final scaffoldSpec = ScaffoldSpec.of(context);
  /// ```
  /// {@endtemplate}
  static ScaffoldSpec of(BuildContext context) {
    return _$ScaffoldSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [ScaffoldSpec] but with the given fields
  /// replaced with the new values.
  @override
  ScaffoldSpec copyWith({
    BoxSpec? container,
    AnimatedData? animated,
    WidgetModifiersData? modifiers,
  }) {
    return ScaffoldSpec(
      container: container ?? _$this.container,
      animated: animated ?? _$this.animated,
      modifiers: modifiers ?? _$this.modifiers,
    );
  }

  /// Linearly interpolates between this [ScaffoldSpec] and another [ScaffoldSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ScaffoldSpec] is returned. When [t] is 1.0, the [other] [ScaffoldSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ScaffoldSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ScaffoldSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ScaffoldSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [container].
  /// For [animated] and [modifiers], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ScaffoldSpec] is used. Otherwise, the value
  /// from the [other] [ScaffoldSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ScaffoldSpec] configurations.
  @override
  ScaffoldSpec lerp(ScaffoldSpec? other, double t) {
    if (other == null) return _$this;

    return ScaffoldSpec(
      container: _$this.container.lerp(other.container, t),
      animated: t < 0.5 ? _$this.animated : other.animated,
      modifiers: other.modifiers,
    );
  }

  /// The list of properties that constitute the state of this [ScaffoldSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ScaffoldSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.animated,
        _$this.modifiers,
      ];

  ScaffoldSpec get _$this => this as ScaffoldSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('container', _$this.container, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
  }
}

/// Represents the attributes of a [ScaffoldSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ScaffoldSpec].
///
/// Use this class to configure the attributes of a [ScaffoldSpec] and pass it to
/// the [ScaffoldSpec] constructor.
class ScaffoldSpecAttribute extends SpecAttribute<ScaffoldSpec>
    with Diagnosticable {
  final BoxSpecAttribute? container;

  const ScaffoldSpecAttribute({
    this.container,
    super.animated,
    super.modifiers,
  });

  /// Resolves to [ScaffoldSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final scaffoldSpec = ScaffoldSpecAttribute(...).resolve(mix);
  /// ```
  @override
  ScaffoldSpec resolve(MixData mix) {
    return ScaffoldSpec(
      container: container?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
      modifiers: modifiers?.resolve(mix),
    );
  }

  /// Merges the properties of this [ScaffoldSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ScaffoldSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ScaffoldSpecAttribute merge(ScaffoldSpecAttribute? other) {
    if (other == null) return this;

    return ScaffoldSpecAttribute(
      container: container?.merge(other.container) ?? other.container,
      animated: animated?.merge(other.animated) ?? other.animated,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
    );
  }

  /// The list of properties that constitute the state of this [ScaffoldSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ScaffoldSpecAttribute] instances for equality.
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

/// Utility class for configuring [ScaffoldSpec] properties.
///
/// This class provides methods to set individual properties of a [ScaffoldSpec].
/// Use the methods of this class to configure specific properties of a [ScaffoldSpec].
class ScaffoldSpecUtility<T extends Attribute>
    extends SpecUtility<T, ScaffoldSpecAttribute> {
  /// Utility for defining [ScaffoldSpecAttribute.container]
  late final container = BoxSpecUtility((v) => only(container: v));

  /// Utility for defining [ScaffoldSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  /// Utility for defining [ScaffoldSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  ScaffoldSpecUtility(super.builder, {super.mutable});

  ScaffoldSpecUtility<T> get chain =>
      ScaffoldSpecUtility(attributeBuilder, mutable: true);

  static ScaffoldSpecUtility<ScaffoldSpecAttribute> get self =>
      ScaffoldSpecUtility((v) => v);

  /// Returns a new [ScaffoldSpecAttribute] with the specified properties.
  @override
  T only({
    BoxSpecAttribute? container,
    AnimatedDataDto? animated,
    WidgetModifiersDataDto? modifiers,
  }) {
    return builder(ScaffoldSpecAttribute(
      container: container,
      animated: animated,
      modifiers: modifiers,
    ));
  }
}

/// A tween that interpolates between two [ScaffoldSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [ScaffoldSpec] specifications.
class ScaffoldSpecTween extends Tween<ScaffoldSpec?> {
  ScaffoldSpecTween({
    super.begin,
    super.end,
  });

  @override
  ScaffoldSpec lerp(double t) {
    if (begin == null && end == null) {
      return const ScaffoldSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
