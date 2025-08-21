import 'package:flutter/foundation.dart';

import '../animation/animation_config.dart';
import 'modifier.dart';
import 'spec.dart';

/// Base class for all widget specifications that include widget-level metadata.
///
/// Replaces the former ResolvedStyle wrapper by embedding animation and
/// widget modifier metadata directly into the concrete spec types.
abstract class WidgetSpec<T extends WidgetSpec<T>> extends Spec<T>
    with Diagnosticable {
  /// Optional animation configuration attached to this spec.
  final AnimationConfig? animation;

  /// Widget-level modifiers to apply around the built widget.
  final List<Modifier>? widgetModifiers;

  /// Whether this spec should inherit styles from ancestors.
  final bool? inherit;

  const WidgetSpec({this.animation, this.widgetModifiers, this.inherit});

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('animation', animation))
      ..add(IterableProperty<Modifier>('widgetModifiers', widgetModifiers))
      ..add(FlagProperty('inherit', value: inherit, ifTrue: 'inherits styles'));
  }

  @override
  List<Object?> get props => [animation, widgetModifiers, inherit];
}
