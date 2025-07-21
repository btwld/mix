/// A collection of extension methods for the `String` class and `List<String>` class.
/// These methods provide various string manipulation functionalities such as converting
/// between different case styles (camel case, pascal case, snake case, etc.), capitalizing
/// words, and extracting words from a string.
///
/// The `StringExt` extension provides methods for manipulating individual strings,
/// while the `ListStringExt` extension provides methods for manipulating lists of strings.
///
/// Example usage:
/// ```dart
/// import 'package:mix/helpers/string_ext.dart';
///
/// void main() {
///   String myString = 'hello_world';
///   print(myString.camelCase); // Output: helloWorld
///
///   List<String> myStringList = ['hello', 'world'];
///   print(myStringList.uppercase); // Output: ['HELLO', 'WORLD']
/// }
/// ```
const _snakeCaseSeparator = '_';
const _paramCaseSeparator = '-';
const _spaceSeparator = ' ';

final _upperAlphaRegex = RegExp(r'[_-\sA-Z]');

final _symbolSet = {
  _snakeCaseSeparator,
  _paramCaseSeparator,
  _spaceSeparator,
};

/// Extension on [String] to provide various string manipulation operations.
extension StringExt on String {
  /// Splits the string into a list of words.
  List<String> get words {
    final sb = StringBuffer();
    final words = <String>[];
    final isAllCaps = toUpperCase() == this;

    for (int i = 0; i < length; i++) {
      final char = this[i];
      final nextChar = i + 1 == length ? null : this[i + 1];

      if (_symbolSet.contains(char)) {
        continue;
      }

      sb.write(char);

      final isEndOfWord = nextChar == null ||
          (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
          _symbolSet.contains(nextChar);

      if (isEndOfWord) {
        words.add(sb.toString());
        sb.clear();
      }
    }

    return words;
  }

  /// Checks if the string is in all uppercase.
  bool get isUpperCase => toUpperCase() == this;

  /// Checks if the string is in all lowercase.
  bool get isLowerCase => toLowerCase() == this;

  /// Converts the string to camel case.
  String get camelCase {
    final wordList = words.map((word) => word.capitalize).toList();
    if (wordList.isNotEmpty) {
      wordList[0] = wordList.first.toLowerCase();
    }

    return wordList.join();
  }

  /// Converts the string to pascal case.
  String get pascalCase => words.map((word) => word.capitalize).join();

  /// Capitalizes the first letter of the string.
  String get capitalize {
    if (isEmpty) return this;
    final firstRune = runes.first;
    final restRunes = runes.skip(1);

    return String.fromCharCode(firstRune).toUpperCase() +
        restRunes.map((rune) => String.fromCharCode(rune).toLowerCase()).join();
  }

  /// Converts the string to constant case.
  String get constantCase => words.uppercase.join(_snakeCaseSeparator);

  /// Converts the string to snake case.
  String get snakeCase => words.lowercase.join(_snakeCaseSeparator);

  /// Converts the string to param case.
  String get paramCase => words.lowercase.join(_paramCaseSeparator);

  /// Converts the string to title case.
  String get titleCase =>
      words.map((word) => word.capitalize).join(_spaceSeparator);

  /// Converts the string to sentence case.
  String get sentenceCase {
    final wordList = [...words];
    if (wordList.isEmpty) return this;

    wordList[0] = wordList.first.capitalize;

    return wordList.join(_spaceSeparator);
  }
}

/// Extension on [List<String>] to provide additional string manipulation methods.
extension ListStringExt on List<String> {
  /// Converts all strings in the list to lowercase.
  List<String> get lowercase => map((e) => e.toLowerCase()).toList();

  /// Converts all strings in the list to uppercase.
  List<String> get uppercase => map((e) => e.toUpperCase()).toList();
}