// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'callout.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [CalloutSpec].
mixin _$CalloutSpec on Spec<CalloutSpec> {
  static CalloutSpec from(MixData mix) {
    return mix.attributeOf<CalloutSpecAttribute>()?.resolve(mix) ??
        const CalloutSpec();
  }

  /// {@template callout_spec_of}
  /// Retrieves the [CalloutSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [CalloutSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [CalloutSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final calloutSpec = CalloutSpec.of(context);
  /// ```
  /// {@endtemplate}
  static CalloutSpec of(BuildContext context) {
    return _$CalloutSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [CalloutSpec] but with the given fields
  /// replaced with the new values.
  @override
  CalloutSpec copyWith({
    FlexBoxSpec? container,
    IconSpec? icon,
    TextSpec? text,
    WidgetModifiersData? modifiers,
    AnimatedData? animated,
  }) {
    return CalloutSpec(
      container: container ?? _$this.container,
      icon: icon ?? _$this.icon,
      text: text ?? _$this.text,
      modifiers: modifiers ?? _$this.modifiers,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [CalloutSpec] and another [CalloutSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [CalloutSpec] is returned. When [t] is 1.0, the [other] [CalloutSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [CalloutSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [CalloutSpec] instance.
  ///
  /// The interpolation is performed on each property of the [CalloutSpec] using the appropriate
  /// interpolation method:
  /// - [FlexBoxSpec.lerp] for [container].
  /// - [IconSpec.lerp] for [icon].
  /// - [TextSpec.lerp] for [text].
  /// For [modifiers] and [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [CalloutSpec] is used. Otherwise, the value
  /// from the [other] [CalloutSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [CalloutSpec] configurations.
  @override
  CalloutSpec lerp(CalloutSpec? other, double t) {
    if (other == null) return _$this;

    return CalloutSpec(
      container: _$this.container.lerp(other.container, t),
      icon: _$this.icon.lerp(other.icon, t),
      text: _$this.text.lerp(other.text, t),
      modifiers: other.modifiers,
      animated: t < 0.5 ? _$this.animated : other.animated,
    );
  }

  /// The list of properties that constitute the state of this [CalloutSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [CalloutSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.icon,
        _$this.text,
        _$this.modifiers,
        _$this.animated,
      ];

  CalloutSpec get _$this => this as CalloutSpec;
}

/// Represents the attributes of a [CalloutSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [CalloutSpec].
///
/// Use this class to configure the attributes of a [CalloutSpec] and pass it to
/// the [CalloutSpec] constructor.
class CalloutSpecAttribute extends SpecAttribute<CalloutSpec> {
  final FlexBoxSpecAttribute? container;
  final IconSpecAttribute? icon;
  final TextSpecAttribute? text;

  const CalloutSpecAttribute({
    this.container,
    this.icon,
    this.text,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [CalloutSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final calloutSpec = CalloutSpecAttribute(...).resolve(mix);
  /// ```
  @override
  CalloutSpec resolve(MixData mix) {
    return CalloutSpec(
      container: container?.resolve(mix),
      icon: icon?.resolve(mix),
      text: text?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [CalloutSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [CalloutSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  CalloutSpecAttribute merge(CalloutSpecAttribute? other) {
    if (other == null) return this;

    return CalloutSpecAttribute(
      container: container?.merge(other.container) ?? other.container,
      icon: icon?.merge(other.icon) ?? other.icon,
      text: text?.merge(other.text) ?? other.text,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [CalloutSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [CalloutSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        container,
        icon,
        text,
        modifiers,
        animated,
      ];
}

/// Utility class for configuring [CalloutSpec] properties.
///
/// This class provides methods to set individual properties of a [CalloutSpec].
/// Use the methods of this class to configure specific properties of a [CalloutSpec].
class CalloutSpecUtility<T extends Attribute>
    extends SpecUtility<T, CalloutSpecAttribute> {
  /// Utility for defining [CalloutSpecAttribute.container]
  late final container = FlexBoxSpecUtility((v) => only(container: v));

  /// Utility for defining [CalloutSpecAttribute.icon]
  late final icon = IconSpecUtility((v) => only(icon: v));

  /// Utility for defining [CalloutSpecAttribute.text]
  late final text = TextSpecUtility((v) => only(text: v));

  /// Utility for defining [CalloutSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [CalloutSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  CalloutSpecUtility(super.builder, {super.mutable});

  CalloutSpecUtility<T> get chain =>
      CalloutSpecUtility(attributeBuilder, mutable: true);

  static CalloutSpecUtility<CalloutSpecAttribute> get self =>
      CalloutSpecUtility((v) => v);

  /// Returns a new [CalloutSpecAttribute] with the specified properties.
  @override
  T only({
    FlexBoxSpecAttribute? container,
    IconSpecAttribute? icon,
    TextSpecAttribute? text,
    WidgetModifiersDataDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(CalloutSpecAttribute(
      container: container,
      icon: icon,
      text: text,
      modifiers: modifiers,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [CalloutSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [CalloutSpec] specifications.
class CalloutSpecTween extends Tween<CalloutSpec?> {
  CalloutSpecTween({
    super.begin,
    super.end,
  });

  @override
  CalloutSpec lerp(double t) {
    if (begin == null && end == null) {
      return const CalloutSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
