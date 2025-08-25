import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/mix_element.dart';
import '../../properties/layout/constraints_mix.dart';
import '../../properties/layout/edge_insets_geometry_mix.dart';
import '../../properties/painting/border_radius_mix.dart';
import '../../properties/painting/border_mix.dart';
import '../../properties/painting/decoration_mix.dart';
import '../../properties/painting/shadow_mix.dart';
import 'flex_container_spec.dart';

/// Mix class for configuring [FlexContainerSpec] properties.
///
/// Combines both container and flex layout properties in a unified Mix class,
/// allowing for easy creation and configuration of flex container specifications
/// with support for proper Mix framework integration.
final class FlexContainerMix extends Mix<FlexContainerSpec> with Diagnosticable {
  // Container properties (using Prop<T>)
  final Prop<Decoration>? $decoration;
  final Prop<Decoration>? $foregroundDecoration;
  final Prop<EdgeInsetsGeometry>? $padding;
  final Prop<EdgeInsetsGeometry>? $margin;
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<BoxConstraints>? $constraints;
  final Prop<Matrix4>? $transform;
  final Prop<AlignmentGeometry>? $transformAlignment;
  final Prop<Clip>? $clipBehavior;

  // Flex layout properties (using Prop<T>)
  final Prop<Axis>? $direction;
  final Prop<MainAxisAlignment>? $mainAxisAlignment;
  final Prop<CrossAxisAlignment>? $crossAxisAlignment;
  final Prop<MainAxisSize>? $mainAxisSize;
  final Prop<VerticalDirection>? $verticalDirection;
  final Prop<TextDirection>? $textDirection;
  final Prop<TextBaseline>? $textBaseline;
  final Prop<double>? $spacing;

  /// Main constructor with user-friendly Mix types
  FlexContainerMix({
    // Container properties
    DecorationMix? decoration,
    DecorationMix? foregroundDecoration,
    EdgeInsetsGeometryMix? padding,
    EdgeInsetsGeometryMix? margin,
    AlignmentGeometry? alignment,
    BoxConstraintsMix? constraints,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    // Flex properties
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    double? spacing,
  }) : this.create(
          decoration: Prop.maybeMix(decoration),
          foregroundDecoration: Prop.maybeMix(foregroundDecoration),
          padding: Prop.maybeMix(padding),
          margin: Prop.maybeMix(margin),
          alignment: Prop.maybe(alignment),
          constraints: Prop.maybeMix(constraints),
          transform: Prop.maybe(transform),
          transformAlignment: Prop.maybe(transformAlignment),
          clipBehavior: Prop.maybe(clipBehavior),
          direction: Prop.maybe(direction),
          mainAxisAlignment: Prop.maybe(mainAxisAlignment),
          crossAxisAlignment: Prop.maybe(crossAxisAlignment),
          mainAxisSize: Prop.maybe(mainAxisSize),
          verticalDirection: Prop.maybe(verticalDirection),
          textDirection: Prop.maybe(textDirection),
          textBaseline: Prop.maybe(textBaseline),
          spacing: Prop.maybe(spacing),
        );

