/// Golden-snapshot harness for component atlases.
///
/// Test-only entrypoint (depends on `flutter_test`); import from test files
/// and `flutter_test_config.dart`, never from app code.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mix_atlas.dart';

/// Configuration for atlas golden generation.
abstract final class AtlasGoldens {
  /// Operating systems whose rendered bytes match the committed baselines.
  ///
  /// Font rasterization differs subtly across platforms, so goldens are only
  /// generated and compared on the platforms listed here; everywhere else
  /// [expectAtlasGolden] skips the comparison. Override in
  /// `flutter_test_config.dart` if your team generates goldens elsewhere.
  static Set<String> platforms = {'macos'};

  /// Maximum fraction of differing pixels accepted by the local comparator.
  ///
  /// Keep this at zero in canonical CI for byte-exact enforcement. A very
  /// small local-only value can absorb host OS text-rasterization differences
  /// while still comparing the complete image.
  static double precisionTolerance = 0.0;
}

/// Producer/portable parity defaults shared by adapter test suites.
abstract final class AtlasParity {
  /// Existing macOS raster tolerance used by the Fortal capture.
  static double precisionTolerance = 0.0002;

  /// Deterministic phase used for spinners and other looping animations.
  static Duration animationPhase = const Duration(milliseconds: 200);
}

/// Renders producer and portable widgets independently and compares every
/// rasterized pixel using [AtlasParity] defaults.
///
/// Callers are responsible for supplying the same theme, constraints, and
/// contact-sheet chrome to both widgets. A mismatch throws a [TestFailure]
/// with the measured differing-pixel fraction.
Future<void> expectAtlasWidgetParity(
  WidgetTester tester, {
  required Widget producer,
  required Widget portable,
  double? precisionTolerance,
  Duration? animationPhase,
}) async {
  final producerBytes = await _renderParityWidget(
    tester,
    producer,
    phase: animationPhase ?? AtlasParity.animationPhase,
  );
  final portableBytes = await _renderParityWidget(
    tester,
    portable,
    phase: animationPhase ?? AtlasParity.animationPhase,
  );
  final comparison = await GoldenFileComparator.compareLists(
    producerBytes,
    portableBytes,
  );
  final tolerance = precisionTolerance ?? AtlasParity.precisionTolerance;
  final passed = comparison.passed || comparison.diffPercent <= tolerance;
  if (!passed) {
    final difference = comparison.diffPercent;
    comparison.dispose();
    throw TestFailure(
      'Producer and portable contact sheets differ by '
      '${difference.toStringAsFixed(8)} pixels; tolerance is '
      '${tolerance.toStringAsFixed(8)}.',
    );
  }
  comparison.dispose();
}

