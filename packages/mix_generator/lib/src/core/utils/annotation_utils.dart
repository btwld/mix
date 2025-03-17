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
    dto: dtoReader != null ? _getMixableDto(dtoReader) : null,
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

  final properties = reader
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

/// Reads the [MixableFieldResolvable] annotation from an element
MixableFieldResolvable? readMixableFieldResolvable(Element element) {
  const checker = TypeChecker.fromRuntime(MixableFieldResolvable);
  final annotation = checker.firstAnnotationOfExact(element);

  if (annotation == null) return null;

  final reader = ConstantReader(annotation);
  final typeString = reader.typeAsString;

  if (typeString == null) return null;

  return MixableFieldResolvable(type: typeString);
}

/// Extracts [MixableFieldResolvable] data from a [ConstantReader]
MixableFieldResolvable? _getMixableDto(ConstantReader reader) {
  final typeString = reader.typeAsString;
  if (typeString == null) return null;

  return MixableFieldResolvable(type: typeString);
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

/// Reads the [MixableResolvable] annotation from a class element
MixableResolvable readMixableResolvable(ClassElement element) {
  const checker = TypeChecker.fromRuntime(MixableResolvable);
  final annotation = checker.firstAnnotationOfExact(element);

  if (annotation == null) {
    throw InvalidGenerationSourceError(
      'No MixableDto annotation found on the class',
      element: element,
    );
  }

  final reader = ConstantReader(annotation);

  return MixableResolvable(
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
  final referenceType = referenceTypeReader != null &&
          !referenceTypeReader.isNull &&
          referenceTypeReader.isType
      ? referenceTypeReader.typeValue
      : null;

  return MixableUtility(methods: methodsValue, referenceType: referenceType);
}

/// Reads the [MixableToken] annotation from a class element
MixableToken readMixableToken(ClassElement element) {
  const checker = TypeChecker.fromRuntime(MixableToken);
  final annotation = checker.firstAnnotationOfExact(element);

  if (annotation == null) {
    throw InvalidGenerationSourceError(
      'No MixableToken annotation found on the class',
      element: element,
    );
  }

  final reader = ConstantReader(annotation);
  final type = reader.read('type').typeValue;

  return MixableToken(
    type,
    namespace: reader.read('namespace').isNull
        ? null
        : reader.read('namespace').stringValue,
    utilityExtension: reader.read('utilityExtension').boolValue,
    contextExtension: reader.read('contextExtension').boolValue,
  );
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
FieldUtilityMetadata? createFieldUtilityMetadata({
  required String name,
  required DartType dartType,
  MixableFieldUtility? utilityAnnotation,
}) {
  final typeRegistry = TypeRegistry.instance;

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
  final utilityTypeName = typeRegistry.getUtilityForType(dartType);
  if (utilityTypeName == null && utilityAnnotation == null) return null;

  // Determine name and type from annotations or defaults
  final utilityName = utilityAnnotation?.alias ?? name;
  String utilityType;

  if (utilityAnnotation?.typeAsString != null) {
    utilityType = utilityAnnotation!.typeAsString!;
  } else if (utilityTypeName != null) {
    utilityType = utilityTypeName;
  } else {
    utilityType = 'DynamicUtility';
  }

  return FieldUtilityMetadata(name: utilityName, type: utilityType);
}

/// Creates resolvable metadata for a field/parameter
FieldResolvableMetadata? createFieldResolvableMetadata({
  required String name,
  required DartType dartType,
  required MixableFieldResolvable? resolvableAnnotation,
}) {
  try {
    final typeRegistry = TypeRegistry.instance;

    // Get resolvable type from registry or annotation
    final registryType = typeRegistry.getResolvableForType(dartType);

    String? resolvableTypeName;
    if (resolvableAnnotation?.type != null) {
      if (resolvableAnnotation!.type is Type) {
        resolvableTypeName = (resolvableAnnotation.type as Type).toString();
      } else if (resolvableAnnotation.type is String) {
        resolvableTypeName = resolvableAnnotation.type as String;
      } else {
        final logger = Logger('AnnotationUtils');
        logger.warning('Resolvable type is not a Type or String');
      }
    } else {
      resolvableTypeName = registryType;
    }

    if (resolvableTypeName == null) return null;

    return FieldResolvableMetadata(
      name: name,
      type: resolvableTypeName,
      tryToMergeType: typeRegistry.hasTryToMerge(resolvableTypeName),
    );
  } catch (e) {
    Logger('AnnotationUtils').warning(
      'Error creating resolvable metadata for $name: $e',
    );

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

    result.add(UtilityProperty(
      name: aliasName,
      path: name,
      utilityName: utilType,
    ));

    // Add nested properties
    for (final nested in util.properties) {
      result.add(UtilityProperty(
        name: nested.alias,
        path: '$aliasName.${nested.path}',
        utilityName: utilType,
      ));
    }
  }

  return result;
}

/// Check if a list is of a specific element type
bool _isListOfType<T>(List<dynamic> list) {
  return list.every((element) => element is T);
}
