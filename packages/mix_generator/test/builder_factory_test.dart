import 'package:build/build.dart';
import 'package:mix_generator/mix_generator.dart';
import 'package:test/test.dart';

void main() {
  group('builder factories', () {
    final cases = <({String name, Builder builder, String outputExtension})>[
      (
        name: 'mixGenerator',
        builder: mixGenerator(BuilderOptions.empty),
        outputExtension: '.mix_generator.g.part',
      ),
      (
        name: 'specStylerGenerator',
        builder: specStylerGenerator(BuilderOptions.empty),
        outputExtension: '.spec_styler_generator.g.part',
      ),
      (
        name: 'stylerGenerator',
        builder: stylerGenerator(BuilderOptions.empty),
        outputExtension: '.styler_generator.g.part',
      ),
      (
        name: 'mixableGenerator',
        builder: mixableGenerator(BuilderOptions.empty),
        outputExtension: '.mixable_generator.g.part',
      ),
      (
        name: 'mixWidgetGenerator',
        builder: mixWidgetGenerator(BuilderOptions.empty),
        outputExtension: '.mix_widget_generator.g.part',
      ),
      (
        name: 'modifierGenerator',
        builder: modifierGenerator(BuilderOptions.empty),
        outputExtension: '.modifier_generator.g.part',
      ),
    ];

    for (final entry in cases) {
      test('${entry.name} preserves its declared output extension', () {
        expect(entry.builder.buildExtensions, {
          '.dart': [entry.outputExtension],
        });
      });
    }
  });
}
