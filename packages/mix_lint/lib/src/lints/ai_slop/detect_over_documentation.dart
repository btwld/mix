import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Detects excessive documentation for trivial code.
///
/// AI-generated code often over-documents simple, self-explanatory functions:
/// ```dart
/// /// Adds two numbers together.
/// /// @param a - The first number to add
/// /// @param b - The second number to add
/// /// @returns The sum of a and b
/// int add(int a, int b) => a + b;
/// ```
///
/// When the documentation is longer than the code and adds no insight,
/// it's noise that clutters the codebase.
class DetectOverDocumentation extends DartLintRule {
  static const _code = LintCode(
    name: 'ai_slop_over_documentation',
    problemMessage:
        'Documentation is significantly longer than the code it describes. Consider simplifying.',
    correctionMessage:
        'Remove redundant documentation or make it more concise.',
  );

  const DetectOverDocumentation() : super(code: _code);

  /// Minimum ratio of doc lines to code lines to flag.
  static const _docToCodeRatio = 3.0;

  /// Minimum code length where this rule applies (very short functions).
  static const _maxTrivialCodeLength = 50;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    // Check function declarations
    context.registry.addFunctionDeclaration((node) {
      _checkDocumentation(
        node.documentationComment,
        node,
        reporter,
      );
    });

    // Check method declarations
    context.registry.addMethodDeclaration((node) {
      _checkDocumentation(
        node.documentationComment,
        node,
        reporter,
      );
    });
  }

  void _checkDocumentation(
    Comment? documentation,
    AstNode codeNode,
    ErrorReporter reporter,
  ) {
    if (documentation == null) return;

    // Get code length (excluding documentation)
    final codeStart = documentation.end;
    final codeEnd = codeNode.end;
    final codeLength = codeEnd - codeStart;

    // Only check trivial/short code
    if (codeLength > _maxTrivialCodeLength) return;

    // Count documentation lines
    final docLines = _countDocLines(documentation);

    // Calculate code lines (approximate)
    final lineInfo = codeNode.root.lineInfo;
    if (lineInfo == null) return;

    final codeStartLine = lineInfo.getLocation(codeStart).lineNumber;
    final codeEndLine = lineInfo.getLocation(codeEnd).lineNumber;
    final codeLines = codeEndLine - codeStartLine + 1;

    // Check ratio
    if (codeLines > 0 && docLines / codeLines > _docToCodeRatio) {
      // Check if documentation is mostly boilerplate
      if (_isBoilerplateDocumentation(documentation)) {
        reporter.atNode(documentation, _code);
      }
    }
  }

  int _countDocLines(Comment documentation) {
    int count = 0;
    for (final token in documentation.tokens) {
      // Count actual content lines (non-empty after stripping comment syntax)
      final content = token.lexeme
          .replaceAll(RegExp(r'^///\s*'), '')
          .replaceAll(RegExp(r'^\*\s*'), '')
          .trim();
      if (content.isNotEmpty) {
        count++;
      }
    }
    return count;
  }

  bool _isBoilerplateDocumentation(Comment documentation) {
    final fullText = documentation.tokens.map((t) => t.lexeme).join('\n');

    // Common boilerplate patterns
    final boilerplatePatterns = [
      // @param annotations for each parameter without additional insight
      RegExp(r'@param\s+\w+\s+-?\s*(The|A|An)\s+\w+', caseSensitive: false),
      // @returns that just say "Returns the result"
      RegExp(r'@returns?\s+(The\s+)?(result|value|output)',
          caseSensitive: false),
      // "This function/method does X" where X mirrors the name
      RegExp(r'(This\s+)?(function|method)\s+(that\s+)?\w+s?',
          caseSensitive: false),
    ];

    int boilerplateCount = 0;
    for (final pattern in boilerplatePatterns) {
      if (pattern.hasMatch(fullText)) {
        boilerplateCount++;
      }
    }

    // If most of the documentation is boilerplate
    return boilerplateCount >= 2;
  }
}
