import '../metadata/spec_metadata.dart';
import '../resolvable/resolvable_method_builder.dart';
import '../utils/code_builder.dart';
import '../utils/common_method_builder.dart';
import '../utils/helpers.dart';

/// Builds the attribute class for a spec.
class SpecAttributeBuilder implements CodeBuilder {
  final SpecMetadata metadata;

  const SpecAttributeBuilder(this.metadata);

  /// Builds the field declarations
  List<String> _buildFieldDeclarations() {
    return metadata.parameters.where((field) => !field.isSuper).map((field) {
      final fieldType = field.resolvable?.type ?? field.type;

      return 'final $fieldType? ${field.name};';
    }).toList();
  }

  /// Builds the methods
  List<String> _buildMethods(String attributeName) {
    final methods = <String>[];

    // Add resolve method
    methods.add(ResolvableStyleMethods.generateResolveMethod(
      className: attributeName,
      constructorRef: '',
      fields: metadata.parameters,
      isConst: metadata.isConst,
      resolvedType: metadata.name,
      withDefaults: false,
      useInternalRef: false,
    ));

    // Add merge method
    methods.add(ResolvableStyleMethods.generateMergeMethod(
      className: attributeName,
      fields: metadata.parameters,
      isAbstract: metadata.isAbstract,
      shouldMergeLists: true,
      useInternalRef: false,
    ));

    // Add props getter
    methods.add(CommonMethods.generatePropsGetter(
      className: attributeName,
      fields: metadata.parameters,
      useInternalRef: false,
    ));

    // Add debug fill properties if needed
    if (metadata.isDiagnosticable) {
      methods.add(CommonMethods.generateDebugFillPropertiesMethod(
        fields: metadata.parameters,
        useInternalRef: false,
      ));
    }

    return methods;
  }

  @override
  String build() {
    final params = buildArguments(metadata.parameters, (field) {
      final fieldName = field.name;

      return field.isSuper ? 'super.$fieldName' : 'this.$fieldName';
    });

    final specName = metadata.name;
    final attributeName = metadata.attributeName;
    final extendsAttributeOfType = metadata.extendsAttributeOfType;

    // Build the class
    final classBuilder = ClassBuilder(
      className: attributeName,
      documentation: '''
/// Represents the attributes of a [$specName].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [$specName].
///
/// Use this class to configure the attributes of a [$specName] and pass it to
/// the [$specName] constructor.''',
      isFinal: false,
      isBase: false,
      extendsClass: extendsAttributeOfType,
      withMixins: metadata.isDiagnosticable ? ['Diagnosticable'] : [],
      constructorCode: 'const $attributeName($params);',
      fields: _buildFieldDeclarations(),
      methods: _buildMethods(attributeName),
    );

    return classBuilder.build();
  }
}
