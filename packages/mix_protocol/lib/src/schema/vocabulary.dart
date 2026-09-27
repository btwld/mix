import 'package:ack/ack.dart' hide JsonMap;
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../contract/identity_resolution.dart';
import '../contract/json_map.dart';
import '../errors/mix_protocol_error.dart';
import 'box_styler_codec.dart';
import 'common_codecs.dart';
import 'flex_box_styler_codec.dart';
import 'flex_styler_codec.dart';
import 'grid_box_styler_codec.dart';
import 'icon_styler_codec.dart';
import 'image_styler_codec.dart';
import 'schema_field.dart';
import 'stack_box_styler_codec.dart';
import 'stack_styler_codec.dart';
import 'styler_branch.dart';
import 'styler_codec_helpers.dart';
import 'text_styler_codec.dart';
import 'wire_discriminators.dart';
import 'wire_schema.dart';
import 'wrap_box_styler_codec.dart';
import 'wrap_styler_codec.dart';

final RegExp _wireIdentifierPattern = RegExp(r'^[a-z][a-z0-9_]*$');

const _gradientListEntryPaths = [
  ['colors'],
  ['stops'],
];

/// An immutable set of styler branches that share a wire namespace.
final class MixProtocolVocabulary {
  /// Stable lowercase package namespace.
  final String id;

  /// Independent major version of this vocabulary's wire contract.
  final int wireVersion;

  /// Styler branches contributed by this vocabulary.
  final List<MixProtocolStylerBranchBase> branches;

  final bool _isCore;

  /// Creates a contributed vocabulary.
  MixProtocolVocabulary({
    required this.id,
    required this.wireVersion,
    required List<MixProtocolStylerBranchBase> branches,
  }) : branches = List.unmodifiable(branches),
       _isCore = false;

  MixProtocolVocabulary._core({
    required this.id,
    required this.wireVersion,
    required List<MixProtocolStylerBranchBase> branches,
  }) : branches = List.unmodifiable(branches),
       _isCore = true;
}

/// Type-erased branch contract stored by [MixProtocolVocabulary].
abstract interface class MixProtocolStylerBranchBase {
  _CompiledStylerBranch _build(MixProtocolBranchContext context);

  /// Local branch name inside its vocabulary.
  String get name;

  /// Runtime type encoded by this branch.
  Type get valueType;
}

final class _CompiledStylerBranch {
  final AckSchema<JsonMap, Object> schema;
  final Map<String, SchemaFieldSemantics> fieldSemantics;

  const _CompiledStylerBranch({
    required this.schema,
    required this.fieldSemantics,
  });
}

/// A package-contributed styler branch.
final class MixProtocolStylerBranch<T extends Object>
    implements MixProtocolStylerBranchBase {
  @override
  final String name;

  final MixProtocolStylerCodec<T> Function(MixProtocolBranchContext context)
  _codec;

  /// Creates a branch whose full discriminator is derived from its vocabulary.
  const MixProtocolStylerBranch({required this.name, required this._codec});

  @override
  _CompiledStylerBranch _build(MixProtocolBranchContext context) {
    final schemaObject = _codec(context)._build();

    return _CompiledStylerBranch(
      schema: widenStylerBranch(
        schemaObject.codec(debugName: name),
        debugName: name,
      ),
      fieldSemantics: schemaObject.fieldSemantics,
    );
  }

  @override
  Type get valueType => T;
}

/// Shared construction context supplied to every contributed branch.
final class MixProtocolBranchContext {
  final AckSchema<JsonMap, Object> _rootStyleSchema;
  final MixProtocolIdentityContext Function() _identityContext;

  const MixProtocolBranchContext._(
    this._rootStyleSchema,
    this._identityContext,
  );
}

/// Opaque value codec used by the public protocol-authoring API.
final class MixProtocolValueCodec<T extends Object> {
  final AckSchema<Object, T> _schema;
  final List<List<String>> _listEntryPaths;
  final T? Function(Object value)? _convertValue;
  final AckSchema<Object, Object> Function(String fieldName)? _mixPropCodec;

