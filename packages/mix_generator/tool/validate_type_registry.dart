import 'dart:io';

import 'package:path/path.dart' as path;

void main() async {
  print('Validating type registry discovery...\n');

  // Load hardcoded registry
  final registryFile = File(path.join(
    Directory.current.path,
    'lib/src/core/type_registry.dart',
  ));

  if (!registryFile.existsSync()) {
    print('Error: type_registry.dart not found');
    exit(1);
  }

  final hardcodedContent = registryFile.readAsStringSync();

  // Load discovered registry
  final discoveredFile = File(path.join(
    Directory.current.path,
    'lib/src/core/discovered_type_registry.dart',
  ));

  if (!discoveredFile.existsSync()) {
    print('Error: discovered_type_registry.dart not found');
    print('Run: dart tool/discover_types.dart first');
    exit(1);
  }

  final discoveredContent = discoveredFile.readAsStringSync();

  // Extract maps from content
  final hardcodedResolvables = _extractMap(hardcodedContent, 'resolvables');
  final hardcodedUtilities = _extractMap(hardcodedContent, 'utilities');
  final hardcodedTryToMerge = _extractSet(hardcodedContent, 'tryToMerge');

  final discoveredResolvables = _extractMap(discoveredContent, 'resolvables');
  final discoveredUtilities = _extractMap(discoveredContent, 'utilities');
  final discoveredTryToMerge = _extractSet(discoveredContent, 'tryToMerge');

  // Compare resolvables
  print('=== RESOLVABLES ===');
  print('Hardcoded: ${hardcodedResolvables.length} entries');
  print('Discovered: ${discoveredResolvables.length} entries\n');

  final missingResolvables = <String, String>{};
  final extraResolvables = <String, String>{};
  final mismatchedResolvables = <String, List<String>>{};

  // Find missing from discovered
  hardcodedResolvables.forEach((key, value) {
    if (!discoveredResolvables.containsKey(key)) {
      missingResolvables[key] = value;
    } else if (discoveredResolvables[key] != value) {
      mismatchedResolvables[key] = [value, discoveredResolvables[key]!];
    }
  });

  // Find extra in discovered
  discoveredResolvables.forEach((key, value) {
    if (!hardcodedResolvables.containsKey(key)) {
      extraResolvables[key] = value;
    }
  });

  if (missingResolvables.isNotEmpty) {
    print('Missing from discovered (${missingResolvables.length}):');
    missingResolvables.forEach((key, value) {
      print('  $key: $value');
    });
    print('');
  }

  if (extraResolvables.isNotEmpty) {
    print('Extra in discovered (${extraResolvables.length}):');
    extraResolvables.forEach((key, value) {
      print('  $key: $value');
    });
    print('');
  }

  if (mismatchedResolvables.isNotEmpty) {
    print('Value mismatches (${mismatchedResolvables.length}):');
    mismatchedResolvables.forEach((key, values) {
      print('  $key: ${values[0]} (hardcoded) vs ${values[1]} (discovered)');
    });
    print('');
  }

  // Compare utilities
  print('=== UTILITIES ===');
  print('Hardcoded: ${hardcodedUtilities.length} entries');
  print('Discovered: ${discoveredUtilities.length} entries\n');

  final missingUtilities = <String, String>{};
  final extraUtilities = <String, String>{};
  final mismatchedUtilities = <String, List<String>>{};

  // Find missing from discovered
  hardcodedUtilities.forEach((key, value) {
    if (!discoveredUtilities.containsKey(key)) {
      missingUtilities[key] = value;
    } else if (discoveredUtilities[key] != value) {
      mismatchedUtilities[key] = [value, discoveredUtilities[key]!];
    }
  });

  // Find extra in discovered
  discoveredUtilities.forEach((key, value) {
    if (!hardcodedUtilities.containsKey(key)) {
      extraUtilities[key] = value;
    }
  });

  if (missingUtilities.isNotEmpty) {
    print('Missing from discovered (${missingUtilities.length}):');
    missingUtilities.forEach((key, value) {
      print('  $key: $value');
    });
    print('');
  }

  if (extraUtilities.isNotEmpty) {
    print('Extra in discovered (${extraUtilities.length}):');
    extraUtilities.forEach((key, value) {
      print('  $key: $value');
    });
    print('');
  }

  if (mismatchedUtilities.isNotEmpty) {
    print('Value mismatches (${mismatchedUtilities.length}):');
    mismatchedUtilities.forEach((key, values) {
      print('  $key: ${values[0]} (hardcoded) vs ${values[1]} (discovered)');
    });
    print('');
  }

  // Compare tryToMerge
  print('=== TRY TO MERGE ===');
  print('Hardcoded: ${hardcodedTryToMerge.length} entries');
  print('Discovered: ${discoveredTryToMerge.length} entries\n');

  final missingTryToMerge =
      hardcodedTryToMerge.difference(discoveredTryToMerge);
  final extraTryToMerge = discoveredTryToMerge.difference(hardcodedTryToMerge);

  if (missingTryToMerge.isNotEmpty) {
    print('Missing from discovered: $missingTryToMerge');
  }

  if (extraTryToMerge.isNotEmpty) {
    print('Extra in discovered: $extraTryToMerge');
  }

  // Summary
  print('\n=== SUMMARY ===');
  final resolvableIssues = missingResolvables.length +
      extraResolvables.length +
      mismatchedResolvables.length;
  final utilityIssues = missingUtilities.length +
      extraUtilities.length +
      mismatchedUtilities.length;
  final tryToMergeIssues = missingTryToMerge.length + extraTryToMerge.length;

  if (resolvableIssues == 0 && utilityIssues == 0 && tryToMergeIssues == 0) {
    print(
        '✅ Perfect match! Discovery produces identical results to hardcoded maps.');
  } else {
    print('❌ Differences found:');
    print('  - Resolvables: $resolvableIssues issues');
    print('  - Utilities: $utilityIssues issues');
    print('  - TryToMerge: $tryToMergeIssues issues');
    print(
        '\nThese differences need to be resolved before replacing hardcoded maps.');
  }
}

