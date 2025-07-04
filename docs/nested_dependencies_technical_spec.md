# Nested Dependencies Technical Specification

## Overview

This document details how the multi-phase type registry will handle complex nested dependencies in the Mix code generation system.

## Current Nested Dependency Challenges

### Example Complex Dependency Chain
```dart
// Level 1: Root Spec
@MixableSpec()
class BoxSpec extends Spec<BoxSpec> {
  final BoxDecorationDto? decoration;  // Depends on BoxDecorationDto
}

// Level 2: Complex DTO
@MixableType()
class BoxDecorationDto extends Mixable<BoxDecoration> {
  final BorderDto? border;           // Depends on BorderDto
  final GradientDto? gradient;       // Depends on GradientDto
  final List<BoxShadowDto>? shadows; // Depends on BoxShadowDto
}

// Level 3: Nested DTOs
@MixableType()
class BorderDto extends Mixable<Border> {
  final BorderSideDto? top;    // Depends on BorderSideDto
  final BorderSideDto? bottom; // Depends on BorderSideDto
}

@MixableType()
class GradientDto extends Mixable<Gradient> {
  final List<ColorDto>? colors; // Depends on ColorDto
  final List<double>? stops;    // Primitive type
}

// Level 4: Leaf DTOs
@MixableType()
class BorderSideDto extends Mixable<BorderSide> {
  final ColorDto? color; // Depends on ColorDto
  final double? width;   // Primitive type
}

@MixableType()
class ColorDto extends Mixable<Color> {
  final int? value; // Primitive type
}
```

### Dependency Graph Visualization
```
BoxSpec
  └── BoxDecorationDto
      ├── BorderDto
      │   └── BorderSideDto
      │       └── ColorDto
      ├── GradientDto
      │   └── ColorDto
      └── BoxShadowDto
          └── ColorDto
```

## Technical Solution

### 1. Dependency Detection Algorithm

```dart
class DependencyDetector {
  Map<String, TypeDependencies> detectAllDependencies(
    Map<String, TypeDiscoveryInfo> discoveredTypes
  ) {
    final dependencies = <String, TypeDependencies>{};
    
    for (final type in discoveredTypes.values) {
      dependencies[type.generatedType] = _analyzeTypeDependencies(type);
    }
    
    return dependencies;
  }
  
  TypeDependencies _analyzeTypeDependencies(TypeDiscoveryInfo type) {
    final deps = TypeDependencies(type.generatedType);
    
    // Analyze class fields
    for (final field in type.fields) {
      _analyzeFieldDependencies(field, deps);
    }
    
    // Analyze constructor parameters
    for (final param in type.constructorParameters) {
      _analyzeParameterDependencies(param, deps);
    }
    
    // Analyze generic type arguments
    for (final typeArg in type.genericTypeArguments) {
      _analyzeGenericDependencies(typeArg, deps);
    }
    
    return deps;
  }
  
  void _analyzeFieldDependencies(FieldInfo field, TypeDependencies deps) {
    // Direct type dependency
    if (_isGeneratedType(field.type)) {
      deps.addDirectDependency(field.type);
    }
    
    // List/Collection dependencies
    if (field.isListType) {
      final elementType = field.listElementType;
      if (_isGeneratedType(elementType)) {
        deps.addCollectionDependency(elementType);
      }
    }
    
    // Map dependencies
    if (field.isMapType) {
      final keyType = field.mapKeyType;
      final valueType = field.mapValueType;
      if (_isGeneratedType(keyType)) {
        deps.addDirectDependency(keyType);
      }
      if (_isGeneratedType(valueType)) {
        deps.addDirectDependency(valueType);
      }
    }
    
    // Optional/Nullable dependencies
    if (field.isNullable) {
      deps.markAsOptional(field.type);
    }
  }
}

class TypeDependencies {
  final String typeName;
  final Set<String> directDependencies = {};
  final Set<String> collectionDependencies = {};
  final Set<String> optionalDependencies = {};
  final Map<String, DependencyContext> dependencyContexts = {};
  
  TypeDependencies(this.typeName);
  
  void addDirectDependency(String type) {
    directDependencies.add(type);
    dependencyContexts[type] = DependencyContext.direct;
  }
  
  void addCollectionDependency(String type) {
    collectionDependencies.add(type);
    dependencyContexts[type] = DependencyContext.collection;
  }
  
  Set<String> getAllDependencies() {
    return {...directDependencies, ...collectionDependencies};
  }
}

enum DependencyContext {
  direct,      // BoxSpec depends on BoxDecorationDto
  collection,  // BoxDecorationDto depends on List<BoxShadowDto>
  optional,    // BorderDto optionally depends on BorderSideDto
  generic,     // MixUtility<T, V> depends on T and V
}
```

