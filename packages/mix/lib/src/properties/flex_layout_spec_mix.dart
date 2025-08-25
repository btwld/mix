import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/helpers.dart';
import '../core/mix_element.dart';
import '../core/prop.dart';
import 'flex_layout_spec.dart';
import 'layout/edge_insets_geometry_mix.dart';
import 'painting/decoration_mix.dart';

/// Mix class for configuring [FlexLayoutSpec] properties.
///
/// Encapsulates flex layout properties with support for proper Mix framework integration.
final class FlexLayoutSpecMix extends Mix<FlexLayoutSpec> with Diagnosticable {
  final Prop<Decoration>? $decoration;
  final Prop<EdgeInsetsGeometry>? $padding;
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<Axis>? $direction;
  final Prop<MainAxisAlignment>? $mainAxisAlignment;
  final Prop<CrossAxisAlignment>? $crossAxisAlignment;
  final Prop<MainAxisSize>? $mainAxisSize;
  final Prop<VerticalDirection>? $verticalDirection;
  final Prop<TextDirection>? $textDirection;
  final Prop<TextBaseline>? $textBaseline;
  final Prop<double>? $gap;
  final Prop<Clip>? $clipBehavior;
  final Prop<double>? $spacing;

  /// Main constructor with user-friendly Mix types
  FlexLayoutSpecMix({
    DecorationMix? decoration,
    EdgeInsetsGeometryMix? padding,
    AlignmentGeometry? alignment,
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    double? gap,
    Clip? clipBehavior,
    double? spacing,
  }) : this.create(
         decoration: Prop.maybeMix(decoration),
         padding: Prop.maybeMix(padding),
         alignment: Prop.maybe(alignment),
         direction: Prop.maybe(direction),
         mainAxisAlignment: Prop.maybe(mainAxisAlignment),
         crossAxisAlignment: Prop.maybe(crossAxisAlignment),
         mainAxisSize: Prop.maybe(mainAxisSize),
         verticalDirection: Prop.maybe(verticalDirection),
         textDirection: Prop.maybe(textDirection),
         textBaseline: Prop.maybe(textBaseline),
         gap: Prop.maybe(gap),
         clipBehavior: Prop.maybe(clipBehavior),
         spacing: Prop.maybe(spacing),
       );

  /// Create constructor with Prop<T> types for internal use
  const FlexLayoutSpecMix.create({
    Prop<Decoration>? decoration,
    Prop<EdgeInsetsGeometry>? padding,
    Prop<AlignmentGeometry>? alignment,
    Prop<Axis>? direction,
    Prop<MainAxisAlignment>? mainAxisAlignment,
    Prop<CrossAxisAlignment>? crossAxisAlignment,
    Prop<MainAxisSize>? mainAxisSize,
    Prop<VerticalDirection>? verticalDirection,
    Prop<TextDirection>? textDirection,
    Prop<TextBaseline>? textBaseline,
    Prop<double>? gap,
    Prop<Clip>? clipBehavior,
    Prop<double>? spacing,
  }) : $decoration = decoration,
       $padding = padding,
       $alignment = alignment,
       $direction = direction,
       $mainAxisAlignment = mainAxisAlignment,
       $crossAxisAlignment = crossAxisAlignment,
       $mainAxisSize = mainAxisSize,
       $verticalDirection = verticalDirection,
       $textDirection = textDirection,
       $textBaseline = textBaseline,
       $gap = gap,
       $clipBehavior = clipBehavior,
       $spacing = spacing;

  /// Constructor that accepts a [FlexLayoutSpec] value and extracts its properties.
  FlexLayoutSpecMix.value(FlexLayoutSpec spec)
    : this(
        decoration: DecorationMix.maybeValue(spec.decoration),
        padding: EdgeInsetsGeometryMix.maybeValue(spec.padding),
        alignment: spec.alignment,
        direction: spec.direction,
        mainAxisAlignment: spec.mainAxisAlignment,
        crossAxisAlignment: spec.crossAxisAlignment,
        mainAxisSize: spec.mainAxisSize,
        verticalDirection: spec.verticalDirection,
        textDirection: spec.textDirection,
        textBaseline: spec.textBaseline,
        gap: spec.gap,
        clipBehavior: spec.clipBehavior,
        spacing: spec.spacing,
      );

  // Factory constructors for common use cases

  /// Color factory
  factory FlexLayoutSpecMix.color(Color value) {
    return FlexLayoutSpecMix(decoration: DecorationMix.color(value));
  }

  /// Decoration factory
  factory FlexLayoutSpecMix.decoration(DecorationMix value) {
    return FlexLayoutSpecMix(decoration: value);
  }

