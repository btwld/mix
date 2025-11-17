// lib/src/utils/type_utilities.dart
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:logging/logging.dart';

import 'extensions.dart';

//------------------------------------------------------------------------------
// CORE TYPE UTILITIES
//------------------------------------------------------------------------------

/// Core type utility functions for working with the Dart analyzer.
///
/// This class provides reusable functionality for resolving and analyzing types
/// that are common across all code generation use cases.
class TypeUtils {
  static final _logger = Logger('TypeUtils');

  const TypeUtils._();

  /// Resolves a [DartType] to its corresponding [ClassElement] when possible.
  ///
  /// This handles interface types directly and attempts to resolve type parameters
  /// to their bounds.
  ///
  /// Returns null if the type cannot be resolved to a class element.
  static ClassElement? resolveTypeToClass(DartType type) {
    try {
      if (type is InterfaceType) {
        return type.element as ClassElement;
      } else if (type is TypeParameterType && type.element.bound != null) {
        // For generic type parameters, try to resolve the bound
        return resolveTypeToClass(type.element.bound!);
      }

      return null;
    } catch (e) {
      _logger.warning('Failed to resolve type to class: $type', e);

      return null;
    }
  }

  /// Gets all type arguments for a type
  static List<DartType> getTypeArguments(DartType type) {
    if (type is InterfaceType) {
      return type.typeArguments;
    }

    return const [];
  }

  static bool hasDefaultValueMixin(ClassElement element) {
    // Check for a direct implementation of the mixin
    bool hasDirectMixin = element.mixins.any((mixin) {
      final name = mixin.element.name;

      return name == 'HasDefaultValue' || name.startsWith('HasDefaultValue<');
    });

    if (hasDirectMixin) return true;

    // Recursively check supertypes for the mixin
    for (final supertype in element.allSupertypes) {
      if (supertype.element is ClassElement) {
        if (hasDefaultValueMixin(supertype.element as ClassElement)) {
          return true;
        }
      }
    }

    // Check if any of the interfaces is the HasDefaultValue mixin
    bool hasInterfaceMixin = element.interfaces.any((interface) {
      final name = interface.element.name;

      return name == 'HasDefaultValue' ||
          interface.getTypeAsString().contains('HasDefaultValue<');
    });

    return hasDirectMixin || hasInterfaceMixin;
  }

  /// Finds a specific supertype of a class by name.
  ///
  /// Returns the [InterfaceType] of the supertype if found, or null otherwise.
  static InterfaceType? findSupertype(Element element, String typeName) {
    if (element is InterfaceElement) {
      try {
        return element.allSupertypes.firstWhereOrNull(
          (supertype) => supertype.element.name == typeName,
        );
      } catch (e) {
        _logger.warning(
          'Failed to find supertype $typeName in ${element.name}',
          e,
        );

        return null;
      }
    }

    return null;
  }

  /// Extracts a generic type argument from a specific supertype.
  ///
  /// This is particularly useful for working with base classes or interfaces that
  /// use generics, such as `BaseClass<T>`.
  ///
  /// Returns null if the supertype is not found or has no type arguments.
  static DartType? getGenericFromSupertype(
    ClassElement element,
    String typeName, {
    int argumentIndex = 0,
  }) {
    try {
      final supertype = findSupertype(element, typeName);
      if (supertype == null ||
          supertype.typeArguments.isEmpty ||
          argumentIndex >= supertype.typeArguments.length) {
        return null;
      }

      final typeArgument = supertype.typeArguments[argumentIndex];

      // If it's a type parameter, try to resolve it to its bound
      if (typeArgument is TypeParameterType) {
        return typeArgument.bound;
      }

      return typeArgument;
    } catch (e) {
      _logger.warning(
        'Failed to get generic type from supertype $typeName in ${element.name}',
        e,
      );

      return null;
    }
  }

  /// Resolves a generic type to its concrete type.
  ///
  /// If the type is a type parameter, this will try to resolve it to its bound.
  /// If the type is an interface type, it will return the type as is.
  static DartType? resolveGenericType(DartType type) {
    if (type is TypeParameterType) {
      // If the type is a generic type parameter, resolve its bound
      var bound = type.element.bound;
      if (bound != null) {
        return resolveGenericType(bound);
      }

      return null;
    } else if (type is InterfaceType) {
      // If the type is an interface type, return it as the resolved type
      return type;
    }

    return null;
  }

  //----------------------------------------------------------------------------
  // MIX-SPECIFIC TYPE UTILITIES
  //----------------------------------------------------------------------------

