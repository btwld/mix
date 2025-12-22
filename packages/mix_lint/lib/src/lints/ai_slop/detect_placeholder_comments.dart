import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Detects placeholder comments that indicate incomplete code.
///
/// AI-generated code often leaves placeholder comments like:
/// - `// TODO: implement`
/// - `// FIXME: handle edge case`
/// - `// NOTE: temporary solution`
/// - `// HACK: workaround`
///
/// These indicate incomplete work that shouldn't be merged to production.
class DetectPlaceholderComments extends DartLintRule {
  static const _code = LintCode(
    name: 'ai_slop_placeholder_comments',
    problemMessage:
        'Placeholder comment indicates incomplete code. Complete the implementation before merging.',
    correctionMessage:
        'Implement the missing functionality or remove the placeholder.',
  );

  const DetectPlaceholderComments() : super(code: _code);

  /// Patterns that indicate placeholder/incomplete code.
  static final _placeholderPatterns = [
    // TODO patterns
    RegExp(r'//\s*TODO\s*:', caseSensitive: false),
    RegExp(r'//\s*TODO\s*$', caseSensitive: false),
    RegExp(r'//\s*TODO\s+implement', caseSensitive: false),
    RegExp(r'//\s*TODO\s+add', caseSensitive: false),
    RegExp(r'//\s*TODO\s+fix', caseSensitive: false),
    RegExp(r'//\s*TODO\s+handle', caseSensitive: false),

    // FIXME patterns
    RegExp(r'//\s*FIXME\s*:', caseSensitive: false),
    RegExp(r'//\s*FIXME\s*$', caseSensitive: false),
    RegExp(r'//\s*FIXME\s+', caseSensitive: false),

    // XXX patterns (common placeholder)
    RegExp(r'//\s*XXX\s*:', caseSensitive: false),
    RegExp(r'//\s*XXX\s*$', caseSensitive: false),
    RegExp(r'//\s*XXX\s+', caseSensitive: false),

    // HACK patterns
    RegExp(r'//\s*HACK\s*:', caseSensitive: false),
    RegExp(r'//\s*HACK\s*$', caseSensitive: false),
    RegExp(r'//\s*HACK\s+', caseSensitive: false),

    // Temporary patterns
    RegExp(r'//\s*temporary\s+(solution|fix|workaround|hack)',
        caseSensitive: false),
    RegExp(r'//\s*temp\s+(solution|fix|workaround|hack)', caseSensitive: false),

    // Implement later patterns
    RegExp(r'//\s*implement\s+later', caseSensitive: false),
    RegExp(r'//\s*add\s+later', caseSensitive: false),
    RegExp(r'//\s*fix\s+later', caseSensitive: false),
    RegExp(r'//\s*handle\s+later', caseSensitive: false),
    RegExp(r'//\s*do\s+later', caseSensitive: false),

    // Not implemented patterns
    RegExp(r'//\s*not\s+implemented', caseSensitive: false),
    RegExp(r'//\s*unimplemented', caseSensitive: false),
    RegExp(r'//\s*stub', caseSensitive: false),
    RegExp(r'//\s*placeholder', caseSensitive: false),

    // WIP patterns
    RegExp(r'//\s*WIP\s*:', caseSensitive: false),
    RegExp(r'//\s*WIP\s*$', caseSensitive: false),
    RegExp(r'//\s*work\s+in\s+progress', caseSensitive: false),

    // Needs patterns
    RegExp(r'//\s*needs\s+(to\s+be\s+)?(implement|fix|complet|add)',
        caseSensitive: false),

    // Missing patterns
    RegExp(r'//\s*missing\s+(implementation|logic|code|functionality)',
        caseSensitive: false),

    // Come back patterns
    RegExp(r'//\s*come\s+back\s+(to\s+)?this', caseSensitive: false),
    RegExp(r'//\s*revisit\s+(this|later)', caseSensitive: false),
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
          if (_isPlaceholderComment(commentText)) {
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

  bool _isPlaceholderComment(String comment) {
    for (final pattern in _placeholderPatterns) {
      if (pattern.hasMatch(comment)) {
        return true;
      }
    }
    return false;
  }
}