  const MixProtocolValueCodec._(
    this._schema, {
    this._listEntryPaths = const [],
    this._convertValue,
    this._mixPropCodec,
  });

  SchemaFieldSemantics get _fieldSemantics =>
      SchemaFieldSemantics(listEntryPaths: _listEntryPaths);
}

/// Public protocol value codecs without exposing the private Ack engine.
abstract final class MixProtocolCodecs {
  /// Boolean JSON values.
  static MixProtocolValueCodec<bool> boolean() {
    return MixProtocolValueCodec._(Ack.boolean() as AckSchema<Object, bool>);
  }

  /// String JSON values.
  static MixProtocolValueCodec<String> string() {
    return MixProtocolValueCodec._(Ack.string() as AckSchema<Object, String>);
  }

  /// Integer JSON values.
  static MixProtocolValueCodec<int> integer({int? min, int? max}) {
    var schema = Ack.integer();
    if (min != null) schema = schema.min(min);
    if (max != null) schema = schema.max(max);

    return MixProtocolValueCodec._(schema as AckSchema<Object, int>);
  }

  /// Finite number with canonical double-valued token support.
  static MixProtocolValueCodec<double> number() {
    return MixProtocolValueCodec._(doubleTokenCodec());
  }

  /// Positive finite number with canonical double-valued token support.
  static MixProtocolValueCodec<double> positiveNumber() {
    return MixProtocolValueCodec._(positiveDoubleTokenCodec());
  }

  /// Non-negative finite number with canonical double-valued token support.
  static MixProtocolValueCodec<double> nonNegativeNumber() {
    return MixProtocolValueCodec._(nonNegativeDoubleTokenCodec());
  }

  /// Number in the inclusive zero-to-one range with token support.
  static MixProtocolValueCodec<double> unitNumber() {
    return MixProtocolValueCodec._(unitDoubleTokenCodec());
  }

  /// Canonical Mix color literal or color-token reference.
  static MixProtocolValueCodec<Color> color() {
    return MixProtocolValueCodec._(colorCodec());
  }

  /// Canonical Mix gradient value.
  static MixProtocolValueCodec<GradientMix> gradient() {
    return MixProtocolValueCodec._(
      gradientCodec() as AckSchema<Object, GradientMix>,
      listEntryPaths: _gradientListEntryPaths,
      convertValue: (value) =>
          value is Gradient ? GradientMix.value(value) : null,
    );
  }

  /// Canonical Mix border value.
  static MixProtocolValueCodec<BorderMix> border() {
    return MixProtocolValueCodec._(
      borderCodec() as AckSchema<Object, BorderMix>,
      convertValue: (value) => value is Border ? BorderMix.value(value) : null,
    );
  }

  /// Canonical Mix border-side value.
  static MixProtocolValueCodec<BorderSideMix> borderSide() {
    return MixProtocolValueCodec._(
      borderSideCodec() as AckSchema<Object, BorderSideMix>,
      convertValue: (value) =>
          value is BorderSide ? BorderSideMix.value(value) : null,
      mixPropCodec: borderSideMixPropCodec,
    );
  }

  /// Canonical Mix border-radius value.
  static MixProtocolValueCodec<BorderRadiusMix> borderRadius() {
    return MixProtocolValueCodec._(
      borderRadiusCodec(),
      convertValue: (value) =>
          value is BorderRadius ? BorderRadiusMix.value(value) : null,
    );
  }

  /// Canonical Mix edge-insets value.
  static MixProtocolValueCodec<EdgeInsetsMix> edgeInsets() {
    return MixProtocolValueCodec._(
      edgeInsetsCodec(),
      convertValue: (value) =>
          value is EdgeInsets ? EdgeInsetsMix.value(value) : null,
    );
  }

