/// Pure Dart Tailwind candidate parser.
library;

import 'diagnostics.dart';
import 'model.dart';
import 'parser_registry.dart';

final class TailwindCandidateParser {
  const TailwindCandidateParser({
    this.registry = TailwindParserRegistry.empty,
    this.options = const TailwindParserOptions(),
  });

  final TailwindParserRegistry registry;
  final TailwindParserOptions options;

  TailwindParseResult parseCandidate(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return TailwindParseFailure(
        input: input,
        errors: [
          TailwindParseError(
            code: TailwindParseErrorCode.emptyInput,
            message: 'Tailwind candidate is empty.',
            span: SourceSpan(0, input.length),
          ),
        ],
      );
    }

    final balanceError = _balancedDelimiterError(trimmed);
    if (balanceError != null) {
      return TailwindParseFailure(input: input, errors: [balanceError]);
    }
    final emptyArbitraryError = _emptyArbitraryValueError(trimmed);
    if (emptyArbitraryError != null) {
      return TailwindParseFailure(input: input, errors: [emptyArbitraryError]);
    }

    final parts = _splitOutsideDelimiters(trimmed, ':');
    if (parts.any((part) => part.isEmpty)) {
      return TailwindParseFailure(
        input: input,
        errors: [
          TailwindParseError(
            code: TailwindParseErrorCode.invalidVariantChain,
            message: 'Variant chains cannot contain empty segments.',
            span: SourceSpan(0, trimmed.length),
          ),
        ],
      );
    }

    var utilityRaw = parts.last;
    var utilityStart = trimmed.length - utilityRaw.length;
    var important = false;
    if (utilityRaw.endsWith('!')) {
      important = true;
      utilityRaw = utilityRaw.substring(0, utilityRaw.length - 1);
    }
    if (options.allowLegacyImportantPrefix && utilityRaw.startsWith('!')) {
      important = true;
      utilityRaw = utilityRaw.substring(1);
      utilityStart++;
    }
    final invalidImportant = _indexOutsideDelimiters(utilityRaw, '!');
    if (invalidImportant != -1) {
      final spanStart = utilityStart + invalidImportant;
      return TailwindParseFailure(
        input: input,
        errors: [
          TailwindParseError(
            code: TailwindParseErrorCode.invalidImportantPosition,
            message: 'Important marker is only allowed at the start or end.',
            span: SourceSpan(spanStart, spanStart + 1),
          ),
        ],
      );
    }
    final modifierError = _modifierError(utilityRaw);
    if (modifierError != null) {
      return TailwindParseFailure(input: input, errors: [modifierError]);
    }

    final variants = <TailwindVariant>[];
    for (final rawVariant in parts.take(parts.length - 1)) {
      final modifierError = _modifierError(rawVariant);
      if (modifierError != null) {
        return TailwindParseFailure(input: input, errors: [modifierError]);
      }
      variants.add(_parseVariant(rawVariant));
    }

    final utility = _parseUtility(utilityRaw);
    if (utility == null) {
      return TailwindParseFailure(
        input: input,
        errors: [
          TailwindParseError(
            code: TailwindParseErrorCode.invalidArbitraryProperty,
            message: 'Arbitrary property must be [property:value].',
            span: SourceSpan(0, trimmed.length),
          ),
        ],
      );
    }

