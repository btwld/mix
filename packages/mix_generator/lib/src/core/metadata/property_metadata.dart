import 'package:analyzer/dart/element/element.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../property/property_method_builder.dart';
import '../utils/constructor_utils.dart';
import '../utils/dart_type_utils.dart';
import 'base_metadata.dart';
import 'field_metadata.dart';

/// Metadata for MixableType classes, extracted from MixableDto annotations.
class MixableTypeMetadata extends BaseMetadata {
  /// Whether to merge lists when merging DTOs
  final bool mergeLists;

  final int generatedComponents;

  /// The resolved value type (from Dto<T>)
  final ClassElement resolvedElement;

  /// The resolved field accessors
  final List<FieldMetadata> resolvableFields;

  /// Default values extracted from the resolved type's constructor
  final Map<String, String?> constructorDefaults;

  /// Whether this type implements HasDefaultValue mixin
  final bool hasDefaultValue;

  const MixableTypeMetadata({
    required super.element,
    required super.name,
    required super.parameters,
    required super.isConst,
    required super.isDiagnosticable,
    required super.constructor,
    required super.isAbstract,
    required this.mergeLists,
    required this.generatedComponents,
    required this.resolvedElement,
    required this.resolvableFields,
    required this.constructorDefaults,
    required this.hasDefaultValue,
  });

  /// Creates a ResolvableMetadata from a class element and its annotation
  static MixableTypeMetadata fromAnnotation(
    ClassElement element,
    MixableType annotation,
  ) {
    final constructor = findTargetConstructor(element);
    final parameters = ParameterMetadata.extractFromConstructor(element);
    final resolvedElement = _getResolvedType(element);

    // Extract constructor defaults from resolved type
    final resolvedConstructor = findTargetConstructor(resolvedElement);
    final constructorDefaults =
        extractConstructorDefaults(resolvedConstructor.parameters);

    // Check if the class has the HasDefaultValue mixin using utility method
    final hasDefaultValue = TypeUtils.hasDefaultValueMixin(element);

    final resolvedFieldsAndAccessors = collectClassMembers(resolvedElement);
    final List<FieldMetadata> resolvedFields = [];

    for (final param in parameters) {
      // Check for field first
      final field = resolvedFieldsAndAccessors.getField(param.name);
      if (field != null) {
        resolvedFields.add(FieldMetadata.fromField(field));
        continue; // Skip accessor check if field exists
      }

      // Check for accessor if no field was found
      final accessor = resolvedFieldsAndAccessors.getAccessor(param.name);
      if (accessor != null) {
        resolvedFields.add(FieldMetadata.fromPropertyAccessor(accessor));
      }
    }

    return MixableTypeMetadata(
      element: element,
      name: element.name,
      parameters: parameters,
      isConst: constructor.isConst,
      isDiagnosticable: element.allSupertypes.any(
        (e) => e.element.name == 'Diagnosticable',
      ),
      constructor: constructor,
      isAbstract: element.isAbstract,
      mergeLists: annotation.mergeLists,
      generatedComponents: annotation.components,
      resolvedElement: resolvedElement,
      resolvableFields: resolvedFields,
      constructorDefaults: constructorDefaults,
      hasDefaultValue: hasDefaultValue,
    );
  }

  /// Extracts the value type from a Dto<Value> class
  static ClassElement _getResolvedType(ClassElement element) {
    final resolvedType = TypeUtils.extractDtoTypeArgument(element);

    if (resolvedType == null) {
      throw Exception('No resolved type found for $element');
    }

    return resolvedType.element as ClassElement;
  }
}
