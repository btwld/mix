import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/mix_element.dart';
import '../../properties/layout/constraints_mix.dart';
import '../../properties/layout/constraints_mixin.dart';
import '../../properties/layout/edge_insets_geometry_mix.dart';
import '../../properties/layout/spacing_mixin.dart';
import '../../properties/painting/border_radius_mix.dart';
import '../../properties/painting/border_radius_util.dart';
import '../../properties/painting/decoration_mix.dart';
import '../../properties/painting/decoration_mixin.dart';
import '../../properties/transform_mixin.dart';
import '../box/box_mix.dart';
import '../flex/flex_mix.dart';
import 'flexbox_spec.dart';
import 'flexbox_style.dart';

/// Mix class for configuring [FlexBoxSpec] properties using composition.
///
/// Combines BoxMix (container properties) and FlexMix (flex layout properties)
/// in a unified Mix class, providing clean separation of concerns while maintaining
/// the full feature set for flex container styling.
final class FlexBoxMix extends Mix<FlexBoxSpec>
    with
        DecorationMixin<FlexBoxMix>,
        SpacingMixin<FlexBoxMix>,
        ConstraintsMixin<FlexBoxMix>,
        TransformMixin<FlexBoxMix>,
        BorderRadiusMixin<FlexBoxMix>,
        Diagnosticable {
  final BoxMix? container;
  final FlexMix? flex;

  /// Main constructor with Mix composition
  const FlexBoxMix({this.container, this.flex});

  // Container properties delegation
  factory FlexBoxMix.color(Color value) {
    return FlexBoxMix(container: BoxMix.color(value));
  }

  factory FlexBoxMix.decoration(DecorationMix value) {
    return FlexBoxMix(container: BoxMix.decoration(value));
  }

  factory FlexBoxMix.foregroundDecoration(DecorationMix value) {
    return FlexBoxMix(container: BoxMix.foregroundDecoration(value));
  }

  factory FlexBoxMix.alignment(AlignmentGeometry value) {
    return FlexBoxMix(container: BoxMix.alignment(value));
  }

  factory FlexBoxMix.padding(EdgeInsetsGeometryMix value) {
    return FlexBoxMix(container: BoxMix.padding(value));
  }

  factory FlexBoxMix.margin(EdgeInsetsGeometryMix value) {
    return FlexBoxMix(container: BoxMix.margin(value));
  }

  factory FlexBoxMix.transform(Matrix4 value) {
    return FlexBoxMix(container: BoxMix.transform(value));
  }

  factory FlexBoxMix.transformAlignment(AlignmentGeometry value) {
    return FlexBoxMix(container: BoxMix.transformAlignment(value));
  }

  factory FlexBoxMix.clipBehavior(Clip value) {
    return FlexBoxMix(container: BoxMix.clipBehavior(value));
  }

  factory FlexBoxMix.constraints(BoxConstraintsMix value) {
    return FlexBoxMix(container: BoxMix.constraints(value));
  }

  factory FlexBoxMix.width(double value) {
    return FlexBoxMix(
      container: BoxMix(constraints: BoxConstraintsMix.width(value)),
    );
  }

  factory FlexBoxMix.height(double value) {
    return FlexBoxMix(
      container: BoxMix(constraints: BoxConstraintsMix.height(value)),
    );
  }

  // Flex properties delegation
  factory FlexBoxMix.direction(Axis value) {
    return FlexBoxMix(flex: FlexMix.direction(value));
  }

  factory FlexBoxMix.mainAxisAlignment(MainAxisAlignment value) {
    return FlexBoxMix(flex: FlexMix.mainAxisAlignment(value));
  }

  factory FlexBoxMix.crossAxisAlignment(CrossAxisAlignment value) {
    return FlexBoxMix(flex: FlexMix.crossAxisAlignment(value));
  }

  factory FlexBoxMix.mainAxisSize(MainAxisSize value) {
    return FlexBoxMix(flex: FlexMix.mainAxisSize(value));
  }

  factory FlexBoxMix.verticalDirection(VerticalDirection value) {
    return FlexBoxMix(flex: FlexMix.verticalDirection(value));
  }

  factory FlexBoxMix.textDirection(TextDirection value) {
    return FlexBoxMix(flex: FlexMix.textDirection(value));
  }

  factory FlexBoxMix.textBaseline(TextBaseline value) {
    return FlexBoxMix(flex: FlexMix.textBaseline(value));
  }

  factory FlexBoxMix.clipBehaviorFlex(Clip value) {
    return FlexBoxMix(flex: FlexMix.clipBehavior(value));
  }

  factory FlexBoxMix.spacing(double value) {
    return FlexBoxMix(flex: FlexMix.spacing(value));
  }

  // Convenience flex layout factories
  factory FlexBoxMix.horizontal({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? spacing,
  }) {
    return FlexBoxMix(
      flex: FlexMix(
        direction: Axis.horizontal,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        spacing: spacing,
      ),
    );
  }

  factory FlexBoxMix.vertical({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? spacing,
  }) {
    return FlexBoxMix(
      flex: FlexMix(
        direction: Axis.vertical,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        spacing: spacing,
      ),
    );
  }

  factory FlexBoxMix.row({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? spacing,
  }) {
    return FlexBoxMix.horizontal(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      spacing: spacing,
    );
  }

  factory FlexBoxMix.column({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? spacing,
  }) {
    return FlexBoxMix.vertical(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      spacing: spacing,
    );
  }

  /// Factory constructor to create FlexBoxMix from FlexBoxSpec.
  static FlexBoxMix value(FlexBoxSpec spec) {
    return FlexBoxMix(
      container: spec.container != null ? BoxMix.value(spec.container!) : null,
      flex: spec.flex != null ? FlexMix.value(spec.flex!) : null,
    );
  }

  /// Factory constructor to create FlexBoxMix from nullable FlexBoxSpec.
  static FlexBoxMix? maybeValue(FlexBoxSpec? spec) {
    return spec != null ? FlexBoxMix.value(spec) : null;
  }

  // Chainable instance methods (consistent with BoxMix pattern)

  // Container/Box instance methods (from BoxMix)
  FlexBoxMix alignment(AlignmentGeometry value) {
    return merge(FlexBoxMix.alignment(value));
  }

  FlexBoxMix foregroundDecoration(DecorationMix value) {
    return merge(FlexBoxMix.foregroundDecoration(value));
  }

  FlexBoxMix transformAlignment(AlignmentGeometry value) {
    return merge(FlexBoxMix.transformAlignment(value));
  }

  FlexBoxMix clipBehavior(Clip value) {
    return merge(FlexBoxMix.clipBehavior(value));
  }

  @override
  FlexBoxMix borderRadius(BorderRadiusGeometryMix value) {
    return merge(FlexBoxMix(container: BoxMix.borderRadius(value)));
  }

  @override
  FlexBoxMix padding(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxMix.padding(value));
  }

  @override
  FlexBoxMix margin(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxMix.margin(value));
  }

  @override
  FlexBoxMix transform(Matrix4 value) {
    return merge(FlexBoxMix.transform(value));
  }

  @override
  FlexBoxMix constraints(BoxConstraintsMix value) {
    return merge(FlexBoxMix.constraints(value));
  }

  @override
  FlexBoxMix decoration(DecorationMix value) {
    return merge(FlexBoxMix.decoration(value));
  }

  @override
  FlexBoxSpec resolve(BuildContext context) {
    return FlexBoxSpec(
      container: container?.resolve(context),
      flex: flex?.resolve(context),
    );
  }

  @override
  FlexBoxMix merge(FlexBoxMix? other) {
    if (other == null) return this;

    return FlexBoxMix(
      container: container?.merge(other.container) ?? other.container,
      flex: flex?.merge(other.flex) ?? other.flex,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('flex', flex));
  }

  @override
  List<Object?> get props => [container, flex];
}

extension FlexBoxMixToStyle on FlexBoxMix {
  /// Converts this FlexBoxMix to a FlexBoxStyle
  FlexBoxStyle toStyle() => FlexBoxStyle.from(this);
}

/// Legacy alias for FlexBoxMix to maintain backward compatibility.
/// @deprecated Use FlexBoxMix directly instead.
typedef FlexContainerMix = FlexBoxMix;
