import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('package manifest remains independently publishable as a beta', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final changelog = File('CHANGELOG.md').readAsStringSync();

    expect(pubspec, contains(RegExp(r'^name: mix_chart$', multiLine: true)));
    expect(
      pubspec,
      contains(RegExp(r'^version: 0\.0\.1-beta\.0$', multiLine: true)),
    );
    expect(changelog, startsWith('## 0.0.1-beta.0\n'));
    expect(
      pubspec,
      isNot(contains('publish_to: none')),
      reason: 'mix_chart is released by the repository publish workflow.',
    );
    expect(
      RegExp(r'^  mix: \^2\.2\.0-beta\.0$', multiLine: true).hasMatch(pubspec),
      isTrue,
      reason: 'Published packages must use the hosted Mix dependency.',
    );
    expect(
      RegExp(
        r'^  mix_annotations: \^2\.2\.0-beta\.0$',
        multiLine: true,
      ).hasMatch(pubspec),
      isTrue,
      reason: 'Published packages must use hosted annotations.',
    );
    expect(
      RegExp(r'^  fl_chart: \^1\.2\.0$', multiLine: true).hasMatch(pubspec),
      isTrue,
    );
    expect(
      RegExp(r'^screenshots:$', multiLine: true).hasMatch(pubspec),
      isTrue,
    );
    final screenshotPaths = RegExp(
      r'^    path: (example/screenshots/\S+)$',
      multiLine: true,
    ).allMatches(pubspec).map((match) => match.group(1)!);
    expect(screenshotPaths, hasLength(7));
    expect(
      screenshotPaths,
      everyElement(
        predicate<String>(
          (path) => File(path).existsSync(),
          'references an existing screenshot',
        ),
      ),
    );
  });
}
