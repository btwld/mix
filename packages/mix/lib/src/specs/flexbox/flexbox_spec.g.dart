// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flexbox_spec.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [FlexBoxSpec].
mixin _$FlexBoxSpec on Spec<FlexBoxSpec> {
  static FlexBoxSpec from(MixData mix) {
    return mix.attributeOf<FlexBoxSpecAttribute>()?.resolve(mix) ??
        const FlexBoxSpec();
  }

  /// {@template flex_box_spec_of}
  /// Retrieves the [FlexBoxSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [FlexBoxSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [FlexBoxSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final flexBoxSpec = FlexBoxSpec.of(context);
  /// ```
  /// {@endtemplate}
  static FlexBoxSpec of(BuildContext context) {
    return ComputedStyle.specOf<FlexBoxSpec>(context) ?? const FlexBoxSpec();
  }

  /// Creates a copy of this [FlexBoxSpec] but with the given fields
  /// replaced with the new values.
  @override
  FlexBoxSpec copyWith({
    AnimatedData? animated,
    WidgetModifiersData? modifiers,
    BoxSpec? box,
    FlexSpec? flex,
  }) {
    return FlexBoxSpec(
      animated: animated ?? _$this.animated,
      modifiers: modifiers ?? _$this.modifiers,
      box: box ?? _$this.box,
      flex: flex ?? _$this.flex,
    );
  }

  /// Linearly interpolates between this [FlexBoxSpec] and another [FlexBoxSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [FlexBoxSpec] is returned. When [t] is 1.0, the [other] [FlexBoxSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [FlexBoxSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [FlexBoxSpec] instance.
  ///
  /// The interpolation is performed on each property of the [FlexBoxSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [box].
  /// - [FlexSpec.lerp] for [flex].
  /// For [animated] and [modifiers], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [FlexBoxSpec] is used. Otherwise, the value
  /// from the [other] [FlexBoxSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [FlexBoxSpec] configurations.
  @override
  FlexBoxSpec lerp(FlexBoxSpec? other, double t) {
    if (other == null) return _$this;

    return FlexBoxSpec(
      animated: t < 0.5 ? _$this.animated : other.animated,
      modifiers: other.modifiers,
      box: _$this.box.lerp(other.box, t),
      flex: _$this.flex.lerp(other.flex, t),
    );
  }

  /// The list of properties that constitute the state of this [FlexBoxSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexBoxSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.animated,
        _$this.modifiers,
        _$this.box,
        _$this.flex,
      ];

  FlexBoxSpec get _$this => this as FlexBoxSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(DiagnosticsProperty('box', _$this.box, defaultValue: null));
    properties
        .add(DiagnosticsProperty('flex', _$this.flex, defaultValue: null));
  }
}

/// Represents the attributes of a [FlexBoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexBoxSpec].
///
/// Use this class to configure the attributes of a [FlexBoxSpec] and pass it to
/// the [FlexBoxSpec] constructor.
class FlexBoxSpecAttribute extends SpecAttribute<FlexBoxSpec>
    with Diagnosticable {
  final BoxSpecAttribute? box;
  final FlexSpecAttribute? flex;

  const FlexBoxSpecAttribute({
    super.animated,
    super.modifiers,
    this.box,
    this.flex,
  });

  /// Resolves to [FlexBoxSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final flexBoxSpec = FlexBoxSpecAttribute(...).resolve(mix);
  /// ```
  @override
  FlexBoxSpec resolve(MixData mix) {
    return FlexBoxSpec(
      animated: animated?.resolve(mix) ?? mix.animation,
      modifiers: modifiers?.resolve(mix),
      box: box?.resolve(mix),
      flex: flex?.resolve(mix),
    );
  }

  /// Merges the properties of this [FlexBoxSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FlexBoxSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FlexBoxSpecAttribute merge(FlexBoxSpecAttribute? other) {
    if (other == null) return this;

    return FlexBoxSpecAttribute(
      animated: animated?.merge(other.animated) ?? other.animated,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      box: box?.merge(other.box) ?? other.box,
      flex: flex?.merge(other.flex) ?? other.flex,
    );
  }

  /// The list of properties that constitute the state of this [FlexBoxSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexBoxSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        animated,
        modifiers,
        box,
        flex,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
    properties.add(DiagnosticsProperty('box', box, defaultValue: null));
    properties.add(DiagnosticsProperty('flex', flex, defaultValue: null));
  }
}

