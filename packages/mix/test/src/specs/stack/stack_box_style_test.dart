import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('StackBoxStyle', () {
    group('Constructor', () {
      test('creates StackBoxStyle with box and stack properties', () {
        final attribute = StackBoxStyler(
          // Box properties
          constraints: BoxConstraintsMix(
            minWidth: 200.0,
            maxWidth: 200.0,
            minHeight: 200.0,
            maxHeight: 200.0,
          ),
          padding: EdgeInsetsMix.all(16.0),
          // Stack properties
          stackAlignment: Alignment.center,
          fit: StackFit.expand,
        );

        // Verify the properties are stored correctly
        expect(attribute.$box, isNotNull);
        expect(attribute.$stack, isNotNull);

        // Verify the properties resolve correctly
        final context = MockBuildContext();
        final resolved = attribute.resolve(context);
        final spec = resolved.spec;

        expect(
          spec.box?.spec.constraints,
          const BoxConstraints(
            minWidth: 200.0,
            maxWidth: 200.0,
            minHeight: 200.0,
            maxHeight: 200.0,
          ),
        );
        expect(spec.box?.spec.padding, const EdgeInsets.all(16.0));
        expect(spec.stack?.spec.alignment, Alignment.center);
        expect(spec.stack?.spec.fit, StackFit.expand);
      });

      test('creates StackBoxStyle with default values', () {
        final attribute = StackBoxStyler();

        expect(attribute.$box, isNotNull);
        expect(attribute.$stack, isNotNull);
      });
    });

    group('Individual property constructors', () {
      test('creates StackBoxStyle with only box properties', () {
        final stackBoxStyle = StackBoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
        );

        expect(stackBoxStyle.$box, isNotNull);
        expect(stackBoxStyle.$stack, isNotNull);
      });

      test('creates StackBoxStyle with only stack properties', () {
        final stackBoxStyle = StackBoxStyler(stackAlignment: Alignment.center);

        expect(stackBoxStyle.$stack, isNotNull);
        expect(stackBoxStyle.$box, isNotNull);
      });

      test('creates StackBoxStyle with animation', () {
        final animation = AnimationConfig.linear(Duration(seconds: 1));
        final stackBoxStyle = StackBoxStyler(animation: animation);

        expect(stackBoxStyle.$animation, animation);
      });

      test('creates StackBoxStyle with variants', () {
        final variant = ContextVariant.brightness(Brightness.dark);
        final style = StackBoxStyler(
          decoration: DecorationMix.color(Colors.white),
        );
        final stackBoxStyle = StackBoxStyler(
          variants: [VariantStyle(variant, style)],
        );

        expect(stackBoxStyle.$variants, isNotNull);
        expect(stackBoxStyle.$variants!.length, 1);
      });
    });

    group('Property methods', () {
      test('padding method creates new instance', () {
        final first = StackBoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
        );
        final second = first.padding(EdgeInsetsMix.all(16.0));

        expect(first, isNot(second));
        expect(second.$box, isNotNull);

        final context = MockBuildContext();
        final resolved = second.resolve(context);
        expect(resolved.spec.box?.spec.padding, const EdgeInsets.all(16.0));
      });

      test('margin method creates new instance', () {
        final first = StackBoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
        );
        final second = first.margin(EdgeInsetsMix.all(8.0));

        expect(first, isNot(second));
        expect(second.$box, isNotNull);

        final context = MockBuildContext();
        final resolved = second.resolve(context);
        expect(resolved.spec.box?.spec.margin, const EdgeInsets.all(8.0));
      });

      test('decoration method creates new instance', () {
        final attribute = StackBoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
        );
        final decorated = attribute.decoration(
          DecorationMix.color(Colors.blue),
        );

        expect(attribute, isNot(decorated));
        expect(decorated.$box, isNotNull);

        final context = MockBuildContext();
        final resolved = decorated.resolve(context);
        final decoration = resolved.spec.box?.spec.decoration as BoxDecoration?;
        expect(decoration?.color, Colors.blue);
      });
    });

    group('Merge', () {
      test('merges two StackBoxStyles correctly', () {
        final first = StackBoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
        );
        final second = StackBoxStyler(
          constraints: BoxConstraintsMix.height(200.0),
          stackAlignment: Alignment.center,
        );

        final merged = first.merge(second);
        final context = MockBuildContext();
        final resolved = merged.resolve(context);
        final spec = resolved.spec;

        // Should have both width and height from merged constraints
        expect(spec.box?.spec.constraints?.maxWidth, 100.0);
        expect(spec.box?.spec.constraints?.maxHeight, 200.0);
        expect(spec.stack?.spec.alignment, Alignment.center);
      });

      test('null merge returns original', () {
        final attribute = StackBoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
        );
        final merged = attribute.merge(null);

        expect(merged, attribute);
      });
    });

    group('Equality', () {
      test('equal StackBoxStyles have same properties', () {
        final constraints = BoxConstraintsMix.width(100.0);
        final alignment = Alignment.center;

        final attr1 = StackBoxStyler(
          constraints: constraints,
          stackAlignment: alignment,
        );
        final attr2 = StackBoxStyler(
          constraints: constraints,
          stackAlignment: alignment,
        );

        expect(attr1, attr2);
        expect(attr1.hashCode, attr2.hashCode);
      });

      test('different StackBoxStyles are not equal', () {
        final attr1 = StackBoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
        );
        final attr2 = StackBoxStyler(
          constraints: BoxConstraintsMix.width(200.0),
        );

        expect(attr1, isNot(attr2));
      });
    });

    group('Debug', () {
      test('debugFillProperties includes all properties', () {
        final attribute = StackBoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
          stackAlignment: Alignment.center,
        );

        final properties = DiagnosticPropertiesBuilder();
        attribute.debugFillProperties(properties);

        expect(properties.properties.any((p) => p.name == 'box'), isTrue);
        expect(properties.properties.any((p) => p.name == 'stack'), isTrue);
      });
    });

    group('Real-world usage', () {
      test('creates complete styled box', () {
        final style = StackBoxStyler(
          // Box styling
          padding: EdgeInsetsMix.all(16.0),
          decoration: DecorationMix.color(
            Colors.white,
          ).borderRadius(BorderRadiusMix.circular(8.0)),
          constraints: BoxConstraintsMix.minWidth(200.0),
          // Stack layout
          stackAlignment: Alignment.center,
          fit: StackFit.expand,
        );

        final context = MockBuildContext();
        final resolved = style.resolve(context);
        final spec = resolved.spec;

        expect(spec.box?.spec.padding, const EdgeInsets.all(16.0));
        expect(spec.box?.spec.constraints?.minWidth, 200.0);
        expect(spec.stack?.spec.alignment, Alignment.center);
        expect(spec.stack?.spec.fit, StackFit.expand);
      });
    });
  });
}
