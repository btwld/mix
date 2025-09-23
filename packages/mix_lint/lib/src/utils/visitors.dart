import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class RecursiveSimpleIdentifierVisitor extends RecursiveAstVisitor<void> {
  final void Function(SimpleIdentifier node) onVisitSimpleIdentifier;

  const RecursiveSimpleIdentifierVisitor({
    required this.onVisitSimpleIdentifier,
  });

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    onVisitSimpleIdentifier(node);
    node.visitChildren(this);
  }
}

class RecursiveFunctionExpressionInvocationVisitor
    extends RecursiveAstVisitor<void> {
  final void Function(FunctionExpressionInvocation node)
      onVisitFunctionExpressionInvocation;

  const RecursiveFunctionExpressionInvocationVisitor({
    required this.onVisitFunctionExpressionInvocation,
  });

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    onVisitFunctionExpressionInvocation(node);
    node.visitChildren(this);
  }
}
