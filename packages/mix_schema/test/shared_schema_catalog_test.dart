import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/src/errors/mix_schema_error_code.dart';
import 'package:mix_schema/src/errors/schema_error_mapper.dart';
import 'package:mix_schema/src/registry/registry_catalog.dart';
import 'package:mix_schema/src/schema/mix_schema_catalog.dart';
import 'package:mix_schema/src/schema/painting/gradient_schemas.dart';
import 'package:mix_schema/src/schema/shared/box_constraints_schema.dart';

void main() {
  group('Shared schema catalog', () {
    final catalog = MixSchemaCatalog(registries: RegistryCatalog(const []));

    test('buildDecorationSchema decodes reusable painting objects', () {
      final result = catalog.decoration.safeParse({
        'type': 'box_decoration',
        'gradient': {
          'type': 'linear_gradient',
          'colors': ['#000000', '#FFFFFFFF'],
          'begin': {'x': -1, 'y': 0},
          'end': {'x': 1, 'y': 0},
        },
        'border': {
          'type': 'border',
          'top': {'color': 'rgb(0, 0, 0)', 'width': 2},
        },
        'borderRadius': {
          'type': 'border_radius',
          'topLeft': {'x': 12},
        },
        'boxShadow': [
          {
            'color': '#00000033',
            'offset': {'dx': 1, 'dy': 2},
            'blurRadius': 4,
          },
        ],
      });

      expect(result.isOk, isTrue);
      expect(result.getOrNull(), isA<BoxDecorationMix>());
    });

    test('boxConstraintsSchema enforces min/max ordering', () {
      final result = boxConstraintsSchema.safeParse({
        'minWidth': 120,
        'maxWidth': 60,
      });

      expect(result.isFail, isTrue);

      final errors = const SchemaErrorMapper().map(result.getError());
      expect(errors.single.code, MixSchemaErrorCode.validationFailed);
      expect(errors.single.path, '#');
    });

    test('buildDecorationSchema validates gradient stop counts', () {
      final result = catalog.decoration.safeParse({
        'type': 'box_decoration',
        'gradient': {
          'type': 'linear_gradient',
          'colors': ['#000000', '#FFFFFFFF'],
          'stops': [0.0],
        },
      });

      expect(result.isFail, isTrue);

      final errors = const SchemaErrorMapper().map(result.getError());
      expect(errors.single.code, MixSchemaErrorCode.validationFailed);
      expect(errors.single.path, '#/gradient');
    });

    testWidgets(
      'buildDecorationSchema decodes shape decorations and gradient transforms',
      (tester) async {
        final result = catalog.decoration.safeParse({
          'type': 'shape_decoration',
          'shape': {
            'type': 'rounded_rectangle_border',
            'borderRadius': {
              'type': 'border_radius',
              'topLeft': {'x': 10},
            },
          },
          'gradient': {
            'type': 'linear_gradient',
            'colors': ['#000000', '#FFFFFFFF'],
            'transform': {
              'type': 'tailwind_css_angle_rect',
              'direction': 'to-br',
            },
          },
        });

        expect(result.isOk, isTrue);

        final decoration = result.getOrNull()! as ShapeDecorationMix;
        late ShapeDecoration resolved;

        await tester.pumpWidget(
          Builder(
            builder: (context) {
              resolved = decoration.resolve(context);
              return const SizedBox();
            },
          ),
        );

        final gradient = resolved.gradient! as LinearGradient;
        expect(resolved.shape, isA<RoundedRectangleBorder>());
        expect(
          gradient.transform,
          const TailwindCssAngleRectGradientTransform('to-br'),
        );
      },
    );
  });
}
