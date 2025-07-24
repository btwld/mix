import 'package:flutter/widgets.dart';

import '../internal/compare_mixin.dart';

mixin Resolvable<V> {
  V resolve(BuildContext context);
}

abstract class Mixable<T> {
  const Mixable();

  Object get mergeKey => runtimeType;
  Mixable<T> merge(covariant Mixable<T>? other);
}

abstract class Mix<T> extends Mixable<T> with Resolvable<T>, EqualityMixin {
  const Mix();

  @override
  Mix<T> merge(covariant Mix<T>? other);

  @override
  T resolve(BuildContext context);
}

// Define a mixin for properties that have default values
mixin DefaultValue<Value> {
  @protected
  Value get defaultValue;
}
