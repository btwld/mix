import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:test/test.dart';

import 'stubs.dart';

/// Base class for `mix_lint` rule tests.
///
/// Adds the `flutter`, `mix`, and `mix_annotations` stub packages, and
/// [assertLints], which reads expected ranges from `[!` and `!]` markers.
abstract class MixRuleTest extends AnalysisRuleTest {
  /// Creates the rule under test.
  AbstractAnalysisRule createRule();

  @override
  void setUp() {
    rule = createRule();
    newPackage('flutter').addFile('lib/widgets.dart', flutterStub);
    newPackage('mix').addFile('lib/mix.dart', mixStub);
    newPackage(
      'mix_annotations',
    ).addFile('lib/mix_annotations.dart', mixAnnotationsStub);
    super.setUp();
  }

  /// Asserts that the rule reports exactly the ranges marked with `[!` and
  /// `!]` in [markedCode], and nothing else.
  ///
  /// Every diagnostic message must contain each of [messageContains].
  Future<void> assertLints(
    String markedCode, {
    List<Pattern> messageContains = const [],
  }) {
    final (code, ranges) = parseRangeMarkers(markedCode);

    return assertDiagnostics(code, [
      for (final (offset, length) in ranges)
        lint(offset, length, messageContainsAll: messageContains),
    ]);
  }

  /// Asserts that [fixedCode], the output of a quick fix, has no errors and
  /// no diagnostics from the rule under test.
  ///
  /// Other warnings are allowed, such as an import that the fix left unused.
  /// The test file is cached after its first analysis, so this analyzes a
  /// new file.
  Future<void> assertFixedCodeIsClean(String fixedCode) async {
    final path = '$testPackageLibPath/fixed.dart';
    newFile(path, fixedCode);
    final fixed = await resolveFile(path);

    expect(
      fixed.diagnostics.where(
        (d) =>
            d.severity == Severity.error ||
            rule.diagnosticCodes.contains(d.diagnosticCode),
      ),
      isEmpty,
    );
  }
}

/// Removes `[!` and `!]` markers from [markedCode] and returns the plain code
/// with the `(offset, length)` of each marked range.
///
/// Ranges cannot nest.
(String, List<(int, int)>) parseRangeMarkers(String markedCode) {
  final code = StringBuffer();
  final ranges = <(int, int)>[];
  int? start;

  var i = 0;
  while (i < markedCode.length) {
    if (markedCode.startsWith('[!', i)) {
      if (start != null) throw ArgumentError('Nested [! markers at $i.');
      start = code.length;
      i += 2;
    } else if (markedCode.startsWith('!]', i)) {
      if (start == null) throw ArgumentError('Unmatched !] marker at $i.');
      ranges.add((start, code.length - start));
      start = null;
      i += 2;
    } else {
      code.write(markedCode[i]);
      i++;
    }
  }
  if (start != null) throw ArgumentError('Unclosed [! marker.');

  return (code.toString(), ranges);
}
