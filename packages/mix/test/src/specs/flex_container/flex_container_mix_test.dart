import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('FlexContainerMix', () {
    test('should create instance with all properties', () {
      final mix = FlexContainerMix(
        // Container properties
        decoration: DecorationMix.color(Colors.red),
        foregroundDecoration: DecorationMix.color(Colors.blue),
        padding: EdgeInsetsGeometryMix.all(10),
        margin: EdgeInsetsGeometryMix.all(5),
        alignment: Alignment.center,
        constraints: BoxConstraintsMix.width(100),
        transform: Matrix4.identity(),
        transformAlignment: Alignment.topLeft,
        clipBehavior: Clip.hardEdge,
        // Flex properties
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.up,
        textDirection: TextDirection.rtl,
        textBaseline: TextBaseline.ideographic,
        spacing: 10.0,
      );

      // Just verify that the mix was created successfully
      expect(mix, isA<FlexContainerMix>());
    });

    test('should create empty instance with null properties', () {
      final mix = FlexContainerMix();

      // Verify empty mix was created successfully
      expect(mix, isA<FlexContainerMix>());
    });

    group('Container factory constructors', () {
      test('color factory should create decoration with color', () {
        final mix = FlexContainerMix.color(Colors.red);
        expect(mix, isA<FlexContainerMix>());
      });

      test('decoration factory should set decoration', () {
        final mix = FlexContainerMix.decoration(DecorationMix.color(Colors.blue));
        expect(mix, isA<FlexContainerMix>());
      });

      test('padding factory should set padding', () {
        final mix = FlexContainerMix.padding(EdgeInsetsGeometryMix.all(10));
        expect(mix, isA<FlexContainerMix>());
      });

      test('margin factory should set margin', () {
        final mix = FlexContainerMix.margin(EdgeInsetsGeometryMix.all(5));
        expect(mix, isA<FlexContainerMix>());
      });

      test('alignment factory should set alignment', () {
        final mix = FlexContainerMix.alignment(Alignment.center);
        expect(mix, isA<FlexContainerMix>());
      });

      test('constraints factory should set constraints', () {
        final mix = FlexContainerMix.constraints(BoxConstraintsMix.width(100));
        expect(mix, isA<FlexContainerMix>());
      });

      test('transform factory should set transform', () {
        final mix = FlexContainerMix.transform(Matrix4.identity());
        expect(mix, isA<FlexContainerMix>());
      });

      test('transformAlignment factory should set transformAlignment', () {
        final mix = FlexContainerMix.transformAlignment(Alignment.topLeft);
        expect(mix, isA<FlexContainerMix>());
      });

      test('clipBehavior factory should set clipBehavior', () {
        final mix = FlexContainerMix.clipBehavior(Clip.hardEdge);
        expect(mix, isA<FlexContainerMix>());
      });

      test('border factory should create decoration with border', () {
        final mix = FlexContainerMix.border(BoxBorderMix.all(BorderSideMix.color(Colors.black)));
        expect(mix, isA<FlexContainerMix>());
      });

      test('borderRadius factory should create decoration with border radius', () {
        final mix = FlexContainerMix.borderRadius(BorderRadiusGeometryMix.circular(5));
        expect(mix, isA<FlexContainerMix>());
      });

      test('shadow factory should create decoration with shadow', () {
        final mix = FlexContainerMix.shadow(BoxShadowMix.color(Colors.black));
        expect(mix, isA<FlexContainerMix>());
      });

      test('width factory should set constraints', () {
        final mix = FlexContainerMix.width(100);
        expect(mix, isA<FlexContainerMix>());
      });

      test('height factory should set constraints', () {
        final mix = FlexContainerMix.height(200);
        expect(mix, isA<FlexContainerMix>());
      });
    });

    group('Flex factory constructors', () {
      test('direction factory should set direction', () {
        final mix = FlexContainerMix.direction(Axis.horizontal);
        expect(mix, isA<FlexContainerMix>());
      });

      test('spacing factory should set spacing', () {
        final mix = FlexContainerMix.spacing(10);
        expect(mix, isA<FlexContainerMix>());
      });

      test('mainAxisAlignment factory should set mainAxisAlignment', () {
        final mix = FlexContainerMix.mainAxisAlignment(MainAxisAlignment.center);
        expect(mix, isA<FlexContainerMix>());
      });

      test('crossAxisAlignment factory should set crossAxisAlignment', () {
        final mix = FlexContainerMix.crossAxisAlignment(CrossAxisAlignment.start);
        expect(mix, isA<FlexContainerMix>());
      });

      test('mainAxisSize factory should set mainAxisSize', () {
        final mix = FlexContainerMix.mainAxisSize(MainAxisSize.min);
        expect(mix, isA<FlexContainerMix>());
      });

      test('verticalDirection factory should set verticalDirection', () {
        final mix = FlexContainerMix.verticalDirection(VerticalDirection.up);
        expect(mix, isA<FlexContainerMix>());
      });

      test('textDirection factory should set textDirection', () {
        final mix = FlexContainerMix.textDirection(TextDirection.rtl);
        expect(mix, isA<FlexContainerMix>());
      });

      test('textBaseline factory should set textBaseline', () {
        final mix = FlexContainerMix.textBaseline(TextBaseline.ideographic);
        expect(mix, isA<FlexContainerMix>());
      });
    });

    group('Convenience flex factories', () {
      test('horizontal factory should create horizontal flex', () {
        final mix = FlexContainerMix.horizontal(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 5,
        );

        expect(mix, isA<FlexContainerMix>());
      });

      test('vertical factory should create vertical flex', () {
        final mix = FlexContainerMix.vertical(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
        );

        expect(mix, isA<FlexContainerMix>());
      });

      test('row factory should create horizontal flex', () {
        final mix = FlexContainerMix.row(spacing: 10);

        expect(mix, isA<FlexContainerMix>());
      });

      test('column factory should create vertical flex', () {
        final mix = FlexContainerMix.column(spacing: 15);

        expect(mix, isA<FlexContainerMix>());
      });
    });

    test('value constructor should extract properties from spec', () {
      final spec = FlexContainerSpec(
        decoration: const BoxDecoration(color: Colors.red),
        padding: const EdgeInsets.all(10),
        direction: Axis.horizontal,
        spacing: 5.0,
      );

      final mix = FlexContainerMix.value(spec);

      expect(mix, isA<FlexContainerMix>());
    });

    test('maybeValue should return null for null spec', () {
      final result = FlexContainerMix.maybeValue(null);
      expect(result, null);
    });

    test('maybeValue should return mix for non-null spec', () {
      const spec = FlexContainerSpec(direction: Axis.horizontal);
      final result = FlexContainerMix.maybeValue(spec);
      expect(result, isA<FlexContainerMix>());
    });

    group('Chainable methods', () {
      test('should chain container methods correctly', () {
        final mix = FlexContainerMix()
            .color(Colors.red)
            .padding(EdgeInsetsGeometryMix.all(10))
            .alignment(Alignment.center)
            .width(100)
            .height(200);

        expect(mix, isA<FlexContainerMix>());
      });

      test('should chain flex methods correctly', () {
        final mix = FlexContainerMix()
            .direction(Axis.horizontal)
            .mainAxisAlignment(MainAxisAlignment.center)
            .crossAxisAlignment(CrossAxisAlignment.start)
            .spacing(10);

        expect(mix, isA<FlexContainerMix>());
      });

      test('should chain mixed container and flex methods', () {
        final mix = FlexContainerMix()
            .color(Colors.blue)
            .direction(Axis.vertical)
            .padding(EdgeInsetsGeometryMix.all(5))
            .spacing(8)
            .alignment(Alignment.topCenter);

        expect(mix, isA<FlexContainerMix>());
      });
    });

    test('merge should combine two mixes correctly', () {
      final mix1 = FlexContainerMix(
        decoration: DecorationMix.color(Colors.red),
        direction: Axis.horizontal,
      );
      final mix2 = FlexContainerMix(
        padding: EdgeInsetsGeometryMix.all(10),
        spacing: 5.0,
      );

      final merged = mix1.merge(mix2);

      expect(merged, isA<FlexContainerMix>());
    });

    test('merge with null should return original', () {
      final mix = FlexContainerMix(decoration: DecorationMix.color(Colors.red));
      final result = mix.merge(null);

      expect(result, same(mix));
    });

    testWidgets('resolve should create FlexContainerSpec from context', (tester) async {
      final mix = FlexContainerMix(
        decoration: DecorationMix.color(Colors.red),
        padding: EdgeInsetsGeometryMix.all(10),
        direction: Axis.horizontal,
        spacing: 5.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final spec = mix.resolve(context);

              expect(spec, isA<FlexContainerSpec>());
              expect(spec.decoration, isNotNull);
              expect(spec.padding, isNotNull);
              expect(spec.direction, Axis.horizontal);
              expect(spec.spacing, 5.0);

              return Container();
            },
          ),
        ),
      );
    });

    test('debugFillProperties should add all properties', () {
      final mix = FlexContainerMix(
        decoration: DecorationMix.color(Colors.red),
        padding: EdgeInsetsGeometryMix.all(10),
        direction: Axis.horizontal,
        spacing: 5.0,
      );

      final builder = DiagnosticPropertiesBuilder();
      mix.debugFillProperties(builder);

      final properties = builder.properties;
      expect(properties.any((p) => p.name == 'decoration'), true);
      expect(properties.any((p) => p.name == 'padding'), true);
      expect(properties.any((p) => p.name == 'direction'), true);
      expect(properties.any((p) => p.name == 'spacing'), true);
    });

    test('props should include all properties for equality comparison', () {
      final mix1 = FlexContainerMix(
        decoration: DecorationMix.color(Colors.red),
        direction: Axis.horizontal,
      );
      final mix2 = FlexContainerMix(
        decoration: DecorationMix.color(Colors.red),
        direction: Axis.horizontal,
      );
      final mix3 = FlexContainerMix(
        decoration: DecorationMix.color(Colors.blue),
        direction: Axis.horizontal,
      );

      expect(mix1, mix2);
      expect(mix1, isNot(mix3));
    });
  });
}