import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:logging/logging.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import '../metadata/field_metadata.dart';
import '../type_registry.dart';

/// Extension to get typeAsString from a ConstantReader
extension ConstantReaderX on ConstantReader {
  String? get typeAsString {
    final peakedType = peek('type');

    if (peakedType?.isString == true) {
      return peakedType!.stringValue;
    } else if (peakedType?.isType == true) {
      return peakedType!.typeValue.element!.name;
    }

    return null;
  }
}

/// Parse utility properties from annotation reader
MixableUtilityProps parseMixableUtilityProps(ConstantReader reader) {
  final path = reader.read('path').stringValue;
  final alias = reader.read('alias').stringValue;

  return (path: path, alias: alias);
}

/// Reads the [MixableField] annotation from a field element
MixableField readMixableField(Element element) {
  const checker = TypeChecker.fromRuntime(MixableField);
  final annotation = checker.firstAnnotationOf(element);

  if (annotation is! DartObject) {
    return const MixableField();
  }

  final reader = ConstantReader(annotation);
  final dtoReader = reader.peek('dto');

  final utilities = reader
      .peek('utilities')
      ?.listValue
      .map((e) => _readMixableFieldUtility(ConstantReader(e)))
      .toList();

  final isLerpable = reader.peek('isLerpable')?.boolValue ?? true;

  return MixableField(
    dto: dtoReader != null ? _getMixableType(dtoReader) : null,
    utilities: utilities,
    isLerpable: isLerpable,
  );
}

/// Reads the [MixableFieldUtility] annotation from an element
MixableFieldUtility? readMixableFieldUtility(Element element) {
  const checker = TypeChecker.fromRuntime(MixableFieldUtility);
  final annotation = checker.firstAnnotationOfExact(element);

  if (annotation == null) return null;

  return _readMixableFieldUtility(ConstantReader(annotation));
}

/// Reads a [MixableFieldUtility] from a [ConstantReader]
MixableFieldUtility _readMixableFieldUtility(ConstantReader reader) {
  final typeReader = reader.peek('type');
  final utilityName = _getUtilityTypeNameFromReader(typeReader);
  final utilityAlias = reader.peek('alias')?.stringValue;

  final properties =
      reader
          .peek('properties')
          ?.listValue
          .map((e) => parseMixableUtilityProps(ConstantReader(e)))
          .toList() ??
      [];

  return MixableFieldUtility(
    alias: utilityAlias,
    type: utilityName,
    properties: properties,
  );
}

/// Extracts a utility type name from a reader
String? _getUtilityTypeNameFromReader(ConstantReader? typeReader) {
  if (typeReader == null) return null;

  if (typeReader.isString) {
    return typeReader.stringValue;
  } else if (typeReader.isType) {
    final typeName = typeReader.typeValue.element?.name;

    return typeName != null ? _ensureUtilitySuffix(typeName) : null;
  }

  return null;
}

/// Ensures a type name has the 'Utility' suffix
String _ensureUtilitySuffix(String typeName) {
  return typeName.endsWith('Utility') ? typeName : '${typeName}Utility';
}

/// Reads the [MixableFieldType] annotation from an element
MixableFieldType? readMixableFieldType(Element element) {
  const checker = TypeChecker.fromRuntime(MixableFieldType);
  final annotation = checker.firstAnnotationOfExact(element);

  if (annotation == null) return null;

  final reader = ConstantReader(annotation);
  final typeString = reader.typeAsString;

  if (typeString == null) return null;

  return MixableFieldType(type: typeString);
}

/// Extracts [MixableFieldType] data from a [ConstantReader]
MixableFieldType? _getMixableType(ConstantReader reader) {
  final typeString = reader.typeAsString;
  if (typeString == null) return null;

  return MixableFieldType(type: typeString);
}

/// Reads the [MixableSpec] annotation from a class element
MixableSpec readMixableSpec(ClassElement element) {
  const checker = TypeChecker.fromRuntime(MixableSpec);
  final annotation = checker.firstAnnotationOfExact(element);

  if (annotation == null) {
    throw InvalidGenerationSourceError(
      'No MixableSpec annotation found on the class',
      element: element,
    );
  }

  final reader = ConstantReader(annotation);

  return MixableSpec(
    methods: reader.read('methods').intValue,
    components: reader.read('components').intValue,
  );
}

/// Reads the [MixableType] annotation from a class element
MixableType readMixableType(ClassElement element) {
  const checker = TypeChecker.fromRuntime(MixableType);
  final annotation = checker.firstAnnotationOfExact(element);

  if (annotation == null) {
    throw InvalidGenerationSourceError(
      'No MixableType annotation found on the class',
      element: element,
    );
  }

  final reader = ConstantReader(annotation);

  return MixableType(
    components: reader.read('components').intValue,
    mergeLists: reader.read('mergeLists').boolValue,
  );
}

