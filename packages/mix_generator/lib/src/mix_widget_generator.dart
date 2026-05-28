/// Generator for `@MixWidget` factories.
///
/// Emits a `StatelessWidget` wrapper for a top-level variable or function
/// that produces a `Style<S>`.
///
/// Triggers on `@MixWidget` annotations applied to a top-level variable or
/// top-level function. The styler's `call()` method drives the wrapper's
/// widget-level API (parameters + delegation in `build`).
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/builders/mix_widget_builder.dart';
import 'core/checkers.dart';
import 'core/errors.dart';
import 'core/helpers/library_scope.dart';
import 'core/helpers/type_hierarchy.dart';
import 'core/models/mix_widget_model.dart';

const _annotationLabel = '@MixWidget';

class MixWidgetGenerator extends GeneratorForAnnotation<MixWidget> {
  static final _identifierPattern = RegExp(r'^_*[A-Za-z][A-Za-z0-9_]*$');
  static final _derivedNamePattern = RegExp(r'^_*[a-z][A-Za-z0-9]*Style$');

  static const _reservedParamNames = {
    'build',
    'createElement',
    'runtimeType',
    'hashCode',
    'toString',
    'noSuchMethod',
  };

  static const _dartReservedWords = {
    'abstract',
    'as',
    'assert',
    'async',
    'await',
    'base',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'covariant',
    'default',
    'deferred',
    'do',
    'dynamic',
    'else',
    'enum',
    'export',
    'extends',
    'extension',
    'external',
    'factory',
    'false',
    'final',
    'finally',
    'for',
    'Function',
    'get',
    'hide',
    'if',
    'implements',
    'import',
    'in',
    'interface',
    'is',
    'late',
    'library',
    'mixin',
    'new',
    'null',
    'of',
    'on',
    'operator',
    'part',
    'required',
    'rethrow',
    'return',
    'sealed',
    'set',
    'show',
    'static',
    'super',
    'switch',
    'sync',
    'this',
    'throw',
    'true',
    'try',
    'type',
    'typedef',
    'var',
    'void',
    'when',
    'while',
    'with',
    'yield',
  };

  const MixWidgetGenerator();

  MixWidgetModel _modelForVariable(
    TopLevelVariableElement variable,
    ConstantReader annotation,
  ) {
    final variableName = requireName(
      variable,
      orFailWith: '$_annotationLabel target must have a name.',
    );

    final library = variable.library;
    final stylerType = _requireStyleInterface(variable, variable.type);
    final callMethod = _requireCallMethod(
      variable,
      stylerType,
      library: library,
    );
    _requireUnprefixedFlutterSymbols(variable, callMethod, library);
    final call = _extractCallParams(
      callMethod,
      anchor: variable,
      library: library,
      factoryReference: variableName,
    );

    return MixWidgetModel(
      widgetName: _resolveWidgetName(
        variable,
        annotation,
        variableName,
        library,
      ),
      factoryReference: variableName,
      isFunctionFactory: false,
      factoryParams: const [],
      callParams: call.params,
      stylerCallForwardsKey: call.forwardsKey,
      doc: variable.documentationComment,
    );
  }

  MixWidgetModel _modelForFunction(
    TopLevelFunctionElement function,
    ConstantReader annotation,
  ) {
    final functionName = requireName(
      function,
      orFailWith: '$_annotationLabel target must have a name.',
    );

    if (function.typeParameters.isNotEmpty) {
      fail(
        function,
        '$_annotationLabel does not support generic factory functions.',
        todo: 'Remove type parameters from $functionName.',
      );
    }

    final library = function.library;
    final stylerType = _requireStyleInterface(function, function.returnType);
    final callMethod = _requireCallMethod(
      function,
      stylerType,
      library: library,
    );

    _requireUnprefixedFlutterSymbols(function, callMethod, library);

    final factoryParams = _extractFactoryParams(
      function,
      library: library,
      factoryReference: functionName,
    );
    final call = _extractCallParams(
      callMethod,
      anchor: function,
      library: library,
      factoryReference: functionName,
    );

    _rejectCollisions(function, factoryParams, call.params);

    return MixWidgetModel(
      widgetName: _resolveWidgetName(
        function,
        annotation,
        functionName,
        library,
      ),
      factoryReference: functionName,
      isFunctionFactory: true,
      factoryParams: factoryParams,
      callParams: call.params,
      stylerCallForwardsKey: call.forwardsKey,
      doc: function.documentationComment,
    );
  }

