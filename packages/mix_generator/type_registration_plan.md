# Type Registration Plan: Simple Auto-Discovery Implementation

## Executive Summary

This plan outlines a simple, practical approach to eliminate hardcoded type registries by discovering `Mixable<T>` implementations and their utilities at build time.

## Core Principle

**Extract type information from class hierarchy**, not naming conventions:
- If a class extends `Mixable<Color>`, register `Color` → `ThisClass`
- If a class implements `Mixable<Color>`, register `Color` → `ThisClass`
- If a utility handles `Color`, register `ColorUtility` → `Color`
- Fallback to `Mixable<T>` and `GenericUtility<T, Type>` when specific implementations don't exist

### Examples of Discovery

```dart
// Case 1: Direct extension (most common)
class ColorDto extends Mixable<Color> { }
// Discovers: Color → ColorDto

// Case 2: Implementation
class MyColorWrapper implements Mixable<Color> { }
// Discovers: Color → MyColorWrapper

// Case 3: Indirect through inheritance
abstract class BaseColorDto extends Mixable<Color> { }
class SpecialColorDto extends BaseColorDto { }
// Discovers: Color → SpecialColorDto

// Case 4: Direct Mixable<T> usage (after ColorDto removal)
final color = Mixable<Color>.value(Colors.red);
// No specific class to discover, uses Mixable<Color> directly
```

## Implementation Plan

### Phase 1: Type Extraction (Week 1)

#### 1.1 Create Type Discovery Helper

```dart
// lib/src/core/type_discovery.dart
class TypeDiscovery {
  /// Extract the T from Mixable<T> for a given class
  static String? extractMixableType(ClassElement element) {
    // Check direct interfaces first (implements Mixable<T>)
    for (final interface in element.interfaces) {
      if (interface.element.name == 'Mixable' && 
          interface.typeArguments.isNotEmpty) {
        return interface.typeArguments.first
            .getDisplayString(withNullability: false);
      }
    }
    
    // Check all supertypes (extends Mixable<T> or extends something that implements it)
    final mixableInterface = element.allSupertypes
        .firstWhereOrNull((type) => 
            type.element.name == 'Mixable' && 
            type.typeArguments.isNotEmpty);
    
    if (mixableInterface != null) {
      // Return the T from Mixable<T>
      return mixableInterface.typeArguments.first
          .getDisplayString(withNullability: false);
    }
    
    // Check if the class itself is Mixable<T> (for abstract classes)
    if (element.name == 'Mixable' && element.typeParameters.isNotEmpty) {
      // This handles cases where we're looking at Mixable itself
      return element.typeParameters.first.name;
    }
    
    return null;
  }
  
  /// Extract the handled type from a utility class
  static String? extractUtilityType(ClassElement element) {
    // Check if extends MixUtility<T, V> or DtoUtility<T, D, V>
    for (final supertype in element.allSupertypes) {
      if (supertype.element.name == 'MixUtility' && 
          supertype.typeArguments.length >= 2) {
        // Return V from MixUtility<T, V>
        return supertype.typeArguments[1]
            .getDisplayString(withNullability: false);
      }
      
      if (supertype.element.name == 'DtoUtility' && 
          supertype.typeArguments.length >= 3) {
        // Return V from DtoUtility<T, D, V>
        return supertype.typeArguments[2]
            .getDisplayString(withNullability: false);
      }
    }
    
    return null;
  }
  
  /// Check if a class has tryToMerge capability
  static bool hasTryToMerge(ClassElement element) {
    return element.methods.any((method) => 
      method.name == 'tryToMerge' && 
      method.isStatic &&
      method.parameters.length == 2
    );
  }
}
```

#### 1.2 Update MixGenerator

```dart
// In mix_generator.dart
class MixGenerator extends Generator {
  // Local type maps built during generation
  final _mixableTypes = <String, String>{};  // Type -> Implementation
  final _utilityTypes = <String, String>{};  // Utility -> Type
  final _tryToMergeTypes = <String>{};
  
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    // 1. Discover all types in current library
    _discoverTypes(library);
    
    // 2. Continue with normal generation
    return _generateCode(library, buildStep);
  }
  
  void _discoverTypes(LibraryReader library) {
    for (final element in library.classes) {
      // Discover Mixable implementations
      final mixableType = TypeDiscovery.extractMixableType(element);
      if (mixableType != null) {
        // Note: If multiple implementations exist for the same type,
        // the last one discovered wins. This matches current behavior
        // where the last registration in TypeRegistry overwrites previous ones.
        // In practice, there should only be one implementation per type.
        _mixableTypes[mixableType] = element.name;
        
        if (TypeDiscovery.hasTryToMerge(element)) {
          _tryToMergeTypes.add(element.name);
        }
      }
      
      // Discover Utility implementations
      final utilityType = TypeDiscovery.extractUtilityType(element);
      if (utilityType != null) {
        _utilityTypes[element.name] = utilityType;
      }
    }
  }
}
```

### Phase 2: Context-Based Resolution (Week 2)

#### 2.1 Create Resolution Context