  /// Canonical finite two-dimensional offset.
  static MixProtocolValueCodec<Offset> offset() {
    return MixProtocolValueCodec._(offsetCodec() as AckSchema<Object, Offset>);
  }

  /// Canonical Mix shadow value.
  static MixProtocolValueCodec<ShadowMix> shadow() {
    return MixProtocolValueCodec._(
      shadowCodec() as AckSchema<Object, ShadowMix>,
      convertValue: (value) => value is Shadow ? ShadowMix.value(value) : null,
    );
  }

  /// Enum encoded by its Dart enum name.
  static MixProtocolValueCodec<T> enumName<T extends Enum>(List<T> values) {
    return MixProtocolValueCodec._(
      enumNameCodec(values) as AckSchema<Object, T>,
    );
  }

  /// JSON list whose entries use [item].
  static MixProtocolValueCodec<List<T>> list<T extends Object>(
    MixProtocolValueCodec<T> item, {
    bool nonEmpty = false,
  }) {
    var schema = Ack.list(item._schema);
    if (nonEmpty) schema = schema.nonEmpty();

    return MixProtocolValueCodec._(
      schema as AckSchema<Object, List<T>>,
      listEntryPaths: [
        const [],
        for (final path in item._listEntryPaths) ['*', ...path],
      ],
    );
  }

  /// A recursively encoded style constrained to the requested spec type.
  static MixProtocolValueCodec<Style<S>> style<S extends Spec<S>>(
    MixProtocolBranchContext context,
  ) {
    final schema = Ack.codec<JsonMap, Object, Style<S>>(
      input: context._rootStyleSchema,
      decode: (value) {
        if (value is Style<S>) return value;

        throw SchemaPathError(
          code: MixProtocolErrorCode.typeMismatch,
          relativePath: '',
          reason:
              'Nested style decoded to ${value.runtimeType}; expected a $S '
              'style.',
          value: value,
        );
      },
      encode: (value) => value,
      output: Ack.instance<Style<S>>(),
    );

    return MixProtocolValueCodec._(
      schema.withConstraint(WireSchemaReference<Style<S>>('mix_protocol_style'))
          as AckSchema<Object, Style<S>>,
    );
  }
}

/// One typed declarative field in a contributed styler branch.
final class MixProtocolFieldCodec<Owner extends Object, Value extends Object> {
  final SchemaField<Owner, Value> _field;

  const MixProtocolFieldCodec._(this._field);

  /// Returns this field's decoded value from branch data.
  Value? value(JsonMap data) => _field.value(data);
}

/// Builders for declarative contributed-styler fields.
///
/// A declaration keeps three names separate: `wire` is the stable serialized
/// key, `inventoryName` is the Dart owner field consumed by the declaration,
/// and `fieldName` is an optional diagnostic label. Keeping these namespaces
/// explicit allows Dart fields to evolve without silently changing the wire
/// contract.
abstract final class MixProtocolField {
  /// Creates a field read directly from its owner.
  static MixProtocolFieldCodec<Owner, Value>
  direct<Owner extends Object, Value extends Object>({
    required String wire,
    required MixProtocolValueCodec<Value> codec,
    required Value? Function(Owner value) read,
    String? inventoryName,
  }) {
    return MixProtocolFieldCodec._(
      directField<Owner, Value>(
        wire,
        codec._schema,
        read,
        inventoryName: inventoryName,
        schemaSemantics: codec._fieldSemantics,
      ),
    );
  }

  /// Creates a property field whose sources are direct runtime values.
  static MixProtocolFieldCodec<Owner, Prop<Value>>
  value<Owner extends Object, Value extends Object>({
    required String wire,
    required MixProtocolValueCodec<Value> codec,
    required Prop<Value>? Function(Owner value) read,
    String? fieldName,
    String? inventoryName,
  }) {
    return MixProtocolFieldCodec._(
      propValueField<Owner, Value>(
        wire,
        codec._schema,
        read,
        fieldName: fieldName,
        inventoryName: inventoryName,
        schemaSemantics: codec._fieldSemantics,
      ),
    );
  }