  /// Confirms [type] is a `Style<S>` subtype and returns the styler interface.
  InterfaceType _requireStyleInterface(Element anchor, DartType type) {
    if (type is! InterfaceType) {
      fail(
        anchor,
        '$_annotationLabel target must resolve to a Style<S> subtype, but '
        'got `${type.getDisplayString()}`.',
        todo:
            'Declare a static type extending `Style<YourSpec>` on the variable '
            'or as the function return type.',
      );
    }

    if (findSupertypeMatching(type, styleChecker) == null) {
      fail(
        anchor,
        '$_annotationLabel target must resolve to a Style<S> subtype, but '
        '`${type.getDisplayString()}` does not extend Style<S>.',
        todo:
            'Use a styler that extends `Style<YourSpec>` (e.g. `BoxStyler`, '
            '`TextStyler`).',
      );
    }

    return type;
  }

  /// Looks up the styler's `call()` method (including inherited members) and
  /// validates the contract: non-generic, returns a `Widget`, no optional
  /// positional parameters.
  MethodElement _requireCallMethod(
    Element anchor,
    InterfaceType stylerType, {
    required LibraryElement library,
  }) {
    final call =
        stylerType.getMethod('call') ??
        stylerType.lookUpMethod('call', library, inherited: true);

    final stylerElement = stylerType.element;
    final stylerName = stylerElement.name ?? stylerType.getDisplayString();
    if (call == null) {
      fail(
        anchor,
        '$_annotationLabel requires $stylerName to declare a `call()` method.',
        todo:
            'Add a `Widget call({...}) { return ...; }` to $stylerName so '
            'the generated widget knows how to render.',
      );
    }

    if (call.typeParameters.isNotEmpty) {
      fail(
        anchor,
        '$_annotationLabel requires a non-generic `call()` on $stylerName.',
        todo: 'Remove type parameters from the `call()` method.',
      );
    }

    if (!widgetChecker.isAssignableFromType(call.returnType)) {
      fail(
        anchor,
        '$_annotationLabel requires $stylerName.call() to return a Widget '
        'subtype, but it returns `${call.returnType.getDisplayString()}`.',
      );
    }

    final optionalPositional = _optionalPositionalNames(call.formalParameters);
    if (optionalPositional.isNotEmpty) {
      fail(
        anchor,
        '$_annotationLabel does not support optional positional `call()` '
        'parameters on $stylerName: [${optionalPositional.join(', ')}].',
        todo: 'Convert these parameters to required positional or named.',
      );
    }

    return call;
  }

  /// Returns display names of optional positional parameters in declaration
  /// order, with `<unnamed>` substituted for nameless parameters.
  List<String> _optionalPositionalNames(
    Iterable<FormalParameterElement> parameters,
  ) {
    return parameters
        .where((p) => p.isOptionalPositional)
        .map((p) => p.name ?? '<unnamed>')
        .toList();
  }

  List<MixWidgetParam> _extractFactoryParams(
    TopLevelFunctionElement function, {
    required LibraryElement library,
    required String factoryReference,
  }) {
    final optionalPositional = _optionalPositionalNames(
      function.formalParameters,
    );
    if (optionalPositional.isNotEmpty) {
      fail(
        function,
        '$_annotationLabel does not support optional positional factory '
        'parameters: [${optionalPositional.join(', ')}].',
        todo: 'Convert these parameters to required positional or named.',
      );
    }

    final params = <MixWidgetParam>[];
    for (final p in function.formalParameters) {
      _rejectFactoryKeyParam(p, function);
      _rejectReservedName(p, function);
      _rejectFactoryReferenceCollision(p, function, factoryReference);
      params.add(_paramFor(p, library: library));
    }

    return params;
  }

  ({List<MixWidgetParam> params, bool forwardsKey}) _extractCallParams(
    MethodElement callMethod, {
    required Element anchor,
    required LibraryElement library,
    required String factoryReference,
  }) {
    var forwardsKey = false;
    final params = <MixWidgetParam>[];

    for (final p in callMethod.formalParameters) {
      if (_validateAndDetectCallKey(p, anchor)) {
        forwardsKey = true;
        continue;
      }
      _rejectReservedName(p, anchor);
      _rejectFactoryReferenceCollision(p, anchor, factoryReference);
      params.add(_paramFor(p, library: library));
    }

    return (params: params, forwardsKey: forwardsKey);
  }

