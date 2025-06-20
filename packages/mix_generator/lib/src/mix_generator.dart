// This is the consolidated MixGenerator implementation that replaces the previous approach
// with multiple separate generators and the TypeRegistry.
//
// TODO: The following files still depend on type_registry.dart and need to be updated:
// - lib/src/core/metadata/field_metadata.dart
// - lib/src/core/utils/annotation_utils.dart
// - test files that use TypeRegistry directly
//
// To complete the migration, these files should be modified to use MixGenerator methods
// instead of TypeRegistry directly.

import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:logging/logging.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/dependency_graph.dart';
import 'core/metadata/base_metadata.dart';
import 'core/metadata/property_metadata.dart';
import 'core/metadata/spec_metadata.dart';
import 'core/metadata/tokens_metadata.dart';
import 'core/metadata/utility_metadata.dart';
import 'core/property/property_extension_builder.dart';
import 'core/property/property_mixin_builder.dart';
import 'core/property/property_utility_builder.dart';
import 'core/spec/spec_attribute_builder.dart';
import 'core/spec/spec_mixin_builder.dart';
import 'core/spec/spec_tween_builder.dart';
import 'core/spec/spec_utility_builder.dart';
import 'core/type_registry.dart';
import 'core/utils/annotation_utils.dart';
import 'core/utils/dart_type_utils.dart';
import 'core/utils/extensions.dart';
import 'core/utils/utility_code_generator.dart';
import 'generators/mixable_tokens_generator.dart';

/// A consolidated generator that processes all Mix annotations
/// (MixableSpec, MixableType, MixableUtility, MixableToken)
/// in a single pass with proper dependency handling.
class MixGenerator extends Generator {
  final Logger _logger = Logger('MixGenerator');

  // Type checkers for all annotations
  final TypeChecker _specChecker = const TypeChecker.fromRuntime(MixableSpec);
  final TypeChecker _propertyChecker =
      const TypeChecker.fromRuntime(MixableType);
  final TypeChecker _utilityChecker =
      const TypeChecker.fromRuntime(MixableUtility);
  final TypeChecker _tokensChecker =
      const TypeChecker.fromRuntime(MixableToken);

  // Map to store types discovered during the generation phase
  final Map<String, String> _discoveredTypes = {};

  // Utility methods for collecting elements and creating metadata

  List<ClassElement> _getAnnotatedElements(
    LibraryReader library,
    TypeChecker checker,
  ) {
    // Collect elements with annotations, preserving the order they appear in the file
    return library
        .annotatedWith(checker)
        .map((annotated) => annotated.element)
        .whereType<ClassElement>()
        .toList();
  }

  List<SpecMetadata> _createSpecMetadata(List<ClassElement> elements) {
    return elements.map((element) {
      return SpecMetadata.fromAnnotation(element);
    }).toList();
  }

  List<MixableTypeMetadata> _createPropertyMetadata(
    List<ClassElement> elements,
  ) {
    return elements.map((element) {
      final annotation = readMixableType(element);

      return MixableTypeMetadata.fromAnnotation(element, annotation);
    }).toList();
  }

  List<UtilityMetadata> _createUtilityMetadata(List<ClassElement> elements) {
    return elements.map((element) {
      final reader =
          ConstantReader(_utilityChecker.firstAnnotationOfExact(element));

      return UtilityMetadata.fromAnnotation(element, reader);
    }).toList();
  }

  List<TokensMetadata> _createTokenMetadata(List<ClassElement> elements) {
    return elements.map((element) {
      final annotation = readMixableToken(element);

      return TokensMetadata.fromAnnotation(element, annotation);
    }).toList();
  }

  // Dependency analysis

  DependencyGraph _buildDependencyGraph(
    List<SpecMetadata> specMetadata,
    List<MixableTypeMetadata> propertyMetadata,
    List<UtilityMetadata> utilityMetadata,
    List<TokensMetadata> tokenMetadata,
  ) {
    final graph = DependencyGraph();

    // Add all elements to the graph
    for (final metadata in [
      ...specMetadata,
      ...propertyMetadata,
      ...utilityMetadata,
      ...tokenMetadata,
    ]) {
      graph.addNode(metadata);
    }

    // Add dependencies based on field types
    _addSpecDependencies(graph, specMetadata);
    _addPropertyDependencies(graph, propertyMetadata);
    _addUtilityDependencies(graph, utilityMetadata);
    // Tokens generally don't have dependencies

    return graph;
  }