  /// Creates a property field whose sources are Mix values.
  static MixProtocolFieldCodec<Owner, Prop<PropValue>>
  mix<Owner extends Object, Value extends Object, PropValue extends Object>({
    required String wire,
    required MixProtocolValueCodec<Value> codec,
    required Prop<PropValue>? Function(Owner value) read,
    String? fieldName,
    String? inventoryName,
  }) {
    final fieldNameOrWire = fieldName ?? wire;
    final customCodec = codec._mixPropCodec?.call(fieldNameOrWire);
    if (customCodec != null) {
      return MixProtocolFieldCodec._(
        SchemaField<Owner, Prop<PropValue>>(
          wire: wire,
          codec: customCodec as AckSchema<Object, Prop<PropValue>>,
          inventoryName: inventoryName,
          schemaSemantics: codec._fieldSemantics,
          read: read,
        ),
      );
    }

    return MixProtocolFieldCodec._(
      propMixField<Owner, Value, PropValue>(
        wire,
        codec._schema,
        read,
        fieldName: fieldName,
        inventoryName: inventoryName,
        schemaSemantics: codec._fieldSemantics,
        convertValue: (value) => codec._convertValue?.call(value),
      ),
    );
  }

  /// Creates a recursively encoded nested style property.
  static MixProtocolFieldCodec<Owner, Prop<StyleSpec<S>>>
  style<Owner extends Object, S extends Spec<S>>({
    required String wire,
    required MixProtocolBranchContext context,
    required Prop<StyleSpec<S>>? Function(Owner value) read,
    String? fieldName,
    String? inventoryName,
  }) {
    return mix<Owner, Style<S>, StyleSpec<S>>(
      wire: wire,
      codec: MixProtocolCodecs.style<S>(context),
      read: read,
      fieldName: fieldName,
      inventoryName: inventoryName,
    );
  }
}

/// Type-erased metadata contract accepted by [MixProtocolStylerCodec].
abstract interface class MixProtocolStylerMetadataBase<Owner extends Object> {
  List<SchemaFieldBase<Owner>> get _fields;
  List<UnsupportedSchemaField<Owner>> get _unsupportedFields;
}

/// Standard variants, modifiers, and animation fields for a Mix styler.
final class MixProtocolStylerMetadata<Owner extends Object, S extends Spec<S>>
    implements MixProtocolStylerMetadataBase<Owner> {
  final StylerMetadataFields<Owner, S> _metadata;

  MixProtocolStylerMetadata({
    required MixProtocolBranchContext context,
    required List<VariantStyle<S>>? Function(Owner value) readVariants,
    required WidgetModifierConfig? Function(Owner value) readModifier,
    required AnimationConfig? Function(Owner value) readAnimation,
  }) : _metadata = StylerMetadataFields<Owner, S>(
         rootStyleSchema: context._rootStyleSchema,
         readVariants: readVariants,
         readModifier: readModifier,
         readAnimation: readAnimation,
       );

  @override
  List<SchemaFieldBase<Owner>> get _fields => _metadata.fields;

  @override
  List<UnsupportedSchemaField<Owner>> get _unsupportedFields =>
      _metadata.unsupportedFields();

  /// Decoded variants, when present.
  List<VariantStyle<S>>? variants(JsonMap data) =>
      _metadata.variants?.value(data);

  /// Decoded widget modifiers, when present.
  WidgetModifierConfig? modifier(JsonMap data) =>
      _metadata.modifiers.value(data);

  /// Decoded animation configuration, when present.
  AnimationConfig? animation(JsonMap data) => _metadata.animation.value(data);
}

