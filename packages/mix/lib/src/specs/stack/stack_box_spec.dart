import 'package:flutter/foundation.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/modifier.dart';
import '../../core/widget_spec.dart';
import '../box/box_spec.dart';
import 'stack_spec.dart';

final class ZBoxWidgetSpec extends WidgetSpec<ZBoxWidgetSpec> {
  final BoxSpec box;
  final StackSpec stack;

  const ZBoxWidgetSpec({
    BoxSpec? box,
    StackSpec? stack,
    super.animation,
    super.widgetModifiers,
    super.inherit,
  }) : box = box ?? const BoxSpec(),
       stack = stack ?? const StackSpec();

  /// Creates a copy of this [ZBoxWidgetSpec] but with the given fields
  /// replaced with the new values.
  @override
  ZBoxWidgetSpec copyWith({
    BoxSpec? box,
    StackSpec? stack,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return ZBoxWidgetSpec(
      box: box ?? this.box,
      stack: stack ?? this.stack,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  /// Linearly interpolates between this [ZBoxWidgetSpec] and another [ZBoxWidgetSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ZBoxWidgetSpec] is returned. When [t] is 1.0, the [other] [ZBoxWidgetSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ZBoxWidgetSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ZBoxWidgetSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ZBoxWidgetSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [box].
  /// - [StackSpec.lerp] for [stack].
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ZBoxWidgetSpec] configurations.
  @override
  ZBoxWidgetSpec lerp(ZBoxWidgetSpec? other, double t) {
    // Create new BoxSpec and StackSpec WITHOUT their metadata
    // The metadata is handled at ZBoxSpec level
    final lerpedBox = box
        .lerp(other?.box, t)
        .copyWith(animation: null, widgetModifiers: null, inherit: null);
    final lerpedStack = stack
        .lerp(other?.stack, t)
        .copyWith(animation: null, widgetModifiers: null, inherit: null);

    return ZBoxWidgetSpec(
      box: lerpedBox,
      stack: lerpedStack,
      // Meta fields: use confirmed policy other.field ?? this.field
      animation: other?.animation ?? animation,
      widgetModifiers: MixOps.lerp(widgetModifiers, other?.widgetModifiers, t),
      inherit: other?.inherit ?? inherit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('box', box, defaultValue: const BoxSpec()))
      ..add(
        DiagnosticsProperty('stack', stack, defaultValue: const StackSpec()),
      );
  }

  /// The list of properties that constitute the state of this [ZBoxWidgetSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ZBoxWidgetSpec] instances for equality.
  @override
  List<Object?> get props => [...super.props, box, stack];
}
