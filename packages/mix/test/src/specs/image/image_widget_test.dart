import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('Default parameters for StyledImage matches Image', () {
    testWidgets('should have the same default parameters', (tester) async {
      final imageProvider = mockImageProvider();
      final styledImageKey = const Key('styled-image');
      final imageKey = const Key('image');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                StyledImage(key: styledImageKey, image: imageProvider),
                Image(key: imageKey, image: imageProvider),
              ],
            ),
          ),
        ),
      );

      /// Get widgets by key
      final styledImageFinder = find.byKey(styledImageKey);
      final imageFinder = find.byKey(imageKey);

      /// Get the default parameters for StyledImage and Image

      /// Find the Image widget inside the StyledImage widget
      final styledImage = tester.widget<Image>(
        find.descendant(of: styledImageFinder, matching: find.byType(Image)),
      );
      final image = tester.widget<Image>(imageFinder);

      /// Compare the default parameters
      expect(styledImage.fit, image.fit);
      expect(styledImage.alignment, image.alignment);
      expect(styledImage.color, image.color);
      expect(styledImage.colorBlendMode, image.colorBlendMode);
      expect(styledImage.repeat, image.repeat);
      expect(styledImage.centerSlice, image.centerSlice);
      expect(styledImage.filterQuality, image.filterQuality);
      expect(styledImage.excludeFromSemantics, image.excludeFromSemantics);
      expect(styledImage.gaplessPlayback, image.gaplessPlayback);
      expect(styledImage.isAntiAlias, image.isAntiAlias);
      expect(styledImage.matchTextDirection, image.matchTextDirection);
      expect(styledImage.width, image.width);
      expect(styledImage.height, image.height);
      expect(styledImage.semanticLabel, image.semanticLabel);
      expect(styledImage.opacity, image.opacity);
      expect(styledImage.frameBuilder, image.frameBuilder);
      expect(styledImage.loadingBuilder, image.loadingBuilder);
      expect(styledImage.errorBuilder, image.errorBuilder);
      expect(styledImage.excludeFromSemantics, image.excludeFromSemantics);
      expect(styledImage.gaplessPlayback, image.gaplessPlayback);
      expect(styledImage.isAntiAlias, image.isAntiAlias);
      expect(styledImage.matchTextDirection, image.matchTextDirection);
      expect(styledImage.image, image.image);
    });
  });

  group('ImageStyler.call', () {
    testWidgets('forwards image widget parameters', (tester) async {
      final imageProvider = mockImageProvider();
      final widgetImageProvider = mockImageProvider();
      final opacity = AlwaysStoppedAnimation(0.5);

      Widget frameBuilder(
        BuildContext context,
        Widget child,
        int? frame,
        bool wasSynchronouslyLoaded,
      ) {
        return child;
      }

      Widget loadingBuilder(
        BuildContext context,
        Widget child,
        ImageChunkEvent? loadingProgress,
      ) {
        return child;
      }

      Widget errorBuilder(
        BuildContext context,
        Object error,
        StackTrace? stackTrace,
      ) {
        return const SizedBox();
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageStyler(image: imageProvider).call(
              image: widgetImageProvider,
              frameBuilder: frameBuilder,
              loadingBuilder: loadingBuilder,
              errorBuilder: errorBuilder,
              opacity: opacity,
            ),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));

      expect(image.image, widgetImageProvider);
      expect(image.frameBuilder, same(frameBuilder));
      expect(image.loadingBuilder, same(loadingBuilder));
      expect(image.errorBuilder, same(errorBuilder));
      expect(image.opacity, opacity);
    });
  });
}
