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

import 'package:analyzer/dart/ast/ast.dart';
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
import 'core/models/field_model.dart' show deriveStylerName;
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
    ConstructorElement? targetConstructor,
    String? writtenStylerName,
  ) {
    final variableName = requireName(
      variable,
      orFailWith: '$_annotationLabel target must have a name.',
    );

    final library = variable.library;
    final callSource = targetConstructor == null
        ? _resolveCallSource(
            anchor: variable,
            stylerType: variable.type,
            writtenStylerName: writtenStylerName,
            library: library,
          )
        : _directTargetCallSource(
            anchor: variable,
            constructor: targetConstructor,
            stylerType: variable.type,
            writtenStylerName: writtenStylerName,
            library: library,
          );
    _requireUnprefixedFlutterSymbols(variable, callSource.call, library);
    final call = _extractWidgetCallParams(
      callSource.call,
      anchor: variable,
      library: library,
      factoryReference: variableName,
      widgetParameters: widgetParameters,
      baseExcluded: callSource.baseExcluded,
    );
    final callParams = targetConstructor == null
        ? call.params
        : _qualifyDirectTargetDefaults(
            call.params,
            constructor: targetConstructor,
            targetTypeReference: callSource.targetTypeReference!,
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
      callParams: callParams,
      callTypeParams: targetConstructor == null
          ? (callSource.isGenerated
                ? const []
                : _extractCallTypeParams(callSource.call, library: library))
          : _extractTargetTypeParams(targetConstructor, library: library),
      stylerCallForwardsKey: call.forwardsKey,
      targetTypeReference: callSource.targetTypeReference,
      targetConstructorName: callSource.targetConstructorName,
      doc: variable.documentationComment,
    );
  }

  MixWidgetModel _modelForFunction(
    TopLevelFunctionElement function,
    ConstantReader annotation,
    _WidgetParameterSelection widgetParameters,
    _WidgetParameterSelection factoryParameters,
    ConstructorElement? targetConstructor,
    String? writtenStylerName,
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
    final callSource = targetConstructor == null
        ? _resolveCallSource(
            anchor: function,
            stylerType: function.returnType,
            writtenStylerName: writtenStylerName,
            library: library,
          )
        : _directTargetCallSource(
            anchor: function,
            constructor: targetConstructor,
            stylerType: function.returnType,
            writtenStylerName: writtenStylerName,
            library: library,
          );

    _requireUnprefixedFlutterSymbols(function, callSource.call, library);

    final factoryParams = _extractFactoryParams(
      function,
      library: library,
      factoryReference: functionName,
      factoryParameters: factoryParameters,
    );
    final call = _extractWidgetCallParams(
      callSource.call,
      anchor: function,
      library: library,
      factoryReference: functionName,
      widgetParameters: widgetParameters,
      baseExcluded: callSource.baseExcluded,
    );
    final callParams = targetConstructor == null
        ? call.params
        : _qualifyDirectTargetDefaults(
            call.params,
            constructor: targetConstructor,
            targetTypeReference: callSource.targetTypeReference!,
          );

    if (targetConstructor == null) {
      _rejectCollisions(function, factoryParams, callParams);
    } else {
      _validateDirectTargetCollisions(function, factoryParams, callParams);
    }

    final callTypeParams = targetConstructor == null
        ? (callSource.isGenerated
              ? const <WidgetCallTypeParam>[]
              : _extractCallTypeParams(callSource.call, library: library))
        : _extractTargetTypeParams(targetConstructor, library: library);
    final variantConstructors =
        factoryParams.any((parameter) => parameter.name == _variantParamName)
        ? _extractVariantConstructors(
            function,
            library: library,
            widgetTypeParameterNames: {
              for (final typeParameter in callTypeParams) typeParameter.name,
            },
          )
        : null;

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
      callParams: callParams,
      callTypeParams: callTypeParams,
      stylerCallForwardsKey: call.forwardsKey,
      targetTypeReference: callSource.targetTypeReference,
      targetConstructorName: callSource.targetConstructorName,
      doc: function.documentationComment,
      variantParamName: variantConstructors == null ? null : _variantParamName,
      variantConstructors: variantConstructors ?? const [],
    );
  }

  List<WidgetCallParam> _qualifyDirectTargetDefaults(
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

  _CallSource _directTargetCallSource({
    required Element anchor,
    required ConstructorElement constructor,
    required DartType stylerType,
    required String? writtenStylerName,
    required LibraryElement library,
  }) {
    final targetType = constructor.enclosingElement.thisType;
    final targetName =
        constructor.enclosingElement.name ?? targetType.getDisplayString();
    if (!widgetChecker.isAssignableFromType(targetType)) {
      fail(
        anchor,
        '$_annotationLabel(target:) must reference a Widget constructor, but '
        '`$targetName` is not a Widget subtype.',
      );
    }

    final targetReference = referenceFor(constructor.enclosingElement, library);
    if (targetReference == null) {
      fail(
        anchor,
        '$_annotationLabel(target:) widget `$targetName` is not visible from '
        'the annotated library.',
      );
    }

    final optionalPositional = optionalPositionalNames(
      constructor.formalParameters,
    );
    if (optionalPositional.isNotEmpty) {
      fail(
        anchor,
        '$_annotationLabel(target:) does not support optional positional '
        'target constructor parameters on $targetName: '
        '[${optionalPositional.join(', ')}].',
        todo: 'Convert these parameters to required positional or named.',
      );
    }

    FormalParameterElement? styleParameter;
    for (final parameter in constructor.formalParameters) {
      if (parameter.name == 'style' && parameter.isNamed) {
        styleParameter = parameter;
        break;
      }
    }
    if (styleParameter == null) {
      fail(
        anchor,
        '$_annotationLabel(target:) requires $targetName to expose a named '
        '`style` constructor parameter so the generated widget can pass the '
        'recipe result through `style`.',
      );
    }

    final styleSpecParameter = constructor.formalParameters
        .where((parameter) => parameter.name == 'styleSpec')
        .firstOrNull;
    if (styleSpecParameter != null && styleSpecParameter.isRequired) {
      fail(
        anchor,
        '$_annotationLabel(target:) cannot omit required `styleSpec` on '
        '$targetName.',
      );
    }

    final compatible = _targetStyleAcceptsRecipe(
      styleParameter.type,
      stylerType: stylerType,
      writtenStylerName: writtenStylerName,
      library: library,
    );
    if (!compatible) {
      fail(
        anchor,
        '$_annotationLabel(target:) $targetName `style` parameter cannot '
        'accept the `${writtenStylerName ?? stylerType.getDisplayString()}` '
        'recipe result.',
      );
    }

    final constructorName = constructor.name;
    return _CallSource(
      call: constructor,
      baseExcluded: stylerBackedTargetParams,
      isGenerated: false,
      targetTypeReference: targetReference,
      targetConstructorName:
          constructorName == null ||
              constructorName.isEmpty ||
              constructorName == 'new'
          ? null
          : constructorName,
    );
  }

  bool _targetStyleAcceptsRecipe(
    DartType targetStyleType, {
    required DartType stylerType,
    required String? writtenStylerName,
    required LibraryElement library,
  }) {
    if (stylerType is InterfaceType) {
      return library.typeSystem.isAssignableTo(
        stylerType,
        targetStyleType,
        strictCasts: false,
      );
    }

    if (writtenStylerName == null) return false;
    final spec = _findGeneratedStylerSpec(library, writtenStylerName);
    if (spec == null) return false;

    // A target can itself refer to a same-build generated Styler, in which
    // case analyzer reports InvalidType until the shared part is written.
    if (targetStyleType is! InterfaceType) return true;

    final acceptedStyle = findSupertypeMatching(targetStyleType, styleChecker);
    if (acceptedStyle == null) {
      // Some build-test consumers re-export a lightweight Style stub from a
      // barrel rather than its canonical library. Preserve semantic matching
      // for that test shape without weakening non-Style targets.
      return targetStyleType.getDisplayString() == 'Style<${spec.name}>';
    }
    if (acceptedStyle.typeArguments.isEmpty) {
      return false;
    }

    final acceptedSpec = acceptedStyle.typeArguments.first;
    return acceptedSpec is InterfaceType &&
        acceptedSpec.element.name == spec.name &&
        acceptedSpec.element.library.uri == spec.library.uri;
  }

  List<WidgetCallTypeParam> _extractTargetTypeParams(
    ConstructorElement constructor, {
    required LibraryElement library,
  }) {
    return [
      for (final typeParameter in constructor.enclosingElement.typeParameters)
        _callTypeParam(typeParameter, library: library),
    ];
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

  /// Resolves the executable whose parameters define the generated widget's
  /// `call()`-facing surface.
  ///
  /// The common path is the styler's own resolvable `call()` method. When the
  /// factory returns a Styler that `@MixableSpec` generates in the *same*
  /// build, that Styler is invisible to the resolver — its declaration only
  /// exists in the combined `.g.dart` part emitted after this generator runs —
  /// so [stylerType] resolves to `InvalidType`. In that case the widget's call
  /// surface is exactly the `@MixableSpec(target:)` constructor that
  /// `SpecStylerGenerator` turns into `<Styler>.call()`, derived here from the
  /// same source so generation stays single-pass.
  _CallSource _resolveCallSource({
    required Element anchor,
    required DartType stylerType,
    required String? writtenStylerName,
    required LibraryElement library,
  }) {
    if (stylerType is InterfaceType &&
        findSupertypeMatching(stylerType, styleChecker) != null) {
      return _CallSource(
        call: _requireCallMethod(anchor, stylerType, library: library),
        baseExcluded: const {},
        isGenerated: false,
      );
    }

    final target = _generatedStylerTargetConstructor(
      anchor,
      stylerType,
      writtenStylerName,
      library,
    );
    if (target != null) {
      return _CallSource(
        call: target,
        baseExcluded: stylerBackedTargetParams,
        isGenerated: true,
      );
    }

    // No same-build generated Styler matched: surface the original diagnostic
    // (`InvalidType` / `does not extend Style<S>`) unchanged.
    _rejectNonStylerType(anchor, stylerType);
  }

  /// Returns the `@MixableSpec(target:)` constructor backing a same-build
  /// generated Styler named [writtenStylerName], or `null` when the factory
  /// return type is not an unresolved same-library generated Styler.
  ConstructorElement? _generatedStylerTargetConstructor(
    Element anchor,
    DartType stylerType,
    String? writtenStylerName,
    LibraryElement library,
  ) {
    // A resolvable interface is a real (mis)typed styler, not a generated one.
    if (stylerType is InterfaceType || writtenStylerName == null) return null;

    final specElement = _findGeneratedStylerSpec(library, writtenStylerName);
    if (specElement == null) return null;

    final specName = specElement.name!;
    final annotationObject = mixableSpecAnnotationChecker.firstAnnotationOf(
      specElement,
    );
    if (annotationObject == null) return null;

    final target = ConstantReader(annotationObject).peek('target');
    if (target == null || target.isNull) {
      fail(
        anchor,
        '$_annotationLabel factory returns the same-build generated styler '
        '`$writtenStylerName`, but `@MixableSpec` on `$specName` declares no '
        '`target:`, so the generated styler has no `call()` to drive the '
        'widget.',
        todo:
            'Add `@MixableSpec(target: YourWidget.new)` to `$specName`, or '
            'return a styler that declares a `call()` method.',
      );
    }

    final constructor = mixableSpecTargetTearOff(target, specElement);

    validateMixableSpecTargetConstructor(
      constructor: constructor,
      widgetName: mixableSpecTargetWidgetName(constructor),
      specElement: specElement,
      specName: specName,
      anchor: anchor,
    );

    return constructor;
  }

  /// Finds the `@MixableSpec` class in [library] whose conventional Styler
  /// name equals [stylerName] (e.g. `ButtonSpec` -> `ButtonStyler`).
  ///
  /// Mirrors how `SpecStylerGenerator` links nested specs to their generated
  /// stylers by name convention, because same-build generated stylers cannot
  /// be resolved while a generator runs.
  ClassElement? _findGeneratedStylerSpec(
    LibraryElement library,
    String stylerName,
  ) {
    for (final classElement in library.classes) {
      final name = classElement.name;
      if (name == null || deriveStylerName(name) != stylerName) continue;
      if (mixableSpecAnnotationChecker.firstAnnotationOf(classElement) ==
          null) {
        continue;
      }

      return classElement;
    }

    return null;
  }

  /// Rejects a factory type that is neither a resolvable `Style<S>` subtype
  /// nor a same-build generated Styler, with the diagnostic matched to why.
  Never _rejectNonStylerType(Element anchor, DartType type) {
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

    fail(
      anchor,
      '$_annotationLabel target must resolve to a Style<S> subtype, but '
      '`${type.getDisplayString()}` does not extend Style<S>.',
      todo:
          'Use a styler that extends `Style<YourSpec>` (e.g. `BoxStyler`, '
          '`TextStyler`).',
    );
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
  _WidgetParameterSelection _parameterSelectionFor(
    ConstantReader annotation,
    String fieldName,
  ) {
    final selection = annotation.peek(fieldName);
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
    ExecutableElement callMethod, {
    required Element anchor,
    required LibraryElement library,
    required String factoryReference,
    required _WidgetParameterSelection widgetParameters,
    Set<String> baseExcluded = const {},
  }) {
    // [baseExcluded] names never surface as widget parameters (a generated
    // styler's `style`/`styleSpec`); they are filtered out before curation,
    // required-parameter, and optional-positional validation.
    final excludedNames = <String>{};

    if (!widgetParameters.includesAll) {
      final availableNames = {
        for (final parameter in callMethod.formalParameters)
          if (parameter.name case final String name
              when !baseExcluded.contains(name))
            name,
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
            baseExcluded.contains(name) ||
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
            (!excludedNames.contains(parameter.name) &&
                !baseExcluded.contains(parameter.name)))
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
      excludeNames: {...excludedNames, ...baseExcluded},
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
    ExecutableElement callMethod, {
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
    required _WidgetParameterSelection factoryParameters,
  }) {
    final selectedParameters = <FormalParameterElement>[];
    final availableNames = {
      for (final parameter in function.formalParameters)
        if (parameter.name case final String name) name,
    };

    if (!factoryParameters.includesAll) {
      for (final name in factoryParameters.names) {
        if (!availableNames.contains(name)) {
          fail(
            function,
            '$_annotationLabel factoryParameters selects unknown factory '
            'parameter `$name`.',
            todo: 'Select a parameter declared by the recipe factory.',
          );
        }
      }
    }

    for (final parameter in function.formalParameters) {
      final name = parameter.name;
      final selected =
          factoryParameters.includesAll ||
          (name != null && factoryParameters.names.contains(name));
      if (!selected) {
        if (parameter.isRequired) {
          fail(
            function,
            '$_annotationLabel factoryParameters must include required '
            'factory parameter `$name`.',
            todo:
                'Add `$name` to `factoryParameters: .only({...})` or use '
                '`factoryParameters: .all()`.',
          );
        }
        continue;
      }
      selectedParameters.add(parameter);
    }

    final optionalPositional = optionalPositionalNames(selectedParameters);
    if (optionalPositional.isNotEmpty) {
      fail(
        function,
        '$_annotationLabel does not support optional positional factory '
        'parameters: [${optionalPositional.join(', ')}].',
        todo: 'Convert these parameters to required positional or named.',
      );
    }

    final params = <WidgetCallParam>[];
    for (final p in selectedParameters) {
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

  void _validateDirectTargetCollisions(
    Element anchor,
    List<WidgetCallParam> factoryParams,
    List<WidgetCallParam> targetParams,
  ) {
    final factoryByName = {
      for (final parameter in factoryParams) parameter.name: parameter,
    };
    for (final targetParam in targetParams) {
      final factoryParam = factoryByName[targetParam.name];
      if (factoryParam == null) continue;
      if (factoryParam.typeCode == targetParam.typeCode) continue;

      fail(
        anchor,
        '$_annotationLabel shared factory/target parameter '
        '`${targetParam.name}` has incompatible types '
        '`${factoryParam.typeCode}` and `${targetParam.typeCode}`.',
        todo:
            'Use matching types, or exclude the parameter from either '
            '`factoryParameters` or `widgetParameters`.',
      );
    }
  }

  void _requireUnprefixedFlutterSymbols(
    Element anchor,
    ExecutableElement callMethod,
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

  /// The syntactic return/variable type name of the annotated factory, read
  /// from the AST.
  ///
  /// A same-build generated Styler resolves to `InvalidType`, so its element
  /// type carries no usable name; the written annotation still does. Returns
  /// `null` when there is no explicit unprefixed type annotation (an inferred
  /// variable, or a prefixed cross-library reference this pass cannot derive).
  Future<String?> _writtenStylerTypeName(
    Element element,
    BuildStep buildStep,
  ) async {
    final node = await buildStep.resolver.astNodeFor(
      element.firstFragment,
      resolve: false,
    );

    TypeAnnotation? annotationType;
    if (node is FunctionDeclaration) {
      annotationType = node.returnType;
    } else if (node is VariableDeclaration) {
      final declarationList = node.parent;
      if (declarationList is VariableDeclarationList) {
        annotationType = declarationList.type;
      }
    }

    if (annotationType is! NamedType || annotationType.importPrefix != null) {
      return null;
    }

    return annotationType.name.lexeme;
  }

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final widgetParameters = _parameterSelectionFor(
      annotation,
      'widgetParameters',
    );
    final factoryParameters = _parameterSelectionFor(
      annotation,
      'factoryParameters',
    );
    final targetConstructor = _targetConstructorFor(element, annotation);
    final writtenStylerName = await _writtenStylerTypeName(element, buildStep);
    final model = switch (element) {
      TopLevelVariableElement v => _modelForVariable(
        v,
        annotation,
        widgetParameters,
        targetConstructor,
        writtenStylerName,
      ),
      TopLevelFunctionElement f => _modelForFunction(
        f,
        annotation,
        widgetParameters,
        factoryParameters,
        targetConstructor,
        writtenStylerName,
      ),
      _ => fail(
        element,
        '$_annotationLabel can only be applied to top-level variables or '
        'top-level functions.',
      ),
    };

    return MixWidgetBuilder(model).build();
  }

  ConstructorElement? _targetConstructorFor(
    Element anchor,
    ConstantReader annotation,
  ) {
    final target = annotation.peek('target');
    if (target == null || target.isNull) return null;

    final constructor = target.objectValue.toFunctionValue();
    if (constructor is! ConstructorElement) {
      fail(
        anchor,
        '$_annotationLabel(target:) must be a constructor tear-off '
        '(e.g., RemixButton.new).',
      );
    }
    return constructor;
  }
}

/// The executable whose parameters define a generated widget's `call()`
/// surface, plus how to interpret them.
class _CallSource {
  /// The styler `call()` method, or the `@MixableSpec(target:)` constructor
  /// when the factory returns a same-build generated Styler.
  final ExecutableElement call;

  /// Parameter names that never surface on the widget (a generated styler's
  /// `style`/`styleSpec`).
  final Set<String> baseExcluded;

  /// Whether [call] is a generated styler's target constructor rather than a
  /// resolvable `call()` method.
  final bool isGenerated;

  /// Plain widget type rendered directly instead of invoking Styler.call().
  final String? targetTypeReference;

  /// Named constructor on [targetTypeReference], or `null` for `.new`.
  final String? targetConstructorName;

  const _CallSource({
    required this.call,
    required this.baseExcluded,
    required this.isGenerated,
    this.targetTypeReference,
    this.targetConstructorName,
  });
}
