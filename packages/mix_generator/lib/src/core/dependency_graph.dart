import 'package:logging/logging.dart';

import 'metadata/base_metadata.dart';

/// A graph structure to represent dependencies between metadata types.
/// Uses BaseMetadata as the node type to ensure type safety.
class DependencyGraph {
  final Logger _logger = Logger('DependencyGraph');
  final Map<BaseMetadata, Set<BaseMetadata>> _dependencies = {};

  /// Get a descriptive name for a node (for logging)
  String _getNodeName(BaseMetadata node) {
    return node.name;
  }

  /// Add a node to the graph
  void addNode(BaseMetadata node) {
    _dependencies.putIfAbsent(node, () => {});
  }

  /// Add a dependency between two nodes
  void addDependency(BaseMetadata from, BaseMetadata to) {
    // Add the 'from' node if it doesn't exist
    addNode(from);
    // Add the 'to' node if it doesn't exist
    addNode(to);

    // Add the dependency
    _dependencies[from]!.add(to);

    _logger
        .fine('Added dependency: ${_getNodeName(from)} -> ${_getNodeName(to)}');
  }

  /// Get all nodes in the graph
  List<BaseMetadata> getAllNodes() {
    return _dependencies.keys.toList();
  }

  /// Get dependencies for a node
  Set<BaseMetadata> getDependenciesFor(BaseMetadata node) {
    return _dependencies[node] ?? {};
  }

  /// Sort nodes topologically
  List<BaseMetadata> sortTopologically() {
    final result = <BaseMetadata>[];
    final visited = <BaseMetadata>{};
    final visiting = <BaseMetadata>{};

    void visit(BaseMetadata node) {
      if (visited.contains(node)) return;
      if (visiting.contains(node)) {
        _logger.warning(
          'Circular dependency detected involving ${_getNodeName(node)}',
        );

        // Handle circular dependency by breaking it
        return;
      }

      visiting.add(node);
      for (final dependency in _dependencies[node] ?? {}) {
        visit(dependency);
      }
      visiting.remove(node);
      visited.add(node);
      result.add(node);
    }

    // Visit each node that hasn't been visited yet
    for (final node in _dependencies.keys) {
      if (!visited.contains(node)) {
        visit(node);
      }
    }

    return result.reversed.toList(); // Reverse for correct order
  }
}
