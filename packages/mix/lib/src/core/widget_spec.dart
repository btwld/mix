import 'package:flutter/foundation.dart';

import '../animation/animation_config.dart';
import 'helpers.dart';
import 'modifier.dart';
import 'spec.dart';

/// A widget specification that wraps a pure Spec with widget metadata.
///
/// This class provides a way to add widget-level metadata (animation, modifiers, inherit)
/// to any Spec without requiring the Spec to extend WidgetSpec directly.
/// This promotes clean separation between data specs and widget metadata.
///
/// Example:
/// ```dart
/// // Pure data spec
/// final containerSpec = ContainerSpec(padding: EdgeInsets.all(16));
///
/// // Wrapped with metadata
/// final wrappedSpec = WidgetSpec(
///   spec: containerSpec,
///   animation: AnimationConfig.curve(),
/// );
/// ```
class WidgetSpec<T extends Spec<T>> extends Spec<WidgetSpec<T>>
    with Diagnosticable {
  /// The underlying specification that holds the actual data.
  final T spec;

  /// Optional animation configuration attached to this spec.
  final AnimationConfig? animation;

  /// Widget-level modifiers to apply around the built widget.
  final List<Modifier>? widgetModifiers;

  /// Whether this spec should inherit styles from ancestors.
  final bool? inherit;

  /// Creates a [WidgetSpec] with the provided spec and optional metadata.
  const WidgetSpec({
    required this.spec,
    this.animation,
    this.widgetModifiers,
    this.inherit,
  });

  /// Creates a copy of this [WidgetSpec] with the given fields
  /// replaced by the new values.
  @override
  WidgetSpec<T> copyWith({
    T? spec,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return WidgetSpec(
      spec: spec ?? this.spec,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  /// Linearly interpolates between this [WidgetSpec] and another.
  ///
  /// The interpolation is performed on:
  /// - The wrapped spec using its lerp method
  /// - Widget modifiers using standard lerp
  /// - Animation and inherit follow the standard policy (other?.field ?? this.field)
  @override
  WidgetSpec<T> lerp(WidgetSpec<T>? other, double t) {
    return WidgetSpec(
      spec: spec.lerp(other?.spec, t),
      animation: other?.animation ?? animation,
      widgetModifiers: MixOps.lerp(widgetModifiers, other?.widgetModifiers, t),
      inherit: other?.inherit ?? inherit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('animation', animation))
      ..add(IterableProperty<Modifier>('widgetModifiers', widgetModifiers))
      ..add(FlagProperty('inherit', value: inherit, ifTrue: 'inherits styles'))
      ..add(DiagnosticsProperty<T>('spec', spec));
  }

  /// The list of properties that constitute the state of this [WidgetSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [WidgetSpec] instances for equality.
  @override
  List<Object?> get props => [animation, widgetModifiers, inherit, spec];
}