  /// Create constructor with `Prop<T>` types for internal use
  const FlexContainerMix.create({
    // Container properties
    Prop<Decoration>? decoration,
    Prop<Decoration>? foregroundDecoration,
    Prop<EdgeInsetsGeometry>? padding,
    Prop<EdgeInsetsGeometry>? margin,
    Prop<AlignmentGeometry>? alignment,
    Prop<BoxConstraints>? constraints,
    Prop<Matrix4>? transform,
    Prop<AlignmentGeometry>? transformAlignment,
    Prop<Clip>? clipBehavior,
    // Flex properties
    Prop<Axis>? direction,
    Prop<MainAxisAlignment>? mainAxisAlignment,
    Prop<CrossAxisAlignment>? crossAxisAlignment,
    Prop<MainAxisSize>? mainAxisSize,
    Prop<VerticalDirection>? verticalDirection,
    Prop<TextDirection>? textDirection,
    Prop<TextBaseline>? textBaseline,
    Prop<double>? spacing,
  })  : $decoration = decoration,
        $foregroundDecoration = foregroundDecoration,
        $padding = padding,
        $margin = margin,
        $alignment = alignment,
        $constraints = constraints,
        $transform = transform,
        $transformAlignment = transformAlignment,
        $clipBehavior = clipBehavior,
        $direction = direction,
        $mainAxisAlignment = mainAxisAlignment,
        $crossAxisAlignment = crossAxisAlignment,
        $mainAxisSize = mainAxisSize,
        $verticalDirection = verticalDirection,
        $textDirection = textDirection,
        $textBaseline = textBaseline,
        $spacing = spacing;

  /// Constructor that accepts a [FlexContainerSpec] value and extracts its properties.
  FlexContainerMix.value(FlexContainerSpec spec)
      : this(
          decoration: DecorationMix.maybeValue(spec.decoration),
          foregroundDecoration: DecorationMix.maybeValue(spec.foregroundDecoration),
          padding: EdgeInsetsGeometryMix.maybeValue(spec.padding),
          margin: EdgeInsetsGeometryMix.maybeValue(spec.margin),
          alignment: spec.alignment,
          constraints: BoxConstraintsMix.maybeValue(spec.constraints),
          transform: spec.transform,
          transformAlignment: spec.transformAlignment,
          clipBehavior: spec.clipBehavior,
          direction: spec.direction,
          mainAxisAlignment: spec.mainAxisAlignment,
          crossAxisAlignment: spec.crossAxisAlignment,
          mainAxisSize: spec.mainAxisSize,
          verticalDirection: spec.verticalDirection,
          textDirection: spec.textDirection,
          textBaseline: spec.textBaseline,
          spacing: spec.spacing,
        );

  // Container factory constructors

  /// Color factory
  factory FlexContainerMix.color(Color value) {
    return FlexContainerMix(decoration: DecorationMix.color(value));
  }

  /// Decoration factory
  factory FlexContainerMix.decoration(DecorationMix value) {
    return FlexContainerMix(decoration: value);
  }

  /// Foreground decoration factory
  factory FlexContainerMix.foregroundDecoration(DecorationMix value) {
    return FlexContainerMix(foregroundDecoration: value);
  }

  /// Alignment factory
  factory FlexContainerMix.alignment(AlignmentGeometry value) {
    return FlexContainerMix(alignment: value);
  }

  /// Padding factory
  factory FlexContainerMix.padding(EdgeInsetsGeometryMix value) {
    return FlexContainerMix(padding: value);
  }

  /// Margin factory
  factory FlexContainerMix.margin(EdgeInsetsGeometryMix value) {
    return FlexContainerMix(margin: value);
  }

  /// Transform factory
  factory FlexContainerMix.transform(Matrix4 value) {
    return FlexContainerMix(transform: value);
  }

  /// Transform alignment factory
  factory FlexContainerMix.transformAlignment(AlignmentGeometry value) {
    return FlexContainerMix(transformAlignment: value);
  }

  /// Clip behavior factory
  factory FlexContainerMix.clipBehavior(Clip value) {
    return FlexContainerMix(clipBehavior: value);
  }

  /// Constraints factory
  factory FlexContainerMix.constraints(BoxConstraintsMix value) {
    return FlexContainerMix(constraints: value);
  }

  /// Border factory
  factory FlexContainerMix.border(BoxBorderMix value) {
    return FlexContainerMix(decoration: DecorationMix.border(value));
  }

  /// Border radius factory
  factory FlexContainerMix.borderRadius(BorderRadiusGeometryMix value) {
    return FlexContainerMix(decoration: DecorationMix.borderRadius(value));
  }

