/// Shared planning helpers for generated widget-facing call APIs.
library;

import 'package:analyzer/dart/element/element.dart';

import '../checkers.dart';
import '../errors.dart';
import '../models/mix_widget_model.dart';
import 'library_scope.dart';

const reservedParamNames = {
  'build',
  'createElement',
  'runtimeType',
  'hashCode',
  'toString',
  'noSuchMethod',
};

/// Returns display names of optional positional parameters in declaration
/// order, with `<unnamed>` substituted for nameless parameters.
List<String> optionalPositionalNames(
  Iterable<FormalParameterElement> parameters,
) {
  return parameters
      .where((p) => p.isOptionalPositional)
      .map((p) => p.name ?? '<unnamed>')
      .toList();
}

({List<WidgetCallParam> params, bool forwardsKey}) extractCallParams(
  ExecutableElement executable, {
  required Element anchor,
  required LibraryElement library,
  required String factoryReference,
  Set<String> excludeNames = const {},
  String annotationLabel = '@MixWidget',
  String keyOwner = 'the styler `call()`',
}) {
  var forwardsKey = false;
  final params = <WidgetCallParam>[];

  for (final parameter in executable.formalParameters) {
    final name = parameter.name;
    if (name != null && excludeNames.contains(name)) continue;

    if (validateAndDetectCallKey(
      parameter,
      anchor,
      annotationLabel: annotationLabel,
      keyOwner: keyOwner,
    )) {
      forwardsKey = true;
      continue;
    }
    rejectReservedName(parameter, anchor, annotationLabel: annotationLabel);
    rejectFactoryReferenceCollision(
      parameter,
      anchor,
      factoryReference,
      annotationLabel: annotationLabel,
    );
    params.add(
      paramFor(parameter, library: library, annotationLabel: annotationLabel),
    );
  }

  return (params: params, forwardsKey: forwardsKey);
}

String renderWidgetCall({
  required String widgetName,
  required List<WidgetCallParam> params,
  required bool forwardsKey,
  String indent = '',
}) {
  final positional = params.where((p) => p.isPositional).toList();
  final named = params.where((p) => !p.isPositional).toList();
  final signatureParams = [
    ...positional.map(renderCallParameter),
    if (forwardsKey || named.isNotEmpty)
      '{${[if (forwardsKey) 'Key? key', ...named.map(renderCallParameter)].join(', ')}}',
  ];
  final invocationArgs = [
    ...positional.map((p) => p.name),
    if (forwardsKey) 'key: key',
    'style: this',
    ...named.map((p) => '${p.name}: ${p.name}'),
  ];

  return '''
$indent$widgetName call(${signatureParams.join(', ')}) {
$indent  return $widgetName(${invocationArgs.join(', ')});
$indent}
''';
}

String renderCallParameter(WidgetCallParam param) {
  final required = param.isRequired && !param.isPositional ? 'required ' : '';
  final defaultClause = param.defaultValueCode != null
      ? ' = ${param.defaultValueCode}'
      : '';

  return '$required${param.typeCode} ${param.name}$defaultClause';
}

void rejectReservedName(
  FormalParameterElement parameter,
  Element anchor, {
  String annotationLabel = '@MixWidget',
}) {
  final name = parameter.name;
  if (name == null || !reservedParamNames.contains(name)) return;

  fail(
    anchor,
    '$annotationLabel reserves the parameter name `$name` because the '
    'generated widget declares or inherits a member with that name. Dart '
    "doesn't allow a subclass field to share a name with an inherited "
    'method/getter, so the generated class would not compile.',
    todo: 'Rename the parameter to avoid clashing with `$name`.',
  );
}

void rejectFactoryReferenceCollision(
  FormalParameterElement parameter,
  Element anchor,
  String factoryReference, {
  String annotationLabel = '@MixWidget',
}) {
  if (parameter.name != factoryReference) return;

  fail(
    anchor,
    '$annotationLabel reserves the parameter name `$factoryReference` '
    "because it matches the factory's identifier; once a field with that "
    'name exists on the generated widget, the bare `$factoryReference(...)` '
    'call inside `build()` resolves to the field rather than the top-level '
    'factory.',
    todo: 'Rename the parameter to avoid clashing with the factory name.',
  );
}

/// Returns `true` when [parameter] is the forwarded `Key? key`.
///
/// Any other shape of a `key`-named parameter fails with a clear error: the
/// generated APIs expose `Key? key` as Flutter widget identity, so allowing a
/// divergent `key` parameter would silently change its contract or emit a
/// duplicate key surface.
bool validateAndDetectCallKey(
  FormalParameterElement parameter,
  Element anchor, {
  String annotationLabel = '@MixWidget',
  String keyOwner = 'the styler `call()`',
}) {
  if (parameter.name != 'key') return false;

  final issues = <String>[];
  if (!parameter.isNamed) issues.add('must be a named parameter');
  if (parameter.isRequired) issues.add('must not be `required`');
  if (parameter.defaultValueCode != null) {
    issues.add('must not have a default value');
  }
  if (parameter.type.nullabilitySuffix != .question) {
    issues.add('must be nullable');
  }
  if (!keyChecker.isExactlyType(parameter.type)) {
    issues.add(
      'must use the exact `Key` type (subtypes like `LocalKey` or '
      '`GlobalKey` are not allowed)',
    );
  }

  if (issues.isNotEmpty) {
    final typeDisplay = parameter.type.getDisplayString();
    fail(
      anchor,
      '$annotationLabel only forwards a `key` parameter when it is '
      'declared as `Key? key` on $keyOwner. Found `$typeDisplay key` '
      'which ${issues.join(' and ')}.',
      todo:
          'Use `Key? key` (named, nullable, no default, not `required`) or '
          'rename the parameter.',
    );
  }

  return true;
}

WidgetCallParam paramFor(
  FormalParameterElement parameter, {
  required LibraryElement library,
  String annotationLabel = '@MixWidget',
}) {
  final name = parameter.name;
  if (name == null) {
    fail(parameter, '$annotationLabel cannot route a parameter with no name.');
  }

  final hiddenType = firstInvisibleTypeName(parameter.type, library);
  if (hiddenType != null) {
    fail(
      parameter,
      'Parameter `$name` uses type `$hiddenType`, but that type is not '
      'visible from the annotated library.',
      todo: 'Import or re-export `$hiddenType` where the annotation lives.',
    );
  }

  return WidgetCallParam(
    name: name,
    typeCode: typeCode(parameter.type, visibleFrom: library),
    isPositional: parameter.isPositional,
    isRequired: parameter.isRequired,
    defaultValueCode: parameter.defaultValueCode,
  );
}
