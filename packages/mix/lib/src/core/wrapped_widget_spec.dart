import 'package:flutter/foundation.dart';

import '../animation/animation_config.dart';
import 'helpers.dart';
import 'modifier.dart';
import 'spec.dart';
import 'widget_spec.dart';

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
/// final wrappedSpec = WrappedWidgetSpec(
///   spec: containerSpec,
///   animation: AnimationConfig.curve(),
/// );
/// ```
class WrappedWidgetSpec<T extends Spec<T>>
    extends WidgetSpec<WrappedWidgetSpec<T>> {
  /// The underlying specification that holds the actual data.
  final T spec;

  /// Creates a [WrappedWidgetSpec] with the provided spec and optional metadata.
  const WrappedWidgetSpec({
    required this.spec,
    super.animation,
    super.widgetModifiers,
    super.inherit,
  });

  /// Creates a copy of this [WrappedWidgetSpec] with the given fields
  /// replaced by the new values.
  @override
  WrappedWidgetSpec<T> copyWith({
    T? spec,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return WrappedWidgetSpec(
      spec: spec ?? this.spec,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  /// Linearly interpolates between this [WrappedWidgetSpec] and another.
  ///
  /// The interpolation is performed on:
  /// - The wrapped spec using its lerp method
  /// - Widget modifiers using standard lerp
  /// - Animation and inherit follow the standard policy (other?.field ?? this.field)
  @override
  WrappedWidgetSpec<T> lerp(WrappedWidgetSpec<T>? other, double t) {
    return WrappedWidgetSpec(
      spec: spec.lerp(other?.spec, t),
      animation: other?.animation ?? animation,
      widgetModifiers: MixOps.lerp(widgetModifiers, other?.widgetModifiers, t),
      inherit: other?.inherit ?? inherit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('spec', spec));
  }

  /// The list of properties that constitute the state of this [WrappedWidgetSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [WrappedWidgetSpec] instances for equality.
  @override
  List<Object?> get props => [...super.props, spec];
}
