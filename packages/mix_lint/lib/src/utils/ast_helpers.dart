import 'package:analyzer/dart/ast/ast.dart';

/// Collects the linear method chain directly following [root].
///
/// Stops when the chain branches into another context, such as an argument list.
List<MethodInvocation> collectDirectMethodChain(
  InstanceCreationExpression root,
) {
  final chain = <MethodInvocation>[];
  AstNode current = root;

  while (true) {
    final parent = current.parent;
    if (parent is! MethodInvocation || parent.target != current) break;

    chain.add(parent);
    current = parent;
  }

  return chain;
}

Iterable<AstNode> ancestorsBeforeStatementOrDeclaration(AstNode node) sync* {
  AstNode? current = node.parent;
  while (current != null && current is! Statement && current is! Declaration) {
    yield current;
    current = current.parent;
  }
}
