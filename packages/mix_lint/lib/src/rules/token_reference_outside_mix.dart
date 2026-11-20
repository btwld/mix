import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';

import '../utils/type_helpers.dart';

/// Color methods that a color token reference keeps as directives.
const _colorDirectives = {
  'withValues',
  'withAlpha',
  'withRed',
  'withGreen',
  'withBlue',
  'withOpacity',
};

/// A verdict on whether the consumer of a token reference belongs to Mix.
enum _Verdict {
  /// The consumer is a Mix API, so the reference resolves.
  mix,

  /// The consumer is provably not a Mix API, so the reference escapes.
  notMix,

  /// The consumer could not be resolved, so stay quiet.
  unknown,
}

/// A rule that reports a token reference passed to an API from another
/// package, where it never resolves.
///
/// A token reference is `token()`, `token.call()`, or `token.mix()`.
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
  ///
  /// Stays silent when the reference is not an argument or when the consumer
  /// cannot be resolved.
  void _check(Expression reference) {
    final consumer = _enclosingConsumer(reference);
    if (consumer == null || _classify(consumer) != .notMix) return;
    // Mix's `.value()` conversions, such as `TextStyleMix.value(...)`, copy a
    // Flutter value field by field, so a reference inside it resolves if it
    // gets there unchanged. `$space() * 2` is a plain number.
    if (_reachesUnchanged(reference, consumer) &&
        _reachesMixConversion(consumer)) {
      return;
    }
    rule.reportAtNode(reference);
  }

  /// Whether [reference] reaches [consumer] as a reference, directly or
  /// through a color method that Mix keeps as a directive, such as
  /// `withValues`.
  bool _reachesUnchanged(Expression reference, AstNode consumer) {
    var value = reference;
    for (
      var call = value.parent;
      call is MethodInvocation &&
          call.target == value &&
          _colorDirectives.contains(call.methodName.name);
      call = value.parent
    ) {
      value = call;
    }

    return _directConsumer(value) == consumer;
  }

  /// Whether [value], a Flutter value such as `TextStyle(...)`, is passed to
  /// a Mix `.value()` conversion, directly or inside other Flutter values.
  bool _reachesMixConversion(AstNode value) {
    if (value is! InstanceCreationExpression &&
        value is! DotShorthandConstructorInvocation) {
      return false;
    }
    final type = (value as Expression).staticType;
    if (isFlutterWidgetType(type)) return false;
    final outer = _directConsumer(value);
    if (outer == null) return false;
    if (_isMixConversion(outer)) return true;

    // A conversion converts a nested value only through its Mix value type,
    // such as ShadowMix for the shadows of a TextStyle. It copies other
    // values, such as FontVariation, whole.
    return _hasMixValueType(type) &&
        _classify(outer) == .notMix &&
        _reachesMixConversion(outer);
  }

  /// Whether a Mix value type for [type] is visible in this library, such as
  /// `ShadowMix` for `Shadow`.
  bool _hasMixValueType(DartType? type) {
    final library = context.libraryElement;
    if (type is! InterfaceType || library == null) return false;
    final name = '${type.element.name}Mix';
    final libraries = [
      library,
      ...library.fragments.expand((fragment) => fragment.importedLibraries),
    ];

    return libraries.any((candidate) {
      final element = candidate.exportNamespace.get2(name);

      return element is InterfaceElement && isMixType(element.thisType);
    });
  }

  /// Whether [node] calls `value` or `maybeValue` on a Mix value type, such
  /// as `TextStyleMix.value(...)`.
  ///
  /// `Prop.value` stores its argument whole, so it doesn't count.
  bool _isMixConversion(AstNode node) {
    final (name, element) = switch (node) {
      InstanceCreationExpression(:final constructorName) => (
        constructorName.name?.name,
        constructorName.element,
      ),
      DotShorthandConstructorInvocation(:final constructorName) => (
        constructorName.name,
        constructorName.element,
      ),
      MethodInvocation(:final methodName) ||
      DotShorthandInvocation(
        memberName: final methodName,
      ) => (methodName.name, methodName.element),
      _ => (null, null),
    };

    if (name != 'value' && name != 'maybeValue') return false;
    final owner = element?.enclosingElement;

    return owner is InterfaceElement && isMixType(owner.thisType);
  }

  /// The invocation that [value] is passed to directly, possibly as a named
  /// argument or inside a collection literal, or null.
  AstNode? _directConsumer(Expression value) {
    var current = value.parent;
    while (current is NamedArgument ||
        current is ParenthesizedExpression ||
        current is ConditionalExpression ||
        current is SwitchExpressionCase ||
        current is SwitchExpression ||
        current is ListLiteral ||
        current is SetOrMapLiteral ||
        current is MapLiteralEntry ||
        current is IfElement ||
        current is ForElement ||
        current is SpreadElement) {
      current = current?.parent;
    }

    return current is ArgumentList ? current.parent : null;
  }

  /// The innermost invocation whose arguments contain [reference], or null
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
    // `Type(...)`, `Type.named(...)`, and `.named(...)`.
    if (consumer is InstanceCreationExpression ||
        consumer is DotShorthandConstructorInvocation) {
      final type = (consumer as Expression).staticType;
      if (type is InterfaceType && _isInAnalyzedPackage(type.element)) {
        return .unknown;
      }

      return _verdictForType(type);
    }

    // A static method through a dot shorthand, such as `.all(...)`.
    if (consumer is DotShorthandInvocation) {
      final element = consumer.memberName.element;
      if (isFromMix(element)) return .mix;
      if (_isInAnalyzedPackage(element)) return .unknown;

      return _verdictForElement(element);
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

  /// Whether [element] is declared in the package being analyzed.
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
