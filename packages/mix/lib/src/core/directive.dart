import 'package:flutter/widgets.dart';

import 'mix_element.dart';

typedef Modifier<T> = T Function(T value);

@immutable
class TextDirectiveDto extends Mix<TextDirective> {
  final List<Modifier<String>> _modifiers;
  const TextDirectiveDto(this._modifiers);

  /// Constructor that accepts a [TextDirective] value and extracts its properties.
  ///
  /// This is useful for converting existing [TextDirective] instances to [TextDirectiveDto].
  ///
  /// ```dart
  /// final directive = TextDirective((s) => s.toUpperCase());
  /// final dto = TextDirectiveDto.value(directive);
  /// ```
  factory TextDirectiveDto.value(TextDirective directive) {
    return TextDirectiveDto([directive._modifier]);
  }

  /// Constructor that accepts a nullable [TextDirective] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [TextDirectiveDto.value].
  ///
  /// ```dart
  /// final TextDirective? directive = TextDirective((s) => s.toUpperCase());
  /// final dto = TextDirectiveDto.maybeValue(directive); // Returns TextDirectiveDto or null
  /// ```
  static TextDirectiveDto? maybeValue(TextDirective? directive) {
    return directive != null ? TextDirectiveDto.value(directive) : null;
  }

  @visibleForTesting
  int get length => _modifiers.length;
  @override
  TextDirective resolve(BuildContext context) {
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
