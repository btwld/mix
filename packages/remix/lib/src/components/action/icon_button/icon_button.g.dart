// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon_button.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [IconButtonSpec].
mixin _$IconButtonSpec on Spec<IconButtonSpec> {
  static IconButtonSpec from(MixData mix) {
    return mix.attributeOf<IconButtonSpecAttribute>()?.resolve(mix) ??
        const IconButtonSpec();
  }

  /// {@template icon_button_spec_of}
  /// Retrieves the [IconButtonSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [IconButtonSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [IconButtonSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final iconButtonSpec = IconButtonSpec.of(context);
  /// ```
  /// {@endtemplate}
  static IconButtonSpec of(BuildContext context) {
    return _$IconButtonSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [IconButtonSpec] but with the given fields
  /// replaced with the new values.
  @override
  IconButtonSpec copyWith({
    BoxSpec? container,
    IconSpec? icon,
    WidgetModifiersData? modifiers,
    SpinnerSpec? spinner,
    AnimatedData? animated,
  }) {
    return IconButtonSpec(
      container: container ?? _$this.container,
      icon: icon ?? _$this.icon,
      modifiers: modifiers ?? _$this.modifiers,
      spinner: spinner ?? _$this.spinner,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [IconButtonSpec] and another [IconButtonSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [IconButtonSpec] is returned. When [t] is 1.0, the [other] [IconButtonSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [IconButtonSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [IconButtonSpec] instance.
  ///
  /// The interpolation is performed on each property of the [IconButtonSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [container].
  /// - [IconSpec.lerp] for [icon].
  /// - [SpinnerSpec.lerp] for [spinner].
  /// For [modifiers] and [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [IconButtonSpec] is used. Otherwise, the value
  /// from the [other] [IconButtonSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [IconButtonSpec] configurations.
  @override
  IconButtonSpec lerp(IconButtonSpec? other, double t) {
    if (other == null) return _$this;

    return IconButtonSpec(
      container: _$this.container.lerp(other.container, t),
      icon: _$this.icon.lerp(other.icon, t),
      modifiers: other.modifiers,
      spinner: _$this.spinner.lerp(other.spinner, t),
      animated: t < 0.5 ? _$this.animated : other.animated,
    );
  }

  /// The list of properties that constitute the state of this [IconButtonSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IconButtonSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.icon,
        _$this.modifiers,
        _$this.spinner,
        _$this.animated,
      ];

  IconButtonSpec get _$this => this as IconButtonSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('container', _$this.container, defaultValue: null));
    properties
        .add(DiagnosticsProperty('icon', _$this.icon, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(
        DiagnosticsProperty('spinner', _$this.spinner, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
  }
}

/// Represents the attributes of a [IconButtonSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [IconButtonSpec].
///
/// Use this class to configure the attributes of a [IconButtonSpec] and pass it to
/// the [IconButtonSpec] constructor.
class IconButtonSpecAttribute extends SpecAttribute<IconButtonSpec>
    with Diagnosticable {
  final BoxSpecAttribute? container;
  final IconSpecAttribute? icon;
  final SpinnerSpecAttribute? spinner;

  const IconButtonSpecAttribute({
    this.container,
    this.icon,
    super.modifiers,
    this.spinner,
    super.animated,
  });

  /// Resolves to [IconButtonSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final iconButtonSpec = IconButtonSpecAttribute(...).resolve(mix);
  /// ```
  @override
  IconButtonSpec resolve(MixData mix) {
    return IconButtonSpec(
      container: container?.resolve(mix),
      icon: icon?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
      spinner: spinner?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [IconButtonSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [IconButtonSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  IconButtonSpecAttribute merge(IconButtonSpecAttribute? other) {
    if (other == null) return this;

    return IconButtonSpecAttribute(
      container: container?.merge(other.container) ?? other.container,
      icon: icon?.merge(other.icon) ?? other.icon,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      spinner: spinner?.merge(other.spinner) ?? other.spinner,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [IconButtonSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IconButtonSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        container,
        icon,
        modifiers,
        spinner,
        animated,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties.add(DiagnosticsProperty('icon', icon, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
    properties.add(DiagnosticsProperty('spinner', spinner, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
  }
}

/// Utility class for configuring [IconButtonSpec] properties.
///
/// This class provides methods to set individual properties of a [IconButtonSpec].
/// Use the methods of this class to configure specific properties of a [IconButtonSpec].
class IconButtonSpecUtility<T extends Attribute>
    extends SpecUtility<T, IconButtonSpecAttribute> {
  /// Utility for defining [IconButtonSpecAttribute.container]
  late final container = BoxSpecUtility((v) => only(container: v));

  /// Utility for defining [IconButtonSpecAttribute.icon]
  late final icon = IconSpecUtility((v) => only(icon: v));

  /// Utility for defining [IconButtonSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [IconButtonSpecAttribute.spinner]
  late final spinner = SpinnerSpecUtility((v) => only(spinner: v));

  /// Utility for defining [IconButtonSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  IconButtonSpecUtility(super.builder, {super.mutable});

  IconButtonSpecUtility<T> get chain =>
      IconButtonSpecUtility(attributeBuilder, mutable: true);

  static IconButtonSpecUtility<IconButtonSpecAttribute> get self =>
      IconButtonSpecUtility((v) => v);

  /// Returns a new [IconButtonSpecAttribute] with the specified properties.
  @override
  T only({
    BoxSpecAttribute? container,
    IconSpecAttribute? icon,
    WidgetModifiersDataDto? modifiers,
    SpinnerSpecAttribute? spinner,
    AnimatedDataDto? animated,
  }) {
    return builder(IconButtonSpecAttribute(
      container: container,
      icon: icon,
      modifiers: modifiers,
      spinner: spinner,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [IconButtonSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [IconButtonSpec] specifications.
class IconButtonSpecTween extends Tween<IconButtonSpec?> {
  IconButtonSpecTween({
    super.begin,
    super.end,
  });

  @override
  IconButtonSpec lerp(double t) {
    if (begin == null && end == null) {
      return const IconButtonSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
