import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('FlexBoxSpec', () {
    test('should create instance with container and flex', () {
      final spec = FlexBoxSpec(
        box: BoxSpec(
          decoration: const BoxDecoration(color: Colors.red),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(5),
          alignment: Alignment.center,
          constraints: const BoxConstraints.tightFor(width: 100, height: 100),
          transform: Matrix4.identity(),
          transformAlignment: Alignment.topLeft,
          clipBehavior: Clip.hardEdge,
        ),
        flex: FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.up,
          textDirection: TextDirection.rtl,
          textBaseline: TextBaseline.ideographic,
          spacing: 10.0,
        ),
      );

      // Container spec
      expect(spec.box?.decoration, const BoxDecoration(color: Colors.red));
      expect(spec.box?.padding, const EdgeInsets.all(10));
      expect(spec.box?.margin, const EdgeInsets.all(5));
      expect(spec.box?.alignment, Alignment.center);
      expect(
        spec.box?.constraints,
        const BoxConstraints.tightFor(width: 100, height: 100),
      );
      expect(spec.box?.transform, Matrix4.identity());
      expect(spec.box?.transformAlignment, Alignment.topLeft);
      expect(spec.box?.clipBehavior, Clip.hardEdge);

      // Flex spec
      expect(spec.flex?.direction, Axis.horizontal);
      expect(spec.flex?.mainAxisAlignment, MainAxisAlignment.center);
      expect(spec.flex?.crossAxisAlignment, CrossAxisAlignment.start);
      expect(spec.flex?.mainAxisSize, MainAxisSize.min);
      expect(spec.flex?.verticalDirection, VerticalDirection.up);
      expect(spec.flex?.textDirection, TextDirection.rtl);
      expect(spec.flex?.textBaseline, TextBaseline.ideographic);
      expect(spec.flex?.spacing, 10.0);
    });

    test('should create empty instance with null properties', () {
      final spec = FlexBoxSpec();

      expect(spec.box, isNull);
      expect(spec.flex, isNull);
    });

    test('should create instance with only container', () {
      final spec = FlexBoxSpec(
        box: BoxSpec(decoration: const BoxDecoration(color: Colors.red)),
      );

      expect(spec.box, isNotNull);
      expect(spec.box?.decoration, const BoxDecoration(color: Colors.red));
      expect(spec.flex, isNull);
    });

    test('should create instance with only flex', () {
      final spec = FlexBoxSpec(
        flex: FlexSpec(direction: Axis.horizontal, spacing: 10.0),
      );

      expect(spec.box, isNull);
      expect(spec.flex, isNotNull);
      expect(spec.flex?.direction, Axis.horizontal);
      expect(spec.flex?.spacing, 10.0);
    });

    test('equality should work correctly', () {
      final spec1 = FlexBoxSpec(
        box: BoxSpec(decoration: const BoxDecoration(color: Colors.red)),
        flex: FlexSpec(direction: Axis.horizontal),
      );
      final spec2 = FlexBoxSpec(
        box: BoxSpec(decoration: const BoxDecoration(color: Colors.red)),
        flex: FlexSpec(direction: Axis.horizontal),
      );

      expect(spec1, equals(spec2));
    });

    test('hashCode should be consistent', () {
      final spec = FlexBoxSpec(
        box: BoxSpec(decoration: const BoxDecoration(color: Colors.red)),
        flex: FlexSpec(direction: Axis.horizontal),
      );

      expect(spec.hashCode, spec.hashCode);
    });

    group('debugFillProperties', () {
      test('should add container and flex to diagnostics', () {
        final spec = FlexBoxSpec(
          box: BoxSpec(decoration: const BoxDecoration(color: Colors.red)),
          flex: FlexSpec(direction: Axis.horizontal),
        );

        final builder = DiagnosticPropertiesBuilder();
        spec.debugFillProperties(builder);

        expect(builder.properties.length, equals(2));
      });
    });

    group('copyWith', () {
      test('should copy with new container', () {
        final original = FlexBoxSpec(
          flex: FlexSpec(direction: Axis.horizontal),
        );
        final newContainer = BoxSpec(
          decoration: const BoxDecoration(color: Colors.red),
        );
        final copied = original.copyWith(box: newContainer);

        expect(copied.box, equals(newContainer));
        expect(copied.flex, equals(original.flex));
      });

      test('should copy with new flex', () {
        final original = FlexBoxSpec(
          box: BoxSpec(decoration: const BoxDecoration(color: Colors.red)),
        );
        final newFlex = FlexSpec(direction: Axis.vertical);
        final copied = original.copyWith(flex: newFlex);

        expect(copied.box, equals(original.box));
        expect(copied.flex, equals(newFlex));
      });
    });

    group('props', () {
      test('should include container and flex in props', () {
        final spec = FlexBoxSpec(
          box: BoxSpec(decoration: const BoxDecoration(color: Colors.red)),
          flex: FlexSpec(direction: Axis.horizontal),
        );

        expect(spec.props.length, equals(2));
        expect(spec.props, contains(spec.box));
        expect(spec.props, contains(spec.flex));
      });
    });
  });
}
