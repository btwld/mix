import '../metadata/spec_metadata.dart';
import '../utils/code_builder.dart';

class SpecStyleBuilder implements CodeBuilder {
  final SpecMetadata metadata;

  const SpecStyleBuilder(this.metadata);

  @override
  String build() {
    final specName = metadata.name;
    final attributeName = '${specName}Attribute';
    final utilityName = '${specName}Utility';

    final styleName = specName.endsWith('Spec')
        ? 'Style${specName.substring(0, specName.length - 4)}'
        : 'Style$specName';

    // Build your class using a ClassBuilder or do it manually:
    final classBuilder = ClassBuilder(
      className: styleName,
      documentation: '''
/// A concrete implementation of [$utilityName] for creating a Style with a [$attributeName].
///
/// This class provides a convenient way to define styling properties and is designed
/// for direct usage in styling contexts.
''',
      extendsClass: '$utilityName<$attributeName>',
      constructorCode: '''$styleName() : super((v) => v);''',
    );

    return classBuilder.build();
  }
}
