import 'package:mix_generator/src/core/builders/styler_api_planner.dart';
import 'package:mix_generator/src/core/curated/styler_surface_metadata.dart';
import 'package:test/test.dart';

void main() {
  group('planStylerApi', () {
    test('fails on duplicate factory names before emitting code', () {
      expect(
        () => planStylerApi(
          stylerName: 'ConflictStyler',
          fieldFactories: [
            (
              name: 'color',
              code:
                  'factory ConflictStyler.color(Color value) => ConflictStyler();',
            ),
          ],
          curatedFactories: [
            const StylerFactoryDescriptor(
              name: 'color',
              signature: 'color(Color value)',
              invocation: 'color(value)',
            ),
          ],
        ),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('Duplicate generated factory `ConflictStyler.color`'),
          ),
        ),
      );
    });

    test('fails on duplicate explicit method names before emitting code', () {
      expect(
        () => planStylerApi(
          stylerName: 'ConflictStyler',
          generatedSetterNames: {'shadow'},
          curatedMethods: [
            const StylerMethodDescriptor(
              name: 'shadow',
              signature: 'shadow(ShadowMix value)',
              bodyLines: ['return this;'],
            ),
          ],
        ),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('Duplicate generated method `ConflictStyler.shadow`'),
          ),
        ),
      );
    });

    test('fails when a setter collides with a generated base method', () {
      for (final methodName in ['animate', 'variants', 'wrap', 'modifier']) {
        expect(
          () => planStylerApi(
            stylerName: 'ConflictStyler',
            generatedSetterNames: {methodName},
          ),
          throwsA(
            isA<StateError>().having(
              (error) => error.message,
              'message',
              contains(
                'Duplicate generated method `ConflictStyler.$methodName`',
              ),
            ),
          ),
        );
      }
    });

    test('combines field-backed and curated API members in stable order', () {
      final plan = planStylerApi(
        stylerName: 'BoxStyler',
        fieldFactories: [
          (
            name: 'padding',
            code:
                'factory BoxStyler.padding(EdgeInsetsGeometryMix value) => BoxStyler().padding(value);',
          ),
        ],
        curatedFactories: [
          const StylerFactoryDescriptor(
            name: 'color',
            signature: 'color(Color value)',
            invocation: 'color(value)',
          ),
        ],
      );

      expect(
        plan.factoryCodes,
        orderedEquals([
          'factory BoxStyler.padding(EdgeInsetsGeometryMix value) => BoxStyler().padding(value);',
          'factory BoxStyler.color(Color value) => BoxStyler().color(value);',
        ]),
      );
    });
  });
}
