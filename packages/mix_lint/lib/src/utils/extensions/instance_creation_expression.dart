import 'package:analyzer/dart/ast/ast.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension InstanceCreationExpressionExt on InstanceCreationExpression {
  bool isDecendentOf(TypeChecker parentTypeChecker) {
    final parentInstanceCreationExpression =
        parent?.thisOrAncestorOfType<InstanceCreationExpression>();
    if (parentInstanceCreationExpression == null) return false;

    final parentType = parentInstanceCreationExpression.staticType;

    if (parentType == null ||
        !parentTypeChecker.isAssignableFromType(parentType)) {
      return false;
    }

    return true;
  }
}
