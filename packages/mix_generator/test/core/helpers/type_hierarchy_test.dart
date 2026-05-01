import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:mix_generator/src/core/helpers/type_hierarchy.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  group('findSupertypeMatching', () {
    test('returns a direct matching supertype', () async {
      final library = await resolveSource(
        '''
        library hierarchy;

        class Base<T> {}
        class Leaf extends Base<int> {}
        ''',
        (resolver) async => (await resolver.findLibraryByName('hierarchy'))!,
      );

      final base = library.getClass('Base')!;
      final leaf = library.getClass('Leaf')!;
      final match = findSupertypeMatching(
        leaf.supertype,
        TypeChecker.fromStatic(base.thisType),
      );

      expect(match, isNotNull);
      expect(match!.element, same(base));
      expect(match.typeArguments.single.getDisplayString(), 'int');
    });

    test('returns null when no supertype matches', () async {
      final library = await resolveSource(
        '''
        library hierarchy;

        class Base<T> {}
        class Other<T> {}
        class Leaf extends Other<int> {}
        ''',
        (resolver) async => (await resolver.findLibraryByName('hierarchy'))!,
      );

      final base = library.getClass('Base')!;
      final leaf = library.getClass('Leaf')!;

      expect(
        findSupertypeMatching(
          leaf.supertype,
          TypeChecker.fromStatic(base.thisType),
        ),
        isNull,
      );
    });

    test('preserves intermediate generic substitution', () async {
      final library = await resolveSource(
        '''
        library hierarchy;

        class Base<T> {}
        class Middle<U> extends Base<List<U>> {}
        class Leaf extends Middle<int> {}
        ''',
        (resolver) async => (await resolver.findLibraryByName('hierarchy'))!,
      );

      final base = library.getClass('Base')!;
      final leaf = library.getClass('Leaf')!;
      final match = findSupertypeMatching(
        leaf.supertype,
        TypeChecker.fromStatic(base.thisType),
      );

      expect(match, isNotNull);
      expect(match!.typeArguments.single.getDisplayString(), 'List<int>');
    });

    test('rejects a same-named type from a different library', () async {
      final libraries = await resolveSources(
        {
          'test_pkg|lib/a.dart': '''
            library a;

            class Base<T> {}
          ''',
          'test_pkg|lib/b.dart': '''
            library b;

            class Base<T> {}
            class Leaf extends Base<int> {}
          ''',
        },
        (resolver) async {
          return (
            a: await resolver.libraryFor(AssetId('test_pkg', 'lib/a.dart')),
            b: await resolver.libraryFor(AssetId('test_pkg', 'lib/b.dart')),
          );
        },
        resolverFor: 'test_pkg|lib/b.dart',
      );

      final baseFromA = libraries.a.getClass('Base')!;
      final leaf = libraries.b.getClass('Leaf')!;

      expect(
        findSupertypeMatching(
          leaf.supertype,
          TypeChecker.fromStatic(baseFromA.thisType),
        ),
        isNull,
      );
    });
  });
}
