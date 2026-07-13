/// Generator for `@MixWidget` factories.
///
/// Emits a `StatelessWidget` wrapper for a top-level variable or function
/// that produces a `Style<S>`.
///
/// Triggers on `@MixWidget` annotations applied to a top-level variable or
/// top-level function. The styler's `call()` method usually drives the
/// wrapper's widget-level API (parameters + delegation in `build`); for
/// spec-generated stylers, that `call()` can come from `SpecStylerGenerator`.
library;

import 'dart:convert';

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
import 'core/helpers/widget_call_planner.dart';
import 'core/models/mix_widget_model.dart';

const _annotationLabel = '@MixWidget';

typedef _WidgetParameterSelection = ({bool includesAll, Set<String> names});

class MixWidgetGenerator extends GeneratorForAnnotation<MixWidget> {
  static final _identifierPattern = RegExp(r'^_*[A-Za-z][A-Za-z0-9_]*$');
  static final _derivedNamePattern = RegExp(r'^_*[a-z][A-Za-z0-9]*Style$');
  static const _variantParamName = 'variant';

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
    _WidgetParameterSelection widgetParameters,
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
    final call = _extractWidgetCallParams(
      callMethod,
      anchor: variable,
      library: library,
      factoryReference: variableName,
      widgetParameters: widgetParameters,
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
      callTypeParams: _extractCallTypeParams(callMethod, library: library),
      stylerCallForwardsKey: call.forwardsKey,
      doc: variable.documentationComment,
    );
  }

  MixWidgetModel _modelForFunction(
    TopLevelFunctionElement function,
    ConstantReader annotation,
    _WidgetParameterSelection widgetParameters,
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
    final call = _extractWidgetCallParams(
      callMethod,
      anchor: function,
      library: library,
      factoryReference: functionName,
      widgetParameters: widgetParameters,
    );

    _rejectCollisions(function, factoryParams, call.params);

    final callTypeParams = _extractCallTypeParams(callMethod, library: library);
    final variantConstructors = _extractVariantConstructors(
      function,
      library: library,
      widgetTypeParameterNames: {
        for (final typeParameter in callTypeParams) typeParameter.name,
      },
    );

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
      callTypeParams: callTypeParams,
      stylerCallForwardsKey: call.forwardsKey,
      doc: function.documentationComment,
      variantParamName: variantConstructors == null ? null : _variantParamName,
      variantConstructors: variantConstructors ?? const [],
    );
  }

  List<WidgetVariantConstructor>? _extractVariantConstructors(
    TopLevelFunctionElement function, {
    required LibraryElement library,
    required Set<String> widgetTypeParameterNames,
  }) {
    for (final parameter in function.formalParameters) {
      if (parameter.name != _variantParamName || !parameter.isNamed) continue;

      final type = parameter.type;
      if (type is! InterfaceType ||
          type.nullabilitySuffix == .question ||
          type.element is! EnumElement) {
        return null;
      }

      final enumElement = type.element as EnumElement;
      final enumTypeCode = typeCode(type, visibleFrom: library);

      final constructors = [
        for (final constant in enumElement.constants)
          // An imported enum's private constants cannot be referenced from
          // the annotated library, so they cannot back constructors here.
          if (constant.isPublic || constant.library == library)
            _variantConstructor(constant, enumTypeCode: enumTypeCode),
      ];

      if (constructors.any(
        (constructor) => widgetTypeParameterNames.contains(constructor.name),
      )) {
        // Named constructors and class type parameters share a namespace.
        // Keep the convention non-breaking rather than emitting invalid Dart.
        return null;
      }

      return constructors;
    }

    return null;
  }

  WidgetVariantConstructor _variantConstructor(
    FieldElement constant, {
    required String enumTypeCode,
  }) {
    final name = requireName(
      constant,
      orFailWith: '$_annotationLabel enum constants must have names.',
    );

    return WidgetVariantConstructor(
      name: name,
      valueCode: '$enumTypeCode.$name',
      doc: constant.documentationComment,
      deprecationCode: _deprecationCode(constant),
    );
  }

  String? _deprecationCode(FieldElement constant) {
    for (final annotation in constant.metadata.annotations) {
      if (!annotation.isDeprecated) continue;

      final value = annotation.computeConstantValue();
      final message = value?.getField('message')?.toStringValue();
      final messageCode = message == null
          ? 'null'
          : _dartStringLiteral(message);

      return '@Deprecated($messageCode)';
    }

    return null;
  }

  String _dartStringLiteral(String value) =>
      jsonEncode(value).replaceAll(r'$', r'\$');

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
  /// validates that it returns a `Widget`-assignable type.
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

    if (_widgetAssignableReturnType(call.returnType) == null) {
      fail(
        anchor,
        '$_annotationLabel requires $stylerName.call() to return a Widget '
        'subtype, but it returns `${call.returnType.getDisplayString()}`.',
      );
    }

    return call;
  }

  /// Reads the concrete annotation value into the two generator modes.
  ///
  /// `mix_annotations` versions before parameter curation do not expose
  /// [MixWidget.widgetParameters]. Treat that legacy shape as `.all()` so a
  /// generator upgrade does not break existing `@MixWidget()` consumers.
  _WidgetParameterSelection _widgetParameterSelectionFor(
    ConstantReader annotation,
  ) {
    final selection = annotation.peek('widgetParameters');
    if (selection == null) return (includesAll: true, names: <String>{});

    final names = {
      for (final name in selection.read('names').setValue)
        ConstantReader(name).stringValue,
    };

    return (includesAll: selection.read('includesAll').boolValue, names: names);
  }

  /// Selects and validates the non-key styler `call()` parameters exposed by
  /// a generated widget.
  ///
  /// Excluded parameters are removed before optional-positional, reserved-name,
  /// visibility, and collision validation. `key` remains automatic and is
  /// therefore always validated, even in an empty `only` selection.
  ({List<WidgetCallParam> params, bool forwardsKey}) _extractWidgetCallParams(
    MethodElement callMethod, {
    required Element anchor,
    required LibraryElement library,
    required String factoryReference,
    required _WidgetParameterSelection widgetParameters,
  }) {
    final excludedNames = <String>{};

    if (!widgetParameters.includesAll) {
      final availableNames = {
        for (final parameter in callMethod.formalParameters)
          if (parameter.name case final String name) name,
      };

      for (final name in widgetParameters.names) {
        if (name == 'key') {
          fail(
            anchor,
            '$_annotationLabel widgetParameters must not select `key`; '
            '`Key? key` is forwarded automatically.',
            todo: 'Remove `key` from the selection.',
          );
        }

        if (!availableNames.contains(name)) {
          fail(
            anchor,
            '$_annotationLabel widgetParameters selects unknown styler '
            '`call()` parameter `$name`.',
            todo: 'Select a parameter declared by the styler `call()` method.',
          );
        }
      }

      for (final parameter in callMethod.formalParameters) {
        final name = parameter.name;
        if (name == 'key' ||
            name == null ||
            widgetParameters.names.contains(name)) {
          continue;
        }

        if (parameter.isRequired) {
          fail(
            anchor,
            '$_annotationLabel widgetParameters must include required styler '
            '`call()` parameter `$name`.',
            todo:
                'Add `$name` to `widgetParameters: .only({...})` or use '
                '`widgetParameters: .all()`.',
          );
        }

        excludedNames.add(name);
      }
    }

    final selectedParameters = [
      for (final parameter in callMethod.formalParameters)
        if (parameter.name == 'key' ||
            parameter.name == null ||
            !excludedNames.contains(parameter.name))
          parameter,
    ];

    final optionalPositional = optionalPositionalNames(
      selectedParameters.where((parameter) => parameter.name != 'key'),
    );
    if (optionalPositional.isNotEmpty) {
      fail(
        anchor,
        '$_annotationLabel does not support selected optional positional '
        '`call()` parameters on '
        '${callMethod.enclosingElement?.displayName ?? 'the styler'}: '
        '[${optionalPositional.join(', ')}].',
        todo: 'Convert these parameters to required positional or named.',
      );
    }

    return extractCallParams(
      callMethod,
      anchor: anchor,
      library: library,
      factoryReference: factoryReference,
      excludeNames: excludedNames,
    );
  }

  /// A generic `call<T extends Widget>()` reports its return as `T`; validate
  /// that shape against the bound so generated `build()` still returns Widget.
  DartType? _widgetAssignableReturnType(DartType returnType) {
    if (returnType is TypeParameterType) {
      return _widgetAssignableReturnType(returnType.bound);
    }

    if (widgetChecker.isAssignableFromType(returnType)) {
      return returnType;
    }

    return null;
  }

  List<WidgetCallTypeParam> _extractCallTypeParams(
    MethodElement callMethod, {
    required LibraryElement library,
  }) {
    return [
      for (final typeParameter in callMethod.typeParameters)
        _callTypeParam(typeParameter, library: library),
    ];
  }

  WidgetCallTypeParam _callTypeParam(
    TypeParameterElement typeParameter, {
    required LibraryElement library,
  }) {
    final name = requireName(
      typeParameter,
      orFailWith: '$_annotationLabel call type parameter must have a name.',
    );
    final bound = typeParameter.bound;

    if (bound == null) {
      return WidgetCallTypeParam(name: name);
    }

    final hiddenType = firstInvisibleTypeName(bound, library);
    if (hiddenType != null) {
      fail(
        typeParameter,
        'Call type parameter `$name` has bound `$hiddenType`, but that type '
        'is not visible from the annotated library.',
        todo: 'Import or re-export `$hiddenType` where the annotation lives.',
      );
    }

    return WidgetCallTypeParam(
      name: name,
      boundCode: typeCode(bound, visibleFrom: library),
    );
  }

  List<WidgetCallParam> _extractFactoryParams(
    TopLevelFunctionElement function, {
    required LibraryElement library,
    required String factoryReference,
  }) {
    final optionalPositional = optionalPositionalNames(
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

    final params = <WidgetCallParam>[];
    for (final p in function.formalParameters) {
      _rejectFactoryKeyParam(p, function);
      rejectReservedName(p, function);
      rejectFactoryReferenceCollision(p, function, factoryReference);
      params.add(paramFor(p, library: library));
    }

    return params;
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

  /// Disallows reusing the same name for a factory parameter and a non-`key`
  /// call parameter.
  ///
  /// Without this check the generated constructor would have two fields with
  /// the same name and fail to compile; this error is more actionable than
  /// the resulting Dart compiler diagnostic.
  void _rejectCollisions(
    Element anchor,
    List<WidgetCallParam> factoryParams,
    List<WidgetCallParam> callParams,
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
    final returnType = _widgetAssignableReturnType(callMethod.returnType);
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
    final widgetParameters = _widgetParameterSelectionFor(annotation);
    final model = switch (element) {
      TopLevelVariableElement v => _modelForVariable(
        v,
        annotation,
        widgetParameters,
      ),
      TopLevelFunctionElement f => _modelForFunction(
        f,
        annotation,
        widgetParameters,
      ),
      _ => fail(
        element,
        '$_annotationLabel can only be applied to top-level variables or '
        'top-level functions.',
      ),
    };

    return MixWidgetBuilder(model).build();
  }
}
