/// Mixable generator for Mix mixin code generation.
///
/// Generates _$XMixin from @Mixable annotations.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/builders/mix_mixin_builder.dart';
import 'core/models/annotation_config.dart';
import 'core/models/mix_field_model.dart';

/// Main generator for Mix class code.
///
/// Triggers on @Mixable annotations and generates:
/// - _$XMixin (Mix method implementations)
class MixableGenerator extends GeneratorForAnnotation<Mixable> {
  const MixableGenerator();

  bool _isMixClass(ClassElement element) {
    // Check if class extends Mix<T> or a subclass of Mix<T>
    final supertype = element.supertype;
    if (supertype == null) return false;

    // Check direct supertype
    if (_isMixType(supertype)) return true;

    // Check if any supertype in hierarchy is Mix<T>
    for (final interface in element.allSupertypes) {
      if (_isMixType(interface)) return true;
    }

    return false;
  }

  bool _isMixType(InterfaceType type) {
    final elementName = type.element.name;

    return elementName == 'Mix' || elementName == 'Mixable';
  }

  String? _extractResolveToType(ClassElement classElement) {
    // First check direct supertype
    final supertype = classElement.supertype;
    if (supertype != null && supertype.typeArguments.isNotEmpty) {
      // ConstraintsMix<BoxConstraints> -> BoxConstraints
      return supertype.typeArguments.first.getDisplayString();
    }

    // Fallback: check all supertypes for Mix<T>
    for (final interface in classElement.allSupertypes) {
      if (_isMixType(interface) && interface.typeArguments.isNotEmpty) {
        return interface.typeArguments.first.getDisplayString();
      }
    }

    return null;
  }

  bool _hasDefaultValueMixin(ClassElement classElement) {
    // Check if the class uses DefaultValue<T> mixin
    for (final mixin in classElement.mixins) {
      if (mixin.element.name == 'DefaultValue') {
        return true;
      }
    }

    return false;
  }

  List<MixFieldModel> _extractFields(ClassElement classElement) {
    final allFields = <String, FieldElement>{};

    // Collect fields from superclass hierarchy first (so subclass fields override)
    _collectFieldsFromHierarchy(classElement, allFields);

    // Get $ fields only
    final dollarFields = allFields.values
        .where((f) => f.name!.startsWith(r'$'))
        .toList();

    // Sort by name for stable ordering
    dollarFields.sort((a, b) => a.name!.compareTo(b.name!));

    return dollarFields.map(MixFieldModel.fromElement).toList();
  }

  void _collectFieldsFromHierarchy(
    InterfaceElement classElement,
    Map<String, FieldElement> fields,
  ) {
    // First collect from superclass (if it's not Mix or Object)
    if (classElement is ClassElement) {
      final supertype = classElement.supertype;
      if (supertype != null) {
        final superElement = supertype.element;
        final superName = superElement.name;

        // Stop at Mix, Mixable, or Object
        if (superName != 'Mix' &&
            superName != 'Mixable' &&
            superName != 'Object') {
          _collectFieldsFromHierarchy(superElement, fields);
        }
      }
    }

    // Then collect from current class (overrides super fields)
    for (final field in classElement.fields) {
      final name = field.name;
      if (name != null) {
        fields[name] = field;
      }
    }
  }

  MixableAnnotationConfig _extractAnnotationConfig(
    ConstantReader annotation,
  ) {
    final methodsReader = annotation.peek('methods');
    final resolveToTypeReader = annotation.peek('resolveToType');

    return MixableAnnotationConfig(
      methods: methodsReader?.intValue ?? GeneratedMixMethods.all,
      resolveToType: resolveToTypeReader?.stringValue,
    );
  }

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    // Validate element is a class
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@Mixable can only be applied to classes.',
        element: element,
      );
    }

    final classElement = element;
    final mixName = classElement.name;
    if (mixName == null) {
      throw InvalidGenerationSourceError(
        '@Mixable class must have a name.',
        element: element,
      );
    }

    // Validate it's a Mix class
    if (!_isMixClass(classElement)) {
      throw InvalidGenerationSourceError(
        '@Mixable can only be applied to classes extending Mix<T> or its subclasses.',
        element: element,
      );
    }

    // Extract annotation configuration
    final config = _extractAnnotationConfig(annotation);

    // Extract resolve-to type from annotation or infer from supertype
    final resolveToType = config.resolveToType ?? _extractResolveToType(classElement);
    if (resolveToType == null) {
      throw InvalidGenerationSourceError(
        'Could not determine target type for resolve(). '
        'Specify resolveToType in @Mixable annotation or ensure class extends Mix<T>.',
        element: element,
      );
    }

    // Check for DefaultValue mixin
    final hasDefaultValue = _hasDefaultValueMixin(classElement);

    // Extract field models
    final fields = _extractFields(classElement);

    // Build output
    final buffer = StringBuffer();

    // Generate Mix mixin
    final mixMixinBuilder = MixMixinBuilder(
      mixName: mixName,
      resolveToType: resolveToType,
      fields: fields,
      config: config,
      hasDefaultValue: hasDefaultValue,
    );
    buffer.writeln(mixMixinBuilder.build());

    return buffer.toString();
  }
}
