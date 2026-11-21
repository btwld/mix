import 'dart:collection';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

/// Public styler classes and their declared `$` fields in one package surface.
final class StylerSurfaceSnapshot {
  /// Deterministically ordered styler-to-field inventory.
  final Map<String, Set<String>> fieldsByStyler;

  StylerSurfaceSnapshot(Map<String, Set<String>> fieldsByStyler)
    : fieldsByStyler = Map.unmodifiable({
        for (final entry in SplayTreeMap<String, Set<String>>.of(
          fieldsByStyler,
        ).entries)
          entry.key: Set.unmodifiable(SplayTreeSet<String>.of(entry.value)),
      });

  /// Public styler class names.
  Set<String> get stylerNames => fieldsByStyler.keys.toSet();
}

/// Collects the public Mix styler surface rooted at [sourceRoot].
StylerSurfaceSnapshot collectStylerSurface({required Directory sourceRoot}) {
  if (!sourceRoot.existsSync()) {
    throw StateError('Missing styler source root: ${sourceRoot.path}');
  }

  final files = _dartFiles(sourceRoot);
  final inheritance = _collectClassInheritance(files);
  final stylers = _subclassesOf(inheritance, 'MixStyler');
  final fieldsByStyler = <String, Set<String>>{};

  for (final file in files) {
    final unit = parseString(
      content: file.readAsStringSync(),
      path: file.path,
      throwIfDiagnostics: false,
    ).unit;
    for (final declaration in unit.declarations) {
      if (declaration is! ClassDeclaration) continue;
      final name = _declarationName(declaration.namePart.toSource());
      if (name.startsWith('_') || !stylers.contains(name)) continue;

      final fields = fieldsByStyler.putIfAbsent(name, () => <String>{});
      fields.addAll(const {'animation', 'modifier', 'variants'});
      final body = declaration.body;
      if (body is! BlockClassBody) continue;
      for (final member in body.members.whereType<FieldDeclaration>()) {
        for (final variable in member.fields.variables) {
          final fieldName = variable.name.lexeme;
          if (fieldName.startsWith(r'$')) fields.add(fieldName.substring(1));
        }
      }
    }
  }

  return StylerSurfaceSnapshot(fieldsByStyler);
}

/// Collects field metadata emitted into generated Styler classes.
StylerSurfaceSnapshot collectGeneratedStylerSurface({
  required Directory sourceRoot,
}) {
  if (!sourceRoot.existsSync()) {
    throw StateError(
      'Missing generated Styler source root: ${sourceRoot.path}',
    );
  }

  final fieldsByStyler = <String, Set<String>>{};
  for (final file in _dartFiles(sourceRoot)) {
    final unit = parseString(
      content: file.readAsStringSync(),
      path: file.path,
      throwIfDiagnostics: false,
    ).unit;
    for (final declaration in unit.declarations.whereType<ClassDeclaration>()) {
      final body = declaration.body;
      if (body is! BlockClassBody) continue;

      for (final member in body.members.whereType<MethodDeclaration>()) {
        if (!member.isGetter || member.name.lexeme != r'$stylerFieldNames') {
          continue;
        }
        final functionBody = member.body;
        final expression = functionBody is ExpressionFunctionBody
            ? functionBody.expression
            : null;
        if (expression is! SetOrMapLiteral) {
          throw StateError(
            '${declaration.namePart}.\$stylerFieldNames must use a set literal.',
          );
        }

        final fields = <String>{};
        for (final element in expression.elements) {
          if (element is! StringLiteral || element.stringValue == null) {
            throw StateError(
              '${declaration.namePart}.\$stylerFieldNames contains a '
              'non-string entry.',
            );
          }
          fields.add(element.stringValue!);
        }
        fieldsByStyler[_declarationName(declaration.namePart.toSource())] =
            fields;
      }
    }
  }

  return StylerSurfaceSnapshot(fieldsByStyler);
}

List<File> _dartFiles(Directory root) {
  return root
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList()
    ..sort((left, right) => left.path.compareTo(right.path));
}

Map<String, Set<String>> _collectClassInheritance(List<File> files) {
  final inheritanceByClass = <String, Set<String>>{};
  for (final file in files) {
    final unit = parseString(
      content: file.readAsStringSync(),
      path: file.path,
      throwIfDiagnostics: false,
    ).unit;
    for (final declaration in unit.declarations) {
      if (declaration is ClassDeclaration) {
        inheritanceByClass[_declarationName(declaration.namePart.toSource())] =
            _directSupertypeNames(declaration);
      }
    }
  }

  return inheritanceByClass;
}

Set<String> _subclassesOf(
  Map<String, Set<String>> inheritanceByClass,
  String base,
) {
  final classes = <String>{base};
  var changed = true;
  while (changed) {
    changed = false;
    for (final entry in inheritanceByClass.entries) {
      if (classes.contains(entry.key)) continue;
      if (!entry.value.any(classes.contains)) continue;

      classes.add(entry.key);
      changed = true;
    }
  }

  return classes..remove(base);
}

Set<String> _directSupertypeNames(ClassDeclaration node) {
  return {
    if (node.extendsClause != null)
      _declarationName(node.extendsClause!.superclass.toSource()),
    if (node.withClause != null)
      for (final type in node.withClause!.mixinTypes)
        _declarationName(type.toSource()),
    if (node.implementsClause != null)
      for (final type in node.implementsClause!.interfaces)
        _declarationName(type.toSource()),
  };
}

String _declarationName(String source) => source.split('<').first.trim();
