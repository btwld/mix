import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../attributes/constraints/constraints_dto.dart';
import '../../attributes/constraints/constraints_util.dart';
import '../../attributes/decoration/decoration_dto.dart';
import '../../attributes/decoration/decoration_util.dart';
import '../../attributes/enum/enum_util.dart';
import '../../attributes/scalars/scalar_util.dart';
import '../../attributes/spacing/edge_insets_dto.dart';
import '../../attributes/spacing/spacing_util.dart';
import '../../core/attribute.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/resolved_style_provider.dart';
import '../../core/spec.dart';
import '../../core/utility.dart';

final class BoxSpec extends Spec<BoxSpec> with Diagnosticable {
  /// Aligns the child within the box.
  final AlignmentGeometry? alignment;

  /// Adds empty space inside the box.
  final EdgeInsetsGeometry? padding;

  /// Adds empty space around the box.
  final EdgeInsetsGeometry? margin;

  /// Applies additional constraints to the child.
  final BoxConstraints? constraints;

  /// Paints a decoration behind the child.
  final Decoration? decoration;

  /// Paints a decoration in front of the child.
  final Decoration? foregroundDecoration;

  /// Applies a transformation matrix before painting the box.
  final Matrix4? transform;

  /// Aligns the origin of the coordinate system for the [transform].
  final AlignmentGeometry? transformAlignment;

  /// Defines the clip behavior for the box
  /// when [BoxConstraints] has a negative minimum extent.
  final Clip? clipBehavior;

  /// Specifies the width of the box.
  final double? width;

  /// Specifies the height of the box.
  final double? height;

  const BoxSpec({
    this.alignment,
    this.padding,
    this.margin,
    this.constraints,
    this.decoration,
    this.foregroundDecoration,
    this.transform,
    this.transformAlignment,
    this.clipBehavior,
    this.width,
    this.height,
  });

  static BoxSpec? maybeOf(BuildContext context) {
    return ResolvedStyleProvider.of<BoxSpec>(context)?.spec;
  }

