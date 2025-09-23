import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../type_registry.dart';
import '../utils/annotation_utils.dart';
import '../utils/constructor_utils.dart';
import '../utils/dart_type_utils.dart';
import '../utils/extensions.dart';

/// Stores utility metadata for a field
class FieldUtilityMetadata {
  final String name;
  final String type;

  const FieldUtilityMetadata({required this.name, required this.type});
}

/// Stores resolvable type metadata for a field
class FieldResolvableMetadata {
  final String name;
  final String type;
  final bool tryToMergeType;

  const FieldResolvableMetadata({
    required this.name,
    required this.type,
    required this.tryToMergeType,
  });
}

/// Represents utility property mapping for code generation
class UtilityProperty {
  final String name;
  final String path;
  final String? utilityName;

  const UtilityProperty({
    required this.name,
    required this.path,
    required this.utilityName,
  });
}

/// Represents metadata about a field or property for code generation.
class FieldMetadata {
  /// The name of the field
  final String name;

  /// The Dart type of the field
  final DartType dartType;

  /// The annotation associated with this field
  final MixableField annotation;

  /// Documentation comment for the field, if any
  final String? documentationComment;

  /// Whether the field is marked as deprecated
  final bool hasDeprecated;

  /// Whether the field is nullable
  final bool nullable;

  /// Resolved type metadata for this field (if applicable)
  final FieldResolvableMetadata? resolvable;

  /// Utility metadata for this field (if applicable)
  final FieldUtilityMetadata? utility;

  /// Creates a new [FieldMetadata] instance
  const FieldMetadata({
    required this.name,
    required this.dartType,
    required this.annotation,
    this.documentationComment,
    required this.hasDeprecated,
    required this.nullable,
    required this.resolvable,
    required this.utility,
  });

  /// Creates a [FieldMetadata] from a class field
  factory FieldMetadata.fromField(FieldElement element) {
    final annotation = readMixableField(element);
    final utilityAnnotation = readMixableFieldUtility(element);

    // Use the DTO from the MixableField annotation
    // This is more correct as the DTO is a property of the MixableField annotation
    final resolvableAnnotation = annotation.dto;

    return FieldMetadata(
      name: element.name,
      dartType: element.type,
      annotation: annotation,
      documentationComment: element.documentationComment,
      hasDeprecated: element.hasDeprecated,
      nullable: element.type.nullabilitySuffix == NullabilitySuffix.question,
      resolvable: createFieldResolvableMetadata(
        name: element.name,
        dartType: element.type,
        propertyAnnotation: resolvableAnnotation,
      ),
      utility: createFieldUtilityMetadata(
        name: element.name,
        dartType: element.type,
        utilityAnnotation: utilityAnnotation,
      ),
    );
  }

  /// Creates a [FieldMetadata] from a property accessor (getter)
  factory FieldMetadata.fromPropertyAccessor(PropertyAccessorElement element) {
    final annotation = readMixableField(element);
    final utilityAnnotation = readMixableFieldUtility(element);

    // Use the DTO from the MixableField annotation
    // This is more correct as the DTO is a property of the MixableField annotation
    final resolvableAnnotation = annotation.dto;

    return FieldMetadata(
      name: element.name,
      dartType: element.returnType,
      annotation: annotation,
      documentationComment: element.documentationComment,
      hasDeprecated: element.hasDeprecated,
      nullable:
          element.returnType.nullabilitySuffix == NullabilitySuffix.question,
      resolvable: createFieldResolvableMetadata(
        name: element.name,
        dartType: element.returnType,
        propertyAnnotation: resolvableAnnotation,
      ),
      utility: createFieldUtilityMetadata(
        name: element.name,
        dartType: element.returnType,
        utilityAnnotation: utilityAnnotation,
      ),
    );
  }

  /// Gets the field type as a string (without nullability marker)
  String get type => dartType.getTypeAsString();

  /// Gets the field type with nullability marker
  String get typeWithNullability => '$type${nullable ? '?' : ''}';

  /// Checks if the field type is a List
  bool get isListType => dartType.isList;

  bool get isDtoListType => isListType && isResolvable;

  /// Checks if the field type is a Map
  bool get isMapType => dartType.isMap;

  /// Checks if the field type is a Set
  bool get isSetType => dartType.isSet;

  bool get isSpec => TypeUtils.isSpec(dartType);

  bool get isResolvable => TypeUtils.isResolvable(dartType);

