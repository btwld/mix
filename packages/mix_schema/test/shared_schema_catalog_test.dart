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

    test('boxConstraintsCodec enforces min/max ordering', () {
      final result = boxConstraintsCodec.safeParse({
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

    test(
      'gradient schema round-trips all gradient branches through encode',
      () {
        final cases = <GradientMix, Map<String, Object?>>{
          LinearGradientMix(
            colors: const [Color(0xFF000000), Color(0xFFFFFFFF)],
            stops: const [0, 1],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            tileMode: TileMode.mirror,
            transform: const GradientRotation(1.5),
          ): {
            'type': 'linear_gradient',
            'colors': ['#000000FF', '#FFFFFFFF'],
            'stops': [0.0, 1.0],
            'begin': {'x': -1.0, 'y': 0.0},
            'end': {'x': 1.0, 'y': 0.0},
            'tileMode': 'mirror',
            'transform': {'type': 'gradient_rotation', 'radians': 1.5},
          },
          RadialGradientMix(
            colors: const [Color(0xFF112233), Color(0xFF445566)],
            stops: const [0.2, 0.8],
            center: Alignment.topCenter,
            radius: 0.75,
            focal: Alignment.bottomRight,
            focalRadius: 0.25,
            tileMode: TileMode.repeated,
          ): {
            'type': 'radial_gradient',
            'colors': ['#112233FF', '#445566FF'],
            'stops': [0.2, 0.8],
            'center': {'x': 0.0, 'y': -1.0},
            'radius': 0.75,
            'tileMode': 'repeated',
            'focal': {'x': 1.0, 'y': 1.0},
            'focalRadius': 0.25,
          },
          SweepGradientMix(
            colors: const [Color(0xFF010203), Color(0xFF040506)],
            center: Alignment.bottomCenter,
            startAngle: 0.25,
            endAngle: 2.5,
            tileMode: TileMode.decal,
            transform: const TailwindCssAngleRectGradientTransform('to-tr'),
          ): {
            'type': 'sweep_gradient',
            'colors': ['#010203FF', '#040506FF'],
            'center': {'x': 0.0, 'y': 1.0},
            'startAngle': 0.25,
            'endAngle': 2.5,
            'tileMode': 'decal',
            'transform': {
              'type': 'tailwind_css_angle_rect',
              'direction': 'to-tr',
            },
          },
        };

        for (final MapEntry(:key, :value) in cases.entries) {
          expect(catalog.gradient.encode(key), value);
          expect(catalog.gradient.parse(value), key);
        }
      },
    );

    test('shape border schema round-trips all branches through encode', () {
      final side = BorderSideMix(color: const Color(0xFF000000), width: 2);
      final radius = BorderRadiusMix.circular(12);
      final cases = <ShapeBorderMix, Map<String, Object?>>{
        RoundedRectangleBorderMix(borderRadius: radius, side: side): {
          'type': 'rounded_rectangle_border',
          'borderRadius': {
            'type': 'border_radius',
            'topLeft': {'x': 12.0},
            'topRight': {'x': 12.0},
            'bottomLeft': {'x': 12.0},
            'bottomRight': {'x': 12.0},
          },
          'side': {'color': '#000000FF', 'width': 2.0},
        },
        RoundedSuperellipseBorderMix(borderRadius: radius, side: side): {
          'type': 'rounded_superellipse_border',
          'borderRadius': {
            'type': 'border_radius',
            'topLeft': {'x': 12.0},
            'topRight': {'x': 12.0},
            'bottomLeft': {'x': 12.0},
            'bottomRight': {'x': 12.0},
          },
          'side': {'color': '#000000FF', 'width': 2.0},
        },
        BeveledRectangleBorderMix(borderRadius: radius, side: side): {
          'type': 'beveled_rectangle_border',
          'borderRadius': {
            'type': 'border_radius',
            'topLeft': {'x': 12.0},
            'topRight': {'x': 12.0},
            'bottomLeft': {'x': 12.0},
            'bottomRight': {'x': 12.0},
          },
          'side': {'color': '#000000FF', 'width': 2.0},
        },
        ContinuousRectangleBorderMix(borderRadius: radius, side: side): {
          'type': 'continuous_rectangle_border',
          'borderRadius': {
            'type': 'border_radius',
            'topLeft': {'x': 12.0},
            'topRight': {'x': 12.0},
            'bottomLeft': {'x': 12.0},
            'bottomRight': {'x': 12.0},
          },
          'side': {'color': '#000000FF', 'width': 2.0},
        },
        CircleBorderMix(side: side, eccentricity: 0.5): {
          'type': 'circle_border',
          'side': {'color': '#000000FF', 'width': 2.0},
          'eccentricity': 0.5,
        },
        StarBorderMix(
          side: side,
          points: 6,
          innerRadiusRatio: 0.4,
          pointRounding: 0.1,
          valleyRounding: 0.2,
          rotation: 0.3,
          squash: 0.4,
        ): {
          'type': 'star_border',
          'side': {'color': '#000000FF', 'width': 2.0},
          'points': 6.0,
          'innerRadiusRatio': 0.4,
          'pointRounding': 0.1,
          'valleyRounding': 0.2,
          'rotation': 0.3,
          'squash': 0.4,
        },
        LinearBorderMix(
          side: side,
          start: LinearBorderEdgeMix(size: 1.5, alignment: -1),
          end: LinearBorderEdgeMix(size: 2.5, alignment: 1),
        ): {
          'type': 'linear_border',
          'side': {'color': '#000000FF', 'width': 2.0},
          'start': {'size': 1.5, 'alignment': -1.0},
          'end': {'size': 2.5, 'alignment': 1.0},
        },
        StadiumBorderMix(side: side): {
          'type': 'stadium_border',
          'side': {'color': '#000000FF', 'width': 2.0},
        },
      };

      for (final MapEntry(:key, :value) in cases.entries) {
        expect(catalog.shapeBorder.encode(key), value);
        expect(catalog.shapeBorder.parse(value), key);
      }
    });

    test(
      'decoration schema round-trips box and shape branches through encode',
      () {
        final boxDecoration = BoxDecorationMix(
          color: const Color(0xFF336699),
          gradient: LinearGradientMix(
            colors: const [Color(0xFF000000), Color(0xFFFFFFFF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: BorderMix(
            top: BorderSideMix(color: const Color(0xFF000000), width: 2),
          ),
          borderRadius: BorderRadiusMix.topLeft(const Radius.circular(12)),
          boxShadow: [
            BoxShadowMix(
              color: const Color(0x33000000),
              offset: const Offset(1, 2),
              blurRadius: 4,
            ),
          ],
        );
        final boxWire = {
          'type': 'box_decoration',
          'color': '#336699FF',
          'gradient': {
            'type': 'linear_gradient',
            'colors': ['#000000FF', '#FFFFFFFF'],
            'begin': {'x': -1.0, 'y': 0.0},
            'end': {'x': 1.0, 'y': 0.0},
          },
          'border': {
            'type': 'border',
            'top': {'color': '#000000FF', 'width': 2.0},
          },
          'borderRadius': {
            'type': 'border_radius',
            'topLeft': {'x': 12.0},
          },
          'boxShadow': [
            {
              'color': '#00000033',
              'offset': {'dx': 1.0, 'dy': 2.0},
              'blurRadius': 4.0,
            },
          ],
        };

        final shapeDecoration = ShapeDecorationMix(
          shape: RoundedRectangleBorderMix(
            borderRadius: BorderRadiusMix.circular(8),
          ),
          color: const Color(0xFF112233),
          gradient: SweepGradientMix(
            colors: const [Color(0xFF445566), Color(0xFF778899)],
            center: Alignment.topLeft,
          ),
          shadows: [
            BoxShadowMix(
              color: const Color(0x22000000),
              offset: const Offset(2, 3),
              spreadRadius: 1,
            ),
          ],
        );
        final shapeWire = {
          'type': 'shape_decoration',
          'shape': {
            'type': 'rounded_rectangle_border',
            'borderRadius': {
              'type': 'border_radius',
              'topLeft': {'x': 8.0},
              'topRight': {'x': 8.0},
              'bottomLeft': {'x': 8.0},
              'bottomRight': {'x': 8.0},
            },
          },
          'color': '#112233FF',
          'gradient': {
            'type': 'sweep_gradient',
            'colors': ['#445566FF', '#778899FF'],
            'center': {'x': -1.0, 'y': -1.0},
          },
          'shadows': [
            {
              'color': '#00000022',
              'offset': {'dx': 2.0, 'dy': 3.0},
              'spreadRadius': 1.0,
            },
          ],
        };

        expect(catalog.decoration.encode(boxDecoration), boxWire);
        expect(catalog.decoration.parse(boxWire), boxDecoration);
        expect(catalog.decoration.encode(shapeDecoration), shapeWire);
        expect(catalog.decoration.parse(shapeWire), shapeDecoration);
      },
    );
  });
}
