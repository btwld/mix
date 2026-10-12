/// Structured parse diagnostics for Tailwind candidate syntax.
library;

import 'model.dart';

sealed class TailwindParseResult {
  const TailwindParseResult();
}

final class TailwindParseSuccess extends TailwindParseResult {
  final TailwindCandidate candidate;

  const TailwindParseSuccess({required this.candidate});
}

final class TailwindParseFailure extends TailwindParseResult {
  final List<TailwindParseError> errors;

  const TailwindParseFailure({required this.errors});
}

final class TailwindParseError {
  final TailwindParseErrorCode code;

  final String message;
  final SourceSpan span;
  const TailwindParseError({
    required this.code,
    required this.message,
    required this.span,
  });
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
