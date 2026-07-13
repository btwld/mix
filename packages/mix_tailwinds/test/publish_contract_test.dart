import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('package manifest remains publishable', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();

    expect(
      pubspec,
      isNot(contains('publish_to: none')),
      reason: 'mix_tailwinds is released by the repository publish workflow.',
    );
    expect(
      RegExp(r'^  mix: \^2\.1\.0$', multiLine: true).hasMatch(pubspec),
      isTrue,
      reason: 'Published packages must use the hosted Mix dependency.',
    );
  });
}
