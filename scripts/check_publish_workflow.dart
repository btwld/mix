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
  final triggers = workflow['on'] as YamlMap;
  final push = triggers['push'];
  if (triggers.length != 1 ||
      push is! YamlMap ||
      push.length != 1 ||
      push['tags'] is! YamlList) {
    stderr.writeln(
      'The publish workflow must only run on pushes of release tags.',
    );
    exitCode = 1;
    return;
  }
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
  for (final package in publishJobs) {
    final needs = jobs['$prefix$package']['needs'];
    if (needs != 'validate' &&
        (needs is! YamlList || !needs.contains('validate'))) {
      stderr.writeln('$prefix$package must need the validate job.');
      exitCode = 1;
      return;
    }
  }
  if (workflow case {
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
    'publish_mix_markdown must use btwld/dart-actions with OIDC and skip the first manual-release tag.',
  );
  exitCode = 1;
}
