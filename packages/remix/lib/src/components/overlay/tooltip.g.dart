// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tooltip.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [TooltipSpec].
mixin _$TooltipSpec on Spec<TooltipSpec> {
  static TooltipSpec from(MixContext mix) {
    return mix.attributeOf<TooltipSpecAttribute>()?.resolve(mix) ??
        const TooltipSpec();
  }

  /// {@template tooltip_spec_of}
  /// Retrieves the [TooltipSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [TooltipSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [TooltipSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final tooltipSpec = TooltipSpec.of(context);
  /// ```
  /// {@endtemplate}
  static TooltipSpec of(BuildContext context) {
    return ComputedStyle.specOf<TooltipSpec>(context) ?? const TooltipSpec();
  }

  /// Creates a copy of this [TooltipSpec] but with the given fields
  /// replaced with the new values.
  @override
  TooltipSpec copyWith({
    BoxSpec? container,
    WidgetModifiersConfig? modifiers,
    AnimatedData? animated,
  }) {
    return TooltipSpec(
      container: container ?? _$this.container,
      modifiers: modifiers ?? _$this.modifiers,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [TooltipSpec] and another [TooltipSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [TooltipSpec] is returned. When [t] is 1.0, the [other] [TooltipSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [TooltipSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [TooltipSpec] instance.
  ///
  /// The interpolation is performed on each property of the [TooltipSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [container].
  /// For [modifiers] and [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [TooltipSpec] is used. Otherwise, the value
  /// from the [other] [TooltipSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [TooltipSpec] configurations.
  @override
  TooltipSpec lerp(TooltipSpec? other, double t) {
    if (other == null) return _$this;

    return TooltipSpec(
      container: _$this.container.lerp(other.container, t),
      modifiers: other.modifiers,
      animated: _$this.animated ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [TooltipSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TooltipSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.modifiers,
        _$this.animated,
      ];

  TooltipSpec get _$this => this as TooltipSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('container', _$this.container, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
  }
}

/// Represents the attributes of a [TooltipSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [TooltipSpec].
///
/// Use this class to configure the attributes of a [TooltipSpec] and pass it to
/// the [TooltipSpec] constructor.
class TooltipSpecAttribute extends SpecAttribute<TooltipSpec>
    with Diagnosticable {
  final BoxSpecAttribute? container;

  const TooltipSpecAttribute({
    this.container,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [TooltipSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final tooltipSpec = TooltipSpecAttribute(...).resolve(mix);
  /// ```
  @override
  TooltipSpec resolve(MixContext mix) {
    return TooltipSpec(
      container: container?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [TooltipSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [TooltipSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  TooltipSpecAttribute merge(TooltipSpecAttribute? other) {
    if (other == null) return this;

    return TooltipSpecAttribute(
      container: container?.merge(other.container) ?? other.container,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [TooltipSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TooltipSpecAttribute] instances for equality.
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

/// Utility class for configuring [TooltipSpec] properties.
///
/// This class provides methods to set individual properties of a [TooltipSpec].
/// Use the methods of this class to configure specific properties of a [TooltipSpec].
class TooltipSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, TooltipSpecAttribute> {
  /// Utility for defining [TooltipSpecAttribute.container]
  late final container = BoxSpecUtility((v) => only(container: v));

  /// Utility for defining [TooltipSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [TooltipSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  TooltipSpecUtility(
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
  TooltipSpecUtility<T> get chain => TooltipSpecUtility(attributeBuilder);

  static TooltipSpecUtility<TooltipSpecAttribute> get self =>
      TooltipSpecUtility((v) => v);

  /// Returns a new [TooltipSpecAttribute] with the specified properties.
  @override
  T only({
    BoxSpecAttribute? container,
    WidgetModifiersConfigDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(TooltipSpecAttribute(
      container: container,
      modifiers: modifiers,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [TooltipSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [TooltipSpec] specifications.
class TooltipSpecTween extends Tween<TooltipSpec?> {
  TooltipSpecTween({
    super.begin,
    super.end,
  });

  @override
  TooltipSpec lerp(double t) {
    if (begin == null && end == null) {
      return const TooltipSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
