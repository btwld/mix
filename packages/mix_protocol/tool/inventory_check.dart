import 'dart:collection';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:mix_protocol/src/inventory/schema_inventory_manifest.dart';

/// Manual inventory drift probes:
///
/// - Delete one manifest entry and run
///   `dart run tool/inventory_check.dart --check`; the entry must be reported
///   under "Missing manifest entries".
/// - Add a throwaway public `$inventoryProbe` field to any `packages/mix` styler
///   class in a local checkout and rerun the same command; the new id must be
///   reported under "Missing manifest entries". Do not commit the probe field.
///
/// Snapshot of data-bearing `package:mix` constructs relevant to `mix_protocol`.
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
    '${repositoryRoot.path}/packages/mix_protocol/lib/src/schema',
  );

  if (!mixSourceRoot.existsSync()) {
    throw StateError('Missing mix source root: ${mixSourceRoot.path}');
  }

  final mixFiles = _dartFiles(mixSourceRoot);
  final enumDeclarations = _collectEnumDeclarations(mixFiles);
  final classInheritance = _collectClassInheritance(mixFiles);
  final trackedClasses = _TrackedClassSets.fromInheritance(classInheritance);

  for (final file in mixFiles) {
    final unit = parseString(
      content: file.readAsStringSync(),
      path: file.path,
      throwIfDiagnostics: false,
    ).unit;
    unit.accept(
      _MixInventoryVisitor(ids, enumDeclarations, trackedClasses, file.path),
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

/// Collects styler owner-field ids that have an encode/decode field declared.
Set<String> collectDeclaredStylerCodecFieldIds({
  required Directory repositoryRoot,
}) {
  final schemaSourceRoot = Directory(
    '${repositoryRoot.path}/packages/mix_protocol/lib/src/schema',
  );
  if (!schemaSourceRoot.existsSync()) return const {};

  final ids = SplayTreeSet<String>();
  for (final file in _dartFiles(schemaSourceRoot)) {
    if (!file.path.endsWith('_styler_codec.dart')) continue;
    final unit = parseString(
      content: file.readAsStringSync(),
      path: file.path,
      throwIfDiagnostics: false,
    ).unit;
    final visitor = _StylerCodecFieldVisitor();
    unit.accept(visitor);
    ids.addAll(visitor.ids);
  }

  return ids;
}

/// Supported styler-field manifest ids that do not have a declared codec field.
List<String> supportedStylerFieldsWithoutCodec({
  required Iterable<SchemaInventoryEntry> manifestEntries,
  required Iterable<String> declaredCodecFieldIds,
}) {
  final declared = declaredCodecFieldIds.toSet();

  return SplayTreeSet<String>.of(
    manifestEntries
        .where((entry) => entry.status == SchemaInventoryStatus.supported)
        .map((entry) => entry.id)
        .where(_isStylerFieldId)
        .where((id) => !declared.contains(id)),
  ).toList(growable: false);
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
  final supportedFieldsWithoutCodec = supportedStylerFieldsWithoutCodec(
    manifestEntries: schemaInventoryManifest,
    declaredCodecFieldIds: collectDeclaredStylerCodecFieldIds(
      repositoryRoot: repositoryRoot,
    ),
  );

  if (args.contains('--list')) {
    stdout.write(snapshot.ids.join('\n'));
    stdout.writeln();
  }

  final backlogPath = _argumentValue(args, '--write-backlog');
  if (backlogPath != null) {
    if (!validation.isValid || supportedFieldsWithoutCodec.isNotEmpty) {
      _writeValidationFailures(validation, supportedFieldsWithoutCodec);
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
    if (!validation.isValid || supportedFieldsWithoutCodec.isNotEmpty) {
      _writeValidationFailures(validation, supportedFieldsWithoutCodec);
      exitCode = 1;
      return;
    }

    stdout.writeln(
      'schema inventory ok: ${snapshot.ids.length} ids '
      '(${snapshot.sourceRevision})',
    );
  }
}

void _writeValidationFailures(
  InventoryValidationResult validation,
  List<String> supportedFieldsWithoutCodec,
) {
  if (!validation.isValid) {
    stderr.writeln(validation.describe());
  }
  if (supportedFieldsWithoutCodec.isEmpty) return;

  stderr
    ..writeln('supported styler-field entries without declared codec fields:')
    ..writeln();
  for (final id in supportedFieldsWithoutCodec) {
    stderr.writeln('  - $id');
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
            _directSupertypeNames(declaration);
      }
    }
  }

  return inheritanceByClass;
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
    this.trackedClasses,
    this.filePath,
  );

  final Set<String> ids;
  final Set<String> enumDeclarations;
  final _TrackedClassSets trackedClasses;
  final String filePath;
  final List<String> _classStack = [];

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final name = _declarationName(node.namePart.toSource());
    if (name.startsWith('_')) return;

    final isStyler = trackedClasses.mixStylers.contains(name);
    final isMixType =
        name.endsWith('Mix') && trackedClasses.mixTypes.contains(name);
    final isStyle =
        !isStyler &&
        node.abstractKeyword == null &&
        trackedClasses.styles.contains(name);
    final isModifierMix = trackedClasses.modifierMixes.contains(name);
    final isAnimationConfig = trackedClasses.animationConfigs.contains(name);
    final isToken = trackedClasses.tokens.contains(name);
    final isVariant = trackedClasses.variants.contains(name);
    final isDirective =
        name != 'Directive' &&
        trackedClasses.directives.contains(name) &&
        node.abstractKeyword == null;

    if (isStyle) ids.add('style:$name');
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
      } else if (_looksLikeUnknownEnumType(typeName)) {
        throw StateError(
          'Inventory found unknown enum-like type $typeName in $filePath. '
          'Declare local enums in source, or add Flutter enum types to '
          '_flutterEnumFieldTypes with a manifest decision.',
        );
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

final class _TrackedClassSets {
  const _TrackedClassSets({
    required this.styles,
    required this.mixStylers,
    required this.mixTypes,
    required this.modifierMixes,
    required this.directives,
    required this.variants,
    required this.animationConfigs,
    required this.tokens,
  });

  factory _TrackedClassSets.fromInheritance(
    Map<String, Set<String>> inheritanceByClass,
  ) {
    final mixStylers = _subclassesOf(inheritanceByClass, 'MixStyler');

    return _TrackedClassSets(
      styles: _subclassesOf(inheritanceByClass, 'Style')..removeAll(mixStylers),
      mixStylers: mixStylers,
      mixTypes: _subclassesOf(inheritanceByClass, 'Mix'),
      modifierMixes: _subclassesOf(inheritanceByClass, 'ModifierMix'),
      directives: _subclassesOf(inheritanceByClass, 'Directive'),
      variants: _subclassesOf(inheritanceByClass, 'Variant'),
      animationConfigs: _subclassesOf(inheritanceByClass, 'AnimationConfig'),
      tokens: _subclassesOf(inheritanceByClass, 'MixToken'),
    );
  }

  final Set<String> styles;
  final Set<String> mixStylers;
  final Set<String> mixTypes;
  final Set<String> modifierMixes;
  final Set<String> directives;
  final Set<String> variants;
  final Set<String> animationConfigs;
  final Set<String> tokens;
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

final class _StylerCodecFieldVisitor extends RecursiveAstVisitor<void> {
  final ids = SplayTreeSet<String>();
  final _fieldInventoryByVariable = <String, String>{};

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    final inventoryName = _schemaFieldInventoryName(node.initializer);
    if (inventoryName != null) {
      _fieldInventoryByVariable[node.name.lexeme] = inventoryName;
    }

    super.visitVariableDeclaration(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final owner = _schemaObjectOwner(node.constructorName.toSource());
    if (owner != null) _recordSchemaObjectFields(owner, node.argumentList);

    super.visitInstanceCreationExpression(node);
  }

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    final owner = _schemaObjectOwner(node.toSource());
    if (owner != null) _recordSchemaObjectFields(owner, node.argumentList);

    super.visitFunctionExpressionInvocation(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final owner = _schemaObjectOwner(node.toSource());
    if (owner != null) _recordSchemaObjectFields(owner, node.argumentList);

    super.visitMethodInvocation(node);
  }

  void _recordSchemaObjectFields(String owner, ArgumentList argumentList) {
    final fields = _namedArgument(argumentList, 'fields');
    if (fields is ListLiteral) {
      for (final element in fields.elements) {
        if (element is SimpleIdentifier) {
          final inventoryName = _fieldInventoryByVariable[element.name];
          if (inventoryName != null) ids.add('$owner.\$$inventoryName');
        } else if (element is SpreadElement &&
            element.expression.toSource().endsWith('.fields')) {
          ids
            ..add('$owner.\$animation')
            ..add('$owner.\$modifier')
            ..add('$owner.\$variants');
        }
      }
    }
  }
}

String? _schemaFieldInventoryName(Expression? expression) {
  final arguments = _argumentList(expression);
  if (arguments == null) return null;

  final source = expression!.toSource();
  if (!RegExp(
    r'^(valueField|propValueField|propValueAsField|tokenValueField|propTokenValueField|mixField|propMixField|tokenMixField|propTokenMixField|directField|derivedField)(<|\()',
  ).hasMatch(source)) {
    return null;
  }

  return _namedStringArgument(arguments, 'inventoryName') ??
      _firstPositionalStringArgument(arguments);
}

ArgumentList? _argumentList(Expression? expression) {
  return switch (expression) {
    MethodInvocation(:final argumentList) => argumentList,
    FunctionExpressionInvocation(:final argumentList) => argumentList,
    _ => null,
  };
}

Expression? _namedArgument(ArgumentList argumentList, String name) {
  for (final argument in argumentList.arguments) {
    if (argument is NamedExpression && argument.name.label.name == name) {
      return argument.expression;
    }
  }

  return null;
}

String? _namedStringArgument(ArgumentList argumentList, String name) {
  final argument = _namedArgument(argumentList, name);

  return argument is StringLiteral ? argument.stringValue : null;
}

String? _firstPositionalStringArgument(ArgumentList argumentList) {
  for (final argument in argumentList.arguments) {
    if (argument is NamedExpression) continue;

    return argument is StringLiteral ? argument.stringValue : null;
  }

  return null;
}

String? _schemaObjectOwner(String constructorSource) {
  final match = RegExp(r'^SchemaObject<([^>]+)>').firstMatch(constructorSource);

  return match?.group(1);
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

Iterable<String> _typeNames(String source) {
  return RegExp(
    r'\b[A-Z][A-Za-z0-9_]*\b',
  ).allMatches(source).map((match) => match.group(0)!);
}

bool _looksLikeUnknownEnumType(String typeName) {
  return typeName != 'Enum' &&
      (typeName.endsWith('Enum') ||
          _flutterEnumLikeFieldTypes.contains(typeName));
}

bool _isStylerFieldId(String id) {
  return RegExp(r'^[A-Za-z][A-Za-z0-9]*Styler\.\$').hasMatch(id);
}

const _flutterEnumLikeFieldTypes = <String>{
  'AutofillContextAction',
  'FloatingLabelAlignment',
  'FloatingLabelBehavior',
  'SmartDashesType',
  'SmartQuotesType',
  'TextAffinity',
  'TextCapitalization',
  'TextInputAction',
};

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

  final revision = (result.stdout as String).trim();
  final status = await Process.run('git', [
    'status',
    '--porcelain',
  ], workingDirectory: repositoryRoot.path);
  if (status.exitCode != 0) return revision;
  if ((status.stdout as String).trim().isEmpty) return revision;

  return '$revision+dirty';
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
    ..writeln('# mix_protocol coverage backlog')
    ..writeln()
    ..writeln(
      '> Generated by `packages/mix_protocol/tool/inventory_check.dart`.',
    )
    ..writeln(
      '> Command: `dart run tool/inventory_check.dart --write-backlog <output-path>`.',
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
