import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:gen_helpers/gen_helpers.dart';
import 'package:path/path.dart' as path;

void main() async {
  print('Starting type discovery for Mix framework...\n');

  // Get the mix package directory
  final mixPackageDir = path.normalize(
    path.join(Directory.current.path, '..', 'mix'),
  );

  if (!Directory(mixPackageDir).existsSync()) {
    print('Error: Mix package not found at $mixPackageDir');
    exit(1);
  }

  print('Analyzing Mix package at: $mixPackageDir');

  // Create analysis context
  final collection = AnalysisContextCollection(
    includedPaths: [mixPackageDir],
  );

  final discovery = TypeDiscovery();

  // Base types to discover
  const baseTypes = {
    'Mixable',
    'MixUtility',
    'ScalarUtility',
    'ListUtility',
    'Spec',
    'SpecAttribute',
  };

  // Analyze all Dart files
  var fileCount = 0;
  for (final context in collection.contexts) {
    final analyzedFiles = context.contextRoot.analyzedFiles();

    for (final file in analyzedFiles) {
      if (!file.endsWith('.dart') || file.contains('.g.dart')) continue;

      // Skip test files
      if (file.contains('/test/') || file.contains('_test.dart')) continue;

      final result = await context.currentSession.getResolvedLibrary(file);
      if (result is ResolvedLibraryResult) {
        fileCount++;
        await discovery.analyzeForBases(result.element, baseTypes);
      }
    }
  }

  print('Analyzed $fileCount files');
  print('Discovered ${discovery.registry.allTypes.length} types\n');

  // Build the registry data
  final resolvables = <String, String>{};
  final utilities = <String, String>{};
  final tryToMerge = <String>{};

  for (final type in discovery.registry.allTypes) {
    // Skip test/mock types
    if (type.name.startsWith('Mock') ||
        type.name.startsWith('Test') ||
        type.name.startsWith('_')) {
      continue;
    }

    // Handle DTOs
    if (type.name.endsWith('Dto') &&
        _inheritsFromMixable(type, discovery.registry)) {
      var valueType = type.getGenericArgument('Mixable', 'Value') ??
          type.name.substring(0, type.name.length - 3);

      // Skip unresolved generics
      if (valueType == 'T' || valueType == 'Value') {
        // For known abstract DTOs, use the base name
        final baseName = type.name.substring(0, type.name.length - 3);
        if ([
          'Decoration',
          'Gradient',
          'BoxBorder',
          'Constraints',
          'BorderRadiusGeometry',
          'EdgeInsetsGeometry'
        ].contains(baseName)) {
          valueType = baseName;
        } else {
          continue;
        }
      }

      resolvables[type.name] = valueType;

      if (type.methods.any((m) => m.name == 'tryToMerge')) {
        tryToMerge.add(type.name);
      }
    }

    // Handle Attributes - but only core ones, not widget-specific modifiers
    if (type.name.endsWith('Attribute') &&
        !type.name.contains('Modifier') &&
        _inheritsFromSpecAttribute(type, discovery.registry)) {
      final specType = type.getGenericArgument('SpecAttribute', 'Value') ??
          type.name.replaceAll('Attribute', 'Spec');

      if (specType != 'T' && specType != 'Value') {
        resolvables[type.name] = specType;
      }
    }

    // Handle Utilities
    if (type.name.endsWith('Utility') &&
        _inheritsFromUtility(type, discovery.registry)) {
      final valueType = _getUtilityValueType(type);

      // Skip generic utilities and unresolved types
      if (valueType != null &&
          !['T', 'V', 'Value', 'D'].contains(valueType) &&
          !['GenericUtility', 'DtoUtility'].contains(type.name)) {
        utilities[type.name] = valueType;
      }
    }
  }

  print('Discovered mappings:');
  print('- ${resolvables.length} resolvables');
  print('- ${utilities.length} utilities');
  print('- ${tryToMerge.length} DTOs with tryToMerge\n');

  // Load existing hardcoded maps for comparison
  final registryFile = File(path.join(
    Directory.current.path,
    'lib/src/core/type_registry.dart',
  ));

  if (registryFile.existsSync()) {
    final content = registryFile.readAsStringSync();

    // Extract hardcoded counts (rough estimation)
    final resolvableMatches = RegExp(r"'.*':\s*'.*',").allMatches(
      content.substring(
        content.indexOf('final resolvables'),
        content.indexOf('final utilities'),
      ),
    );
    final utilityMatches = RegExp(r"'.*':\s*'.*',").allMatches(
      content.substring(
        content.indexOf('final utilities'),
        content.indexOf('final tryToMerge'),
      ),
    );

    print('Comparison with hardcoded maps:');
    print('- Hardcoded resolvables: ~${resolvableMatches.length}');
    print('- Discovered resolvables: ${resolvables.length}');
    print('- Hardcoded utilities: ~${utilityMatches.length}');
    print('- Discovered utilities: ${utilities.length}\n');
  }

  // Generate the new registry code
  final output = '''
// AUTO-GENERATED TYPE REGISTRY
// Generated by tool/discover_types.dart
// Run 'dart tool/discover_types.dart' to regenerate

/// Map of resolvable class names to their corresponding Flutter type names
final resolvables = ${_formatMap(resolvables)};

/// Map of utility class names to their corresponding value types  
final utilities = ${_formatMap(utilities)};

/// Set of DTO class names that have a tryToMerge method
final tryToMerge = ${_formatSet(tryToMerge)};
''';

  // Write to a separate file for review
  final outputFile = File(path.join(
    Directory.current.path,
    'lib/src/core/discovered_type_registry.dart',
  ));

  await outputFile.writeAsString(output);
  print('Generated registry written to: ${outputFile.path}');
  print(
    '\nTo use the discovered types, replace the hardcoded maps in type_registry.dart',
  );
}

