import 'package:analyzer/dart/element/element.dart';
import 'package:logging/logging.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import '../metadata/base_metadata.dart';
import '../metadata/field_metadata.dart';
import '../metadata/utility_metadata.dart';
import 'constructor_utils.dart';
import 'dart_type_utils.dart';
import 'string_utils.dart';
import 'utility_code_helpers.dart';

/// Responsible for generating all utility code
class UtilityCodeGenerator {
  static final _logger = Logger('UtilityCodeGenerator');

  const UtilityCodeGenerator._();

  /// Main entry point for utility mixin generation
  static String generateUtilityMixin(UtilityMetadata metadata) {
    try {
      if (metadata.isEnumUtility) {
        return generateEnumUtilityMixin(metadata);
      }

      return generateClassUtilityMixin(metadata);
    } catch (e) {
      _logger.warning('Error generating code for ${metadata.name}: $e');

      return '// Error generating code for ${metadata.name}: $e';
    }
  }

  /// Generates the utility mixin code for an enum utility.
  static String generateEnumUtilityMixin(UtilityMetadata metadata) {
    try {
      final className = metadata.name;
      final generatedClassName = '_\$$className';
      final enumElement = metadata.enumElement!;
      final enumTypeName = enumElement.name;
      final enumValues = metadata.enumValues;

      final callMethod = metadata.generatedMethods.hasFlag(
        GeneratedUtilityMethods.callMethod,
      )
          ? '''
  /// Creates an [Attribute] instance with the specified $enumTypeName value.
  T call($enumTypeName value) => builder(value);
  '''
          : '';

      final enumMethods = enumValues.map((value) {
        return '''
  /// Creates an [Attribute] instance with [$enumTypeName.$value] value.
  T $value() => builder($enumTypeName.$value);
  ''';
      }).join('\n');

      final comments = generateDocTemplate(className, enumTypeName);

      return '''
$comments
mixin $generatedClassName<T extends Attribute> on MixUtility<T, $enumTypeName> {
$callMethod
$enumMethods
}
''';
    } catch (e) {
      _logger.warning('Error generating code for ${metadata.name}: $e');

      return '// Error generating code for ${metadata.name}: $e';
    }
  }

  /// Generates the utility mixin code for a class utility.
  static String generateClassUtilityMixin(UtilityMetadata metadata) {
    try {
      // Extract basic information from metadata
      final className = metadata.name;
      final generatedClassName = '_\$$className';
      final valueElement = metadata.valueElement;

      if (valueElement == null) {
        throw InvalidGenerationSourceError(
          'The class must extend MixUtility<Attribute, ValueType>',
          element: metadata.element,
        );
      }

      final valueName = valueElement.name;
      final shouldGenerateCallMethod = metadata.generatedMethods.hasFlag(
        GeneratedUtilityMethods.callMethod,
      );

      // Determine which elements to use for fields and constructors
      final elementInfo = _getElementInfo(metadata);

      // Generate field statements for static fields
      final fieldStatements = _generateStaticFieldStatements(
        elementInfo.fieldElement,
        valueElement,
        metadata.referenceElement,
      );

      // Generate call method
      final callMethod = shouldGenerateCallMethod
          ? '''
  /// Creates an [Attribute] instance with the specified $valueName value.
  T call($valueName value) => builder(value);
  '''
          : '';

      // Generate constructor statements
      final constructorStatements = _generateConstructorStatements(
        elementInfo.constructorElement,
        elementInfo.mappingElement,
        shouldGenerateCallMethod,
      );

      // Generate documentation
      final comments = generateDocTemplate(className, valueName);

      // Combine everything into the final mixin
      return '''
$comments
mixin $generatedClassName<T extends Attribute> on MixUtility<T, $valueName> {
${fieldStatements.join('\n')}
${constructorStatements.join('\n')}
$callMethod
}
''';
    } catch (e) {
      _logger.warning('Error generating code for ${metadata.name}: $e');

      return '// Error generating code for ${metadata.name}: $e';
    }
  }

  /// Determines which elements to use for fields, constructors, and mapping
  static ElementInfo _getElementInfo(UtilityMetadata metadata) {
    final valueElement = metadata.valueElement!;
    final referenceElement = metadata.referenceElement;
    final mappingElement = metadata.mappingElement;

    // Use reference element for fields if available, otherwise use value element
    final sourceElement = referenceElement ?? valueElement;

    // Use mapping element if available, otherwise use constructor element
    final effectiveMappingElement = mappingElement ?? sourceElement;

    return ElementInfo(
      fieldElement: sourceElement,
      constructorElement: sourceElement,
      mappingElement: effectiveMappingElement,
    );
  }