  void _rejectReservedName(FormalParameterElement parameter, Element anchor) {
    final name = parameter.name;
    if (name == null || !_reservedParamNames.contains(name)) return;

    fail(
      anchor,
      '$_annotationLabel reserves the parameter name `$name` because the '
      'generated widget declares or inherits a member with that name. Dart '
      "doesn't allow a subclass field to share a name with an inherited "
      'method/getter, so the generated class would not compile.',
      todo: 'Rename the parameter to avoid clashing with `$name`.',
    );
  }

  void _rejectFactoryReferenceCollision(
    FormalParameterElement parameter,
    Element anchor,
    String factoryReference,
  ) {
    if (parameter.name != factoryReference) return;

    fail(
      anchor,
      '$_annotationLabel reserves the parameter name `$factoryReference` '
      "because it matches the factory's identifier; once a field with that "
      'name exists on the generated widget, the bare `$factoryReference(...)` '
      'call inside `build()` resolves to the field rather than the top-level '
      'factory.',
      todo: 'Rename the parameter to avoid clashing with the factory name.',
    );
  }

  /// Reserves the parameter name `key` on factory functions. The forwarded
  /// `super.key` always comes from the styler's `call()`; a factory-level
  /// `key` would collide with that.
  void _rejectFactoryKeyParam(
    FormalParameterElement parameter,
    Element anchor,
  ) {
    if (parameter.name != 'key') return;
    fail(
      anchor,
      '$_annotationLabel reserves the parameter name `key` for the styler '
      "`call()`'s `Key? key`. Factory functions must not declare a parameter "
      'named `key`.',
      todo: 'Rename the factory parameter to something other than `key`.',
    );
  }

