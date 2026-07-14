/// Structured parse diagnostics for Tailwind candidate syntax.
library;

import 'model.dart';

sealed class TailwindParseResult {
  const TailwindParseResult();
}

final class TailwindParseSuccess extends TailwindParseResult {
  const TailwindParseSuccess({required this.candidate});

  final TailwindCandidate candidate;
}

final class TailwindParseFailure extends TailwindParseResult {
  const TailwindParseFailure({required this.errors});

  final List<TailwindParseError> errors;
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