/// Declarative codec for one contributed styler object.
final class MixProtocolStylerCodec<Owner extends Object> {
  final List<MixProtocolFieldCodec<Owner, Object>> _fields;
  final Owner Function(JsonMap data) _buildOwner;
  final MixProtocolStylerMetadataBase<Owner>? _metadata;
  final String? _inventoryOwner;
  final Set<String>? _ownerFieldInventory;
  final Set<String>? Function(Owner value)? _ownerFieldInventoryOf;
  final int Function(Owner value)? _actualFieldCount;

  /// Creates a styler codec from its fields and reconstruction callback.
  MixProtocolStylerCodec({
    required List<MixProtocolFieldCodec<Owner, Object>> fields,
    MixProtocolStylerMetadataBase<Owner>? metadata,
    String? inventoryOwner,
    Set<String>? ownerFieldInventory,
    int Function(Owner value)? actualFieldCount,
    required Owner Function(JsonMap data) build,
  }) : this._(
         fields: fields,
         metadata: metadata,
         inventoryOwner: inventoryOwner,
         ownerFieldInventory: ownerFieldInventory,
         actualFieldCount: actualFieldCount,
         build: build,
       );

  MixProtocolStylerCodec._({
    required List<MixProtocolFieldCodec<Owner, Object>> fields,
    this._metadata,
    this._inventoryOwner,
    Set<String>? ownerFieldInventory,
    this._ownerFieldInventoryOf,
    this._actualFieldCount,
    required Owner Function(JsonMap data) build,
  }) : _fields = List.unmodifiable(fields),
       _buildOwner = build,
       _ownerFieldInventory = ownerFieldInventory == null
           ? null
           : Set.unmodifiable(ownerFieldInventory);

  /// Creates a codec for a Mix [Style], wiring its standard metadata and
  /// generated field inventory automatically.
  ///
  /// [ownerFieldInventory] is a compatibility fallback for handwritten
  /// Stylers and output produced before field metadata was generated. Encoding
  /// fails with an inventory-skew diagnostic when neither source is available.
  /// Metadata exposed by the runtime Styler takes precedence over the fallback.
  static MixProtocolStylerCodec<Styler>
  forStyler<Styler extends Style<S>, S extends Spec<S>>({
    required MixProtocolBranchContext context,
    required List<MixProtocolFieldCodec<Styler, Object>> fields,
    Set<String>? ownerFieldInventory,
    required Styler Function(
      JsonMap data,
      MixProtocolStylerMetadata<Styler, S> metadata,
    )
    build,
  }) {
    final metadata = MixProtocolStylerMetadata<Styler, S>(
      context: context,
      readVariants: (value) => value.$variants,
      readModifier: (value) => value.$modifier,
      readAnimation: (value) => value.$animation,
    );

    return MixProtocolStylerCodec<Styler>._(
      fields: fields,
      metadata: metadata,
      ownerFieldInventory: ownerFieldInventory,
      ownerFieldInventoryOf: stylerFieldInventoryOf,
      actualFieldCount: (value) => value.props.length,
      build: (data) => build(data, metadata),
    );
  }

  SchemaObject<Owner> _build() {
    return SchemaObject<Owner>(
      fields: [
        for (final field in _fields) field._field,
        ...?_metadata?._fields,
      ],
      build: _buildOwner,
      unsupportedFields: [...?_metadata?._unsupportedFields],
      inventoryOwner: _inventoryOwner,
      ownerFieldInventory: _ownerFieldInventory,
      ownerFieldInventoryOf: _ownerFieldInventoryOf,
      actualFieldCount: _actualFieldCount,
    );
  }
}

final class _CoreStylerBranch<T extends Object>
    implements MixProtocolStylerBranchBase {
  @override
  final String name;

  final SchemaObject<T> Function(
    AckSchema<JsonMap, Object> rootStyleSchema,
    MixProtocolIdentityContext Function() identityContext,
  )
  _codec;

  const _CoreStylerBranch(this.name, this._codec);

  @override
  _CompiledStylerBranch _build(MixProtocolBranchContext context) {
    final schemaObject = _codec(
      context._rootStyleSchema,
      context._identityContext,
    );

    return _CompiledStylerBranch(
      schema: widenStylerBranch(
        schemaObject.codec(debugName: name),
        debugName: name,
      ),
      fieldSemantics: schemaObject.fieldSemantics,
    );
  }

  @override
  Type get valueType => T;
}

