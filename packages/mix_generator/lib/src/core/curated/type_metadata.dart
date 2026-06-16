/// Curated type metadata for the Mix generator.
///
/// The generator uses this registry to find Mix counterparts, choose
/// interpolation and diagnostic behavior, and label generated `FlagProperty`
/// instances.
library;

/// Kind of diagnostic property to use.
enum DiagnosticKind {
  /// `DiagnosticsProperty`, the default diagnostic wrapper.
  diagnostics,

  /// `ColorProperty`.
  color,

  /// `DoubleProperty`.
  doubleProperty,

  /// `IntProperty`.
  intProperty,

  /// `StringProperty`.
  stringProperty,

  /// `EnumProperty<T>`.
  enumProperty,

  /// `FlagProperty`, used for booleans with `ifTrue` labels.
  flagProperty,

  /// `IterableProperty<T>`.
  iterableProperty,
}

/// How a type should be treated for interpolation and diagnostics.
enum TypeCategory {
  /// An enum-like value that snaps and uses `EnumProperty<T>`.
  enumType,

  /// A value that can be interpolated with `MixOps.lerp`.
  lerpable,

  /// A value that should snap with `MixOps.lerpSnap`.
  snappable,
}

/// Metadata for a single Dart type name.
class TypeMetadata {
  /// The type's generated-code category.
  final TypeCategory category;

  /// The Mix counterpart, when the type supports `Prop.maybeMix`.
  final String? mixType;

  /// Styler mixins that own fluent methods for this field type.
  final List<String> ownerMixins;

  const TypeMetadata({
    required this.category,
    this.mixType,
    this.ownerMixins = const [],
  });

  /// Whether this type uses `MixOps.lerp`.
  bool get isLerpable => category == .lerpable;

  /// Whether this type uses `MixOps.lerpSnap`.
  bool get isSnappable => category == .snappable || category == .enumType;

  /// Whether this type should use `EnumProperty<T>`.
  bool get isEnum => category == .enumType;
}

/// Type metadata keyed by analyzer display name.
const Map<String, TypeMetadata> typeMetadata = {
  // Geometry types.
  'EdgeInsetsGeometry': TypeMetadata(
    category: .lerpable,
    mixType: 'EdgeInsetsGeometryMix',
    ownerMixins: ['SpacingStyleMixin'],
  ),
  'BoxConstraints': TypeMetadata(
    category: .lerpable,
    mixType: 'BoxConstraintsMix',
    ownerMixins: ['ConstraintStyleMixin'],
  ),
  'AlignmentGeometry': TypeMetadata(category: .lerpable),
  'Matrix4': TypeMetadata(
    category: .lerpable,
    ownerMixins: ['TransformStyleMixin'],
  ),

  // Painting types.
  'Decoration': TypeMetadata(
    category: .lerpable,
    mixType: 'DecorationMix',
    ownerMixins: [
      'DecorationStyleMixin',
      'BorderStyleMixin',
      'BorderRadiusStyleMixin',
      'ShadowStyleMixin',
    ],
  ),
  'TextStyle': TypeMetadata(category: .lerpable, mixType: 'TextStyleMix'),
  'StrutStyle': TypeMetadata(category: .lerpable, mixType: 'StrutStyleMix'),
  'TextHeightBehavior': TypeMetadata(
    category: .snappable,
    mixType: 'TextHeightBehaviorMix',
  ),
  'BorderRadiusGeometry': TypeMetadata(
    category: .lerpable,
    mixType: 'BorderRadiusGeometryMix',
  ),
  'BoxBorder': TypeMetadata(category: .lerpable, mixType: 'BoxBorderMix'),

  // Shadow types.
  'Shadow': TypeMetadata(category: .lerpable, mixType: 'ShadowMix'),
  'BoxShadow': TypeMetadata(category: .lerpable, mixType: 'BoxShadowMix'),

  // Primitives and common direct values.
  'double': TypeMetadata(category: .lerpable),
  'int': TypeMetadata(category: .snappable),
  'num': TypeMetadata(category: .lerpable),
  'bool': TypeMetadata(category: .snappable),
  'String': TypeMetadata(category: .snappable),
  'Color': TypeMetadata(category: .lerpable),
  'ImageProvider<Object>': TypeMetadata(category: .snappable),
  'ImageProvider': TypeMetadata(category: .snappable),
  'Rect': TypeMetadata(category: .lerpable),
  'TextScaler': TypeMetadata(category: .snappable),
  'Locale': TypeMetadata(category: .snappable),
  'IconData': TypeMetadata(category: .snappable),

  // Additional lerpable Flutter value types.
  'HSVColor': TypeMetadata(category: .lerpable),
  'HSLColor': TypeMetadata(category: .lerpable),
  'Offset': TypeMetadata(category: .lerpable),
  'Size': TypeMetadata(category: .lerpable),
  'RRect': TypeMetadata(category: .lerpable),
  'Alignment': TypeMetadata(category: .lerpable),
  'FractionalOffset': TypeMetadata(category: .lerpable),
  'EdgeInsets': TypeMetadata(category: .lerpable),
  'EdgeInsetsDirectional': TypeMetadata(category: .lerpable),
  'BorderRadius': TypeMetadata(category: .lerpable),
  'BorderRadiusDirectional': TypeMetadata(category: .lerpable),
  'BorderSide': TypeMetadata(category: .lerpable),
  'Border': TypeMetadata(category: .lerpable),
  'ShapeBorder': TypeMetadata(category: .lerpable),
  'Constraints': TypeMetadata(category: .lerpable),
  'BoxDecoration': TypeMetadata(category: .lerpable),
  'ShapeDecoration': TypeMetadata(category: .lerpable),
  'LinearGradient': TypeMetadata(category: .lerpable),
  'RadialGradient': TypeMetadata(category: .lerpable),
  'SweepGradient': TypeMetadata(category: .lerpable),
  'Gradient': TypeMetadata(category: .lerpable),
  'IconThemeData': TypeMetadata(category: .lerpable),
  'RelativeRect': TypeMetadata(category: .lerpable),

  // Enums.
  'Clip': TypeMetadata(category: .enumType),
  'Axis': TypeMetadata(category: .enumType),
  'TextAlign': TypeMetadata(category: .enumType),
  'TextDirection': TypeMetadata(category: .enumType),
  'TextBaseline': TypeMetadata(category: .enumType),
  'MainAxisAlignment': TypeMetadata(category: .enumType),
  'CrossAxisAlignment': TypeMetadata(category: .enumType),
  'MainAxisSize': TypeMetadata(category: .enumType),
  'FlexFit': TypeMetadata(category: .enumType),
  'VerticalDirection': TypeMetadata(category: .enumType),
  'TextOverflow': TypeMetadata(category: .enumType),
  'TextWidthBasis': TypeMetadata(category: .enumType),
  'BoxFit': TypeMetadata(category: .enumType),
  'ImageRepeat': TypeMetadata(category: .enumType),
  'FilterQuality': TypeMetadata(category: .enumType),
  'BlendMode': TypeMetadata(category: .enumType),
  'StackFit': TypeMetadata(category: .enumType),
};

