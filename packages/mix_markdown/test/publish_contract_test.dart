import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  final workflow = File('../../.github/workflows/publish.yml');

  test(
    'later Markdown tags publish through the canonical OIDC workflow',
    () {
      final config = loadYaml(workflow.readAsStringSync()) as YamlMap;
      final job = config['jobs']['publish_mix_markdown'] as YamlMap;

      expect(
        job['uses'],
        'btwld/dart-actions/.github/workflows/publish.yml@main',
      );
      expect(job['permissions']['id-token'], 'write');
      expect(
        job['if'],
        contains("github.ref_name != 'mix_markdown-v0.1.0-beta.1'"),
      );
    },
    skip: workflow.existsSync()
        ? false
        : 'Requires the Mix repository checkout',
  );
}