Map<String, String> _extractMap(String content, String mapName) {
  final map = <String, String>{};

  // Find the map declaration
  final startPattern = RegExp('final\\s+$mapName\\s*=\\s*{');
  final startMatch = startPattern.firstMatch(content);
  if (startMatch == null) return map;

  var index = startMatch.end;
  var braceCount = 1;
  var inString = false;
  var escape = false;
  var currentKey = '';
  var currentValue = '';
  var isKey = true;

  while (index < content.length && braceCount > 0) {
    final char = content[index];

    if (!escape && char == '\\') {
      escape = true;
    } else if (!escape && char == "'") {
      inString = !inString;
    } else if (!inString && !escape) {
      if (char == '{') {
        braceCount++;
      } else if (char == '}') {
        braceCount--;
        if (braceCount == 0) break;
      } else if (char == ':' && isKey) {
        isKey = false;
      } else if (char == ',' && !isKey) {
        // End of entry
        final key = currentKey.trim().replaceAll("'", '');
        final value = currentValue.trim().replaceAll("'", '');
        if (key.isNotEmpty && value.isNotEmpty) {
          map[key] = value;
        }
        currentKey = '';
        currentValue = '';
        isKey = true;
      }
    }

    if (inString && !escape && char != "'") {
      if (isKey) {
        currentKey += char;
      } else {
        currentValue += char;
      }
    }

    if (escape) escape = false;
    index++;
  }

  // Handle last entry if no trailing comma
  if (currentKey.isNotEmpty && currentValue.isNotEmpty) {
    final key = currentKey.trim().replaceAll("'", '');
    final value = currentValue.trim().replaceAll("'", '');
    map[key] = value;
  }

  return map;
}

Set<String> _extractSet(String content, String setName) {
  final set = <String>{};

  // Find the set declaration
  final startPattern = RegExp('final\\s+$setName\\s*=\\s*{');
  final startMatch = startPattern.firstMatch(content);
  if (startMatch == null) return set;

  var index = startMatch.end;
  var braceCount = 1;
  var inString = false;
  var escape = false;
  var currentValue = '';

  while (index < content.length && braceCount > 0) {
    final char = content[index];

    if (!escape && char == '\\') {
      escape = true;
    } else if (!escape && char == "'") {
      inString = !inString;
    } else if (!inString && !escape) {
      if (char == '{') {
        braceCount++;
      } else if (char == '}') {
        braceCount--;
        if (braceCount == 0) {
          // Handle last entry
          if (currentValue.isNotEmpty) {
            set.add(currentValue.trim().replaceAll("'", ''));
          }
          break;
        }
      } else if (char == ',') {
        // End of entry
        if (currentValue.isNotEmpty) {
          set.add(currentValue.trim().replaceAll("'", ''));
          currentValue = '';
        }
      }
    }

    if (inString && !escape && char != "'") {
      currentValue += char;
    }

    if (escape) escape = false;
    index++;
  }

  return set;
}
