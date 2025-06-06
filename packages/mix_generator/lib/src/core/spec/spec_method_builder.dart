import 'package:analyzer/dart/element/element.dart';

import '../metadata/field_metadata.dart';
import '../utils/dart_type_utils.dart';
import '../utils/helpers.dart';

/// Utilities for generating common method implementations.
class SpecMethods {
  const SpecMethods._();

  /// Generates a copyWith method
  static String generateCopyWithMethod({
    required String className,
    required String constructorRef,
    required List<ParameterMetadata> fields,
    required bool isConst,
    required bool useInternalRef,
  }) {
    final params = buildParameters(fields, (field) {
      final fieldName =
          useInternalRef ? field.asInternalRef : 'this.${field.name}';

      return '${field.name} ?? $fieldName';
    });

    final optionalParams = buildArguments(
      fields,
      (field) => '${field.type}? ${field.name}',
    );

    final constModifier = fields.isEmpty && isConst ? 'const ' : '';

    return '''
  /// Creates a copy of this [$className] but with the given fields
  /// replaced with the new values.
  @override
  $className copyWith($optionalParams) {
    return $constModifier$className$constructorRef(
      $params
    );
  }''';
  }

  /// Generates a lerp method
  static String generateLerpMethod({
    required String className,
    required String constructorRef,
    required List<ParameterMetadata> fields,
    required bool isConst,
    required bool useInternalRef,
  }) {
    final thisRef = useInternalRef ? '_\$this' : 'this';

    // Categorize fields by interpolation method
    final Map<String, List<String>> lerpMethods = {};
    final List<String> stepMethodFields = [];

    for (final field in fields) {
      final lerpMethod = _getLerpMethodName(field);
      if (lerpMethod != null) {
        lerpMethods.putIfAbsent(lerpMethod, () => []).add(field.name);
      } else {
        stepMethodFields.add(field.name);
      }
    }

    // Build lerp expressions for each field
    final lerpStatements = buildParameters(
      fields,
      (field) => _getLerpExpression(field, useInternalRef),
    );

    // Generate the documentation for the method
    final lerpMethodsDocs = lerpMethods.entries
        .map((e) =>
            '/// - [${e.key}] for ${e.value.map((name) => '[$name]').join(' and ')}.\n')
        .join();

    final stepMethodDocs = stepMethodFields.isEmpty
        ? ''
        : '''/// For ${stepMethodFields.map((e) => '[$e]').join(' and ')}, the interpolation is performed using a step function.
/// If [t] is less than 0.5, the value from the current [$className] is used. Otherwise, the value
/// from the [other] [$className] is used.
///''';

    final constKeyword = (fields.isEmpty && isConst) ? 'const ' : '';

    final constructorCall = '$constKeyword$className$constructorRef';

    return '''
/// Linearly interpolates between this [$className] and another [$className] based on the given parameter [t].
///
/// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
/// When [t] is 0.0, the current [$className] is returned. When [t] is 1.0, the [other] [$className] is returned.
/// For values of [t] between 0.0 and 1.0, an interpolated [$className] is returned.
///
/// If [other] is null, this method returns the current [$className] instance.
///
/// The interpolation is performed on each property of the [$className] using the appropriate
/// interpolation method:
$lerpMethodsDocs$stepMethodDocs
/// This method is typically used in animations to smoothly transition between
/// different [$className] configurations.
  @override
  $className lerp($className? other, double t) {
    if (other == null) return $thisRef;

    return $constructorCall($lerpStatements);
  }
''';
  }
}

