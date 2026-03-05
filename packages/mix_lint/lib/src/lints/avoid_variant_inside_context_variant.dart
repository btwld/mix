import 'package:analyzer/dart/ast/ast.dart';
// ignore: undefined_hidden_name
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../utils/type_checker.dart';
import '../utils/visitors.dart';

class AvoidVariantInsideContextVariant extends DartLintRule {
  static const _code = LintCode(
    name: 'mix_avoid_variant_inside_context_variant',
    problemMessage:
        'Ensure that Variants are not applied inside the ContextVariant scope but rather combined using the & operator.',
    errorSeverity: ErrorSeverity.ERROR,
  );

  const AvoidVariantInsideContextVariant() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addSimpleIdentifier((identifier) {
      if (identifier.staticType == null) return;
      if (!contextVariantChecker.isAssignableFromType(identifier.staticType!)) {
        return;
      }

      final parent = identifier.parent
          ?.thisOrAncestorOfType<FunctionExpressionInvocation>();

      if (parent == null) return;

      final simpleIdentifiers = <SimpleIdentifier>[];
      final visitor = RecursiveSimpleIdentifierVisitor(
        onVisitSimpleIdentifier: simpleIdentifiers.add,
      );
      parent.argumentList.accept(visitor);

      final types = simpleIdentifiers.where((i) {
        if (i.staticType == null) return false;

        return variantChecker.isAssignableFromType(i.staticType!);
      }).toList();

      if (types.isEmpty) return;

      for (final type in types) {
        reporter.atOffset(
          errorCode: _code,
          offset: type.offset,
          length: type.length,
        );
      }
    });
  }
}
