import 'package:flutter/widgets.dart';

import '../../core/element.dart';
import '../../core/factory/style_mix.dart';

/// Allows to pass down Mixes as attributes for use with helpers.
@immutable
final class NestedStyleAttribute extends Attribute {
  final Style value;

  const NestedStyleAttribute(this.value);

  factory NestedStyleAttribute.fromList(List<StyleElement> elements) {
    return NestedStyleAttribute(Style.create(elements));
  }

  @override
  NestedStyleAttribute merge(NestedStyleAttribute? other) {
    return other == null
        ? this
        : NestedStyleAttribute(value.merge(other.value));
  }

  @override
  Type get mergeKey => NestedStyleAttribute;

  @override
  List<Object?> get props => [value];
}
