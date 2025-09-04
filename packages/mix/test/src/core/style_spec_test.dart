import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('StyleSpecWidgetBuilder', () {
    testWidgets('createBuilder creates widget with resolved spec',
        (WidgetTester tester) async {
      const testColor = Colors.blue;
      const testPadding = EdgeInsets.all(16);
      final style = BoxStyler()
        .color(testColor)
        .padding(EdgeInsetsMix.all(16));

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final styleSpec = style.build(context);
              return styleSpec.createBuilder((context, spec) {
                return Container(
                  decoration: spec.decoration,
                  padding: spec.padding,
                  child: const Text('Test'),
                );
              });
            },
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(testColor));
      expect(container.padding, equals(testPadding));
    });

    testWidgets('createBuilder works with TextSpec', (WidgetTester tester) async {
      const testFontSize = 20.0;
      const testColor = Colors.red;
      final style = TextStyler()
        .fontSize(testFontSize)
        .color(testColor);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final styleSpec = style.build(context);
              return styleSpec.createBuilder((context, spec) {
                return Text(
                  'Test Text',
                  style: spec.style,
                );
              });
            },
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Test Text'));
      expect(text.style?.fontSize, equals(testFontSize));
      expect(text.style?.color, equals(testColor));
    });

    testWidgets('createBuilder works with IconSpec', (WidgetTester tester) async {
      const testSize = 30.0;
      const testColor = Colors.green;
      final style = IconStyler()
        .size(testSize)
        .color(testColor);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final styleSpec = style.build(context);
              return styleSpec.createBuilder((context, spec) {
                return Icon(
                  Icons.star,
                  size: spec.size,
                  color: spec.color,
                );
              });
            },
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, equals(testSize));
      expect(icon.color, equals(testColor));
    });

    testWidgets('createBuilder applies modifiers', (WidgetTester tester) async {
      // Create a modifier mix
      final opacityModifierMix = OpacityModifierMix(opacity: 0.5);
      final modifierConfig = ModifierConfig(modifiers: [opacityModifierMix]);
      
      final style = BoxStyler()
        .color(Colors.blue)
        .modifier(modifierConfig);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final styleSpec = style.build(context);
              return styleSpec.createBuilder((context, spec) {
                return Container(
                  decoration: spec.decoration,
                  width: 100,
                  height: 100,
                );
              });
            },
          ),
        ),
      );

      // Check that Opacity modifier is applied
      expect(find.byType(Opacity), findsOneWidget);
      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, equals(0.5));
    });

    testWidgets('createBuilder works with animation', (WidgetTester tester) async {
      final style = BoxStyler()
        .color(Colors.blue)
        .animate(AnimationConfig.curve(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ));

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final styleSpec = style.build(context);
              return styleSpec.createBuilder((context, spec) {
                return Container(
                  decoration: spec.decoration,
                  width: 100,
                  height: 100,
                );
              });
            },
          ),
        ),
      );

      // Animation should be set up
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('createBuilder can create custom widgets',
        (WidgetTester tester) async {
      final style = BoxStyler()
        .padding(EdgeInsetsMix.all(20))
        .color(Colors.purple);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final styleSpec = style.build(context);
              return styleSpec.createBuilder((context, spec) {
                // Create a custom widget structure
                final boxColor = (spec.decoration as BoxDecoration?)?.color;
                return Material(
                  color: boxColor,
                  child: Padding(
                    padding: spec.padding ?? EdgeInsets.zero,
                    child: const Text('Custom Widget'),
                  ),
                );
              });
            },
          ),
        ),
      );

      expect(find.byType(Material), findsOneWidget);
      expect(find.byType(Padding), findsOneWidget);
      expect(find.text('Custom Widget'), findsOneWidget);

      final material = tester.widget<Material>(find.byType(Material));
      expect(material.color, equals(Colors.purple));

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(20)));
    });

    testWidgets('createBuilder preserves type safety',
        (WidgetTester tester) async {
      final boxStyle = BoxStyler()
        .color(Colors.blue)
        .padding(EdgeInsetsMix.all(10));

      final textStyle = TextStyler()
        .fontSize(16)
        .color(Colors.black);

      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              Builder(
                builder: (context) {
                  final boxSpec = boxStyle.build(context);
                  // BoxSpec type is preserved
                  return boxSpec.createBuilder((context, spec) {
                    // spec is typed as BoxSpec
                    return Container(
                      decoration: spec.decoration,
                      padding: spec.padding,
                    );
                  });
                },
              ),
              Builder(
                builder: (context) {
                  final textSpec = textStyle.build(context);
                  // TextSpec type is preserved
                  return textSpec.createBuilder((context, spec) {
                    // spec is typed as TextSpec
                    return Text(
                      'Test',
                      style: spec.style,
                    );
                  });
                },
              ),
            ],
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });
  });
}