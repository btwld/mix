import 'dart:io';

import 'package:yaml/yaml.dart';

void main() {
  final workflow = loadYaml(
    File('.github/workflows/publish.yml').readAsStringSync(),
  );
  if (workflow case {
    'jobs': {
      'publish_mix_markdown': {
        'uses': 'btwld/dart-actions/.github/workflows/publish.yml@main',
        'permissions': {'id-token': 'write'},
        'if':
            "startsWith(github.ref_name, 'mix_markdown-v') && github.ref_name != 'mix_markdown-v0.1.0-beta.1'",
      },
    },
  }) {
    return;
  }

  stderr.writeln(
    'publish_mix_markdown must use btwld/dart-actions with OIDC and skip the first manual-release tag.',
  );
  exitCode = 1;
}
