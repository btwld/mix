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
