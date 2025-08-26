import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('FlexBoxSpec', () {
    test('should create instance with container and flex', () {
      final spec = FlexBoxSpec(
        container: BoxSpec(
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
      expect(spec.container?.decoration, const BoxDecoration(color: Colors.red));
      expect(spec.container?.padding, const EdgeInsets.all(10));
      expect(spec.container?.margin, const EdgeInsets.all(5));
      expect(spec.container?.alignment, Alignment.center);
      expect(spec.container?.constraints, const BoxConstraints.tightFor(width: 100, height: 100));
      expect(spec.container?.transform, Matrix4.identity());
      expect(spec.container?.transformAlignment, Alignment.topLeft);
      expect(spec.container?.clipBehavior, Clip.hardEdge);
      
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

      expect(spec.container, isNull);
      expect(spec.flex, isNull);
    });

    test('should create instance with only container', () {
      final spec = FlexBoxSpec(
        container: BoxSpec(
          decoration: const BoxDecoration(color: Colors.red),
        ),
      );

      expect(spec.container, isNotNull);
      expect(spec.container?.decoration, const BoxDecoration(color: Colors.red));
      expect(spec.flex, isNull);
    });

    test('should create instance with only flex', () {
      final spec = FlexBoxSpec(
        flex: FlexSpec(
          direction: Axis.horizontal,
          spacing: 10.0,
        ),
      );

      expect(spec.container, isNull);
      expect(spec.flex, isNotNull);
      expect(spec.flex?.direction, Axis.horizontal);
      expect(spec.flex?.spacing, 10.0);
    });

    test('equality should work correctly', () {
      final spec1 = FlexBoxSpec(
        container: BoxSpec(decoration: const BoxDecoration(color: Colors.red)),
        flex: FlexSpec(direction: Axis.horizontal),
      );
      final spec2 = FlexBoxSpec(
        container: BoxSpec(decoration: const BoxDecoration(color: Colors.red)),
        flex: FlexSpec(direction: Axis.horizontal),
      );

      expect(spec1, equals(spec2));
    });

    test('hashCode should be consistent', () {
      final spec = FlexBoxSpec(
        container: BoxSpec(decoration: const BoxDecoration(color: Colors.red)),
        flex: FlexSpec(direction: Axis.horizontal),
      );

      expect(spec.hashCode, spec.hashCode);
    });

    group('debugFillProperties', () {
      test('should add container and flex to diagnostics', () {
        final spec = FlexBoxSpec(
          container: BoxSpec(decoration: const BoxDecoration(color: Colors.red)),
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
        final newContainer = BoxSpec(decoration: const BoxDecoration(color: Colors.red));
        final copied = original.copyWith(container: newContainer);

        expect(copied.container, equals(newContainer));
        expect(copied.flex, equals(original.flex));
      });

      test('should copy with new flex', () {
        final original = FlexBoxSpec(
          container: BoxSpec(decoration: const BoxDecoration(color: Colors.red)),
        );
        final newFlex = FlexSpec(direction: Axis.vertical);
        final copied = original.copyWith(flex: newFlex);

        expect(copied.container, equals(original.container));
        expect(copied.flex, equals(newFlex));
      });
    });

    group('props', () {
      test('should include container and flex in props', () {
        final spec = FlexBoxSpec(
          container: BoxSpec(decoration: const BoxDecoration(color: Colors.red)),
          flex: FlexSpec(direction: Axis.horizontal),
        );

        expect(spec.props.length, equals(2));
        expect(spec.props, contains(spec.container));
        expect(spec.props, contains(spec.flex));
      });
    });
  });
}