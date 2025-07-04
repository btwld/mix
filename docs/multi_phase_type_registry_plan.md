# Multi-Phase Type Registry Implementation Plan

## Executive Summary

This plan outlines the complete replacement of the current `TypeRegistry` singleton with a multi-phase build system that discovers types through comprehensive analysis rather than hardcoded maps.

## Current State Analysis

### Problems with Current System
1. **Circular Dependency**: Type discovery happens during generation, but generation needs discovered types
2. **Hardcoded Maps**: Static maps in `type_registry.dart` require manual maintenance
3. **Limited Discovery**: Only finds annotated types, misses framework extensions
4. **Runtime Discovery**: Type registration happens too late in the process

### Current Dependencies
- `TypeRegistry.instance` used in 15+ files
- Hardcoded maps: `utilities`, `resolvables`, `tryToMerge`
- Runtime type registration in `MixGenerator._registerTypes()`

## Proposed Multi-Phase Architecture

### Phase 1: Enhanced Type Discovery Builder
**File**: `packages/mix_generator/lib/src/builders/type_discovery_builder.dart`

**Purpose**: Comprehensive type discovery across entire codebase

**Discovery Methods**:
1. **Annotation-Based**: `@MixableSpec`, `@MixableType`, etc.
2. **Framework Extension**: Classes extending `Spec<T>`, `Mixable<T>`, `MixUtility<T,V>`
3. **Existing Utilities**: Classes ending in `Utility` (even without annotations)
4. **Pattern-Based**: `*Dto`, `*Spec`, `*Attribute` naming patterns
5. **Core Types**: Flutter/Dart types that need utilities (`Color`, `EdgeInsets`, etc.)
6. **Import Analysis**: Types imported from Mix framework
7. **Usage Analysis**: Types referenced in fields, parameters, return types

**Output**: `.types.json` files per Dart file containing discovered type metadata

### Phase 2: Dependency Analysis Builder
**File**: `packages/mix_generator/lib/src/builders/dependency_analysis_builder.dart`

**Purpose**: Analyze type dependencies and build dependency graph

**Dependency Types**:
1. **Direct Dependencies**: `BoxSpec` depends on `BoxDecoration`
2. **Generic Dependencies**: `List<ColorDto>` depends on `ColorDto`
3. **Nested Dependencies**: `BoxDecorationDto` depends on `BorderDto`, `GradientDto`
4. **Circular Dependencies**: Detection and resolution
5. **Cross-Package Dependencies**: Types from different packages

**Output**: `.deps.json` files containing dependency relationships

### Phase 3: Type Registry Generator
**File**: `packages/mix_generator/lib/src/builders/type_registry_builder.dart`

**Purpose**: Generate complete type registry from all discovered types

**Generated Registry Structure**:
```dart
class GeneratedTypeRegistry {
  static const Map<String, String> utilities = {...};
  static const Map<String, String> resolvables = {...};
  static const Set<String> tryToMergeTypes = {...};
  static const Map<String, TypeMetadata> discoveredTypes = {...};
  static const Map<String, List<String>> dependencies = {...};
}
```

**Output**: `lib/generated/type_registry.dart`

### Phase 4: Main Code Generator
**File**: `packages/mix_generator/lib/src/builders/main_generator.dart`

**Purpose**: Generate code using complete type registry

**Changes**:
- Replace `TypeRegistry.instance` with `GeneratedTypeRegistry`
- Use dependency graph for generation order
- Handle nested dependencies correctly

## Nested Dependencies Handling

### Problem Statement
Current system struggles with nested dependencies like:
```dart
BoxDecorationDto -> BorderDto -> BorderSideDto -> ColorDto
```

### Solution: Dependency Graph Analysis

**1. Dependency Detection**:
```dart
class DependencyAnalyzer {
  Map<String, Set<String>> analyzeDependencies(TypeDiscoveryInfo type) {
    final dependencies = <String, Set<String>>{};
    
    // Analyze field types
    for (final field in type.fields) {
      final fieldDeps = _analyzeFieldDependencies(field);
      dependencies[field.name] = fieldDeps;
    }
    
    return dependencies;
  }
  
  Set<String> _analyzeFieldDependencies(FieldInfo field) {
    final deps = <String>{};
    
    // Direct type dependency
    if (_isGeneratedType(field.type)) {
      deps.add(field.type);
    }
    
    // Generic type dependencies (List<T>, Map<K,V>)
    for (final typeArg in field.typeArguments) {
      if (_isGeneratedType(typeArg)) {
        deps.add(typeArg);
      }
    }
    
    // Nested object dependencies
    if (field.isComplexType) {
      deps.addAll(_analyzeNestedDependencies(field.type));
    }
    
    return deps;
  }
}
```

