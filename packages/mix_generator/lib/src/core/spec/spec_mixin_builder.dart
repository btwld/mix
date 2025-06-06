import 'package:mix_annotations/mix_annotations.dart';

import '../metadata/base_metadata.dart';
import '../metadata/spec_metadata.dart';
import '../utils/code_builder.dart';
import '../utils/common_method_builder.dart';
import '../utils/string_utils.dart';
import 'spec_method_builder.dart';

/// Builds the mixin for a Spec class.
class SpecMixinBuilder implements CodeBuilder {
  final SpecMetadata metadata;

  const SpecMixinBuilder(this.metadata);

  /// Generates static methods for regular specs
  String _generateStaticMethods() {
    final className = metadata.name;
    final specAttributeName = '${className}Attribute';

    // Static from method to create from MixData
    final fromMethod = '''
static $className from(MixData mix) {
  return mix.attributeOf<$specAttributeName>()?.resolve(mix) ?? ${metadata.isConst ? 'const' : ''} $className${metadata.constructorRef}();
}''';

    // Static of method to get from BuildContext
    final ofMethod = '''
/// {@template ${className.snakeCase}_of}
/// Retrieves the [$className] from the nearest [ComputedStyleProvider] ancestor in the widget tree.
///
/// This method uses [ComputedStyleProvider.specOf] for surgical rebuilds - only widgets
/// that call this method will rebuild when [$className] changes, not when other specs change.
/// If no ancestor [ComputedStyleProvider] is found, this method returns an empty [$className].
///
/// Example:
///
/// ```dart
/// final ${className.camelCase} = $className.of(context);
/// ```
/// {@endtemplate}
static $className of(BuildContext context) {
  // SURGICAL REBUILD: Only rebuilds when $className changes
  return ComputedStyleProvider.specOf<$className>(context) ?? ${metadata.isConst ? 'const' : ''} $className${metadata.constructorRef}();
}''';

    return '$fromMethod\n\n  $ofMethod';
  }

  @override
  String build() {
    final className = metadata.name;
    final mixinName = '_\$$className';

    // Determine the base spec type
    final specType = metadata.isWidgetModifier
        ? 'WidgetModifierSpec<$className>'
        : 'Spec<$className>';

    // Generate static methods for regular specs
    final staticMethods =
        metadata.isWidgetModifier ? '' : _generateStaticMethods();

    // Check which methods need to be generated
    final hasCopyWith = metadata.hasMethod('copyWith');
    final hasLerp = metadata.hasMethod('lerp');
    final hasProps = metadata.hasMethod('props');

    // Generate methods as needed
    final methods = <String>[];

    methods.add(staticMethods);

    if (metadata.generatedMethods.hasFlag(GeneratedSpecMethods.copyWith) &&
        !hasCopyWith) {
      methods.add(SpecMethods.generateCopyWithMethod(
        className: className,
        constructorRef: metadata.constructorRef,
        fields: metadata.parameters,
        isConst: metadata.isConst,
        useInternalRef: true,
      ));
    }

    if (metadata.generatedMethods.hasFlag(GeneratedSpecMethods.lerp) &&
        !hasLerp) {
      methods.add(SpecMethods.generateLerpMethod(
        className: className,
        constructorRef: metadata.constructorRef,
        fields: metadata.parameters,
        isConst: metadata.isConst,
        useInternalRef: true,
      ));
    }

    if (metadata.generatedMethods.hasFlag(GeneratedSpecMethods.equals) &&
        !hasProps) {
      methods.add(CommonMethods.generatePropsGetter(
        className: className,
        fields: metadata.parameters,
        useInternalRef: true,
      ));
    }

    // Add self getter
    methods.add('$className get _\$this => this as $className;');

    // Add diagnostics methods if needed
    if (metadata.isDiagnosticable) {
      methods.add(CommonMethods.generateDebugFillPropertiesMethod(
        fields: metadata.parameters,
        useInternalRef: true,
      ));
    }

    // Combine all methods
    final methodsText = methods.where((m) => m.isNotEmpty).join('\n\n  ');

    return '''
/// A mixin that provides spec functionality for [$className].
mixin $mixinName on $specType {
  $methodsText
}''';
  }
}