```dart
// lib/src/core/resolution_context.dart
class ResolutionContext {
  final Map<String, String> mixableTypes;
  final Map<String, String> utilityTypes;
  final Set<String> tryToMergeTypes;
  
  ResolutionContext({
    required this.mixableTypes,
    required this.utilityTypes,
    required this.tryToMergeTypes,
  });
  
  /// Get the Mixable implementation for a type
  String getMixableForType(String type) {
    // Check discovered types first
    if (mixableTypes.containsKey(type)) {
      return mixableTypes[type]!;
    }
    
    // Fallback to generic Mixable<T>
    return 'Mixable<$type>';
  }
  
  /// Get the utility for a type
  String getUtilityForType(DartType type) {
    final typeString = type.getDisplayString(withNullability: false);
    
    // Find utility that handles this type
    for (final entry in utilityTypes.entries) {
      if (entry.value == typeString) {
        return entry.key;
      }
    }
    
    // Fallback to GenericUtility
    return 'GenericUtility<T, $typeString>';
  }
  
  /// Check if type has tryToMerge
  bool hasTryToMerge(String typeName) {
    return tryToMergeTypes.contains(typeName);
  }
}
```

#### 2.2 Update Metadata Creation

```dart
// Update annotation_utils.dart
FieldUtilityMetadata createFieldUtilityMetadata({
  required String name,
  required DartType dartType,
  MixableFieldUtility? utilityAnnotation,
  ResolutionContext? context,
}) {
  String utilityType;
  
  if (utilityAnnotation?.typeAsString != null) {
    utilityType = utilityAnnotation!.typeAsString!;
  } else if (context != null) {
    // Use context for resolution
    utilityType = context.getUtilityForType(dartType);
  } else {
    // Fallback to TypeRegistry during transition
    utilityType = TypeRegistry.instance.getUtilityForType(dartType);
  }
  
  return FieldUtilityMetadata(name: name, type: utilityType);
}
```

### Phase 3: Import Discovery (Week 3)

#### 3.1 Scan Imported Libraries

```dart
// Add to MixGenerator
void _discoverImportedTypes(LibraryReader library) {
  for (final import in library.element.imports) {
    final importedLibrary = import.importedLibrary;
    if (importedLibrary == null) continue;
    
    // Check if this is a Mix-related import
    if (_isMixLibrary(importedLibrary)) {
      final reader = LibraryReader(importedLibrary);
      
      // Discover types from imported library
      for (final element in reader.classes) {
        final mixableType = TypeDiscovery.extractMixableType(element);
        if (mixableType != null) {
          _mixableTypes.putIfAbsent(mixableType, () => element.name);
        }
        
        final utilityType = TypeDiscovery.extractUtilityType(element);
        if (utilityType != null) {
          _utilityTypes.putIfAbsent(element.name, () => utilityType);
        }
      }
    }
  }
}

bool _isMixLibrary(LibraryElement library) {
  // Check if library contains Mix types
  return library.identifier.contains('mix') ||
         library.topLevelElements.any((e) => 
           e is ClassElement && 
           (TypeDiscovery.extractMixableType(e) != null ||
            TypeDiscovery.extractUtilityType(e) != null)
         );
}
```

### Phase 4: Migration Path (Week 4)

#### 4.1 Compatibility Layer

```dart
// In type_registry.dart
class TypeRegistry {
  // Keep existing maps but mark as deprecated
  @deprecated
  static final Map<String, String> resolvables = {...};
  
  @deprecated  
  static final Map<String, String> utilities = {...};
  
  // Add context-aware methods
  String getUtilityForType(DartType type, {ResolutionContext? context}) {
    if (context != null) {
      return context.getUtilityForType(type);
    }
    // Fallback to hardcoded maps
    return _getUtilityFromMaps(type);
  }
}
```

#### 4.2 Update Builders Incrementally

```dart
// Example: Update MixableTypeUtilityBuilder
class MixableTypeUtilityBuilder implements CodeBuilder {
  final MixableTypeMetadata metadata;
  final ResolutionContext? context; // Optional during transition
  
  @override
  String build() {
    // Use context if available, fallback to TypeRegistry
    final utilityType = context?.getUtilityForType(metadata.dartType) ??
                       TypeRegistry.instance.getUtilityForType(metadata.dartType);
    
    // Generate code...
  }
}
```

## Validation Strategy

### 1. Unit Tests
```dart
test('discovers Mixable<Color> implementation', () {
  final element = // mock ColorDto extending Mixable<Color>
  final type = TypeDiscovery.extractMixableType(element);
  expect(type, equals('Color'));
});

test('discovers utility for Color type', () {
  final element = // mock ColorUtility
  final type = TypeDiscovery.extractUtilityType(element);
  expect(type, equals('Color'));
});
```

### 2. Integration Tests
- Generate code for all existing specs
- Compare output with current generator
- Ensure ColorDto and RadiusDto are no longer in generated code

### 3. Performance Tests
- Measure generation time before/after
- Should be within 10% of current performance

## Success Metrics

1. **Zero hardcoded type maps** - All types discovered automatically
2. **Correct fallbacks** - Uses `Mixable<T>` and `GenericUtility<T, Type>` appropriately
3. **No breaking changes** - Existing code continues to work
4. **Better maintainability** - No manual registry updates needed

## Timeline

- **Week 1**: Implement TypeDiscovery and basic discovery
- **Week 2**: Add ResolutionContext and update metadata creation
- **Week 3**: Add import scanning for cross-package types
- **Week 4**: Migration compatibility and testing

## Benefits

1. **Automatic Updates** - Removing ColorDto automatically removes it from discovery
2. **Type Safety** - Based on actual type parameters, not naming conventions
3. **Simple Implementation** - Single-pass, no complex multi-phase builds
4. **Backward Compatible** - Gradual migration with fallbacks

## Next Steps

1. Review and approve this plan
2. Create TypeDiscovery class with comprehensive tests
3. Update MixGenerator to use discovery
4. Gradually migrate all TypeRegistry usages
5. Remove hardcoded maps after full migration

---

This approach focuses on extracting real type information from the Dart type system rather than relying on conventions, making it more robust and maintainable.