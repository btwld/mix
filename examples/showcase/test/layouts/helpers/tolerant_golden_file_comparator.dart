import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

const defaultGoldenDiffTolerance = 0.03;

void useTolerantGoldenFileComparator(
  String testFileName, {
  double precisionTolerance = defaultGoldenDiffTolerance,
}) {
  final previousComparator = goldenFileComparator;
  final basedir = (previousComparator as LocalFileComparator).basedir;
  goldenFileComparator = TolerantGoldenFileComparator(
    Uri.parse('$basedir$testFileName'),
    precisionTolerance: precisionTolerance,
  );
  addTearDown(() => goldenFileComparator = previousComparator);
}

/// Allows small rasterization differences between macOS and Linux renderers.
class TolerantGoldenFileComparator extends LocalFileComparator {
  TolerantGoldenFileComparator(
    super.testFile, {
    required this.precisionTolerance,
  }) : assert(
         precisionTolerance >= 0 && precisionTolerance <= 1,
         'precisionTolerance must be between 0 and 1',
       );

  final double precisionTolerance;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (result.passed || result.diffPercent <= precisionTolerance) {
      result.dispose();
      return true;
    }

    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}