/// The fixed built-in Mix vocabulary used by the shared [mixProtocol] facade.
final MixProtocolVocabulary
mixProtocolCoreVocabulary = MixProtocolVocabulary._core(
  id: 'mix',
  wireVersion: 1,
  branches: [
    _CoreStylerBranch(
      schemaTypeBox,
      (root, identity) =>
          boxStylerSchema(rootStyleSchema: root, identityContext: identity),
    ),
    _CoreStylerBranch(
      schemaTypeText,
      (root, identity) =>
          textStylerSchema(rootStyleSchema: root, identityContext: identity),
    ),
    _CoreStylerBranch(
      schemaTypeFlex,
      (root, identity) =>
          flexStylerSchema(rootStyleSchema: root, identityContext: identity),
    ),
    _CoreStylerBranch(
      schemaTypeStack,
      (root, identity) =>
          stackStylerSchema(rootStyleSchema: root, identityContext: identity),
    ),
    _CoreStylerBranch(
      schemaTypeIcon,
      (root, identity) =>
          iconStylerSchema(rootStyleSchema: root, identityContext: identity),
    ),
    _CoreStylerBranch(
      schemaTypeImage,
      (root, identity) =>
          imageStylerSchema(rootStyleSchema: root, identityContext: identity),
    ),
    _CoreStylerBranch(
      schemaTypeFlexBox,
      (root, identity) =>
          flexBoxStylerSchema(rootStyleSchema: root, identityContext: identity),
    ),
    _CoreStylerBranch(
      schemaTypeStackBox,
      (root, identity) => stackBoxStylerSchema(
        rootStyleSchema: root,
        identityContext: identity,
      ),
    ),
    _CoreStylerBranch(
      schemaTypeWrap,
      (root, identity) =>
          wrapStylerSchema(rootStyleSchema: root, identityContext: identity),
    ),
    _CoreStylerBranch(
      schemaTypeWrapBox,
      (root, identity) =>
          wrapBoxStylerSchema(rootStyleSchema: root, identityContext: identity),
    ),
    _CoreStylerBranch(
      schemaTypeGridBox,
      (root, _) => gridBoxStylerSchema(rootStyleSchema: root),
    ),
  ],
);

/// Internal result of validating and compiling a vocabulary composition.
final class MixProtocolVocabularyCompilation {
  final AckSchema<JsonMap, Object> rootSchema;
  final List<({String id, int wireVersion})> contributedVocabularies;
  final List<List<String>> lenientListEntryPathSuffixes;

  const MixProtocolVocabularyCompilation({
    required this.rootSchema,
    required this.contributedVocabularies,
    required this.lenientListEntryPathSuffixes,
  });
}

