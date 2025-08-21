import 'package:flutter/foundation.dart';

import '../../animation/animation_config.dart';
import '../../core/modifier.dart';
import '../../core/widget_spec.dart';
import '../box/box_spec.dart';
import '../flex/flex_spec.dart';

/// Specification that combines box styling and flex layout properties.
///
/// Provides comprehensive styling for container widgets that need both
/// box decoration and flex layout capabilities. Merges [BoxSpec] and
/// [FlexSpec] into a unified specification.
final class FlexBoxSpec extends WidgetSpec<FlexBoxSpec> {
  /// Box styling properties for decoration, padding, constraints, etc.
  final BoxSpec box;
  
  /// Flex layout properties for direction, alignment, spacing, etc.
  final FlexSpec flex;

  const FlexBoxSpec({
    BoxSpec? box,
    FlexSpec? flex,
    super.animation,
    super.widgetModifiers,
    super.inherit,
  }) : box = box ?? const BoxSpec(),
       flex = flex ?? const FlexSpec();


  /// Creates a copy of this [FlexBoxSpec] but with the given fields
  /// replaced with the new values.
  @override
  FlexBoxSpec copyWith({
    BoxSpec? box,
    FlexSpec? flex,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return FlexBoxSpec(
      box: box ?? this.box,
      flex: flex ?? this.flex,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  /// Linearly interpolates between this [FlexBoxSpec] and another [FlexBoxSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [FlexBoxSpec] is returned. When [t] is 1.0, the [other] [FlexBoxSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [FlexBoxSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [FlexBoxSpec] instance.
  ///
  /// The interpolation is performed on each property of the [FlexBoxSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [box].
  /// - [FlexSpec.lerp] for [flex].
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [FlexBoxSpec] configurations.
  @override
  FlexBoxSpec lerp(FlexBoxSpec? other, double t) {
    // Create new BoxSpec and FlexSpec WITHOUT their metadata
    // The metadata is handled at FlexBoxSpec level
    final lerpedBox = box.lerp(other?.box, t).copyWith(
      animation: null,
      widgetModifiers: null,
      inherit: null,
    );
    final lerpedFlex = flex.lerp(other?.flex, t).copyWith(
      animation: null,
      widgetModifiers: null,
      inherit: null,
    );

    return FlexBoxSpec(
      box: lerpedBox,
      flex: lerpedFlex,
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
      ..add(DiagnosticsProperty('box', box, defaultValue: const BoxSpec()))
      ..add(DiagnosticsProperty('flex', flex, defaultValue: const FlexSpec()));
  }

  /// The list of properties that constitute the state of this [FlexBoxSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexBoxSpec] instances for equality.
  @override
  List<Object?> get props => [...super.props, box, flex];
}