  /// Gets the utility name for this field, using pre-computed value when available
  String get utilityName {
    if (utility != null) return utility!.type;

    // Fallback to computing
    final utilities = annotation.utilities ?? [];
    if (utilities.isNotEmpty) {
      final firstUtility = utilities.first;
      if (firstUtility.typeAsString != null) {
        return firstUtility.typeAsString!;
      }

      if (firstUtility.alias != null) {
        return firstUtility.alias!;
      }
    }

    return TypeRegistry.instance.getUtilityForType(dartType);
  }

  bool get hasResolvable => resolvable != null;

  /// Gets the internal reference for this field
  String get asInternalRef => '_\$this.$name';

  /// Creates a list of utility properties specified in the annotation
  List<UtilityProperty> get utilityProperties {
    // If we have a pre-computed utility, prioritize that information
    if (utility != null &&
        (annotation.utilities == null || annotation.utilities!.isEmpty)) {
      return [
        UtilityProperty(
          name: utility!.name,
          path: name,
          utilityName: utility!.type,
        ),
      ];
    }

    // Use the utility function from annotation_utils.dart
    return createUtilityProperties(
      name: name,
      utilities: annotation.utilities,
      defaultUtilityName: utilityName,
    );
  }
}

/// Represents metadata about a constructor parameter, extending field metadata.
class ParameterMetadata extends FieldMetadata {
  /// Whether this is a super parameter
  final bool isSuper;

  /// Whether this is a positional parameter
  final bool isPositional;

  /// Whether this parameter is required (named or positional)
  final bool isRequired;

  /// Creates a new [ParameterMetadata] instance
  const ParameterMetadata({
    required super.name,
    required super.dartType,
    required super.annotation,
    super.documentationComment,
    required super.hasDeprecated,
    required super.nullable,
    required super.utility,
    required super.resolvable,
    required this.isSuper,
    required this.isPositional,
    required this.isRequired,
  });

  /// Creates a [ParameterMetadata] from a constructor parameter
  factory ParameterMetadata.fromParameter(ParameterElement parameter) {
    final existingFieldInfo = _getFieldFromParameter(parameter);

    // If we have existing field info, use that as the basis
    if (existingFieldInfo != null) {
      return ParameterMetadata(
        name: parameter.name,
        dartType: parameter.type,
        annotation: existingFieldInfo.annotation,
        documentationComment: existingFieldInfo.documentationComment,
        hasDeprecated: existingFieldInfo.hasDeprecated,
        nullable: existingFieldInfo.nullable,
        utility: existingFieldInfo.utility,
        resolvable: existingFieldInfo.resolvable,
        isSuper: parameter.isSuperFormal,
        isPositional: parameter.isPositional,
        isRequired: parameter.isRequiredNamed || parameter.isRequiredPositional,
      );
    }

    // Otherwise compute from scratch
    final isNullable =
        parameter.type.nullabilitySuffix == NullabilitySuffix.question;
    final annotation = readMixableField(parameter);
    final utilityAnnotation = readMixableFieldUtility(parameter);

    // Use the DTO from the MixableField annotation
    // This is more correct as the DTO is a property of the MixableField annotation
    final resolvableAnnotation = annotation.dto;

    return ParameterMetadata(
      name: parameter.name,
      dartType: parameter.type,
      annotation: annotation,
      documentationComment: null,
      hasDeprecated: parameter.hasDeprecated,
      nullable: isNullable,
      utility: createFieldUtilityMetadata(
        name: parameter.name,
        dartType: parameter.type,
        utilityAnnotation: utilityAnnotation,
      ),
      resolvable: createFieldResolvableMetadata(
        name: parameter.name,
        dartType: parameter.type,
        propertyAnnotation: resolvableAnnotation,
      ),
      isSuper: parameter.isSuperFormal,
      isPositional: parameter.isPositional,
      isRequired: parameter.isRequiredNamed || parameter.isRequiredPositional,
    );
  }

  /// Extracts parameter metadata from a class constructor
  static List<ParameterMetadata> extractFromConstructor(ClassElement element) {
    final targetConstructor = findTargetConstructor(element);

    return targetConstructor.parameters
        .map((param) => ParameterMetadata.fromParameter(param))
        .toList();
  }
}

/// Attempts to get the corresponding field for a constructor parameter
FieldMetadata? _getFieldFromParameter(ParameterElement parameter) {
  final element = parameter.enclosingElement3;
  if (element is! ConstructorElement) return null;

  final classElement = element.enclosingElement3 as ClassElement;

  // Search up the class hierarchy for the field
  ClassElement? current = classElement;
  while (current != null) {
    final field = current.fields
        .firstWhereOrNull((field) => field.name == parameter.name);

    if (field != null) {
      return FieldMetadata.fromField(field);
    }

    // Move up to the superclass
    current = current.supertype?.element as ClassElement?;
  }

  return null;
}
