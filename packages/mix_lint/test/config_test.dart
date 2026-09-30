import 'package:analyzer_testing/resource_provider_mixin.dart';
import 'package:mix_lint/src/config.dart';
import 'package:test/test.dart';

void main() {
  late _FileSystem fs;

  setUp(() => fs = _FileSystem());

  Map<String, Object?>? optionsFor(String path) =>
      RuleOptions.forRule(fs.getFile(path), 'long_styler_chain');

  test('reads the rule section from the nearest options file', () {
    fs.newFile('/app/analysis_options.yaml', '''
mix_lint:
  long_styler_chain:
    max_calls: 20
''');
    fs.newFile('/app/lib/src/a.dart', '');

    expect(optionsFor('/app/lib/src/a.dart'), {'max_calls': 20});
    expect(
      RuleOptions.forRule(fs.getFile('/app/lib/src/a.dart'), 'other_rule'),
      isNull,
    );
  });

  test('returns null without a mix_lint section or options file', () {
    fs.newFile('/app/lib/a.dart', '');
    expect(optionsFor('/app/lib/a.dart'), isNull);

    fs.newFile('/app/analysis_options.yaml', 'linter:\n  rules: []\n');
    expect(optionsFor('/app/lib/a.dart'), isNull);
  });

  test('uses the options file closest to the Dart file', () {
    fs.newFile('/ws/analysis_options.yaml', '''
mix_lint:
  long_styler_chain:
    max_calls: 20
''');
    fs.newFile('/ws/pkg/analysis_options.yaml', '''
mix_lint:
  long_styler_chain:
    max_calls: 5
''');
    fs.newFile('/ws/pkg/lib/a.dart', '');

    expect(optionsFor('/ws/pkg/lib/a.dart'), {'max_calls': 5});
  });

  test('rereads the options after the file or an include changes', () {
    fs.newFile('/app/shared.yaml', '''
mix_lint:
  long_styler_chain:
    max_calls: 20
''');
    final options = fs.newFile(
      '/app/analysis_options.yaml',
      'include: shared.yaml\n',
    );
    fs.newFile('/app/lib/a.dart', '');
    expect(optionsFor('/app/lib/a.dart'), {'max_calls': 20});

    fs.newFile('/app/shared.yaml', '''
mix_lint:
  long_styler_chain:
    max_calls: 30
''');
    expect(optionsFor('/app/lib/a.dart'), {'max_calls': 30});

    fs.modifyFile2(options, '''
include: shared.yaml
mix_lint:
  long_styler_chain:
    max_calls: 4
''');
    expect(optionsFor('/app/lib/a.dart'), {'max_calls': 4});
  });

  test('reads an include that is created after the first read', () {
    fs.newFile('/app/analysis_options.yaml', 'include: shared.yaml\n');
    fs.newFile('/app/lib/a.dart', '');
    expect(optionsFor('/app/lib/a.dart'), isNull);

    fs.newFile('/app/shared.yaml', '''
mix_lint:
  long_styler_chain:
    max_calls: 20
''');
    expect(optionsFor('/app/lib/a.dart'), {'max_calls': 20});
  });

  test('applies a file again each time it is included', () {
    // As in the analyzer, a later include wins, even over values that an
    // earlier include set on top of the same file.
    fs.newFile('/app/base.yaml', '''
mix_lint:
  long_styler_chain:
    max_calls: 9
''');
    fs.newFile('/app/a.yaml', '''
include: base.yaml
mix_lint:
  long_styler_chain:
    max_calls: 1
''');
    fs.newFile('/app/b.yaml', 'include: base.yaml\n');
    fs.newFile('/app/analysis_options.yaml', '''
include:
  - a.yaml
  - b.yaml
''');
    fs.newFile('/app/lib/a.dart', '');

    expect(optionsFor('/app/lib/a.dart'), {'max_calls': 9});
  });

  test('skips invalid includes', () {
    fs.newFile('/app/analysis_options.yaml', '''
include:
  - 'package:'
  - package:missing/options.yaml
  - missing.yaml
mix_lint:
  long_styler_chain:
    max_calls: 7
''');
    fs.newFile('/app/lib/a.dart', '');

    expect(optionsFor('/app/lib/a.dart'), {'max_calls': 7});
  });

  test('stops at an include cycle', () {
    fs.newFile('/app/analysis_options.yaml', '''
include: other.yaml
mix_lint:
  long_styler_chain:
    max_calls: 7
''');
    fs.newFile('/app/other.yaml', 'include: analysis_options.yaml\n');
    fs.newFile('/app/lib/a.dart', '');

    expect(optionsFor('/app/lib/a.dart'), {'max_calls': 7});
  });
}

final class _FileSystem with ResourceProviderMixin {}