MixableUtility readMixableUtility(ClassElement element) {
  const checker = TypeChecker.fromRuntime(MixableUtility);
  final annotation = checker.firstAnnotationOfExact(element);

  if (annotation == null) return const MixableUtility();

  final reader = ConstantReader(annotation);
  final methodsValue = reader.read('methods').intValue;

  // Safely handle the referenceType field, which might not be a Type
  final referenceTypeReader = reader.peek('referenceType');
  final referenceType =
      referenceTypeReader != null &&
          !referenceTypeReader.isNull &&
          referenceTypeReader.isType
      ? referenceTypeReader.typeValue
      : null;

  return MixableUtility(methods: methodsValue, referenceType: referenceType);
}

/// Checks if a class has the [MixableUtility] annotation
bool hasMixableUtility(ClassElement element) {
  const checker = TypeChecker.fromRuntime(MixableUtility);

  return checker.hasAnnotationOfExact(element);
}

/// Gets all annotations of a specific type from an element
List<DartObject> getAnnotations(Element element, Type annotationType) {
  final checker = TypeChecker.fromRuntime(annotationType);

  return checker.annotationsOf(element).toList();
}

/// Reads the list of [MixableFieldUtility] annotations from a field element
List<MixableFieldUtility>? readMixableFieldUtilities(FieldElement element) {
  final annotations = getAnnotations(element, MixableField);
  if (annotations.isEmpty) return null;

  final reader = ConstantReader(annotations.first);
  final utilities = reader.peek('utilities')?.listValue;

  if (utilities == null || utilities.isEmpty) {
    return null;
  }

  return utilities
      .map((e) => _readMixableFieldUtility(ConstantReader(e)))
      .toList();
}

/// Creates utility metadata for a field/parameter
FieldUtilityMetadata createFieldUtilityMetadata({
  required String name,
  required DartType dartType,
  MixableFieldUtility? utilityAnnotation,
}) {
  // If we have a utility annotation with a type, use that directly
  if (utilityAnnotation?.type != null) {
    final utilityName = utilityAnnotation?.alias ?? name;
    String utilityType;

    if (utilityAnnotation!.typeAsString != null) {
      utilityType = utilityAnnotation.typeAsString!;
    } else {
      final typeObj = utilityAnnotation.type!;
      final typeStr = typeObj.toString();
      utilityType = _ensureUtilitySuffix(typeStr);
    }

    return FieldUtilityMetadata(name: utilityName, type: utilityType);
  }

  // Get utility type from registry

  // Determine name and type from annotations or defaults
  final utilityName = utilityAnnotation?.alias ?? name;
  String utilityType;

  if (utilityAnnotation?.typeAsString != null) {
    utilityType = utilityAnnotation!.typeAsString!;
  } else {
    utilityType = TypeRegistry.instance.getUtilityForType(dartType);
  }

  return FieldUtilityMetadata(name: utilityName, type: utilityType);
}

/// Creates resolvable metadata for a field/parameter
FieldResolvableMetadata? createFieldResolvableMetadata({
  required String name,
  required DartType dartType,
  required MixableFieldType? propertyAnnotation,
}) {
  try {
    final typeRegistry = TypeRegistry.instance;

    // Get resolvable type from registry or annotation

    String? resolvableTypeName;
    if (propertyAnnotation?.type != null) {
      if (propertyAnnotation!.type is Type) {
        resolvableTypeName = (propertyAnnotation.type as Type).toString();
      } else if (propertyAnnotation.type is String) {
        resolvableTypeName = propertyAnnotation.type as String;
      } else {
        final logger = Logger('AnnotationUtils');
        logger.warning('Resolvable type is not a Type or String');
      }
    } else {
      resolvableTypeName = typeRegistry.getResolvableForType(dartType);
    }

    if (resolvableTypeName == null) return null;

    return FieldResolvableMetadata(
      name: name,
      type: resolvableTypeName,
      tryToMergeType: typeRegistry.hasTryToMerge(resolvableTypeName),
    );
  } catch (e) {
    Logger(
      'AnnotationUtils',
    ).warning('Error creating resolvable metadata for $name: $e');

    return null;
  }
}

/// Creates utility properties for a field
List<UtilityProperty> createUtilityProperties({
  required String name,
  required List<MixableFieldUtility>? utilities,
  required String? defaultUtilityName,
}) {
  final result = <UtilityProperty>[];

  if (utilities == null || utilities.isEmpty) {
    return [
      UtilityProperty(name: name, path: name, utilityName: defaultUtilityName),
    ];
  }

  for (final util in utilities) {
    final aliasName = util.alias ?? name;
    final utilType = util.typeAsString ?? defaultUtilityName;

    result.add(
      UtilityProperty(name: aliasName, path: name, utilityName: utilType),
    );

    // Add nested properties
    for (final nested in util.properties) {
      result.add(
        UtilityProperty(
          name: nested.alias,
          path: '$aliasName.${nested.path}',
          utilityName: utilType,
        ),
      );
    }
  }

  return result;
}
