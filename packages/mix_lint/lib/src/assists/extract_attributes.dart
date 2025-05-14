import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../utils/extensions/dart_file_edit_builder.dart';
import '../utils/type_checker.dart';
import '../utils/visitors.dart';

class ExtractAttributes extends DartAssist {
  _AttributesExtractor? _getExtractionInfo(
    InstanceCreationExpression node,
    SourceRange target,
  ) {
    AstNode? ancestorNode;

    ancestorNode = node.thisOrAncestorMatching<Block>((node) {
      return node is Block;
    });

    if (ancestorNode is Block) {
      return _BlockExtractor(
        target: target,
        node: ancestorNode,
        extractedCodeName: _getNameForExtractedCode(node, target),
      );
    }

    ancestorNode = node.thisOrAncestorMatching<FieldDeclaration>((node) {
      return node is FieldDeclaration;
    });

    if (ancestorNode is FieldDeclaration) {
      return _FieldDeclarationExtractor(
        target: target,
        node: ancestorNode,
        extractedCodeName: _getNameForExtractedCode(node, target),
      );
    }

    ancestorNode = node.thisOrAncestorMatching<MethodDeclaration>((node) {
      return node is MethodDeclaration && node.isGetter;
    });

    if (ancestorNode is MethodDeclaration) {
      return _MethodDeclarationExtractor(
        target: target,
        node: ancestorNode,
        extractedCodeName: _getNameForExtractedCode(node, target),
      );
    }

    ancestorNode =
        node.thisOrAncestorMatching<TopLevelVariableDeclaration>((node) {
      return node is TopLevelVariableDeclaration;
    });

    if (ancestorNode is TopLevelVariableDeclaration) {
      return _TopLevelVariableDeclarationExtractor(
        target: target,
        node: ancestorNode,
        extractedCodeName: _getNameForExtractedCode(node, target),
      );
    }

    ancestorNode = node.thisOrAncestorMatching<FunctionDeclaration>((node) {
      return node is FunctionDeclaration && node.isGetter;
    });

    if (ancestorNode is FunctionDeclaration) {
      return _FunctionDeclarationExtractor(
        target: target,
        node: ancestorNode,
        extractedCodeName: _getNameForExtractedCode(node, target),
      );
    }

    return null;
  }

  String _getNameForExtractedCode(
    InstanceCreationExpression node,
    SourceRange target,
  ) {
    final functionExpression = <FunctionExpressionInvocation>[];
    final visitor = RecursiveFunctionExpressionInvocationVisitor(
      onVisitFunctionExpressionInvocation: functionExpression.add,
    );
    node.argumentList.accept(visitor);

    final variants = functionExpression
        .where(
          (e) =>
              variantAttributeChecker.isAssignableFromType(e.staticType!) &&
              e.sourceRange.covers(target),
        )
        .map((e) => e.function.endToken);

    if (variants.isEmpty) return 'extractedAttributes';

    return '${variants.last}Variant';
  }

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) async {
    final unit = await resolver.getResolvedUnitResult();

    context.registry.addInstanceCreationExpression((node) {
      if (!node.argumentList.sourceRange.covers(target)) return;
      if (node.staticType == null ||
          !styleChecker.isAssignableFromType(node.staticType!)) {
        return;
      }

      final extractor = _getExtractionInfo(node, target);
      if (extractor == null) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Extract Attributes',
        priority: 100,
      );

      changeBuilder.addDartFileEdit((builder) {
        extractor.builder = builder;

        try {
          extractor.applyRefactor(unit.content);
        } catch (e) {}
      });
    });
  }
}

abstract class _AttributesExtractor<T extends AstNode> {
  final SourceRange target;
  final T node;
  final String extractedCodeName;
  DartFileEditBuilder? builder;

  _AttributesExtractor({
    required this.target,
    required this.node,
    required this.extractedCodeName,
  });

  void applyRefactor(String content);
}

