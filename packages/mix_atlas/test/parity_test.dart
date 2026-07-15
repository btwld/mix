import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas/golden.dart';

void main() {
  testWidgets('parity harness compares the deterministic 200 ms phase', (
    tester,
  ) async {
    const contactSheet = SizedBox(
      width: 120,
      height: 80,
      child: ColoredBox(
        color: Color(0xFF3366FF),
        child: Center(child: Text('Atlas')),
      ),
    );

    await expectAtlasWidgetParity(
      tester,
      producer: contactSheet,
      portable: contactSheet,
    );
  });

  testWidgets('parity harness compares unequal image bytes without hanging', (
    tester,
  ) async {
    await expectAtlasWidgetParity(
      tester,
      producer: const SizedBox(
        width: 120,
        height: 80,
        child: ColoredBox(color: Color(0xFF3366FF)),
      ),
      portable: const SizedBox(
        width: 120,
        height: 80,
        child: ColoredBox(color: Color(0xFFFF6633)),
      ),
      precisionTolerance: 1,
    );
  });

  testWidgets('parity harness can write producer and portable failures', (
    tester,
  ) async {
    final directory = Directory.systemTemp.createTempSync('mix-atlas-parity-');
    addTearDown(() => directory.deleteSync(recursive: true));

    await expectLater(
      () => expectAtlasWidgetParity(
        tester,
        producer: const SizedBox(
          width: 120,
          height: 80,
          child: ColoredBox(color: Color(0xFF3366FF)),
        ),
        portable: const SizedBox(
          width: 120,
          height: 80,
          child: ColoredBox(color: Color(0xFFFF6633)),
        ),
        precisionTolerance: 0,
        failureDirectory: directory,
        failureName: 'colors',
      ),
      throwsA(isA<TestFailure>()),
    );
    expect(File('${directory.path}/colors.producer.png').existsSync(), isTrue);
    expect(File('${directory.path}/colors.portable.png').existsSync(), isTrue);
  });
}
