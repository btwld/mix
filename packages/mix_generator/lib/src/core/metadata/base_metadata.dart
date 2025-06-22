import 'package:analyzer/dart/element/element.dart';

import 'field_metadata.dart';

/// Base class for metadata used in code generation.
///
/// This provides common properties and methods needed across different
/// annotation types (Spec, DTO, etc.).
abstract class BaseMetadata {
  /// The annotated class element
  final ClassElement element; // ignore: deprecated_member_use

  /// The name of the class
  final String name;

  /// The fields/parameters of the class
  final List<ParameterMetadata> parameters;

  /// Whether the class has a const constructor
  final bool isConst;

  /// Whether the class implements the Diagnosticable mixin
  final bool isDiagnosticable;

  /// The constructor to use for code generation
  final ConstructorElement constructor; // ignore: deprecated_member_use

  /// Whether the class is abstract
  final bool isAbstract;

  const BaseMetadata({
    required this.element,
    required this.name,
    required this.parameters,
    required this.isConst,
    required this.isDiagnosticable,
    required this.constructor,
    required this.isAbstract,
  });

  /// Gets the constructor reference for code generation (empty or .name)
  String get constructorRef =>
      constructor.name.isEmpty ? '' : '.${constructor.name}';

  /// Checks if the class has a specific method
  bool hasMethod(String methodName) =>
      element.methods.any((m) => m.name == methodName);
}

extension GeneratedFlagExtension on int {
  bool hasFlag(int flag) => (this & flag) != 0;
}