  /// Gets the resolved type from a DTO.
  ///
  /// If the input type is a List of DTOs, this will return a List of the
  /// extracted DTO type arguments.
  static String getResolvedTypeFromDto(DartType type) {
    final isList = type.isList;
    DartType resolvedType = type;

    if (isList && type.firstTypeArgument != null) {
      resolvedType = type.firstTypeArgument!;
    }

    if (isResolvable(resolvedType)) {
      final dtoType = extractDtoTypeArgument(resolvedType.asClassElement!);
      if (dtoType != null) {
        resolvedType = dtoType;
      }
    }

    if (isList) {
      return 'List<${resolvedType.getTypeAsString()}>';
    }

    return resolvedType.getDisplayString(withNullability: false);
  }

  /// Checks if a type is a Dto.
  static bool isResolvable(DartType type) {
    if (type.element == null) return false;

    if (type.isList) {
      return isResolvable(type.firstTypeArgument!);
    }

    return findSupertype(type.element!, $Mixable) != null;
  }

  /// Checks if a type is a Spec.
  static bool isSpec(DartType type) {
    if (type.element == null) return false;

    return findSupertype(type.element!, $Spec) != null;
  }

  /// Checks if an element is from the Mix package.
  static bool isMixRef(InterfaceElement element) {
    return element.source.uri.scheme == _mixUri.scheme &&
        element.source.uri.path.startsWith(_mixUri.path);
  }

  /// Extracts the type argument from a Dto class.
  ///
  /// For example, if the class is UserDto extends Dto\<User>,
  /// this will return the User type.
  static DartType? extractDtoTypeArgument(ClassElement classElement) {
    try {
      // Check if the class itself is Dto<T>
      if (classElement.name == $Mixable &&
          classElement.typeParameters.length == 1) {
        final typeArgument = classElement.thisType.typeArguments.first;

        return resolveGenericType(typeArgument);
      }

      // Traverse the class hierarchy
      for (final interface in classElement.allSupertypes) {
        if (interface.element.name == $Mixable) {
          final typeArguments = interface.typeArguments;
          if (typeArguments.length == 1) {
            final typeArgument = typeArguments.first;

            return resolveGenericType(typeArgument);
          }
        }
      }

      return null;
    } catch (e) {
      _logger.warning(
        'Failed to extract Mixable type argument from ${classElement.name}',
        e,
      );

      return null;
    }
  }

  /// Checks if a type is assignable to another type.
  ///
  /// This is a utility method to check if one type can be assigned to another.
  /// It's similar to the isAssignableTo method on DartType, but handles null cases.
  static bool isAssignableTo(DartType? type, DartType? targetType) {
    if (type == null || targetType == null) return false;

    if (type is InterfaceType && targetType is InterfaceType) {
      return type.element.thisType.isAssignableTo(targetType);
    }

    return false;
  }

  //----------------------------------------------------------------------------
  // TYPE AVAILABILITY UTILITIES
  //----------------------------------------------------------------------------

  /// Checks if a type is available in the current context for code generation.
  ///
  /// This method determines if a type can be safely used in generated code by checking:
  /// 1. If it's a primitive or core Dart type (always available)
  /// 2. If it's from a known problematic package (like vector_math)
  /// 3. If it can be properly resolved by the analyzer
  /// 4. If it's from a library that's likely to be available (Flutter, dart:ui, etc.)
  ///
  /// Returns true if the type is available, false otherwise.
  static bool isTypeAvailable(DartType type) {
    final typeName = type.getDisplayString(withNullability: false);

    // Known problematic types that should be skipped
    final knownProblematicTypes = [
      'Vector3', 'Vector4', 'Quaternion',
      // Add other known problematic types here
    ];

    if (knownProblematicTypes.contains(typeName)) {
      _logger.fine('Skipping known problematic type: $typeName');

      return false;
    }

    // Primitive and core types are always available
    if (type.isDartCoreBool ||
        type.isDartCoreDouble ||
        type.isDartCoreInt ||
        type.isDartCoreString ||
        type.isDartCoreList ||
        type.isDartCoreMap ||
        type.isDartCoreSet ||
        type.isDartCoreIterable ||
        type.isDartCoreFunction ||
        type.isDartCoreObject) {
      return true;
    }

    // Check if the type element is available
    if (type.element == null) {
      _logger.fine('Type element not available for: $typeName');

      return false;
    }

    // Check if the type is from a library that's likely to be available
    final element = type.element;
    if (element != null && element.library != null) {
      final libraryUri = element.library!.source.uri.toString();

      // Safe libraries that are likely to be available
      final safeLibraries = [
        'dart:core',
        'dart:ui',
        'dart:async',
        'dart:collection',
        'dart:convert',
        'dart:math',
        'package:flutter/',
      ];

      // Problematic libraries that might not be available
      final problematicLibraries = [
        'dart:ffi',
        'dart:js',
        'dart:io',
        'package:vector_math/',
      ];

      // Check if the library is in the problematic list
      for (final lib in problematicLibraries) {
        if (libraryUri.startsWith(lib)) {
          _logger.fine(
            'Type from problematic library: $typeName ($libraryUri)',
          );

          return false;
        }
      }

      // Check if the library is in the safe list
      for (final lib in safeLibraries) {
        if (libraryUri.startsWith(lib)) {
          return true;
        }
      }

      // For other libraries, try to resolve the type
      try {
        final resolvedType = resolveTypeToClass(type);

        return resolvedType != null;
      } catch (e) {
        _logger.fine('Failed to resolve type: $typeName', e);

        return false;
      }
    }

    // Default to false for safety
    return false;
  }