  /// Alignment factory
  factory FlexLayoutSpecMix.alignment(AlignmentGeometry value) {
    return FlexLayoutSpecMix(alignment: value);
  }

  /// Padding factory
  factory FlexLayoutSpecMix.padding(EdgeInsetsGeometryMix value) {
    return FlexLayoutSpecMix(padding: value);
  }

  /// Direction factory
  factory FlexLayoutSpecMix.direction(Axis value) {
    return FlexLayoutSpecMix(direction: value);
  }

  /// Gap factory
  factory FlexLayoutSpecMix.gap(double value) {
    return FlexLayoutSpecMix(gap: value);
  }

  /// Main axis alignment factory
  factory FlexLayoutSpecMix.mainAxisAlignment(MainAxisAlignment value) {
    return FlexLayoutSpecMix(mainAxisAlignment: value);
  }

  /// Cross axis alignment factory
  factory FlexLayoutSpecMix.crossAxisAlignment(CrossAxisAlignment value) {
    return FlexLayoutSpecMix(crossAxisAlignment: value);
  }

  /// Main axis size factory
  factory FlexLayoutSpecMix.mainAxisSize(MainAxisSize value) {
    return FlexLayoutSpecMix(mainAxisSize: value);
  }

  /// Vertical direction factory
  factory FlexLayoutSpecMix.verticalDirection(VerticalDirection value) {
    return FlexLayoutSpecMix(verticalDirection: value);
  }

  /// Text direction factory
  factory FlexLayoutSpecMix.textDirection(TextDirection value) {
    return FlexLayoutSpecMix(textDirection: value);
  }

  /// Text baseline factory
  factory FlexLayoutSpecMix.textBaseline(TextBaseline value) {
    return FlexLayoutSpecMix(textBaseline: value);
  }

  /// Spacing factory (sets spacing internally for API consistency)
  factory FlexLayoutSpecMix.spacing(double value) {
    return FlexLayoutSpecMix(spacing: value);
  }

  /// Clip behavior factory
  factory FlexLayoutSpecMix.clipBehavior(Clip value) {
    return FlexLayoutSpecMix(clipBehavior: value);
  }

  // Flex-specific factories

  /// Horizontal flex factory
  factory FlexLayoutSpecMix.horizontal({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? gap,
  }) {
    return FlexLayoutSpecMix(
      direction: Axis.horizontal,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      gap: gap,
    );
  }

  /// Vertical flex factory
  factory FlexLayoutSpecMix.vertical({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? gap,
  }) {
    return FlexLayoutSpecMix(
      direction: Axis.vertical,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      gap: gap,
    );
  }

  /// Row factory (horizontal shorthand)
  factory FlexLayoutSpecMix.row({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? gap,
  }) {
    return FlexLayoutSpecMix.horizontal(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      gap: gap,
    );
  }

  /// Column factory (vertical shorthand)
  factory FlexLayoutSpecMix.column({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? gap,
  }) {
    return FlexLayoutSpecMix.vertical(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      gap: gap,
    );
  }

  /// Constructor that accepts a nullable [FlexLayoutSpec] value.
  ///
  /// Returns null if the input is null, otherwise uses [FlexLayoutSpecMix.value].
  static FlexLayoutSpecMix? maybeValue(FlexLayoutSpec? spec) {
    return spec != null ? FlexLayoutSpecMix.value(spec) : null;
  }

  // Chainable instance methods

  /// Returns a copy with the specified color.
  FlexLayoutSpecMix color(Color value) {
    return merge(FlexLayoutSpecMix.color(value));
  }

  /// Returns a copy with the specified decoration.
  FlexLayoutSpecMix decoration(DecorationMix value) {
    return merge(FlexLayoutSpecMix.decoration(value));
  }

  /// Returns a copy with the specified alignment.
  FlexLayoutSpecMix alignment(AlignmentGeometry value) {
    return merge(FlexLayoutSpecMix.alignment(value));
  }

  /// Returns a copy with the specified padding.
  FlexLayoutSpecMix padding(EdgeInsetsGeometryMix value) {
    return merge(FlexLayoutSpecMix.padding(value));
  }

  /// Returns a copy with the specified direction.
  FlexLayoutSpecMix direction(Axis value) {
    return merge(FlexLayoutSpecMix.direction(value));
  }

  /// Returns a copy with the specified gap.
  FlexLayoutSpecMix gap(double value) {
    return merge(FlexLayoutSpecMix.gap(value));
  }

  /// Returns a copy with the specified main axis alignment.
  FlexLayoutSpecMix mainAxisAlignment(MainAxisAlignment value) {
    return merge(FlexLayoutSpecMix(mainAxisAlignment: value));
  }

