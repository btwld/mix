import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:logging/logging.dart';
import 'package:source_gen/source_gen.dart';

import '../utils/annotation_utils.dart';
import '../utils/constructor_utils.dart';
import 'base_metadata.dart';

/// Metadata for utility classes, extracted from MixableUtility annotations.
class UtilityMetadata extends BaseMetadata {
  /// The enum element if this is an enum utility
  final EnumElement? enumElement;

  /// The value element if this is a class utility
  final ClassElement? valueElement;

  /// The mapping element if this is a class utility with a mapping type
  final ClassElement? mappingElement;

  /// The reference element if this is a class utility with a reference type
  final ClassElement? referenceElement;

  final int generatedMethods;

  static final _logger = Logger('UtilityMetadata');

  const UtilityMetadata({
    required super.element,
    required super.name,
    required super.parameters,
    required super.isConst,
    required super.isDiagnosticable,
    required super.constructor,
    required super.isAbstract,
    this.enumElement,
    this.valueElement,
    this.mappingElement,
    this.referenceElement,
    required this.generatedMethods,
  });

  /// Creates a UtilityMetadata from a class element with optional annotation data
  factory UtilityMetadata.create(
    ClassElement element, {
    ConstantReader? annotation,
  }) {
    try {
      // Extract utility type info
      final utilityType = _getUtilityType(element);

      if (utilityType == null) {
        throw InvalidGenerationSourceError(
          'The class must extend MixUtility<Attribute, ValueType>',
          element: element,
        );
      }

      // Parse type information
      EnumElement? enumElement;
      ClassElement? valueElement;

      if (utilityType.element is EnumElement) {
        enumElement = utilityType.element as EnumElement;
      } else if (utilityType.element is ClassElement &&
          utilityType.element is! EnumElement) {
        valueElement = utilityType.element as ClassElement;
      }

      // Initialize annotation-specific fields
      ClassElement? mappingElement;
      ClassElement? referenceElement;

      // If we have annotation data, extract mapping and reference types
      if (annotation != null) {
        // Handle mapping type
        if (!hasMixableUtility(element)) {
          final mixableUtility = readMixableFieldUtility(element);
          final mappingType = mixableUtility?.type;

          if (mappingType != null) {
            final mappingTypeElement =
                annotation.read('type').typeValue.element;
            if (mappingTypeElement is! ClassElement) {
              throw InvalidGenerationSourceError(
                'The mapping type must be a class',
                element: element,
              );
            }
            mappingElement = mappingTypeElement;
          }
        }

        // Handle reference type - safely check if it's a valid type
        final referenceTypeValue = annotation.peek('referenceType');
        if (referenceTypeValue != null &&
            !referenceTypeValue.isNull &&
            referenceTypeValue.isType) {
          final referenceTypeElement = referenceTypeValue.typeValue.element;
          if (referenceTypeElement is ClassElement) {
            referenceElement = referenceTypeElement;
          }
        }
      }

      final mixableUtility = readMixableUtility(element);

      return UtilityMetadata(
        element: element,
        name: element.name,
        parameters: [], // Utilities don't have fields
        isConst: element.unnamedConstructor?.isConst ?? false,
        isDiagnosticable: false, // Utilities don't need diagnostics
        constructor: findTargetConstructor(element),
        isAbstract: element.isAbstract,
        enumElement: enumElement,
        valueElement: valueElement,
        mappingElement: mappingElement,
        referenceElement: referenceElement,
        generatedMethods: mixableUtility.methods,
      );
    } catch (e) {
      _logger.warning('Error creating utility metadata: $e');

      if (e is InvalidGenerationSourceError) {
        rethrow;
      }
      // ignore: avoid-throw-in-catch-block
      throw InvalidGenerationSourceError(
        'Error creating utility metadata: $e',
        element: element,
      );
    }
  }

  /// Creates a UtilityMetadata from a class element
  factory UtilityMetadata.fromElement(ClassElement element) {
    return UtilityMetadata.create(element);
  }

  /// Creates a UtilityMetadata from a class element and its annotation
  static UtilityMetadata fromAnnotation(
    ClassElement element,
    ConstantReader annotation,
  ) {
    try {
      return UtilityMetadata.create(element, annotation: annotation);
    } catch (e) {
      _logger.warning('Error creating utility metadata from annotation: $e');

      // Fallback to basic metadata if annotation parsing fails
      return UtilityMetadata.fromElement(element);
    }
  }

  /// Checks if this is an enum utility
  bool get isEnumUtility => enumElement != null;

  /// Gets the enum values as strings if this is an enum utility
  List<String> get enumValues {
    if (!isEnumUtility || enumElement == null) {
      return [];
    }

    return enumElement!.fields
        .where((field) => field.isEnumConstant)
        .map((field) => field.name)
        .toList();
  }

  /// Gets the effective mapping element (either mappingElement or valueElement)
  ClassElement? get effectiveMappingElement {
    if (!isEnumUtility && valueElement != null) {
      return mappingElement ?? valueElement;
    }

    return null;
  }
}

/// Gets the utility type from a class that extends MixUtility
DartType? _getUtilityType(ClassElement element) {
  const utilityTypes = ['MixUtility'];

  for (var supertype in element.allSupertypes) {
    if (utilityTypes.contains(supertype.element.name) &&
        supertype.typeArguments.length == 2) {
      return supertype.typeArguments[1];
    }
  }

  return null;
}
