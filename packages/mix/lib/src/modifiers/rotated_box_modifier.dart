import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

final class RotatedBoxWidgetDecorator
    extends WidgetDecorator<RotatedBoxWidgetDecorator> {
  final int quarterTurns;
  const RotatedBoxWidgetDecorator([int? quarterTurns])
    : quarterTurns = quarterTurns ?? 0;

  /// Creates a copy of this [RotatedBoxWidgetDecorator] but with the given fields
  /// replaced with the new values.
  @override
  RotatedBoxWidgetDecorator copyWith({int? quarterTurns}) {
    return RotatedBoxWidgetDecorator(quarterTurns ?? this.quarterTurns);
  }

  @override
  RotatedBoxWidgetDecorator lerp(RotatedBoxWidgetDecorator? other, double t) {
    if (other == null) return this;

    return RotatedBoxWidgetDecorator(
      MixHelpers.lerpInt(quarterTurns, other.quarterTurns, t),
    );
  }

  /// The list of properties that constitute the state of this [RotatedBoxWidgetDecorator].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [RotatedBoxWidgetDecorator] instances for equality.
  @override
  List<Object?> get props => [quarterTurns];

  @override
  Widget build(Widget child) {
    return RotatedBox(quarterTurns: quarterTurns, child: child);
  }
}

/// Represents the attributes of a [RotatedBoxWidgetDecorator].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [RotatedBoxWidgetDecorator].
///
/// Use this class to configure the attributes of a [RotatedBoxWidgetDecorator] and pass it to
/// the [RotatedBoxWidgetDecorator] constructor.
class RotatedBoxWidgetDecoratorStyle
    extends WidgetDecoratorStyle<RotatedBoxWidgetDecorator> {
  final Prop<int>? quarterTurns;

  const RotatedBoxWidgetDecoratorStyle.raw({this.quarterTurns});

  RotatedBoxWidgetDecoratorStyle({int? quarterTurns})
    : this.raw(quarterTurns: Prop.maybe(quarterTurns));

  /// Resolves to [RotatedBoxWidgetDecorator] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final rotatedBoxModifierSpec = RotatedBoxWidgetDecoratorStyle(...).resolve(mix);
  /// ```
  @override
  RotatedBoxWidgetDecorator resolve(BuildContext context) {
    return RotatedBoxWidgetDecorator(MixHelpers.resolve(context, quarterTurns));
  }

  /// Merges the properties of this [RotatedBoxWidgetDecoratorStyle] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [RotatedBoxWidgetDecoratorStyle] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  RotatedBoxWidgetDecoratorStyle merge(RotatedBoxWidgetDecoratorStyle? other) {
    if (other == null) return this;

    return RotatedBoxWidgetDecoratorStyle.raw(
      quarterTurns: quarterTurns.tryMerge(other.quarterTurns),
    );
  }

  @override
  List<Object?> get props => [quarterTurns];
}

final class RotatedBoxWidgetDecoratorUtility<T extends Style<Object?>>
    extends MixUtility<T, RotatedBoxWidgetDecoratorStyle> {
  const RotatedBoxWidgetDecoratorUtility(super.builder);
  T d90() => call(1);
  T d180() => call(2);
  T d270() => call(3);

  T call(int value) => builder(
    RotatedBoxWidgetDecoratorStyle.raw(quarterTurns: Prop.value(value)),
  );
}
