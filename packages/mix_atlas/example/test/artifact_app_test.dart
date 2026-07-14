import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas_example/artifact_app.dart';
import 'package:mix_atlas_example/artifacts/capture_bundle.dart';
import 'package:mix_atlas_example/artifacts/capture_loader.dart';

import 'artifact_fixture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpWidgetSize();

  testWidgets('opens a verified partial capture and switches themes', (
    tester,
  ) async {
    final fixture = ArtifactFixture.create();
    await tester.pumpWidget(
      ArtifactAtlasApp(
        loader: CaptureLoader(source: fixture.source()),
        clock: () => DateTime.utc(2026, 7, 13, 14, 30),
      ),
    );

    expect(find.text('btwld/remix'), findsOneWidget);
    expect(find.text('main'), findsOneWidget);
    expect(find.text('atlas/fortal/capture.json'), findsOneWidget);
    expect(find.text('Open Fortal'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('open-fortal')));
    await tester.pumpAndSettle();

    expect(find.text('Static repository capture'), findsOneWidget);
    expect(find.text(fixtureCommit), findsOneWidget);
    expect(find.text('Button'), findsWidgets);
    expect(find.text('Capture health'), findsOneWidget);
    expect(find.text('4 supported · 1 unsupported'), findsNothing);
    expect(find.text('3 supported · 1 unsupported'), findsOneWidget);
    expect(find.textContaining('RemixButtonStyler'), findsOneWidget);
    expect(find.byKey(const ValueKey('artifact-image-light')), findsOneWidget);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('artifact-image-dark')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a precise network failure and retries successfully', (
    tester,
  ) async {
    final fixture = ArtifactFixture.create();
    final loader = RetryFixtureLoader(
      success: CaptureLoader(source: fixture.source()),
    );
    await tester.pumpWidget(ArtifactAtlasApp(loader: loader));

    await tester.tap(find.byKey(const ValueKey('open-fortal')));
    await tester.pumpAndSettle();

    expect(find.text('GitHub could not be reached'), findsOneWidget);
    expect(find.textContaining('Connection interrupted'), findsOneWidget);
    expect(find.byKey(const ValueKey('retry-capture')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('retry-capture')));
    await tester.pumpAndSettle();

    expect(find.text('Static repository capture'), findsOneWidget);
    expect(loader.attempts, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('switches from the PNG oracle to the portable reconstruction', (
    tester,
  ) async {
    final fixture = ArtifactFixture.create()..addPortableButtonCapture();
    await tester.pumpWidget(
      ArtifactAtlasApp(loader: CaptureLoader(source: fixture.source())),
    );

    await tester.tap(find.byKey(const ValueKey('open-fortal')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reconstructed'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('portable-component-button')),
      findsOneWidget,
    );
    expect(
      find.text('Portable JSON · strict decoded · no Remix runtime'),
      findsOneWidget,
    );
    expect(find.text('1 document · 1 recipe'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('component-state-selector')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}

void setUpWidgetSize() {
  setUp(() {
    final binding = TestWidgetsFlutterBinding.instance;
    binding.platformDispatcher.views.first.physicalSize = const Size(1280, 800);
    binding.platformDispatcher.views.first.devicePixelRatio = 1;
  });
  tearDown(() {
    final binding = TestWidgetsFlutterBinding.instance;
    binding.platformDispatcher.views.first.resetPhysicalSize();
    binding.platformDispatcher.views.first.resetDevicePixelRatio();
  });
}

final class RetryFixtureLoader implements ArtifactCaptureLoader {
  RetryFixtureLoader({required this.success});

  final ArtifactCaptureLoader success;
  int attempts = 0;

  @override
  Future<LoadedCapture> load(ArtifactRepositoryRequest request) {
    attempts += 1;
    if (attempts == 1) {
      throw const ArtifactLoadException(
        ArtifactFailureKind.network,
        'Connection interrupted while reading capture.json.',
      );
    }

    return success.load(request);
  }
}