// Helper functions

bool _inheritsFromMixable(DiscoveredType type, TypeRegistry registry) {
  // Use the new transitive inheritance check
  return registry.inheritsFromTransitive(type.name, 'Mixable');
}

bool _inheritsFromSpecAttribute(DiscoveredType type, TypeRegistry registry) {
  // Use the new transitive inheritance check
  return registry.inheritsFromTransitive(type.name, 'SpecAttribute');
}

bool _inheritsFromUtility(DiscoveredType type, TypeRegistry registry) {
  // Use the new transitive inheritance check for all utility base types
  return registry.inheritsFromTransitive(type.name, 'MixUtility') ||
      registry.inheritsFromTransitive(type.name, 'ScalarUtility') ||
      registry.inheritsFromTransitive(type.name, 'ListUtility');
}

String? _getUtilityValueType(DiscoveredType type) {
  // Special cases first
  if (type.name == 'ImageProviderUtility') {
    return 'ImageProvider<Object>';
  }

  // Try new gen_helpers methods
  // MixUtility<Attr, Value> - position 1 is Value
  var valueType = type.getGenericArgument('MixUtility', 'Value') ??
      type.getGenericArgumentByPosition('MixUtility', 1);
  if (valueType != null && valueType != 'Value') {
    if (type.name.contains('ListUtility')) {
      return 'List<$valueType>';
    }
    return valueType;
  }

  // ScalarUtility<Return, V> - position 1 is V
  valueType = type.getGenericArgument('ScalarUtility', 'V') ??
      type.getGenericArgumentByPosition('ScalarUtility', 1);
  if (valueType != null && valueType != 'V') {
    return valueType;
  }

  // ListUtility<T, V> - position 1 is V
  valueType = type.getGenericArgument('ListUtility', 'V') ??
      type.getGenericArgumentByPosition('ListUtility', 1);
  if (valueType != null && valueType != 'V') {
    // Handle nested List types properly
    if (valueType.startsWith('List<')) {
      return valueType;
    }
    return 'List<$valueType>';
  }

  return null;
}

String _formatMap(Map<String, String> map) {
  if (map.isEmpty) return '{}';

  final sortedEntries = map.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));

  final entries =
      sortedEntries.map((e) => "  '${e.key}': '${e.value}',").join('\n');

  return '{\n$entries\n}';
}

String _formatSet(Set<String> set) {
  if (set.isEmpty) return '{}';

  final sortedItems = set.toList()..sort();
  final entries = sortedItems.map((e) => "  '$e',").join('\n');

  return '{\n$entries\n}';
}
