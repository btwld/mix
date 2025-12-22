/// Parameters for configuring the AI Slop Detector rules.
class AiSlopParameters {
  /// Whether the AI slop detection is enabled.
  final bool enabled;

  /// Maximum function length before flagging as potential god function.
  final int maxFunctionLength;

  /// Maximum class method count before flagging as potential god class.
  final int maxClassMethods;

  /// Maximum nesting depth before flagging.
  final int maxNestingDepth;

  /// Whether to check for obvious comments.
  final bool checkObviousComments;

  /// Whether to check for hedging comments.
  final bool checkHedgingComments;

  /// Whether to check for TODO/FIXME comments in production code.
  final bool checkPlaceholderComments;

  /// Whether to check for empty test assertions.
  final bool checkEmptyAssertions;

  /// Whether to check for silent error handling.
  final bool checkSilentErrors;

  const AiSlopParameters({
    this.enabled = true,
    this.maxFunctionLength = 100,
    this.maxClassMethods = 20,
    this.maxNestingDepth = 4,
    this.checkObviousComments = true,
    this.checkHedgingComments = true,
    this.checkPlaceholderComments = true,
    this.checkEmptyAssertions = true,
    this.checkSilentErrors = true,
  });

  factory AiSlopParameters.fromJson(Map<String, Object?> json) {
    return AiSlopParameters(
      enabled: json['enabled'] as bool? ?? true,
      maxFunctionLength: json['max_function_length'] as int? ?? 100,
      maxClassMethods: json['max_class_methods'] as int? ?? 20,
      maxNestingDepth: json['max_nesting_depth'] as int? ?? 4,
      checkObviousComments: json['check_obvious_comments'] as bool? ?? true,
      checkHedgingComments: json['check_hedging_comments'] as bool? ?? true,
      checkPlaceholderComments:
          json['check_placeholder_comments'] as bool? ?? true,
      checkEmptyAssertions: json['check_empty_assertions'] as bool? ?? true,
      checkSilentErrors: json['check_silent_errors'] as bool? ?? true,
    );
  }
}