    return TailwindParseSuccess(
      input: input,
      candidate: TailwindCandidate(
        raw: trimmed,
        variants: List.unmodifiable(variants),
        utility: utility,
        important: important,
        span: SourceSpan(0, trimmed.length),
      ),
    );
  }

  TailwindUtility? _parseUtility(String raw) {
    if (raw.startsWith('[')) return _parseArbitraryProperty(raw);

    var negative = false;
    var body = raw;
    if (body.startsWith('-')) {
      negative = true;
      body = body.substring(1);
    }

    if (registry.isStaticUtility(body)) {
      return TailwindStaticUtility(raw: raw, root: body);
    }

    final root = _findFunctionalRoot(body, registry.functionalUtilityRoots);
    if (root != null) {
      final valueAndModifierRaw = body.length == root.length
          ? ''
          : body.substring(root.length + 1);
      final (valueRaw, modifier) = _splitUtilityValueModifier(
        root,
        valueAndModifierRaw,
      );
      if (valueRaw == null) {
        return TailwindUnresolvedUtility(
          raw: raw,
          segments: const [],
          negative: negative,
        );
      }
      return TailwindFunctionalUtility(
        raw: raw,
        root: root,
        value: _parseValue(valueRaw),
        modifier: modifier,
        negative: negative,
      );
    }

    final (base, modifier) = _splitModifier(body);
    if (base == null) {
      return TailwindUnresolvedUtility(
        raw: raw,
        segments: const [],
        negative: negative,
      );
    }

    return TailwindUnresolvedUtility(
      raw: raw,
      segments: _segments(base),
      modifier: modifier,
      negative: negative,
    );
  }

  TailwindArbitraryProperty? _parseArbitraryProperty(String raw) {
    final close = _matchingCloseIndex(raw, 0, '[', ']');
    if (close == null) return null;

    final (body, modifier) = _splitModifier(raw);
    if (body == null || !body.startsWith('[') || !body.endsWith(']')) {
      return null;
    }

    final inner = body.substring(1, body.length - 1);
    final colon = _indexOutsideDelimiters(inner, ':');
    if (colon <= 0 || colon == inner.length - 1) return null;

    return TailwindArbitraryProperty(
      raw: raw,
      property: inner.substring(0, colon),
      value: inner.substring(colon + 1),
      modifier: modifier,
    );
  }

  TailwindVariant _parseVariant(String raw) {
    final (base, modifier) = _splitModifier(raw);
    final body = base ?? raw;

    if (body.startsWith('[') && body.endsWith(']')) {
      final selector = body.substring(1, body.length - 1);
      return TailwindArbitraryVariant(
        raw: raw,
        selector: selector,
        relative: selector.startsWith('&') || selector.startsWith('@'),
      );
    }

    final compoundRoot = _findCompoundRoot(body);
    if (compoundRoot != null) {
      final childRaw = body.substring(compoundRoot.length + 1);
      return TailwindCompoundVariant(
        raw: raw,
        root: compoundRoot,
        variant: _parseVariant(childRaw),
        modifier: modifier,
      );
    }

    if (registry.isStaticVariant(body)) {
      return TailwindStaticVariant(raw: raw, root: body, modifier: modifier);
    }

    final functional = _findVariantFunctionalRoot(body);
    if (functional != null) {
      final valueRaw = functional == '@'
          ? body.substring(1)
          : body.substring(functional.length + 1);
      return TailwindFunctionalVariant(
        raw: raw,
        root: functional,
        value: _parseValue(valueRaw),
        modifier: modifier,
      );
    }

    return TailwindUnresolvedVariant(
      raw: raw,
      segments: _segments(body),
      modifier: modifier,
    );
  }

  TailwindValue _parseValue(String raw) {
    if (raw.startsWith('[') && raw.endsWith(']')) {
      final inner = raw.substring(1, raw.length - 1);
      final colon = _indexOutsideDelimiters(inner, ':');
      return TailwindArbitraryValue(
        raw: raw,
        typeHint: colon > 0 ? inner.substring(0, colon) : null,
        value: colon > 0 ? inner.substring(colon + 1) : inner,
      );
    }
    if (raw.startsWith('(') && raw.endsWith(')')) {
      return TailwindCssVariableValue(
        raw: raw,
        variableName: raw.substring(1, raw.length - 1),
      );
    }
    return TailwindNamedValue(raw);
  }

  (String?, TailwindModifier?) _splitModifier(String raw) {
    final slash = _indexOutsideDelimiters(raw, '/');
    if (slash == -1) return (raw, null);
    if (slash == 0 || slash == raw.length - 1) return (null, null);

    final base = raw.substring(0, slash);
    final modifierRaw = raw.substring(slash + 1);
    if (_indexOutsideDelimiters(modifierRaw, '/') != -1) return (null, null);

    return (base, _parseModifier(modifierRaw));
  }

  TailwindModifier _parseModifier(String raw) {
    if (raw.startsWith('[') && raw.endsWith(']')) {
      return TailwindArbitraryModifier(
        raw: raw,
        value: raw.substring(1, raw.length - 1),
      );
    }
    if (raw.startsWith('(') && raw.endsWith(')')) {
      return TailwindCssVariableModifier(
        raw: raw,
        variableName: raw.substring(1, raw.length - 1),
      );
    }
    return TailwindNamedModifier(raw);
  }

  (String?, TailwindModifier?) _splitUtilityValueModifier(
    String root,
    String raw,
  ) {
    final slash = _indexOutsideDelimiters(raw, '/');
    if (slash == -1) return (raw, null);

    if (_isFractionValueRoot(root) && _isFractionValue(raw)) {
      return (raw, null);
    }

    if (slash == 0 || slash == raw.length - 1) return (null, null);

    final base = raw.substring(0, slash);
    final modifierRaw = raw.substring(slash + 1);
    if (_indexOutsideDelimiters(modifierRaw, '/') != -1) return (null, null);

    return (base, _parseModifier(modifierRaw));
  }

  bool _isFractionValueRoot(String root) {
    return const {
      'basis',
      'flex',
      'h',
      'max-h',
      'max-w',
      'min-h',
      'min-w',
      'w',
    }.contains(root);
  }

  bool _isFractionValue(String raw) {
    return RegExp(r'^\d+(?:\.\d+)?/\d+(?:\.\d+)?$').hasMatch(raw);
  }

  String? _findFunctionalRoot(String body, Set<String> roots) {
    if (roots.contains(body)) return body;

    var current = body;
    while (current.isNotEmpty) {
      final dash = current.lastIndexOf('-');
      if (dash == -1) break;
      current = current.substring(0, dash);
      if (roots.contains(current)) return current;
    }
    return null;
  }

  String? _findCompoundRoot(String body) {
    for (final root in registry.compoundVariantRoots) {
      if (body.startsWith('$root-') && body.length > root.length + 1) {
        return root;
      }
    }
    return null;
  }

  String? _findVariantFunctionalRoot(String body) {
    final roots = registry.functionalVariantRoots;
    final longest = _findFunctionalRoot(
      body,
      roots.where((root) => root != '@').toSet(),
    );
    if (longest != null) return longest;
    if (roots.contains('@') && body.startsWith('@') && body.length > 1) {
      return '@';
    }
    return null;
  }
}

