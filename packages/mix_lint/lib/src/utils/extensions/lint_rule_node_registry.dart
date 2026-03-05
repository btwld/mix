import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'instance_creation_expression.dart';

extension LintRuleNodeRegistryExt on LintRuleNodeRegistry {
  void addInstanceCreationExpressionFor(
    TypeChecker checker,
    void Function(InstanceCreationExpression) listener,
  ) {
    addInstanceCreationExpression((node) {
      final type = node.staticType;
      if (type == null || //
          !checker.isAssignableFromType(type)) {
        return;
      }

      listener(node);
    });
  }

  void addFunctionExpressionInvocationFor(
    TypeChecker checker,
    void Function(FunctionExpressionInvocation) listener,
  ) {
    addFunctionExpressionInvocation((node) {
      final type = node.staticType;
      if (type == null || //
          !checker.isAssignableFromType(type)) {
        return;
      }

      listener(node);
    });
  }
}

extension CustomLintContextExt on CustomLintContext {
  void checkTypeHierarchyCompliance({
    required TypeChecker parent,
    required TypeChecker child,
    required ErrorReporter reporter,
    required ErrorCode code,
  }) {
    registry.addInstanceCreationExpressionFor(child, (node) {
      if (!node.isDecendentOf(parent)) return;

      reporter.atOffset(
        errorCode: code,
        offset: node.offset,
        length: node.length,
      );
    });
  }
}
