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

    test('emits Prop<T>? fields matching spec constructor parameters', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';

        part 'spike.spec_styler.g.part';

        class EdgeInsetsGeometry {}

        @MixableSpec()
        final class TrivialSpec {
          final EdgeInsetsGeometry? padding;
          final int? count;
          const TrivialSpec({this.padding, this.count});
        }
      ''';

      await testBuilder(
        PartBuilder([const SpecStylerGenerator()], '.spec_styler.g.part'),
        {...mixAnnotationsSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.spec_styler.g.part': decodedMatches(
            allOf(
              contains(r'Prop<EdgeInsetsGeometry>? $padding'),
              contains(r'Prop<int>? $count'),
            ),
          ),
        },
      );
    });

    test('emits .create() const constructor and default constructor', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';

        part 'spike.spec_styler.g.part';

        class EdgeInsetsGeometry {}

        @MixableSpec()
        final class TrivialSpec {
          final EdgeInsetsGeometry? padding;
          const TrivialSpec({this.padding});
        }
      ''';

      await testBuilder(
        PartBuilder([const SpecStylerGenerator()], '.spec_styler.g.part'),
        {...mixAnnotationsSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.spec_styler.g.part': decodedMatches(
            allOf(
              contains('const TrivialStyler.create('),
              contains('Prop<EdgeInsetsGeometry>? padding'),
              contains('TrivialStyler({'),
              contains('EdgeInsetsGeometryMix? padding'),
              contains('Prop.maybeMix(padding)'),
            ),
          ),
        },
      );
    });

    test('emits dedup with-clause from ownerMixins of all field types', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';

        part 'spike.spec_styler.g.part';

        class EdgeInsetsGeometry {}
        class BoxConstraints {}
        class Decoration {}
        enum Clip { hardEdge }

        @MixableSpec()
        final class BoxLikeSpec {
          final EdgeInsetsGeometry? padding;
          final EdgeInsetsGeometry? margin;
          final BoxConstraints? constraints;
          final Decoration? decoration;
          final Clip? clipBehavior;
          const BoxLikeSpec({
            this.padding,
            this.margin,
            this.constraints,
            this.decoration,
            this.clipBehavior,
          });
        }
      ''';

      await testBuilder(
        PartBuilder([const SpecStylerGenerator()], '.spec_styler.g.part'),
        {...mixAnnotationsSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.spec_styler.g.part': decodedMatches(
            allOf(
              contains('SpacingStyleMixin<BoxLikeStyler>'),
              contains('ConstraintStyleMixin<BoxLikeStyler>'),
              contains('DecorationStyleMixin<BoxLikeStyler>'),
              contains('BorderStyleMixin<BoxLikeStyler>'),
              contains('BorderRadiusStyleMixin<BoxLikeStyler>'),
              contains('ShadowStyleMixin<BoxLikeStyler>'),
            ),
          ),
        },
      );
    });

    test('emits setter for fields without owner mixin; skips fields owned by mixin', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';

        part 'spike.spec_styler.g.part';

        class EdgeInsetsGeometry {}
        enum Clip { hardEdge }

        @MixableSpec()
        final class BoxLikeSpec {
          final EdgeInsetsGeometry? padding;
          final Clip? clipBehavior;
          const BoxLikeSpec({this.padding, this.clipBehavior});
        }
      ''';

      await testBuilder(
        PartBuilder([const SpecStylerGenerator()], '.spec_styler.g.part'),
        {...mixAnnotationsSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.spec_styler.g.part': decodedMatches(
            allOf(
              contains('BoxLikeStyler clipBehavior(Clip value)'),
              isNot(contains('BoxLikeStyler padding(')),
            ),
          ),
        },
      );
    });
  });
}
