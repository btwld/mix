import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

extension TokenTestHelper on WidgetTester {
  /// Pumps a widget wrapped with [MixScope] and the provided tokens.
  ///
  /// Use [useDirectionality] when testing widgets that require text direction
  /// (e.g., FlexBox, StackBox, Icon).
  /// Use [useMaterialApp] when testing widgets that require Material context
  /// (e.g., StyledText).
  Future<void> pumpWithTokens(
    Map<MixToken, Object> tokens, {
    required Widget child,
    bool useDirectionality = false,
    bool useMaterialApp = false,
  }) {
    Widget content = MixScope(tokens: tokens, child: child);

    if (useMaterialApp) {
      content = MaterialApp(home: content);
    } else if (useDirectionality) {
      content = Directionality(
        textDirection: TextDirection.ltr,
        child: content,
      );
    }

    return pumpWidget(content);
  }
}

void main() {
  group('TokenStyleMixin', () {
    group('useToken', () {
      test('resolves token value when builder is called', () {
        const colorToken = ColorToken('test.color');
        const testColor = Colors.red;
        Color? capturedColor;

        final style =
            BoxStyler() //
                .useToken(colorToken, (color) {
                  capturedColor = color;
                  return BoxStyler().color(color);
                });

        // Get the variant builder and execute it
        final variantBuilder =
            style.$variants!.first.variant as ContextVariantBuilder<BoxStyler>;

        final mockContext = MockBuildContext(tokens: {colorToken: testColor});
        variantBuilder.build(mockContext);

        expect(capturedColor, equals(testColor));
      });

      test('can be chained with other style methods', () {
        const colorToken = ColorToken('test.color');

        final style = BoxStyler()
            .width(100)
            .useToken(colorToken, BoxStyler().color)
            .height(200);

        // Should have width set
        expect(style.$constraints, isNotNull);

        // Should have variant
        expect(style.$variants, isNotNull);
        expect(style.$variants!.length, 1);
      });

      test('can be used with different token types', () {
        const doubleToken = DoubleToken('test.space');
        const testValue = 16.0;

        final style =
            BoxStyler() //
                .useToken(doubleToken, BoxStyler().paddingAll);

        expect(style.$variants, isNotNull);
        expect(style.$variants!.first.variant, isA<ContextVariantBuilder>());

        // Verify the builder uses the token value
        final variantBuilder =
            style.$variants!.first.variant as ContextVariantBuilder<BoxStyler>;
        final mockContext = MockBuildContext(tokens: {doubleToken: testValue});

        final builtStyle = variantBuilder.build(mockContext);
        expect(builtStyle.$padding, isNotNull);
      });

      test('multiple useToken calls create multiple variants', () {
        const colorToken = ColorToken('test.color');
        const spaceToken = SpaceToken('test.space');

        final style = BoxStyler()
            .useToken(colorToken, BoxStyler().color)
            .useToken(spaceToken, BoxStyler().paddingAll);

        expect(style.$variants, isNotNull);
        expect(style.$variants!.length, 2);

        final mockContext = MockBuildContext(
          tokens: {colorToken: Colors.red, spaceToken: 16.0},
        );

        final resolvedStyle = style.$variants!
            .map((v) => v.variant as ContextVariantBuilder<BoxStyler>)
            .map((v) => v.build(mockContext))
            .reduce((a, b) => a.merge(b))
            .resolve(mockContext);

        expect(
          (resolvedStyle.spec.decoration as BoxDecoration).color,
          equals(Colors.red),
        );
        expect(resolvedStyle.spec.padding, equals(EdgeInsets.all(16.0)));
      });
    });

    group('useToken widget integration', () {
      testWidgets('resolves token in widget tree', (tester) async {
        const colorToken = ColorToken('test.primary');
        const testColor = Colors.blue;

        final style = BoxStyler()
            .width(100)
            .height(100)
            .useToken(colorToken, BoxStyler().color);

        await tester.pumpWithTokens({
          colorToken: testColor,
        }, child: Box(style: style));

        // Find the Container and verify its decoration
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration?;
        expect(decoration?.color, equals(testColor));
      });

      testWidgets('updates when token value changes', (tester) async {
        const colorToken = ColorToken('test.primary');
        final tokenNotifier = ValueNotifier<Color>(Colors.red);

        final style = BoxStyler()
            .width(100)
            .height(100)
            .useToken(colorToken, BoxStyler().color);

        await tester.pumpWidget(
          ValueListenableBuilder<Color>(
            valueListenable: tokenNotifier,
            builder: (context, color, _) {
              return MixScope(
                tokens: {colorToken: color},
                child: Box(style: style),
              );
            },
          ),
        );

        // Verify initial color
        var container = tester.widget<Container>(find.byType(Container));
        var decoration = container.decoration as BoxDecoration?;
        expect(decoration?.color, equals(Colors.red));

        // Update token value
        tokenNotifier.value = Colors.green;
        await tester.pump();

        // Verify updated color
        container = tester.widget<Container>(find.byType(Container));
        decoration = container.decoration as BoxDecoration?;
        expect(decoration?.color, equals(Colors.green));
      });

      testWidgets('works with TextStyler', (tester) async {
        const colorToken = ColorToken('test.text');
        const testColor = Colors.purple;

        final style = TextStyler().useToken(
          colorToken,
          (color) => TextStyler().color(color),
        );

        await tester.pumpWithTokens(
          {colorToken: testColor},
          useMaterialApp: true,
          child: StyledText('Hello', style: style),
        );

        // Find the Text widget and verify color
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.color, equals(testColor));
      });

      testWidgets('works alongside other variants', (tester) async {
        const colorToken = ColorToken('test.primary');
        const testColor = Colors.blue;

        final style = BoxStyler()
            .width(100)
            .height(100)
            .color(Colors.grey) // default color
            .useToken(colorToken, (color) => BoxStyler().color(color))
            .onDark(BoxStyler().color(Colors.black));

        await tester.pumpWithTokens({
          colorToken: testColor,
        }, child: Box(style: style));

        // Token should be applied (overriding default grey)
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration?;
        expect(decoration?.color, equals(testColor));
      });
    });

    group('useToken widget tests for all Stylers', () {
      // These widget tests verify that useToken resolves DoubleToken values
      // correctly in the widget tree for all Styler types.

      testWidgets('BoxStyler resolves DoubleToken for width', (tester) async {
        const sizeToken = DoubleToken('test.size');
        const testSize = 150.0;

        final style = BoxStyler().useToken(sizeToken, BoxStyler().width);

        await tester.pumpWithTokens({
          sizeToken: testSize,
        }, child: Box(style: style));

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.constraints?.maxWidth, equals(testSize));
        expect(container.constraints?.minWidth, equals(testSize));
      });

      testWidgets('FlexBoxStyler resolves DoubleToken for spacing', (
        tester,
      ) async {
        const spacingToken = DoubleToken('test.spacing');
        const testSpacing = 24.0;

        final style = FlexBoxStyler().row().useToken(
          spacingToken,
          FlexBoxStyler().spacing,
        );

        await tester.pumpWithTokens(
          {spacingToken: testSpacing},
          useDirectionality: true,
          child: FlexBox(
            style: style,
            children: const [SizedBox(width: 10), SizedBox(width: 10)],
          ),
        );

        // Verify the flex renders without error with token-resolved spacing
        expect(find.byType(FlexBox), findsOneWidget);
      });

      testWidgets('StackBoxStyler resolves DoubleToken for padding', (
        tester,
      ) async {
        const paddingToken = DoubleToken('test.padding');
        const testPadding = 16.0;

        final style = StackBoxStyler().useToken(
          paddingToken,
          StackBoxStyler().paddingAll,
        );

        await tester.pumpWithTokens(
          {paddingToken: testPadding},
          useDirectionality: true,
          child: StackBox(
            style: style,
            children: const [SizedBox(width: 50, height: 50)],
          ),
        );

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, equals(EdgeInsets.all(testPadding)));
      });

      testWidgets('TextStyler resolves DoubleToken for fontSize', (
        tester,
      ) async {
        const fontSizeToken = DoubleToken('test.fontSize');
        const testFontSize = 24.0;

        final style = TextStyler().useToken(
          fontSizeToken,
          TextStyler().fontSize,
        );

        await tester.pumpWithTokens(
          {fontSizeToken: testFontSize},
          useMaterialApp: true,
          child: StyledText('Hello', style: style),
        );

        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, equals(testFontSize));
      });

      testWidgets('IconStyler resolves DoubleToken for size', (tester) async {
        const sizeToken = DoubleToken('test.iconSize');
        const testSize = 48.0;

        final style = IconStyler().useToken(sizeToken, IconStyler().size);

        await tester.pumpWithTokens(
          {sizeToken: testSize},
          useDirectionality: true,
          child: StyledIcon(icon: Icons.star, style: style),
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.size, equals(testSize));
      });

      testWidgets('FlexStyler resolves DoubleToken for spacing', (
        tester,
      ) async {
        const spacingToken = DoubleToken('test.flexSpacing');
        const testSpacing = 12.0;

        final style = FlexStyler().row().useToken(
          spacingToken,
          FlexStyler().spacing,
        );

        // FlexStyler is typically used via FlexBoxStyler, but we can test
        // that the token resolution works by checking the style compiles
        // and a widget with this configuration renders
        await tester.pumpWithTokens(
          {spacingToken: testSpacing},
          useDirectionality: true,
          child: FlexBox(
            style: FlexBoxStyler().flex(style),
            children: const [SizedBox(width: 10), SizedBox(width: 10)],
          ),
        );

        expect(find.byType(FlexBox), findsOneWidget);
      });

      testWidgets('StackStyler resolves DoubleToken via StackBoxStyler', (
        tester,
      ) async {
        // StackStyler doesn't have double properties directly, but we can
        // verify useToken works by testing via StackBoxStyler integration
        const sizeToken = DoubleToken('test.stackSize');
        const testSize = 200.0;

        final style = StackBoxStyler().useToken(
          sizeToken,
          StackBoxStyler().width,
        );

        await tester.pumpWithTokens(
          {sizeToken: testSize},
          useDirectionality: true,
          child: StackBox(
            style: style,
            children: const [SizedBox(width: 50, height: 50)],
          ),
        );

        final constrainedBox = tester.widget<ConstrainedBox>(
          find.byType(ConstrainedBox),
        );
        expect(constrainedBox.constraints.maxWidth, equals(testSize));
      });

      testWidgets('ImageStyler resolves DoubleToken for width', (tester) async {
        const widthToken = DoubleToken('test.imageWidth');
        const testWidth = 100.0;

        final style = ImageStyler().useToken(widthToken, ImageStyler().width);

        await tester.pumpWithTokens(
          {widthToken: testWidth},
          useDirectionality: true,
          child: StyledImage(style: style, image: mockImageProvider()),
        );

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.width, equals(testWidth));
      });
    });
  });
}
