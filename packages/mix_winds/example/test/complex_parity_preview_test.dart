import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds/mix_winds.dart';
import 'package:mix_winds_example/complex_parity_preview.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('HTML and Flutter complex fixtures use identical utility strings', () {
    final exampleRoot = Directory.current.path.endsWith('/example')
        ? Directory.current
        : Directory('${Directory.current.path}/example');
    final dartSource = File(
      '${exampleRoot.path}/lib/complex_parity_preview.dart',
    ).readAsStringSync();
    final htmlSource = File(
      '${exampleRoot.path}/real_tailwind/complex-parity.html',
    ).readAsStringSync();

    final dartClassMatches = [
      ...RegExp(
        r"\b(?:div|p)\(\s*((?:'[^']*'\s*)+)",
        multiLine: true,
      ).allMatches(dartSource),
      ...RegExp(
        r"classNames:\s*((?:'[^']*'\s*)+)",
        multiLine: true,
      ).allMatches(dartSource),
    ];
    final dartClasses = dartClassMatches.map((match) {
      final literals = RegExp(
        r"'([^']*)'",
      ).allMatches(match.group(1)!).map((literal) => literal.group(1)!).join();
      return _normalizeClasses(literals);
    }).toList()..sort();

    final htmlClasses =
        RegExp(
            r'<[^>]*data-parity-class[^>]*class="([^"]+)"[^>]*>',
            multiLine: true,
          ).allMatches(htmlSource).map((match) {
            return _normalizeClasses(match.group(1)!);
          }).toList()
          ..sort();

    expect(dartClasses, hasLength(17));
    expect(htmlClasses, dartClasses);
  });

  testWidgets('all complex cases render at every comparison width', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    for (final width in [480.0, 768.0, 1024.0]) {
      tester.view.physicalSize = Size(width, 400);

      for (var caseNumber = 1; caseNumber <= 10; caseNumber++) {
        final caseId = caseNumber.toString().padLeft(2, '0');
        await tester.pumpWidget(
          WidgetsApp(
            color: const Color(0xFFF3F4F6),
            pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
              settings: settings,
              pageBuilder: (context, animation, secondaryAnimation) {
                return builder(context);
              },
            ),
            home: TwScope(
              config: TwConfig.standard(),
              child: ComplexParityPreview(caseId: caseId, width: width),
            ),
          ),
        );
        await tester.pump();

        expect(
          tester.takeException(),
          isNull,
          reason: 'case $caseId failed to render at ${width.toInt()}px',
        );
      }
    }
  });
}

String _normalizeClasses(String value) {
  return value.trim().split(RegExp(r'\s+')).join(' ');
}
