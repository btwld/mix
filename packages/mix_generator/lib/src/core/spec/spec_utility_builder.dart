import '../metadata/spec_metadata.dart';
import '../utils/code_builder.dart';
import '../utils/utility_code_generator.dart';

class SpecUtilityBuilder implements CodeBuilder {
  final SpecMetadata metadata;

  const SpecUtilityBuilder(this.metadata);

  @override
  String build() {
    final specName = metadata.name;
    final attributeName = '${specName}Attribute';
    final utilityName = '${specName}MutableStyler';

    // Generate utility fields using UtilityCodeGenerator:
    final generatedFields = UtilityCodeGenerator.generateUtilityFields(
      attributeName,
      metadata.parameters,
    );

    // Build your class using a ClassBuilder or do it manually:
    final classBuilder = ClassBuilder(
      className: utilityName,
      documentation: '''
/// Utility class for configuring [$specName] properties.
///
/// This class provides methods to set individual properties of a [$specName].
/// Use the methods of this class to configure specific properties of a [$specName].
''',
      extendsClass: 'SpecUtility<T, $attributeName>',
      typeParameters: '<T extends SpecAttribute>',
      constructorCode: '''$utilityName(
    super.builder, {
    @Deprecated(
      'mutable parameter is no longer used. All SpecUtilities are now mutable by default.',
    )
    super.mutable,
  });''',

      // The fields you want in the generated class
      fields: generatedFields,

      // The methods you want in the generated class, reintroducing call()
      methods: [
        UtilityCodeGenerator.chainGetter(utilityName),
        UtilityCodeGenerator.selfGetter(utilityName, attributeName),
        UtilityCodeGenerator.methodOnly(
          utilityType: attributeName,
          fields: metadata.parameters,
        ),
      ],
    );

    return classBuilder.build();
  }
}