  /// Checks if all parameter types in a list are available in the current context.
  ///
  /// This is useful for determining if a constructor can be safely used in generated code.
  /// Returns true if all parameter types are available, false otherwise.
  static bool areAllParameterTypesAvailable(List<ParameterElement> parameters) {
    for (var param in parameters) {
      if (param.isPrivate) return false;
      if (!isTypeAvailable(param.type)) {
        return false;
      }
    }

    return true;
  }

  /// Removes the 'Utility' suffix from a type name if present
  static String removeUtilitySuffix(String typeName) {
    if (typeName.endsWith('Utility')) {
      return typeName.substring(0, typeName.length - 'Utility'.length);
    }

    return typeName;
  }

  /// Removes the 'Dto' suffix from a type name if present
  static String removeDtoSuffix(String typeName) {
    if (typeName.endsWith('Dto')) {
      return typeName.substring(0, typeName.length - 'Dto'.length);
    }

    return typeName;
  }
}

//------------------------------------------------------------------------------
// CONSTANTS AND HELPER REFERENCES
//------------------------------------------------------------------------------

/// URI for Mix package
final Uri _mixUri = Uri(scheme: 'package', path: 'mix/');

/// Class name constants used throughout the code generator

const $Spec = 'Spec';

const $Mixable = 'Mixable';

/// References to Mix helper functions used in generated code.
///
/// These references point to the actual implementation of helper functions
/// provided by the Mix framework.
class MixHelperRef {
  const MixHelperRef._();

  static String get _refName => 'MixOps';

  /// Reference to the deep equality function.
  static String get deepEquality => '$_refName.deepEquality';

  /// Reference to the general interpolation function.
  static String get lerp => '$_refName.lerp';

  /// Reference to the list merging function.
  static String get mergeList => '$_refName.mergeList';
}

class ClassMemberCollection {
  final List<FieldElement> fields;
  final List<PropertyAccessorElement> accessors;
  final Map<String, FieldElement> fieldsByName;
  final Map<String, PropertyAccessorElement> accessorsByName;

  ClassMemberCollection({required this.fields, required this.accessors})
    : fieldsByName = {for (var f in fields) f.name: f},
      accessorsByName = {for (var a in accessors) a.name: a};

  /// Get a field by name, returns null if not found
  FieldElement? getField(String name) => fieldsByName[name];

  /// Get an accessor by name, returns null if not found
  PropertyAccessorElement? getAccessor(String name) => accessorsByName[name];
}

/// Collects all fields and accessors from a class and its superclasses
ClassMemberCollection collectClassMembers(InterfaceElement classElement) {
  final fields = <FieldElement>[];
  final accessors = <PropertyAccessorElement>[];
  final processedClasses = <String>{};

  void processClass(InterfaceElement element) {
    // Skip if already processed to avoid duplicates
    final elementId = element.displayName;
    if (processedClasses.contains(elementId)) return;
    processedClasses.add(elementId);

    // Add fields and accessors from this class
    fields.addAll(element.fields);
    accessors.addAll(element.accessors);

    // Process superclass if exists
    if (element.supertype != null &&
        element.supertype!.element.name != 'Object') {
      processClass(element.supertype!.element);
    }

    // Process mixins
    for (final mixin in element.mixins) {
      processClass(mixin.element);
    }

    // Process interfaces if needed
    // Uncomment if you need interface members too
    /*
    for (final interface in element.interfaces) {
      processClass(interface.element);
    }
    */
  }

  processClass(classElement);

  return ClassMemberCollection(fields: fields, accessors: accessors);
}
