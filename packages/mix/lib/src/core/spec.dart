import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../attributes/animated/animated_data.dart';
import '../attributes/animated/animated_data_dto.dart';
import '../attributes/modifiers/widget_modifiers_data.dart';
import '../attributes/modifiers/widget_modifiers_data_dto.dart';
import '../internal/compare_mixin.dart';
import '../variants/context_variant_util/on_util.dart';
import '../variants/variant_attribute.dart';
import '../variants/widget_state_variant.dart';
import 'element.dart';
import 'factory/mix_data.dart';
import 'factory/style_mix.dart';
import 'variant.dart';

@immutable
abstract class Spec<T extends Spec<T>> with EqualityMixin {
  final AnimatedData? animated;

  @MixableField(
    utilities: [MixableFieldUtility(alias: 'wrap')],
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
/// This class extends the [Attribute] class and provides a generic type [Self] and [Value].
/// The [Self] type represents the concrete implementation of the attribute, while the [Value] type represents the resolvable value.
abstract class SpecAttribute<Value> extends Mixable<Value>
    implements Attribute {
  final AnimatedDataDto? animated;
  final WidgetModifiersDataDto? modifiers;

  const SpecAttribute({this.animated, this.modifiers});

  @override
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

class SpecConfiguration<U extends SpecUtility> {
  final BuildContext context;

  final U _utility;

  const SpecConfiguration(this.context, this._utility);

  OnContextVariantUtility get on => OnContextVariantUtility.self;

  U get utilities => _utility;
}

abstract class SpecStyle<U extends SpecUtility> {
  const SpecStyle();

  Style makeStyle(SpecConfiguration<U> spec);
}

/// An abstract class representing a resolvable attribute.
///
/// This class extends the [Attribute] class and provides a generic type [Self] and [Value].
/// The [Self] type represents the concrete implementation of the attribute, while the [Value] type represents the resolvable value.
abstract class FluentAttribute<Attr, S, Self> extends Mixable<S>
    implements Attribute {
  final Attr value;
  final List<VariantAttribute> variants;

  // final AnimatedDataDto? animated;
  // final WidgetModifiersDataDto? modifiers;

  const FluentAttribute(this.value, {this.variants = const []});

  FluentAttribute<Attr, S, Self> _addContextVariant({
    required Attribute Function(Self) value,
    required VariantAttribute variant,
  }) =>
      constructor(this.value, variants: [...variants, variant])
          as FluentAttribute<Attr, S, Self>;

  @protected
  // ignore: avoid-unused-parameters
  Self Function(Attr value, {List<VariantAttribute> variants}) get constructor;
  Self Function() get constructorEmpty;

  FluentAttribute<Attr, S, Self> onHover(Attribute Function(Self) value) =>
      _addContextVariant(
        value: value,
        variant: const OnHoverVariant().call(value(constructorEmpty())),
      );

  FluentAttribute<Attr, S, Self> onVariant(
    Variant variant,
    Attribute Function(Self) value,
  ) =>
      _addContextVariant(
        value: value,
        variant: variant(value(this as Self)),
      );

  FluentAttribute<Attr, S, Self> onPress(Attribute Function(Self) value) =>
      _addContextVariant(
        value: value,
        variant: const OnPressVariant().call(value(constructorEmpty())),
      );

  @override
  FluentAttribute<Attr, S, Self> merge(
    covariant FluentAttribute<Attr, S, Self>? other,
  );

  @override
  S resolve(MixData mix);

  @override
  List<Object?> get props => [value, variants];
}
