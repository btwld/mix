/// MixWidget generator: emits a `StatelessWidget` wrapper for a top-level
/// variable or function that produces a `Style<S>`.
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
    final call = _extractCallParams(callMethod, library: library);

    return MixWidgetModel(
      widgetName: _resolveWidgetName(variable, annotation, variableName),
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

    final factoryParams = _extractFactoryParams(function, library: library);
    final call = _extractCallParams(callMethod, library: library);

    _rejectCollisions(function, factoryParams, call.params);

    return MixWidgetModel(
      widgetName: _resolveWidgetName(function, annotation, functionName),
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
  /// validates the contract: non-generic, returns a Widget, no optional
  /// positional parameters.
  MethodElement _requireCallMethod(
    Element anchor,
    InterfaceType stylerType, {
    required LibraryElement library,
  }) {
    final stylerElement = stylerType.element;
    final call =
        stylerElement.getMethod('call') ??
        stylerElement.lookUpInheritedMethod(
          methodName: 'call',
          library: library,
        );

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

    final optionalPositional = call.formalParameters
        .where((p) => p.isOptionalPositional)
        .toList();
    if (optionalPositional.isNotEmpty) {
      final names = optionalPositional
          .map((p) => p.name ?? '<unnamed>')
          .join(', ');
      fail(
        anchor,
        '$_annotationLabel does not support optional positional `call()` '
        'parameters on $stylerName: [$names].',
        todo: 'Convert these parameters to required positional or named.',
      );
    }

    return call;
  }

  List<MixWidgetParam> _extractFactoryParams(
    TopLevelFunctionElement function, {
    required LibraryElement library,
  }) {
    return function.formalParameters.map((p) {
      return _paramFor(p, library: library, source: .factory_);
    }).toList();
  }

  ({List<MixWidgetParam> params, bool forwardsKey}) _extractCallParams(
    MethodElement callMethod, {
    required LibraryElement library,
  }) {
    var forwardsKey = false;
    final params = <MixWidgetParam>[];

    for (final p in callMethod.formalParameters) {
      if (_isKeyParameter(p)) {
        forwardsKey = true;
        continue;
      }
      params.add(_paramFor(p, library: library, source: .call));
    }

    return (params: params, forwardsKey: forwardsKey);
  }

  /// Identifies the named `Key? key` parameter that gets forwarded via
  /// `super.key` instead of becoming a generated constructor parameter.
  bool _isKeyParameter(FormalParameterElement p) {
    if (p.name != 'key' || !p.isNamed) return false;

    return keyChecker.isExactlyType(p.type);
  }

  MixWidgetParam _paramFor(
    FormalParameterElement parameter, {
    required LibraryElement library,
    required ParamSource source,
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
      source: source,
      defaultValueCode: parameter.defaultValueCode,
    );
  }

  /// Disallows reusing the same name for a factory parameter and a non-`key`
  /// call parameter. Without this check the generated constructor would have
  /// two fields with the same name and fail to compile — the precise error
  /// is more actionable than the resulting Dart compiler diagnostic.
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

  /// Resolves the generated widget name. `@MixWidget(name: 'X')` wins;
  /// otherwise strip a trailing `Style` and PascalCase, preserving leading
  /// underscores for privacy.
  String _resolveWidgetName(
    Element anchor,
    ConstantReader annotation,
    String elementName,
  ) {
    final override = annotation.peek('name')?.stringValue;
    if (override != null && override.isNotEmpty) {
      return override;
    }

    return _deriveWidgetName(anchor, elementName);
  }

  String _deriveWidgetName(Element anchor, String name) {
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