Future<Uint8List> _renderParityWidget(
  WidgetTester tester,
  Widget child, {
  required Duration phase,
}) async {
  final key = UniqueKey();
  await tester.pumpWidget(
    Directionality(
      textDirection: .ltr,
      child: Align(
        alignment: Alignment.topLeft,
        child: RepaintBoundary(key: key, child: child),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(phase);
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(key));
  final imageFuture = boundary.toImage(pixelRatio: 1);

  // Raster capture and PNG encoding are engine-backed asynchronous work.
  // Flutter's own golden matcher performs both outside the fake-async test
  // zone so a following pump cannot deadlock behind an engine callback.
  final bytes = await tester.runAsync<Uint8List>(() async {
    final image = await imageFuture;
    try {
      final data = await image.toByteData(format: .png);
      if (data == null) {
        throw TestFailure('Could not encode an Atlas parity raster.');
      }

      return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    } finally {
      image.dispose();
    }
  });
  if (bytes == null) {
    throw TestFailure('Atlas parity raster capture did not complete.');
  }

  return bytes;
}

/// Loads Roboto and MaterialIcons from the Flutter SDK cache so atlas
/// goldens render legible text and icons instead of the block test font.
///
/// Call from `flutter_test_config.dart` before running tests. Throws when
/// the fonts cannot be located: silently falling back to the block font
/// would produce baselines that mismatch every correctly-rendered run.
Future<void> loadAtlasFonts() async {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  final fontsDir = flutterRoot == null
      ? null
      : Directory('$flutterRoot/bin/cache/artifacts/material_fonts');
  if (fontsDir == null || !fontsDir.existsSync()) {
    throw StateError(
      'mix_atlas could not locate the Flutter SDK material fonts '
      '(FLUTTER_ROOT=${flutterRoot ?? 'unset'}). Run tests through the '
      'flutter tool so FLUTTER_ROOT is set and the font cache exists.',
    );
  }

  final files = fontsDir.listSync().whereType<File>().toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  final roboto = FontLoader('Roboto');
  final icons = FontLoader('MaterialIcons');
  for (final file in files) {
    final name = file.uri.pathSegments.last;
    if (name.startsWith('Roboto-')) {
      roboto.addFont(_fontData(file));
    } else if (name == 'MaterialIcons-Regular.otf') {
      icons.addFont(_fontData(file));
    }
  }

  await roboto.load();
  await icons.load();
}

Future<ByteData> _fontData(File file) async =>
    ByteData.sublistView(await file.readAsBytes());

/// Installs a local golden comparator with synchronous artifact writes.
///
/// Flutter's default [LocalFileComparator] uses asynchronous file writes from
/// inside the test binding's `runAsync` zone. That future can hang indefinitely
/// on some macOS/Flutter combinations after the PNG has already been written.
/// These artifacts are small and infrequently updated, so a synchronous write
/// is both reliable and negligible compared with rendering the atlas.
///
/// Call this once from `flutter_test_config.dart` before [testMain].
void configureAtlasGoldenComparator() {
  final current = goldenFileComparator;
  if (current is! LocalFileComparator || current is _AtlasLocalFileComparator) {
    return;
  }

  goldenFileComparator = _AtlasLocalFileComparator(
    current.basedir.resolve('.mix_atlas_test.dart'),
    precisionTolerance: AtlasGoldens.precisionTolerance,
  );
}

final class _AtlasLocalFileComparator extends LocalFileComparator {
  final double _precisionTolerance;

  _AtlasLocalFileComparator(
    super.testFile, {
    required double precisionTolerance,
  }) : assert(
         precisionTolerance >= 0 && precisionTolerance <= 1,
         'precisionTolerance must be between 0 and 1.',
       ),
       _precisionTolerance = precisionTolerance;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    if (result.passed || result.diffPercent <= _precisionTolerance) {
      result.dispose();

      return true;
    }

    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) {
    final file = File.fromUri(basedir.resolve(golden.path));
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(imageBytes);

    return Future.value();
  }
}

/// Pumps [atlas] under [theme] and compares it against
/// `goldens/<theme.id>/<atlas.id>.png` (relative to the test file).
///
/// It also compares a `<atlas.id>.json` sidecar next to the image describing
/// the atlas's axes, so agents can interpret the grid without reading the test
/// source. With `--update-goldens`, both artifacts are refreshed.
///
/// The sidecar is compared on every platform. PNG comparison is skipped on
/// platforms outside [AtlasGoldens.platforms].
Future<void> expectAtlasGolden(
  WidgetTester tester, {
  required ComponentAtlas atlas,
  required AtlasTheme theme,
}) async {
  atlas.validate();
  _expectSidecar(atlas, theme);
  await _expectAtlasImage(tester, atlas: atlas, theme: theme);
}

Future<void> _expectAtlasImage(
  WidgetTester tester, {
  required ComponentAtlas atlas,
  required AtlasTheme theme,
}) async {
  if (!AtlasGoldens.platforms.contains(Platform.operatingSystem)) {
    markTestSkipped(
      'Atlas goldens are generated on ${AtlasGoldens.platforms}; '
      'rendering differs on ${Platform.operatingSystem}.',
    );

    return;
  }

  tester.platformDispatcher.platformBrightnessTestValue = theme.brightness;
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(4096, 4096);
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

  const atlasKey = ValueKey('mix_atlas.atlas');
  final isDark = theme.brightness == .dark;

  await tester.pumpWidget(
    MaterialApp(
      home: Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: .horizontal,
            child: Builder(
              builder: (context) => theme.builder(
                context,
                RepaintBoundary(
                  key: atlasKey,
                  child: ColoredBox(
                    color: theme.background,
                    // Transparent Material supplies a real DefaultTextStyle
                    // (Roboto in tests); without it component text falls back
                    // to the block test font with yellow underlines.
                    child: Material(
                      type: .transparency,
                      child: Padding(
                        padding: const .all(24),
                        child: AtlasView(
                          atlas: atlas,
                          title: '${atlas.id} - ${theme.id}',
                          labelColor: isDark
                              ? const Color(0x99FFFFFF)
                              : const Color(0x99000000),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      theme: ThemeData(brightness: theme.brightness),
      debugShowCheckedModeBanner: false,
    ),
  );

  // Fixed pump instead of pumpAndSettle: looping animations (spinners) never
  // settle, and a fixed offset keeps their captured frame deterministic.
  // The zero-duration pump also flushes deterministic post-frame overlay opens
  // after nested local Navigators have attached their anchors.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));

  final goldenPath = 'goldens/${theme.id}/${atlas.id}.png';
  await expectLater(find.byKey(atlasKey), matchesGoldenFile(goldenPath));
}

void _expectSidecar(ComponentAtlas atlas, AtlasTheme theme) {
  _expectJsonArtifact(
    'goldens/${theme.id}/${atlas.id}.json',
    () => componentAtlasMetadata(atlas, theme),
  );
}

/// Creates the structured v1 sidecar payload for an atlas.
Map<String, Object?> componentAtlasMetadata(
  ComponentAtlas atlas,
  AtlasTheme theme,
) {
  atlas.validate();

  return {
    'schema': 'mix_atlas/atlas/v1',
    'component': atlas.id,
    'componentLabel': ?atlas.label,
    'theme': theme.id,
    'themeLabel': ?theme.label,
    'brightness': theme.brightness.name,
    'file': '${atlas.id}.png',
    'rowAxes': [
      for (final axis in atlas.rowAxes) {'id': axis.id, 'label': axis.label},
    ],
    'rows': [
      for (final row in atlas.rows)
        {
          'id': row.id,
          'label': ?row.label,
          'values': {
            for (final axis in atlas.rowAxes)
              axis.id: {
                'id': row.values[axis.id]!.id,
                'label': row.values[axis.id]!.label,
              },
          },
        },
    ],
    'columns': [
      for (final scenario in atlas.scenarios)
        {
          'id': scenario.id,
          'label': ?scenario.label,
          'states': _sortedStateNames(scenario.states),
          'props': _normalizeScenarioProps(scenario),
        },
    ],
  };
}

/// Creates the deterministic v1 catalog index payload.
Map<String, Object?> atlasCatalogMetadata(AtlasCatalog catalog) {
  catalog.validate();

  return {
    'schema': 'mix_atlas/catalog/v1',
    'id': catalog.id,
    'label': ?catalog.label,
    'themes': [
      for (final theme in catalog.themes)
        {
          'id': theme.id,
          'label': ?theme.label,
          'brightness': theme.brightness.name,
        },
    ],
    'atlases': [
      for (final atlas in catalog.atlases)
        {
          'id': atlas.id,
          'label': ?atlas.label,
          'files': [
            for (final theme in catalog.themes)
              {
                'theme': theme.id,
                'image': '${theme.id}/${atlas.id}.png',
                'metadata': '${theme.id}/${atlas.id}.json',
              },
          ],
        },
    ],
  };
}

/// Registers platform-independent metadata regression coverage plus one PNG
/// golden test per catalog atlas/theme pair.
void registerAtlasCatalogGoldens(AtlasCatalog catalog) {
  catalog.validate();

  test('${catalog.id} atlas metadata', () {
    _expectCatalogIndex(catalog);
    for (final theme in catalog.themes) {
      for (final atlas in catalog.atlases) {
        _expectSidecar(atlas, theme);
      }
    }
  });

  for (final theme in catalog.themes) {
    for (final atlas in catalog.atlases) {
      testWidgets('${atlas.id} atlas - ${theme.id}', (tester) async {
        await _expectAtlasImage(tester, atlas: atlas, theme: theme);
      });
    }
  }
}

void _expectCatalogIndex(AtlasCatalog catalog) {
  _expectJsonArtifact(
    'goldens/catalog.json',
    () => atlasCatalogMetadata(catalog),
  );
}

List<String> _sortedStateNames(Set<WidgetState> states) {
  return [for (final state in states) state.name]..sort();
}

Map<String, Object?> _normalizeScenarioProps(AtlasScenario scenario) {
  final normalized = <String, Object?>{};
  final keys = scenario.props.keys.toList()..sort();
  for (final key in keys) {
    normalized[key] = _normalizeJsonValue(
      scenario.props[key],
      scenarioId: scenario.id,
      keyPath: key,
    );
  }

  return normalized;
}

Object? _normalizeJsonValue(
  Object? value, {
  required String scenarioId,
  required String keyPath,
}) {
  if (value == null || value is bool || value is String) return value;
  if (value is num) {
    if (value.isFinite) return value;
    throw _invalidScenarioProp(scenarioId, keyPath, value);
  }
  if (value is List) {
    return [
      for (var index = 0; index < value.length; index++)
        _normalizeJsonValue(
          value[index],
          scenarioId: scenarioId,
          keyPath: '$keyPath[$index]',
        ),
    ];
  }
  if (value is Map) {
    final entries = <MapEntry<String, Object?>>[];
    for (final entry in value.entries) {
      final key = entry.key;
      if (key is! String) {
        throw _invalidScenarioProp(scenarioId, keyPath, value);
      }
      entries.add(MapEntry(key, entry.value));
    }
    entries.sort((a, b) => a.key.compareTo(b.key));

    return {
      for (final entry in entries)
        entry.key: _normalizeJsonValue(
          entry.value,
          scenarioId: scenarioId,
          keyPath: '$keyPath.${entry.key}',
        ),
    };
  }

  throw _invalidScenarioProp(scenarioId, keyPath, value);
}

ArgumentError _invalidScenarioProp(
  String scenarioId,
  String keyPath,
  Object value,
) {
  return ArgumentError(
    'Scenario "$scenarioId" prop "$keyPath" is not JSON-safe '
    '(${value.runtimeType}).',
  );
}

void _expectJsonArtifact(String path, Map<String, Object?> Function() payload) {
  final canonical =
      '${const JsonEncoder.withIndent('  ').convert(payload())}\n';

  final comparator = goldenFileComparator;
  if (comparator is! LocalFileComparator) {
    throw StateError(
      'mix_atlas JSON artifacts require Flutter\'s LocalFileComparator.',
    );
  }

  final file = File.fromUri(comparator.basedir.resolve(path));
  if (autoUpdateGoldenFiles) {
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(canonical);

    return;
  }

  expect(
    file.existsSync(),
    isTrue,
    reason:
        'Missing atlas JSON artifact: ${file.path}. '
        'Run flutter test --update-goldens to create it.',
  );
  if (!file.existsSync()) return;
  expect(
    file.readAsStringSync(),
    canonical,
    reason:
        'Atlas JSON artifact is stale: ${file.path}. '
        'Run flutter test --update-goldens to refresh it.',
  );
}
