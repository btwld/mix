import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import 'flex_spec.dart';
import 'flex_style.dart';

/// Mix class for configuring [FlexSpec] properties.
///
/// Encapsulates flex-specific styling properties for Row, Column, and Flex widgets
/// with support for proper Mix framework integration.
final class FlexMix extends Mix<FlexSpec> with Diagnosticable {
  final Prop<Axis>? $direction;
  final Prop<MainAxisAlignment>? $mainAxisAlignment;
  final Prop<CrossAxisAlignment>? $crossAxisAlignment;
  final Prop<MainAxisSize>? $mainAxisSize;
  final Prop<VerticalDirection>? $verticalDirection;
  final Prop<TextDirection>? $textDirection;
  final Prop<TextBaseline>? $textBaseline;
  final Prop<Clip>? $clipBehavior;
  final Prop<double>? $spacing;

  /// Main constructor with user-friendly types
  FlexMix({
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    Clip? clipBehavior,
    double? spacing,
  }) : this.create(
         direction: Prop.maybe(direction),
         mainAxisAlignment: Prop.maybe(mainAxisAlignment),
         crossAxisAlignment: Prop.maybe(crossAxisAlignment),
         mainAxisSize: Prop.maybe(mainAxisSize),
         verticalDirection: Prop.maybe(verticalDirection),
         textDirection: Prop.maybe(textDirection),
         textBaseline: Prop.maybe(textBaseline),
         clipBehavior: Prop.maybe(clipBehavior),
         spacing: Prop.maybe(spacing),
       );

  /// Create constructor with Prop`<T>` types for internal use
  const FlexMix.create({
    Prop<Axis>? direction,
    Prop<MainAxisAlignment>? mainAxisAlignment,
    Prop<CrossAxisAlignment>? crossAxisAlignment,
    Prop<MainAxisSize>? mainAxisSize,
    Prop<VerticalDirection>? verticalDirection,
    Prop<TextDirection>? textDirection,
    Prop<TextBaseline>? textBaseline,
    Prop<Clip>? clipBehavior,
    Prop<double>? spacing,
  }) : $direction = direction,
       $mainAxisAlignment = mainAxisAlignment,
       $crossAxisAlignment = crossAxisAlignment,
       $mainAxisSize = mainAxisSize,
       $verticalDirection = verticalDirection,
       $textDirection = textDirection,
       $textBaseline = textBaseline,
       $clipBehavior = clipBehavior,
       $spacing = spacing;

  // Factory constructors for common properties
  factory FlexMix.direction(Axis value) => FlexMix(direction: value);
  factory FlexMix.mainAxisAlignment(MainAxisAlignment value) => FlexMix(mainAxisAlignment: value);
  factory FlexMix.crossAxisAlignment(CrossAxisAlignment value) => FlexMix(crossAxisAlignment: value);
  factory FlexMix.mainAxisSize(MainAxisSize value) => FlexMix(mainAxisSize: value);
  factory FlexMix.verticalDirection(VerticalDirection value) => FlexMix(verticalDirection: value);
  factory FlexMix.textDirection(TextDirection value) => FlexMix(textDirection: value);
  factory FlexMix.textBaseline(TextBaseline value) => FlexMix(textBaseline: value);
  factory FlexMix.clipBehavior(Clip value) => FlexMix(clipBehavior: value);
  factory FlexMix.spacing(double value) => FlexMix(spacing: value);

  /// Factory constructor to create FlexMix from FlexSpec.
  static FlexMix value(FlexSpec spec) {
    return FlexMix.create(
      direction: Prop.maybe(spec.direction),
      mainAxisAlignment: Prop.maybe(spec.mainAxisAlignment),
      crossAxisAlignment: Prop.maybe(spec.crossAxisAlignment),
      mainAxisSize: Prop.maybe(spec.mainAxisSize),
      verticalDirection: Prop.maybe(spec.verticalDirection),
      textDirection: Prop.maybe(spec.textDirection),
      textBaseline: Prop.maybe(spec.textBaseline),
      clipBehavior: Prop.maybe(spec.clipBehavior),
      spacing: Prop.maybe(spec.spacing),
    );
  }

  /// Factory constructor to create FlexMix from nullable FlexSpec.
  static FlexMix? maybeValue(FlexSpec? spec) {
    return spec != null ? FlexMix.value(spec) : null;
  }

  @override
  FlexSpec resolve(BuildContext context) {
    return FlexSpec(
      direction: MixOps.resolve(context, $direction),
      mainAxisAlignment: MixOps.resolve(context, $mainAxisAlignment),
      crossAxisAlignment: MixOps.resolve(context, $crossAxisAlignment),
      mainAxisSize: MixOps.resolve(context, $mainAxisSize),
      verticalDirection: MixOps.resolve(context, $verticalDirection),
      textDirection: MixOps.resolve(context, $textDirection),
      textBaseline: MixOps.resolve(context, $textBaseline),
      clipBehavior: MixOps.resolve(context, $clipBehavior),
      spacing: MixOps.resolve(context, $spacing),
    );
  }

  @override
  FlexMix merge(FlexMix? other) {
    if (other == null) return this;

    return FlexMix.create(
      direction: MixOps.merge($direction, other.$direction),
      mainAxisAlignment: MixOps.merge($mainAxisAlignment, other.$mainAxisAlignment),
      crossAxisAlignment: MixOps.merge($crossAxisAlignment, other.$crossAxisAlignment),
      mainAxisSize: MixOps.merge($mainAxisSize, other.$mainAxisSize),
      verticalDirection: MixOps.merge($verticalDirection, other.$verticalDirection),
      textDirection: MixOps.merge($textDirection, other.$textDirection),
      textBaseline: MixOps.merge($textBaseline, other.$textBaseline),
      clipBehavior: MixOps.merge($clipBehavior, other.$clipBehavior),
      spacing: MixOps.merge($spacing, other.$spacing),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('direction', $direction))
      ..add(DiagnosticsProperty('mainAxisAlignment', $mainAxisAlignment))
      ..add(DiagnosticsProperty('crossAxisAlignment', $crossAxisAlignment))
      ..add(DiagnosticsProperty('mainAxisSize', $mainAxisSize))
      ..add(DiagnosticsProperty('verticalDirection', $verticalDirection))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('textBaseline', $textBaseline))
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior))
      ..add(DiagnosticsProperty('spacing', $spacing));
  }

  @override
  List<Object?> get props => [
    $direction,
    $mainAxisAlignment,
    $crossAxisAlignment,
    $mainAxisSize,
    $verticalDirection,
    $textDirection,
    $textBaseline,
    $clipBehavior,
    $spacing,
  ];
}

extension FlexMixToStyle on FlexMix {
  /// Converts this FlexMix to a FlexStyle
  FlexStyle toStyle() => FlexStyle.from(this);
}