import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';

import 'dart_type_utils.dart';

//------------------------------------------------------------------------------
// DART TYPE EXTENSIONS
//------------------------------------------------------------------------------

/// Extension methods on [DartType] to simplify common type operations.
extension DartTypeExtensions on DartType {
  /// Gets a string representation of this type without nullability.
  String getTypeAsString() {
    return getDisplayString(withNullability: false);
  }

  /// Whether this type is nullable (has a ? suffix).
  bool get isNullable => nullabilitySuffix == NullabilitySuffix.question;

  /// Whether this type is a Dart core List.
  bool get isList {
    if (this is! InterfaceType) return false;
    final element = (this as InterfaceType).element;

    return element.name == 'List' && element.library.name == 'dart.core';
  }

  /// Whether this type is a Dart core Map.
  bool get isMap {
    if (this is! InterfaceType) return false;
    final element = (this as InterfaceType).element;

    return element.name == 'Map' && element.library.name == 'dart.core';
  }

  /// Whether this type is a Dart core Set.
  bool get isSet {
    if (this is! InterfaceType) return false;
    final element = (this as InterfaceType).element;

    return element.name == 'Set' && element.library.name == 'dart.core';
  }

  /// Whether this type is a Future.
  bool get isFuture {
    if (this is! InterfaceType) return false;
    final element = (this as InterfaceType).element;

    return element.name == 'Future' && element.library.name == 'dart.async';
  }

  /// Whether this type is a Stream.
  bool get isStream {
    if (this is! InterfaceType) return false;
    final element = (this as InterfaceType).element;

    return element.name == 'Stream' && element.library.name == 'dart.async';
  }

  /// Checks if this type is assignable to another type.
  bool isAssignableTo(DartType other) {
    if (this is! InterfaceType || element is! ClassElement) {
      return false;
    }

    final classElement = element as ClassElement;
    final library = classElement.library;

    return library.typeSystem.isAssignableTo(this, other);
  }

  /// Gets the first type argument if this is a generic type.
  DartType? get firstTypeArgument {
    if (this is InterfaceType) {
      final typeArguments = (this as InterfaceType).typeArguments;
      if (typeArguments.isNotEmpty) {
        return typeArguments.first;
      }
    }

    return null;
  }

  /// Gets all type arguments for this type.
  List<DartType> get typeArguments {
    if (this is InterfaceType) {
      return (this as InterfaceType).typeArguments;
    }

    return const [];
  }

  /// Gets this type with nullability removed.
  DartType get nonNullable {
    if (isNullable && this is InterfaceType) {
      return (this as InterfaceType).element.thisType;
    }

    return this;
  }

  /// Attempts to resolve this type to a [ClassElement].
  ClassElement? get asClassElement => TypeUtils.resolveTypeToClass(this);

  /// Checks if this type is an enum
  bool get isEnum {
    final element = this.element;

    return element is EnumElement;
  }
}

//------------------------------------------------------------------------------
// CLASS ELEMENT EXTENSIONS
//------------------------------------------------------------------------------

/// Extension methods on [ClassElement] for common operations.
extension ClassElementExtensions on ClassElement {
  /// Checks if this class implements or extends a class with the given name.
  bool implementsOrExtends(String className) {
    if (name == className) return true;

    return allSupertypes.any((type) => type.element.name == className);
  }

  /// Gets the names of all fields declared in this class and its superclasses.
  Set<String> get allFieldNames {
    final result = <String>{};

    // Add fields from this class
    result.addAll(fields.map((f) => f.name));

    // Add fields from superclasses
    var superClass = supertype?.element as ClassElement?;
    while (superClass != null && !superClass.isDartCoreObject) {
      result.addAll(superClass.fields.map((f) => f.name));
      superClass = superClass.supertype?.element as ClassElement?;
    }

    return result;
  }

  /// Gets the names of all methods declared in this class and its superclasses.
  Set<String> get allMethodNames {
    final result = <String>{};

    // Add methods from this class
    result.addAll(methods.map((m) => m.name));

    // Add methods from superclasses
    var superClass = supertype?.element as ClassElement?;
    while (superClass != null && !superClass.isDartCoreObject) {
      result.addAll(superClass.methods.map((m) => m.name));
      superClass = superClass.supertype?.element as ClassElement?;
    }

    return result;
  }

  /// Gets all fields declared in this class and its superclasses.
  List<FieldElement> get allFields {
    final result = <FieldElement>[];

    // Add fields from this class
    result.addAll(fields);

    // Add fields from superclasses
    var superClass = supertype?.element as ClassElement?;
    while (superClass != null && !superClass.isDartCoreObject) {
      result.addAll(superClass.fields);
      superClass = superClass.supertype?.element as ClassElement?;
    }

    return result;
  }

  /// Gets all methods declared in this class and its superclasses.
  List<MethodElement> get allMethods {
    final result = <MethodElement>[];

    // Add methods from this class
    result.addAll(methods);

    // Add methods from superclasses
    var superClass = supertype?.element as ClassElement?;
    while (superClass != null && !superClass.isDartCoreObject) {
      result.addAll(superClass.methods);
      superClass = superClass.supertype?.element as ClassElement?;
    }

    return result;
  }

  /// Gets the generated name for this class
  String get generatedName => '_\$$name';
}

//------------------------------------------------------------------------------
// STRING EXTENSIONS
//------------------------------------------------------------------------------

/// Extension methods for String
extension StringExtension on String {
  /// Converts a string to snake_case
  String get snakecase {
    final result = StringBuffer();
    for (var i = 0; i < length; i++) {
      final char = this[i];
      if (i > 0 && char.toUpperCase() == char) {
        result.write('_');
      }
      result.write(char.toLowerCase());
    }

    return result.toString();
  }
}
