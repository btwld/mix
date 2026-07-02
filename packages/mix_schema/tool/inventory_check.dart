import 'dart:collection';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:mix_schema/src/inventory/schema_inventory_manifest.dart';

/// Manual drift probes before closing Phase 2:
///
/// - Delete one manifest entry and run
///   `dart run tool/inventory_check.dart --check`; the entry must be reported
///   under "Missing manifest entries".
/// - Add a throwaway public `$phase2Probe` field to any `packages/mix` styler
///   class in a local checkout and rerun the same command; the new id must be
///   reported under "Missing manifest entries". Do not commit the probe field.
///
/// Snapshot of data-bearing `package:mix` constructs relevant to `mix_schema`.
final class InventorySnapshot {
  InventorySnapshot({
    required Iterable<String> ids,
    required this.sourceRevision,
  }) : ids = List.unmodifiable(ids);

  /// Sorted stable inventory ids.
  final List<String> ids;

  /// Git revision used as provenance for generated reports.
  final String sourceRevision;
}

/// Result of comparing inventory ids to the checked-in manifest.
final class InventoryValidationResult {
  const InventoryValidationResult({
    required this.missingIds,
    required this.staleIds,
    required this.conflictingIds,
    required this.duplicateIds,
  });

  /// Inventory ids with no manifest classification.
  final List<String> missingIds;

  /// Manifest ids no longer present in the inventory.
  final List<String> staleIds;

  /// Manifest ids classified into more than one bucket.
  final List<String> conflictingIds;

  /// Manifest ids declared more than once.
  final List<String> duplicateIds;

  /// Whether the inventory and manifest match exactly.
  bool get isValid =>
      missingIds.isEmpty &&
      staleIds.isEmpty &&
      conflictingIds.isEmpty &&
      duplicateIds.isEmpty;

  /// Human-readable validation summary for tests and CI output.
  String describe() {
    if (isValid) return 'inventory manifest is exhaustive';

    final buffer = StringBuffer('inventory manifest drift detected');
    void writeGroup(String title, List<String> ids) {
      if (ids.isEmpty) return;
      buffer
        ..writeln()
        ..writeln()
        ..writeln(title);
      for (final id in ids) {
        buffer.writeln('  - $id');
      }
    }

    writeGroup('Missing manifest entries:', missingIds);
    writeGroup('Stale manifest entries:', staleIds);
    writeGroup('Conflicting manifest entries:', conflictingIds);
    writeGroup('Duplicate manifest entries:', duplicateIds);

    return buffer.toString();
  }
}

/// Collects a deterministic inventory from `packages/mix` at [repositoryRoot].
Future<InventorySnapshot> collectMixInventory({
  required Directory repositoryRoot,
}) async {
  final ids = SplayTreeSet<String>();
  final mixSourceRoot = Directory(
    '${repositoryRoot.path}/packages/mix/lib/src',
  );
  final schemaSourceRoot = Directory(
    '${repositoryRoot.path}/packages/mix_schema/lib/src/schema',
  );

  if (!mixSourceRoot.existsSync()) {
    throw StateError('Missing mix source root: ${mixSourceRoot.path}');
  }

  final mixFiles = _dartFiles(mixSourceRoot);
  final enumDeclarations = _collectEnumDeclarations(mixFiles);
  final classInheritance = _collectClassInheritance(mixFiles);
  final directiveClassNames = _collectDirectiveClassNames(classInheritance);

  for (final file in mixFiles) {
    final unit = parseString(
      content: file.readAsStringSync(),
      path: file.path,
      throwIfDiagnostics: false,
    ).unit;
    unit.accept(
      _MixInventoryVisitor(
        ids,
        enumDeclarations,
        directiveClassNames,
        file.path,
      ),
    );
  }

  _collectNamedCurves(schemaSourceRoot, ids);

  return InventorySnapshot(
    ids: ids,
    sourceRevision: await _sourceRevision(repositoryRoot),
  );
}