  void _addSpecDependencies(
    DependencyGraph graph,
    List<SpecMetadata> metadataList,
  ) {
    for (final metadata in metadataList) {
      for (final param in metadata.parameters) {
        if (_isGeneratedType(param.dartType)) {
          // Find the metadata for the dependency
          final dependencyMetadata =
              _findMetadataForType(param.dartType, graph);
          if (dependencyMetadata != null) {
            graph.addDependency(metadata, dependencyMetadata);
          }
        }

        // Handle list types
        if (param.isListType &&
            param.dartType.isList &&
            param.dartType.isDartCoreList) {
          final elementType = TypeUtils.getTypeArguments(param.dartType).first;
          if (_isGeneratedType(elementType)) {
            final dependencyMetadata = _findMetadataForType(elementType, graph);
            if (dependencyMetadata != null) {
              graph.addDependency(metadata, dependencyMetadata);
            }
          }
        }
      }
    }
  }

  void _addPropertyDependencies(
    DependencyGraph graph,
    List<MixableTypeMetadata> metadataList,
  ) {
    // Similar pattern as _addSpecDependencies
    for (final metadata in metadataList) {
      for (final param in metadata.parameters) {
        if (_isGeneratedType(param.dartType)) {
          final dependencyMetadata =
              _findMetadataForType(param.dartType, graph);
          if (dependencyMetadata != null) {
            graph.addDependency(metadata, dependencyMetadata);
          }
        }

        if (param.isListType &&
            param.dartType.isList &&
            param.dartType.isDartCoreList) {
          final elementType = TypeUtils.getTypeArguments(param.dartType).first;
          if (_isGeneratedType(elementType)) {
            final dependencyMetadata = _findMetadataForType(elementType, graph);
            if (dependencyMetadata != null) {
              graph.addDependency(metadata, dependencyMetadata);
            }
          }
        }
      }
    }
  }

  void _addUtilityDependencies(
    DependencyGraph graph,
    List<UtilityMetadata> metadataList,
  ) {
    // Utility dependencies are often based on the value type
    for (final metadata in metadataList) {
      if (metadata.valueElement != null) {
        // Check if the value element is a generated type
        final valueElement = metadata.valueElement!;

        if (_specChecker.hasAnnotationOfExact(valueElement) ||
            _propertyChecker.hasAnnotationOfExact(valueElement)) {
          // Find the metadata for the value element
          BaseMetadata? dependencyMetadata;

          for (final node in graph.getAllNodes()) {
            if ((node is SpecMetadata && node.element == valueElement) ||
                (node is MixableTypeMetadata && node.element == valueElement)) {
              dependencyMetadata = node;
              break;
            }
          }

          if (dependencyMetadata != null) {
            graph.addDependency(metadata, dependencyMetadata);
          }
        }
      }
    }
  }

  bool _isGeneratedType(DartType type) {
    if (type.element is! ClassElement) return false;

    final element = type.element as ClassElement;

    return _specChecker.hasAnnotationOfExact(element) ||
        _propertyChecker.hasAnnotationOfExact(element) ||
        _utilityChecker.hasAnnotationOfExact(element) ||
        _tokensChecker.hasAnnotationOfExact(element);
  }

  BaseMetadata? _findMetadataForType(DartType type, DependencyGraph graph) {
    if (type.element is! ClassElement) return null;

    final element = type.element as ClassElement;
    _logger.info(
      '_findMetadataForType: Looking for metadata for type ${element.name}',
    );

    for (final node in graph.getAllNodes()) {
      if (node.element == element) {
        _logger.info('  Found metadata of type: ${node.runtimeType}');

        return node;
      }
    }

    _logger.info('  No metadata found for type ${element.name}');

    return null;
  }

  List<BaseMetadata> _sortByDependencies(DependencyGraph graph) {
    final sortedNodes = graph.sortTopologically();
    _logger.info('_sortByDependencies: Sorted ${sortedNodes.length} nodes');
    for (var i = 0; i < sortedNodes.length && i < 5; i++) {
      _logger.info(
        '  Node $i: ${sortedNodes[i].runtimeType} - ${sortedNodes[i].name}',
      );
    }
    if (sortedNodes.length > 5) {
      _logger.info('  ... and ${sortedNodes.length - 5} more nodes');
    }

    return sortedNodes;
  }

  // Type registration

