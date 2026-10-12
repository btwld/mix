import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Maximum golden pixel-diff fraction accepted as rasterization noise.
///
/// Goldens are byte-identical on the platform that generated them, but text
/// anti-aliasing differs slightly across host platforms even with the bundled
/// TwParityRoboto font and the deterministic test embedder. Measured bands
/// (2026-08, macOS-generated goldens compared on Linux CI):
///   - cross-platform noise: 0.75%–1.80%
///   - smallest genuine regression observed in this suite: 6.97%
/// 3% sits above the noise ceiling and well below the signal floor. Focused
/// metric tests guard structural layout, while the browser comparison tool
/// separately compares Flutter captures with real Tailwind renders.
const double _kGoldenDiffTolerance = 0.03;

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final previous = goldenFileComparator;
  if (previous is LocalFileComparator) {
    goldenFileComparator = _TolerantGoldenFileComparator(
      Uri.parse('${previous.basedir}test.dart'),
    );
  }
  await testMain();
}

final class _TolerantGoldenFileComparator extends LocalFileComparator {
  _TolerantGoldenFileComparator(super.testFile);

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (result.passed) return true;

    if (result.diffPercent <= _kGoldenDiffTolerance) {
      debugPrint(
        'Golden "$golden" differs by '
        '${(result.diffPercent * 100).toStringAsFixed(2)}% — accepted as '
        'cross-platform rasterization noise '
        '(tolerance ${(_kGoldenDiffTolerance * 100).toStringAsFixed(0)}%).',
      );
      return true;
    }

    final error = await generateFailureOutput(result, golden, basedir);
    throw FlutterError(error);
  }
}