**2. Topological Sorting**:
```dart
class DependencyGraph {
  List<String> getGenerationOrder(Map<String, Set<String>> dependencies) {
    // Kahn's algorithm for topological sorting
    final inDegree = <String, int>{};
    final adjList = <String, Set<String>>{};
    
    // Build graph and calculate in-degrees
    for (final entry in dependencies.entries) {
      final node = entry.key;
      final deps = entry.value;
      
      inDegree[node] = deps.length;
      for (final dep in deps) {
        adjList.putIfAbsent(dep, () => {}).add(node);
      }
    }
    
    // Topological sort
    final queue = <String>[];
    final result = <String>[];
    
    // Add nodes with no dependencies
    for (final entry in inDegree.entries) {
      if (entry.value == 0) {
        queue.add(entry.key);
      }
    }
    
    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      result.add(current);
      
      // Update dependent nodes
      for (final dependent in adjList[current] ?? <String>{}) {
        inDegree[dependent] = inDegree[dependent]! - 1;
        if (inDegree[dependent] == 0) {
          queue.add(dependent);
        }
      }
    }
    
    // Check for circular dependencies
    if (result.length != dependencies.length) {
      throw CircularDependencyException(_findCircularDependencies(dependencies));
    }
    
    return result;
  }
}
```

**3. Circular Dependency Resolution**:
```dart
class CircularDependencyResolver {
  List<String> resolveDependencies(Map<String, Set<String>> dependencies) {
    try {
      return DependencyGraph().getGenerationOrder(dependencies);
    } on CircularDependencyException catch (e) {
      // Break circular dependencies by generating forward declarations
      return _breakCircularDependencies(dependencies, e.circularNodes);
    }
  }
  
  List<String> _breakCircularDependencies(
    Map<String, Set<String>> dependencies,
    Set<String> circularNodes,
  ) {
    // Strategy 1: Generate forward declarations
    // Strategy 2: Use late initialization
    // Strategy 3: Split into multiple generation phases
  }
}
```

## Implementation Timeline

### Phase 1: Foundation (Week 1)
- [ ] Create `TypeDiscoveryBuilder` with basic annotation scanning
- [ ] Implement discovery data models (`TypeDiscoveryInfo`, etc.)
- [ ] Add JSON serialization for discovery results
- [ ] Create initial build configuration

### Phase 2: Enhanced Discovery (Week 2)
- [ ] Add framework extension detection
- [ ] Implement existing utility discovery
- [ ] Add pattern-based discovery
- [ ] Add core type discovery
- [ ] Add comprehensive testing

### Phase 3: Dependency Analysis (Week 3)
- [ ] Create `DependencyAnalysisBuilder`
- [ ] Implement dependency detection algorithms
- [ ] Add topological sorting
- [ ] Add circular dependency detection
- [ ] Test with complex nested dependencies

### Phase 4: Registry Generation (Week 4)
- [ ] Create `TypeRegistryBuilder`
- [ ] Implement registry code generation
- [ ] Add dependency graph integration
- [ ] Generate complete type mappings

### Phase 5: Main Generator Update (Week 5)
- [ ] Update `MixGenerator` to use generated registry
- [ ] Remove `TypeRegistry` singleton
- [ ] Update all dependent files
- [ ] Add comprehensive testing

### Phase 6: Migration & Cleanup (Week 6)
- [ ] Remove hardcoded type maps
- [ ] Update build configuration
- [ ] Add documentation
- [ ] Performance testing and optimization

## Risk Assessment

### High Risk
- **Circular Dependencies**: Complex nested types may create circular references
- **Performance**: Multi-phase build may be slower initially
- **Breaking Changes**: Complete API change for type registry

### Medium Risk
- **Discovery Accuracy**: May miss edge cases in type discovery
- **Build Complexity**: More complex build configuration

### Low Risk
- **Backward Compatibility**: Can maintain during transition
- **Testing**: Comprehensive test coverage possible

## Success Criteria

1. **Elimination of Hardcoded Maps**: No static type maps in codebase
2. **Comprehensive Discovery**: Finds all types (annotated and non-annotated)
3. **Correct Dependency Handling**: Proper generation order for nested dependencies
4. **Performance**: Build time within 20% of current system
5. **Maintainability**: Self-updating type registry

## Next Steps

1. **Review and Approve Plan**: Team review of this document
2. **Create Proof of Concept**: Basic type discovery for one annotation type
3. **Test with Complex Dependencies**: Validate nested dependency handling
4. **Implement Phase by Phase**: Gradual rollout with testing at each phase

---

**Note**: This plan addresses nested dependencies through comprehensive dependency analysis and topological sorting, ensuring correct generation order even for complex type hierarchies.
