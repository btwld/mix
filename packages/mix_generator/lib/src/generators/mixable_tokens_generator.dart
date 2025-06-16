import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import '../core/metadata/tokens_metadata.dart';
import '../core/utils/annotation_utils.dart';
import '../core/utils/base_generator.dart';

/// Generator for classes annotated with [MixableToken].
///
/// This generator produces:
/// - A token struct class with token definitions
/// - A method to convert token instances to token-value maps
/// - Optional utility extensions
/// - Optional build context extensions
class MixableTokensGenerator
    extends BaseMixGenerator<MixableToken, TokensMetadata> {
  // final Logger _logger = Logger('MixableTokensGenerator');

  MixableTokensGenerator() : super(const TypeChecker.fromRuntime(MixableToken));

  static String generateTokenCode(TokensMetadata metadata) {
    final tokensGenerator = MixableTokensGenerator();
    final output = StringBuffer();

    // Generate token struct
    output.writeln(tokensGenerator._generateTokenStruct(metadata));

    // Generate token to data method
    output.writeln(tokensGenerator._generateTokenToDataMethod(metadata));

    // Generate utility extension if enabled
    if (metadata.utilityExtension) {
      output.writeln(tokensGenerator._generateTokenUtilityExtension(metadata));
    }

    // Generate context extensions if enabled
    if (metadata.contextExtension) {
      output.writeln(tokensGenerator._generateBuildContextMethods(metadata));
      output.writeln(tokensGenerator._generateBuildContextExtension(metadata));
    }

    return output.toString();
  }

  // Helper methods for code generation

  String _generateTokenStruct(TokensMetadata metadata) {
    final settings = metadata.tokenSettings;
    final swatchTokens = metadata.swatchColorTokens;
    final tokenFields = metadata.tokenFields;

    final buffer = StringBuffer();
    buffer.writeln('class ${_kTokenStructName(metadata.name)} {');
    buffer.writeln('  ${_kTokenStructName(metadata.name)}();');
    buffer.writeln();

    for (final field in tokenFields) {
      final annotation = swatchTokens[field];
      if (annotation != null) {
        buffer.writeln(
          '  final ColorSwatchToken ${field.name} = ColorSwatchToken.scale(\'${field.name}\', ${annotation.scale});',
        );
      } else {
        buffer.writeln(
          '  final ${settings.token} ${field.name} = const ${settings.token}(\'${field.name}\');',
        );
      }
    }

    buffer.writeln('}');
    buffer.writeln();
    buffer.writeln(
      'final ${_kVariableStructName(metadata.name)} = ${_kTokenStructName(metadata.name)}();',
    );

    return buffer.toString();
  }

  String _generateTokenToDataMethod(TokensMetadata metadata) {
    final settings = metadata.tokenSettings;
    final typeStr = metadata.type.toString();
    final tokenFields = metadata.tokenFields;

    return '''

Map<${settings.token}, $typeStr> ${_kFunctionToMapName(metadata.name)}(${metadata.name} tokens) {
  return {
    ${tokenFields.map((e) => '${_kVariableStructName(metadata.name)}.${e.name}: tokens.${e.name},').join('\n    ')}
  };
}
''';
  }

  String _generateTokenUtilityExtension(TokensMetadata metadata) {
    final settings = metadata.tokenSettings;
    final swatchTokens = metadata.swatchColorTokens;
    final tokenFields = metadata.tokenFields;
    final buffer = StringBuffer();

    String generateMethod(FieldElement field) {
      final annotation = swatchTokens[field];

      if (annotation != null) {
        return 'T \$${field.name}([int step = ${annotation.defaultValue}]) => ref(${_kVariableStructName(metadata.name)}.${field.name}[step]);';
      }

      return 'T \$${field.name}() => ref(${_kVariableStructName(metadata.name)}.${field.name});';
    }

    for (final utility in settings.utilities) {
      buffer.writeln('''
extension ${_kUtilityExtensionName(metadata.name, utility)}<T extends StyleElement> on $utility<T> {
  ${tokenFields.map(generateMethod).join('\n  ')}
}
''');
    }

    return buffer.toString();
  }

  String _generateBuildContextMethods(TokensMetadata metadata) {
    final swatchTokens = metadata.swatchColorTokens;
    final tokenFields = metadata.tokenFields;

    String generateMethod(FieldElement field) {
      final annotation = swatchTokens[field];

      if (annotation != null) {
        return '${field.type} ${field.name}([int step = ${annotation.defaultValue}]) => ${_kVariableStructName(metadata.name)}.${field.name}[step].resolve(context);';
      }

      return '${field.type} ${field.name}() => ${_kVariableStructName(metadata.name)}.${field.name}.resolve(context);';
    }

    return '''
class ${_kBuildContextMethodsClassName(metadata.name)} {
  const ${_kBuildContextMethodsClassName(metadata.name)}(this.context);

  final BuildContext context;
  ${tokenFields.map(generateMethod).join('\n  ')}
}
''';
  }

  String _generateBuildContextExtension(TokensMetadata metadata) {
    final settings = metadata.tokenSettings;

    return '''
extension ${_kBuildContextExtensionName(metadata.name)} on BuildContext {
  ${_kBuildContextMethodsClassName(metadata.name)} get \$${metadata.namespace ?? settings.defaultNamespace} =>
      ${_kBuildContextMethodsClassName(metadata.name)}(this);
}
''';
  }

  @override
  Future<TokensMetadata> createMetadata(
    ClassElement element,
    BuildStep buildStep,
  ) async {
    validateClassElement(element);

    final annotation = readMixableToken(element);
    final metadata = TokensMetadata.fromAnnotation(element, annotation);
    metadata.validate();

    return metadata;
  }

  @override
  String generateForMetadata(TokensMetadata metadata, BuildStep buildStep) {
    final output = StringBuffer();

    // Generate token struct
    output.writeln(_generateTokenStruct(metadata));

    // Generate token to data method
    output.writeln(_generateTokenToDataMethod(metadata));

    // Generate utility extension if enabled
    if (metadata.utilityExtension) {
      output.writeln(_generateTokenUtilityExtension(metadata));
    }

    // Generate context extensions if enabled
    if (metadata.contextExtension) {
      output.writeln(_generateBuildContextMethods(metadata));
      output.writeln(_generateBuildContextExtension(metadata));
    }

    return output.toString();
  }

  @override
  bool get allowAbstractClasses => false;

  @override
  String get annotationName => 'MixableToken';
}

// Helper string formatters for consistent naming
String _kTokenStructName(String name) => '_\$${name}Struct';
String _kVariableStructName(String name) => '_struct$name';
String _kFunctionToMapName(String name) => '_\$${name}ToMap';
String _kUtilityExtensionName(String name, String utility) =>
    '\$$name${utility}X';
String _kBuildContextMethodsClassName(String name) =>
    'BuildContext${name}Methods';
String _kBuildContextExtensionName(String name) => '\$BuildContext${name}X';
