import 'package:test/test.dart';

import '../support/widget_generator_golden_support.dart';

void main() {
  group('MixWidgetGenerator goldens', () {
    final goldenCases = loadMixWidgetGoldenCases();

    test('discovers MixWidget golden cases', () {
      expect(goldenCases, isNotEmpty);
    });

    for (final goldenCase in goldenCases) {
      test(goldenCase.name, () async {
        final actualOutput = await generateMixWidgetGoldenOutput(goldenCase);
        final expectedOutput = goldenCase.readExpectedOutput();

        expect(
          actualOutput,
          expectedOutput,
          reason:
              'Golden mismatch for `${goldenCase.expectedDisplayPath}`. '
              'Run `$mixWidgetGoldenUpdateCommand` if the change is intentional.',
        );
      });
    }
  });
}
