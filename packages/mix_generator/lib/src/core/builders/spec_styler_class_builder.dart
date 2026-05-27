library;

import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../checkers.dart';
import '../curated/type_metadata.dart';
import '../errors.dart';
import '../models/annotation_config.dart';
import '../models/field_model.dart';
import '../models/styler_field_model.dart';
import '../resolvers/known_mix_symbol_resolver.dart';
import 'styler_mixin_builder.dart';

class SpecStylerClassBuilder {
  final ClassElement specElement;
  final String specName;
  final ConstantReader annotation;
  final KnownMixSymbolResolver symbolResolver;

  const SpecStylerClassBuilder({
    required this.specElement,
    required this.specName,
    required this.annotation,
    required this.symbolResolver,
  });

  String _fieldValueType(FieldModel field) =>
      _stripNullableSuffix(field.effectiveSpecType);

  String _fieldStorageType(FieldModel field) {
    final rawListElementType = rawListElementTypeFor(field.name);
    if (rawListElementType != null) {
      return 'List<$rawListElementType>?';
    }

    return 'Prop<${_fieldValueType(field)}>?';
  }

  String _publicParamType(FieldModel field) =>
      mixTypeFor(field.typeName) ?? _fieldValueType(field);

  String? _propFactory(FieldModel field) {
    if (isRawListField(field.name)) return null;

    return mixTypeFor(field.typeName) == null ? 'Prop.maybe' : 'Prop.maybeMix';
  }

  /// Returns the owner-mixin names contributed by [field], or `null` when the
  /// field explicitly opts out via `@MixableField(skipMixin: true)`.
  ///
  /// A `mixin: X` override resolves to a single-element list; otherwise the
  /// curated mapping from [ownerMixinsFor] is used.
  List<_OwnerMixinReference>? _ownerMixinsForField(FieldModel field) {
    final reader = _mixableFieldReader(field.name);
    if (reader?.peek('skipMixin')?.boolValue ?? false) return null;

    final overrideElement = reader?.peek('mixin')?.typeValue.element;
    if (overrideElement != null) {
      return [_ownerMixinFromElement(overrideElement)];
    }

    return ownerMixinsFor(
      field.typeName,
    ).map(_ownerMixinFromSupportLibrary).toList();
  }

  List<_OwnerMixinReference> _collectOwnerMixins(List<FieldModel> fields) {
    final mixins = <_OwnerMixinReference>[];

    void addMixin(_OwnerMixinReference candidate) {
      for (final existing in mixins) {
        if (existing.element.baseElement == candidate.element.baseElement) {
          return;
        }
      }
      mixins.add(candidate);
    }

    for (final field in fields) {
      for (final mixin in _ownerMixinsForField(field) ?? const []) {
        addMixin(mixin);
      }
    }

    final extra = annotation.peek('extraStylerMixins')?.listValue ?? const [];
    for (final object in extra) {
      final element = object.toTypeValue()?.element;
      if (element != null) addMixin(_ownerMixinFromElement(element));
    }

    return mixins;
  }

  ConstantReader? _mixableFieldReader(String fieldName) {
    final field = specElement.getField(fieldName);
    if (field == null) return null;

    final annotation = mixableFieldAnnotationChecker.firstAnnotationOf(field);

    return annotation == null ? null : ConstantReader(annotation);
  }

  _OwnerMixinReference _ownerMixinFromSupportLibrary(String mixinName) {
    final element = symbolResolver.requireInterface(mixinName, specElement);

    return _OwnerMixinReference(name: mixinName, element: element);
  }

  _OwnerMixinReference _ownerMixinFromElement(Element element) {
    if (element is! InterfaceElement) {
      fail(
        specElement,
        'SpecStylerGenerator expected an interface type for an owner mixin, '
        'but found `${element.displayName}`.',
        todo:
            'Use a class or mixin type in `@MixableField(mixin: ...)` and '
            '`extraStylerMixins`.',
      );
    }

    final name = element.name;
    if (name == null) {
      fail(
        specElement,
        'SpecStylerGenerator found an unnamed owner mixin element.',
        todo:
            'Use a named class or mixin type in `@MixableField(mixin: ...)` '
            'and `extraStylerMixins`.',
      );
    }

    return _OwnerMixinReference(name: name, element: element);
  }

  String? _fieldFactoryName(
    FieldModel field,
    List<FieldModel> fields,
    List<_OwnerMixinReference> mixins,
  ) {
    if (!_shouldGenerateSetter(field, fields, mixins)) return null;

    final reader = _mixableFieldReader(field.name);
    if (reader?.peek('skipFactory')?.boolValue ?? false) return null;

    return reader?.peek('factoryName')?.stringValue ?? field.name;
  }

  FieldAliasConfig? _fieldAlias(FieldModel field) =>
      fieldAliasMap['$stylerName.${field.name}'];

  bool _hasFieldNamed(List<FieldModel> fields, String name) {
    return fields.any((field) => field.name == name);
  }

  bool _usesTransformOwnerMixin(List<_OwnerMixinReference> mixins) {
    return mixins.any((mixin) => mixin.name == 'TransformStyleMixin');
  }

  bool _needsTransformAnchor(
    FieldModel field,
    List<FieldModel> fields,
    List<_OwnerMixinReference> mixins,
  ) {
    return (field.name == 'transform' || field.name == 'transformAlignment') &&
        _hasFieldNamed(fields, 'transformAlignment') &&
        _usesTransformOwnerMixin(mixins);
  }

  bool _shouldGenerateSetter(
    FieldModel field,
    List<FieldModel> fields,
    List<_OwnerMixinReference> mixins,
  ) {
    final reader = _mixableFieldReader(field.name);
    if (reader?.peek('ignoreSetter')?.boolValue ?? false) return false;
    if (_needsTransformAnchor(field, fields, mixins)) return false;

    final alias = _fieldAlias(field);

    return alias == null || alias.setterName != null;
  }

