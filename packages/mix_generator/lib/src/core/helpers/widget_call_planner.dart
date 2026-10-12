/// Shared planning helpers for generated widget-facing call APIs.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

import '../checkers.dart';
import '../errors.dart';
import '../models/mix_widget_model.dart';
import 'library_scope.dart';
import 'type_hierarchy.dart';

const reservedParamNames = {
  'build',
  'createElement',
  'runtimeType',
  'hashCode',
  'toString',
  'noSuchMethod',
};

/// Target constructor parameters backed by the styler itself; a generated
/// `call()` passes `style: this`, so they never surface as widget-facing
/// parameters.
const stylerBackedTargetParams = {'style', 'styleSpec'};

/// Builds the widget-facing `call()` method configured by
/// `@MixableSpec(target:)`.
///
/// [hostElement] and [hostLibrary] identify where the generated method is
/// emitted. Legacy handwritten stylers can live in a different library from
/// the spec, so [validateTargetVisibility] preserves their stricter visibility
/// check without changing the generated-spec path.
String? buildMixableSpecTargetCall({
  required ConstantReader annotation,
  required InterfaceElement specElement,
  required String stylerName,
  required bool allowExactGeneratedStyler,
  required Element hostElement,
  required LibraryElement hostLibrary,
  bool validateTargetVisibility = false,
  String indent = '',
}) {
  final target = annotation.peek('target');
  if (target == null || target.isNull) return null;

  final constructor = mixableSpecTargetTearOff(target, specElement);
  final widgetName = mixableSpecTargetWidgetName(constructor);
  validateGenericTargetTearOff(
    target: target,
    constructor: constructor,
    anchor: specElement,
    annotationLabel: '@MixableSpec(target:)',
  );
  if (validateTargetVisibility) {
    final widgetElement = constructor.enclosingElement;
    final hiddenWidgetType = firstInvisibleTypeName(
      widgetElement.thisType,
      hostLibrary,
    );
    if (hiddenWidgetType != null) {
      fail(
        hostElement,
        'Target widget `$hiddenWidgetType` is used by @MixableSpec(target:) '
        'but is not visible from the @MixableStyler library.',
        todo:
            'Import or re-export `$hiddenWidgetType` where the styler is declared.',
      );
    }
  }

  validateMixableSpecTargetConstructor(
    constructor: constructor,
    widgetName: widgetName,
    specElement: specElement,
    stylerName: stylerName,
    allowExactGeneratedStyler: allowExactGeneratedStyler,
    anchor: specElement,
  );

  final call = extractCallParams(
    constructor,
    anchor: hostElement,
    library: hostLibrary,
    factoryReference: stylerName,
    excludeNames: stylerBackedTargetParams,
    annotationLabel: '@MixableSpec(target:)',
    keyOwner: 'the target constructor',
  );
  final callParams = qualifyTargetMemberDefaults(
    call.params,
    constructor: constructor,
    targetTypeReference: widgetName,
  );
  if (call.forwardsKey) {
    for (final typeParameter in constructor.enclosingElement.typeParameters) {
      if (typeParameter.name != 'Key') continue;
      fail(
        typeParameter,
        'Target widget type parameter `Key` conflicts with the generated '
        'Flutter `Key? key` parameter in @MixableSpec(target:) call().',
        todo: 'Rename the target widget type parameter.',
      );
    }
  }
  // Generated stylers and legacy styler mixins are never generic today, so
  // target type parameters cannot shadow host type parameters. Revisit this
  // if generic specs or stylers become supported.
  final typeParams = extractTypeParams(
    constructor.enclosingElement.typeParameters,
    library: hostLibrary,
    context: .mixableSpecTarget,
  );

  return renderWidgetCall(
    widgetName: widgetName,
    params: callParams,
    forwardsKey: call.forwardsKey,
    typeParams: typeParams,
    indent: indent,
  );
}

/// Qualifies default-value identifiers that refer to static members of the
/// target class so they remain in scope when copied into generated code.
List<WidgetCallParam> qualifyTargetMemberDefaults(
  List<WidgetCallParam> params, {
  required ConstructorElement constructor,
  required String targetTypeReference,
}) {
  final target = constructor.enclosingElement;

  return [
    for (final param in params)
      if (param.defaultValueCode case final code?
          when RegExp(r'^[_$A-Za-z][_$A-Za-z0-9]*$').hasMatch(code) &&
              _isStaticTargetMember(target, code))
        WidgetCallParam(
          name: param.name,
          typeCode: param.typeCode,
          isPositional: param.isPositional,
          isRequired: param.isRequired,
          defaultValueCode: '$targetTypeReference.$code',
        )
      else
        param,
  ];
}