  /// Validates and filters static fields for utility methods
  static bool _isValidStaticField(
    FieldElement field,
    ClassElement valueElement,
    ClassElement? referenceElement,
  ) {
    // Only use static, public, const fields
    if (!field.isStatic || !field.isPublic || !field.isConst) {
      return false;
    }

    // Check if the field type is assignable to the value type
    final isAssignable =
        TypeUtils.isAssignableTo(field.type, valueElement.thisType) ||
            (referenceElement != null &&
                field.type.element?.name == referenceElement.name);

    return isAssignable;
  }

  /// Generates statements for static fields
  static List<String> _generateStaticFieldStatements(
    ClassElement fieldElement,
    ClassElement valueElement,
    ClassElement? referenceElement,
  ) {
    final fieldStatements = <String>[];

    // Get all static fields that are public and const
    for (var field in fieldElement.fields) {
      if (!_isValidStaticField(field, valueElement, referenceElement)) {
        continue;
      }

      final fieldName = field.name;

      final typeValue = '${fieldElement.name}.$fieldName';

      fieldStatements.add('''
  /// Creates an [Attribute] instance with [$typeValue] value.
  T $fieldName() => builder($typeValue);''');
    }

    return fieldStatements;
  }

  /// Generates statements for constructors
  static List<String> _generateConstructorStatements(
    ClassElement constructorElement,
    ClassElement mappingElement,
    bool shouldGenerateCallMethod,
  ) {
    final constructorStatements = <String>[];

    // Get all constructors that are public
    for (var constructor in constructorElement.constructors) {
      if (!constructor.isPublic) {
        continue;
      }

      // Skip unnamed constructors if we have a call method
      if (constructor.name.isEmpty && shouldGenerateCallMethod) {
        continue;
      }

      final statement = generateUtilityForConstructor(
        constructor,
        skipCallMethod: shouldGenerateCallMethod,
        mappedEl: mappingElement,
      );

      if (statement.isNotEmpty) {
        constructorStatements.add(statement);
      }
    }

    return constructorStatements;
  }

  /// Generates a documentation template for a utility class
  static String generateDocTemplate(String className, String typeName) {
    // Use the StringUtils extension method for snake_case conversion
    final snakeCase = className.snakeCase;

    return '''
/// {@template $snakeCase}
/// A utility class for creating [Attribute] instances from [$typeName] values.
///
/// This class extends [MixUtility] and provides methods to create [Attribute] instances
/// from predefined [$typeName] values.
/// {@endtemplate}''';
  }

  /// Generates the utility statements for public consts
  /// static methods of `mappingElement` in the context
  ///
  /// For example:
  /// T staticValue() => builder(ClassElement.staticValue);
  static String generateUtilityFieldsFromClass(ClassElement classElement) {
    final fieldStatements = <String>[];

    final constructors = classElement.constructors.where(isValidConstructor);

    for (var constructor in constructors) {
      final utilityConstructor = generateUtilityForConstructor(
        constructor,
        skipCallMethod: true,
      );
      if (utilityConstructor.isNotEmpty) {
        fieldStatements.add(utilityConstructor);
      }
    }

    return fieldStatements.join('\n');
  }

  /// Generates a utility method for a constructor
  static String generateUtilityForConstructor(
    ConstructorElement constructor, {
    bool skipCallMethod = false,
    ClassElement? mappedEl,
  }) {
    final isConst = constructor.isConst;
    final isUnamed = constructor.name.isEmpty;

    mappedEl ??= constructor.enclosingElement3 as ClassElement;

    if (isUnamed && skipCallMethod) return '';

    // Check if all parameter types are available
    if (!TypeUtils.areAllParameterTypesAvailable(constructor.parameters)) {
      return ''; // Skip this constructor if any parameter type is not available
    }

    final name = constructor.name.isEmpty ? '' : '.${constructor.name}';
    final methodName = constructor.name.isEmpty ? 'call' : constructor.name;
    final type = mappedEl.name;

    final parameters = constructor.parameters;
    final parameterInfo = _processConstructorParameters(parameters);

    final constStatement = isConst && parameters.isEmpty ? 'const' : '';

    final signature = 'T $methodName(${parameterInfo.signature})';
    final invocation =
        'builder($constStatement $type$name(${parameterInfo.invocation}))';

    final totalCharacters = signature.length + invocation.length;
    String signatureLine;

    if (totalCharacters > 80) {
      signatureLine = '$signature { return $invocation;} ';
    } else {
      signatureLine = '$signature => $invocation;';
    }

    return '''
/// Creates an [Attribute] instance using the [$type$name] constructor.
$signatureLine
''';
  }

