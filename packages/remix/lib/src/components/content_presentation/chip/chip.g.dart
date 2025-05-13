// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chip.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [ChipSpec].
mixin _$ChipSpec on Spec<ChipSpec> {
  static ChipSpec from(MixData mix) {
    return mix.attributeOf<ChipSpecAttribute>()?.resolve(mix) ??
        const ChipSpec();
  }

  /// {@template chip_spec_of}
  /// Retrieves the [ChipSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [ChipSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [ChipSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final chipSpec = ChipSpec.of(context);
  /// ```
  /// {@endtemplate}
  static ChipSpec of(BuildContext context) {
    return _$ChipSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [ChipSpec] but with the given fields
  /// replaced with the new values.
  @override
  ChipSpec copyWith({
    FlexBoxSpec? container,
    IconSpec? icon,
    TextSpec? label,
    WidgetModifiersData? modifiers,
    AnimatedData? animated,
  }) {
    return ChipSpec(
      container: container ?? _$this.container,
      icon: icon ?? _$this.icon,
      label: label ?? _$this.label,
      modifiers: modifiers ?? _$this.modifiers,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [ChipSpec] and another [ChipSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ChipSpec] is returned. When [t] is 1.0, the [other] [ChipSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ChipSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ChipSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ChipSpec] using the appropriate
  /// interpolation method:
  /// - [FlexBoxSpec.lerp] for [container].
  /// - [IconSpec.lerp] for [icon].
  /// - [TextSpec.lerp] for [label].
  /// For [modifiers] and [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ChipSpec] is used. Otherwise, the value
  /// from the [other] [ChipSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ChipSpec] configurations.
  @override
  ChipSpec lerp(ChipSpec? other, double t) {
    if (other == null) return _$this;

    return ChipSpec(
      container: _$this.container.lerp(other.container, t),
      icon: _$this.icon.lerp(other.icon, t),
      label: _$this.label.lerp(other.label, t),
      modifiers: other.modifiers,
      animated: t < 0.5 ? _$this.animated : other.animated,
    );
  }

  /// The list of properties that constitute the state of this [ChipSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ChipSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.icon,
        _$this.label,
        _$this.modifiers,
        _$this.animated,
      ];

  ChipSpec get _$this => this as ChipSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('container', _$this.container, defaultValue: null));
    properties
        .add(DiagnosticsProperty('icon', _$this.icon, defaultValue: null));
    properties
        .add(DiagnosticsProperty('label', _$this.label, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
  }
}

/// Represents the attributes of a [ChipSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ChipSpec].
///
/// Use this class to configure the attributes of a [ChipSpec] and pass it to
/// the [ChipSpec] constructor.
class ChipSpecAttribute extends SpecAttribute<ChipSpec> with Diagnosticable {
  final FlexBoxSpecAttribute? container;
  final IconSpecAttribute? icon;
  final TextSpecAttribute? label;

  const ChipSpecAttribute({
    this.container,
    this.icon,
    this.label,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [ChipSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final chipSpec = ChipSpecAttribute(...).resolve(mix);
  /// ```
  @override
  ChipSpec resolve(MixData mix) {
    return ChipSpec(
      container: container?.resolve(mix),
      icon: icon?.resolve(mix),
      label: label?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [ChipSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ChipSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ChipSpecAttribute merge(ChipSpecAttribute? other) {
    if (other == null) return this;

    return ChipSpecAttribute(
      container: container?.merge(other.container) ?? other.container,
      icon: icon?.merge(other.icon) ?? other.icon,
      label: label?.merge(other.label) ?? other.label,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [ChipSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ChipSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        container,
        icon,
        label,
        modifiers,
        animated,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties.add(DiagnosticsProperty('icon', icon, defaultValue: null));
    properties.add(DiagnosticsProperty('label', label, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
  }
}

/// Utility class for configuring [ChipSpec] properties.
///
/// This class provides methods to set individual properties of a [ChipSpec].
/// Use the methods of this class to configure specific properties of a [ChipSpec].
class ChipSpecUtility<T extends Attribute>
    extends SpecUtility<T, ChipSpecAttribute> {
  /// Utility for defining [ChipSpecAttribute.container]
  late final container = FlexBoxSpecUtility((v) => only(container: v));

  /// Utility for defining [ChipSpecAttribute.icon]
  late final icon = IconSpecUtility((v) => only(icon: v));

  /// Utility for defining [ChipSpecAttribute.label]
  late final label = TextSpecUtility((v) => only(label: v));

  /// Utility for defining [ChipSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [ChipSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  ChipSpecUtility(super.builder, {super.mutable});

  ChipSpecUtility<T> get chain =>
      ChipSpecUtility(attributeBuilder, mutable: true);

  static ChipSpecUtility<ChipSpecAttribute> get self =>
      ChipSpecUtility((v) => v);

  /// Returns a new [ChipSpecAttribute] with the specified properties.
  @override
  T only({
    FlexBoxSpecAttribute? container,
    IconSpecAttribute? icon,
    TextSpecAttribute? label,
    WidgetModifiersDataDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(ChipSpecAttribute(
      container: container,
      icon: icon,
      label: label,
      modifiers: modifiers,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [ChipSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [ChipSpec] specifications.
class ChipSpecTween extends Tween<ChipSpec?> {
  ChipSpecTween({
    super.begin,
    super.end,
  });

  @override
  ChipSpec lerp(double t) {
    if (begin == null && end == null) {
      return const ChipSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