final class TailwindParserOptions {
  const TailwindParserOptions({
    this.allowLegacyImportantPrefix = true,
    this.preserveSourceSpans = true,
  });

  final bool allowLegacyImportantPrefix;
  final bool preserveSourceSpans;
}

TailwindParseError? _balancedDelimiterError(String input) {
  final stack = <String>[];
  for (var i = 0; i < input.length; i++) {
    final char = input[i];
    if (char == '[' || char == '(') {
      stack.add(char);
    } else if (char == ']') {
      if (stack.isEmpty || stack.removeLast() != '[') {
        return TailwindParseError(
          code: TailwindParseErrorCode.unopenedBracket,
          message: 'Closing bracket has no matching opening bracket.',
          span: SourceSpan(i, i + 1),
        );
      }
    } else if (char == ')') {
      if (stack.isEmpty || stack.removeLast() != '(') {
        return TailwindParseError(
          code: TailwindParseErrorCode.unopenedParenthesis,
          message: 'Closing parenthesis has no matching opening parenthesis.',
          span: SourceSpan(i, i + 1),
        );
      }
    }
  }
  if (stack.isEmpty) return null;
  final opening = stack.last;
  return TailwindParseError(
    code: opening == '['
        ? TailwindParseErrorCode.unclosedBracket
        : TailwindParseErrorCode.unclosedParenthesis,
    message: 'Delimiter was not closed.',
    span: SourceSpan(input.length - 1, input.length),
  );
}

TailwindParseError? _emptyArbitraryValueError(String input) {
  for (var i = 0; i < input.length - 1; i++) {
    final startsArbitrarySegment =
        i == 0 ||
        input[i - 1] == '-' ||
        input[i - 1] == ':' ||
        input[i - 1] == '/';
    if (startsArbitrarySegment && input[i] == '[' && input[i + 1] == ']') {
      return TailwindParseError(
        code: TailwindParseErrorCode.emptyArbitraryValue,
        message: 'Arbitrary values cannot be empty.',
        span: SourceSpan(i, i + 2),
      );
    }
  }
  return null;
}

TailwindParseError? _modifierError(String raw) {
  final slash = _indexOutsideDelimiters(raw, '/');
  if (slash == -1) return null;
  if (slash == 0 || slash == raw.length - 1) {
    return TailwindParseError(
      code: TailwindParseErrorCode.invalidModifier,
      message: 'Modifiers must have a value after one slash.',
      span: SourceSpan(slash, slash + 1),
    );
  }
  final modifierRaw = raw.substring(slash + 1);
  if (_indexOutsideDelimiters(modifierRaw, '/') != -1) {
    return TailwindParseError(
      code: TailwindParseErrorCode.invalidModifier,
      message: 'Only one modifier slash is allowed.',
      span: SourceSpan(slash, raw.length),
    );
  }
  return null;
}

List<String> _splitOutsideDelimiters(String input, String delimiter) {
  final parts = <String>[];
  var start = 0;
  var square = 0;
  var paren = 0;
  for (var i = 0; i < input.length; i++) {
    final char = input[i];
    if (char == '[') square++;
    if (char == ']') square--;
    if (char == '(') paren++;
    if (char == ')') paren--;
    if (char == delimiter && square == 0 && paren == 0) {
      parts.add(input.substring(start, i));
      start = i + 1;
    }
  }
  parts.add(input.substring(start));
  return parts;
}

int _indexOutsideDelimiters(String input, String needle) {
  var square = 0;
  var paren = 0;
  for (var i = 0; i < input.length; i++) {
    final char = input[i];
    if (char == '[') square++;
    if (char == ']') square--;
    if (char == '(') paren++;
    if (char == ')') paren--;
    if (char == needle && square == 0 && paren == 0) return i;
  }
  return -1;
}

int? _matchingCloseIndex(
  String input,
  int openIndex,
  String open,
  String close,
) {
  var depth = 0;
  for (var i = openIndex; i < input.length; i++) {
    if (input[i] == open) depth++;
    if (input[i] == close) {
      depth--;
      if (depth == 0) return i;
    }
  }
  return null;
}

List<String> _segments(String raw) {
  if (raw.isEmpty) return const [];
  return raw.split('-');
}