  void _registerTypes(List<BaseMetadata> sortedMetadata) {
    final types = <String, String>{};

    // Write debug info to file
    try {
      final debugFile = File('/tmp/mix_generator_debug.txt');
      final debugSink = debugFile.openWrite();

      debugSink.writeln(
        '_registerTypes: Registering types from ${sortedMetadata.length} metadata objects',
      );

      for (final metadata in sortedMetadata) {
        final typeName = metadata.runtimeType.toString();
        final name = metadata.name;
        debugSink.writeln('  Metadata type: $typeName, name: $name');

        if (metadata is SpecMetadata) {
          types['${name}Attribute'] = name;
          types['${name}Utility'] = name;
        } else if (metadata is MixableTypeMetadata) {
          if (name.endsWith('Dto')) {
            final baseName = name.substring(0, name.length - 3);
            types['${baseName}Utility'] = baseName;
          } else {
            types['${name}Utility'] = name;
          }
        } else if (metadata is UtilityMetadata) {
          types[name] = TypeUtils.removeUtilitySuffix(name);
        } else {
          debugSink.writeln('  Unknown metadata type: $typeName');
        }
      }

      debugSink.writeln('  Added ${types.length} types to _discoveredTypes');
      debugSink.close();
    } catch (e) {
      _logger.info('Error writing debug file: $e');
    }

    _discoveredTypes.addAll(types);

    // Add discovered types to the resolvables and utilities maps
    types.forEach((generatedType, baseType) {
      if (generatedType.endsWith('Utility')) {
        // Add to utilities map - Utility types map to their base type
        utilities[generatedType] = baseType;
      } else if (generatedType.endsWith('Attribute')) {
        // Add to resolvables map - Attributes map to their Spec class
        resolvables[generatedType] = baseType;
      } else if (generatedType.endsWith('Dto')) {
        // Add to resolvables map - DTOs map to their Flutter type
        final flutterType = baseType;
        resolvables[generatedType] = flutterType;

        // Also add a utility for this DTO if one doesn't already exist
        final utilityName = '${baseType}Utility';
        if (!utilities.containsKey(utilityName)) {
          utilities[utilityName] = baseType;
        }
      }
    });

    _logger.info(
      'Registered ${types.length} discovered types and updated utility/resolvable maps',
    );
  }

  // Code generation methods

  void _generateSpecCode(SpecMetadata metadata, StringBuffer buffer) {
    // Generate mixin
    final mixinBuilder = SpecMixinBuilder(metadata);
    buffer.writeln(mixinBuilder.build());
    buffer.writeln();

    // Generate attribute class
    if (metadata.generatedComponents
        .hasFlag(GeneratedSpecComponents.attribute)) {
      final attributeBuilder = SpecAttributeBuilder(metadata);
      buffer.writeln(attributeBuilder.build());
      buffer.writeln();
    }

    // Generate utility class
    if (metadata.generatedComponents.hasFlag(GeneratedSpecComponents.utility)) {
      final utilityBuilder = SpecUtilityBuilder(metadata);
      buffer.writeln(utilityBuilder.build());
      buffer.writeln();
    }

    // Generate tween class
    if (metadata.generatedComponents.hasFlag(GeneratedSpecComponents.tween)) {
      final tweenBuilder = SpecTweenBuilder(metadata);
      buffer.writeln(tweenBuilder.build());
      buffer.writeln();
    }
  }

  void _generatePropertyCode(
    MixableTypeMetadata metadata,
    StringBuffer buffer,
  ) {
    // Generate mixin
    final mixinBuilder = MixableTypeMixinBuilder(metadata);
    buffer.writeln(mixinBuilder.build());
    buffer.writeln();

    // Generate utility class
    if (metadata.generatedComponents
        .hasFlag(GeneratedPropertyComponents.utility)) {
      final utilityBuilder = MixableTypeUtilityBuilder(metadata);
      buffer.writeln(utilityBuilder.build());
      buffer.writeln();
    }

    // Generate extension
    if (metadata.generatedComponents
        .hasFlag(GeneratedPropertyComponents.resolvableExtension)) {
      final extensionBuilder = MixableTypeExtensionBuilder(metadata);
      buffer.writeln(extensionBuilder.build());
      buffer.writeln();
    }
  }

  void _generateUtilityCode(UtilityMetadata metadata, StringBuffer buffer) {
    // Use the utility code generator
    final code = UtilityCodeGenerator.generateUtilityMixin(metadata);
    buffer.writeln(code);
    buffer.writeln();
  }

  void _generateTokenCode(TokensMetadata metadata, StringBuffer buffer) {
    // Generate token struct and methods
    // This is a placeholder - the actual implementation would depend on your token generation logic
    buffer.writeln("// Token code for ${metadata.name}");

    buffer.writeln(MixableTokensGenerator.generateTokenCode(metadata));

    // Logic to generate token classes and extensions would go here
    // This would likely involve extracting code from MixableTokensGenerator

    buffer.writeln();
  }

