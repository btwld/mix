import '../metadata/field_metadata.dart';

/// Returns constructor for the given type and optional named constructor name. E.g. "TestConstructor" or "TestConstructor._private" when "_private" constructor name is provided.
String constructorFor(String typeAnnotation, String? namedConstructor) =>
    "$typeAnnotation${namedConstructor == null ? "" : ".$namedConstructor"}";

/// Builds a string of constructor parameters from a list of field metadata.
///
/// [params] - List of field metadata objects
/// [buildParam] - Function to transform each field into a parameter string
/// [addTrailingComma] - Whether to add a trailing comma (defaults to true)
String buildParameters(
  List<ParameterMetadata> params,
  String Function(ParameterMetadata) buildParam,
) {
  if (params.isEmpty) return '';

  // Separate params into positional and named
  final positionalParams = params.where((p) => p.isPositional).toList();
  final namedParams = params.where((p) => !p.isPositional).toList();

  // Build parts list for cleaner joining
  final parts = <String>[];

  // Add positional parameters if any
  if (positionalParams.isNotEmpty) {
    parts.add(positionalParams.map(buildParam).join(', '));
  }

  // Add named parameters if any
  if (namedParams.isNotEmpty) {
    parts.add(namedParams
        .map((param) => '${param.name}: ${buildParam(param)}')
        .join(', '));
  }

  // Join all parts with comma separator
  final result = parts.join(', ');

  // Add trailing comma if requested and there are parameters
  return result.isEmpty ? '' : '$result,';
}

String buildArguments(
  List<ParameterMetadata> params,
  String Function(ParameterMetadata) buildParam,
) {
  if (params.isEmpty) return '';

  final paramsStr = params.map((param) => buildParam(param)).join(', ');

  return '{$paramsStr,}';
}
