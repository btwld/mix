import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:mix_lint/src/rules/mix_avoid_token_ref_outside_mix.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../mix_stub.dart';

@reflectiveTest
class MixAvoidTokenRefOutsideMixTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = MixAvoidTokenRefOutsideMix();
    newPackage('mix').addFile('lib/mix.dart', mixStubLibContent);
    super.setUp();
  }

  // --- Reports ---------------------------------------------------------------

  void test_call_into_non_mix_constructor_reports() async {
    await assertDiagnostics(
      r'''
import 'package:mix/mix.dart';
void main() {
  final t = MyToken();
  Container(color: t());
}
''',
      [lint(87, 3)],
    );
  }

  void test_explicit_call_into_non_mix_constructor_reports() async {
    await assertDiagnostics(
      r'''
import 'package:mix/mix.dart';
void main() {
  final t = MyToken();
  Container(color: t.call());
}
''',
      [lint(87, 8)],
    );
  }

  void test_mix_method_into_non_mix_constructor_reports() async {
    await assertDiagnostics(
      r'''
import 'package:mix/mix.dart';
void main() {
  final t = MyToken();
  Container(color: t.mix());
}
''',
      [lint(87, 7)],
    );
  }

  void test_call_into_top_level_function_reports() async {
    await assertDiagnostics(
      r'''
import 'package:mix/mix.dart';
void main() {
  final t = MyToken();
  print(t());
}
''',
      [lint(76, 3)],
    );
  }

  void test_call_inside_collection_into_non_mix_reports() async {
    await assertDiagnostics(
      r'''
import 'package:mix/mix.dart';
void main() {
  final t = MyToken();
  print([t()]);
}
''',
      [lint(77, 3)],
    );
  }

  // --- No diagnostics --------------------------------------------------------

  void test_call_into_styler_method_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
void main() {
  final t = MyToken();
  BoxStyler().color(t());
}
''');
  }

  void test_explicit_call_into_styler_method_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
void main() {
  final t = MyToken();
  BoxStyler().color(t.call());
}
''');
  }

  void test_call_into_mix_static_utility_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
void main() {
  final t = MyToken();
  EdgeInsetsGeometryMix.value(t());
}
''');
  }

  void test_resolve_is_not_a_ref_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
void main() {
  final t = MyToken();
  Container(color: t.resolve(0));
}
''');
  }

  void test_call_assigned_to_variable_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
void main() {
  final t = MyToken();
  final x = t();
}
''');
  }

  void test_call_in_return_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
int build() {
  final t = MyToken();
  return t();
}
''');
  }

  void test_call_into_unresolved_receiver_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
void main() {
  final t = MyToken();
  dynamic d;
  d.foo(t());
}
''');
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MixAvoidTokenRefOutsideMixTest);
  });
}
