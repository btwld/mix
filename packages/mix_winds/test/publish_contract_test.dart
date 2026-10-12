import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('package manifest remains publishable', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();

    expect(
      pubspec,
      isNot(contains('publish_to: none')),
      reason: 'mix_winds is released by the repository publish workflow.',
    );
    expect(
      RegExp(
        r'^  mix: \^2\.\d+\.\d+(-[0-9A-Za-z.]+)?$',
        multiLine: true,
      ).hasMatch(pubspec),
      isTrue,
      reason:
          'Published packages must use a hosted caret Mix constraint. Keep '
          'its minimum at the first Mix version that has every API this '
          'library uses; verify by resolving lib/ against pub.dev without '
          'pubspec_overrides.yaml.',
    );
  });
}
