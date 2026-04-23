import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/builders/mix_widget_builder.dart';
import 'core/models/mix_widget_param_model.dart';

class MixWidgetGenerator extends GeneratorForAnnotation<MixWidget> {
  const MixWidgetGenerator();

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final widgetName = annotation.read('name').stringValue;
    final stylable = annotation.peek('stylable')?.boolValue ?? false;

    if (element is TopLevelVariableElement) {
      return _generateForVariable(
        element: element,
        widgetName: widgetName,
        stylable: stylable,
      );
    }
    if (element is TopLevelFunctionElement) {
      return _generateForFunction(
        element: element,
        widgetName: widgetName,
        stylable: stylable,
      );
    }
    throw InvalidGenerationSource(
      '@MixWidget can only be applied to top-level variables or functions.',
      element: element,
    );
  }

  String _generateForVariable({
    required TopLevelVariableElement element,
    required String widgetName,
    required bool stylable,
  }) {
    final sourceName = element.name!;
    final stylerType = element.type;
    final stylerClass = _resolveStyleClass(stylerType, element);

    final callMethod = _findCall(stylerClass, element);
    final (callParams, callHasPositional) = _convertCallParams(callMethod);

    return MixWidgetBuilder(
      widgetName: widgetName,
      sourceKind: MixWidgetSourceKind.variable,
      sourceName: sourceName,
      sourceParams: const <MixWidgetParam>[],
      callParams: callParams,
      callHasPositional: callHasPositional,
      stylable: stylable,
      stylerTypeDisplay: stylerType.getDisplayString(),
    ).build();
  }

  String _generateForFunction({
    required TopLevelFunctionElement element,
    required String widgetName,
    required bool stylable,
  }) {
    final sourceName = element.name!;
    final returnType = element.returnType;
    final stylerClass = _resolveStyleClass(returnType, element);
    final callMethod = _findCall(stylerClass, element);
    final (callParams, callHasPositional) = _convertCallParams(callMethod);

    final sourceParams = element.formalParameters
        .map(_convertFormalParam)
        .toList(growable: false);

    if (stylable && sourceParams.any((p) => p.name == 'style')) {
      throw InvalidGenerationSource(
        '@MixWidget(stylable: true) reserves the `style` parameter name.',
        element: element,
      );
    }

    return MixWidgetBuilder(
      widgetName: widgetName,
      sourceKind: MixWidgetSourceKind.function,
      sourceName: sourceName,
      sourceParams: sourceParams,
      callParams: callParams,
      callHasPositional: callHasPositional,
      stylable: stylable,
      stylerTypeDisplay: returnType.getDisplayString(),
    ).build();
  }

  InterfaceElement _resolveStyleClass(DartType type, Element element) {
    if (type is! InterfaceType) {
      throw InvalidGenerationSource(
        '@MixWidget target must resolve to a Style<T> subtype.',
        element: element,
      );
    }
    InterfaceType? current = type;
    while (current != null) {
      if (current.element.name == 'Style') {
        return type.element;
      }
      current = current.superclass;
    }
    throw InvalidGenerationSource(
      '@MixWidget target must resolve to a Style<T> subtype.',
      element: element,
    );
  }

  MethodElement _findCall(InterfaceElement styler, Element annotated) {
    for (final m in styler.methods) {
      if (m.name == 'call') return m;
    }
    throw InvalidGenerationSource(
      '@MixWidget Styler ${styler.name} must declare a `call(...)` method.',
      element: annotated,
    );
  }

  (List<MixWidgetParam>, bool) _convertCallParams(MethodElement m) {
    final params = m.formalParameters.map(_convertFormalParam).toList();
    final hasPositional = params.any((p) => p.isPositional);
    return (params, hasPositional);
  }

  MixWidgetParam _convertFormalParam(FormalParameterElement p) {
    final typeStr = p.type.getDisplayString();
    final nullable = typeStr.endsWith('?');
    final hasDefault = p.defaultValueCode != null;
    return MixWidgetParam(
      name: p.name!,
      typeDisplay: typeStr,
      isPositional: p.isPositional,
      isRequired: !nullable && !hasDefault && !p.isOptional,
      defaultValueCode: p.defaultValueCode,
    );
  }
}
