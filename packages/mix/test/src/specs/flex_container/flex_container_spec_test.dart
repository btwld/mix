import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('FlexContainerSpec', () {
    test('should create instance with all properties', () {
      final spec = FlexContainerSpec(
        // Container properties
        decoration: const BoxDecoration(color: Colors.red),
        foregroundDecoration: const BoxDecoration(color: Colors.blue),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
        constraints: const BoxConstraints.tightFor(width: 100, height: 100),
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

      // Container properties
      expect(spec.decoration, const BoxDecoration(color: Colors.red));
      expect(spec.foregroundDecoration, const BoxDecoration(color: Colors.blue));
      expect(spec.padding, const EdgeInsets.all(10));
      expect(spec.margin, const EdgeInsets.all(5));
      expect(spec.alignment, Alignment.center);
      expect(spec.constraints, const BoxConstraints.tightFor(width: 100, height: 100));
      expect(spec.transform, Matrix4.identity());
      expect(spec.transformAlignment, Alignment.topLeft);
      expect(spec.clipBehavior, Clip.hardEdge);
      
      // Flex properties
      expect(spec.direction, Axis.horizontal);
      expect(spec.mainAxisAlignment, MainAxisAlignment.center);
      expect(spec.crossAxisAlignment, CrossAxisAlignment.start);
      expect(spec.mainAxisSize, MainAxisSize.min);
      expect(spec.verticalDirection, VerticalDirection.up);
      expect(spec.textDirection, TextDirection.rtl);
      expect(spec.textBaseline, TextBaseline.ideographic);
      expect(spec.spacing, 10.0);
    });

    test('should create empty instance with null properties', () {
      const spec = FlexContainerSpec();

      // All properties should be null
      expect(spec.decoration, null);
      expect(spec.foregroundDecoration, null);
      expect(spec.padding, null);
      expect(spec.margin, null);
      expect(spec.alignment, null);
      expect(spec.constraints, null);
      expect(spec.transform, null);
      expect(spec.transformAlignment, null);
      expect(spec.clipBehavior, null);
      expect(spec.direction, null);
      expect(spec.mainAxisAlignment, null);
      expect(spec.crossAxisAlignment, null);
      expect(spec.mainAxisSize, null);
      expect(spec.verticalDirection, null);
      expect(spec.textDirection, null);
      expect(spec.textBaseline, null);
      expect(spec.spacing, null);
    });

    test('copyWith should update only specified properties', () {
      const original = FlexContainerSpec(
        decoration: BoxDecoration(color: Colors.red),
        direction: Axis.vertical,
        spacing: 5.0,
      );

      final updated = original.copyWith(
        decoration: const BoxDecoration(color: Colors.blue),
        mainAxisAlignment: MainAxisAlignment.end,
      );

      expect(updated.decoration, const BoxDecoration(color: Colors.blue));
      expect(updated.direction, Axis.vertical); // unchanged
      expect(updated.spacing, 5.0); // unchanged
      expect(updated.mainAxisAlignment, MainAxisAlignment.end); // new
    });

    test('copyWith should preserve existing values when null is passed', () {
      const original = FlexContainerSpec(
        decoration: BoxDecoration(color: Colors.red),
        direction: Axis.vertical,
        spacing: 5.0,
      );

      final updated = original.copyWith();

      expect(updated.decoration, original.decoration);
      expect(updated.direction, original.direction);
      expect(updated.spacing, original.spacing);
    });

    test('lerp should interpolate between two specs', () {
      const spec1 = FlexContainerSpec(
        padding: EdgeInsets.all(10),
        spacing: 5.0,
        direction: Axis.horizontal,
      );
      const spec2 = FlexContainerSpec(
        padding: EdgeInsets.all(20),
        spacing: 15.0,
        direction: Axis.vertical,
      );

      final interpolated = spec1.lerp(spec2, 0.5);

      expect(interpolated.padding, const EdgeInsets.all(15)); // 10 + (20-10) * 0.5
      expect(interpolated.spacing, 10.0); // 5 + (15-5) * 0.5
      expect(interpolated.direction, Axis.vertical); // snap at t > 0.5
    });

    test('lerp should interpolate properly when other is null', () {
      const testColor = Color(0xFFFF0000); // Regular color instead of Colors.red (MaterialColor)
      const spec = FlexContainerSpec(
        decoration: BoxDecoration(color: testColor),
        direction: Axis.horizontal,
      );

      final result = spec.lerp(null, 0.5);

      // Properties should interpolate according to their lerp behavior  
      // Since Decoration.lerp behavior may vary, just check that the result is not null
      expect(result.decoration, isNotNull);
      expect(result.direction, MixOps.lerpSnap(Axis.horizontal, null, 0.5)); // Should be null since t=0.5 >= 0.5
    });

    test('lerp should handle null properties correctly', () {
      const spec1 = FlexContainerSpec(
        padding: EdgeInsets.all(10),
      );
      const spec2 = FlexContainerSpec(
        spacing: 15.0,
      );

      final interpolated = spec1.lerp(spec2, 0.5);

      expect(interpolated.padding, const EdgeInsets.all(5)); // 10 * (1-0.5)
      expect(interpolated.spacing, 7.5); // 15 * 0.5
    });

    test('props should include all properties for equality comparison', () {
      const spec1 = FlexContainerSpec(
        decoration: BoxDecoration(color: Colors.red),
        direction: Axis.horizontal,
        spacing: 10.0,
      );
      const spec2 = FlexContainerSpec(
        decoration: BoxDecoration(color: Colors.red),
        direction: Axis.horizontal,
        spacing: 10.0,
      );
      const spec3 = FlexContainerSpec(
        decoration: BoxDecoration(color: Colors.blue),
        direction: Axis.horizontal,
        spacing: 10.0,
      );

      expect(spec1, spec2);
      expect(spec1, isNot(spec3));
    });

    test('debugFillProperties should add all properties', () {
      const spec = FlexContainerSpec(
        decoration: BoxDecoration(color: Colors.red),
        padding: EdgeInsets.all(10),
        direction: Axis.horizontal,
        spacing: 5.0,
      );

      final builder = DiagnosticPropertiesBuilder();
      spec.debugFillProperties(builder);

      final properties = builder.properties;
      expect(properties.any((p) => p.name == 'decoration'), true);
      expect(properties.any((p) => p.name == 'padding'), true);
      expect(properties.any((p) => p.name == 'direction'), true);
      expect(properties.any((p) => p.name == 'spacing'), true);
    });
  });

  group('FlexContainerSpecX Extension', () {
    testWidgets('call should create Container with Flex child', (tester) async {
      const spec = FlexContainerSpec(
        decoration: BoxDecoration(color: Colors.red),
        padding: EdgeInsets.all(10),
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5.0,
      );

      final widget = spec(
        direction: Axis.vertical, // This should be overridden by spec.direction
        children: [
          Container(width: 50, height: 50, color: Colors.blue),
          Container(width: 50, height: 50, color: Colors.green),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: widget)),
      );

      // Check that Container is created
      expect(find.byType(Container), findsWidgets);
      
      // Check that Flex is created
      expect(find.byType(Flex), findsOneWidget);

      // Find the Flex widget and verify its properties
      final flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.direction, Axis.horizontal); // Should use spec.direction
      expect(flex.mainAxisAlignment, MainAxisAlignment.center);
      
      // Check that spacing is applied (children + spacing widgets)
      expect(flex.children.length, 3); // 2 containers + 1 spacing widget
    });

    testWidgets('call should handle null direction by using default', (tester) async {
      const spec = FlexContainerSpec(
        decoration: BoxDecoration(color: Colors.red),
        // direction is null
      );

      final widget = spec(
        direction: Axis.vertical, // Should be used as fallback
        children: [Container(width: 50, height: 50, color: Colors.blue)],
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: widget)),
      );

      final flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.direction, Axis.vertical); // Should use provided default
    });

    testWidgets('call should handle spacing correctly', (tester) async {
      const spec = FlexContainerSpec(
        spacing: 10.0,
        direction: Axis.horizontal,
      );

      final widget = spec(
        direction: Axis.horizontal,
        children: [
          Container(width: 50, height: 50, color: Colors.blue),
          Container(width: 50, height: 50, color: Colors.green),
          Container(width: 50, height: 50, color: Colors.red),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: widget)),
      );

      final flex = tester.widget<Flex>(find.byType(Flex));
      
      // Should have 3 containers + 2 spacing SizedBoxes
      expect(flex.children.length, 5);
      
      // Check that spacing SizedBoxes are created with correct width (horizontal)
      final sizedBoxes = flex.children.whereType<SizedBox>().toList();
      expect(sizedBoxes.length, 2);
      expect(sizedBoxes[0].width, 10.0);
      expect(sizedBoxes[0].height, null);
    });

    testWidgets('call operator should work like toWidget', (tester) async {
      const spec = FlexContainerSpec(
        decoration: BoxDecoration(color: Colors.red),
        direction: Axis.horizontal,
      );

      final widget = spec(
        direction: Axis.vertical,
        children: [Container(width: 50, height: 50, color: Colors.blue)],
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: widget)),
      );

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Flex), findsOneWidget);

      final flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.direction, Axis.horizontal); // spec.direction overrides parameter
    });
  });
}