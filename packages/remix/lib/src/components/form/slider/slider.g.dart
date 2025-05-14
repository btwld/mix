// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [SliderSpec].
mixin _$SliderSpec on Spec<SliderSpec> {
  static SliderSpec from(MixData mix) {
    return mix.attributeOf<SliderSpecAttribute>()?.resolve(mix) ?? SliderSpec();
  }

  /// {@template slider_spec_of}
  /// Retrieves the [SliderSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [SliderSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [SliderSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final sliderSpec = SliderSpec.of(context);
  /// ```
  /// {@endtemplate}
  static SliderSpec of(BuildContext context) {
    return _$SliderSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [SliderSpec] but with the given fields
  /// replaced with the new values.
  @override
  SliderSpec copyWith({
    BoxSpec? thumb,
    BoxSpec? track,
    BoxSpec? activeTrack,
    BoxSpec? division,
    WidgetModifiersData? modifiers,
    AnimatedData? animated,
  }) {
    return SliderSpec(
      thumb: thumb ?? _$this.thumb,
      track: track ?? _$this.track,
      activeTrack: activeTrack ?? _$this.activeTrack,
      division: division ?? _$this.division,
      modifiers: modifiers ?? _$this.modifiers,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [SliderSpec] and another [SliderSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [SliderSpec] is returned. When [t] is 1.0, the [other] [SliderSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [SliderSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [SliderSpec] instance.
  ///
  /// The interpolation is performed on each property of the [SliderSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [thumb] and [track] and [activeTrack] and [division].
  /// For [modifiers] and [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [SliderSpec] is used. Otherwise, the value
  /// from the [other] [SliderSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [SliderSpec] configurations.
  @override
  SliderSpec lerp(SliderSpec? other, double t) {
    if (other == null) return _$this;

    return SliderSpec(
      thumb: _$this.thumb.lerp(other.thumb, t),
      track: _$this.track.lerp(other.track, t),
      activeTrack: _$this.activeTrack.lerp(other.activeTrack, t),
      division: _$this.division.lerp(other.division, t),
      modifiers: other.modifiers,
      animated: t < 0.5 ? _$this.animated : other.animated,
    );
  }

  /// The list of properties that constitute the state of this [SliderSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SliderSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.thumb,
        _$this.track,
        _$this.activeTrack,
        _$this.division,
        _$this.modifiers,
        _$this.animated,
      ];

  SliderSpec get _$this => this as SliderSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
        .add(DiagnosticsProperty('thumb', _$this.thumb, defaultValue: null));
    properties
        .add(DiagnosticsProperty('track', _$this.track, defaultValue: null));
    properties.add(DiagnosticsProperty('activeTrack', _$this.activeTrack,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('division', _$this.division, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
  }
}

/// Represents the attributes of a [SliderSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [SliderSpec].
///
/// Use this class to configure the attributes of a [SliderSpec] and pass it to
/// the [SliderSpec] constructor.
class SliderSpecAttribute extends SpecAttribute<SliderSpec>
    with Diagnosticable {
  final BoxSpecAttribute? thumb;
  final BoxSpecAttribute? track;
  final BoxSpecAttribute? activeTrack;
  final BoxSpecAttribute? division;

  const SliderSpecAttribute({
    this.thumb,
    this.track,
    this.activeTrack,
    this.division,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [SliderSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final sliderSpec = SliderSpecAttribute(...).resolve(mix);
  /// ```
  @override
  SliderSpec resolve(MixData mix) {
    return SliderSpec(
      thumb: thumb?.resolve(mix),
      track: track?.resolve(mix),
      activeTrack: activeTrack?.resolve(mix),
      division: division?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [SliderSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [SliderSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  SliderSpecAttribute merge(SliderSpecAttribute? other) {
    if (other == null) return this;

    return SliderSpecAttribute(
      thumb: thumb?.merge(other.thumb) ?? other.thumb,
      track: track?.merge(other.track) ?? other.track,
      activeTrack: activeTrack?.merge(other.activeTrack) ?? other.activeTrack,
      division: division?.merge(other.division) ?? other.division,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [SliderSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SliderSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        thumb,
        track,
        activeTrack,
        division,
        modifiers,
        animated,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('thumb', thumb, defaultValue: null));
    properties.add(DiagnosticsProperty('track', track, defaultValue: null));
    properties.add(
        DiagnosticsProperty('activeTrack', activeTrack, defaultValue: null));
    properties
        .add(DiagnosticsProperty('division', division, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
  }
}

/// Utility class for configuring [SliderSpec] properties.
///
/// This class provides methods to set individual properties of a [SliderSpec].
/// Use the methods of this class to configure specific properties of a [SliderSpec].
class SliderSpecUtility<T extends Attribute>
    extends SpecUtility<T, SliderSpecAttribute> {
  /// Utility for defining [SliderSpecAttribute.thumb]
  late final thumb = BoxSpecUtility((v) => only(thumb: v));

  /// Utility for defining [SliderSpecAttribute.track]
  late final track = BoxSpecUtility((v) => only(track: v));

  /// Utility for defining [SliderSpecAttribute.activeTrack]
  late final activeTrack = BoxSpecUtility((v) => only(activeTrack: v));

  /// Utility for defining [SliderSpecAttribute.division]
  late final division = BoxSpecUtility((v) => only(division: v));

  /// Utility for defining [SliderSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [SliderSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  SliderSpecUtility(super.builder, {super.mutable});

  SliderSpecUtility<T> get chain =>
      SliderSpecUtility(attributeBuilder, mutable: true);

  static SliderSpecUtility<SliderSpecAttribute> get self =>
      SliderSpecUtility((v) => v);

  /// Returns a new [SliderSpecAttribute] with the specified properties.
  @override
  T only({
    BoxSpecAttribute? thumb,
    BoxSpecAttribute? track,
    BoxSpecAttribute? activeTrack,
    BoxSpecAttribute? division,
    WidgetModifiersDataDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(SliderSpecAttribute(
      thumb: thumb,
      track: track,
      activeTrack: activeTrack,
      division: division,
      modifiers: modifiers,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [SliderSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [SliderSpec] specifications.
class SliderSpecTween extends Tween<SliderSpec?> {
  SliderSpecTween({
    super.begin,
    super.end,
  });

  @override
  SliderSpec lerp(double t) {
    if (begin == null && end == null) {
      return SliderSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