  String? _setterNameFor(FieldModel field) {
    final aliasSetterName = _fieldAlias(field)?.setterName;
    if (aliasSetterName?.isNotEmpty ?? false) return aliasSetterName;

    return field.name;
  }

  String _buildStylerMixin(List<FieldModel> fields) {
    final mixins = _collectOwnerMixins(fields);
    final stylerFields = fields
        .map(
          (field) => StylerFieldModel(
            name: field.name,
            declaredName: field.stylerFieldName,
            fieldTypeCode: _fieldStorageType(field),
            isRawList: isRawListField(field.name),
            effectivePublicParamType: _publicParamType(field),
            generateSetter: _shouldGenerateSetter(field, fields, mixins),
            setterName: _setterNameFor(field),
            diagnosticLabel: field.diagnosticLabel,
          ),
        )
        .toList();

    return StylerMixinBuilder(
      stylerName: stylerName,
      specName: specName,
      fields: stylerFields,
      config: const MixableStylerAnnotationConfig(),
    ).build();
  }

  void _writeTransformFactory(
    StringBuffer buffer,
    List<FieldModel> fields,
    List<_OwnerMixinReference> mixins,
  ) {
    if (!_usesTransformOwnerMixin(mixins)) return;
    if (!_hasFieldNamed(fields, 'transform')) return;
    if (!_hasFieldNamed(fields, 'transformAlignment')) return;

    buffer.writeln(
      '  factory $stylerName.transform(Matrix4 value, {Alignment alignment = .center}) =>',
    );
    buffer.writeln(
      '      $stylerName().transform(value, alignment: alignment);',
    );
  }

  void _writeTransformAnchor(
    StringBuffer buffer,
    List<FieldModel> fields,
    List<_OwnerMixinReference> mixins,
  ) {
    if (!_usesTransformOwnerMixin(mixins)) return;
    if (!_hasFieldNamed(fields, 'transform')) return;
    if (!_hasFieldNamed(fields, 'transformAlignment')) return;

    buffer.writeln('  @override');
    buffer.writeln(
      '  $stylerName transform(Matrix4 value, {Alignment alignment = .center}) {',
    );
    buffer.writeln(
      '    return merge($stylerName(transform: value, transformAlignment: alignment));',
    );
    buffer.writeln('  }');
    buffer.writeln();
  }

  String _createArgument(FieldModel field) {
    final propFactory = _propFactory(field);
    if (propFactory == null) return '         ${field.name}: ${field.name},';

    return '         ${field.name}: $propFactory(${field.name}),';
  }

  String get _stylerMixinName => '_\$${stylerName}Mixin';

  String get stylerName => deriveStylerName(specName);

  String build() {
    final fields = extractSpecFields(specElement, specName);
    final mixins = _collectOwnerMixins(fields);
    final mixinClause =
        ' with ${[...mixins.map((m) => '${m.name}<$stylerName>'), _stylerMixinName].join(', ')}';
    final buffer = StringBuffer();
    buffer.writeln(
      'class $stylerName extends MixStyler<$stylerName, $specName>$mixinClause {',
    );

    for (final field in fields) {
      buffer.writeln('  @override');
      buffer.writeln('  final ${_fieldStorageType(field)} \$${field.name};');
    }
    buffer.writeln();

    buffer.writeln('  const $stylerName.create({');
    for (final field in fields) {
      buffer.writeln('    ${_fieldStorageType(field)} ${field.name},');
    }
    buffer.writeln('    super.variants,');
    buffer.writeln('    super.modifier,');
    buffer.writeln('    super.animation,');
    if (fields.isEmpty) {
      buffer.writeln('  });');
    } else {
      buffer.writeln('  }) :');
      for (var i = 0; i < fields.length; i++) {
        final field = fields[i];
        final suffix = i == fields.length - 1 ? ';' : ',';
        buffer.writeln('       \$${field.name} = ${field.name}$suffix');
      }
    }
    buffer.writeln();

    buffer.writeln('  $stylerName({');
    for (final field in fields) {
      buffer.writeln('    ${_publicParamType(field)}? ${field.name},');
    }
    buffer.writeln('    AnimationConfig? animation,');
    buffer.writeln('    WidgetModifierConfig? modifier,');
    buffer.writeln('    List<VariantStyle<$specName>>? variants,');
    buffer.writeln('  }) : this.create(');
    for (final field in fields) {
      buffer.writeln(_createArgument(field));
    }
    buffer.writeln('         variants: variants,');
    buffer.writeln('         modifier: modifier,');
    buffer.writeln('         animation: animation,');
    buffer.writeln('       );');
    buffer.writeln();

    _writeTransformFactory(buffer, fields, mixins);

    for (final field in fields) {
      final factoryName = _fieldFactoryName(field, fields, mixins);
      if (factoryName == null) continue;

      final paramType = _publicParamType(field);
      buffer.writeln('  factory $stylerName.$factoryName($paramType value) =>');
      buffer.writeln('      $stylerName().${_setterNameFor(field)}(value);');
    }
    buffer.writeln();

    _writeTransformAnchor(buffer, fields, mixins);

    buffer.writeln('}');
    buffer.writeln();
    buffer.writeln(_buildStylerMixin(fields));

    return buffer.toString();
  }
}

String _stripNullableSuffix(String typeCode) => typeCode.endsWith('?')
    ? typeCode.substring(0, typeCode.length - 1)
    : typeCode;

class _OwnerMixinReference {
  final String name;
  final InterfaceElement element;

  const _OwnerMixinReference({required this.name, required this.element});
}
