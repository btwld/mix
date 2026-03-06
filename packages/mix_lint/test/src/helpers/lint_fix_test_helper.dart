import 'package:analysis_server_plugin/edit/fix/dart_fix_context.dart';
import 'package:analysis_server_plugin/edit/fix/fix.dart';
import 'package:analysis_server_plugin/src/correction/dart_change_workspace.dart';
import 'package:analysis_server_plugin/src/correction/fix_processor.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/instrumentation/service.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';

/// Required shape of the analysis result for [applyQuickFixForResult].
///
/// The object must have: `path` (String), `content` (String),
/// `diagnostics` (Iterable of analyzer [Diagnostic]), and `session` (analysis
/// session with `getResolvedLibraryContaining(String path)`).
/// Compatible with [AnalysisRuleTest]'s `result` after [assertDiagnostics].

/// Applies the first quick fix that matches [selectFix] for the given
/// [diagnostic], and returns the file content after applying the fix.
///
/// Use this when you already have [ResolvedLibraryResult], [ResolvedUnitResult],
/// and the [diagnostic]. Suitable for any project using
/// `analysis_server_plugin` fix infrastructure.
///
/// [session] is the analysis session (e.g. `result.session`).
/// [filePath] and [fileContent] are the path and current content of the file
/// being fixed.
///
/// Returns the new file content. Throws if [selectFix] matches no fix or
/// the chosen fix has no edit for [filePath].
Future<String> applyQuickFix({
  required dynamic session,
  required ResolvedLibraryResult libraryResult,
  required ResolvedUnitResult unitResult,
  required String filePath,
  required String fileContent,
  required Diagnostic diagnostic,
  required bool Function(Fix fix) selectFix,
}) async {
  final workspace = DartChangeWorkspace([session]);
  final fixContext = DartFixContext(
    instrumentationService: InstrumentationService.NULL_SERVICE,
    workspace: workspace,
    libraryResult: libraryResult,
    unitResult: unitResult,
    error: diagnostic,
  );
  final fixes = await computeFixes(fixContext);

  final chosenList = fixes.where(selectFix).toList();
  if (chosenList.isEmpty) {
    throw StateError('No fix matched selectFix among ${fixes.length} fix(es)');
  }
  final chosen = chosenList.first;

  final fileEdit = chosen.change.getFileEdit(filePath);
  if (fileEdit == null) {
    throw StateError('Chosen fix has no file edit for path: $filePath');
  }

  return SourceEdit.applySequence(fileContent, fileEdit.edits);
}

/// Convenience helper that finds the diagnostic with [diagnosticCode] on
/// [result], resolves the library, then calls [applyQuickFix].
///
/// [result] must have `path`, `content`, `diagnostics`, and `session` (see
/// doc at top of file). Use [applyQuickFix] directly if your result type
/// differs.
///
/// Returns the new file content. Throws if no diagnostic with [diagnosticCode]
/// exists or [selectFix] matches no fix.
Future<String> applyQuickFixForResult(
  dynamic result,
  Object diagnosticCode, {
  required bool Function(Fix fix) selectFix,
}) async {
  final matching = result.diagnostics
      .where((d) => d.diagnosticCode == diagnosticCode)
      .toList();
  if (matching.isEmpty) {
    throw StateError(
      'No diagnostic with code "$diagnosticCode" in result (${result.diagnostics.length} diagnostics)',
    );
  }
  final diagnostic = matching.first;

  final libraryResult = await result.session.getResolvedLibraryContaining(
    result.path,
  );
  if (libraryResult is! ResolvedLibraryResult) {
    throw StateError('Expected ResolvedLibraryResult');
  }

  final unitResult =
      libraryResult.unitWithPath(result.path) as ResolvedUnitResult;

  return applyQuickFix(
    session: result.session,
    libraryResult: libraryResult,
    unitResult: unitResult,
    filePath: result.path,
    fileContent: result.content,
    diagnostic: diagnostic,
    selectFix: selectFix,
  );
}