/// Validates that [manifestEntries] classify every [inventoryIds] entry once.
InventoryValidationResult validateManifest({
  required Iterable<String> inventoryIds,
  required Iterable<SchemaInventoryEntry> manifestEntries,
}) {
  final inventory = SplayTreeSet<String>.of(inventoryIds);
  final idsByStatus = <String, Set<SchemaInventoryStatus>>{};
  final idCounts = <String, int>{};
  for (final entry in manifestEntries) {
    idCounts.update(entry.id, (count) => count + 1, ifAbsent: () => 1);
    idsByStatus
        .putIfAbsent(entry.id, () => <SchemaInventoryStatus>{})
        .add(entry.status);
  }

  final manifestIds = SplayTreeSet<String>.of(idsByStatus.keys);
  final missingIds = SplayTreeSet<String>.of(inventory.difference(manifestIds));
  final staleIds = SplayTreeSet<String>.of(manifestIds.difference(inventory));
  final conflictingIds = SplayTreeSet<String>.of(
    idsByStatus.entries
        .where((entry) => entry.value.length > 1)
        .map((entry) => entry.key),
  );
  final duplicateIds = SplayTreeSet<String>.of(
    idCounts.entries
        .where((entry) => entry.value > 1)
        .map((entry) => entry.key),
  );

  return InventoryValidationResult(
    missingIds: missingIds.toList(growable: false),
    staleIds: staleIds.toList(growable: false),
    conflictingIds: conflictingIds.toList(growable: false),
    duplicateIds: duplicateIds.toList(growable: false),
  );
}

Future<void> main(List<String> args) async {
  final repositoryRoot = _argumentValue(args, '--repository-root') == null
      ? _findRepositoryRoot(Directory.current)
      : Directory(_argumentValue(args, '--repository-root')!);
  final snapshot = await collectMixInventory(repositoryRoot: repositoryRoot);
  final validation = validateManifest(
    inventoryIds: snapshot.ids,
    manifestEntries: schemaInventoryManifest,
  );

  if (args.contains('--list')) {
    stdout.write(snapshot.ids.join('\n'));
    stdout.writeln();
  }

  final backlogPath = _argumentValue(args, '--write-backlog');
  if (backlogPath != null) {
    if (!validation.isValid) {
      stderr.writeln(validation.describe());
      exitCode = 1;
      return;
    }

    final output = File(_resolvePath(repositoryRoot, backlogPath));
    output.parent.createSync(recursive: true);
    output.writeAsStringSync(_renderBacklog(snapshot, schemaInventoryManifest));
    stdout.writeln('wrote ${output.path}');
  }

  if (args.contains('--check') ||
      (!args.contains('--list') && backlogPath == null)) {
    if (!validation.isValid) {
      stderr.writeln(validation.describe());
      exitCode = 1;
      return;
    }

    stdout.writeln(
      'schema inventory ok: ${snapshot.ids.length} ids '
      '(${snapshot.sourceRevision})',
    );
  }
}

List<File> _dartFiles(Directory root) {
  return root
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));
}

Set<String> _collectEnumDeclarations(List<File> files) {
  final names = <String>{};
  for (final file in files) {
    final unit = parseString(
      content: file.readAsStringSync(),
      path: file.path,
      throwIfDiagnostics: false,
    ).unit;
    for (final declaration in unit.declarations) {
      if (declaration is EnumDeclaration) {
        names.add(_declarationName(declaration.namePart.toSource()));
      }
    }
  }

  return names;
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
            _typeNames(_inheritanceSource(declaration)).toSet();
      }
    }
  }

  return inheritanceByClass;
}

Set<String> _collectDirectiveClassNames(
  Map<String, Set<String>> inheritanceByClass,
) {
  final directiveClasses = <String>{'Directive'};
  var changed = true;
  while (changed) {
    changed = false;
    for (final entry in inheritanceByClass.entries) {
      if (directiveClasses.contains(entry.key)) continue;
      if (!entry.value.any(directiveClasses.contains)) continue;

      directiveClasses.add(entry.key);
      changed = true;
    }
  }

  return directiveClasses;
}

void _collectNamedCurves(Directory schemaSourceRoot, Set<String> ids) {
  final file = File('${schemaSourceRoot.path}/animation_codec.dart');
  if (!file.existsSync()) return;

  final content = file.readAsStringSync();
  final curvePattern = RegExp(r"'([^']+)'\s*:\s*Curves\.");
  for (final match in curvePattern.allMatches(content)) {
    ids.add('curve:${match.group(1)!}');
  }
}

final class _MixInventoryVisitor extends RecursiveAstVisitor<void> {
  _MixInventoryVisitor(
    this.ids,
    this.enumDeclarations,
    this.directiveClassNames,
    this.filePath,
  );

  final Set<String> ids;
  final Set<String> enumDeclarations;
  final Set<String> directiveClassNames;
  final String filePath;
  final List<String> _classStack = [];

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final name = _declarationName(node.namePart.toSource());
    if (name.startsWith('_')) return;

