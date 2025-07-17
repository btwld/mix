import 'package:flutter/foundation.dart';

import '../core/mix_element.dart';
import '../core/variant.dart';

@immutable
class VariantAttribute<V> {
  final Variant variant;
  final StyleElement<V> _style;
  
  const VariantAttribute(this.variant, StyleElement<V> style) 
    : _style = style;

  StyleElement<V> get value => _style;

  bool matches(Iterable<Variant> otherVariants) =>
      otherVariants.contains(variant);

  VariantAttribute<V>? removeVariants(Iterable<Variant> variantsToRemove) {
    Variant? remainingVariant;
    if (variant is MultiVariant) {
      final multiVariant = variant as MultiVariant;
      final remainingVariants = multiVariant.variants
          .where((v) => !variantsToRemove.contains(v))
          .toList();

      if (remainingVariants.isEmpty) {
        return null;
      } else if (remainingVariants.length == 1) {
        remainingVariant = remainingVariants.first;
      } else {
        remainingVariant = multiVariant.operatorType == MultiVariantOperator.and
            ? MultiVariant.and(remainingVariants)
            : MultiVariant.or(remainingVariants);
      }
    } else {
      if (!variantsToRemove.contains(variant)) {
        return this;
      }
    }

    return remainingVariant == null
        ? null
        : VariantAttribute(remainingVariant, _style);
  }

  VariantAttribute<V> merge(VariantAttribute<V>? other) {
    if (other == null) return this;
    if (other.variant != variant) throw _throwArgumentError(other);

    return VariantAttribute(variant, _style.merge(other._style));
  }

  Object get mergeKey => variant.key;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VariantAttribute<V> &&
          other.variant == variant &&
          other._style == _style;

  @override
  int get hashCode => Object.hash(variant, _style);
}

ArgumentError _throwArgumentError<T extends VariantAttribute>(T? other) {
  throw ArgumentError.value(
    other.runtimeType,
    'other',
    'VariantAttribute must have the same variant',
  );
}
