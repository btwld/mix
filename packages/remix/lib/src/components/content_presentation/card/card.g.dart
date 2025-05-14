// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [CardSpec].
mixin _$CardSpec on Spec<CardSpec> {
  static CardSpec from(MixData mix) {
    return mix.attributeOf<CardSpecAttribute>()?.resolve(mix) ??
        const CardSpec();
  }

  /// {@template card_spec_of}
  /// Retrieves the [CardSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [CardSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [CardSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final cardSpec = CardSpec.of(context);
  /// ```
  /// {@endtemplate}
  static CardSpec of(BuildContext context) {
    return _$CardSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [CardSpec] but with the given fields
  /// replaced with the new values.
  @override
  CardSpec copyWith({
    BoxSpec? container,
    WidgetModifiersData? modifiers,
    AnimatedData? animated,
  }) {
    return CardSpec(
      container: container ?? _$this.container,
      modifiers: modifiers ?? _$this.modifiers,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [CardSpec] and another [CardSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [CardSpec] is returned. When [t] is 1.0, the [other] [CardSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [CardSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [CardSpec] instance.
  ///
  /// The interpolation is performed on each property of the [CardSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [container].
  /// For [modifiers] and [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [CardSpec] is used. Otherwise, the value
  /// from the [other] [CardSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [CardSpec] configurations.
  @override
  CardSpec lerp(CardSpec? other, double t) {
    if (other == null) return _$this;

    return CardSpec(
      container: _$this.container.lerp(other.container, t),
      modifiers: other.modifiers,
      animated: t < 0.5 ? _$this.animated : other.animated,
    );
  }

  /// The list of properties that constitute the state of this [CardSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [CardSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.modifiers,
        _$this.animated,
      ];

  CardSpec get _$this => this as CardSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('container', _$this.container, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
  }
}

/// Represents the attributes of a [CardSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [CardSpec].
///
/// Use this class to configure the attributes of a [CardSpec] and pass it to
/// the [CardSpec] constructor.
class CardSpecAttribute extends SpecAttribute<CardSpec> with Diagnosticable {
  final BoxSpecAttribute? container;

  const CardSpecAttribute({
    this.container,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [CardSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final cardSpec = CardSpecAttribute(...).resolve(mix);
  /// ```
  @override
  CardSpec resolve(MixData mix) {
    return CardSpec(
      container: container?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [CardSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [CardSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  CardSpecAttribute merge(CardSpecAttribute? other) {
    if (other == null) return this;

    return CardSpecAttribute(
      container: container?.merge(other.container) ?? other.container,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [CardSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [CardSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        container,
        modifiers,
        animated,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
  }
}

/// Utility class for configuring [CardSpec] properties.
///
/// This class provides methods to set individual properties of a [CardSpec].
/// Use the methods of this class to configure specific properties of a [CardSpec].
class CardSpecUtility<T extends Attribute>
    extends SpecUtility<T, CardSpecAttribute> {
  /// Utility for defining [CardSpecAttribute.container]
  late final container = BoxSpecUtility((v) => only(container: v));

  /// Utility for defining [CardSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [CardSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  CardSpecUtility(super.builder, {super.mutable});

  CardSpecUtility<T> get chain =>
      CardSpecUtility(attributeBuilder, mutable: true);

  static CardSpecUtility<CardSpecAttribute> get self =>
      CardSpecUtility((v) => v);

  /// Returns a new [CardSpecAttribute] with the specified properties.
  @override
  T only({
    BoxSpecAttribute? container,
    WidgetModifiersDataDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(CardSpecAttribute(
      container: container,
      modifiers: modifiers,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [CardSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [CardSpec] specifications.
class CardSpecTween extends Tween<CardSpec?> {
  CardSpecTween({
    super.begin,
    super.end,
  });

  @override
  CardSpec lerp(double t) {
    if (begin == null && end == null) {
      return const CardSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