  /// Processes constructor parameters and returns signature and invocation strings
  static ParameterInfo _processConstructorParameters(
    List<ParameterElement> parameters,
  ) {
    final signatureRequiredParams = <String>[];
    final invocationRequiredParams = <String>[];
    final signatureOptionalParams = <String>[];
    final invocationOptionalParams = <String>[];
    final signatureNamedParams = <String>[];
    final invocationNamedParams = <String>[];

    for (var param in parameters) {
      final paramName = param.name;
      final paramType = param.type.getDisplayString(withNullability: true);
      final defaultValue =
          param.defaultValueCode != null ? ' = ${param.defaultValueCode}' : '';

      if (param.isPositional) {
        if (param.isRequiredPositional) {
          signatureRequiredParams.add('$paramType $paramName$defaultValue');
          invocationRequiredParams.add(paramName);
        } else {
          signatureOptionalParams.add('$paramType $paramName$defaultValue');
          invocationOptionalParams.add(paramName);
        }
      } else if (param.isNamed) {
        final requiredParam = param.isRequiredNamed ? 'required ' : '';
        signatureNamedParams
            .add('$requiredParam$paramType $paramName$defaultValue');
        invocationNamedParams.add('$paramName: $paramName');
      }
    }

    final signatureParams = [
      ...signatureRequiredParams,
      if (signatureOptionalParams.isNotEmpty)
        '[${signatureOptionalParams.join(', ')}]',
      if (signatureNamedParams.isNotEmpty)
        '{${signatureNamedParams.join(', ')}}',
    ].join(', ');

    final invocationParams = [
      ...invocationRequiredParams,
      if (invocationOptionalParams.isNotEmpty)
        invocationOptionalParams.join(', '),
      if (invocationNamedParams.isNotEmpty) invocationNamedParams.join(', '),
    ].join(', ');

    return ParameterInfo(
      signature: signatureParams,
      invocation: invocationParams,
    );
  }

  /// Generates utility fields for the given attribute class and fields.
  static List<String> generateUtilityFields(
    String className,
    List<FieldMetadata> fields,
  ) {
    final expressions = <String>[];

    for (final field in fields) {
      final propertyName = field.name;
      final utilityProps = field.utilityProperties;

      for (final prop in utilityProps) {
        if (prop.path == propertyName) {
          // Top-level utility (main field or with an alias)
          final utilityName =
              prop.utilityName ?? 'GenericUtility<T, ${field.type}>';
          final utilityExpression =
              '$utilityName((v) => only($propertyName: v))';

          expressions.add(generateUtilityField(
            docPath: '$className.$propertyName',
            aliasName: prop.name,
            utilityExpression: utilityExpression,
          ));
        } else {
          // Nested utility
          expressions.add(generateUtilityField(
            docPath: '$className.${prop.path}',
            aliasName: prop.name,
            utilityExpression: prop.path,
          ));
        }
      }
    }

    return expressions;
  }

  /// Generates a utility field string based on the provided parameters.
  static String generateUtilityField({
    required String docPath,
    required String aliasName,
    required String utilityExpression,
  }) {
    return '''
/// Utility for defining [$docPath]
late final $aliasName = $utilityExpression;
''';
  }

  /// Generates the 'only' method for a utility class
  static String methodOnly({
    required String utilityType,
    required List<FieldMetadata> fields,
  }) {
    if (fields.isEmpty) {
      return '''
  /// Returns a new [$utilityType] with the specified properties.
  @override
  T only() {
    return builder($utilityType());
  }
''';
    }

    final fieldStatements = fields.map((e) {
      final fieldName = e.name;

      return '$fieldName: $fieldName,';
    }).join('\n      ');

    final optionalParameters = fields.map((e) {
      final fieldType = e.resolvable?.type ?? e.type;

      return '$fieldType? ${e.name},';
    }).join('\n    ');

    return '''
  /// Returns a new [$utilityType] with the specified properties.
  @override
  T only({
    $optionalParameters
  }) {
    return builder($utilityType(
      $fieldStatements
    ));
  }
''';
  }

  /// Creates a getter to enable chained configuration.
  static String chainGetter(String utilityName) {
    return '''
  @Deprecated(
    'Use "this" instead of "chain" for method chaining. '
    'The chain getter will be removed in a future version.',
  )
  $utilityName<T> get chain => $utilityName(attributeBuilder);
''';
  }

  /// Creates a static getter that returns the self utility.
  static String selfGetter(String utilityName, String attributeName) {
    return '''
  static $utilityName<$attributeName> get self => $utilityName((v) => v);
''';
  }

  /// Generates a call method for a utility class
  static String methodCall(List<FieldMetadata> fields) {
    if (fields.isEmpty) {
      return '';
    }

    final optionalParameters = fields.map((field) {
      final fieldType = TypeUtils.getResolvedTypeFromDto(field.dartType);

      return '$fieldType? ${field.name},';
    }).join('\n  ');

    final fieldStatements = fields.map((field) {
      final fieldName = field.name;

      if (field.isDtoListType) {
        return '$fieldName: $fieldName?.map((e) => e.toDto()).toList(),';
      }

      if (field.hasResolvable) {
        return '$fieldName: $fieldName?.toDto(),';
      }

      return '$fieldName: $fieldName,';
    }).join('\n    ');

    return '''
  T call({
  $optionalParameters
  }) {
    return only(
    $fieldStatements
    );
  }
''';
  }
}