bool _isStaticTargetMember(InterfaceElement target, String name) {
  for (final method in target.methods) {
    if (method.name == name && method.isStatic) return true;
  }
  for (final field in target.fields) {
    if (field.name == name && field.isStatic) return true;
  }

  return false;
}

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

/// Resolves `@MixableSpec(target:)` to its constructor tear-off, failing on
/// any other constant shape.
ConstructorElement mixableSpecTargetTearOff(
  ConstantReader target,
  InterfaceElement specElement,
) {
  final constructor = target.objectValue.toFunctionValue();
  if (constructor is! ConstructorElement) {
    fail(
      specElement,
      '@MixableSpec(target:) must be a constructor tear-off '
      '(e.g., Box.new).',
    );
  }

  return constructor;
}

/// Ensures a generic target is the class constructor's direct, uninstantiated
/// tear-off. The raw [ConstructorElement] does not retain type arguments or
/// typedef substitutions, so accepting either would silently change the API.
void validateGenericTargetTearOff({
  required ConstantReader target,
  required ConstructorElement constructor,
  required Element anchor,
  required String annotationLabel,
}) {
  final classTypeParams = constructor.enclosingElement.typeParameters;
  final tearOffType = target.objectValue.type;
  if (classTypeParams.isEmpty) return;

  final preservesClassTypeParams =
      tearOffType is FunctionType &&
      tearOffType.typeParameters.length == classTypeParams.length &&
      tearOffType.typeParameters.indexed.every(
        (entry) =>
            entry.$2.baseElement == classTypeParams[entry.$1].baseElement,
      );
  if (preservesClassTypeParams) return;

  final widgetName = requireName(
    constructor.enclosingElement,
    orFailWith: '$annotationLabel target widget class must have a name.',
  );
  fail(
    anchor,
    '$annotationLabel only supports direct, uninstantiated constructor '
    'tear-offs for generic target `$widgetName`.',
    todo:
        'Use the class constructor tear-off directly, without type arguments '
        'or a typedef, so the generated API can preserve its generics.',
  );
}

String mixableSpecTargetWidgetName(ConstructorElement constructor) {
  return requireName(
    constructor.enclosingElement,
    orFailWith: '@MixableSpec(target:) widget class must have a name.',
  );
}

void validateMixableSpecTargetConstructor({
  required ConstructorElement constructor,
  required String widgetName,
  required InterfaceElement specElement,
  required String stylerName,
  required bool allowExactGeneratedStyler,
  required Element anchor,
}) {
  final targetType = constructor.enclosingElement.thisType;
  if (!widgetChecker.isAssignableFromType(targetType)) {
    fail(
      anchor,
      '@MixableSpec(target:) must reference a Widget constructor, but '
      '`$widgetName` is not a Widget subtype.',
    );
  }

  final parameters = constructor.formalParameters;
  final optionalPositional = optionalPositionalNames(parameters);
  if (optionalPositional.isNotEmpty) {
    fail(
      anchor,
      '@MixableSpec(target:) does not support optional positional target '
      'constructor parameters on $widgetName: '
      '[${optionalPositional.join(', ')}].',
      todo: 'Convert these parameters to required positional or named.',
    );
  }

  final styleParameter = parameters
      .where((parameter) => parameter.name == 'style' && parameter.isNamed)
      .firstOrNull;
  if (styleParameter == null) {
    fail(
      anchor,
      '@MixableSpec(target:) requires $widgetName to expose a named '
      '`style` constructor parameter so the generated call() can pass '
      '`style: this`.',
    );
  }

  final styleSpecParameter = parameters
      .where((parameter) => parameter.name == 'styleSpec')
      .firstOrNull;
  if (styleSpecParameter != null && styleSpecParameter.isRequired) {
    fail(
      anchor,
      '@MixableSpec(target:) cannot omit required `styleSpec` on $widgetName.',
    );
  }

  if (!_targetStyleAcceptsGeneratedStyler(
    styleParameter.type,
    specElement: specElement,
    stylerName: stylerName,
    allowExactGeneratedStyler: allowExactGeneratedStyler,
  )) {
    fail(
      anchor,
      '@MixableSpec(target:) $widgetName `style` parameter cannot accept '
      'the generated `$stylerName`.',
    );
  }
}

