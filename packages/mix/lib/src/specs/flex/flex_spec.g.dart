// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_spec.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [FlexSpec].
mixin _$FlexSpec on Spec<FlexSpec> {
  static FlexSpec from(MixData mix) {
    return mix.attributeOf<FlexSpecAttribute>()?.resolve(mix) ??
        const FlexSpec();
  }

  /// {@template flex_spec_of}
  /// Retrieves the [FlexSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [FlexSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [FlexSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final flexSpec = FlexSpec.of(context);
  /// ```
  /// {@endtemplate}
  static FlexSpec of(BuildContext context) {
    return ComputedStyle.specOf<FlexSpec>(context) ?? const FlexSpec();
  }

  /// Creates a copy of this [FlexSpec] but with the given fields
  /// replaced with the new values.
  @override
  FlexSpec copyWith({
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    Axis? direction,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    Clip? clipBehavior,
    double? spacing,
    @Deprecated('Use spacing instead') double? gap,
    AnimatedData? animated,
    WidgetModifiersData? modifiers,
  }) {
    return FlexSpec(
      crossAxisAlignment: crossAxisAlignment ?? _$this.crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment ?? _$this.mainAxisAlignment,
      mainAxisSize: mainAxisSize ?? _$this.mainAxisSize,
      verticalDirection: verticalDirection ?? _$this.verticalDirection,
      direction: direction ?? _$this.direction,
      textDirection: textDirection ?? _$this.textDirection,
      textBaseline: textBaseline ?? _$this.textBaseline,
      clipBehavior: clipBehavior ?? _$this.clipBehavior,
      spacing: spacing ?? gap ?? _$this.spacing,
      animated: animated ?? _$this.animated,
      modifiers: modifiers ?? _$this.modifiers,
    );
  }

  /// Linearly interpolates between this [FlexSpec] and another [FlexSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [FlexSpec] is returned. When [t] is 1.0, the [other] [FlexSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [FlexSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [FlexSpec] instance.
  ///
  /// The interpolation is performed on each property of the [FlexSpec] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpDouble] for [spacing].
  /// For [crossAxisAlignment] and [mainAxisAlignment] and [mainAxisSize] and [verticalDirection] and [direction] and [textDirection] and [textBaseline] and [clipBehavior] and [animated] and [modifiers], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [FlexSpec] is used. Otherwise, the value
  /// from the [other] [FlexSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [FlexSpec] configurations.
  @override
  FlexSpec lerp(FlexSpec? other, double t) {
    if (other == null) return _$this;

    return FlexSpec(
      crossAxisAlignment:
          t < 0.5 ? _$this.crossAxisAlignment : other.crossAxisAlignment,
      mainAxisAlignment:
          t < 0.5 ? _$this.mainAxisAlignment : other.mainAxisAlignment,
      mainAxisSize: t < 0.5 ? _$this.mainAxisSize : other.mainAxisSize,
      verticalDirection:
          t < 0.5 ? _$this.verticalDirection : other.verticalDirection,
      direction: t < 0.5 ? _$this.direction : other.direction,
      textDirection: t < 0.5 ? _$this.textDirection : other.textDirection,
      textBaseline: t < 0.5 ? _$this.textBaseline : other.textBaseline,
      clipBehavior: t < 0.5 ? _$this.clipBehavior : other.clipBehavior,
      spacing: MixHelpers.lerpDouble(_$this.spacing, other.spacing, t),
      animated: _$this.animated ?? other.animated,
      modifiers: other.modifiers,
    );
  }

  /// The list of properties that constitute the state of this [FlexSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.crossAxisAlignment,
        _$this.mainAxisAlignment,
        _$this.mainAxisSize,
        _$this.verticalDirection,
        _$this.direction,
        _$this.textDirection,
        _$this.textBaseline,
        _$this.clipBehavior,
        _$this.spacing,
        _$this.animated,
        _$this.modifiers,
      ];

  FlexSpec get _$this => this as FlexSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty(
        'crossAxisAlignment', _$this.crossAxisAlignment,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'mainAxisAlignment', _$this.mainAxisAlignment,
        defaultValue: null));
    properties.add(DiagnosticsProperty('mainAxisSize', _$this.mainAxisSize,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'verticalDirection', _$this.verticalDirection,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('direction', _$this.direction, defaultValue: null));
    properties.add(DiagnosticsProperty('textDirection', _$this.textDirection,
        defaultValue: null));
    properties.add(DiagnosticsProperty('textBaseline', _$this.textBaseline,
        defaultValue: null));
    properties.add(DiagnosticsProperty('clipBehavior', _$this.clipBehavior,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('spacing', _$this.spacing, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
  }
}

/// Utility class for configuring [FlexSpec] properties.
///
/// This class provides methods to set individual properties of a [FlexSpec].
/// Use the methods of this class to configure specific properties of a [FlexSpec].
class FlexSpecUtility<T extends Attribute>
    extends SpecUtility<T, FlexSpecAttribute> {
  /// Utility for defining [FlexSpecAttribute.crossAxisAlignment]
  late final crossAxisAlignment =
      CrossAxisAlignmentUtility((v) => only(crossAxisAlignment: v));

  /// Utility for defining [FlexSpecAttribute.mainAxisAlignment]
  late final mainAxisAlignment =
      MainAxisAlignmentUtility((v) => only(mainAxisAlignment: v));

  /// Utility for defining [FlexSpecAttribute.mainAxisSize]
  late final mainAxisSize = MainAxisSizeUtility((v) => only(mainAxisSize: v));

  /// Utility for defining [FlexSpecAttribute.verticalDirection]
  late final verticalDirection =
      VerticalDirectionUtility((v) => only(verticalDirection: v));

  /// Utility for defining [FlexSpecAttribute.direction]
  late final direction = AxisUtility((v) => only(direction: v));

  /// Utility for defining [FlexSpecAttribute.direction.horizontal]
  late final row = direction.horizontal;

  /// Utility for defining [FlexSpecAttribute.direction.vertical]
  late final column = direction.vertical;

  /// Utility for defining [FlexSpecAttribute.textDirection]
  late final textDirection =
      TextDirectionUtility((v) => only(textDirection: v));

  /// Utility for defining [FlexSpecAttribute.textBaseline]
  late final textBaseline = TextBaselineUtility((v) => only(textBaseline: v));

  /// Utility for defining [FlexSpecAttribute.clipBehavior]
  late final clipBehavior = ClipUtility((v) => only(clipBehavior: v));

  /// Utility for defining [FlexSpecAttribute.spacing]
  late final spacing = FlexSpacingUtility((v) => only(spacing: v));

  /// Utility for defining [FlexSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  /// Utility for defining [FlexSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  FlexSpecUtility(super.builder, {super.mutable});

  FlexSpecUtility<T> get chain =>
      FlexSpecUtility(attributeBuilder, mutable: true);

  static FlexSpecUtility<FlexSpecAttribute> get self =>
      FlexSpecUtility((v) => v);

  /// Returns a new [FlexSpecAttribute] with the specified properties.
  @override
  T only({
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    Axis? direction,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    Clip? clipBehavior,
    SpaceDto? spacing,
    AnimatedDataDto? animated,
    WidgetModifiersDataDto? modifiers,
  }) {
    return builder(FlexSpecAttribute(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      verticalDirection: verticalDirection,
      direction: direction,
      textDirection: textDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      spacing: spacing,
      animated: animated,
      modifiers: modifiers,
    ));
  }
}

/// A tween that interpolates between two [FlexSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [FlexSpec] specifications.
class FlexSpecTween extends Tween<FlexSpec?> {
  FlexSpecTween({
    super.begin,
    super.end,
  });

  @override
  FlexSpec lerp(double t) {
    if (begin == null && end == null) {
      return const FlexSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