/// Validates and compiles an immutable vocabulary composition.
MixProtocolVocabularyCompilation compileMixProtocolVocabularies(
  List<MixProtocolVocabulary> vocabularies,
  MixProtocolIdentityContextHolder identityContext,
) {
  if (vocabularies.isEmpty) {
    throw ArgumentError.value(
      vocabularies,
      'vocabularies',
      'Must not be empty.',
    );
  }

  final byId = <String, MixProtocolVocabulary>{};
  for (final vocabulary in vocabularies) {
    if (!_wireIdentifierPattern.hasMatch(vocabulary.id)) {
      throw ArgumentError.value(
        vocabulary.id,
        'vocabulary.id',
        'Must match ${_wireIdentifierPattern.pattern}.',
      );
    }
    if (vocabulary.wireVersion < 1) {
      throw ArgumentError.value(
        vocabulary.wireVersion,
        'vocabulary.wireVersion',
        'Must be at least 1.',
      );
    }
    if (vocabulary.branches.isEmpty) {
      throw ArgumentError.value(
        vocabulary.branches,
        'vocabulary.branches',
        'Must not be empty.',
      );
    }
    if (byId.containsKey(vocabulary.id)) {
      throw ArgumentError(
        'Duplicate protocol vocabulary id "${vocabulary.id}".',
      );
    }
    byId[vocabulary.id] = vocabulary;
  }

  final core = byId['mix'];
  if (!identical(core, mixProtocolCoreVocabulary)) {
    throw ArgumentError(
      'Every composition must include mixProtocolCoreVocabulary exactly once.',
    );
  }

  final orderedVocabularies = [
    core!,
    ...byId.values.where((value) => !value._isCore).toList()
      ..sort((left, right) => left.id.compareTo(right.id)),
  ];
  final types = <Type>{};
  final discriminators = <String>{};
  late final AckSchema<JsonMap, Object> rootSchema;
  final rootReference = Ack.lazy<JsonMap, Object>(
    'mix_protocol_style',
    () => rootSchema,
  );
  final context = MixProtocolBranchContext._(
    rootReference,
    () => identityContext.current,
  );
  final schemas = <String, AckSchema<JsonMap, Object>>{};
  final branchFieldSemantics = <String, Map<String, SchemaFieldSemantics>>{};

  for (final vocabulary in orderedVocabularies) {
    final branches = vocabulary._isCore
        ? vocabulary.branches
        : ([...vocabulary.branches]
            ..sort((left, right) => left.name.compareTo(right.name)));
    for (final branch in branches) {
      if (!_wireIdentifierPattern.hasMatch(branch.name)) {
        throw ArgumentError.value(
          branch.name,
          'branch.name',
          'Must match ${_wireIdentifierPattern.pattern}.',
        );
      }
      if (!types.add(branch.valueType)) {
        throw ArgumentError(
          'Runtime type ${branch.valueType} is registered more than once.',
        );
      }
      final discriminator = vocabulary._isCore
          ? branch.name
          : '${vocabulary.id}.v${vocabulary.wireVersion}.${branch.name}';
      if (!discriminators.add(discriminator)) {
        throw ArgumentError(
          'Duplicate protocol styler discriminator "$discriminator".',
        );
      }
      final compiled = branch._build(context);
      schemas[discriminator] = compiled.schema;
      branchFieldSemantics[discriminator] = Map.unmodifiable(
        compiled.fieldSemantics,
      );
    }
  }

  rootSchema = Ack.discriminated<Object>(
    discriminatorKey: 'type',
    schemas: schemas,
  );

  return MixProtocolVocabularyCompilation(
    rootSchema: rootSchema,
    contributedVocabularies: List.unmodifiable([
      for (final vocabulary in orderedVocabularies)
        if (!vocabulary._isCore)
          (id: vocabulary.id, wireVersion: vocabulary.wireVersion),
    ]),
    lenientListEntryPathSuffixes: _collectLenientListEntryPathSuffixes(
      branchFieldSemantics,
    ),
  );
}

List<List<String>> _collectLenientListEntryPathSuffixes(
  Map<String, Map<String, SchemaFieldSemantics>> branchFieldSemantics,
) {
  final pathsByKey = <String, List<String>>{};

  void add(List<String> path) {
    final snapshot = List<String>.unmodifiable(path);
    pathsByKey.putIfAbsent(snapshot.join('\u0000'), () => snapshot);
  }

  add(const [applyDirectivesKey]);
  add(const [mergeReferenceKey]);
  for (final fields in branchFieldSemantics.values) {
    for (final entry in fields.entries) {
      for (final path in entry.value.listEntryPaths) {
        add([entry.key, ...path]);
      }
    }
  }

  return List.unmodifiable(pathsByKey.values);
}
