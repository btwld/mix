import 'package:analysis_server_plugin/edit/change_builder/change_builder.dart';
import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';

/// Creates a quick fix for one diagnostic, such as `UseDotShorthand.new`.
typedef FixFactory =
    ResolvedCorrectionProducer Function({
      required CorrectionProducerContext context,
    });

/// Applies the fix from [createFix] to the first [code] diagnostic in
/// [result], and returns the fixed file content.
///
/// Throws a [StateError] when there is no such diagnostic or the fix makes
/// no edit.
Future<String> applyFix(
  ResolvedUnitResult result,
  DiagnosticCode code,
  FixFactory createFix,
) async {
  final diagnostic = result.diagnostics
      .where((d) => d.diagnosticCode == code)
      .firstOrNull;
  if (diagnostic == null) {
    throw StateError("No '${code.lowerCaseName}' diagnostic in the result.");
  }

  final libraryResult = await result.session.getResolvedLibraryContaining(
    result.path,
  );
  if (libraryResult is! ResolvedLibraryResult) {
    throw StateError('Could not resolve the library for ${result.path}.');
  }

  final fix = createFix(
    context: CorrectionProducerContext.createResolved(
      libraryResult: libraryResult,
      unitResult: result,
      diagnostic: diagnostic,
      selectionOffset: diagnostic.offset,
      selectionLength: diagnostic.length,
    ),
  );
  final builder = ChangeBuilder(session: result.session);
  await fix.compute(builder);

  final fileEdit = builder.sourceChange.getFileEdit(result.path);
  if (fileEdit == null) {
    throw StateError('The fix made no edit to ${result.path}.');
  }

  return SourceEdit.applySequence(result.content, fileEdit.edits);
}
