/// Collects concrete public method signatures from a mixin element.
///
/// Skips abstract methods, which are the host-implementation anchors, plus
/// private methods and operators.
library;

import 'package:analyzer/dart/element/element.dart';

/// A method signature suitable for factory generation.
class CollectedMethod {
  final String name;
  final List<FormalParameterElement> parameters;
  final String returnTypeDisplay;

  const CollectedMethod({
    required this.name,
    required this.parameters,
    required this.returnTypeDisplay,
  });
}

class MixinMethodCollector {
  /// Returns concrete public methods declared on [mixinElement].
  static List<CollectedMethod> collect(InterfaceElement mixinElement) {
    return mixinElement.methods
        .where((m) => !m.isAbstract)
        .where((m) => !(m.name?.startsWith('_') ?? true))
        .where((m) => !m.isOperator)
        .map(
          (m) => CollectedMethod(
            name: m.name!,
            parameters: m.formalParameters,
            returnTypeDisplay: m.returnType.getDisplayString(),
          ),
        )
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }
}
