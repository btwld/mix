import 'dart:io';

import '../test/support/widget_generator_golden_support.dart';

Future<void> main() async {
  final goldenCases = loadMixWidgetGoldenCases();
  var updatedCount = 0;
  var unchangedCount = 0;

  for (final goldenCase in goldenCases) {
    try {
      final actualOutput = await generateMixWidgetGoldenOutput(goldenCase);
      final existingOutput = goldenCase.readExpectedOutputIfExists();

      if (existingOutput == actualOutput) {
        unchangedCount++;
        stdout.writeln('unchanged ${goldenCase.name}');
        continue;
      }

      goldenCase.writeExpectedOutput(actualOutput);
      updatedCount++;
      stdout.writeln('updated ${goldenCase.name}');
    } catch (error, stackTrace) {
      stderr.writeln('failed ${goldenCase.name}');
      stderr.writeln(error);
      stderr.writeln(stackTrace);
      exitCode = 1;

      return;
    }
  }

  stdout.writeln(
    'MixWidget goldens complete: $updatedCount updated, $unchangedCount unchanged.',
  );
}