  /// Shadow factory
  factory FlexContainerMix.shadow(BoxShadowMix value) {
    return FlexContainerMix(decoration: DecorationMix.boxShadow([value]));
  }

  /// Width factory
  factory FlexContainerMix.width(double value) {
    return FlexContainerMix(constraints: BoxConstraintsMix.width(value));
  }

  /// Height factory
  factory FlexContainerMix.height(double value) {
    return FlexContainerMix(constraints: BoxConstraintsMix.height(value));
  }

  // Flex layout factory constructors

  /// Direction factory
  factory FlexContainerMix.direction(Axis value) {
    return FlexContainerMix(direction: value);
  }

  /// Gap factory (deprecated, use spacing)
  @Deprecated(
    'Use FlexContainerMix.spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  factory FlexContainerMix.gap(double value) {
    return FlexContainerMix(spacing: value);
  }

  /// Spacing factory
  factory FlexContainerMix.spacing(double value) {
    return FlexContainerMix(spacing: value);
  }

  /// Main axis alignment factory
  factory FlexContainerMix.mainAxisAlignment(MainAxisAlignment value) {
    return FlexContainerMix(mainAxisAlignment: value);
  }

  /// Cross axis alignment factory
  factory FlexContainerMix.crossAxisAlignment(CrossAxisAlignment value) {
    return FlexContainerMix(crossAxisAlignment: value);
  }

  /// Main axis size factory
  factory FlexContainerMix.mainAxisSize(MainAxisSize value) {
    return FlexContainerMix(mainAxisSize: value);
  }

  /// Vertical direction factory
  factory FlexContainerMix.verticalDirection(VerticalDirection value) {
    return FlexContainerMix(verticalDirection: value);
  }

  /// Text direction factory
  factory FlexContainerMix.textDirection(TextDirection value) {
    return FlexContainerMix(textDirection: value);
  }

  /// Text baseline factory
  factory FlexContainerMix.textBaseline(TextBaseline value) {
    return FlexContainerMix(textBaseline: value);
  }

  // Convenience flex layout factories

  /// Horizontal flex factory
  factory FlexContainerMix.horizontal({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? spacing,
  }) {
    return FlexContainerMix(
      direction: Axis.horizontal,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      spacing: spacing,
    );
  }

  /// Vertical flex factory
  factory FlexContainerMix.vertical({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? spacing,
  }) {
    return FlexContainerMix(
      direction: Axis.vertical,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      spacing: spacing,
    );
  }

  /// Row factory (horizontal shorthand)
  factory FlexContainerMix.row({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? spacing,
  }) {
    return FlexContainerMix.horizontal(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      spacing: spacing,
    );
  }

  /// Column factory (vertical shorthand)
  factory FlexContainerMix.column({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? spacing,
  }) {
    return FlexContainerMix.vertical(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      spacing: spacing,
    );
  }

  /// Constructor that accepts a nullable [FlexContainerSpec] value.
  ///
  /// Returns null if the input is null, otherwise uses [FlexContainerMix.value].
  static FlexContainerMix? maybeValue(FlexContainerSpec? spec) {
    return spec != null ? FlexContainerMix.value(spec) : null;
  }

  // Chainable instance methods - Container properties

  /// Returns a copy with the specified color.
  FlexContainerMix color(Color value) {
    return merge(FlexContainerMix.color(value));
  }

  /// Returns a copy with the specified decoration.
  FlexContainerMix decoration(DecorationMix value) {
    return merge(FlexContainerMix.decoration(value));
  }

  /// Returns a copy with the specified foreground decoration.
  FlexContainerMix foregroundDecoration(DecorationMix value) {
    return merge(FlexContainerMix.foregroundDecoration(value));
  }

  /// Returns a copy with the specified alignment.
  FlexContainerMix alignment(AlignmentGeometry value) {
    return merge(FlexContainerMix.alignment(value));
  }

