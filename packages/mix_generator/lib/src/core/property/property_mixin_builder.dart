// lib/src/builders/dto/dto_mixin_builder.dart
import '../metadata/property_metadata.dart';
import '../utils/code_builder.dart';
import '../utils/common_method_builder.dart';
import 'property_method_builder.dart';

class MixableTypeMixinBuilder extends CodeBuilder {
  final MixableTypeMetadata metadata;

  MixableTypeMixinBuilder(this.metadata);

  @override
  String build() {
    final mixinName = '_\$${metadata.name}';
    final resolvedTypeName = metadata.resolvedElement.name;

    // Check if custom methods are already defined
    final hasResolve = metadata.element.methods.any((m) => m.name == 'resolve');
    final hasMerge = metadata.element.methods.any((m) => m.name == 'merge');
    final hasProps = metadata.element.methods.any((m) => m.name == 'props');

    final defaultValueMixin =
        metadata.hasDefaultValue ? ', HasDefaultValue<$resolvedTypeName>' : '';

    // Only generate methods that aren't already defined
    final resolveMethod = !hasResolve
        ? MixableTypeMethods.generateResolveMethod(
            className: metadata.name,
            constructorRef: metadata.constructorRef,
            fields: metadata.parameters,
            isConst: metadata.isConst,
            resolvedType: resolvedTypeName,
            useInternalRef: true,
            constructorDefaults: metadata.constructorDefaults,
            hasDefaultValue: metadata.hasDefaultValue,
          )
        : '';

    final mergeMethod = !hasMerge
        ? MixableTypeMethods.generateMergeMethod(
            className: metadata.name,
            fields: metadata.parameters,
            isAbstract: false,
            shouldMergeLists: metadata.mergeLists,
            useInternalRef: true,
            constructorRef: metadata.constructorRef,
          )
        : '';

    final propsGetter = !hasProps
        ? CommonMethods.generatePropsGetter(
            className: metadata.name,
            fields: metadata.parameters,
            useInternalRef: true,
          )
        : '';

    return '''
/// A mixin that provides DTO functionality for [${metadata.name}].
mixin $mixinName on Mixable<$resolvedTypeName> $defaultValueMixin {
  $resolveMethod

  $mergeMethod

  $propsGetter

  /// Returns this instance as a [${metadata.name}].
  ${metadata.name} get _\$this => this as ${metadata.name};
}
''';
  }
}
