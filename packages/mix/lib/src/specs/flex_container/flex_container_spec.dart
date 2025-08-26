import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/helpers.dart';
import '../../core/spec.dart';

/// A unified specification combining container and flex layout properties.
///
/// This spec provides combined container styling and flex layout values
/// that can be applied to create flexible layouts with decoration capabilities.
/// It merges properties from both ContainerSpec and FlexLayoutSpec into a
/// single flat structure for simplified usage.
final class FlexContainerSpec extends Spec<FlexContainerSpec>
    with Diagnosticable {
  // Container properties
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip? clipBehavior;

  // Flex layout properties
  final Axis? direction;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final VerticalDirection? verticalDirection;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final double? spacing;

  const FlexContainerSpec({
    // Container properties
    this.decoration,
    this.foregroundDecoration,
    this.padding,
    this.margin,
    this.alignment,
    this.constraints,
    this.transform,
    this.transformAlignment,
    this.clipBehavior,
    // Flex properties
    this.direction,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.mainAxisSize,
    this.verticalDirection,
    this.textDirection,
    this.textBaseline,
    this.spacing,
  });

  @override
  FlexContainerSpec copyWith({
    Decoration? decoration,
    Decoration? foregroundDecoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
    BoxConstraints? constraints,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    double? spacing,
  }) {
    return FlexContainerSpec(
      decoration: decoration ?? this.decoration,
      foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      alignment: alignment ?? this.alignment,
      constraints: constraints ?? this.constraints,
      transform: transform ?? this.transform,
      transformAlignment: transformAlignment ?? this.transformAlignment,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      direction: direction ?? this.direction,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      mainAxisSize: mainAxisSize ?? this.mainAxisSize,
      verticalDirection: verticalDirection ?? this.verticalDirection,
      textDirection: textDirection ?? this.textDirection,
      textBaseline: textBaseline ?? this.textBaseline,
      spacing: spacing ?? this.spacing,
    );
  }

  @override
  FlexContainerSpec lerp(FlexContainerSpec? other, double t) {
    return FlexContainerSpec(
      decoration: MixOps.lerp(decoration, other?.decoration, t),
      foregroundDecoration: MixOps.lerp(
        foregroundDecoration,
        other?.foregroundDecoration,
        t,
      ),
      padding: MixOps.lerp(padding, other?.padding, t),
      margin: MixOps.lerp(margin, other?.margin, t),
      alignment: MixOps.lerp(alignment, other?.alignment, t),
      constraints: MixOps.lerp(constraints, other?.constraints, t),
      transform: MixOps.lerp(transform, other?.transform, t),
      transformAlignment: MixOps.lerp(
        transformAlignment,
        other?.transformAlignment,
        t,
      ),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t),
      direction: MixOps.lerpSnap(direction, other?.direction, t),
      mainAxisAlignment: MixOps.lerpSnap(
        mainAxisAlignment,
        other?.mainAxisAlignment,
        t,
      ),
      crossAxisAlignment: MixOps.lerpSnap(
        crossAxisAlignment,
        other?.crossAxisAlignment,
        t,
      ),
      mainAxisSize: MixOps.lerpSnap(mainAxisSize, other?.mainAxisSize, t),
      verticalDirection: MixOps.lerpSnap(
        verticalDirection,
        other?.verticalDirection,
        t,
      ),
      textDirection: MixOps.lerpSnap(textDirection, other?.textDirection, t),
      textBaseline: MixOps.lerpSnap(textBaseline, other?.textBaseline, t),
      spacing: MixOps.lerp(spacing, other?.spacing, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      // Container properties
      ..add(DiagnosticsProperty('decoration', decoration))
      ..add(DiagnosticsProperty('foregroundDecoration', foregroundDecoration))
      ..add(DiagnosticsProperty('padding', padding))
      ..add(DiagnosticsProperty('margin', margin))
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(DiagnosticsProperty('constraints', constraints))
      ..add(DiagnosticsProperty('transform', transform))
      ..add(DiagnosticsProperty('transformAlignment', transformAlignment))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior))
      // Flex properties
      ..add(EnumProperty<Axis>('direction', direction))
      ..add(
        EnumProperty<MainAxisAlignment>('mainAxisAlignment', mainAxisAlignment),
      )
      ..add(
        EnumProperty<CrossAxisAlignment>(
          'crossAxisAlignment',
          crossAxisAlignment,
        ),
      )
      ..add(EnumProperty<MainAxisSize>('mainAxisSize', mainAxisSize))
      ..add(
        EnumProperty<VerticalDirection>('verticalDirection', verticalDirection),
      )
      ..add(EnumProperty<TextDirection>('textDirection', textDirection))
      ..add(EnumProperty<TextBaseline>('textBaseline', textBaseline))
      ..add(DoubleProperty('spacing', spacing));
  }

  @override
  List<Object?> get props => [
    decoration,
    foregroundDecoration,
    padding,
    margin,
    alignment,
    constraints,
    transform,
    transformAlignment,
    clipBehavior,
    direction,
    mainAxisAlignment,
    crossAxisAlignment,
    mainAxisSize,
    verticalDirection,
    textDirection,
    textBaseline,
    spacing,
  ];
}

/// Extension to convert [FlexContainerSpec] directly to a widget.
extension FlexContainerSpecX on FlexContainerSpec {
  /// Builds a widget that combines container and flex properties.
  ///
  /// Creates a Container with Flex as child, applying container properties
  /// to the outer container and flex properties to the inner flex widget.
  Widget call({required Axis direction, List<Widget> children = const []}) {
    final resolvedDirection = this.direction ?? direction;
    final effectiveSpacing = spacing ?? 0.0;

    // Handle spacing by interleaving SizedBox widgets
    List<Widget> childrenWithGaps = children;
    if (effectiveSpacing > 0 && children.length > 1) {
      childrenWithGaps = [];
      for (int i = 0; i < children.length; i++) {
        childrenWithGaps.add(children[i]);
        if (i < children.length - 1) {
          childrenWithGaps.add(
            SizedBox(
              width: resolvedDirection == Axis.horizontal
                  ? effectiveSpacing
                  : null,
              height: resolvedDirection == Axis.vertical
                  ? effectiveSpacing
                  : null,
            ),
          );
        }
      }
    }

    final flex = Flex(
      direction: resolvedDirection,
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      mainAxisSize: mainAxisSize ?? MainAxisSize.max,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      textDirection: textDirection,
      verticalDirection: verticalDirection ?? VerticalDirection.down,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior ?? Clip.none,
      children: childrenWithGaps,
    );

    return Container(
      alignment: alignment,
      padding: padding,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior ?? Clip.none,
      child: flex,
    );
  }
}
