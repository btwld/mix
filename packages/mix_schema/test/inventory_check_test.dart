import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/src/inventory/schema_inventory_manifest.dart';

import '../tool/inventory_check.dart' as inventory;

void main() {
  test('inventory discovers core surface ids deterministically', () async {
    final snapshot = await inventory.collectMixInventory(
      repositoryRoot: _repositoryRoot(),
    );

    expect(snapshot.ids, orderedEquals(snapshot.ids.toList()..sort()));
    expect(
      snapshot.ids,
      containsAll([
        r'BoxStyler.$foregroundDecoration',
        'modifier:RotateModifierMix',
        'directive:color_darken',
        'variant_factory:ContextVariant.breakpoint',
        'animation:SpringAnimationConfig',
        'curve:easeInOut',
        'token:ColorToken',
        'style:IdentityStyle',
        'enum:Clip',
      ]),
    );
  });

  test('checked-in manifest classifies every current inventory id', () async {
    final snapshot = await inventory.collectMixInventory(
      repositoryRoot: _repositoryRoot(),
    );

    final result = inventory.validateManifest(
      inventoryIds: snapshot.ids,
      manifestEntries: schemaInventoryManifest,
    );

    expect(result.isValid, isTrue, reason: result.describe());
  });

  test('manifest validation reports missing stale and conflicting entries', () {
    final result = inventory.validateManifest(
      inventoryIds: const {'present:id', 'missing:id'},
      manifestEntries: const [
        SchemaInventoryEntry.supported('present:id'),
        SchemaInventoryEntry.supported('conflict:id'),
        SchemaInventoryEntry.knownUnsupported(
          'conflict:id',
          'must not be in both buckets',
        ),
        SchemaInventoryEntry.knownUnsupported('stale:id', 'removed upstream'),
      ],
    );

    expect(result.missingIds, ['missing:id']);
    expect(result.staleIds, ['conflict:id', 'stale:id']);
    expect(result.conflictingIds, ['conflict:id']);
    expect(result.describe(), contains('missing:id'));
    expect(result.describe(), contains('stale:id'));
    expect(result.describe(), contains('conflict:id'));
  });

  test('manifest validation reports duplicate entries', () {
    final result = inventory.validateManifest(
      inventoryIds: const {'duplicate:id'},
      manifestEntries: const [
        SchemaInventoryEntry.supported('duplicate:id'),
        SchemaInventoryEntry.supported('duplicate:id'),
      ],
    );

    expect(result.isValid, isFalse);
    expect(result.duplicateIds, ['duplicate:id']);
    expect(result.conflictingIds, isEmpty);
    expect(result.describe(), contains('Duplicate manifest entries:'));
    expect(result.describe(), contains('duplicate:id'));
  });

  test(
    'inventory discovers second-level subclasses of tracked bases',
    () async {
      final root = Directory.systemTemp.createTempSync(
        'mix_schema_inventory_closure_',
      );
      addTearDown(() => root.deleteSync(recursive: true));
      _writeFile(root, 'packages/mix/lib/src/core/style.dart', '''
abstract class Mix<T> {}
abstract class Style<S> extends Mix<S> {}
class BaseStyle<S> extends Style<S> {}
final class DefaultStyle extends BaseStyle<Object> {}
''');
      _writeFile(root, 'packages/mix/lib/src/variants/variant.dart', '''
class Variant {}
class ContextVariant extends Variant {}
class WidgetStateVariant extends ContextVariant {}
final class PressedVariant extends WidgetStateVariant {}
''');

      final snapshot = await inventory.collectMixInventory(
        repositoryRoot: root,
      );

      expect(
        snapshot.ids,
        containsAll(['style:DefaultStyle', 'variant:PressedVariant']),
      );
    },
  );

  test('inventory rejects unknown enum-like field types', () async {
    final root = Directory.systemTemp.createTempSync(
      'mix_schema_inventory_unknown_enum_',
    );
    addTearDown(() => root.deleteSync(recursive: true));
    _writeFile(root, 'packages/mix/lib/src/properties/probe_mix.dart', r'''
class Mix<T> {}
class Prop<T> {}
class MysteryEnum {}

final class ProbeMix extends Mix<Object> {
  final Prop<MysteryEnum>? $mode;
  const ProbeMix({Prop<MysteryEnum>? mode}) : $mode = mode;
}
''');

    await expectLater(
      inventory.collectMixInventory(repositoryRoot: root),
      throwsA(
        isA<StateError>().having(
          (error) => error.toString(),
          'message',
          allOf(contains('MysteryEnum'), contains('unknown enum-like type')),
        ),
      ),
    );
  });

  test('inventory rejects unknown Flutter-style enum field types', () async {
    final root = Directory.systemTemp.createTempSync(
      'mix_schema_inventory_unknown_flutter_enum_',
    );
    addTearDown(() => root.deleteSync(recursive: true));
    _writeFile(root, 'packages/mix/lib/src/properties/probe_mix.dart', r'''
class Mix<T> {}
class Prop<T> {}

final class ProbeMix extends Mix<Object> {
  final Prop<TextCapitalization>? $capitalization;
  const ProbeMix({Prop<TextCapitalization>? capitalization})
    : $capitalization = capitalization;
}
''');

    await expectLater(
      inventory.collectMixInventory(repositoryRoot: root),
      throwsA(
        isA<StateError>().having(
          (error) => error.toString(),
          'message',
          allOf(
            contains('TextCapitalization'),
            contains('unknown enum-like type'),
          ),
        ),
      ),
    );
  });

  test('dirty git worktrees are marked in generated provenance', () async {
    final root = Directory.systemTemp.createTempSync(
      'mix_schema_inventory_dirty_',
    );
    addTearDown(() => root.deleteSync(recursive: true));
    _writeFile(root, 'packages/mix/lib/src/core/directive.dart', '''
class Plain {}
''');
    _runGit(root, ['init']);
    _runGit(root, ['add', '.']);
    _runGit(root, [
      '-c',
      'user.email=test@example.com',
      '-c',
      'user.name=Test User',
      'commit',
      '-m',
      'initial',
    ]);
    _writeFile(root, 'packages/mix/lib/src/core/directive.dart', '''
class Plain {}
class Later {}
''');

    final snapshot = await inventory.collectMixInventory(repositoryRoot: root);

    expect(snapshot.sourceRevision, endsWith('+dirty'));
  });

  test('directive inventory reads static keys from analyzer AST', () async {
    final root = Directory.systemTemp.createTempSync(
      'mix_schema_inventory_directive_',
    );
    addTearDown(() => root.deleteSync(recursive: true));
    _writeFile(root, 'packages/mix/lib/src/core/directive.dart', '''
abstract class Directive<T> {
  String get key;
}

final class DoubleQuotedDirective extends Directive<String> {
  @override
  String get key => "double_key";
}

final class BlockDirective extends Directive<String> {
  @override
  String get key {
    return 'block_key';
  }
}

final class NamedTransform extends Directive<String> {
  @override
  String get key => 'subclass_key';
}

String get key => 'not_a_directive';
''');

    final snapshot = await inventory.collectMixInventory(repositoryRoot: root);

    expect(
      snapshot.ids,
      containsAll([
        'directive:block_key',
        'directive:double_key',
        'directive:subclass_key',
      ]),
    );
    expect(snapshot.ids, isNot(contains('directive:not_a_directive')));
  });

  test('directive inventory rejects dynamic keys', () async {
    final root = Directory.systemTemp.createTempSync(
      'mix_schema_inventory_dynamic_directive_',
    );
    addTearDown(() => root.deleteSync(recursive: true));
    _writeFile(root, 'packages/mix/lib/src/core/directive.dart', '''
abstract class Directive<T> {
  String get key;
}

final class DynamicDirective extends Directive<String> {
  @override
  String get key => DateTime.now().toString();
}
''');

    await expectLater(
      inventory.collectMixInventory(repositoryRoot: root),
      throwsA(
        isA<StateError>().having(
          (error) => error.toString(),
          'message',
          contains('DynamicDirective'),
        ),
      ),
    );
  });

  test(
    'supported styler-field manifest entries match declared codec fields',
    () {
      final declared = inventory.collectDeclaredStylerCodecFieldIds(
        repositoryRoot: _repositoryRoot(),
      );
      final unsupported = inventory.supportedStylerFieldsWithoutCodec(
        manifestEntries: schemaInventoryManifest,
        declaredCodecFieldIds: declared,
      );

      expect(unsupported, isEmpty);
    },
  );

  test(
    'manifest truthfulness rejects supported styler fields without codecs',
    () {
      final unsupported = inventory.supportedStylerFieldsWithoutCodec(
        manifestEntries: const [
          SchemaInventoryEntry.supported(r'TextStyler.$strutStyle'),
        ],
        declaredCodecFieldIds: const {r'TextStyler.$style'},
      );

      expect(unsupported, [r'TextStyler.$strutStyle']);
    },
  );
}

Directory _repositoryRoot() {
  var current = Directory.current;
  while (!File('${current.path}/melos.yaml').existsSync()) {
    final parent = current.parent;
    if (parent.path == current.path) {
      throw StateError(
        'Could not find repository root from ${Directory.current.path}.',
      );
    }
    current = parent;
  }

  return current;
}

void _writeFile(Directory root, String relativePath, String content) {
  final file = File('${root.path}/$relativePath');
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(content);
}

void _runGit(Directory root, List<String> args) {
  final result = Process.runSync('git', args, workingDirectory: root.path);
  if (result.exitCode != 0) {
    throw StateError('git ${args.join(' ')} failed: ${result.stderr}');
  }
}