/// Map from Mix element types to their generated list-mix types.
const listMixTypeMap = {
  'ShadowMix': 'ShadowListMix',
  'BoxShadowMix': 'BoxShadowListMix',
};

/// Map from Flutter list element types to Mix element types.
const listElementMixTypeMap = {
  'Shadow': 'ShadowMix',
  'BoxShadow': 'BoxShadowMix',
};

/// Raw list types that are not wrapped in `Prop<>`.
const rawListTypes = {'textDirectives': 'Directive<String>'};

/// Field alias mappings for diagnostics and setters.
class FieldAliasConfig {
  /// Diagnostic label override, or `null` to use the field name.
  final String? diagnosticLabel;

  /// Setter name override.
  ///
  /// `null` skips setter generation for mapped fields. An empty value keeps
  /// the field name.
  final String? setterName;

  const FieldAliasConfig({this.diagnosticLabel, this.setterName});
}

/// Field aliases keyed by `StylerName.fieldName`.
const fieldAliasMap = {
  'TextStyler.textDirectives': FieldAliasConfig(
    diagnosticLabel: 'directives',
    setterName: null,
  ),
};

/// Curated `FlagProperty.ifTrue` strings keyed by field name.
const flagPropertyDescriptions = {
  'softWrap': 'wrapping at word boundaries',
  'excludeFromSemantics': 'excluded from semantics',
  'gaplessPlayback': 'gapless playback',
  'isAntiAlias': 'anti-aliased',
  'matchTextDirection': 'matches text direction',
  'applyTextScaling': 'scales with text',
  'reverse': 'reversed',
  'visible': 'visible',
};

TypeMetadata? _metadataFor(String typeName) => typeMetadata[typeName];

/// The Mix counterpart for [typeName], if one exists.
String? mixTypeFor(String typeName) => _metadataFor(typeName)?.mixType;

/// The styler mixins that own fluent methods for [typeName].
List<String> ownerMixinsFor(String typeName) =>
    _metadataFor(typeName)?.ownerMixins ?? const [];

/// The Mix element type for a Flutter list element type.
String? listElementMixTypeFor(String typeName) =>
    listElementMixTypeMap[typeName];

/// The list-mix type for a Mix element type.
String? listMixTypeFor(String typeName) => listMixTypeMap[typeName];

/// The raw list element type for [fieldName], if curated.
String? rawListElementTypeFor(String fieldName) => rawListTypes[fieldName];

/// Whether [fieldName] is emitted as a raw list instead of `Prop<>`.
bool isRawListField(String fieldName) => rawListTypes.containsKey(fieldName);

/// The curated bool flag description for [fieldName], if one exists.
String? flagDescriptionFor(String fieldName) =>
    flagPropertyDescriptions[fieldName];

/// Whether [typeName] should be interpolated with `MixOps.lerp`.
bool isLerpableType(String typeName) =>
    _metadataFor(typeName)?.isLerpable ?? false;

/// Whether [typeName] should snap with `MixOps.lerpSnap`.
bool isSnappableType(String typeName) =>
    _metadataFor(typeName)?.isSnappable ?? false;

/// Whether [typeName] is a curated enum type.
bool isEnumType(String typeName) => _metadataFor(typeName)?.isEnum ?? false;

/// Returns the diagnostic property kind for [typeName].
DiagnosticKind diagnosticKindFor(String typeName, {required bool isList}) {
  if (isList) {
    return .iterableProperty;
  }

  return switch (typeName) {
    'Color' => .color,
    'double' => .doubleProperty,
    'int' => .intProperty,
    'String' => .stringProperty,
    'bool' => .flagProperty,
    _ when isEnumType(typeName) => .enumProperty,
    _ => .diagnostics,
  };
}
