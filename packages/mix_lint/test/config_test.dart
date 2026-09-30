import 'dart:convert';

import 'package:analyzer_testing/resource_provider_mixin.dart';
import 'package:mix_lint/src/config.dart';
import 'package:test/test.dart';

const _maxCalls20 = '''
mix_lint:
  long_styler_chain:
    max_calls: 20
''';

void main() {
  late _FileSystem fs;

  setUp(() => fs = _FileSystem()..newFile('/app/lib/a.dart', ''));

  Map<String, Object?>? optionsFor([String path = '/app/lib/a.dart']) =>
      RuleOptions.forRule(fs.getFile(path), 'long_styler_chain');

  /// Writes a package config at [root] whose [packages] map names to root
  /// URIs, relative to the config file or absolute.
  void writePackageConfig(String root, Map<String, String> packages) {
    fs.newFile(
      '$root/.dart_tool/package_config.json',
      jsonEncode({
        'configVersion': 2,
        'packages': [
          for (final MapEntry(key: name, value: rootUri) in packages.entries)
            {'name': name, 'rootUri': rootUri, 'packageUri': 'lib/'},
        ],
      }),
    );
  }

  String fileUri(String path) =>
      fs.pathContext.toUri(fs.convertPath(path)).toString();

  group('lookup', () {
    test('reads the rule section from the nearest options file', () {
      fs.newFile('/app/analysis_options.yaml', _maxCalls20);

      expect(optionsFor(), {'max_calls': 20});
      expect(
        RuleOptions.forRule(fs.getFile('/app/lib/a.dart'), 'other_rule'),
        isNull,
      );
    });

    test('returns null without a mix_lint section or options file', () {
      expect(optionsFor(), isNull);

      fs.newFile('/app/analysis_options.yaml', 'linter:\n  rules: []\n');
      expect(optionsFor(), isNull);
    });

    test('uses the options file closest to the Dart file', () {
      fs.newFile('/analysis_options.yaml', _maxCalls20);
      fs.newFile('/app/analysis_options.yaml', '''
mix_lint:
  long_styler_chain:
    max_calls: 5
''');

      expect(optionsFor(), {'max_calls': 5});
    });
  });

  group('includes', () {
    test('an empty key keeps the included values', () {
      fs.newFile('/app/shared.yaml', _maxCalls20);
      fs.newFile('/app/analysis_options.yaml', '''
include: shared.yaml
mix_lint:
  long_styler_chain:
    # max_calls: 4
''');

      expect(optionsFor(), {'max_calls': 20});
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

      expect(optionsFor(), {'max_calls': 9});
    });

    test('follows file: URIs', () {
      fs.newFile('/shared/options.yaml', _maxCalls20);
      fs.newFile(
        '/app/analysis_options.yaml',
        'include: ${fileUri('/shared/options.yaml')}\n',
      );

      expect(optionsFor(), {'max_calls': 20});
    });

    test('resolves package: URIs with a relative rootUri', () {
      fs.newFile('/shared/lib/options.yaml', _maxCalls20);
      writePackageConfig('/app', {'shared': '../../shared/'});
      fs.newFile(
        '/app/analysis_options.yaml',
        'include: package:shared/options.yaml\n',
      );

      expect(optionsFor(), {'max_calls': 20});
    });

    test('resolves nested package: URIs with the root package config', () {
      // A hosted package has no .dart_tool, so its own includes must use
      // the package config of the project being analyzed.
      fs.newFile('/cache/presets/lib/options.yaml', '''
include: package:presets/v2.yaml
''');
      fs.newFile('/cache/presets/lib/v2.yaml', _maxCalls20);
      writePackageConfig('/app', {'presets': fileUri('/cache/presets/')});
      fs.newFile(
        '/app/analysis_options.yaml',
        'include: package:presets/options.yaml\n',
      );

      expect(optionsFor(), {'max_calls': 20});
    });

    test('skips invalid includes', () {
      writePackageConfig('/app', {
        'broken': 'file://[bad/',
        'shared': '../../shared/',
      });
      fs.newFile('/app/analysis_options.yaml', '''
include:
  - 'package:'
  - package:shared/
  - package:missing/options.yaml
  - package:broken/options.yaml
  - missing.yaml
mix_lint:
  long_styler_chain:
    max_calls: 7
''');

      expect(optionsFor(), {'max_calls': 7});
    });

    test('stops at an include cycle', () {
      fs.newFile('/app/analysis_options.yaml', '''
include: other.yaml
mix_lint:
  long_styler_chain:
    max_calls: 7
''');
      fs.newFile('/app/other.yaml', 'include: analysis_options.yaml\n');

      expect(optionsFor(), {'max_calls': 7});
    });
  });

  group('cache', () {
    test('returns the cached options while no file changes', () {
      fs.newFile('/app/analysis_options.yaml', _maxCalls20);

      expect(identical(optionsFor(), optionsFor()), isTrue);
    });

    test('rereads the options after the file or an include changes', () {
      fs.newFile('/app/shared.yaml', _maxCalls20);
      final options = fs.newFile(
        '/app/analysis_options.yaml',
        'include: shared.yaml\n',
      );
      expect(optionsFor(), {'max_calls': 20});

      fs.newFile('/app/shared.yaml', '''
mix_lint:
  long_styler_chain:
    max_calls: 30
''');
      expect(optionsFor(), {'max_calls': 30});

      fs.modifyFile2(options, '''
include: shared.yaml
mix_lint:
  long_styler_chain:
    max_calls: 4
''');
      expect(optionsFor(), {'max_calls': 4});
    });

    test('notices an include that is created later', () {
      fs.newFile('/app/analysis_options.yaml', 'include: shared.yaml\n');
      expect(optionsFor(), isNull);

      fs.newFile('/app/shared.yaml', _maxCalls20);
      expect(optionsFor(), {'max_calls': 20});
    });

    test('notices a package config that is created later', () {
      fs.newFile('/shared/lib/options.yaml', _maxCalls20);
      fs.newFile(
        '/app/analysis_options.yaml',
        'include: package:shared/options.yaml\n',
      );
      expect(optionsFor(), isNull);

      writePackageConfig('/app', {'shared': '../../shared/'});
      expect(optionsFor(), {'max_calls': 20});
    });
  });
}

final class _FileSystem with ResourceProviderMixin {}
