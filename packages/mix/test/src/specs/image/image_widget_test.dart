import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/override_modifiers_order.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('StyledImage', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('receive all the attributes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledImage(
              style: Style(
                $image.width(152),
                $image.height(152),
                $image.color.black(),
                $image.repeat(),
                $image.fit.fill(),
                $image.centerSlice.fromLTRB(1, 2, 3, 4),
                $image.alignment.bottomLeft(),
                $image.filterQuality.high(),
                $image.colorBlendMode.colorDodge(),
              ),
              image: FileImage(File('test_resources/logo.png')),
            ),
          ),
        ),
      );

      final imageWidget = tester.element(find.byType(Image)).widget as Image;

      expect(imageWidget.width, 152);
      expect(imageWidget.height, 152);
      expect(imageWidget.color, Colors.black);
      expect(imageWidget.repeat, ImageRepeat.repeat);
      expect(imageWidget.fit, BoxFit.fill);
      expect(imageWidget.centerSlice, const Rect.fromLTRB(1, 2, 3, 4));
      expect(imageWidget.alignment, Alignment.bottomLeft);
      expect(imageWidget.filterQuality, FilterQuality.high);
      expect(imageWidget.colorBlendMode, BlendMode.colorDodge);
    });

    testWidgets('can receive a modifier', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledImage(
              style: Style(
                $image.width(152),
                $image.height(152),
                $with.opacity(0.5),
              ),
              image: FileImage(File('test_resources/logo.png')),
            ),
          ),
        ),
      );

      final opacityWidget =
          tester.element(find.byType(Opacity)).widget as Opacity;

      expect(opacityWidget.opacity, 0.5);
    });

    testWidgets(
      'can inherit style from the parent StyledWidget',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          Box(
            style: Style(
              $image.width(152),
              $image.height(152),
              $image.color.black(),
            ),
            child: StyledImage(
              image: FileImage(File('test_resources/logo.png')),
            ),
          ),
        );

        final imageWidget = tester.element(find.byType(Image)).widget as Image;

        expect(imageWidget.width, 152);
        expect(imageWidget.height, 152);
        expect(imageWidget.color, Colors.black);
      },
    );

    testWidgets(
      'StyleImage should apply modifiers only once',
      (tester) async {
        await tester.pumpMaterialApp(
          StyledImage(
            style: Style(
              $box.height(100),
              $box.width(100),
              $with.align(),
            ),
            image: FileImage(File('test_resources/logo.png')),
          ),
        );

        expect(find.byType(Align), findsOneWidget);
      },
    );

    testWidgets('AnimatedStyledImage should animate ImageSpec properties',
        (WidgetTester tester) async {
      final imageProvider = FileImage(File('test_resources/logo.png'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledImage(
              image: imageProvider,
              style: Style(
                $image.width(100),
                $image.height(100),
              ).animate(
                duration: const Duration(milliseconds: 500),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      expect(tester.widget<Image>(find.byType(Image)).width, 100);
      expect(tester.widget<Image>(find.byType(Image)).height, 100);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledImage(
              image: imageProvider,
              style: Style(
                $image.width(200),
                $image.height(200),
              ).animate(duration: const Duration(milliseconds: 500)),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 250));
      expect(tester.widget<Image>(find.byType(Image)).width, 150);
      expect(tester.widget<Image>(find.byType(Image)).height, 150);

      await tester.pump(const Duration(milliseconds: 250));
      expect(tester.widget<Image>(find.byType(Image)).width, 200);
      expect(tester.widget<Image>(find.byType(Image)).height, 200);
    });

    testWidgets('ImageSpecWidget should apply ImageSpec properties',
        (WidgetTester tester) async {
      const spec = ImageSpec(
        width: 150,
        height: 150,
        color: Colors.red,
        fit: BoxFit.cover,
        repeat: ImageRepeat.noRepeat,
        alignment: Alignment.bottomLeft,
        centerSlice: Rect.fromLTRB(1, 2, 3, 4),
        filterQuality: FilterQuality.high,
        colorBlendMode: BlendMode.colorDodge,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageSpecWidget(
              spec: spec,
              image: FileImage(File('test_resources/logo.png')),
            ),
          ),
        ),
      );

      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.width, 150);
      expect(imageWidget.height, 150);
      expect(imageWidget.color, Colors.red);
      expect(imageWidget.fit, BoxFit.cover);
    });

    testWidgets(
      'Renders modifiers in the correct order with many overrides',
      (tester) async {
        testOverrideModifiersOrder(
          tester,
          widgetBuilder: (style, orderOfModifiers) {
            return StyledImage(
              image: FileImage(File('test_resources/logo.png')),
              style: style,
              orderOfModifiers: orderOfModifiers,
            );
          },
        );
      },
    );
  });
}