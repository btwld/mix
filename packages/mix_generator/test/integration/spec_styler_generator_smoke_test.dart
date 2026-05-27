import 'package:build_test/build_test.dart';
import 'package:logging/logging.dart';
import 'package:mix_generator/mix_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

import '../core/test_helpers.dart';

void main() {
  group('SpecStylerGenerator smoke', () {
    test('emits a class shell for a trivial spec', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';

        part 'spike.spec_styler.g.part';

        @MixableSpec()
        final class TrivialSpec {
          final int? count;
          const TrivialSpec({this.count});
        }
      ''';

      await testBuilder(
        PartBuilder([const SpecStylerGenerator()], '.spec_styler.g.part'),
        {
          ...mixAnnotationsSources,
          'mix|lib/spike.dart': input,
        },
        outputs: {
          'mix|lib/spike.spec_styler.g.part': decodedMatches(
            contains(
              'class TrivialStyler extends MixStyler<TrivialStyler, TrivialSpec>',
            ),
          ),
        },
      );
    });

    test('rejects @MixableSpec applied to a non-class element', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';

        part 'spike.spec_styler.g.part';

        @MixableSpec()
        void notAClass() {}
      ''';

      final logs = <LogRecord>[];
      await testBuilder(
        PartBuilder([const SpecStylerGenerator()], '.spec_styler.g.part'),
        {...mixAnnotationsSources, 'mix|lib/spike.dart': input},
        onLog: logs.add,
      );

      expect(
        logs
            .where((r) => r.level == Level.SEVERE)
            .map((r) => r.message)
            .join('\n'),
        contains('@MixableSpec'),
      );
    });
  });
}
