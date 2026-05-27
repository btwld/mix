import 'package:build_test/build_test.dart';
import 'package:mix_generator/src/core/helpers/mixin_method_collector.dart';
import 'package:test/test.dart';

void main() {
  group('MixinMethodCollector', () {
    test('returns concrete methods of a mixin, skipping abstract anchors', () async {
      final library = await resolveSource(
        '''
          library test;

          mixin TestMixin<T> {
            T foo(int value);
            T bar(String s) => foo(s.length);
            T baz() => foo(0);
          }
        ''',
        (resolver) async => (await resolver.findLibraryByName('test'))!,
      );

      final mixinElement = library.getMixin('TestMixin')!;
      final methods = MixinMethodCollector.collect(mixinElement);

      expect(methods.map((m) => m.name), containsAll(['bar', 'baz']));
      expect(methods.map((m) => m.name), isNot(contains('foo')));
    });

    test('captures parameter types and return type', () async {
      final library = await resolveSource(
        '''
          library test;

          mixin TestMixin<T> {
            T set(int a, {String? b}) => throw UnimplementedError();
          }
        ''',
        (resolver) async => (await resolver.findLibraryByName('test'))!,
      );

      final mixinElement = library.getMixin('TestMixin')!;
      final methods = MixinMethodCollector.collect(mixinElement);

      expect(methods, hasLength(1));
      expect(methods.first.name, 'set');
      expect(methods.first.parameters.first.type.getDisplayString(), 'int');
      expect(methods.first.returnTypeDisplay, 'T');
    });
  });
}
