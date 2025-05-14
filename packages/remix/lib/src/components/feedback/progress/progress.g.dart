// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [ProgressSpec].
mixin _$ProgressSpec on Spec<ProgressSpec> {
  static ProgressSpec from(MixData mix) {
    return mix.attributeOf<ProgressSpecAttribute>()?.resolve(mix) ??
        const ProgressSpec();
  }

  /// {@template progress_spec_of}
  /// Retrieves the [ProgressSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [ProgressSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [ProgressSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final progressSpec = ProgressSpec.of(context);
  /// ```
  /// {@endtemplate}
  static ProgressSpec of(BuildContext context) {
    return _$ProgressSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [ProgressSpec] but with the given fields
  /// replaced with the new values.
  @override
  ProgressSpec copyWith({
    BoxSpec? container,
    BoxSpec? track,
    BoxSpec? fill,
    BoxSpec? outerContainer,
    AnimatedData? animated,
    WidgetModifiersData? modifiers,
  }) {
    return ProgressSpec(
      container: container ?? _$this.container,
      track: track ?? _$this.track,
      fill: fill ?? _$this.fill,
      outerContainer: outerContainer ?? _$this.outerContainer,
      animated: animated ?? _$this.animated,
      modifiers: modifiers ?? _$this.modifiers,
    );
  }

  /// Linearly interpolates between this [ProgressSpec] and another [ProgressSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ProgressSpec] is returned. When [t] is 1.0, the [other] [ProgressSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ProgressSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ProgressSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ProgressSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [container] and [track] and [fill] and [outerContainer].
  /// For [animated] and [modifiers], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ProgressSpec] is used. Otherwise, the value
  /// from the [other] [ProgressSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ProgressSpec] configurations.
  @override
  ProgressSpec lerp(ProgressSpec? other, double t) {
    if (other == null) return _$this;

    return ProgressSpec(
      container: _$this.container.lerp(other.container, t),
      track: _$this.track.lerp(other.track, t),
      fill: _$this.fill.lerp(other.fill, t),
      outerContainer: _$this.outerContainer.lerp(other.outerContainer, t),
      animated: t < 0.5 ? _$this.animated : other.animated,
      modifiers: other.modifiers,
    );
  }

  /// The list of properties that constitute the state of this [ProgressSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ProgressSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.track,
        _$this.fill,
        _$this.outerContainer,
        _$this.animated,
        _$this.modifiers,
      ];

  ProgressSpec get _$this => this as ProgressSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('container', _$this.container, defaultValue: null));
    properties
        .add(DiagnosticsProperty('track', _$this.track, defaultValue: null));
    properties
        .add(DiagnosticsProperty('fill', _$this.fill, defaultValue: null));
    properties.add(DiagnosticsProperty('outerContainer', _$this.outerContainer,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
  }
}

/// Represents the attributes of a [ProgressSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ProgressSpec].
///
/// Use this class to configure the attributes of a [ProgressSpec] and pass it to
/// the [ProgressSpec] constructor.
class ProgressSpecAttribute extends SpecAttribute<ProgressSpec>
    with Diagnosticable {
  final BoxSpecAttribute? container;
  final BoxSpecAttribute? track;
  final BoxSpecAttribute? fill;
  final BoxSpecAttribute? outerContainer;

  const ProgressSpecAttribute({
    this.container,
    this.track,
    this.fill,
    this.outerContainer,
    super.animated,
    super.modifiers,
  });

  /// Resolves to [ProgressSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final progressSpec = ProgressSpecAttribute(...).resolve(mix);
  /// ```
  @override
  ProgressSpec resolve(MixData mix) {
    return ProgressSpec(
      container: container?.resolve(mix),
      track: track?.resolve(mix),
      fill: fill?.resolve(mix),
      outerContainer: outerContainer?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
      modifiers: modifiers?.resolve(mix),
    );
  }

  /// Merges the properties of this [ProgressSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ProgressSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ProgressSpecAttribute merge(ProgressSpecAttribute? other) {
    if (other == null) return this;

    return ProgressSpecAttribute(
      container: container?.merge(other.container) ?? other.container,
      track: track?.merge(other.track) ?? other.track,
      fill: fill?.merge(other.fill) ?? other.fill,
      outerContainer:
          outerContainer?.merge(other.outerContainer) ?? other.outerContainer,
      animated: animated?.merge(other.animated) ?? other.animated,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
    );
  }

  /// The list of properties that constitute the state of this [ProgressSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ProgressSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        container,
        track,
        fill,
        outerContainer,
        animated,
        modifiers,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties.add(DiagnosticsProperty('track', track, defaultValue: null));
    properties.add(DiagnosticsProperty('fill', fill, defaultValue: null));
    properties.add(DiagnosticsProperty('outerContainer', outerContainer,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
  }
}

/// Utility class for configuring [ProgressSpec] properties.
///
/// This class provides methods to set individual properties of a [ProgressSpec].
/// Use the methods of this class to configure specific properties of a [ProgressSpec].
class ProgressSpecUtility<T extends Attribute>
    extends SpecUtility<T, ProgressSpecAttribute> {
  /// Utility for defining [ProgressSpecAttribute.container]
  late final container = BoxSpecUtility((v) => only(container: v));

  /// Utility for defining [ProgressSpecAttribute.track]
  late final track = BoxSpecUtility((v) => only(track: v));

  /// Utility for defining [ProgressSpecAttribute.fill]
  late final fill = BoxSpecUtility((v) => only(fill: v));

  /// Utility for defining [ProgressSpecAttribute.outerContainer]
  late final outerContainer = BoxSpecUtility((v) => only(outerContainer: v));

  /// Utility for defining [ProgressSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  /// Utility for defining [ProgressSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  ProgressSpecUtility(super.builder, {super.mutable});

  ProgressSpecUtility<T> get chain =>
      ProgressSpecUtility(attributeBuilder, mutable: true);

  static ProgressSpecUtility<ProgressSpecAttribute> get self =>
      ProgressSpecUtility((v) => v);

  /// Returns a new [ProgressSpecAttribute] with the specified properties.
  @override
  T only({
    BoxSpecAttribute? container,
    BoxSpecAttribute? track,
    BoxSpecAttribute? fill,
    BoxSpecAttribute? outerContainer,
    AnimatedDataDto? animated,
    WidgetModifiersDataDto? modifiers,
  }) {
    return builder(ProgressSpecAttribute(
      container: container,
      track: track,
      fill: fill,
      outerContainer: outerContainer,
      animated: animated,
      modifiers: modifiers,
    ));
  }
}

/// A tween that interpolates between two [ProgressSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [ProgressSpec] specifications.
class ProgressSpecTween extends Tween<ProgressSpec?> {
  ProgressSpecTween({
    super.begin,
    super.end,
  });

  @override
  ProgressSpec lerp(double t) {
    if (begin == null && end == null) {
      return const ProgressSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
