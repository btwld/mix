import 'dart:io';

import 'package:integration_test/integration_test_driver.dart';

Future<void> main() {
  final outputName =
      Platform.environment['BENCHMARK_OUTPUT_BASENAME'] ??
      'rendering_pipeline_perf';

  return integrationDriver(
    writeResponseOnFailure: true,
    responseDataCallback: (Map<String, dynamic>? data) {
      return writeResponseData(data, testOutputFilename: outputName);
    },
  );
}
