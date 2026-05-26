import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/builders/mix_mixin_builder.dart';
import 'core/checkers.dart';
import 'core/errors.dart';
import 'core/helpers/library_scope.dart';
import 'core/helpers/type_hierarchy.dart';
import 'core/models/annotation_config.dart';
import 'core/models/mix_field_model.dart';

/// Source-gen generator that emits `_$<Name>Mixin` for `@Mixable`-annotated
/// `Mix<T>` subclasses.
class MixableGenerator extends GeneratorForAnnotation<Mixable> {
  const MixableGenerator();

  bool _isMixClass(ClassElement element) {
    return _findMixBinding(element) != null;
  }

  InterfaceType? _findMixBinding(ClassElement element) {
    return findSupertypeMatching(element.supertype, mixChecker);
  }

  /// Walks the supertype chain to find the concrete `Mix<T>` binding and
  /// returns `T`.
  ///
  /// Intermediate classes may introduce their own generic parameters (e.g.
  /// `class BaseMix<A> extends Mix<BoxConstraints>`). Reading the direct
  /// supertype's first type argument would incorrectly pick `A`; we must
  /// locate the actual Mix binding first.
  String? _extractResolveToType(ClassElement classElement) {
    final mixType = _findMixBinding(classElement);
    if (mixType == null || mixType.typeArguments.isEmpty) {
      return null;
    }

    final resolveType = mixType.typeArguments.first;
    final hiddenType = firstInvisibleTypeName(
      resolveType,
      classElement.library,
    );
    if (hiddenType != null) {
      final className = classElement.name ?? '<unknown>';
      fail(
        classElement,
        'Resolve type `$hiddenType` is used but not imported into the '
        'annotated library. Import or re-export `$hiddenType` where '
        '$className is declared.',
      );
    }

    return typeCode(resolveType, visibleFrom: classElement.library);
  }

  bool _hasDefaultValueMixin(ClassElement classElement) {
    for (final mixin in classElement.mixins) {
      if (defaultValueChecker.isExactlyType(mixin)) {
        return true;
      }
    }

    return false;
  }

  List<MixFieldModel> _extractFields(ClassElement classElement) {
    final allFields = <String, FieldElement>{};

    // Walk the hierarchy first so subclass fields override their parents.
    _collectFieldsFromHierarchy(classElement, allFields);

    final dollarFields = allFields.values
        .where((f) => f.name!.startsWith(r'$'))
        .toList();

    // Stable ordering for deterministic generator output.
    dollarFields.sort((a, b) => a.name!.compareTo(b.name!));

    return dollarFields.map((field) {
      return MixFieldModel.fromElement(
        field,
        visibleFrom: classElement.library,
      );
    }).toList();
  }

  void _collectFieldsFromHierarchy(
    InterfaceElement classElement,
    Map<String, FieldElement> fields,
  ) {
    // Recurse into the supertype first so the current class's fields
    // override inherited entries in [fields]. Stop at Mix/Mixable/Object.
    if (classElement is ClassElement) {
      final supertype = classElement.supertype;
      if (supertype != null &&
          !mixChecker.isExactlyType(supertype) &&
          !mixableChecker.isExactlyType(supertype) &&
          !supertype.isDartCoreObject) {
        _collectFieldsFromHierarchy(supertype.element, fields);
      }
    }

    for (final field in classElement.fields) {
      final name = field.name;
      if (name != null) {
        fields[name] = field;
      }
    }
  }

  MixableAnnotationConfig _extractAnnotationConfig(ConstantReader annotation) {
    final resolveToTypeReader = annotation.peek('resolveToType');

    return MixableAnnotationConfig(
      methods: peekMethodsBitmask(annotation, GeneratedMixMethods.all),
      resolveToType: resolveToTypeReader?.stringValue,
    );
  }

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final classElement = requireClassElement(element, '@Mixable');
    final mixName = requireName(
      classElement,
      orFailWith: '@Mixable class must have a name.',
    );

    // Validate it's a Mix class
    if (!_isMixClass(classElement)) {
      fail(
        element,
        '@Mixable can only be applied to classes extending Mix<T> or its '
        'subclasses.',
        todo: 'Make the class extend `Mix<YourResolveType>` or a Mix subclass.',
      );
    }

    // Extract annotation configuration
    final config = _extractAnnotationConfig(annotation);

    // Extract resolve-to type from annotation or infer from supertype
    final resolveToType =
        config.resolveToType ?? _extractResolveToType(classElement);
    if (resolveToType == null) {
      fail(
        element,
        'Could not determine target type for resolve(). Specify '
        'resolveToType in @Mixable annotation or ensure class extends '
        'Mix<T>.',
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
