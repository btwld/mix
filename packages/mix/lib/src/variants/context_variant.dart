import 'package:flutter/widgets.dart';

import '../core/factory/style_mix.dart';
import '../core/variant.dart';
import '../internal/compare_mixin.dart';

/// Builder for event-driven context variant styling.
///
/// Unlike regular variants that have boolean states, ContextVariantBuilder
/// allows for dynamic styling based on rich event data (e.g., pointer position).
///
/// This is kept separate from the main variant system for clear separation of
/// concerns: regular variants for conditions, builder for dynamic styling.
@immutable
final class ContextVariantBuilder<T> with EqualityMixin {
  final ContextVariant variant;
  final Style Function(BuildContext context, T value) fn;

  const ContextVariantBuilder(this.variant, this.fn);

  Style Function(BuildContext context, T value) mergeFn(
    Style Function(BuildContext context, T value) other,
  ) {
    return (BuildContext context, T value) =>
        fn(context, value).merge(other(context, value));
  }

  ContextVariantBuilder<T> merge(ContextVariantBuilder<T>? other) {
    if (other == null) return this;
    if (other.variant != variant) {
      throw ArgumentError.value(other, 'variant is not the same');
    }

    return ContextVariantBuilder(variant, mergeFn(other.fn));
  }

  @override
  List<Object?> get props => [variant, fn];

  Style build(BuildContext context, T value) => fn(context, value);
}
