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
  /// The consumer is a Mix API, so the reference resolves.
  mix,

  /// The consumer is provably not a Mix API, so the reference escapes.
  notMix,

  /// The consumer could not be resolved, so stay quiet.
  unknown,
}

/// Reports a token reference (`token()`, `token.call()`, or `token.mix()`)
/// passed to an API outside Mix, where it never resolves.
///
/// Only APIs from other packages, such as Flutter widgets or `dart:core`, are
/// reported. Code in the analyzed package may forward the value into Mix, so
/// the rule stays silent for it.
class TokenReferenceOutsideMix extends AnalysisRule {
  static const LintCode code = LintCode(
    'token_reference_outside_mix',
    'A token reference is passed to an API outside Mix, where it never '
        'resolves.',
    correctionMessage:
        'Try passing it to a Mix Styler or value, or use '
        "'token.resolve(context)' to read the value.",
    severity: .WARNING,
  );

  TokenReferenceOutsideMix()
    : super(
        name: 'token_reference_outside_mix',
        description:
            "Don't pass token references to APIs outside Mix. They only "
            'resolve inside Mix styles.',
      );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry
      ..addFunctionExpressionInvocation(this, visitor)
      ..addMethodInvocation(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final RuleContext context;

  const _Visitor(this.rule, this.context);

  /// Reports [reference] when it is passed as an argument to a non-Mix API.
  /// Stays silent when the reference is not an argument or when the consumer
  /// cannot be resolved.
  void _check(Expression reference) {
    final consumer = _enclosingConsumer(reference);
    if (consumer == null) return;

    if (_classify(consumer) == .notMix) {
      rule.reportAtNode(reference);
    }
  }

  /// Walks up from [reference] to the innermost invocation it is an argument
  /// to, passing through collection literals and named arguments. Returns null
  /// when a statement, declaration, or function body comes first.
  AstNode? _enclosingConsumer(Expression reference) {
    AstNode? current = reference.parent;
    while (current != null &&
        current is! Statement &&
        current is! Declaration &&
        current is! FunctionBody) {
      if (current is ArgumentList) return current.parent;
      current = current.parent;
    }

    return null;
  }

  _Verdict _classify(AstNode consumer) {
    if (consumer is InstanceCreationExpression) {
      final type = consumer.staticType;
      if (type is InterfaceType && _isInAnalyzedPackage(type.element)) {
        return .unknown;
      }

      return _verdictForType(type);
    }

    if (consumer is MethodInvocation) {
      final element = consumer.methodName.element;
      // Any API that Mix declares knows how to resolve references, including
      // plain classes such as GridTrack and WidgetModifierConfig.
      if (isFromMix(element)) return .mix;
      if (_isInAnalyzedPackage(element)) return .unknown;

      // Instance receiver, for example `BoxStyler().color(...)`. realTarget
      // also covers cascades such as `BoxStyler()..color(...)`.
      final receiverType = consumer.realTarget?.staticType;
      if (receiverType is InterfaceType) {
        return isMixType(receiverType) ? .mix : .notMix;
      }

      // Static method or top-level function.
      return _verdictForElement(element);
    }

    // A function-typed value is invoked, for example a closure variable. Its
    // origin is unknown, so stay silent.
    return .unknown;
  }

  /// Returns true if [element] is declared in the package being analyzed.
  bool _isInAnalyzedPackage(Element? element) {
    final library = element?.library;
    if (library == null) return false;

    return context.package?.contains(library.firstFragment.source) ?? false;
  }

  /// Classifies a static method or top-level function by its declaring type.
  _Verdict _verdictForElement(Element? element) {
    if (element == null) return .unknown;

    final enclosing = element.enclosingElement;
    if (enclosing is InterfaceElement) {
      return isMixType(enclosing.thisType) ? .mix : .notMix;
    }

    return element.library == null ? .unknown : .notMix;
  }

  _Verdict _verdictForType(DartType? type) {
    if (type is! InterfaceType) return .unknown;

    return isFromMix(type.element) || isMixType(type) ? .mix : .notMix;
  }

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    // Implicit call: `token()` or `ColorToken('x')()`.
    if (!isMixTokenType(node.function.staticType)) return;
    _check(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    // Explicit reference producers: `token.call()` and `token.mix()`.
    final name = node.methodName.name;
    if (name != 'call' && name != 'mix') return;
    if (!isMixTokenType(node.target?.staticType)) return;
    _check(node);
  }
}
