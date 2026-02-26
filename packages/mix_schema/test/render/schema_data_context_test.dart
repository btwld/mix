import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('SchemaDataContext', () {
    test('root lookup', () {
      final ctx = SchemaDataContext.root({'name': 'John', 'age': 30});
      expect(ctx.lookup<String>('name'), 'John');
      expect(ctx.lookup<int>('age'), 30);
    });

    test('dot-path lookup', () {
      final ctx = SchemaDataContext.root({
        'user': {'name': 'John', 'address': {'city': 'NYC'}},
      });

      expect(ctx.lookup<String>('user.name'), 'John');
      expect(ctx.lookup<String>('user.address.city'), 'NYC');
    });

    test('JSON pointer lookup', () {
      final ctx = SchemaDataContext.root({
        'user': {'name': 'John'},
      });

      expect(ctx.lookup<String>('/user/name'), 'John');
    });

    test('missing path returns null', () {
      final ctx = SchemaDataContext.root({'key': 'value'});
      expect(ctx.lookup<String>('missing'), isNull);
      expect(ctx.lookup<String>('key.deep'), isNull);
    });

    test('empty path returns null', () {
      final ctx = SchemaDataContext.root({'key': 'value'});
      expect(ctx.lookup<String>(''), isNull);
    });

    test('type mismatch returns null', () {
      final ctx = SchemaDataContext.root({'name': 'John'});
      expect(ctx.lookup<int>('name'), isNull);
    });

    test('child context scopes data', () {
      final parent = SchemaDataContext.root({
        'items': [
          {'name': 'A'},
          {'name': 'B'},
        ],
      });

      final child = parent.child(
        alias: 'item',
        item: {'name': 'A'},
        index: 0,
      );

      expect(child.lookup<String>('item.name'), 'A');
      expect(child.lookup<int>('index'), 0);
      expect(child.lookup<int>(r'$index'), 0);
    });

    test('child context falls back to parent', () {
      final parent = SchemaDataContext.root({'title': 'Page Title'});
      final child = parent.child(alias: 'item', item: {'x': 1}, index: 0);

      expect(child.lookup<String>('title'), 'Page Title');
    });

    test('nested children chain correctly', () {
      final root = SchemaDataContext.root({'global': 'value'});
      final level1 = root.child(alias: 'outer', item: {'a': 1}, index: 0);
      final level2 =
          level1.child(alias: 'inner', item: {'b': 2}, index: 1);

      expect(level2.lookup<int>('inner.b'), 2);
      expect(level2.lookup<int>('outer.a'), 1);
      expect(level2.lookup<String>('global'), 'value');
    });

    test('list index access via dot-path', () {
      final ctx = SchemaDataContext.root({
        'items': ['a', 'b', 'c'],
      });

      expect(ctx.lookup<String>('items.0'), 'a');
      expect(ctx.lookup<String>('items.2'), 'c');
    });

    test('bracket notation for list access', () {
      final ctx = SchemaDataContext.root({
        'data': {
          'items': ['x', 'y'],
        },
      });

      expect(ctx.lookup<String>('data.items[0]'), 'x');
      expect(ctx.lookup<String>('data.items[1]'), 'y');
    });

    test('out-of-bounds list access returns null', () {
      final ctx = SchemaDataContext.root({
        'items': ['a'],
      });

      expect(ctx.lookup<String>('items.5'), isNull);
    });
  });

  group('SchemaTransforms', () {
    // The closed transforms don't use BuildContext, so we use testWidgets
    // to get a real one.
    testWidgets('string transform', (tester) async {
      await tester.pumpWidget(Builder(builder: (context) {
        final result =
            SchemaTransforms.closed.apply('string', 42, context);
        expect(result, '42');
        return const SizedBox.shrink();
      }));
    });

    testWidgets('int transform from various types', (tester) async {
      await tester.pumpWidget(Builder(builder: (context) {
        expect(SchemaTransforms.closed.apply('int', 42, context), 42);
        expect(SchemaTransforms.closed.apply('int', 3.14, context), 3);
        expect(SchemaTransforms.closed.apply('int', '42', context), 42);
        return const SizedBox.shrink();
      }));
    });

    testWidgets('double transform from various types', (tester) async {
      await tester.pumpWidget(Builder(builder: (context) {
        expect(
            SchemaTransforms.closed.apply('double', 42, context), 42.0);
        expect(SchemaTransforms.closed.apply('double', '3.14', context),
            3.14);
        return const SizedBox.shrink();
      }));
    });

    testWidgets('bool transform from various types', (tester) async {
      await tester.pumpWidget(Builder(builder: (context) {
        expect(
            SchemaTransforms.closed.apply('bool', true, context), true);
        expect(
            SchemaTransforms.closed.apply('bool', false, context), false);
        expect(
            SchemaTransforms.closed.apply('bool', 'true', context), true);
        expect(SchemaTransforms.closed.apply('bool', 'false', context),
            false);
        expect(SchemaTransforms.closed.apply('bool', '1', context), true);
        expect(
            SchemaTransforms.closed.apply('bool', '0', context), false);
        return const SizedBox.shrink();
      }));
    });

    testWidgets('unknown transform returns null', (tester) async {
      await tester.pumpWidget(Builder(builder: (context) {
        final result =
            SchemaTransforms.closed.apply('unknown', 'value', context);
        expect(result, isNull);
        return const SizedBox.shrink();
      }));
    });
  });
}
