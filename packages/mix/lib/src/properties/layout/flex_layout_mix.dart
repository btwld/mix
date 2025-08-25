import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import 'flex_layout_spec.dart';
import 'edge_insets_geometry_mix.dart';
import '../painting/decoration_mix.dart';

/// Mix class for configuring [FlexLayoutSpec] properties.
///
/// Encapsulates flex layout properties with support for proper Mix framework integration.
final class FlexLayoutMix extends Mix<FlexLayoutSpec> with Diagnosticable {
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
  FlexLayoutMix({
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

  /// Create constructor with `Prop<T>` types for internal use
  const FlexLayoutMix.create({
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
  FlexLayoutMix.value(FlexLayoutSpec spec)
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
  factory FlexLayoutMix.color(Color value) {
    return FlexLayoutMix(decoration: DecorationMix.color(value));
  }

  /// Decoration factory
  factory FlexLayoutMix.decoration(DecorationMix value) {
    return FlexLayoutMix(decoration: value);
  }

  /// Alignment factory
  factory FlexLayoutMix.alignment(AlignmentGeometry value) {
    return FlexLayoutMix(alignment: value);
  }

  /// Padding factory
  factory FlexLayoutMix.padding(EdgeInsetsGeometryMix value) {
    return FlexLayoutMix(padding: value);
  }

  /// Direction factory
  factory FlexLayoutMix.direction(Axis value) {
    return FlexLayoutMix(direction: value);
  }

  /// Gap factory
  factory FlexLayoutMix.gap(double value) {
    return FlexLayoutMix(gap: value);
  }

  /// Main axis alignment factory
  factory FlexLayoutMix.mainAxisAlignment(MainAxisAlignment value) {
    return FlexLayoutMix(mainAxisAlignment: value);
  }

  /// Cross axis alignment factory
  factory FlexLayoutMix.crossAxisAlignment(CrossAxisAlignment value) {
    return FlexLayoutMix(crossAxisAlignment: value);
  }

  /// Main axis size factory
  factory FlexLayoutMix.mainAxisSize(MainAxisSize value) {
    return FlexLayoutMix(mainAxisSize: value);
  }

  /// Vertical direction factory
  factory FlexLayoutMix.verticalDirection(VerticalDirection value) {
    return FlexLayoutMix(verticalDirection: value);
  }

  /// Text direction factory
  factory FlexLayoutMix.textDirection(TextDirection value) {
    return FlexLayoutMix(textDirection: value);
  }

  /// Text baseline factory
  factory FlexLayoutMix.textBaseline(TextBaseline value) {
    return FlexLayoutMix(textBaseline: value);
  }

  /// Spacing factory (sets spacing internally for API consistency)
  factory FlexLayoutMix.spacing(double value) {
    return FlexLayoutMix(spacing: value);
  }

  /// Clip behavior factory
  factory FlexLayoutMix.clipBehavior(Clip value) {
    return FlexLayoutMix(clipBehavior: value);
  }

  // Flex-specific factories

  /// Horizontal flex factory
  factory FlexLayoutMix.horizontal({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? gap,
  }) {
    return FlexLayoutMix(
      direction: Axis.horizontal,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      gap: gap,
    );
  }

  /// Vertical flex factory
  factory FlexLayoutMix.vertical({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? gap,
  }) {
    return FlexLayoutMix(
      direction: Axis.vertical,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      gap: gap,
    );
  }

  /// Row factory (horizontal shorthand)
  factory FlexLayoutMix.row({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? gap,
  }) {
    return FlexLayoutMix.horizontal(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      gap: gap,
    );
  }

  /// Column factory (vertical shorthand)
  factory FlexLayoutMix.column({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? gap,
  }) {
    return FlexLayoutMix.vertical(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      gap: gap,
    );
  }

  /// Constructor that accepts a nullable [FlexLayoutSpec] value.
  ///
  /// Returns null if the input is null, otherwise uses [FlexLayoutMix.value].
  static FlexLayoutMix? maybeValue(FlexLayoutSpec? spec) {
    return spec != null ? FlexLayoutMix.value(spec) : null;
  }

  // Chainable instance methods

  /// Returns a copy with the specified color.
  FlexLayoutMix color(Color value) {
    return merge(FlexLayoutMix.color(value));
  }

  /// Returns a copy with the specified decoration.
  FlexLayoutMix decoration(DecorationMix value) {
    return merge(FlexLayoutMix.decoration(value));
  }

  /// Returns a copy with the specified alignment.
  FlexLayoutMix alignment(AlignmentGeometry value) {
    return merge(FlexLayoutMix.alignment(value));
  }

  /// Returns a copy with the specified padding.
  FlexLayoutMix padding(EdgeInsetsGeometryMix value) {
    return merge(FlexLayoutMix.padding(value));
  }

  /// Returns a copy with the specified direction.
  FlexLayoutMix direction(Axis value) {
    return merge(FlexLayoutMix.direction(value));
  }

  /// Returns a copy with the specified gap.
  FlexLayoutMix gap(double value) {
    return merge(FlexLayoutMix.gap(value));
  }

  /// Returns a copy with the specified main axis alignment.
  FlexLayoutMix mainAxisAlignment(MainAxisAlignment value) {
    return merge(FlexLayoutMix(mainAxisAlignment: value));
  }

  /// Returns a copy with the specified cross axis alignment.
  FlexLayoutMix crossAxisAlignment(CrossAxisAlignment value) {
    return merge(FlexLayoutMix(crossAxisAlignment: value));
  }

  /// Returns a copy with the specified main axis size.
  FlexLayoutMix mainAxisSize(MainAxisSize value) {
    return merge(FlexLayoutMix(mainAxisSize: value));
  }

  /// Returns a copy with the specified vertical direction.
  FlexLayoutMix verticalDirection(VerticalDirection value) {
    return merge(FlexLayoutMix(verticalDirection: value));
  }

  /// Returns a copy with the specified text direction.
  FlexLayoutMix textDirection(TextDirection value) {
    return merge(FlexLayoutMix(textDirection: value));
  }

  /// Returns a copy with the specified text baseline.
  FlexLayoutMix textBaseline(TextBaseline value) {
    return merge(FlexLayoutMix(textBaseline: value));
  }

  /// Returns a copy with the specified spacing.
  FlexLayoutMix spacing(double value) {
    return merge(FlexLayoutMix(spacing: value));
  }

  /// Returns a copy with the specified clip behavior.
  FlexLayoutMix clipBehavior(Clip value) {
    return merge(FlexLayoutMix(clipBehavior: value));
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

  /// Merges the properties of this [FlexLayoutMix] with the properties of [other].
  @override
  FlexLayoutMix merge(FlexLayoutMix? other) {
    if (other == null) return this;

    return FlexLayoutMix.create(
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