/// Whether [targetStyleType] can receive the Styler generated for
/// [specElement] in the same build.
///
/// On a clean build, the generated class is unresolved until the shared part
/// is written. A prior generated part can instead expose it as a resolved
/// interface. Both states are accepted for the exact generated Styler; other
/// resolved types must accept its known `Style<S>` supertype.
///
/// [allowExactGeneratedStyler] is false for legacy mixins, where `this` is
/// only statically known to satisfy the mixin's `Style<S>` constraint.
bool _targetStyleAcceptsGeneratedStyler(
  DartType targetStyleType, {
  required InterfaceElement specElement,
  required String stylerName,
  required bool allowExactGeneratedStyler,
}) {
  final specName = specElement.name;
  if (specName == null) return false;

  if (targetStyleType is DynamicType ||
      targetStyleType is InvalidType ||
      targetStyleType.isDartCoreObject) {
    return true;
  }
  if (targetStyleType is! InterfaceType) return false;

  final targetElement = targetStyleType.element;
  final isExactGeneratedStyler =
      allowExactGeneratedStyler &&
      targetElement.name == stylerName &&
      targetElement.library.uri == specElement.library.uri;
  if (isExactGeneratedStyler) return true;

  var acceptedStyle = findSupertypeMatching(targetStyleType, styleChecker);
  if (acceptedStyle == null &&
      targetElement.name == 'Style' &&
      targetElement.library.uri.toString() == 'package:mix/mix.dart') {
    // Lightweight build-test fixtures declare Style directly at the public
    // barrel URI. Match that exact identity rather than rendered type text.
    acceptedStyle = targetStyleType;
  }
  if (acceptedStyle == null) return false;
  if (acceptedStyle.typeArguments.isEmpty) return false;

  final acceptedSpec = acceptedStyle.typeArguments.first;
  final acceptsSpec =
      acceptedSpec is InterfaceType &&
      acceptedSpec.element.name == specName &&
      acceptedSpec.element.library.uri == specElement.library.uri;
  if (!acceptsSpec) return false;

  return specElement.library.typeSystem.isAssignableTo(
    acceptedStyle,
    targetStyleType,
    strictCasts: false,
  );
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

enum WidgetCallTypeParamContext {
  mixWidgetCall,
  mixableSpecTarget;

  String get missingNameMessage => switch (this) {
    mixWidgetCall => '@MixWidget call type parameter must have a name.',
    mixableSpecTarget =>
      '@MixableSpec(target:) target widget type parameter must have a name.',
  };

  String invisibleBoundMessage(
    String name,
    String hiddenType,
  ) => switch (this) {
    mixWidgetCall =>
      'Call type parameter `$name` has bound `$hiddenType`, but that type '
          'is not visible from the annotated library.',
    mixableSpecTarget =>
      'Target widget type parameter `$name` has bound `$hiddenType`, but that '
          'type is not visible from the annotated library.',
  };
}

List<WidgetCallTypeParam> extractTypeParams(
  Iterable<TypeParameterElement> typeParameters, {
  required LibraryElement library,
  WidgetCallTypeParamContext context = .mixWidgetCall,
}) {
  return [
    for (final typeParameter in typeParameters)
      _typeParam(typeParameter, library: library, context: context),
  ];
}

WidgetCallTypeParam _typeParam(
  TypeParameterElement typeParameter, {
  required LibraryElement library,
  required WidgetCallTypeParamContext context,
}) {
  final name = requireName(
    typeParameter,
    orFailWith: context.missingNameMessage,
  );
  final bound = typeParameter.bound;

  if (bound == null) {
    return WidgetCallTypeParam(name: name);
  }

  final hiddenType = firstInvisibleTypeName(bound, library);
  if (hiddenType != null) {
    fail(
      typeParameter,
      context.invisibleBoundMessage(name, hiddenType),
      todo: 'Import or re-export `$hiddenType` where the annotation lives.',
    );
  }

  return WidgetCallTypeParam(
    name: name,
    boundCode: typeCode(bound, visibleFrom: library),
  );
}

String renderWidgetCall({
  required String widgetName,
  required List<WidgetCallParam> params,
  required bool forwardsKey,
  List<WidgetCallTypeParam> typeParams = const [],
  String indent = '',
}) {
  final declarationSuffix = typeParams.isEmpty
      ? ''
      : '<${typeParams.map((p) => p.declarationCode).join(', ')}>';
  final invocationSuffix = typeParams.isEmpty
      ? ''
      : '<${typeParams.map((p) => p.name).join(', ')}>';
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
$indent$widgetName$invocationSuffix call$declarationSuffix(${signatureParams.join(', ')}) {
$indent  return $widgetName$invocationSuffix(${invocationArgs.join(', ')});
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
