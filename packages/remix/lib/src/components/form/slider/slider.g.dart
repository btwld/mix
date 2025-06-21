// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [SliderSpec].
mixin _$SliderSpec on Spec<SliderSpec> {
  static SliderSpec from(MixContext mix) {
    return mix.attributeOf<SliderSpecAttribute>()?.resolve(mix) ?? SliderSpec();
  }

  /// {@template slider_spec_of}
  /// Retrieves the [SliderSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [SliderSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [SliderSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final sliderSpec = SliderSpec.of(context);
  /// ```
  /// {@endtemplate}
  static SliderSpec of(BuildContext context) {
    return ComputedStyle.specOf<SliderSpec>(context) ?? SliderSpec();
  }

  /// Creates a copy of this [SliderSpec] but with the given fields
  /// replaced with the new values.
  @override
  SliderSpec copyWith({
    BoxSpec? thumb,
    PaintData? baseTrack,
    PaintData? activeTrack,
    PaintData? division,
    WidgetModifiersConfig? modifiers,
    AnimatedData? animated,
  }) {
    return SliderSpec(
      thumb: thumb ?? _$this.thumb,
      baseTrack: baseTrack ?? _$this.baseTrack,
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
  /// - [BoxSpec.lerp] for [thumb].
  /// - [PaintData.lerp] for [baseTrack] and [activeTrack] and [division].
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
      baseTrack: _$this.baseTrack.lerp(other.baseTrack, t),
      activeTrack: _$this.activeTrack.lerp(other.activeTrack, t),
      division: _$this.division.lerp(other.division, t),
      modifiers: other.modifiers,
      animated: _$this.animated ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [SliderSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SliderSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.thumb,
        _$this.baseTrack,
        _$this.activeTrack,
        _$this.division,
        _$this.modifiers,
        _$this.animated,
      ];

  SliderSpec get _$this => this as SliderSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
        .add(DiagnosticsProperty('thumb', _$this.thumb, defaultValue: null));
    properties.add(
        DiagnosticsProperty('baseTrack', _$this.baseTrack, defaultValue: null));
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
  final PaintDataAttribute? baseTrack;
  final PaintDataAttribute? activeTrack;
  final PaintDataAttribute? division;

  const SliderSpecAttribute({
    this.thumb,
    this.baseTrack,
    this.activeTrack,
    this.division,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [SliderSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final sliderSpec = SliderSpecAttribute(...).resolve(mix);
  /// ```
  @override
  SliderSpec resolve(MixContext mix) {
    return SliderSpec(
      thumb: thumb?.resolve(mix),
      baseTrack: baseTrack?.resolve(mix),
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
      baseTrack: baseTrack?.merge(other.baseTrack) ?? other.baseTrack,
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
        baseTrack,
        activeTrack,
        division,
        modifiers,
        animated,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('thumb', thumb, defaultValue: null));
    properties
        .add(DiagnosticsProperty('baseTrack', baseTrack, defaultValue: null));
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
class SliderSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, SliderSpecAttribute> {
  /// Utility for defining [SliderSpecAttribute.thumb]
  late final thumb = BoxSpecUtility((v) => only(thumb: v));

  /// Utility for defining [SliderSpecAttribute.baseTrack]
  late final baseTrack = PaintDataUtility((v) => only(baseTrack: v));

  /// Utility for defining [SliderSpecAttribute.activeTrack]
  late final activeTrack = PaintDataUtility((v) => only(activeTrack: v));

  /// Utility for defining [SliderSpecAttribute.division]
  late final division = PaintDataUtility((v) => only(division: v));

  /// Utility for defining [SliderSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [SliderSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  SliderSpecUtility(
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
  SliderSpecUtility<T> get chain => SliderSpecUtility(attributeBuilder);

  static SliderSpecUtility<SliderSpecAttribute> get self =>
      SliderSpecUtility((v) => v);

  /// Returns a new [SliderSpecAttribute] with the specified properties.
  @override
  T only({
    BoxSpecAttribute? thumb,
    PaintDataAttribute? baseTrack,
    PaintDataAttribute? activeTrack,
    PaintDataAttribute? division,
    WidgetModifiersConfigDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(SliderSpecAttribute(
      thumb: thumb,
      baseTrack: baseTrack,
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

/// A mixin that provides spec functionality for [PaintData].
mixin _$PaintData on Spec<PaintData> {
  static PaintData from(MixContext mix) {
    return mix.attributeOf<PaintDataAttribute>()?.resolve(mix) ??
        const PaintData();
  }

  /// {@template paint_data_of}
  /// Retrieves the [PaintData] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [PaintData] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [PaintData].
  ///
  /// Example:
  ///
  /// ```dart
  /// final paintData = PaintData.of(context);
  /// ```
  /// {@endtemplate}
  static PaintData of(BuildContext context) {
    return ComputedStyle.specOf<PaintData>(context) ?? const PaintData();
  }

  /// Creates a copy of this [PaintData] but with the given fields
  /// replaced with the new values.
  @override
  PaintData copyWith({
    double? strokeWidth,
    Color? color,
    StrokeCap? strokeCap,
  }) {
    return PaintData(
      strokeWidth: strokeWidth ?? _$this.strokeWidth,
      color: color ?? _$this.color,
      strokeCap: strokeCap ?? _$this.strokeCap,
    );
  }

  /// Linearly interpolates between this [PaintData] and another [PaintData] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [PaintData] is returned. When [t] is 1.0, the [other] [PaintData] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [PaintData] is returned.
  ///
  /// If [other] is null, this method returns the current [PaintData] instance.
  ///
  /// The interpolation is performed on each property of the [PaintData] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpDouble] for [strokeWidth].
  /// - [Color.lerp] for [color].
  /// For [strokeCap], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [PaintData] is used. Otherwise, the value
  /// from the [other] [PaintData] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [PaintData] configurations.
  @override
  PaintData lerp(PaintData? other, double t) {
    if (other == null) return _$this;

    return PaintData(
      strokeWidth:
          MixHelpers.lerpDouble(_$this.strokeWidth, other.strokeWidth, t)!,
      color: Color.lerp(_$this.color, other.color, t)!,
      strokeCap: t < 0.5 ? _$this.strokeCap : other.strokeCap,
    );
  }

  /// The list of properties that constitute the state of this [PaintData].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [PaintData] instances for equality.
  @override
  List<Object?> get props => [
        _$this.strokeWidth,
        _$this.color,
        _$this.strokeCap,
      ];

  PaintData get _$this => this as PaintData;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty('strokeWidth', _$this.strokeWidth,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty('color', _$this.color, defaultValue: null));
    properties.add(
        DiagnosticsProperty('strokeCap', _$this.strokeCap, defaultValue: null));
  }
}

/// Represents the attributes of a [PaintData].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [PaintData].
///
/// Use this class to configure the attributes of a [PaintData] and pass it to
/// the [PaintData] constructor.
class PaintDataAttribute extends SpecAttribute<PaintData> with Diagnosticable {
  final double? strokeWidth;
  final ColorDto? color;
  final StrokeCap? strokeCap;

  const PaintDataAttribute({
    this.strokeWidth,
    this.color,
    this.strokeCap,
  });

  /// Resolves to [PaintData] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final paintData = PaintDataAttribute(...).resolve(mix);
  /// ```
  @override
  PaintData resolve(MixContext mix) {
    return PaintData(
      strokeWidth: strokeWidth,
      color: color?.resolve(mix),
      strokeCap: strokeCap,
    );
  }

  /// Merges the properties of this [PaintDataAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [PaintDataAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  PaintDataAttribute merge(PaintDataAttribute? other) {
    if (other == null) return this;

    return PaintDataAttribute(
      strokeWidth: other.strokeWidth ?? strokeWidth,
      color: color?.merge(other.color) ?? other.color,
      strokeCap: other.strokeCap ?? strokeCap,
    );
  }

  /// The list of properties that constitute the state of this [PaintDataAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [PaintDataAttribute] instances for equality.
  @override
  List<Object?> get props => [
        strokeWidth,
        color,
        strokeCap,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty('strokeWidth', strokeWidth, defaultValue: null));
    properties.add(DiagnosticsProperty('color', color, defaultValue: null));
    properties
        .add(DiagnosticsProperty('strokeCap', strokeCap, defaultValue: null));
  }
}

/// Utility class for configuring [PaintData] properties.
///
/// This class provides methods to set individual properties of a [PaintData].
/// Use the methods of this class to configure specific properties of a [PaintData].
class PaintDataUtility<T extends SpecAttribute>
    extends SpecUtility<T, PaintDataAttribute> {
  /// Utility for defining [PaintDataAttribute.strokeWidth]
  late final strokeWidth = DoubleUtility((v) => only(strokeWidth: v));

  /// Utility for defining [PaintDataAttribute.color]
  late final color = ColorUtility((v) => only(color: v));

  /// Utility for defining [PaintDataAttribute.strokeCap]
  late final strokeCap =
      GenericUtility<T, StrokeCap>((v) => only(strokeCap: v));

  PaintDataUtility(
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
  PaintDataUtility<T> get chain => PaintDataUtility(attributeBuilder);

  static PaintDataUtility<PaintDataAttribute> get self =>
      PaintDataUtility((v) => v);

  /// Returns a new [PaintDataAttribute] with the specified properties.
  @override
  T only({
    double? strokeWidth,
    ColorDto? color,
    StrokeCap? strokeCap,
  }) {
    return builder(PaintDataAttribute(
      strokeWidth: strokeWidth,
      color: color,
      strokeCap: strokeCap,
    ));
  }
}

/// A tween that interpolates between two [PaintData] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [PaintData] specifications.
class PaintDataTween extends Tween<PaintData?> {
  PaintDataTween({
    super.begin,
    super.end,
  });

  @override
  PaintData lerp(double t) {
    if (begin == null && end == null) {
      return const PaintData();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