    final inheritance = _inheritanceSource(node);
    final isStyler =
        name.endsWith('Styler') && inheritance.contains('MixStyler');
    final isMixType =
        name.endsWith('Mix') &&
        (inheritance.contains(RegExp(r'\bMix\b')) ||
            inheritance.contains('Mix<') ||
            inheritance.contains('ModifierMix'));
    final isModifierMix =
        name.endsWith('ModifierMix') && inheritance.contains('ModifierMix');
    final isAnimationConfig =
        name != 'AnimationConfig' &&
        inheritance.contains(RegExp(r'\bAnimationConfig\b'));
    final isToken = name.endsWith('Token') && inheritance.contains('MixToken');
    final isVariant =
        name != 'Variant' &&
        (inheritance.contains(RegExp(r'\bVariant\b')) ||
            inheritance.contains('ContextVariant'));
    final isDirective =
        name != 'Directive' &&
        directiveClassNames.contains(name) &&
        node.abstractKeyword == null;

    if (isModifierMix) ids.add('modifier:$name');
    if (isAnimationConfig) ids.add('animation:$name');
    if (isToken) ids.add('token:$name');
    if (isVariant) ids.add('variant:$name');

    if (isStyler) {
      ids
        ..add('$name.\$variants')
        ..add('$name.\$modifier')
        ..add('$name.\$animation');
    }

    _classStack.add(name);
    final body = node.body;
    if (body is! BlockClassBody) {
      _classStack.removeLast();
      return;
    }

    if (isDirective) {
      ids.add('directive:${_extractDirectiveKey(body, name)}');
    }

    for (final member in body.members) {
      if (member is FieldDeclaration) {
        _collectFields(name, member, isStyler: isStyler, isMixType: isMixType);
      }
      member.accept(this);
    }
    _classStack.removeLast();
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    final className = _classStack.isEmpty ? null : _classStack.last;
    if (className != null &&
        node.isStatic &&
        (className == 'Variant' || className == 'ContextVariant')) {
      ids.add('variant_factory:$className.${node.name.lexeme}');
    }

    final parameters = node.parameters?.parameters ?? const <FormalParameter>[];
    for (final parameter in parameters) {
      _recordEnums(parameter.toSource());
    }

    super.visitMethodDeclaration(node);
  }

  void _collectFields(
    String className,
    FieldDeclaration member, {
    required bool isStyler,
    required bool isMixType,
  }) {
    final typeSource = member.fields.type?.toSource() ?? '';
    _recordEnums(typeSource);

    for (final variable in member.fields.variables) {
      final fieldName = variable.name.lexeme;
      if (!fieldName.startsWith(r'$')) continue;

      if (isStyler) {
        ids.add('$className.$fieldName');
      } else if (isMixType) {
        ids.add('mix:$className.$fieldName');
      } else if (className == 'WidgetModifierConfig') {
        ids.add('config:$className.$fieldName');
      }
    }
  }

  void _recordEnums(String typeSource) {
    final typeNames = _typeNames(typeSource);
    for (final typeName in typeNames) {
      if (enumDeclarations.contains(typeName) ||
          _flutterEnumFieldTypes.contains(typeName)) {
        ids.add('enum:$typeName');
      }
    }
  }

  String _extractDirectiveKey(BlockClassBody body, String className) {
    for (final member in body.members) {
      if (member is! MethodDeclaration ||
          !member.isGetter ||
          member.name.lexeme != 'key') {
        continue;
      }

      final key = _staticStringFromBody(member.body);
      if (key != null) return key;

      throw StateError(
        'Directive $className in $filePath must expose key as a static '
        'string literal.',
      );
    }

    throw StateError(
      'Directive $className in $filePath does not declare a key getter.',
    );
  }

  String? _staticStringFromBody(FunctionBody body) {
    if (body is ExpressionFunctionBody) {
      return _staticStringFromExpression(body.expression);
    }

    if (body is BlockFunctionBody) {
      for (final statement in body.block.statements) {
        if (statement is ReturnStatement) {
          return _staticStringFromExpression(statement.expression);
        }
      }
    }

    return null;
  }

  String? _staticStringFromExpression(Expression? expression) {
    if (expression is StringLiteral) return expression.stringValue;

    return null;
  }
}

String _inheritanceSource(ClassDeclaration node) {
  final parts = <String>[
    if (node.extendsClause != null) node.extendsClause!.toSource(),
    if (node.withClause != null) node.withClause!.toSource(),
    if (node.implementsClause != null) node.implementsClause!.toSource(),
  ];

  return parts.join(' ');
}

