import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Detects hedging comments that indicate AI uncertainty.
///
/// AI-generated code often includes comments that reveal uncertainty:
/// - `// This should work`
/// - `// Hopefully this fixes the issue`
/// - `// I think this is correct`
/// - `// This might need adjustment`
///
/// These comments indicate the code author wasn't confident in the solution.
/// If you're not sure, fix the code instead of leaving a hedging comment.
class DetectHedgingComments extends DartLintRule {
  static const _code = LintCode(
    name: 'ai_slop_hedging_comments',
    problemMessage:
        'This comment indicates uncertainty. If unsure, verify the code works correctly instead of hedging.',
    correctionMessage:
        'Remove the hedging comment and verify the code is correct.',
  );

  const DetectHedgingComments() : super(code: _code);

  /// Patterns that indicate hedging/uncertainty.
  static final _hedgingPatterns = [
    // Should/hopefully patterns
    RegExp(r'//\s*this\s+should\s+work', caseSensitive: false),
    RegExp(r'//\s*should\s+work', caseSensitive: false),
    RegExp(r'//\s*hopefully\s+this', caseSensitive: false),
    RegExp(r'//\s*hope\s+this\s+works', caseSensitive: false),
    RegExp(r'//\s*this\s+might\s+work', caseSensitive: false),
    RegExp(r'//\s*might\s+need\s+(to\s+)?(be\s+)?(adjust|change|fix|update)',
        caseSensitive: false),
    RegExp(r'//\s*may\s+need\s+(to\s+)?(be\s+)?(adjust|change|fix|update)',
        caseSensitive: false),

    // Think/believe patterns
    RegExp(r'//\s*i\s+think\s+this', caseSensitive: false),
    RegExp(r'//\s*i\s+believe\s+this', caseSensitive: false),
    RegExp(r'//\s*i\s+assume\s+this', caseSensitive: false),
    RegExp(r'//\s*i\'m\s+not\s+sure', caseSensitive: false),
    RegExp(r'//\s*not\s+sure\s+(if|whether|about)', caseSensitive: false),
    RegExp(r'//\s*not\s+entirely\s+sure', caseSensitive: false),
    RegExp(r'//\s*not\s+100%\s+sure', caseSensitive: false),

    // Probably patterns
    RegExp(r'//\s*probably\s+(correct|right|works|fine)', caseSensitive: false),
    RegExp(r'//\s*this\s+is\s+probably', caseSensitive: false),
    RegExp(r'//\s*this\s+probably', caseSensitive: false),

    // Maybe patterns
    RegExp(r'//\s*maybe\s+this', caseSensitive: false),
    RegExp(r'//\s*this\s+may\s+or\s+may\s+not', caseSensitive: false),

    // Guess patterns
    RegExp(r'//\s*i\s+guess', caseSensitive: false),
    RegExp(r'//\s*just\s+a\s+guess', caseSensitive: false),

    // Fix patterns revealing uncertainty
    RegExp(r'//\s*this\s+should\s+fix', caseSensitive: false),
    RegExp(r'//\s*hopefully\s+fixes', caseSensitive: false),
    RegExp(r'//\s*should\s+fix\s+the\s+(issue|bug|problem)',
        caseSensitive: false),

    // Seems patterns
    RegExp(r'//\s*seems\s+to\s+work', caseSensitive: false),
    RegExp(r'//\s*this\s+seems\s+(correct|right|ok)', caseSensitive: false),

    // Unsure patterns
    RegExp(r'//\s*unsure\s+(if|whether|about)', caseSensitive: false),
    RegExp(r'//\s*uncertain\s+(if|whether|about)', caseSensitive: false),

    // Try patterns (when used with uncertainty)
    RegExp(r'//\s*let\'?s?\s+try\s+this', caseSensitive: false),
    RegExp(r'//\s*try\s+this\s+and\s+see', caseSensitive: false),

    // Worth a try
    RegExp(r'//\s*worth\s+a\s+(try|shot)', caseSensitive: false),

    // Fingers crossed
    RegExp(r'//\s*fingers\s+crossed', caseSensitive: false),
    RegExp(r'//\s*pray\s+this\s+works', caseSensitive: false),
  ];

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addCompilationUnit((unit) {
      _checkComments(unit.beginToken, reporter);
    });
  }

  void _checkComments(Token? token, ErrorReporter reporter) {
    while (token != null && token.type != TokenType.EOF) {
      Token? comment = token.precedingComments;
      while (comment != null) {
        final commentText = comment.lexeme;

        // Check single-line comments
        if (commentText.startsWith('//')) {
          if (_isHedgingComment(commentText)) {
            reporter.atOffset(
              offset: comment.offset,
              length: comment.length,
              errorCode: _code,
            );
          }
        }

        comment = comment.next;
      }

      token = token.next;
    }
  }

  bool _isHedgingComment(String comment) {
    for (final pattern in _hedgingPatterns) {
      if (pattern.hasMatch(comment)) {
        return true;
      }
    }
    return false;
  }
}