/// Utility class for configuring [FlexBoxSpec] properties.
///
/// This class provides methods to set individual properties of a [FlexBoxSpec].
/// Use the methods of this class to configure specific properties of a [FlexBoxSpec].
class FlexBoxSpecUtility<T extends Attribute>
    extends SpecUtility<T, FlexBoxSpecAttribute> {
  /// Utility for defining [FlexBoxSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  /// Utility for defining [FlexBoxSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [FlexBoxSpecAttribute.box]
  late final box = BoxSpecUtility((v) => only(box: v));

  /// Utility for defining [FlexBoxSpecAttribute.box.alignment]
  late final alignment = box.alignment;

  /// Utility for defining [FlexBoxSpecAttribute.box.padding]
  late final padding = box.padding;

  /// Utility for defining [FlexBoxSpecAttribute.box.margin]
  late final margin = box.margin;

  /// Utility for defining [FlexBoxSpecAttribute.box.constraints]
  late final constraints = box.constraints;

  /// Utility for defining [FlexBoxSpecAttribute.box.constraints.minWidth]
  late final minWidth = box.constraints.minWidth;

  /// Utility for defining [FlexBoxSpecAttribute.box.constraints.maxWidth]
  late final maxWidth = box.constraints.maxWidth;

  /// Utility for defining [FlexBoxSpecAttribute.box.constraints.minHeight]
  late final minHeight = box.constraints.minHeight;

  /// Utility for defining [FlexBoxSpecAttribute.box.constraints.maxHeight]
  late final maxHeight = box.constraints.maxHeight;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration]
  late final decoration = box.decoration;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.color]
  late final color = box.decoration.color;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.border]
  late final border = box.decoration.border;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.border.directional]
  late final borderDirectional = box.decoration.border.directional;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.borderRadius]
  late final borderRadius = box.decoration.borderRadius;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.borderRadius.directional]
  late final borderRadiusDirectional = box.decoration.borderRadius.directional;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.gradient]
  late final gradient = box.decoration.gradient;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.gradient.sweep]
  late final sweepGradient = box.decoration.gradient.sweep;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.gradient.radial]
  late final radialGradient = box.decoration.gradient.radial;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.gradient.linear]
  late final linearGradient = box.decoration.gradient.linear;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.boxShadows]
  late final shadows = box.decoration.boxShadows;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.boxShadow]
  late final shadow = box.decoration.boxShadow;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.elevation]
  late final elevation = box.decoration.elevation;

  /// Utility for defining [FlexBoxSpecAttribute.box.shapeDecoration]
  late final shapeDecoration = box.shapeDecoration;

  /// Utility for defining [FlexBoxSpecAttribute.box.shape]
  late final shape = box.shape;

  /// Utility for defining [FlexBoxSpecAttribute.box.foregroundDecoration]
  late final foregroundDecoration = box.foregroundDecoration;

  /// Utility for defining [FlexBoxSpecAttribute.box.transform]
  late final transform = box.transform;

  /// Utility for defining [FlexBoxSpecAttribute.box.transformAlignment]
  late final transformAlignment = box.transformAlignment;

  /// Utility for defining [FlexBoxSpecAttribute.box.clipBehavior]
  late final clipBehavior = box.clipBehavior;

  /// Utility for defining [FlexBoxSpecAttribute.box.width]
  late final width = box.width;

  /// Utility for defining [FlexBoxSpecAttribute.box.height]
  late final height = box.height;

  /// Utility for defining [FlexBoxSpecAttribute.flex]
  late final flex = FlexSpecUtility((v) => only(flex: v));

  FlexBoxSpecUtility(super.builder, {super.mutable});

  FlexBoxSpecUtility<T> get chain =>
      FlexBoxSpecUtility(attributeBuilder, mutable: true);

  static FlexBoxSpecUtility<FlexBoxSpecAttribute> get self =>
      FlexBoxSpecUtility((v) => v);

  /// Returns a new [FlexBoxSpecAttribute] with the specified properties.
  @override
  T only({
    AnimatedDataDto? animated,
    WidgetModifiersDataDto? modifiers,
    BoxSpecAttribute? box,
    FlexSpecAttribute? flex,
  }) {
    return builder(FlexBoxSpecAttribute(
      animated: animated,
      modifiers: modifiers,
      box: box,
      flex: flex,
    ));
  }
}

/// A tween that interpolates between two [FlexBoxSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [FlexBoxSpec] specifications.
class FlexBoxSpecTween extends Tween<FlexBoxSpec?> {
  FlexBoxSpecTween({
    super.begin,
    super.end,
  });

  @override
  FlexBoxSpec lerp(double t) {
    if (begin == null && end == null) {
      return const FlexBoxSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