  bool _needsDeprecationIgnore(
    List<SpecMetadata> specMetadata,
    List<MixableTypeMetadata> propertyMetadata,
  ) {
    for (final metadata in specMetadata) {
      if (metadata.parameters.any((field) => field.hasDeprecated)) {
        return true;
      }
    }

    for (final metadata in propertyMetadata) {
      if (metadata.parameters.any((field) => field.hasDeprecated)) {
        return true;
      }
    }

    return false;
  }

  String _getUtilityForListType(DartType type) {
    final elementType = TypeUtils.getTypeArguments(type).first;
    final elementTypeName =
        getResolvableForType(elementType) ?? elementType.getTypeAsString();

    // If it's a DTO, get the corresponding Flutter type
    String? dartType;
    if (TypeUtils.isResolvable(elementType) && elementType.element != null) {
      final dtoName = elementType.element!.name!;
      // Check if the DTO name exists in the resolvables map
      if (resolvables.containsKey(dtoName)) {
        dartType = resolvables[dtoName]!;
      } else {
        _logger.fine('No Flutter type found for DTO: $dtoName');
      }
    }

    // Construct list type strings for both DTO and Flutter types
    final listTypeString = 'List<$elementTypeName>';
    final flutterListTypeString = dartType != null ? 'List<$dartType>' : null;

    // First check for a direct utility mapping for the list type
    for (final entry in utilities.entries) {
      // Check against both DTO and Flutter type list strings
      if (entry.value == listTypeString) {
        return entry.key;
      }

      if (flutterListTypeString != null &&
          entry.value == flutterListTypeString) {
        return entry.key;
      }
    }

    // Default to generic list utility
    return 'ListUtility<T, $elementTypeName>';
  }

  String _extractBaseTypeName(String typeString) {
    final genericIndex = typeString.indexOf('<');
    if (genericIndex > 0) {
      return typeString.substring(0, genericIndex);
    }

    return typeString;
  }

  // Methods replacing TypeRegistry functionality

  String? getResolvableForType(DartType type) {
    final typeString = type.getTypeAsString();

    // Special handling for Spec types
    if (TypeUtils.isSpec(type)) {
      final typeName = typeString;

      return '${typeName}Attribute';
    }

    if (type.isList && type.isDartCoreList) {
      final elementType = TypeUtils.getTypeArguments(type).first;
      final valueType = getResolvableForType(elementType);

      if (valueType == null) {
        return null;
      }

      return 'List<$valueType>';
    }

    // Special handling for DTO types
    if (TypeUtils.isResolvable(type)) {
      return type.element!.name!;
    }

    // Check for a direct DTO mapping
    for (final entry in resolvables.entries) {
      if (entry.value == typeString) {
        return entry.key;
      }
    }

    // Check in discovered types
    final attributeName = '${typeString}Attribute';
    if (_discoveredTypes.containsKey(attributeName)) {
      return attributeName;
    }

    // If no specific representation, return the type itself
    return null;
  }

