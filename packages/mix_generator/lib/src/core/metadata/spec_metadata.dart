import 'package:analyzer/dart/element/element.dart';

import '../utils/annotation_utils.dart';
import '../utils/constructor_utils.dart';
import 'base_metadata.dart';
import 'field_metadata.dart';

/// Metadata for Spec classes, extracted from MixableSpec annotations.
class SpecMetadata extends BaseMetadata {
  final int generatedMethods;

  final int generatedComponents;

  /// Whether this is a modifier spec (deprecated - modifiers now extend Modifier class)
  @Deprecated('Modifiers now extend Modifier class directly')
  final bool isModifier;

  const SpecMetadata({
    required super.element,
    required super.name,
    required super.parameters,
    required super.isConst,
    required super.isDiagnosticable,
    required super.constructor,
    required super.isAbstract,
    required this.generatedMethods,
    required this.generatedComponents,
    required this.isModifier,
  });

  /// Creates a SpecMetadata from a class element and its annotation
  static SpecMetadata fromAnnotation(ClassElement element) {
    final mixableSpec = readMixableSpec(element);
    final constructor = findTargetConstructor(element);
    final parameters = ParameterMetadata.extractFromConstructor(element);

    // Check for Modifier base class (modifiers now extend Modifier, not a separate spec)
    bool isModifier = false;
    for (var interface in element.allSupertypes) {
      if (interface.element.name == 'Modifier') {
        isModifier = true;
        break;
      }
    }

    return SpecMetadata(
      element: element,
      name: element.name,
      parameters: parameters,
      isConst: element.unnamedConstructor?.isConst ?? false,
      isDiagnosticable: element.allSupertypes.any(
        (e) => e.element.name == 'Diagnosticable',
      ),
      constructor: constructor,
      isAbstract: element.isAbstract,
      generatedMethods: mixableSpec.methods,
      generatedComponents: mixableSpec.components,
      isModifier: isModifier,
    );
  }

  // All attributes now extend SpecAttribute since modifiers are specs
  String get extendsAttributeOfType => 'SpecAttribute<$name>';

  String get attributeName => '${name}Attribute';

  String get utilityName => '${name}Utility';

  String get tweenName => '${name}Tween';
}
