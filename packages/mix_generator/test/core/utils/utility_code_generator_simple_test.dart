import 'package:mix_generator/src/core/utils/utility_code_generator.dart';
import 'package:test/test.dart';

void main() {
  group('UtilityCodeGenerator - Simple Methods', () {
    test('generateDocTemplate creates correct documentation', () {
      final result =
          UtilityCodeGenerator.generateDocTemplate('ColorUtility', 'Color');

      expect(result, contains('{@template color_utility}'));
      expect(
          result,
          contains(
              'A utility class for creating [Attribute] instances from [Color] values.'));
      expect(result, contains('This class extends [MixUtility]'));
    });

    test('generateUtilityField creates correct field definition', () {
      final result = UtilityCodeGenerator.generateUtilityField(
        docPath: 'BoxSpec.color',
        aliasName: 'color',
        utilityExpression: 'ColorUtility((v) => only(color: v))',
      );

      expect(result, contains('/// Utility for defining [BoxSpec.color]'));
      expect(result,
          contains('late final color = ColorUtility((v) => only(color: v));'));
    });

    test('chainGetter creates correct getter', () {
      final result = UtilityCodeGenerator.chainGetter('ColorUtility');

      expect(
          result,
          contains(
              'ColorUtility<T> get chain => ColorUtility(attributeBuilder);'));
    });

    test('selfGetter creates correct static getter', () {
      final result =
          UtilityCodeGenerator.selfGetter('ColorUtility', 'ColorAttribute');

      expect(
          result,
          contains(
              'static ColorUtility<ColorAttribute> get self => ColorUtility((v) => v);'));
    });
  });
}
