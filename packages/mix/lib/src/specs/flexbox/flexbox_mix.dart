import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
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
import '../box/box_spec.dart';
import '../flex/flex_mix.dart';
import '../flex/flex_spec.dart';
import 'flexbox_spec.dart';
import 'flexbox_style.dart';

/// Mix class for configuring [FlexBoxSpec] properties using composition.
///
/// Combines BoxMix (box properties) and FlexMix (flex layout properties)
/// in a unified Mix class, providing clean separation of concerns while maintaining
/// the full feature set for flex box styling.
final class FlexBoxMix extends Mix<FlexBoxSpec>
    with
        DecorationMixin<FlexBoxMix>,
        SpacingMixin<FlexBoxMix>,
        ConstraintsMixin<FlexBoxMix>,
        TransformMixin<FlexBoxMix>,
        BorderRadiusMixin<FlexBoxMix>,
        Diagnosticable {
  final Prop<BoxSpec>? $box;
  final Prop<FlexSpec>? $flex;

  /// Main constructor with Mix composition
  FlexBoxMix({
    // Box properties
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
    Clip? flexClipBehavior,
    double? spacing,
  }) : this.create(
         box: Prop.maybeMix(
           BoxMix(
             decoration: decoration,
             foregroundDecoration: foregroundDecoration,
             padding: padding,
             margin: margin,
             alignment: alignment,
             constraints: constraints,
             transform: transform,
             transformAlignment: transformAlignment,
             clipBehavior: clipBehavior,
           ),
         ),
         flex: Prop.maybeMix(
           FlexMix(
             direction: direction,
             mainAxisAlignment: mainAxisAlignment,
             crossAxisAlignment: crossAxisAlignment,
             mainAxisSize: mainAxisSize,
             verticalDirection: verticalDirection,
             textDirection: textDirection,
             textBaseline: textBaseline,
             clipBehavior: flexClipBehavior,
             spacing: spacing,
           ),
         ),
       );

  /// Create constructor with Prop`<T>` types for internal use
  const FlexBoxMix.create({Prop<BoxSpec>? box, Prop<FlexSpec>? flex})
    : $box = box,
      $flex = flex;

  /// Factory constructor to create FlexBoxMix from FlexBoxSpec.
  static FlexBoxMix value(FlexBoxSpec spec) {
    return FlexBoxMix.create(
      box: Prop.maybeMix(BoxMix.maybeValue(spec.box)),
      flex: Prop.maybeMix(FlexMix.maybeValue(spec.flex)),
    );
  }

  /// Factory constructor to create FlexBoxMix from nullable FlexBoxSpec.
  static FlexBoxMix? maybeValue(FlexBoxSpec? spec) {
    return spec != null ? FlexBoxMix.value(spec) : null;
  }

  // Chainable instance methods (consistent with BoxMix pattern)

  // Container/Box instance methods (from BoxMix)
  FlexBoxMix alignment(AlignmentGeometry value) {
    return merge(FlexBoxMix(alignment: value));
  }

  FlexBoxMix foregroundDecoration(DecorationMix value) {
    return merge(FlexBoxMix(foregroundDecoration: value));
  }

  FlexBoxMix transformAlignment(AlignmentGeometry value) {
    return merge(FlexBoxMix(transformAlignment: value));
  }

  FlexBoxMix clipBehavior(Clip value) {
    return merge(FlexBoxMix(clipBehavior: value));
  }

  @override
  FlexBoxMix borderRadius(BorderRadiusGeometryMix value) {
    return merge(FlexBoxMix(decoration: DecorationMix.borderRadius(value)));
  }

  @override
  FlexBoxMix padding(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxMix(padding: value));
  }

  @override
  FlexBoxMix margin(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxMix(margin: value));
  }

  @override
  FlexBoxMix transform(Matrix4 value) {
    return merge(FlexBoxMix(transform: value));
  }

  @override
  FlexBoxMix constraints(BoxConstraintsMix value) {
    return merge(FlexBoxMix(constraints: value));
  }

  @override
  FlexBoxMix decoration(DecorationMix value) {
    return merge(FlexBoxMix(decoration: value));
  }

  @override
  FlexBoxSpec resolve(BuildContext context) {
    return FlexBoxSpec(
      box: MixOps.resolve(context, $box),
      flex: MixOps.resolve(context, $flex),
    );
  }

  @override
  FlexBoxMix merge(FlexBoxMix? other) {
    if (other == null) return this;

    return FlexBoxMix.create(
      box: MixOps.merge($box, other.$box),
      flex: MixOps.merge($flex, other.$flex),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('box', $box))
      ..add(DiagnosticsProperty('flex', $flex));
  }

  @override
  List<Object?> get props => [$box, $flex];
}

extension FlexBoxMixToStyle on FlexBoxMix {
  /// Converts this FlexBoxMix to a FlexBoxStyle
  FlexBoxStyle toStyle() => FlexBoxStyle.from(this);
}
