import 'package:flutter/foundation.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../attributes/animated/animated_data.dart';
import '../attributes/animated/animated_data_dto.dart';
import '../attributes/modifiers/widget_modifiers_data.dart';
import '../attributes/modifiers/widget_modifiers_data_dto.dart';
import '../internal/compare_mixin.dart';
import 'attribute.dart';
import 'factory/mix_data.dart';

@immutable
abstract class Spec<T extends Spec<T>> with EqualityMixin {
  final AnimatedData? animated;

  @MixableProperty(
    utilities: [MixableUtility(alias: 'wrap')],
    isLerpable: false,
  )
  final WidgetModifiersData? modifiers;

  const Spec({this.animated, this.modifiers});

  Type get type => T;

  bool get isAnimated => animated != null;

  /// Creates a copy of this spec with the given fields
  /// replaced by the non-null parameter values.
  T copyWith();

  /// Linearly interpolate with another [Spec] object.
  T lerp(covariant T? other, double t);
}

/// An abstract class representing a resolvable attribute.
///
/// This class extends the [StyledAttribute] class and provides a generic type [Self] and [Value].
/// The [Self] type represents the concrete implementation of the attribute, while the [Value] type represents the resolvable value.
abstract class SpecAttribute<Value> extends StyledAttribute {
  final AnimatedDataDto? animated;
  final WidgetModifiersDataDto? modifiers;

  const SpecAttribute({this.animated, this.modifiers});

  Value resolve(MixData mix);
  @override
  SpecAttribute<Value> merge(covariant SpecAttribute<Value>? other);
}

abstract class SpecUtility<T extends Attribute, V> extends Attribute {
  T? attributeValue;

  @protected
  @visibleForTesting
  final T Function(V) attributeBuilder;

  final bool _mutable;

  SpecUtility(this.attributeBuilder, {bool mutable = false})
      : _mutable = mutable;

  static T selfBuilder<T>(T value) => value;

  T builder(V v) {
    final attribute = attributeBuilder(v);
    if (_mutable) {
      attributeValue = (attributeValue?.merge(attribute) ?? attribute) as T;
    }

    return attribute;
  }

  T only();
  @override
  SpecUtility<T, V> merge(covariant SpecUtility<T, V> other) {
    attributeValue = (attributeValue?.merge(other.attributeValue) ??
        other.attributeValue) as T;

    return this;
  }

  @override
  get props => [attributeValue];
}