### 2. Topological Sorting with Cycle Detection

```dart
class DependencyGraphSolver {
  GenerationOrder solveDependencies(
    Map<String, TypeDependencies> dependencies
  ) {
    final graph = _buildGraph(dependencies);
    final order = _topologicalSort(graph);
    
    return GenerationOrder(
      order: order,
      cycles: _detectCycles(graph),
      levels: _calculateGenerationLevels(order, dependencies),
    );
  }
  
  Map<String, Set<String>> _buildGraph(
    Map<String, TypeDependencies> dependencies
  ) {
    final graph = <String, Set<String>>{};
    
    for (final entry in dependencies.entries) {
      final typeName = entry.key;
      final deps = entry.value;
      
      graph[typeName] = deps.getAllDependencies();
    }
    
    return graph;
  }
  
  List<String> _topologicalSort(Map<String, Set<String>> graph) {
    final inDegree = <String, int>{};
    final adjList = <String, Set<String>>{};
    final allNodes = <String>{};
    
    // Initialize
    for (final entry in graph.entries) {
      final node = entry.key;
      final deps = entry.value;
      
      allNodes.add(node);
      allNodes.addAll(deps);
      
      inDegree.putIfAbsent(node, () => 0);
      for (final dep in deps) {
        inDegree.putIfAbsent(dep, () => 0);
        adjList.putIfAbsent(dep, () => {}).add(node);
        inDegree[node] = inDegree[node]! + 1;
      }
    }
    
    // Kahn's algorithm
    final queue = <String>[];
    final result = <String>[];
    
    // Find nodes with no incoming edges
    for (final entry in inDegree.entries) {
      if (entry.value == 0) {
        queue.add(entry.key);
      }
    }
    
    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      result.add(current);
      
      // Remove edges from current node
      for (final neighbor in adjList[current] ?? <String>{}) {
        inDegree[neighbor] = inDegree[neighbor]! - 1;
        if (inDegree[neighbor] == 0) {
          queue.add(neighbor);
        }
      }
    }
    
    // Check for cycles
    if (result.length != allNodes.length) {
      final remaining = allNodes.difference(result.toSet());
      throw CircularDependencyException(remaining);
    }
    
    return result;
  }
  
  Map<String, int> _calculateGenerationLevels(
    List<String> order,
    Map<String, TypeDependencies> dependencies,
  ) {
    final levels = <String, int>{};
    
    for (final type in order) {
      final deps = dependencies[type]?.getAllDependencies() ?? <String>{};
      
      if (deps.isEmpty) {
        levels[type] = 0; // Leaf nodes
      } else {
        final maxDepLevel = deps
            .map((dep) => levels[dep] ?? 0)
            .fold(0, (max, level) => level > max ? level : max);
        levels[type] = maxDepLevel + 1;
      }
    }
    
    return levels;
  }
}

class GenerationOrder {
  final List<String> order;
  final Set<String> cycles;
  final Map<String, int> levels;
  
  GenerationOrder({
    required this.order,
    required this.cycles,
    required this.levels,
  });
  
  List<List<String>> getGenerationBatches() {
    final batches = <List<String>>[];
    final maxLevel = levels.values.fold(0, (max, level) => level > max ? level : max);
    
    for (int level = 0; level <= maxLevel; level++) {
      final batch = order.where((type) => levels[type] == level).toList();
      if (batch.isNotEmpty) {
        batches.add(batch);
      }
    }
    
    return batches;
  }
}
```

