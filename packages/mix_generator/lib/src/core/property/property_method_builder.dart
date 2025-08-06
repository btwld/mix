import 'package:analyzer/dart/element/element.dart';

import '../metadata/field_metadata.dart';
import '../utils/extensions.dart';
import '../utils/helpers.dart';
import '../utils/string_utils.dart';

/// Utility to extract default values from constructor parameters
Map<String, String?> extractConstructorDefaults(
  List<ParameterElement> parameters,
) {
  final defaults = <String, String?>{};

  for (final param in parameters) {
    // Check if parameter has a default value
    if (param.hasDefaultValue && param.defaultValueCode != null) {
      defaults[param.name] = param.defaultValueCode;
    }
    // If it's a required parameter with no default value and is a list type, set empty list as default
    else if (param.isRequired && param.type.isList) {
      defaults[param.name] = '[]';
    }
  }

  return defaults;
}

class MixableTypeMethods {
  const MixableTypeMethods._();

  /// Generates a resolve method implementation
  static String generateResolveMethod({
    required String className,
    required String constructorRef,
    required List<ParameterMetadata> fields,
    required bool isConst,
    required String resolvedType,
    required bool useInternalRef,
    Map<String, String?>? constructorDefaults,
    bool hasDefaultValue = false,
  }) {
    final params = buildParameters(fields, (field) {
      final fieldName = useInternalRef ? field.asInternalRef : field.name;

      // Special handling for AnimationConfigDto
      if (field.resolvable?.type == 'AnimationConfigDto') {
        return '$fieldName?.resolve(mix) ?? mix.animation';
      }

      // Prepare fallback expressions in order of priority:
      // 1. If the field is nullable, try to use constructor default if available
      // 2. If the type has HasDefaultValue mixin, use defaultValue.fieldName

      // Default value from constructor if available
      final constructorDefault =
          (field.nullable &&
              constructorDefaults != null &&
              constructorDefaults.containsKey(field.name))
          ? ' ?? ${constructorDefaults[field.name]!}'
          : '';

      // Default value from HasDefaultValue mixin if available
      final defaultValueFallback = hasDefaultValue
          ? ' ?? defaultValue.${field.name}'
          : '';

      // Combine fallbacks in order of priority
      final fallbackExpression = hasDefaultValue
          ? defaultValueFallback
          : constructorDefault;

      if (field.isListType) {
        // Check if the list elements are resolvable
        if (field.isDtoListType || field.hasResolvable) {
          return '$fieldName?.map((e) => e.resolve(mix)).toList()$fallbackExpression';
        }

        return '$fieldName$fallbackExpression';
      }

      if (field.hasResolvable) {
        return '$fieldName?.resolve(mix)$fallbackExpression';
      }

      return '$fieldName$fallbackExpression';
    });

    final constIgnoreRule = fields.isEmpty && isConst
        ? '// ignore: prefer_const_constructors'
        : '';

    const defaultValueRef = 'defaultValue';

    return '''
  /// Resolves to [$resolvedType] using the provided [MixContext].
  /// 
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `$defaultValueRef` for that property.
  ///
  /// ```dart
  /// final ${resolvedType.lowerCaseFirst} = $className(...).resolve(mix);
  /// ```
  @override
  $resolvedType resolve(BuildContext mix) {
  $constIgnoreRule
    return $resolvedType$constructorRef(
      $params
    );
  }''';
  }

  /// Generates a merge method implementation
  static String generateMergeMethod({
    required String className,
    required List<ParameterMetadata> fields,
    required bool isAbstract,
    required bool shouldMergeLists,
    required bool useInternalRef,
    String constructorRef = '',
  }) {
    final mergeStatements = fields
        .map((field) {
          final fieldName = field.name;
          final fieldNameRef = useInternalRef ? field.asInternalRef : fieldName;

          // Handle list fields with proper null-aware spread
          if (field.isListType) {
            // Check if the field has a default value (not nullable)
            final hasDefaultValue = !field.nullable;
            final spreadOperator = hasDefaultValue ? '...' : '...?';

            return shouldMergeLists
                ? '$fieldName: MixOps.mergeList($fieldNameRef, other.$fieldName),'
                : '$fieldName: [$spreadOperator $fieldNameRef, $spreadOperator other.$fieldName],';
          } else if (field.hasResolvable) {
            final resolvable = field.resolvable;
            // Build a default merge statement using the merge() method if available
            final defaultMerge =
                '$fieldName: $fieldNameRef?.merge(other.$fieldName) ?? other.$fieldName,';

            // Extract the element from the representation type (if it exists)

            if (resolvable == null) {
              return defaultMerge;
            }

            if (resolvable.tryToMergeType) {
              return '$fieldName: ${resolvable.type}.tryToMerge($fieldNameRef, other.$fieldName),';
            }

            return defaultMerge;
          }

          // Default: use the value from other if non-null, otherwise fallback to this value

          return '$fieldName: other.$fieldName ?? $fieldNameRef,';
        })
        .join('\n');

    final thisRef = useInternalRef ? '_\$this' : 'this';

    // Use the constructor reference directly
    final returnCode = fields.isEmpty
        ? 'other'
        : '$className$constructorRef($mergeStatements)';

    return '''
    /// Merges the properties of this [$className] with the properties of [other].
    ///
    /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
    /// [$className] with the properties of [other] taking precedence over 
    /// the corresponding properties of this instance.
    ///
    /// Properties from [other] that are null will fall back
    /// to the values from this instance.
    @override
    $className merge(${isAbstract ? 'covariant ' : ''}$className? other) {
      if (other == null) return $thisRef;

      return $returnCode;
    }''';
  }
}