  /// Returns a copy with the specified padding.
  FlexContainerMix padding(EdgeInsetsGeometryMix value) {
    return merge(FlexContainerMix.padding(value));
  }

  /// Returns a copy with the specified margin.
  FlexContainerMix margin(EdgeInsetsGeometryMix value) {
    return merge(FlexContainerMix.margin(value));
  }

  /// Returns a copy with the specified transform.
  FlexContainerMix transform(Matrix4 value) {
    return merge(FlexContainerMix.transform(value));
  }

  /// Returns a copy with the specified transform alignment.
  FlexContainerMix transformAlignment(AlignmentGeometry value) {
    return merge(FlexContainerMix.transformAlignment(value));
  }

  /// Returns a copy with the specified clip behavior.
  FlexContainerMix clipBehavior(Clip value) {
    return merge(FlexContainerMix.clipBehavior(value));
  }

  /// Returns a copy with the specified constraints.
  FlexContainerMix constraints(BoxConstraintsMix value) {
    return merge(FlexContainerMix.constraints(value));
  }

  /// Returns a copy with the specified border.
  FlexContainerMix border(BoxBorderMix value) {
    return merge(FlexContainerMix.border(value));
  }

  /// Returns a copy with the specified border radius.
  FlexContainerMix borderRadius(BorderRadiusGeometryMix value) {
    return merge(FlexContainerMix.borderRadius(value));
  }

  /// Returns a copy with the specified shadow.
  FlexContainerMix shadow(BoxShadowMix value) {
    return merge(FlexContainerMix.shadow(value));
  }

  /// Returns a copy with the specified width.
  FlexContainerMix width(double value) {
    return merge(FlexContainerMix.width(value));
  }

  /// Returns a copy with the specified height.
  FlexContainerMix height(double value) {
    return merge(FlexContainerMix.height(value));
  }

  // Chainable instance methods - Flex properties

  /// Returns a copy with the specified direction.
  FlexContainerMix direction(Axis value) {
    return merge(FlexContainerMix.direction(value));
  }

  /// Returns a copy with the specified gap.
  @Deprecated(
    'Use spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  FlexContainerMix gap(double value) {
    return merge(FlexContainerMix.spacing(value));
  }

  /// Returns a copy with the specified spacing.
  FlexContainerMix spacing(double value) {
    return merge(FlexContainerMix.spacing(value));
  }

  /// Returns a copy with the specified main axis alignment.
  FlexContainerMix mainAxisAlignment(MainAxisAlignment value) {
    return merge(FlexContainerMix.mainAxisAlignment(value));
  }

  /// Returns a copy with the specified cross axis alignment.
  FlexContainerMix crossAxisAlignment(CrossAxisAlignment value) {
    return merge(FlexContainerMix.crossAxisAlignment(value));
  }

  /// Returns a copy with the specified main axis size.
  FlexContainerMix mainAxisSize(MainAxisSize value) {
    return merge(FlexContainerMix.mainAxisSize(value));
  }

  /// Returns a copy with the specified vertical direction.
  FlexContainerMix verticalDirection(VerticalDirection value) {
    return merge(FlexContainerMix.verticalDirection(value));
  }

  /// Returns a copy with the specified text direction.
  FlexContainerMix textDirection(TextDirection value) {
    return merge(FlexContainerMix.textDirection(value));
  }

  /// Returns a copy with the specified text baseline.
  FlexContainerMix textBaseline(TextBaseline value) {
    return merge(FlexContainerMix.textBaseline(value));
  }

