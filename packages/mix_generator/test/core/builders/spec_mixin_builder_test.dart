import 'package:mix_generator/src/core/builders/spec_mixin_builder.dart';
import 'package:test/test.dart';

void main() {
  group('SpecMixinBuilder', () {
    group('mixinName', () {
      test('generates correct mixin name', () {
        final builder = SpecMixinBuilder(specName: 'BoxSpec', fields: []);
        expect(builder.mixinName, equals('_\$BoxSpecMethods'));
      });

      test('generates correct mixin name for TextSpec', () {
        final builder = SpecMixinBuilder(specName: 'TextSpec', fields: []);
        expect(builder.mixinName, equals('_\$TextSpecMethods'));
      });
    });

    group('build', () {
      test('generates mixin declaration', () {
        final builder = SpecMixinBuilder(specName: 'BoxSpec', fields: []);
        final code = builder.build();

        expect(
          code,
          contains('mixin _\$BoxSpecMethods on Spec<BoxSpec>, Diagnosticable'),
        );
      });

      test('generates copyWith override', () {
        final builder = SpecMixinBuilder(specName: 'BoxSpec', fields: []);
        final code = builder.build();

        expect(code, contains('@override'));
        expect(code, contains('BoxSpec copyWith('));
        expect(code, contains('return BoxSpec('));
      });

      test('generates lerp override', () {
        final builder = SpecMixinBuilder(specName: 'BoxSpec', fields: []);
        final code = builder.build();

        expect(code, contains('@override'));
        expect(code, contains('BoxSpec lerp(BoxSpec? other, double t)'));
        expect(code, contains('return BoxSpec('));
      });

      test('generates debugFillProperties override', () {
        final builder = SpecMixinBuilder(specName: 'BoxSpec', fields: []);
        final code = builder.build();

        expect(code, contains('@override'));
        expect(
          code,
          contains(
            'void debugFillProperties(DiagnosticPropertiesBuilder properties)',
          ),
        );
        expect(code, contains('super.debugFillProperties(properties)'));
      });

      test('generates props override', () {
        final builder = SpecMixinBuilder(specName: 'BoxSpec', fields: []);
        final code = builder.build();

        expect(code, contains('@override'));
        expect(code, contains('List<Object?> get props =>'));
      });

      test('closes mixin with brace', () {
        final builder = SpecMixinBuilder(specName: 'BoxSpec', fields: []);
        final code = builder.build();

        expect(code, endsWith('}\n'));
      });
    });

    group('empty fields', () {
      test('generates empty props list', () {
        final builder = SpecMixinBuilder(specName: 'EmptySpec', fields: []);
        final code = builder.build();

        expect(code, contains('List<Object?> get props => [];'));
      });

      test('generates copyWith with no parameters', () {
        final builder = SpecMixinBuilder(specName: 'EmptySpec', fields: []);
        final code = builder.build();

        expect(code, contains('EmptySpec copyWith({'));
        expect(code, contains('}) {'));
      });
    });
  });
}
