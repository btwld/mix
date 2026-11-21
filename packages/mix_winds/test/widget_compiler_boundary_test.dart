import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('widget and layout code consume compiled plans without parsing', () {
    final source = File('lib/src/tw_widget.dart').readAsStringSync();
    const forbidden = {
      "import 'parser/candidate_parser.dart'",
      "import 'parser/model.dart'",
      "import 'translate/tw_routing.dart'",
      "import 'translate/tw_target.dart'",
      'splitTailwindTokens(',
      'parseCandidate(',
      'routeCandidate(',
      '.listTokens(',
      '.setTokens(',
      '.wantsFlex(',
      '.parseAnimationFromTokens(',
      'TwParser(',
    };

    for (final pattern in forbidden) {
      expect(source, isNot(contains(pattern)), reason: pattern);
    }

    expect(source, contains('.compileForWidget('));
    expect(source, contains('TwCompiledLayoutPlan'));
  });

  test('layout plan builder consumes typed compiler semantics', () {
    final source = File('lib/src/tw_layout_plan.dart').readAsStringSync();

    expect(source, isNot(contains('rawUtility')));
    expect(source, isNot(contains("import 'tw_config.dart'")));
    expect(source, isNot(contains("import 'tw_utils.dart'")));
    expect(source, contains('TwLayoutDimensionDeclaration'));
    expect(source, contains('TwLayoutInsetDeclaration'));
  });
}
