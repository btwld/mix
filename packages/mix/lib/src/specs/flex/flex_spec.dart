import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/modifier.dart';
import '../../core/widget_spec.dart';

/// Defines the styling for a Flex widget.
///
/// This class provides configuration for flex-specific properties such as
/// direction, alignment, and spacing through the Mix framework.
@immutable
final class FlexSpec extends WidgetSpec<FlexSpec> {
  /// The direction to use as the main axis.
  final Axis? direction;

  /// How the children should be placed along the main axis.
  final MainAxisAlignment? mainAxisAlignment;

  /// How the children should be placed along the cross axis.
  final CrossAxisAlignment? crossAxisAlignment;

  /// How much space should be occupied in the main axis.
  final MainAxisSize? mainAxisSize;

  /// Determines the order to lay children out vertically.
  final VerticalDirection? verticalDirection;

  /// Determines the order to lay children out horizontally.
  final TextDirection? textDirection;

  /// A baseline to use for aligning items.
  final TextBaseline? textBaseline;

  /// The content will be clipped (or not) according to this option.
  final Clip? clipBehavior;

  /// The spacing between children.
  final double? spacing;

  /// The gap between children.
  @Deprecated(
    'Use spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  final double? gap;

  /// Creates a [FlexSpec] with the provided properties.
  const FlexSpec({
    this.direction,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.mainAxisSize,
    this.verticalDirection,
    this.textDirection,
    this.textBaseline,
    this.clipBehavior,
    this.spacing,
    @Deprecated(
      'Use spacing instead. '
      'This feature was deprecated after Mix v2.0.0.',
    )
    double? gap,
    super.animation,
    super.widgetModifiers,
    super.inherit,
  }) : gap = gap ?? spacing;


  /// Creates a copy of this [FlexSpec] with the given properties replaced.
  @override
  FlexSpec copyWith({
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    Clip? clipBehavior,
    double? spacing,
    @Deprecated(
      'Use spacing instead. '
      'This feature was deprecated after Mix v2.0.0.',
    )
    double? gap,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return FlexSpec(
      direction: direction ?? this.direction,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      mainAxisSize: mainAxisSize ?? this.mainAxisSize,
      verticalDirection: verticalDirection ?? this.verticalDirection,
      textDirection: textDirection ?? this.textDirection,
      textBaseline: textBaseline ?? this.textBaseline,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      spacing: spacing ?? gap ?? this.spacing,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  /// Linearly interpolates between this [FlexSpec] and another [FlexSpec].
  @override
  FlexSpec lerp(FlexSpec? other, double t) {
    return FlexSpec(
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
      clipBehavior: MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t),
      spacing: MixOps.lerp(spacing, other?.spacing, t),
      // Meta fields: use confirmed policy other.field ?? this.field
      animation: other?.animation ?? animation,
      widgetModifiers: other?.widgetModifiers ?? widgetModifiers,
      inherit: other?.inherit ?? inherit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<Axis>('direction', direction))
      ..add(EnumProperty<MainAxisAlignment>('mainAxisAlignment', mainAxisAlignment))
      ..add(EnumProperty<CrossAxisAlignment>('crossAxisAlignment', crossAxisAlignment))
      ..add(EnumProperty<MainAxisSize>('mainAxisSize', mainAxisSize))
      ..add(EnumProperty<VerticalDirection>('verticalDirection', verticalDirection))
      ..add(EnumProperty<TextDirection>('textDirection', textDirection))
      ..add(EnumProperty<TextBaseline>('textBaseline', textBaseline))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior))
      ..add(DoubleProperty('spacing', spacing));
    if (gap != null && gap != spacing) {
      properties.add(DoubleProperty('gap (deprecated)', gap));
    }
  }

  @override
  List<Object?> get props => [
    ...super.props,
    direction,
    mainAxisAlignment,
    crossAxisAlignment,
    mainAxisSize,
    verticalDirection,
    textDirection,
    textBaseline,
    clipBehavior,
    spacing,
  ];
}
