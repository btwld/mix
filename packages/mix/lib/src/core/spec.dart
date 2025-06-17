import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../mix.dart';
import '../internal/compare_mixin.dart';

@immutable
abstract class Spec<T extends Spec<T>> with EqualityMixin {
  final AnimatedData? animated;

  @MixableField(
    utilities: [MixableFieldUtility(alias: 'wrap')],
    isLerpable: false,
  )
  final WidgetModifiersConfig? modifiers;

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
/// This class extends the [StyleElement] class and provides a generic type [Self] and [Value].
/// The [Self] type represents the concrete implementation of the attribute, while the [Value] type represents the resolvable value.
abstract class SpecAttribute<Value> extends StyleElement
    implements Mixable<Value> {
  final AnimatedDataDto? animated;
  final WidgetModifiersDataDto? modifiers;

  const SpecAttribute({this.animated, this.modifiers});

  @override
  Value resolve(MixContext mix);

  @override
  SpecAttribute<Value> merge(covariant SpecAttribute<Value>? other);
}

abstract class SpecUtility<T extends SpecAttribute, V> extends StyleUtility<T> {
  @protected
  @visibleForTesting
  final T Function(V) attributeBuilder;

  SpecUtility(
    this.attributeBuilder, {
    @Deprecated(
      'mutable parameter is no longer used. All SpecUtilities are now mutable by default.',
    )
    bool? mutable,
  });

  static T selfBuilder<T>(T value) => value;

  T builder(V v) {
    final attribute = attributeBuilder(v);
    // Always mutable - accumulate state in attributeValue
    styles = styles.merge(AttributeMap([attribute]));

    return attribute;
  }

  T only();
  @override
  SpecUtility<T, V> merge(covariant SpecUtility<T, V> other) {
    styles = styles.merge(other.styles);

    return this;
  }

  @override
  get props => [attributeValue];
}
