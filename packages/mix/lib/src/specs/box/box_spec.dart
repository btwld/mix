import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../attributes/animation/animated_config_dto.dart';
import '../../attributes/animation/animated_util.dart';
import '../../attributes/animation/animation_config.dart';
import '../../attributes/constraints/constraints_dto.dart';
import '../../attributes/constraints/constraints_util.dart';
import '../../attributes/decoration/decoration_dto.dart';
import '../../attributes/decoration/decoration_util.dart';
import '../../attributes/enum/enum_util.dart';
import '../../attributes/modifiers/widget_modifiers_config.dart';
import '../../attributes/modifiers/widget_modifiers_config_dto.dart';
import '../../attributes/modifiers/widget_modifiers_util.dart';
import '../../attributes/scalars/scalar_util.dart';
import '../../attributes/spacing/edge_insets_dto.dart';
import '../../attributes/spacing/spacing_util.dart';
import '../../core/computed_style/computed_style.dart';
import '../../core/factory/mix_context.dart';
import '../../core/factory/style_mix.dart';
import '../../core/helpers.dart';
import '../../core/spec.dart';
import '../../core/utility.dart';
import 'box_widget.dart';

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
    super.modifiers,
    super.animated,
  });

  static BoxSpec from(MixContext mix) {
    return mix.attributeOf<BoxSpecAttribute>()?.resolve(mix) ?? const BoxSpec();
  }

  /// {@template box_spec_of}
  /// Retrieves the [BoxSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [BoxSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [BoxSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final boxSpec = BoxSpec.of(context);
  /// ```
  /// {@endtemplate}
  static BoxSpec of(BuildContext context) {
    return ComputedStyle.specOf(context) ?? const BoxSpec();
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
    properties.add(
      DiagnosticsProperty('modifiers', modifiers, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('animated', animated, defaultValue: null),
    );
  }

  Widget call({Widget? child, List<Type> orderOfModifiers = const []}) {
    return isAnimated
        ? AnimatedBoxSpecWidget(
            spec: this,
            duration: animated!.duration,
            curve: animated!.curve,
            onEnd: animated?.onEnd,
            orderOfModifiers: orderOfModifiers,
            child: child,
          )
        : BoxSpecWidget(
            spec: this,
            orderOfModifiers: orderOfModifiers,
            child: child,
          );
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
    WidgetModifiersConfig? modifiers,
    AnimationConfig? animated,
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
      modifiers: modifiers ?? this.modifiers,
      animated: animated ?? this.animated,
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
  /// For [clipBehavior] and [modifiers] and [animated], the interpolation is performed using a step function.
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
      modifiers: other.modifiers,
      animated: animated ?? other.animated,
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
    modifiers,
    animated,
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
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometryDto? padding;
  final EdgeInsetsGeometryDto? margin;
  final BoxConstraintsDto? constraints;
  final DecorationDto? decoration;
  final DecorationDto? foregroundDecoration;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip? clipBehavior;
  final double? width;
  final double? height;

  const BoxSpecAttribute({
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
    super.modifiers,
    super.animated,
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
      padding: _convertEdgeInsetsGeometry(spec.padding),
      margin: _convertEdgeInsetsGeometry(spec.margin),
      constraints: BoxConstraintsDto.maybeValue(spec.constraints),
      decoration: _convertDecoration(spec.decoration),
      foregroundDecoration: _convertDecoration(spec.foregroundDecoration),
      transform: spec.transform,
      transformAlignment: spec.transformAlignment,
      clipBehavior: spec.clipBehavior,
      width: spec.width,
      height: spec.height,
      modifiers: WidgetModifiersConfigDto.maybeValue(spec.modifiers),
      animated: AnimationConfigDto.maybeValue(spec.animated),
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
  BoxSpec resolve(MixContext context) {
    return BoxSpec(
      alignment: alignment,
      padding: padding?.resolve(context),
      margin: margin?.resolve(context),
      constraints: constraints?.resolve(context),
      decoration: decoration?.resolve(context),
      foregroundDecoration: foregroundDecoration?.resolve(context),
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      width: width,
      height: height,
      modifiers: modifiers?.resolve(context),
      animated: animated?.resolve(context),
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

    return BoxSpecAttribute(
      alignment: other.alignment ?? alignment,
      padding: EdgeInsetsGeometryDto.tryToMerge(padding, other.padding),
      margin: EdgeInsetsGeometryDto.tryToMerge(margin, other.margin),
      constraints: constraints?.merge(other.constraints) ?? other.constraints,
      decoration: DecorationDto.tryToMerge(decoration, other.decoration),
      foregroundDecoration: DecorationDto.tryToMerge(
        foregroundDecoration,
        other.foregroundDecoration,
      ),
      transform: other.transform ?? transform,
      transformAlignment: other.transformAlignment ?? transformAlignment,
      clipBehavior: other.clipBehavior ?? clipBehavior,
      width: other.width ?? width,
      height: other.height ?? height,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      animated: animated?.merge(other.animated) ?? other.animated,
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
    properties.add(
      DiagnosticsProperty('modifiers', modifiers, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('animated', animated, defaultValue: null),
    );
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
    modifiers,
    animated,
  ];
}

/// Utility class for configuring [BoxSpec] properties.
///
/// This class provides methods to set individual properties of a [BoxSpec].
/// Use the methods of this class to configure specific properties of a [BoxSpec].
class BoxSpecUtility<T extends SpecAttribute>
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
  late final width = DoubleUtility((v) => only(width: v));

  /// Utility for defining [BoxSpecAttribute.height]
  late final height = DoubleUtility((v) => only(height: v));

  /// Utility for defining [BoxSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [BoxSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  BoxSpecUtility(
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
  BoxSpecUtility<T> get chain => BoxSpecUtility(attributeBuilder);

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
    WidgetModifiersConfigDto? modifiers,
    AnimationConfigDto? animated,
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
        modifiers: modifiers,
        animated: animated,
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

// Helper methods for converting Flutter types to DTOs
EdgeInsetsGeometryDto? _convertEdgeInsetsGeometry(EdgeInsetsGeometry? edgeInsets) {
  if (edgeInsets == null) return null;
  if (edgeInsets is EdgeInsets) {
    return EdgeInsetsDto.value(edgeInsets);
  } else if (edgeInsets is EdgeInsetsDirectional) {
    return EdgeInsetsDirectionalDto.value(edgeInsets);
  }
  return null;
}

DecorationDto? _convertDecoration(Decoration? decoration) {
  if (decoration == null) return null;
  if (decoration is BoxDecoration) {
    return BoxDecorationDto.value(decoration);
  } else if (decoration is ShapeDecoration) {
    return ShapeDecorationDto.value(decoration);
  }
  return null;
}
