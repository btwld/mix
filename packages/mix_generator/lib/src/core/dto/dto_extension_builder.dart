import '../models/dto_metadata.dart';
import '../utils/code_builder.dart';
import '../utils/dart_type_utils.dart';
import '../utils/extensions.dart';

/// Builder for generating extension methods to convert between value types and DTOs.
class DtoExtensionBuilder extends CodeBuilder {
  /// The metadata for the DTO class
  final DtoMetadata metadata;

  /// Creates a new DtoExtensionBuilder
  DtoExtensionBuilder(this.metadata);

  @override
  String build() {
    final className = metadata.name;
    final resolvedTypeName = metadata.resolvedType.name;

    final fieldStatements = metadata.fields.map((field) {
      final fieldName = field.name;

      if (field.hasDto) {
        final resolvedFiieldType =
            TypeUtils.extractDtoTypeArgument(field.dartType.asClassElement!);
        final fieldNameRef =
            resolvedFiieldType?.isNullable == true ? '$fieldName?' : fieldName;

        if (field.isListType) {
          return '$fieldName: $fieldNameRef.map((e) => e.toDto()).toList(),';
        } else if (field.isMapType) {
          return '$fieldName: $fieldNameRef.map((k, v) => MapEntry(k, v.toDto())),';
        } else if (field.isSetType) {
          return '$fieldName: $fieldNameRef.map((e) => e.toDto()).toSet(),';
        }

        return '$fieldName: $fieldNameRef.toDto(),';
      }

      return '$fieldName: $fieldName,';
    }).join('\n      ');

    // Build the extension for the value type
    final valueExtension = '''
/// Extension methods to convert [$resolvedTypeName] to [$className].
extension ${resolvedTypeName}MixExt on $resolvedTypeName {
  /// Converts this [$resolvedTypeName] to a [$className].
  $className toDto() {
    return $className(
      $fieldStatements
    );
  }
}
''';

    // Build the extension for List<ValueType>
    final listExtension = '''
/// Extension methods to convert List<[$resolvedTypeName]> to List<[$className]>.
extension List${resolvedTypeName}MixExt on List<$resolvedTypeName> {
  /// Converts this List<[$resolvedTypeName]> to a List<[$className]>.
  List<$className> toDto() {
    return map((e) => e.toDto()).toList();
  }
}
''';

    return '$valueExtension\n$listExtension';
  }
}