class _BlockExtractor extends _AttributesExtractor<Block> {
  _BlockExtractor({
    required super.target,
    required super.node,
    required super.extractedCodeName,
  });

  @override
  void applyRefactor(String content) {
    builder?.addSimpleReplacement(target, '$extractedCodeName(),');

    builder?.addSimpleInsertion(
      node.offset + 1,
      'final $extractedCodeName = Style(${content.substring(target.offset, target.end)});',
    );

    builder?.formatBasedOnAncestor<ClassDeclaration>(node);
  }
}

class _FieldDeclarationExtractor
    extends _AttributesExtractor<FieldDeclaration> {
  _FieldDeclarationExtractor({
    required super.target,
    required super.node,
    required super.extractedCodeName,
  });

  String reformatCode(String content) {
    return content.substring(node.offset, node.end).replaceRange(
          target.offset - node.offset,
          target.offset - node.offset + target.length,
          '$extractedCodeName(),',
        );
  }

  @override
  void applyRefactor(String content) {
    final newFieldCode = reformatCode(content);

    builder?.addReplacement(node.sourceRange, (builder) {
      builder.writeFieldDeclaration(
        extractedCodeName,
        initializerWriter: () {
          builder.write(
            'Style(${content.substring(target.offset, target.end)})',
          );
        },
        isFinal: true,
      );

      if (node.beginToken.toString() != 'late') {
        builder.write('late $newFieldCode');
      } else {
        builder.write(newFieldCode);
      }
    });

    builder?.formatBasedOnAncestor<ClassDeclaration>(node);
  }
}

class _MethodDeclarationExtractor
    extends _AttributesExtractor<MethodDeclaration> {
  _MethodDeclarationExtractor({
    required super.target,
    required super.node,
    required super.extractedCodeName,
  });

  @override
  void applyRefactor(String content) {
    builder?.addSimpleReplacement(target, '$extractedCodeName(),');

    builder?.addInsertion(node.offset, (builder) {
      builder.writeGetterDeclaration(
        extractedCodeName,
        bodyWriter: () {
          builder.write(
            '=> Style(${content.substring(target.offset, target.end)});',
          );
        },
      );
    });

    builder?.formatBasedOnAncestor<ClassDeclaration>(node);
  }
}

class _TopLevelVariableDeclarationExtractor
    extends _AttributesExtractor<TopLevelVariableDeclaration> {
  _TopLevelVariableDeclarationExtractor({
    required super.target,
    required super.node,
    required super.extractedCodeName,
  });

  String get privateExtractedCodeName => '_$extractedCodeName';

  String reformatCode(String content) {
    return content.substring(node.offset, node.end).replaceRange(
          target.offset - node.offset,
          target.offset - node.offset + target.length,
          '$privateExtractedCodeName(),',
        );
  }

  @override
  void applyRefactor(String content) {
    final newFieldCode = reformatCode(content);

    builder?.addReplacement(node.sourceRange, (builder) {
      builder.writeFieldDeclaration(
        privateExtractedCodeName,
        initializerWriter: () {
          builder.write(
            'Style(${content.substring(target.offset, target.end)})',
          );
        },
        isFinal: true,
      );

      builder.write(newFieldCode);
    });

    builder?.format(node.sourceRange);
  }
}

class _FunctionDeclarationExtractor
    extends _AttributesExtractor<FunctionDeclaration> {
  _FunctionDeclarationExtractor({
    required super.target,
    required super.node,
    required super.extractedCodeName,
  });

  String get privateExtractedCodeName => '_$extractedCodeName';

  @override
  void applyRefactor(String content) {
    builder?.addSimpleReplacement(target, '$privateExtractedCodeName(),');

    builder?.addInsertion(node.offset, (builder) {
      builder.writeGetterDeclaration(
        privateExtractedCodeName,
        bodyWriter: () {
          builder.write(
            '=> Style(${content.substring(target.offset, target.end)});',
          );
        },
      );
    });

    builder?.format(node.sourceRange);
  }
}