  /// Returns `true` when [parameter] is the forwarded `Key? key` on a
  /// styler's `call()` — in that case it is dropped from the generated
  /// constructor and surfaced via `super.key` instead.
  ///
  /// Any other shape of a `key`-named parameter fails with a clear error:
  /// the generated constructor unconditionally exposes `super.key`, so
  /// allowing a divergent `key` parameter would either silently change its
  /// contract (e.g. `required Key key` → optional `Key?`) or emit a
  /// duplicate `key` field that won't compile.
  bool _validateAndDetectCallKey(
    FormalParameterElement parameter,
    Element anchor,
  ) {
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
        '$_annotationLabel only forwards a `key` parameter when it is '
        'declared as `Key? key` on the styler `call()`. Found '
        '`$typeDisplay key` which ${issues.join(' and ')}.',
        todo:
            'Use `Key? key` (named, nullable, no default, not `required`) or '
            'rename the parameter.',
      );
    }

    return true;
  }

  MixWidgetParam _paramFor(
    FormalParameterElement parameter, {
    required LibraryElement library,
  }) {
    final name = parameter.name;
    if (name == null) {
      fail(
        parameter,
        '$_annotationLabel cannot route a parameter with no name.',
      );
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

    return MixWidgetParam(
      name: name,
      typeCode: typeCode(parameter.type, visibleFrom: library),
      isPositional: parameter.isPositional,
      isRequired: parameter.isRequired,
      defaultValueCode: parameter.defaultValueCode,
    );
  }

  /// Disallows reusing the same name for a factory parameter and a non-`key`
  /// call parameter.
  ///
  /// Without this check the generated constructor would have two fields with
  /// the same name and fail to compile; this error is more actionable than
  /// the resulting Dart compiler diagnostic.
  void _rejectCollisions(
    Element anchor,
    List<MixWidgetParam> factoryParams,
    List<MixWidgetParam> callParams,
  ) {
    final factoryNames = factoryParams.map((p) => p.name).toSet();
    for (final callParam in callParams) {
      if (factoryNames.contains(callParam.name)) {
        fail(
          anchor,
          '$_annotationLabel parameter name collision: `${callParam.name}` '
          'is declared both as a factory parameter and as a styler `call()` '
          'parameter.',
          todo: 'Rename one of the parameters.',
        );
      }
    }
  }

  void _requireUnprefixedFlutterSymbols(
    Element anchor,
    MethodElement callMethod,
    LibraryElement hostLibrary,
  ) {
    final returnType = callMethod.returnType;
    if (returnType is! InterfaceType) return;

    final widgetType = findSupertypeMatching(returnType, widgetChecker);
    if (widgetType == null) return;

    final framework = widgetType.element.library;
    final widget = framework.getClass('Widget');
    final statelessWidget = framework.getClass('StatelessWidget');
    final buildContext = framework.getClass('BuildContext');

    if (widget == null || statelessWidget == null || buildContext == null) {
      fail(
        anchor,
        '$_annotationLabel could not locate Flutter base classes (Widget, '
        'StatelessWidget, BuildContext) on `${framework.uri}`.',
        todo:
            "Add `import 'package:flutter/widgets.dart';` to the annotated "
            'library.',
      );
    }

    final invisible = <String>[
      if (referenceFor(widget, hostLibrary) != 'Widget') 'Widget',
      if (referenceFor(statelessWidget, hostLibrary) != 'StatelessWidget')
        'StatelessWidget',
      if (referenceFor(buildContext, hostLibrary) != 'BuildContext')
        'BuildContext',
    ];

    if (invisible.isEmpty) return;

    fail(
      anchor,
      '$_annotationLabel requires the Flutter base types '
      '${invisible.map((n) => '`$n`').join(', ')} to be visible unprefixed '
      'in the annotated library. The generated widget extends '
      '`StatelessWidget` and overrides `build(BuildContext context)` using '
      'bare names.',
      todo:
          "Import `package:flutter/widgets.dart` without an `as` prefix "
          '(or re-export it without a prefix from a barrel file).',
    );
  }

  /// Resolves the generated widget name. `@MixWidget(name: 'X')` wins;
  /// otherwise strips a trailing `Style` and uppercases the first character,
  /// preserving leading underscores for privacy.
  String _resolveWidgetName(
    Element anchor,
    ConstantReader annotation,
    String elementName,
    LibraryElement library,
  ) {
    final override = annotation.peek('name')?.stringValue;
    if (override != null && override.isNotEmpty) {
      if (!_isValidDartTypeIdentifier(override)) {
        fail(
          anchor,
          "$_annotationLabel(name: '$override') is not a valid Dart class "
          'identifier.',
          todo: 'Use a valid Dart class name for the override.',
        );
      }

      _rejectWidgetNameCollision(anchor, override, library);

      return override;
    }

    final derived = _deriveWidgetName(anchor, elementName);
    _rejectWidgetNameCollision(anchor, derived, library);

    return derived;
  }

  void _rejectWidgetNameCollision(
    Element anchor,
    String widgetName,
    LibraryElement library,
  ) {
    if (!hasUnprefixedVisibleName(widgetName, library)) return;

    fail(
      anchor,
      '$_annotationLabel generated class `$widgetName` would shadow or '
      'collide with an existing visible symbol in the annotated library.',
      todo:
          'Use @MixWidget(name: ...) with a class name that is not already '
          'visible unprefixed, or hide/rename the existing symbol.',
    );
  }

  bool _isValidDartTypeIdentifier(String value) {
    return _identifierPattern.hasMatch(value) &&
        !_dartReservedWords.contains(value);
  }

  String _deriveWidgetName(Element anchor, String name) {
    if (!_derivedNamePattern.hasMatch(name)) {
      fail(
        anchor,
        '$_annotationLabel expects the annotated element to be lowerCamelCase '
        'ending in `Style` (e.g. `cardStyle`, `primaryButtonStyle`). Got '
        '`$name`.',
        todo:
            "Rename the element or use @MixWidget(name: 'YourWidget') to "
            'override the derived name.',
      );
    }

    var leadingUnderscores = 0;
    while (leadingUnderscores < name.length &&
        name[leadingUnderscores] == '_') {
      leadingUnderscores++;
    }
    final body = name.substring(leadingUnderscores);
    final stripped = body.endsWith('Style')
        ? body.substring(0, body.length - 'Style'.length)
        : body;

    if (stripped.isEmpty) {
      fail(
        anchor,
        '$_annotationLabel cannot derive a widget name from `$name`.',
        todo:
            "Use @MixWidget(name: 'YourWidget') or rename the element so it "
            'has more than just a `Style` suffix.',
      );
    }

    final pascal = stripped[0].toUpperCase() + stripped.substring(1);

    return '${'_' * leadingUnderscores}$pascal';
  }

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final model = switch (element) {
      TopLevelVariableElement v => _modelForVariable(v, annotation),
      TopLevelFunctionElement f => _modelForFunction(f, annotation),
      _ => fail(
        element,
        '$_annotationLabel can only be applied to top-level variables or '
        'top-level functions.',
      ),
    };

    return MixWidgetBuilder(model).build();
  }
}