### 3. Circular Dependency Resolution

```dart
class CircularDependencyResolver {
  GenerationOrder resolveCircularDependencies(
    Map<String, TypeDependencies> dependencies,
    Set<String> circularTypes,
  ) {
    // Strategy 1: Break cycles by removing optional dependencies
    final reducedDeps = _removeOptionalDependencies(dependencies, circularTypes);
    
    try {
      return DependencyGraphSolver().solveDependencies(reducedDeps);
    } catch (e) {
      // Strategy 2: Use forward declarations
      return _useForwardDeclarations(dependencies, circularTypes);
    }
  }
  
  Map<String, TypeDependencies> _removeOptionalDependencies(
    Map<String, TypeDependencies> dependencies,
    Set<String> circularTypes,
  ) {
    final reduced = <String, TypeDependencies>{};
    
    for (final entry in dependencies.entries) {
      final type = entry.key;
      final deps = entry.value;
      
      if (circularTypes.contains(type)) {
        // Remove optional dependencies that create cycles
        final newDeps = TypeDependencies(type);
        for (final dep in deps.directDependencies) {
          if (!_createsCircle(type, dep, circularTypes)) {
            newDeps.addDirectDependency(dep);
          }
        }
        reduced[type] = newDeps;
      } else {
        reduced[type] = deps;
      }
    }
    
    return reduced;
  }
  
  GenerationOrder _useForwardDeclarations(
    Map<String, TypeDependencies> dependencies,
    Set<String> circularTypes,
  ) {
    // Generate forward declarations for circular types
    final forwardDeclarations = circularTypes.map((type) => '${type}_Forward').toList();
    
    // Create modified dependency graph with forward declarations
    final modifiedDeps = <String, TypeDependencies>{};
    
    for (final entry in dependencies.entries) {
      final type = entry.key;
      final deps = entry.value;
      
      final newDeps = TypeDependencies(type);
      
      for (final dep in deps.getAllDependencies()) {
        if (circularTypes.contains(dep)) {
          // Use forward declaration instead
          newDeps.addDirectDependency('${dep}_Forward');
        } else {
          newDeps.addDirectDependency(dep);
        }
      }
      
      modifiedDeps[type] = newDeps;
    }
    
    // Add forward declarations as leaf nodes
    for (final forward in forwardDeclarations) {
      modifiedDeps[forward] = TypeDependencies(forward);
    }
    
    return DependencyGraphSolver().solveDependencies(modifiedDeps);
  }
}
```

## Integration with Build System

### Build Configuration
```yaml
builders:
  dependency_analysis:
    import: 'package:mix_generator/builders.dart'
    builder_factories: ['dependencyAnalysisBuilder']
    build_extensions: {'.types.json': ['.deps.json']}
    auto_apply: dependents
    build_to: cache
    required_inputs: ['.types.json']
    applies_builders: ['mix_generator:type_discovery']
```

### Generated Registry with Dependency Information
```dart
class GeneratedTypeRegistry {
  static const Map<String, List<String>> dependencyOrder = {
    'ColorDto': [],
    'BorderSideDto': ['ColorDto'],
    'BorderDto': ['BorderSideDto'],
    'BoxDecorationDto': ['BorderDto', 'GradientDto', 'BoxShadowDto'],
    'BoxSpec': ['BoxDecorationDto'],
  };
  
  static const Map<String, int> generationLevels = {
    'ColorDto': 0,
    'BorderSideDto': 1,
    'BorderDto': 2,
    'BoxDecorationDto': 3,
    'BoxSpec': 4,
  };
}
```

## Performance Considerations

1. **Caching**: Cache dependency analysis results
2. **Incremental**: Only reanalyze changed types
3. **Parallel**: Generate independent types in parallel
4. **Lazy**: Only analyze dependencies when needed

## Testing Strategy

1. **Unit Tests**: Test dependency detection algorithms
2. **Integration Tests**: Test with real Mix codebase
3. **Edge Cases**: Circular dependencies, deep nesting
4. **Performance Tests**: Large codebases with many types

This technical specification ensures that nested dependencies are handled correctly through comprehensive analysis and proper generation ordering.