  /// Returns a copy with the specified cross axis alignment.
  FlexLayoutSpecMix crossAxisAlignment(CrossAxisAlignment value) {
    return merge(FlexLayoutSpecMix(crossAxisAlignment: value));
  }

  /// Returns a copy with the specified main axis size.
  FlexLayoutSpecMix mainAxisSize(MainAxisSize value) {
    return merge(FlexLayoutSpecMix(mainAxisSize: value));
  }

  /// Returns a copy with the specified vertical direction.
  FlexLayoutSpecMix verticalDirection(VerticalDirection value) {
    return merge(FlexLayoutSpecMix(verticalDirection: value));
  }

  /// Returns a copy with the specified text direction.
  FlexLayoutSpecMix textDirection(TextDirection value) {
    return merge(FlexLayoutSpecMix(textDirection: value));
  }

  /// Returns a copy with the specified text baseline.
  FlexLayoutSpecMix textBaseline(TextBaseline value) {
    return merge(FlexLayoutSpecMix(textBaseline: value));
  }

  /// Returns a copy with the specified spacing.
  FlexLayoutSpecMix spacing(double value) {
    return merge(FlexLayoutSpecMix(spacing: value));
  }

  /// Returns a copy with the specified clip behavior.
  FlexLayoutSpecMix clipBehavior(Clip value) {
    return merge(FlexLayoutSpecMix(clipBehavior: value));
  }

  /// Resolves to [FlexLayoutSpec] using the provided [BuildContext].
  @override
  FlexLayoutSpec resolve(BuildContext context) {
    return FlexLayoutSpec(
      decoration: MixOps.resolve(context, $decoration),
      padding: MixOps.resolve(context, $padding),
      alignment: MixOps.resolve(context, $alignment),
      direction: MixOps.resolve(context, $direction),
      mainAxisAlignment: MixOps.resolve(context, $mainAxisAlignment),
      crossAxisAlignment: MixOps.resolve(context, $crossAxisAlignment),
      mainAxisSize: MixOps.resolve(context, $mainAxisSize),
      verticalDirection: MixOps.resolve(context, $verticalDirection),
      textDirection: MixOps.resolve(context, $textDirection),
      textBaseline: MixOps.resolve(context, $textBaseline),
      gap: MixOps.resolve(context, $gap),
      clipBehavior: MixOps.resolve(context, $clipBehavior),
      spacing: MixOps.resolve(context, $spacing),
    );
  }

  /// Merges the properties of this [FlexLayoutSpecMix] with the properties of [other].
  @override
  FlexLayoutSpecMix merge(FlexLayoutSpecMix? other) {
    if (other == null) return this;

    return FlexLayoutSpecMix.create(
      decoration: MixOps.merge($decoration, other.$decoration),
      padding: MixOps.merge($padding, other.$padding),
      alignment: MixOps.merge($alignment, other.$alignment),
      direction: MixOps.merge($direction, other.$direction),
      mainAxisAlignment: MixOps.merge(
        $mainAxisAlignment,
        other.$mainAxisAlignment,
      ),
      crossAxisAlignment: MixOps.merge(
        $crossAxisAlignment,
        other.$crossAxisAlignment,
      ),
      mainAxisSize: MixOps.merge($mainAxisSize, other.$mainAxisSize),
      verticalDirection: MixOps.merge(
        $verticalDirection,
        other.$verticalDirection,
      ),
      textDirection: MixOps.merge($textDirection, other.$textDirection),
      textBaseline: MixOps.merge($textBaseline, other.$textBaseline),
      gap: MixOps.merge($gap, other.$gap),
      clipBehavior: MixOps.merge($clipBehavior, other.$clipBehavior),
      spacing: MixOps.merge($spacing, other.$spacing),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('decoration', $decoration))
      ..add(DiagnosticsProperty('padding', $padding))
      ..add(DiagnosticsProperty('alignment', $alignment))
      ..add(DiagnosticsProperty('direction', $direction))
      ..add(DiagnosticsProperty('mainAxisAlignment', $mainAxisAlignment))
      ..add(DiagnosticsProperty('crossAxisAlignment', $crossAxisAlignment))
      ..add(DiagnosticsProperty('mainAxisSize', $mainAxisSize))
      ..add(DiagnosticsProperty('verticalDirection', $verticalDirection))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('textBaseline', $textBaseline))
      ..add(DiagnosticsProperty('gap', $gap))
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior))
      ..add(DiagnosticsProperty('spacing', $spacing));
  }

  @override
  List<Object?> get props => [
    $decoration,
    $padding,
    $alignment,
    $direction,
    $mainAxisAlignment,
    $crossAxisAlignment,
    $mainAxisSize,
    $verticalDirection,
    $textDirection,
    $textBaseline,
    $gap,
    $clipBehavior,
    $spacing,
  ];
}