  /// Resolves to [FlexContainerSpec] using the provided [BuildContext].
  @override
  FlexContainerSpec resolve(BuildContext context) {
    return FlexContainerSpec(
      decoration: MixOps.resolve(context, $decoration),
      foregroundDecoration: MixOps.resolve(context, $foregroundDecoration),
      padding: MixOps.resolve(context, $padding),
      margin: MixOps.resolve(context, $margin),
      alignment: MixOps.resolve(context, $alignment),
      constraints: MixOps.resolve(context, $constraints),
      transform: MixOps.resolve(context, $transform),
      transformAlignment: MixOps.resolve(context, $transformAlignment),
      clipBehavior: MixOps.resolve(context, $clipBehavior),
      direction: MixOps.resolve(context, $direction),
      mainAxisAlignment: MixOps.resolve(context, $mainAxisAlignment),
      crossAxisAlignment: MixOps.resolve(context, $crossAxisAlignment),
      mainAxisSize: MixOps.resolve(context, $mainAxisSize),
      verticalDirection: MixOps.resolve(context, $verticalDirection),
      textDirection: MixOps.resolve(context, $textDirection),
      textBaseline: MixOps.resolve(context, $textBaseline),
      spacing: MixOps.resolve(context, $spacing),
    );
  }

  /// Merges the properties of this [FlexContainerMix] with the properties of [other].
  @override
  FlexContainerMix merge(FlexContainerMix? other) {
    if (other == null) return this;

    return FlexContainerMix.create(
      decoration: MixOps.merge($decoration, other.$decoration),
      foregroundDecoration: MixOps.merge($foregroundDecoration, other.$foregroundDecoration),
      padding: MixOps.merge($padding, other.$padding),
      margin: MixOps.merge($margin, other.$margin),
      alignment: MixOps.merge($alignment, other.$alignment),
      constraints: MixOps.merge($constraints, other.$constraints),
      transform: MixOps.merge($transform, other.$transform),
      transformAlignment: MixOps.merge($transformAlignment, other.$transformAlignment),
      clipBehavior: MixOps.merge($clipBehavior, other.$clipBehavior),
      direction: MixOps.merge($direction, other.$direction),
      mainAxisAlignment: MixOps.merge($mainAxisAlignment, other.$mainAxisAlignment),
      crossAxisAlignment: MixOps.merge($crossAxisAlignment, other.$crossAxisAlignment),
      mainAxisSize: MixOps.merge($mainAxisSize, other.$mainAxisSize),
      verticalDirection: MixOps.merge($verticalDirection, other.$verticalDirection),
      textDirection: MixOps.merge($textDirection, other.$textDirection),
      textBaseline: MixOps.merge($textBaseline, other.$textBaseline),
      spacing: MixOps.merge($spacing, other.$spacing),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      // Container properties
      ..add(DiagnosticsProperty('decoration', $decoration))
      ..add(DiagnosticsProperty('foregroundDecoration', $foregroundDecoration))
      ..add(DiagnosticsProperty('padding', $padding))
      ..add(DiagnosticsProperty('margin', $margin))
      ..add(DiagnosticsProperty('alignment', $alignment))
      ..add(DiagnosticsProperty('constraints', $constraints))
      ..add(DiagnosticsProperty('transform', $transform))
      ..add(DiagnosticsProperty('transformAlignment', $transformAlignment))
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior))
      // Flex properties
      ..add(DiagnosticsProperty('direction', $direction))
      ..add(DiagnosticsProperty('mainAxisAlignment', $mainAxisAlignment))
      ..add(DiagnosticsProperty('crossAxisAlignment', $crossAxisAlignment))
      ..add(DiagnosticsProperty('mainAxisSize', $mainAxisSize))
      ..add(DiagnosticsProperty('verticalDirection', $verticalDirection))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('textBaseline', $textBaseline))
      ..add(DiagnosticsProperty('spacing', $spacing));
  }

  @override
  List<Object?> get props => [
    $decoration,
    $foregroundDecoration,
    $padding,
    $margin,
    $alignment,
    $constraints,
    $transform,
    $transformAlignment,
    $clipBehavior,
    $direction,
    $mainAxisAlignment,
    $crossAxisAlignment,
    $mainAxisSize,
    $verticalDirection,
    $textDirection,
    $textBaseline,
    $spacing,
  ];
}