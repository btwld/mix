import '../metadata/property_metadata.dart';
import '../utils/code_builder.dart';
import '../utils/utility_code_generator.dart';

class MixableTypeUtilityBuilder implements CodeBuilder {
  final MixableTypeMetadata metadata;

  const MixableTypeUtilityBuilder(this.metadata);

  @override
  String build() {
    final dtoName = metadata.name;
    final resolvedTypeName = metadata.resolvedElement.name;

    final utilityName = '${resolvedTypeName}Utility';

    // Generate utility fields using UtilityCodeGenerator:
    final generatedFields = UtilityCodeGenerator.generateUtilityFields(
      dtoName,
      metadata.parameters,
    );

    // Build your class using a ClassBuilder or do it manually:
    final classBuilder = ClassBuilder(
      className: utilityName,
      documentation:
          '''
/// Utility class for configuring [$resolvedTypeName] properties.
///
/// This class provides methods to set individual properties of a [$resolvedTypeName].
/// Use the methods of this class to configure specific properties of a [$resolvedTypeName].
''',
      extendsClass: 'DtoUtility<T, $dtoName, $resolvedTypeName>',
      typeParameters: '<T extends StyleElement>',
      constructorCode:
          '$utilityName(super.builder) : super(valueToDto: (v) => v.toDto());',

      // The fields you want in the generated class
      fields: generatedFields,

      // The methods you want in the generated class, reintroducing call()
      methods: [
        UtilityCodeGenerator.generateUtilityFieldsFromClass(metadata.element),
        UtilityCodeGenerator.methodOnly(
          utilityType: dtoName,
          fields: metadata.parameters,
        ),
        UtilityCodeGenerator.methodCall(metadata.parameters),
      ],
    );

    return classBuilder.build();
  }
}
