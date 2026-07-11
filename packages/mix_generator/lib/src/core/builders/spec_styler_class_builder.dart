library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

import '../checkers.dart';
import '../curated/styler_surface_metadata.dart';
import '../curated/type_metadata.dart';
import '../errors.dart';
import '../helpers/widget_call_planner.dart';
import '../models/annotation_config.dart';
import '../models/field_model.dart';
import '../models/styler_field_model.dart';
import '../models/type_helpers.dart' as type_helpers;
import '../resolvers/known_mix_symbol_resolver.dart';
import 'styler_api_planner.dart';
import 'styler_forwarder_factory.dart';
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

  /// The public constructor/setter parameter type for [field] and the `Prop`
  /// factory that wraps it, decided in one ladder so the pair cannot drift:
  /// every branch that picks a Mix-typed parameter also picks `Prop.maybeMix`.
  ///
  /// A `null` factory means the generated constructor forwards the value
  /// unwrapped: curated raw-list fields store plain lists, and list Mix
  /// params are wrapped by [_createArgument] with `Prop.mix(ListMix(...))`.
  ({String paramType, String? propFactory}) _publicApiFor(FieldModel field) {
    // Curated raw-list fields are never Prop-wrapped, whatever their type.
    String? unlessRawList(String propFactory) =>
        isRawListField(field.name) ? null : propFactory;

    // `_setterTypeOverride` validates that overrides are Mix/Styler types.
    final setterTypeOverride = _setterTypeOverride(field);
    if (setterTypeOverride != null) {
      return (
        paramType: setterTypeOverride,
        propFactory: unlessRawList('Prop.maybeMix'),
      );
    }

    final listMixParamType = _listMixParamType(field);
    if (listMixParamType != null) {
      return (paramType: listMixParamType, propFactory: null);
    }

    final mixParamType = mixTypeFor(field.typeName) ?? _nestedStylerType(field);
    if (mixParamType != null) {
      return (
        paramType: mixParamType,
        propFactory: unlessRawList('Prop.maybeMix'),
      );
    }

    return (
      paramType: _fieldValueType(field),
      propFactory: unlessRawList('Prop.maybe'),
    );
  }

  String _publicParamType(FieldModel field) => _publicApiFor(field).paramType;

  String? _propFactory(FieldModel field) => _publicApiFor(field).propFactory;

  /// Styler type for a nested `StyleSpec<X>` field, derived by the same
  /// `X -> XStyler` naming convention as generated styler class names.
  ///
  /// Pure string derivation by design: same-package generated stylers are not
  /// resolvable while this generator runs (build phases hide later-phase
  /// outputs from the resolver), so the derived type cannot be validated
  /// here. When `X`'s styler does not follow the convention the generated
  /// code fails to compile; `@MixableField(setterType:)` overrides the
  /// convention for types that resolve during generation.
  String? _nestedStylerType(FieldModel field) {
    final specArgument = styleSpecArgumentOf(field.typeName);

    return specArgument == null ? null : deriveStylerName(specArgument);
  }

  /// Whether [field] declares a `@MixableField(setterType:)` override.
  bool _hasSetterTypeOverride(FieldModel field) =>
      _setterTypeValue(field) != null;

  /// The resolved `@MixableField(setterType:)` type for [field], or `null`.
  DartType? _setterTypeValue(FieldModel field) =>
      _mixableFieldReader(field.name)?.peek('setterType')?.typeValue;

  /// Dart code for a field's `setterType` override, or `null` when unset.
  ///
  /// Lets a field whose runtime type has no automatic Mix counterpart
  /// (e.g. a nested `StyleSpec<BoxSpec>`) expose its Mix/Styler type
  /// (`BoxStyler`) in the generated setter, factory, and constructor.
  String? _setterTypeOverride(FieldModel field) {
    final type = _setterTypeValue(field);
    if (type == null) return null;

    final element = specElement.getField(field.name);
    if (element == null) return null;

    final typeCode = type_helpers.visibleTypeCodeForField(
      element,
      visibleFrom: element.library,
      type: type,
      usage: 'setter type',
    );

    _validateSetterTypeOverride(field, element, type, typeCode);

    return typeCode;
  }

  void _validateSetterTypeOverride(
    FieldModel field,
    FieldElement element,
    DartType setterType,
    String setterTypeCode,
  ) {
    final mixType = _mixBindingFor(setterType);
    final fieldValueType = element.library.typeSystem.promoteToNonNull(
      element.type,
    );
    final expectedType = type_helpers.visibleTypeCodeForField(
      element,
      visibleFrom: element.library,
      type: fieldValueType,
      usage: 'field value type',
    );
    if (mixType == null) {
      fail(
        element,
        '@MixableField(setterType: $setterTypeCode) on `${field.name}` must '
        'be assignable to `Mix<$expectedType>` for @MixableSpec fields.',
        todo:
            'Use a Mix/Styler type that resolves to `$expectedType`, or '
            'remove `setterType`.',
      );
    }

    final mixValueType = mixType.typeArguments.single;
    final acceptsFieldType =
        !_isInvalidMixValueType(mixValueType) &&
        element.library.typeSystem.isAssignableTo(
          mixValueType,
          fieldValueType,
          strictCasts: false,
        );
    if (acceptsFieldType) return;

    final actualType = type_helpers.visibleTypeCodeForField(
      element,
      visibleFrom: element.library,
      type: mixValueType,
      usage: 'setter type Mix value',
    );
    fail(
      element,
      '@MixableField(setterType: $setterTypeCode) on `${field.name}` resolves '
      'to `Mix<$actualType>`, but the field stores `$expectedType`.',
      todo: 'Use a Mix/Styler type that resolves to `$expectedType`.',
    );
  }

  bool _isInvalidMixValueType(DartType type) {
    return type is DynamicType || type.nullabilitySuffix == .question;
  }

  InterfaceType? _mixBindingFor(DartType type) {
    if (type is! InterfaceType) return null;

    if (mixChecker.isExactlyType(type)) return type;

    for (final supertype in type.allSupertypes) {
      if (mixChecker.isExactlyType(supertype)) return supertype;
    }

    return null;
  }

  String? _listElementMixType(FieldModel field) {
    if (!field.isList) return null;

    final elementType = field.listElementType;
    if (elementType == null) return null;

    return listElementMixTypeFor(elementType);
  }

  String? _listMixParamType(FieldModel field) {
    final elementMixType = _listElementMixType(field);
    if (elementMixType == null) return null;

    return 'List<$elementMixType>';
  }

  String? _listMixWrapperType(FieldModel field) {
    final elementMixType = _listElementMixType(field);
    if (elementMixType == null) return null;

    return listMixTypeFor(elementMixType);
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

    for (final mixinName in _curatedOwnerMixinNames(fields)) {
      addMixin(_ownerMixinFromSupportLibrary(mixinName));
    }

    final extra = annotation.peek('extraStylerMixins')?.listValue ?? const [];
    for (final object in extra) {
      final element = object.toTypeValue()?.element;
      if (element != null) addMixin(_ownerMixinFromElement(element));
    }

    return mixins;
  }

  List<String> _curatedOwnerMixinNames(List<FieldModel> fields) {
    final names = <String>{};
    final fieldNames = _fieldNames(fields);

    final surface = stylerSurfaceFor(stylerName);
    if (surface != null &&
        compoundStylerSurfaceFor(stylerName) == null &&
        surface.isAvailableFor(fieldNames)) {
      names.addAll(surface.ownerMixinNames);
    }

    final compound = _compoundConfig(fields);
    if (compound != null) names.addAll(compound.ownerMixinNames);

    return names.toList();
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

  Set<String> _fieldNames(List<FieldModel> fields) {
    return fields.map((field) => field.name).toSet();
  }

  bool _usesTransformOwnerMixin(List<_OwnerMixinReference> mixins) {
    return mixins.any((mixin) => mixin.name == 'TransformStyleMixin');
  }

  bool _needsTransformAnchor(
    List<FieldModel> fields,
    List<_OwnerMixinReference> mixins,
  ) {
    return _usesTransformOwnerMixin(mixins) &&
        _hasFieldNamed(fields, 'transform') &&
        _hasFieldNamed(fields, 'transformAlignment');
  }

  bool _shouldGenerateSetter(
    FieldModel field,
    List<FieldModel> fields,
    List<_OwnerMixinReference> mixins,
  ) {
    final reader = _mixableFieldReader(field.name);
    if (reader?.peek('ignoreSetter')?.boolValue ?? false) return false;
    final hasTransformAnchor = _needsTransformAnchor(fields, mixins);
    if (hasTransformAnchor &&
        (field.name == 'transform' || field.name == 'transformAlignment')) {
      return false;
    }
    if (_isCompoundNestedField(field, fields)) return false;

    final alias = _fieldAlias(field);

    return alias == null || alias.setterName != null;
  }

  bool _isCompoundNestedField(FieldModel field, List<FieldModel> fields) {
    final compound = _compoundConfig(fields);
    if (compound == null) return false;

    return compound.fieldNames.contains(field.name);
  }

  String? _setterNameFor(FieldModel field) {
    final aliasSetterName = _fieldAlias(field)?.setterName;
    if (aliasSetterName?.isNotEmpty ?? false) return aliasSetterName;

    return field.name;
  }

  List<StylerFieldModel> _stylerFields(
    List<FieldModel> fields,
    List<_OwnerMixinReference> mixins,
  ) {
    return fields
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
  }

  Set<String> _memberOverrideNames(
    List<_OwnerMixinReference> mixins,
    List<StylerFieldModel> stylerFields,
  ) {
    final generatedSetterNames = stylerFields
        .where((field) => field.generateSetter)
        .map((field) => field.setterName)
        .nonNulls
        .toSet();

    return {
      'animate',
      'variants',
      'wrap',
      for (final mixin in mixins)
        for (final method in mixin.element.methods)
          if (method.name != null &&
              (method.isAbstract || generatedSetterNames.contains(method.name)))
            method.name!,
    };
  }

  ({List<String> factoryCodes, List<String> methodCodes}) _buildApiPlan(
    List<FieldModel> fields,
    List<_OwnerMixinReference> mixins,
  ) {
    final compound = _compoundConfig(fields);
    final fieldNames = _fieldNames(fields);
    final surface = stylerSurfaceFor(stylerName);
    final usesCompoundSurface = compoundStylerSurfaceFor(stylerName) != null;
    final useSurface =
        surface != null &&
        (usesCompoundSurface
            ? compound != null
            : surface.isAvailableFor(fieldNames));
    final fieldFactories = _fieldFactoryMembers(
      fields,
      mixins,
      surface?.suppressedFieldFactoryNames ?? const {},
    );
    final curatedFactories = <StylerFactoryDescriptor>[
      if (useSurface)
        ..._surfaceFactories(
          surface,
          fieldNames,
          mixins: mixins,
          ignoreRequiredFields: compound != null,
        ),
      if (_needsTransformAnchor(fields, mixins) && compound == null)
        transformAnchorFactoryDescriptor(),
      if (_hasFieldNamed(fields, 'textDirectives'))
        ...textDirectiveFactoryDescriptors(),
      if (surface?.generatesSingleShadowConvenience == true &&
          _hasFieldNamed(fields, 'shadows'))
        iconShadowFactoryDescriptor(),
      ...?compound?.surface.factoryDescriptors,
      if (useSurface && surface.generatesAnimateFactory)
        animateFactoryDescriptor(),
    ];
    final curatedMethods = <StylerMethodDescriptor>[
      if (useSurface)
        ..._surfaceMethods(
          surface,
          fieldNames,
          ignoreRequiredFields: compound != null,
        ),
      if (_needsTransformAnchor(fields, mixins) && compound == null)
        transformAnchorMethodDescriptor(),
      if (_hasFieldNamed(fields, 'textDirectives'))
        ...textDirectiveMethodDescriptors(),
      if (surface?.generatesSingleShadowConvenience == true &&
          _hasFieldNamed(fields, 'shadows'))
        iconShadowMethodDescriptor(),
      ...?compound?.surface.methodDescriptors,
    ];

    return planStylerApi(
      stylerName: stylerName,
      fieldFactories: fieldFactories,
      curatedFactories: curatedFactories,
      curatedMethods: curatedMethods,
      generatedSetterNames: _generatedSetterNames(fields, mixins),
    );
  }

  List<StylerFactoryDescriptor> _surfaceFactories(
    StylerSurface surface,
    Set<String> fieldNames, {
    required List<_OwnerMixinReference> mixins,
    required bool ignoreRequiredFields,
  }) {
    final descriptors = <StylerFactoryDescriptor>[];
    for (final entry in surface.factoryEntries) {
      if (entry is StylerFactoryDescriptor) {
        if (ignoreRequiredFields || entry.isAvailableFor(fieldNames)) {
          descriptors.add(entry);
        }
      } else if (entry is ForwarderGroup) {
        if (!ignoreRequiredFields && !entry.isAvailableFor(fieldNames)) {
          continue;
        }
        final mixin = _requireOwnerMixin(mixins, entry.mixinName);
        descriptors.addAll(
          deriveForwarderFactories(
            mixinElement: mixin.element,
            orderedMethodNames: entry.methodNames,
            requiredFieldNames: entry.requiredFieldNames,
            libraryScope: mixin.element.library,
            anchor: specElement,
          ),
        );
      } else {
        throw UnsupportedError(
          'Unsupported styler factory entry `${entry.runtimeType}`.',
        );
      }
    }

    return descriptors;
  }

  _OwnerMixinReference _requireOwnerMixin(
    List<_OwnerMixinReference> mixins,
    String mixinName,
  ) {
    for (final mixin in mixins) {
      if (mixin.name == mixinName) return mixin;
    }

    fail(
      specElement,
      'SpecStylerGenerator could not derive factories from `$mixinName` '
      'because the styler does not include that owner mixin.',
      todo:
          'Add `$mixinName` to the styler surface owner mixins or remove its '
          'forwarder group.',
    );
  }

  List<StylerMethodDescriptor> _surfaceMethods(
    StylerSurface surface,
    Set<String> fieldNames, {
    required bool ignoreRequiredFields,
  }) {
    if (ignoreRequiredFields) return surface.methodDescriptors;

    return surface.methodDescriptors
        .where((descriptor) => descriptor.isAvailableFor(fieldNames))
        .toList();
  }

  List<ApiMember> _fieldFactoryMembers(
    List<FieldModel> fields,
    List<_OwnerMixinReference> mixins,
    Set<String> suppressedFieldFactoryNames,
  ) {
    final members = <ApiMember>[];
    for (final field in fields) {
      final factoryName = _fieldFactoryName(field, fields, mixins);
      if (factoryName == null) continue;
      if (suppressedFieldFactoryNames.contains(factoryName)) continue;

      final setterName = _setterNameFor(field);
      if (setterName == null) continue;

      final paramType = _publicParamType(field);
      members.add((
        name: factoryName,
        code:
            'factory $stylerName.$factoryName($paramType value) => $stylerName().$setterName(value);',
      ));
    }

    return members;
  }

  Set<String> _generatedSetterNames(
    List<FieldModel> fields,
    List<_OwnerMixinReference> mixins,
  ) {
    return {
      for (final field in fields)
        if (_shouldGenerateSetter(field, fields, mixins) &&
            _setterNameFor(field) != null)
          _setterNameFor(field)!,
    };
  }

  void _writeApiMembers(
    StringBuffer buffer,
    ({List<String> factoryCodes, List<String> methodCodes}) plan,
  ) {
    for (final code in plan.factoryCodes) {
      _writeIndentedCode(buffer, code);
    }
    if (plan.factoryCodes.isNotEmpty) buffer.writeln();

    for (final code in plan.methodCodes) {
      _writeIndentedCode(buffer, code);
      buffer.writeln();
    }
  }

  void _writeIndentedCode(StringBuffer buffer, String code) {
    for (final line in code.trimRight().split('\n')) {
      buffer.writeln('  $line');
    }
  }

  String? _buildCallMethod() {
    return buildMixableSpecTargetCall(
      annotation: annotation,
      specElement: specElement,
      specName: specName,
      stylerName: stylerName,
      hostElement: specElement,
      hostLibrary: specElement.library,
    );
  }

  _CompoundConfig? _compoundConfig(List<FieldModel> fields) {
    final surface = compoundStylerSurfaceFor(stylerName);
    if (surface == null) return null;

    final matchedFieldNames = <String>{};
    for (final part in surface.parts) {
      for (final field in fields) {
        if (field.name == part.fieldName && _isStyleSpecField(field, part)) {
          matchedFieldNames.add(field.name);
        }
      }
    }

    if (matchedFieldNames.length != surface.parts.length) return null;

    return _CompoundConfig(surface: surface, fieldNames: matchedFieldNames);
  }

  bool _isStyleSpecField(FieldModel field, CompoundStylerPartDescriptor part) {
    final fieldElement = specElement.getField(field.name);
    final type = fieldElement?.type;
    if (type is! InterfaceType) return false;
    if (type.element.name != 'StyleSpec') return false;
    if (type.typeArguments.length != 1) return false;

    final specType = type.typeArguments.single;

    return specType is InterfaceType && specType.element.name == part.specName;
  }

  String _createArgument(FieldModel field) {
    // A `setterType` override takes precedence over curated list wrapping.
    final listMixWrapperType = _hasSetterTypeOverride(field)
        ? null
        : _listMixWrapperType(field);
    if (listMixWrapperType != null) {
      return '         ${field.name}: ${field.name} != null ? Prop.mix($listMixWrapperType(${field.name})) : null,';
    }

    final propFactory = _propFactory(field);
    if (propFactory == null) return '         ${field.name}: ${field.name},';

    return '         ${field.name}: $propFactory(${field.name}),';
  }

  List<FieldModel> _nonCompoundFields(
    List<FieldModel> fields,
    _CompoundConfig compound,
  ) {
    return [
      for (final field in fields)
        if (!compound.fieldNames.contains(field.name)) field,
    ];
  }

  void _writeConstructor(StringBuffer buffer, List<FieldModel> fields) {
    final compound = _compoundConfig(fields);
    if (compound == null) {
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

      return;
    }

    buffer.writeln('  $stylerName({');
    final emittedParams = <String>{};
    for (final part in compound.activeParts) {
      for (final param in part.constructorParams) {
        if (!emittedParams.add(param.name)) continue;
        buffer.writeln('    ${param.code}');
      }
    }
    final extraFields = _nonCompoundFields(fields, compound);
    for (final field in extraFields) {
      if (!emittedParams.add(field.name)) {
        fail(
          specElement,
          'SpecStylerGenerator cannot flatten compound styler `$stylerName` '
          'because `${field.name}` conflicts with a curated constructor '
          'parameter.',
          todo:
              'Rename the spec field or add an explicit curated compound '
              'constructor mapping.',
        );
      }
      buffer.writeln('    ${_publicParamType(field)}? ${field.name},');
    }
    buffer.writeln('    AnimationConfig? animation,');
    buffer.writeln('    WidgetModifierConfig? modifier,');
    buffer.writeln('    List<VariantStyle<$specName>>? variants,');
    buffer.writeln('  }) : this.create(');
    for (final part in compound.activeParts) {
      buffer.writeln('         ${part.fieldName}: Prop.maybeMix(');
      buffer.writeln('           ${part.stylerName}(');
      for (final argument in part.constructorArguments) {
        buffer.writeln('             $argument');
      }
      buffer.writeln('           ),');
      buffer.writeln('         ),');
    }
    for (final field in extraFields) {
      buffer.writeln(_createArgument(field));
    }
    buffer.writeln('         variants: variants,');
    buffer.writeln('         modifier: modifier,');
    buffer.writeln('         animation: animation,');
    buffer.writeln('       );');
    buffer.writeln();
  }

  String get stylerName => deriveStylerName(specName);

  String build() {
    final fields = extractSpecFields(specElement, specName);
    final mixins = _collectOwnerMixins(fields);
    final mixinNames = mixins.map((m) => '${m.name}<$stylerName>').toList();
    final mixinClause = mixinNames.isEmpty
        ? ''
        : ' with ${mixinNames.join(', ')}';
    final buffer = StringBuffer();
    buffer.writeln(
      'class $stylerName extends MixStyler<$stylerName, $specName>$mixinClause {',
    );

    for (final field in fields) {
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

    _writeConstructor(buffer, fields);

    _writeApiMembers(buffer, _buildApiPlan(fields, mixins));

    final stylerFields = _stylerFields(fields, mixins);
    final members = StylerMixinBuilder(
      stylerName: stylerName,
      specName: specName,
      fields: stylerFields,
      config: const MixableStylerAnnotationConfig(),
      callMethodCode: _buildCallMethod(),
    ).buildMembers(methodOverrides: _memberOverrideNames(mixins, stylerFields));
    buffer.writeln(members);

    buffer.writeln('}');

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

class _CompoundConfig {
  final CompoundStylerSurface surface;
  final Set<String> fieldNames;

  const _CompoundConfig({required this.surface, required this.fieldNames});

  List<CompoundStylerPartDescriptor> get activeParts {
    return [
      for (final part in surface.parts)
        if (fieldNames.contains(part.fieldName)) part,
    ];
  }

  List<String> get ownerMixinNames {
    return activeParts.expand((part) => part.ownerMixinNames).toSet().toList();
  }
}
