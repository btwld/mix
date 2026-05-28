import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:mix_generator/src/core/helpers/library_scope.dart';
import 'package:test/test.dart';

void main() {
  group('referenceFor', () {
    test('returns a bare name when the element is directly visible', () async {
      final libraries = await _resolveLibraryScope('''
        import 'visible.dart';
      ''');

      final target = libraries.visible.getClass('VisibleType')!;

      expect(referenceFor(target, libraries.input), 'VisibleType');
    });

    test('returns a prefixed name when visible through a prefix', () async {
      final libraries = await _resolveLibraryScope('''
        import 'visible.dart' as v;
      ''');

      final target = libraries.visible.getClass('VisibleType')!;

      expect(referenceFor(target, libraries.input), 'v.VisibleType');
    });

    test('returns null when the element is not visible', () async {
      final libraries = await _resolveLibraryScope('');
      final target = libraries.visible.getClass('VisibleType')!;

      expect(referenceFor(target, libraries.input), isNull);
    });

    test(
      'returns the first visible prefix for repeated prefixed imports',
      () async {
        final libraries = await _resolveLibraryScope('''
        import 'visible.dart' as a;
        import 'visible.dart' as b;
      ''');

        final target = libraries.visible.getClass('VisibleType')!;

        expect(referenceFor(target, libraries.input), 'a.VisibleType');
      },
    );
  });

  group('hasUnprefixedVisibleName', () {
    test('returns true when a name is visible without a prefix', () async {
      final libraries = await _resolveLibraryScope('''
        import 'visible.dart';
      ''');

      expect(hasUnprefixedVisibleName('VisibleType', libraries.input), isTrue);
    });

    test(
      'returns false when a name is visible only through a prefix',
      () async {
        final libraries = await _resolveLibraryScope('''
        import 'visible.dart' as v;
      ''');

        expect(
          hasUnprefixedVisibleName('VisibleType', libraries.input),
          isFalse,
        );
      },
    );

    test('returns true for local declarations', () async {
      final libraries = await _resolveLibraryScope('''
        class LocalType {}
      ''');

      expect(hasUnprefixedVisibleName('LocalType', libraries.input), isTrue);
    });
  });

  group('typeCode', () {
    test('uses the visible prefix for generic type aliases', () async {
      final libraries = await _resolveLibraryScope('''
        import 'visible.dart' as v;

        v.VisibleAlias<int>? value() => null;
      ''');

      final value = libraries.input.getTopLevelFunction('value')!;

      expect(
        typeCode(value.returnType, visibleFrom: libraries.input),
        'v.VisibleAlias<int>?',
      );
    });

    test('uses visible prefixes inside direct function types', () async {
      final libraries = await _resolveLibraryScope('''
        import 'visible.dart' as v;

        v.VisibleType Function(
          v.VisibleType value, {
          required v.VisibleType named,
        }) value() => throw UnimplementedError();
      ''');

      final value = libraries.input.getTopLevelFunction('value')!;

      expect(
        typeCode(value.returnType, visibleFrom: libraries.input),
        'v.VisibleType Function(v.VisibleType value, '
        '{required v.VisibleType named})',
      );
    });
  });
}

Future<({LibraryElement visible, LibraryElement input})> _resolveLibraryScope(
  String inputImportsAndMembers,
) {
  return resolveSources(
    {
      'test_pkg|lib/visible.dart': '''
        library visible;

        class VisibleType {}
        typedef VisibleAlias<T> = VisibleType;
      ''',
      'test_pkg|lib/input.dart':
          '''
        library input;

        $inputImportsAndMembers
      ''',
    },
    (resolver) async {
      return (
        visible: await resolver.libraryFor(
          AssetId('test_pkg', 'lib/visible.dart'),
        ),
        input: await resolver.libraryFor(AssetId('test_pkg', 'lib/input.dart')),
      );
    },
    resolverFor: 'test_pkg|lib/input.dart',
  );
}
