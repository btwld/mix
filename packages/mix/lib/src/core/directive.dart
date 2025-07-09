import 'package:flutter/widgets.dart';

import 'factory/mix_context.dart';
import 'mix_element.dart';

typedef Modifier<T> = T Function(T value);

@immutable
class TextDirectiveDto extends Mix<TextDirective> {
  final List<Modifier<String>> _modifiers;
  const TextDirectiveDto(this._modifiers);

  @visibleForTesting
  int get length => _modifiers.length;
  @override
  TextDirective resolve(MixContext mix) {
    return TextDirective((String content) {
      return _modifiers.fold(
        content,
        (previousValue, modifier) => modifier(previousValue),
      );
    });
  }

  @override
  TextDirectiveDto merge(TextDirectiveDto? other) {
    return TextDirectiveDto([..._modifiers, ...?other?._modifiers]);
  }

  @override
  get props => [_modifiers];
}

class TextDirective {
  final Modifier<String> _modifier;
  const TextDirective(this._modifier);

  String apply(String content) => _modifier(content);
}
