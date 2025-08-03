import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../core/widget_decorator.dart';
import '../theme/tokens/mix_token.dart';

/// A decorator that wraps a widget with the [Visibility] widget.
///
/// Controls whether a child widget is visible or hidden while maintaining
/// its space in the layout.
final class VisibilityWidgetDecorator
    extends WidgetDecorator<VisibilityWidgetDecorator>
    with Diagnosticable {
  /// Whether the child widget should be visible.
  final bool visible;
  const VisibilityWidgetDecorator([bool? visible]) : visible = visible ?? true;

  /// Creates a copy of this [VisibilityWidgetDecorator] with the given fields replaced.
  @override
  VisibilityWidgetDecorator copyWith({bool? visible}) {
    return VisibilityWidgetDecorator(visible ?? this.visible);
  }

  /// Linearly interpolates between this [VisibilityWidgetDecorator] and [other].
  ///
  /// Uses a step function for [visible] property - values below 0.5 use this
  /// instance's value, otherwise uses [other]'s value.
  ///
  /// This method is typically used in animations to transition between
  /// different [VisibilityWidgetDecorator] configurations.
  @override
  VisibilityWidgetDecorator lerp(VisibilityWidgetDecorator? other, double t) {
    if (other == null) return this;

    return VisibilityWidgetDecorator(t < 0.5 ? visible : other.visible);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('visible', visible, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [VisibilityWidgetDecorator].
  @override
  List<Object?> get props => [visible];

  @override
  Widget build(Widget child) {
    return Visibility(visible: visible, child: child);
  }
}

/// Represents the attributes of a [VisibilityWidgetDecorator].
///
/// This class encapsulates properties defining the visibility behavior
/// of a [VisibilityWidgetDecorator].
class VisibilityWidgetDecoratorMix
    extends WidgetDecoratorMix<VisibilityWidgetDecorator>
    with Diagnosticable {
  /// Whether the child widget should be visible.
  final Prop<bool>? visible;

  const VisibilityWidgetDecoratorMix.raw({this.visible});

  VisibilityWidgetDecoratorMix({bool? visible})
    : this.raw(visible: Prop.maybe(visible));

  /// Resolves to [VisibilityWidgetDecorator] using the provided [BuildContext].
  ///
  /// ```dart
  /// final visibilityModifier = VisibilityWidgetDecoratorMix(...).resolve(context);
  /// ```
  @override
  VisibilityWidgetDecorator resolve(BuildContext context) {
    return VisibilityWidgetDecorator(visible?.resolveProp(context));
  }

  /// Merges the properties of this [VisibilityWidgetDecoratorMix] with [other].
  ///
  /// Properties from [other] take precedence over the corresponding properties
  /// of this instance. Returns this instance unchanged if [other] is null.
  @override
  VisibilityWidgetDecoratorMix merge(VisibilityWidgetDecoratorMix? other) {
    if (other == null) return this;

    return VisibilityWidgetDecoratorMix.raw(
      visible: visible?.mergeProp(other.visible) ?? other.visible,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('visible', visible, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [VisibilityWidgetDecoratorMix].
  @override
  List<Object?> get props => [visible];
}

/// Utility class for configuring [VisibilityWidgetDecorator] properties.
///
/// This class provides methods to set the visibility state of a [VisibilityWidgetDecorator].
final class VisibilityWidgetDecoratorUtility<T extends Style<Object?>>
    extends MixUtility<T, VisibilityWidgetDecoratorMix> {
  const VisibilityWidgetDecoratorUtility(super.builder);

  /// Sets the visibility to true.
  T on() => call(true);

  /// Sets the visibility to false.
  T off() => call(false);

  /// Creates a [VisibilityWidgetDecoratorMix] with the specified visibility state.
  T call(bool value) =>
      builder(VisibilityWidgetDecoratorMix.raw(visible: Prop.value(value)));

  /// Creates a [VisibilityWidgetDecoratorMix] with the specified visibility token.
  T token(MixToken<bool> token) =>
      builder(VisibilityWidgetDecoratorMix.raw(visible: Prop.token(token)));
}