String _declarationName(String source) => source.split('<').first.trim();

Iterable<String> _typeNames(String source) {
  return RegExp(
    r'\b[A-Z][A-Za-z0-9_]*\b',
  ).allMatches(source).map((match) => match.group(0)!);
}

const _flutterEnumFieldTypes = <String>{
  'Axis',
  'BlendMode',
  'BorderStyle',
  'BoxFit',
  'BoxShape',
  'Brightness',
  'Clip',
  'CrossAxisAlignment',
  'FilterQuality',
  'FlexFit',
  'FontStyle',
  'FontWeight',
  'ImageRepeat',
  'MainAxisAlignment',
  'MainAxisSize',
  'Orientation',
  'StackFit',
  'TargetPlatform',
  'TextAlign',
  'TextBaseline',
  'TextDecorationStyle',
  'TextDirection',
  'TextLeadingDistribution',
  'TextOverflow',
  'TextWidthBasis',
  'TileMode',
  'VerticalDirection',
  'WidgetState',
};

Directory _findRepositoryRoot(Directory start) {
  var current = start;
  while (!File('${current.path}/melos.yaml').existsSync()) {
    final parent = current.parent;
    if (parent.path == current.path) {
      throw StateError('Could not find repository root from ${start.path}.');
    }
    current = parent;
  }

  return current;
}

String? _argumentValue(List<String> args, String name) {
  final index = args.indexOf(name);
  if (index == -1) return null;
  if (index + 1 >= args.length) {
    throw ArgumentError('Missing value for $name.');
  }

  return args[index + 1];
}

String _resolvePath(Directory repositoryRoot, String path) {
  if (path.startsWith('/')) return path;

  return '${repositoryRoot.path}/$path';
}

Future<String> _sourceRevision(Directory repositoryRoot) async {
  final result = await Process.run('git', [
    'rev-parse',
    'HEAD',
  ], workingDirectory: repositoryRoot.path);
  if (result.exitCode != 0) return 'unknown';

  return (result.stdout as String).trim();
}

String _renderBacklog(
  InventorySnapshot snapshot,
  Iterable<SchemaInventoryEntry> entries,
) {
  final entriesById = {
    for (final entry in entries)
      if (snapshot.ids.contains(entry.id)) entry.id: entry,
  };
  final supported = <SchemaInventoryEntry>[];
  final deferred = <SchemaInventoryEntry>[];
  final never = <SchemaInventoryEntry>[];

  for (final id in snapshot.ids) {
    final entry = entriesById[id];
    if (entry == null) continue;
    switch (entry.status) {
      case SchemaInventoryStatus.supported:
        supported.add(entry);
      case SchemaInventoryStatus.knownUnsupported:
        if ((entry.reason ?? '').startsWith('deferred:')) {
          deferred.add(entry);
        } else {
          never.add(entry);
        }
    }
  }

  final buffer = StringBuffer()
    ..writeln('# mix_schema coverage backlog')
    ..writeln()
    ..writeln('> Generated by `packages/mix_schema/tool/inventory_check.dart`.')
    ..writeln(
      '> Command: `dart run tool/inventory_check.dart --write-backlog plan/coverage-backlog.md`.',
    )
    ..writeln('> Source revision: `${snapshot.sourceRevision}`.')
    ..writeln(
      '> Manual curation: classifications come from `schemaInventoryManifest`; rows are not hand-edited.',
    )
    ..writeln()
    ..writeln('## Supported')
    ..writeln();
  _writeEntries(buffer, supported);
  buffer
    ..writeln()
    ..writeln('## Deferred')
    ..writeln();
  _writeEntries(buffer, deferred);
  buffer
    ..writeln()
    ..writeln('## Never / Explicitly Unsupported')
    ..writeln();
  _writeEntries(buffer, never);

  return buffer.toString();
}

void _writeEntries(StringBuffer buffer, List<SchemaInventoryEntry> entries) {
  entries.sort((a, b) => a.id.compareTo(b.id));
  if (entries.isEmpty) {
    buffer.writeln('_None._');
    return;
  }

  for (final entry in entries) {
    final suffix = switch (entry.status) {
      SchemaInventoryStatus.supported => 'since v${entry.since}',
      SchemaInventoryStatus.knownUnsupported => entry.reason!,
    };
    buffer.writeln('- `${entry.id}` — $suffix');
  }
}