/// Generates the lerp expression for a single field
String _getLerpExpression(ParameterMetadata field, bool isInternalRef) {
  // Special handling for AnimatedData to preserve callbacks
  if (field.name == 'animated' || field.type == 'AnimatedData' || field.type == 'AnimatedData?') {
    final thisFieldName = isInternalRef ? field.asInternalRef : field.name;
    final otherFieldName = 'other.${field.name}';
    return '$thisFieldName ?? $otherFieldName';
  }
  
  if (!field.annotation.isLerpable) {
    return 'other.${field.name}';
  }

  final thisFieldName = isInternalRef ? field.asInternalRef : field.name;
  final otherFieldName = 'other.${field.name}';
  final stepExpression = 't < 0.5 ? $thisFieldName : $otherFieldName';

  // If the field is a Spec type, use its lerp method
  if (field.isSpec) {
    final nullableDot = field.nullable ? '?' : '';
    final nullFallback = field.nullable ? ' ?? $otherFieldName' : '';

    return '$thisFieldName$nullableDot.lerp($otherFieldName, t)$nullFallback';
  }

  // If no element is available, use step interpolation
  if (field.dartType.element == null) {
    return stepExpression;
  }

  // Check if field type has an instance lerp method
  if (_hasInstanceLerpMethod(field.dartType.element)) {
    final nullableDot = field.nullable ? '?' : '';
    final nullFallback = field.nullable ? ' ?? $otherFieldName' : '';

    return '$thisFieldName$nullableDot.lerp($otherFieldName, t)$nullFallback';
  }

  final representationType = field.resolvable?.type;

  if (representationType != null) {
    if (field.isSpec) {
      return '$thisFieldName.lerp($otherFieldName, t)';
    }
  }

  // Check if field type has a static lerp method
  final lerpMethod = _getLerpMethodName(field);
  if (lerpMethod == null) {
    return stepExpression;
  }

  final forceNonNull = field.nullable ? '' : '!';

  return '$lerpMethod($thisFieldName, $otherFieldName, t)$forceNonNull';
}

/// Checks if the element or its mixins have an instance lerp method
bool _hasInstanceLerpMethod(Element? element) {
  if (element is! ClassElement) return false;

  // Check the class itself
  if (_hasLerpMethodWithSignature(element, isStatic: false)) return true;

  // Check mixins
  return element.mixins.any(
    (mixin) => _hasLerpMethodWithSignature(mixin.element, isStatic: false),
  );
}

/// Checks if the element or its supertypes have a static lerp method
bool _hasStaticLerpMethod(Element? element) {
  if (element is! ClassElement) return false;

  // Check the class and its supertypes
  final typesToCheck = [
    element,
    ...element.allSupertypes
        .where((type) => !type.isDartCoreObject)
        .map((type) => type.element),
  ];

  return typesToCheck
      .any((type) => _hasLerpMethodWithSignature(type, isStatic: true));
}

/// Checks if the element has a lerp method with the expected signature
bool _hasLerpMethodWithSignature(
  InterfaceElement element, {
  required bool isStatic,
}) {
  return element.methods.any((method) =>
      method.name == 'lerp' &&
      method.isPublic &&
      method.isStatic == isStatic &&
      method.parameters.length == (isStatic ? 3 : 2) &&
      method.parameters.last.type.isDartCoreDouble);
}

/// Gets the appropriate lerp method name for a field
String? _getLerpMethodName(ParameterMetadata field) {
  // If the field is not lerpable, return null immediately
  if (!field.annotation.isLerpable) {
    return null;
  }

  // Special case handling
  if (field.type == 'TextStyle') {
    return MixHelperRef.lerpTextStyle;
  }

  // Check if the field is a Spec type
  if (field.isSpec) {
    return '${field.type}.lerp';
  }

  // Check if the field has a custom lerp method
  if (_hasStaticLerpMethod(field.dartType.element)) {
    return '${field.type}.lerp';
  }

  // Known types with standard lerp methods
  return switch (field.type) {
    'double' => MixHelperRef.lerpDouble,
    'Matrix4' => MixHelperRef.lerpMatrix4,
    'StrutStyle' => MixHelperRef.lerpStrutStyle,
    'List<Shadow>' => MixHelperRef.lerpShadowList,
    _ => null,
  };
}
