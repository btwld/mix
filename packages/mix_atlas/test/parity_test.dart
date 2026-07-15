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
}
