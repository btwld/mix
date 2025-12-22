import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Detects large blocks of commented-out code.
///
/// AI-generated code often preserves dead code in comments "just in case":
/// ```dart
/// // function oldImplementation() {
/// //   doSomething();
/// //   doSomethingElse();
/// // }
/// ```
///
/// Commented code should be deleted, not preserved.
/// Use version control to recover old implementations.
class DetectCommentedCode extends DartLintRule {
  static const _code = LintCode(
    name: 'ai_slop_commented_code',
    problemMessage:
        'Commented-out code detected. Delete it or use version control.',
    correctionMessage: 'Remove the commented code block.',
  );

  const DetectCommentedCode() : super(code: _code);

  /// Patterns that indicate commented-out code.
  static final _codePatterns = [
    // Function/method declarations
    RegExp(r'//\s*(void|int|String|bool|double|Future|async)\s+\w+\s*\('),
    RegExp(r'//\s*(final|var|const)\s+\w+\s*='),
    RegExp(r'//\s*class\s+\w+'),
    RegExp(r'//\s*if\s*\('),
    RegExp(r'//\s*for\s*\('),
    RegExp(r'//\s*while\s*\('),
    RegExp(r'//\s*return\s+'),
    RegExp(r'//\s*throw\s+'),
    RegExp(r'//\s*try\s*\{'),
    RegExp(r'//\s*catch\s*\('),
    RegExp(r'//\s*switch\s*\('),
    RegExp(r'//\s*case\s+'),
    RegExp(r'//\s*await\s+'),
    RegExp(r'//\s*import\s+[\'"]'),
    RegExp(r'//\s*export\s+'),
    RegExp(r'//\s*@\w+'),  // Annotations
    RegExp(r'//\s*\w+\.\w+\('),  // Method calls
    RegExp(r'//\s*\w+\s*=\s*\w+'),  // Assignments
    RegExp(r'//\s*\}$'),  // Closing brace
    RegExp(r'//\s*\{$'),  // Opening brace
  ];

  /// Minimum consecutive lines of commented code to flag.
  static const _minConsecutiveLines = 3;

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
    final commentGroups = <List<Token>>[];
    List<Token> currentGroup = [];
    int lastLine = -2;

    while (token != null && token.type != TokenType.EOF) {
      Token? comment = token.precedingComments;
      while (comment != null) {
        final commentText = comment.lexeme;

        // Only check single-line comments
        if (commentText.startsWith('//') && !commentText.startsWith('///')) {
          if (_looksLikeCode(commentText)) {
            final commentLine =
                token.charOffset; // Approximate, but close enough

            // Check if this continues a previous group
            if (lastLine >= 0 && (comment.offset - lastLine) < 200) {
              currentGroup.add(comment);
            } else {
              // Start a new group
              if (currentGroup.length >= _minConsecutiveLines) {
                commentGroups.add(List.from(currentGroup));
              }
              currentGroup = [comment];
            }
            lastLine = comment.offset;
          }
        }

        comment = comment.next;
      }

      token = token.next;
    }

    // Check the last group
    if (currentGroup.length >= _minConsecutiveLines) {
      commentGroups.add(currentGroup);
    }

    // Report each group
    for (final group in commentGroups) {
      if (group.isNotEmpty) {
        reporter.atOffset(
          offset: group.first.offset,
          length: group.last.end - group.first.offset,
          errorCode: _code,
        );
      }
    }
  }

  bool _looksLikeCode(String comment) {
    for (final pattern in _codePatterns) {
      if (pattern.hasMatch(comment)) {
        return true;
      }
    }
    return false;
  }
}
