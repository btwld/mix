import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';

import '../utils/type_helpers.dart';

/// Whether the consumer of a token reference belongs to Mix.
enum _Verdict {
  /// The consumer is a Mix API — the reference is handled correctly.
  mix,

  /// The consumer is provably not a Mix API — the reference escapes.
  notMix,

  /// The consumer could not be resolved — stay quiet.
  unknown,
}

class MixAvoidTokenRefOutsideMix extends AnalysisRule {
  static const LintCode code = LintCode(
    'mix_avoid_token_ref_outside_mix',
    'MixToken references must only be passed to Mix styling APIs.',
    correctionMessage:
        'A token reference (e.g. token() or token.mix()) is a sentinel that only '
        "resolves inside Mix's pipeline. Pass it to a Mix styler/utility, or use "
        'token.resolve(context) to read the concrete value.',
    severity: .WARNING,
  );

  MixAvoidTokenRefOutsideMix()
    : super(
        name: 'mix_avoid_token_ref_outside_mix',
        description:
            'Ensures MixToken references (call() and mix()) are only passed as '
            'arguments to Mix APIs. A reference passed to a non-Mix API (e.g. a '
            'plain Flutter widget) is an unresolved sentinel that causes silent '
            'bugs.',
      );

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this);
    registry.addFunctionExpressionInvocation(this, visitor);
    registry.addMethodInvocation(this, visitor);
  }

  @override
  LintCode get diagnosticCode => code;
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  const _Visitor(this.rule);

  /// Reports [callable] (a token reference expression) when it is passed as an
  /// argument to a non-Mix API. Stays silent when the reference is not an
  /// argument or when the consumer cannot be resolved.
  void _check(Expression callable) {
    final consumer = _enclosingConsumer(callable);
    if (consumer == null) return;

    switch (_classify(consumer)) {
      case .notMix:
        rule.reportAtNode(callable);
        break;
      case .mix:
      case .unknown:
        break;
    }
  }

  /// Walks up from [callable] to the innermost invocation it is an argument to,
  /// passing through enclosing collection literals. Returns null when a
  /// statement/declaration boundary is reached first (i.e. the reference is not
  /// in an argument position).
  AstNode? _enclosingConsumer(Expression callable) {
    AstNode? current = callable.parent;
    while (current != null &&
        current is! Statement &&
        current is! Declaration) {
      if (current is ArgumentList) {
        return current.parent;
      }
      // Keep climbing through collection literals (and their map entries) and
      // named-expression wrappers so list/set/map args are still attributed to
      // the enclosing invocation.
      current = current.parent;
    }

    return null;
  }

  _Verdict _classify(AstNode consumer) {
    if (consumer is InstanceCreationExpression) {
      return _verdictForType(consumer.staticType);
    }

    if (consumer is MethodInvocation) {
      // Instance receiver (e.g. `BoxStyler().color(...)`).
      final receiverType = consumer.target?.staticType;
      if (receiverType is InterfaceType) {
        if (isMixType(receiverType)) return .mix;

        // A resolved non-type receiver: judge by enclosing element below, but
        // a plain instance receiver that is not Mix is a clear escape.
        final enclosing = _enclosingVerdict(consumer.methodName.element);

        return enclosing == .mix ? .mix : .notMix;
      }

      // Static method (`EdgeInsetsGeometryMix.all(...)`) or top-level function.
      return _enclosingVerdict(consumer.methodName.element);
    }

    // A function-typed value is being invoked (e.g. a closure variable). We
    // cannot tell whether it came from Mix, so stay silent.
    return .unknown;
  }

  /// Classifies a callee [element] by its enclosing type, falling back to the
  /// declaring library URI for top-level functions.
  _Verdict _enclosingVerdict(Element? element) {
    if (element == null) return .unknown;

    final enclosing = element.enclosingElement;
    if (enclosing is InterfaceElement) {
      return isMixType(enclosing.thisType) ? .mix : .notMix;
    }

    // Top-level / free function: allow only when declared in `package:mix`.
    final uri = element.library?.uri;
    if (uri == null) return .unknown;

    return _isMixPackageUri(uri) ? .mix : .notMix;
  }

  _Verdict _verdictForType(DartType? type) {
    if (type is! InterfaceType) return .unknown;

    return isMixType(type) ? .mix : .notMix;
  }

  bool _isMixPackageUri(Uri uri) =>
      uri.scheme == 'package' &&
      uri.pathSegments.isNotEmpty &&
      uri.pathSegments.first == 'mix';

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    // Implicit call: `token()`, `ColorToken('x')()`.
    if (!isMixTokenType(node.function.staticType)) return;
    _check(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    // Explicit ref producers: `token.call()` and `token.mix()`.
    final name = node.methodName.name;
    if (name != 'call' && name != 'mix') return;
    if (!isMixTokenType(node.target?.staticType)) return;
    _check(node);
  }
}
