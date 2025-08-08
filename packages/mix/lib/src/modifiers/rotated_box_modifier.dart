import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../core/widget_modifier.dart';

final class RotatedBoxWidgetModifier
    extends WidgetModifier<RotatedBoxWidgetModifier> {
  final int quarterTurns;
  const RotatedBoxWidgetModifier([int? quarterTurns])
    : quarterTurns = quarterTurns ?? 0;

  /// Creates a copy of this [RotatedBoxWidgetModifier] but with the given fields
  /// replaced with the new values.
  @override
  RotatedBoxWidgetModifier copyWith({int? quarterTurns}) {
    return RotatedBoxWidgetModifier(quarterTurns ?? this.quarterTurns);
  }

  @override
  RotatedBoxWidgetModifier lerp(RotatedBoxWidgetModifier? other, double t) {
    if (other == null) return this;

    return RotatedBoxWidgetModifier(
      MixOps.lerp(quarterTurns, other.quarterTurns, t),
    );
  }

  /// The list of properties that constitute the state of this [RotatedBoxWidgetModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [RotatedBoxWidgetModifier] instances for equality.
  @override
  List<Object?> get props => [quarterTurns];

  @override
  Widget build(Widget child) {
    return RotatedBox(quarterTurns: quarterTurns, child: child);
  }
}

/// Represents the attributes of a [RotatedBoxWidgetModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [RotatedBoxWidgetModifier].
///
/// Use this class to configure the attributes of a [RotatedBoxWidgetModifier] and pass it to
/// the [RotatedBoxWidgetModifier] constructor.
class RotatedBoxWidgetModifierMix
    extends WidgetModifierMix<RotatedBoxWidgetModifier> {
  final Prop<int>? quarterTurns;

  const RotatedBoxWidgetModifierMix.create({this.quarterTurns});

  RotatedBoxWidgetModifierMix({int? quarterTurns})
    : this.create(quarterTurns: Prop.maybe(quarterTurns));

  /// Resolves to [RotatedBoxWidgetModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final rotatedBoxWidgetModifier = RotatedBoxWidgetModifierMix(...).resolve(mix);
  /// ```
  @override
  RotatedBoxWidgetModifier resolve(BuildContext context) {
    return RotatedBoxWidgetModifier(MixOps.resolve(context, quarterTurns));
  }

  /// Merges the properties of this [RotatedBoxWidgetModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [RotatedBoxWidgetModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  RotatedBoxWidgetModifierMix merge(RotatedBoxWidgetModifierMix? other) {
    if (other == null) return this;

    return RotatedBoxWidgetModifierMix.create(
      quarterTurns: MixOps.merge(quarterTurns, other.quarterTurns),
    );
  }

  @override
  List<Object?> get props => [quarterTurns];
}

final class RotatedBoxWidgetModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, RotatedBoxWidgetModifierMix> {
  const RotatedBoxWidgetModifierUtility(super.builder);
  T d90() => call(1);
  T d180() => call(2);
  T d270() => call(3);

  T call(int value) => builder(
    RotatedBoxWidgetModifierMix.create(quarterTurns: Prop.value(value)),
  );
}
