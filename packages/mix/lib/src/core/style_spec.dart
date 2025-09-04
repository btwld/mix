import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation_config.dart';
import 'helpers.dart';
import 'modifier.dart';
import 'spec.dart';
import 'style_builder.dart';

/// A widget specification that wraps a pure Spec with widget metadata.
///
/// This class provides a way to add widget-level metadata (animation, modifiers)
/// to any Spec without requiring the Spec to extend StyleSpec directly.
/// This promotes clean separation between data specs and widget metadata.
///
/// Example:
/// ```dart
/// // Pure data spec
/// final boxSpec = BoxSpec(padding: EdgeInsets.all(16));
///
/// // Wrapped with metadata
/// final wrappedSpec = StyleSpec(
///   spec: boxSpec,
///   animation: AnimationConfig.curve(),
/// );
/// ```
class StyleSpec<T extends Spec<T>> extends Spec<StyleSpec<T>>
    with Diagnosticable {
  /// The underlying specification that holds the actual data.
  final T spec;

  /// Optional animation configuration attached to this spec.
  final AnimationConfig? animation;

  /// Widget-level modifiers to apply around the built widget.
  final List<Modifier>? widgetModifiers;

  /// Creates a [StyleSpec] with the provided spec and optional metadata.
  const StyleSpec({required this.spec, this.animation, this.widgetModifiers});

  /// Creates a copy of this [StyleSpec] with the given fields
  /// replaced by the new values.
  @override
  StyleSpec<T> copyWith({
    T? spec,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
  }) {
    return StyleSpec(
      spec: spec ?? this.spec,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
    );
  }

  /// Linearly interpolates between this [StyleSpec] and another.
  ///
  /// The interpolation is performed on:
  /// - The wrapped spec using its lerp method
  /// - Widget modifiers using standard lerp
  /// - Animation follows the standard policy (other?.field ?? this.field)
  @override
  StyleSpec<T> lerp(StyleSpec<T>? other, double t) {
    return StyleSpec(
      spec: spec.lerp(other?.spec, t),
      animation: other?.animation ?? animation,
      widgetModifiers: MixOps.lerp(widgetModifiers, other?.widgetModifiers, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('animation', animation))
      ..add(IterableProperty<Modifier>('widgetModifiers', widgetModifiers))
      ..add(DiagnosticsProperty<T>('spec', spec));
  }

  /// The list of properties that constitute the state of this [StyleSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [StyleSpec] instances for equality.
  @override
  List<Object?> get props => [animation, widgetModifiers, spec];
}

/// Extension to create widgets from [StyleSpec] using custom builder functions.
extension StyleSpecWidgetBuilder<T extends Spec<T>> on StyleSpec<T> {
  /// Creates a widget using a custom builder function that receives the resolved spec.
  ///
  /// The [builder] function receives the BuildContext and the resolved spec instance,
  /// allowing custom widget creation logic while still benefiting from context-aware
  /// resolution provided by StyleSpecBuilder.
  ///
  /// Example:
  /// ```dart
  /// styleSpec.createBuilder((context, spec) {
  ///   return Container(
  ///     color: spec.color,
  ///     padding: spec.padding,
  ///   );
  /// });
  /// ```
  Widget createBuilder(Widget Function(BuildContext context, T spec) builder) {
    return StyleSpecBuilder<T>(builder: builder, styleSpec: this);
  }
}