  /// {@template box_spec_of}
  /// Retrieves the [BoxSpec] from the nearest [ResolvedStyleProvider] ancestor in the widget tree.
  ///
  /// This method provides the resolved BoxSpec from the style system.
  /// If no ancestor [ResolvedStyleProvider] is found, this method returns an empty [BoxSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final boxSpec = BoxSpec.of(context);
  /// ```
  /// {@endtemplate}
  static BoxSpec of(BuildContext context) {
    return maybeOf(context) ?? const BoxSpec();
  }

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
      DiagnosticsProperty('alignment', alignment, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('padding', padding, defaultValue: null));
    properties.add(DiagnosticsProperty('margin', margin, defaultValue: null));
    properties.add(
      DiagnosticsProperty('constraints', constraints, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('decoration', decoration, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'foregroundDecoration',
        foregroundDecoration,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('transform', transform, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'transformAlignment',
        transformAlignment,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('width', width, defaultValue: null));
    properties.add(DiagnosticsProperty('height', height, defaultValue: null));
  }

  /// Creates a copy of this [BoxSpec] but with the given fields
  /// replaced with the new values.
  @override
  BoxSpec copyWith({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxConstraints? constraints,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    double? width,
    double? height,
  }) {
    return BoxSpec(
      alignment: alignment ?? this.alignment,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      constraints: constraints ?? this.constraints,
      decoration: decoration ?? this.decoration,
      foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
      transform: transform ?? this.transform,
      transformAlignment: transformAlignment ?? this.transformAlignment,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  /// Linearly interpolates between this [BoxSpec] and another [BoxSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [BoxSpec] is returned. When [t] is 1.0, the [other] [BoxSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [BoxSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [BoxSpec] instance.
  ///
  /// The interpolation is performed on each property of the [BoxSpec] using the appropriate
  /// interpolation method:
  /// - [AlignmentGeometry.lerp] for [alignment] and [transformAlignment].
  /// - [EdgeInsetsGeometry.lerp] for [padding] and [margin].
  /// - [BoxConstraints.lerp] for [constraints].
  /// - [Decoration.lerp] for [decoration] and [foregroundDecoration].
  /// - [MixHelpers.lerpMatrix4] for [transform].
  /// - [MixHelpers.lerpDouble] for [width] and [height].
  /// For [clipBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [BoxSpec] is used. Otherwise, the value
  /// from the [other] [BoxSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [BoxSpec] configurations.
  @override
  BoxSpec lerp(BoxSpec? other, double t) {
    if (other == null) return this;

    return BoxSpec(
      alignment: AlignmentGeometry.lerp(alignment, other.alignment, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      margin: EdgeInsetsGeometry.lerp(margin, other.margin, t),
      constraints: BoxConstraints.lerp(constraints, other.constraints, t),
      decoration: Decoration.lerp(decoration, other.decoration, t),
      foregroundDecoration: Decoration.lerp(
        foregroundDecoration,
        other.foregroundDecoration,
        t,
      ),
      transform: MixHelpers.lerpMatrix4(transform, other.transform, t),
      transformAlignment: AlignmentGeometry.lerp(
        transformAlignment,
        other.transformAlignment,
        t,
      ),
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
      width: MixHelpers.lerpDouble(width, other.width, t),
      height: MixHelpers.lerpDouble(height, other.height, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  /// The list of properties that constitute the state of this [BoxSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BoxSpec] instances for equality.
  @override
  List<Object?> get props => [
    alignment,
    padding,
    margin,
    constraints,
    decoration,
    foregroundDecoration,
    transform,
    transformAlignment,
    clipBehavior,
    width,
    height,
  ];
}

/// Represents the attributes of a [BoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [BoxSpec].
///
/// Use this class to configure the attributes of a [BoxSpec] and pass it to
/// the [BoxSpec] constructor.
class BoxSpecAttribute extends SpecAttribute<BoxSpec> with Diagnosticable {
  final Prop<AlignmentGeometry>? alignment;
  final MixProp<EdgeInsetsGeometry, EdgeInsetsGeometryDto>? padding;
  final MixProp<EdgeInsetsGeometry, EdgeInsetsGeometryDto>? margin;
  final MixProp<BoxConstraints, BoxConstraintsDto>? constraints;
  final MixProp<Decoration, DecorationDto>? decoration;
  final MixProp<Decoration, DecorationDto>? foregroundDecoration;
  final Prop<Matrix4>? transform;
  final Prop<AlignmentGeometry>? transformAlignment;
  final Prop<Clip>? clipBehavior;
  final Prop<double>? width;
  final Prop<double>? height;

  factory BoxSpecAttribute({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometryDto? padding,
    EdgeInsetsGeometryDto? margin,
    BoxConstraintsDto? constraints,
    DecorationDto? decoration,
    DecorationDto? foregroundDecoration,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    double? width,
    double? height,
  }) {
    return BoxSpecAttribute.props(
      alignment: Prop.maybeValue(alignment),
      padding: MixProp.maybeValue(padding),
      margin: MixProp.maybeValue(margin),
      constraints: MixProp.maybeValue(constraints),
      decoration: MixProp.maybeValue(decoration),
      foregroundDecoration: MixProp.maybeValue(foregroundDecoration),
      transform: Prop.maybeValue(transform),
      transformAlignment: Prop.maybeValue(transformAlignment),
      clipBehavior: Prop.maybeValue(clipBehavior),
      width: Prop.maybeValue(width),
      height: Prop.maybeValue(height),
    );
  }

  const BoxSpecAttribute.props({
    this.alignment,
    this.padding,
    this.margin,
    this.constraints,
    this.decoration,
    this.foregroundDecoration,
    this.transform,
    this.transformAlignment,
    this.clipBehavior,
    this.width,
    this.height,
  });

  /// Constructor that accepts a [BoxSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [BoxSpec] instances to [BoxSpecAttribute].
  ///
  /// ```dart
  /// const spec = BoxSpec(alignment: Alignment.center, padding: EdgeInsets.all(8));
  /// final attr = BoxSpecAttribute.value(spec);
  /// ```
  static BoxSpecAttribute value(BoxSpec spec) {
    return BoxSpecAttribute(
      alignment: spec.alignment,
      padding: EdgeInsetsGeometryDto.maybeValue(spec.padding),
      margin: EdgeInsetsGeometryDto.maybeValue(spec.margin),
      constraints: BoxConstraintsDto.maybeValue(spec.constraints),
      decoration: DecorationDto.maybeValue(spec.decoration),
      foregroundDecoration: DecorationDto.maybeValue(spec.foregroundDecoration),
      transform: spec.transform,
      transformAlignment: spec.transformAlignment,
      clipBehavior: spec.clipBehavior,
      width: spec.width,
      height: spec.height,
    );
  }

  /// Constructor that accepts a nullable [BoxSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [BoxSpecAttribute.value].
  ///
  /// ```dart
  /// const BoxSpec? spec = BoxSpec(alignment: Alignment.center, padding: EdgeInsets.all(8));
  /// final attr = BoxSpecAttribute.maybeValue(spec); // Returns BoxSpecAttribute or null
  /// ```
  static BoxSpecAttribute? maybeValue(BoxSpec? spec) {
    return spec != null ? BoxSpecAttribute.value(spec) : null;
  }

  /// Resolves to [BoxSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final boxSpec = BoxSpecAttribute(...).resolve(mix);
  /// ```
  @override
  BoxSpec resolve(BuildContext context) {
    return BoxSpec(
      alignment: MixHelpers.resolve(context, alignment),
      padding: MixHelpers.resolve(context, padding),
      margin: MixHelpers.resolve(context, margin),
      constraints: MixHelpers.resolve(context, constraints),
      decoration: MixHelpers.resolve(context, decoration),
      foregroundDecoration: MixHelpers.resolve(context, foregroundDecoration),
      transform: MixHelpers.resolve(context, transform),
      transformAlignment: MixHelpers.resolve(context, transformAlignment),
      clipBehavior: MixHelpers.resolve(context, clipBehavior),
      width: MixHelpers.resolve(context, width),
      height: MixHelpers.resolve(context, height),
    );
  }

  /// Merges the properties of this [BoxSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BoxSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BoxSpecAttribute merge(BoxSpecAttribute? other) {
    if (other == null) return this;

    return BoxSpecAttribute.props(
      alignment: MixHelpers.merge(alignment, other.alignment),
      padding: MixHelpers.merge(padding, other.padding),
      margin: MixHelpers.merge(margin, other.margin),
      constraints: MixHelpers.merge(constraints, other.constraints),
      decoration: MixHelpers.merge(decoration, other.decoration),
      foregroundDecoration: MixHelpers.merge(
        foregroundDecoration,
        other.foregroundDecoration,
      ),
      transform: MixHelpers.merge(transform, other.transform),
      transformAlignment: MixHelpers.merge(
        transformAlignment,
        other.transformAlignment,
      ),
      clipBehavior: MixHelpers.merge(clipBehavior, other.clipBehavior),
      width: MixHelpers.merge(width, other.width),
      height: MixHelpers.merge(height, other.height),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('alignment', alignment, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('padding', padding, defaultValue: null));
    properties.add(DiagnosticsProperty('margin', margin, defaultValue: null));
    properties.add(
      DiagnosticsProperty('constraints', constraints, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('decoration', decoration, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'foregroundDecoration',
        foregroundDecoration,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('transform', transform, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'transformAlignment',
        transformAlignment,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('width', width, defaultValue: null));
    properties.add(DiagnosticsProperty('height', height, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [BoxSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BoxSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
    alignment,
    padding,
    margin,
    constraints,
    decoration,
    foregroundDecoration,
    transform,
    transformAlignment,
    clipBehavior,
    width,
    height,
  ];
}

/// Utility class for configuring [BoxSpec] properties.
///
/// This class provides methods to set individual properties of a [BoxSpec].
/// Use the methods of this class to configure specific properties of a [BoxSpec].
class BoxSpecUtility<T extends Attribute>
    extends SpecUtility<T, BoxSpecAttribute> {
  /// Utility for defining [BoxSpecAttribute.alignment]
  late final alignment = AlignmentGeometryUtility((v) => only(alignment: v));

  /// Utility for defining [BoxSpecAttribute.padding]
  late final padding = EdgeInsetsGeometryUtility((v) => only(padding: v));

  /// Utility for defining [BoxSpecAttribute.margin]
  late final margin = EdgeInsetsGeometryUtility((v) => only(margin: v));

  /// Utility for defining [BoxSpecAttribute.constraints]
  late final constraints = BoxConstraintsUtility((v) => only(constraints: v));

  /// Utility for defining [BoxSpecAttribute.constraints.minWidth]
  late final minWidth = constraints.minWidth;

  /// Utility for defining [BoxSpecAttribute.constraints.maxWidth]
  late final maxWidth = constraints.maxWidth;

  /// Utility for defining [BoxSpecAttribute.constraints.minHeight]
  late final minHeight = constraints.minHeight;

  /// Utility for defining [BoxSpecAttribute.constraints.maxHeight]
  late final maxHeight = constraints.maxHeight;

  /// Utility for defining [BoxSpecAttribute.decoration]
  late final decoration = BoxDecorationUtility((v) => only(decoration: v));

  /// Utility for defining [BoxSpecAttribute.decoration.color]
  late final color = decoration.color;

  /// Utility for defining [BoxSpecAttribute.decoration.border]
  late final border = decoration.border;

  /// Utility for defining [BoxSpecAttribute.decoration.border.directional]
  late final borderDirectional = decoration.border.directional;

  /// Utility for defining [BoxSpecAttribute.decoration.borderRadius]
  late final borderRadius = decoration.borderRadius;

  /// Utility for defining [BoxSpecAttribute.decoration.borderRadius.directional]
  late final borderRadiusDirectional = decoration.borderRadius.directional;

  /// Utility for defining [BoxSpecAttribute.decoration.gradient]
  late final gradient = decoration.gradient;

  /// Utility for defining [BoxSpecAttribute.decoration.gradient.sweep]
  late final sweepGradient = decoration.gradient.sweep;

  /// Utility for defining [BoxSpecAttribute.decoration.gradient.radial]
  late final radialGradient = decoration.gradient.radial;

  /// Utility for defining [BoxSpecAttribute.decoration.gradient.linear]
  late final linearGradient = decoration.gradient.linear;

  /// Utility for defining [BoxSpecAttribute.decoration.boxShadows]
  late final shadows = decoration.boxShadows;

  /// Utility for defining [BoxSpecAttribute.decoration.boxShadow]
  late final shadow = decoration.boxShadow;

  /// Utility for defining [BoxSpecAttribute.decoration.elevation]
  late final elevation = decoration.elevation;

  /// Utility for defining [BoxSpecAttribute.decoration]
  late final shapeDecoration = ShapeDecorationUtility(
    (v) => only(decoration: v),
  );

  /// Utility for defining [BoxSpecAttribute.shapeDecoration.shape]
  late final shape = shapeDecoration.shape;

  /// Utility for defining [BoxSpecAttribute.foregroundDecoration]
  late final foregroundDecoration = BoxDecorationUtility(
    (v) => only(foregroundDecoration: v),
  );

  /// Utility for defining [BoxSpecAttribute.transform]
  late final transform = Matrix4Utility((v) => only(transform: v));

  /// Utility for defining [BoxSpecAttribute.transformAlignment]
  late final transformAlignment = AlignmentGeometryUtility(
    (v) => only(transformAlignment: v),
  );

  /// Utility for defining [BoxSpecAttribute.clipBehavior]
  late final clipBehavior = ClipUtility((v) => only(clipBehavior: v));

  /// Utility for defining [BoxSpecAttribute.width]
  late final width = DoubleUtility(
    (prop) => builder(BoxSpecAttribute.props(width: prop)),
  );

  /// Utility for defining [BoxSpecAttribute.height]
  late final height = DoubleUtility(
    (prop) => builder(BoxSpecAttribute.props(height: prop)),
  );

  // TODO: add animated back into it
  //TODO: add wrap

  BoxSpecUtility(super.builder);

  static BoxSpecUtility<BoxSpecAttribute> get self => BoxSpecUtility((v) => v);

  /// Returns a new [BoxSpecAttribute] with the specified properties.
  @override
  T only({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometryDto? padding,
    EdgeInsetsGeometryDto? margin,
    BoxConstraintsDto? constraints,
    DecorationDto? decoration,
    DecorationDto? foregroundDecoration,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    double? width,
    double? height,
  }) {
    return builder(
      BoxSpecAttribute(
        alignment: alignment,
        padding: padding,
        margin: margin,
        constraints: constraints,
        decoration: decoration,
        foregroundDecoration: foregroundDecoration,
        transform: transform,
        transformAlignment: transformAlignment,
        clipBehavior: clipBehavior,
        width: width,
        height: height,
      ),
    );
  }
}

/// A tween that interpolates between two [BoxSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [BoxSpec] specifications.
class BoxSpecTween extends Tween<BoxSpec?> {
  BoxSpecTween({super.begin, super.end});

  @override
  BoxSpec lerp(double t) {
    if (begin == null && end == null) {
      return const BoxSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
