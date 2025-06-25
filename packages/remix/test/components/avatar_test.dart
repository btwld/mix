import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

import '../utils/interaction_tests.dart';

class TestImageProvider extends ImageProvider<TestImageProvider> {
  final ui.Image image;

  TestImageProvider(this.image);

  @override
  Future<TestImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }

  @override
  ImageStreamCompleter loadImage(
      TestImageProvider key, ImageDecoderCallback decode) {
    return OneFrameImageStreamCompleter(Future.value(ImageInfo(image: image)));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TestImageProvider;

  @override
  int get hashCode => 0;
}

Future<ui.Image> createTestImage() async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final paint = Paint()..color = const Color(0xFF00FF00);
  canvas.drawRect(const Rect.fromLTWH(0, 0, 10, 10), paint);
  return recorder.endRecording().toImage(10, 10);
}

void validateImageDecoration(
    WidgetTester tester, ImageProvider imageProvider, bool isForeground) {
  final containers = tester.widgetList<Container>(find.byType(Container));
  final lastContainer = containers.last;
  final decoration = isForeground
      ? lastContainer.foregroundDecoration
      : lastContainer.decoration;

  expect(decoration, isNotNull);
  expect(decoration, isA<BoxDecoration>());

  final boxDecoration = decoration as BoxDecoration;
  expect(boxDecoration.image, isNotNull);
  expect(boxDecoration.image!.image, equals(imageProvider));
}

void main() {
  group('RxAvatar', () {
    group('Constructor', () {
      const backgroundImage = NetworkImage('https://background.com/avatar.png');
      const foregroundImage = NetworkImage('https://foreground.com/avatar.png');
      const variants = [Variant('primary')];
      final style = RxAvatarStyle();
      void onBackgroundImageError(error, stackTrace) {}
      void onForegroundImageError(error, stackTrace) {}

      testWidgets('should initialize with correct properties',
          (WidgetTester tester) async {
        final widget = RxAvatar(
          backgroundImage: backgroundImage,
          foregroundImage: foregroundImage,
          onBackgroundImageError: onBackgroundImageError,
          onForegroundImageError: onForegroundImageError,
          style: style,
          variants: variants,
        );

        RxAvatar(
          backgroundImage: backgroundImage,
          foregroundImage: foregroundImage,
          label: 'LO',
        );

        expect(widget.backgroundImage, backgroundImage);
        expect(widget.foregroundImage, foregroundImage);
        expect(widget.style, style);
        expect(widget.variants, variants);
        expect(widget.child, isNull);
      });

      testWidgets('Raw should initialize with correct properties',
          (WidgetTester tester) async {
        const child = Icon(Icons.person);

        final widget = RxAvatar.raw(
          backgroundImage: backgroundImage,
          foregroundImage: foregroundImage,
          onBackgroundImageError: onBackgroundImageError,
          onForegroundImageError: onForegroundImageError,
          style: style,
          variants: variants,
          child: child,
        );

        expect(widget.backgroundImage, backgroundImage);
        expect(widget.foregroundImage, foregroundImage);
        expect(widget.onBackgroundImageError, onBackgroundImageError);
        expect(widget.onForegroundImageError, onForegroundImageError);
        expect(widget.style, style);
        expect(widget.variants, variants);
        expect(widget.child, child);
      });

      testWidgets('should render correct UI output for background image',
          (WidgetTester tester) async {
        final testImage = await createTestImage();
        final imageProvider = TestImageProvider(testImage);

        await tester.pumpRxWidget(
          RxAvatar(
            backgroundImage: imageProvider,
            style: style,
          ),
        );

        validateImageDecoration(tester, imageProvider, false);
      });

      testWidgets('should render correct UI output for foreground image',
          (WidgetTester tester) async {
        final testImage = await createTestImage();
        final imageProvider = TestImageProvider(testImage);

        await tester.pumpRxWidget(
          RxAvatar(
            foregroundImage: imageProvider,
            style: style,
          ),
        );

        validateImageDecoration(tester, imageProvider, true);
      });

      testWidgets('Raw should render correct UI output for background image',
          (WidgetTester tester) async {
        final testImage = await createTestImage();
        final imageProvider = TestImageProvider(testImage);

        await tester.pumpRxWidget(
          RxAvatar.raw(
            backgroundImage: imageProvider,
            style: style,
          ),
        );

        validateImageDecoration(tester, imageProvider, false);
      });

      testWidgets('Raw should render correct UI output for foreground image',
          (WidgetTester tester) async {
        final testImage = await createTestImage();
        final imageProvider = TestImageProvider(testImage);

        await tester.pumpRxWidget(
          RxAvatar.raw(
            foregroundImage: imageProvider,
            style: style,
          ),
        );

        validateImageDecoration(tester, imageProvider, true);
      });

      group('Assertions', () {
        testWidgets(
            'should throw assertion error when backgroundImage is null and onBackgroundImageError is provided',
            (WidgetTester tester) async {
          expect(
            () => RxAvatar.raw(
              backgroundImage: null,
              onBackgroundImageError: (exception, stackTrace) {},
            ),
            throwsAssertionError,
          );
        });

        testWidgets(
            'should throw assertion error when foregroundImage is null and onForegroundImageError is provided',
            (WidgetTester tester) async {
          expect(
            () => RxAvatar.raw(
              foregroundImage: null,
              onForegroundImageError: (exception, stackTrace) {},
            ),
            throwsAssertionError,
          );
        });

        testWidgets(
            'should not throw assertion error when backgroundImage and onBackgroundImageError are both provided',
            (WidgetTester tester) async {
          final testImage = await createTestImage();
          final imageProvider = TestImageProvider(testImage);

          expect(
            () => RxAvatar.raw(
              backgroundImage: imageProvider,
              onBackgroundImageError: (exception, stackTrace) {},
            ),
            returnsNormally,
          );
        });

        testWidgets(
            'should not throw assertion error when foregroundImage and onForegroundImageError are both provided',
            (WidgetTester tester) async {
          final testImage = await createTestImage();
          final imageProvider = TestImageProvider(testImage);

          expect(
            () => RxAvatar.raw(
              foregroundImage: imageProvider,
              onForegroundImageError: (exception, stackTrace) {},
            ),
            returnsNormally,
          );
        });
      });
    });

    testWidgets('should apply style correctly', (WidgetTester tester) async {
      final style = RxAvatarStyle()..container.color.red();

      final widget = RxAvatar(
        style: style,
      );

      await tester.pumpRxWidget(widget);

      final containerFinder = find.byType(Container);
      final containerWidget = tester.widgetList<Container>(containerFinder).first;
      final decoration = containerWidget.decoration as ShapeDecoration;
      expect(decoration.color, Colors.red);
    });
  });
}
