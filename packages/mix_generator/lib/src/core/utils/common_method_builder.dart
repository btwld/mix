import '../metadata/field_metadata.dart';

class CommonMethods {
  const CommonMethods._();

  /// Generates a props getter for equality comparison
  static String generatePropsGetter({
    required String className,
    required List<ParameterMetadata> fields,
    required bool useInternalRef,
  }) {
    final propsFields = fields.map((field) {
      final fieldRef = useInternalRef ? field.asInternalRef : field.name;

      return '$fieldRef,';
    }).join('\n');

    return '''
  /// The list of properties that constitute the state of this [$className].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [$className] instances for equality.
  @override
  List<Object?> get props => [
$propsFields
    ];''';
  }

  /// Generates a debugFillProperties method
  static String generateDebugFillPropertiesMethod({
    required List<ParameterMetadata> fields,
    required bool useInternalRef,
  }) {
    final propertyStatements = fields.map((field) {
      final fieldName = field.name;
      final fieldRef = useInternalRef ? field.asInternalRef : fieldName;

      return 'properties.add(DiagnosticsProperty(\'$fieldName\', $fieldRef, defaultValue: null));';
    }).join('\n    ');

    final methodName =
        useInternalRef ? '_debugFillProperties' : 'debugFillProperties';
    final superCall =
        useInternalRef ? '' : 'super.debugFillProperties(properties);\n    ';

    final override = useInternalRef ? '' : '@override';

    return '''
  $override
  void $methodName(DiagnosticPropertiesBuilder properties) {
    $superCall$propertyStatements
  }''';
  }
}
