import 'dart:io';

import 'package:yaml/yaml.dart';

import 'release.dart' show publishablePackages;
import 'release_test.dart' as release_test;

void main() {
  final workflow = loadYaml(
    File('.github/workflows/publish.yml').readAsStringSync(),
  );
  const prefix = 'publish_';
  final jobs = workflow['jobs'] as YamlMap;
  final publishJobs = jobs.keys
      .whereType<String>()
      .where((name) => name.startsWith(prefix))
      .map((name) => name.substring(prefix.length))
      .toSet();
  final allowed = publishablePackages.toSet();
  final missing = allowed.difference(publishJobs);
  final extra = publishJobs.difference(allowed);
  if (missing.isNotEmpty || extra.isNotEmpty) {
    stderr.writeln(
      'publish_<pkg> jobs must match publishablePackages. '
      'Missing: $missing. Unexpected: $extra.',
    );
    exitCode = 1;
    return;
  }
  if (workflow case {
    'on': {'workflow_dispatch': null},
    'jobs': {
      'publish_mix_markdown': {
        'uses': 'btwld/dart-actions/.github/workflows/publish.yml@main',
        'permissions': {'id-token': 'write'},
        'if':
            "github.ref_type == 'tag' && startsWith(github.ref_name, 'mix_markdown-v') && github.ref_name != 'mix_markdown-v0.1.0-beta.1'",
      },
    },
  }) {
    release_test.main();
    return;
  }

  stderr.writeln(
    'publish_mix_markdown must support tag-only dispatch, use btwld/dart-actions with OIDC, and skip the first manual-release tag.',
  );
  exitCode = 1;
}
