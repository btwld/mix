import 'package:flutter/foundation.dart';

import '../core/element.dart';
import '../core/factory/style_mix.dart';
import '../core/variant.dart';

@immutable
class VariantAttribute<V extends IVariant> extends StyleElement {
  final V variant;
  final Style _style;
  const VariantAttribute(this.variant, Style style) : _style = style;

  Style get value => _style;

  VariantPriority get priority => variant.priority;

  bool matches(Iterable<IVariant> otherVariants) =>
      variant.matches(otherVariants);

  VariantAttribute? removeVariants(Iterable<IVariant> variantsToRemove) {
    IVariant? remainingVariant;
    if (variant is MultiVariant) {
      remainingVariant = (variant as MultiVariant).remove(variantsToRemove);
    } else {
      if (!variantsToRemove.contains(variant)) {
        return this;
      }
    }

    return remainingVariant == null
        ? null
        : VariantAttribute(remainingVariant, _style);
  }

  @override
  VariantAttribute<V> merge(covariant VariantAttribute<V>? other) {
    if (other?.variant != variant) throw _throwArgumentError(other);

    return VariantAttribute(variant, _style.merge(other?._style));
  }

  @override
  get props => [variant, _style];

  @override
  Object get mergeKey => variant.mergeKey;
}

ArgumentError _throwArgumentError<T extends VariantAttribute>(T? other) {
  throw ArgumentError.value(
    other.runtimeType,
    'other',
    'VariantAttribute must have the same variant',
  );
}
