/// Structured parse diagnostics for Tailwind candidate syntax.
library;

import 'model.dart';

sealed class TailwindParseResult {
  const TailwindParseResult();

  String get input;
  bool get isSuccess;
}

final class TailwindParseSuccess extends TailwindParseResult {
  const TailwindParseSuccess({
    required this.input,
    required this.candidate,
    this.warnings = const [],
  });

  @override
  final String input;
  final TailwindCandidate candidate;
  final List<TailwindParseWarning> warnings;

  @override
  bool get isSuccess => true;
}

final class TailwindParseFailure extends TailwindParseResult {
  const TailwindParseFailure({
    required this.input,
    required this.errors,
    this.partial,
  });

  @override
  final String input;
  final List<TailwindParseError> errors;
  final TailwindCandidate? partial;

  @override
  bool get isSuccess => false;
}

final class TailwindParseError {
  const TailwindParseError({
    required this.code,
    required this.message,
    required this.span,
  });

  final TailwindParseErrorCode code;
  final String message;
  final SourceSpan span;
}

enum TailwindParseErrorCode {
  emptyInput,
  emptyArbitraryValue,
  unclosedBracket,
  unopenedBracket,
  unclosedParenthesis,
  unopenedParenthesis,
  invalidModifier,
  invalidImportantPosition,
  invalidArbitraryProperty,
  invalidVariantChain,
}

final class TailwindParseWarning {
  const TailwindParseWarning({
    required this.code,
    required this.message,
    required this.span,
  });

  final String code;
  final String message;
  final SourceSpan span;
}
