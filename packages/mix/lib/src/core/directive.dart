import 'package:flutter/material.dart';

import 'attribute.dart';

typedef TextModifier<T> = T Function(T value);

/// The `Directive` abstract class provides the ability to modify or apply
/// different behaviors to widgets and attributes.
abstract class Directive extends Attribute {
  const Directive();
}

@immutable
class TextDirective extends Directive {
  final List<TextModifier<String>> _modifiers;
  const TextDirective(this._modifiers);

  @visibleForTesting
  int get length => _modifiers.length;

  String apply(String value) {
    return _modifiers.fold(
      value,
      (previousValue, modifier) => modifier(previousValue),
    );
  }

  @override
  TextDirective merge(TextDirective? other) {
    return TextDirective([..._modifiers, ...?other?._modifiers]);
  }

  @override
  get props => [_modifiers];
}
