import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Detects obvious comments that merely restate what the code does.
///
/// AI-generated code often includes comments like:
/// - `counter++;  // Increment counter`
/// - `return result;  // Return the result`
/// - `for item in items:  // Loop through items`
///
/// These add no value and clutter the code.
class DetectObviousComments extends DartLintRule {
  static const _code = LintCode(
    name: 'ai_slop_obvious_comments',
    problemMessage:
        'This comment restates what the code already expresses. Consider removing it.',
    correctionMessage: 'Remove the obvious comment.',
  );

  const DetectObviousComments() : super(code: _code);

  /// Patterns that indicate an obvious comment.
  /// These are common AI-generated comment patterns.
  static final _obviousPatterns = [
    // Direct restatements
    RegExp(r'^\s*//\s*(increment|decrement)\s+\w+\s*$', caseSensitive: false),
    RegExp(r'^\s*//\s*return(s|ing)?\s+(the\s+)?result\s*$',
        caseSensitive: false),
    RegExp(r'^\s*//\s*loop(s|ing)?\s+(through|over)\s+\w+\s*$',
        caseSensitive: false),
    RegExp(r'^\s*//\s*iterate(s)?\s+(through|over)\s+\w+\s*$',
        caseSensitive: false),
    RegExp(r'^\s*//\s*set(s|ting)?\s+\w+\s+(to|=)\s+\w+\s*$',
        caseSensitive: false),
    RegExp(r'^\s*//\s*get(s|ting)?\s+(the\s+)?\w+\s*$', caseSensitive: false),
    RegExp(r'^\s*//\s*create(s)?\s+(a\s+)?(new\s+)?\w+\s*$',
        caseSensitive: false),
    RegExp(r'^\s*//\s*call(s|ing)?\s+\w+\s*$', caseSensitive: false),
    RegExp(r'^\s*//\s*check(s|ing)?\s+(if|whether)\s+\w+\s*$',
        caseSensitive: false),
    RegExp(r'^\s*//\s*initialize(s)?\s+\w+\s*$', caseSensitive: false),
    RegExp(r'^\s*//\s*add(s|ing)?\s+\w+\s+(to\s+)?\w*\s*$',
        caseSensitive: false),
    RegExp(r'^\s*//\s*remove(s|ing)?\s+\w+\s+(from\s+)?\w*\s*$',
        caseSensitive: false),
    RegExp(r'^\s*//\s*update(s|ing)?\s+(the\s+)?\w+\s*$', caseSensitive: false),
    RegExp(r'^\s*//\s*delete(s|ing)?\s+(the\s+)?\w+\s*$', caseSensitive: false),
    RegExp(r'^\s*//\s*assign(s|ing)?\s+\w+\s*$', caseSensitive: false),
    RegExp(r'^\s*//\s*define(s)?\s+(a\s+)?\w+\s*$', caseSensitive: false),
    RegExp(r'^\s*//\s*declare(s)?\s+(a\s+)?\w+\s*$', caseSensitive: false),
    RegExp(r'^\s*//\s*constructor\s*$', caseSensitive: false),
    RegExp(r'^\s*//\s*getter(s)?\s*$', caseSensitive: false),
    RegExp(r'^\s*//\s*setter(s)?\s*$', caseSensitive: false),
    RegExp(r'^\s*//\s*default\s+(value|case)\s*$', caseSensitive: false),
    RegExp(r'^\s*//\s*else\s+(case|block|branch)\s*$', caseSensitive: false),
    RegExp(r'^\s*//\s*if\s+(condition|statement)\s*$', caseSensitive: false),
    RegExp(r'^\s*//\s*switch\s+(statement|case)\s*$', caseSensitive: false),
    RegExp(r'^\s*//\s*import(s)?\s+\w+\s*$', caseSensitive: false),
    RegExp(r'^\s*//\s*export(s)?\s+\w+\s*$', caseSensitive: false),
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

        // Only check single-line comments
        if (commentText.startsWith('//')) {
          if (_isObviousComment(commentText)) {
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

  bool _isObviousComment(String comment) {
    for (final pattern in _obviousPatterns) {
      if (pattern.hasMatch(comment)) {
        return true;
      }
    }
    return false;
  }
}