  String getUtilityForType(DartType type) {
    final typeString = type.getTypeAsString();

    // Special handling for Spec types
    if (TypeUtils.isSpec(type)) {
      return '${typeString}Utility';
    }

    // Handle List types specially
    if (type.isList && type.isDartCoreList) {
      return _getUtilityForListType(type);
    }

    // Special handling for DTO types in test cases and real code
    if (TypeUtils.isResolvable(type)) {
      final dtoName = type.element!.name!;

      // Handle DTOs by removing the Dto suffix for utility lookup
      if (dtoName.endsWith('Dto')) {
        final baseName = dtoName.substring(0, dtoName.length - 3);

        return '${baseName}Utility';
      }

      // Just add Utility suffix for non-Dto classes that are resolvable
      return '${dtoName}Utility';
    }

    // For DTO types, get the resolved type for utility mapping in real code
    String resolvedTypeString = typeString;
    if (resolvables.containsKey(typeString)) {
      resolvedTypeString = resolvables[typeString]!;
    }

    // Check for a direct utility mapping using the resolved type
    for (final entry in utilities.entries) {
      if (entry.value == resolvedTypeString) {
        return entry.key;
      }

      // Special handling for generic types like ImageProvider
      // Compare just the base type name without generic parameters
      if (type is InterfaceType) {
        final baseTypeName = type.element.name;
        final entryBaseTypeName = _extractBaseTypeName(entry.value);

        if (baseTypeName == entryBaseTypeName) {
          return entry.key;
        }
      }
    }

    // Check if we have a discovered type
    final utilityName = '${typeString}Utility';
    if (_discoveredTypes.containsKey(utilityName)) {
      return utilityName;
    }

    // If no mapping found, log warning
    _logger.warning(
      'No utility found for type: $typeString (resolved: $resolvedTypeString), using GenericUtility',
    );

    // Return GenericUtility with the appropriate type parameter instead of DynamicUtility
    return 'GenericUtility<T, $typeString>';
  }

  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    try {
      // 1. Collect all elements with annotations
      final specElements = _getAnnotatedElements(library, _specChecker);
      final propertyElements = _getAnnotatedElements(library, _propertyChecker);
      final utilityElements = _getAnnotatedElements(library, _utilityChecker);
      final tokenElements = _getAnnotatedElements(library, _tokensChecker);

      _logger.info(
        'Generate: Found ${specElements.length} spec elements, ${propertyElements.length} property elements, '
        '${utilityElements.length} utility elements, ${tokenElements.length} token elements',
      );

      // Quick exit if no annotations
      if (specElements.isEmpty &&
          propertyElements.isEmpty &&
          utilityElements.isEmpty &&
          tokenElements.isEmpty) {
        return '';
      }

      // 2. Create metadata objects
      final specMetadata = _createSpecMetadata(specElements);
      final propertyMetadata = _createPropertyMetadata(propertyElements);
      final utilityMetadata = _createUtilityMetadata(utilityElements);
      final tokenMetadata = _createTokenMetadata(tokenElements);

      _logger.info(
        'Generated metadata: ${specMetadata.length} specs, ${propertyMetadata.length} properties, '
        '${utilityMetadata.length} utilities, ${tokenMetadata.length} tokens',
      );

      final sourceOrderedElements = library
          .annotatedWith(
            TypeChecker.any([
              _specChecker,
              _propertyChecker,
              _utilityChecker,
              _tokensChecker,
            ]),
          )
          .map((annotated) => annotated.element)
          .whereType<ClassElement>()
          .toList();

      _logger.info('Source ordered elements: ${sourceOrderedElements.length}');
      for (var i = 0; i < sourceOrderedElements.length && i < 5; i++) {
        _logger.info('  Element $i: ${sourceOrderedElements[i].name}');
      }
      if (sourceOrderedElements.length > 5) {
        _logger.info(
          '  ... and ${sourceOrderedElements.length - 5} more elements',
        );
      }

      // 4. Build dependency graph (needed for type registration)
      final dependencyGraph = _buildDependencyGraph(
        specMetadata,
        propertyMetadata,
        utilityMetadata,
        tokenMetadata,
      );

      _logger.info(
        'Built dependency graph with ${dependencyGraph.getAllNodes().length} nodes',
      );

      // Sort all metadata for type registration
      final allMetadataForRegistration = _sortByDependencies(dependencyGraph);

      // 5. Generate code in source order
      final buffer = StringBuffer();

      // Add warning ignores if needed
      if (_needsDeprecationIgnore(specMetadata, propertyMetadata)) {
        buffer.writeln(
          '// ignore_for_file: deprecated_member_use_from_same_package',
        );
        buffer.writeln();
      }

      // Add file header
      buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
      buffer.writeln();

      // Register all types
      _registerTypes(allMetadataForRegistration);

      // Create a map of element to metadata for quick lookup
      final metadataMap = <ClassElement, BaseMetadata>{};
      for (final metadata in [
        ...specMetadata,
        ...propertyMetadata,
        ...utilityMetadata,
        ...tokenMetadata,
      ]) {
        metadataMap[metadata.element] = metadata;
        _logger.info(
          'Added to metadataMap: ${metadata.element.name} -> ${metadata.runtimeType}',
        );
      }

      // Generate code for each element in source order
      for (final element in sourceOrderedElements) {
        final metadata = metadataMap[element];
        if (metadata == null) continue;

        if (metadata is SpecMetadata) {
          _generateSpecCode(metadata, buffer);
        } else if (metadata is MixableTypeMetadata) {
          _generatePropertyCode(metadata, buffer);
        } else if (metadata is UtilityMetadata) {
          _generateUtilityCode(metadata, buffer);
        } else if (metadata is TokensMetadata) {
          _generateTokenCode(metadata, buffer);
        }
      }

      return buffer.toString();
    } catch (e, stackTrace) {
      _logger.severe('Error generating code', e, stackTrace);

      return '// Error generating code: $e\n// $stackTrace';
    }
  }
}
