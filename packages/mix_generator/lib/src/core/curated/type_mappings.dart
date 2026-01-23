/// Type mappings for the Mix generator.
///
/// This file contains curated mappings between Flutter types and Mix types.
library;

/// Flutter type → Mix type mapping.
/// Used to determine Prop.maybe vs Prop.maybeMix and constructor param types.
const mixTypeMap = {
  // Geometry (types with Mix variants that use Prop.maybeMix)
  'EdgeInsetsGeometry': 'EdgeInsetsGeometryMix',
  'BoxConstraints': 'BoxConstraintsMix',

  // Painting
  'Decoration': 'DecorationMix',
  'TextStyle': 'TextStyleMix',
  'StrutStyle': 'StrutStyleMix',
  'TextHeightBehavior': 'TextHeightBehaviorMix',
  'BorderRadiusGeometry': 'BorderRadiusGeometryMix',
  'BoxBorder': 'BoxBorderMix',

  // Shadows
  'Shadow': 'ShadowMix',
  'BoxShadow': 'BoxShadowMix',
};

/// Mix element type → ListMix type mapping.
/// Used when field is `List<MixType>` (keyed by element type).
const listMixTypeMap = {
  'ShadowMix': 'ShadowListMix',
  'BoxShadowMix': 'BoxShadowListMix',
};

/// Flutter element type → Mix element type mapping for List fields.
/// Used to convert `List<Shadow>` to `List<ShadowMix>` in styler constructor.
const listElementMixTypeMap = {
  'Shadow': 'ShadowMix',
  'BoxShadow': 'BoxShadowMix',
};

/// Direct types - use Prop.maybe, no Mix variant.
/// These types are passed through without conversion.
const directTypes = {
  // Primitives
  'double',
  'int',
  'bool',
  'String',

  // Geometry (use Prop.maybe, not Prop.maybeMix)
  'AlignmentGeometry', // BoxStyler: alignment uses Prop.maybe
  'Matrix4', // BoxStyler: transform uses Prop.maybe
  // Image
  'ImageProvider<Object>',
  'Rect',

  // Text
  'TextScaler',
  'Locale',

  // Other
  'IconData',
  'Color', // Note: Color uses Prop.maybe, not a ColorMix
};

/// Enum types - always use Prop.maybe + MixOps.lerpSnap.
const enumTypes = {
  'Clip',
  'Axis',
  'TextAlign',
  'TextDirection',
  'TextBaseline',
  'MainAxisAlignment',
  'CrossAxisAlignment',
  'MainAxisSize',
  'VerticalDirection',
  'TextOverflow',
  'TextWidthBasis',
  'BoxFit',
  'ImageRepeat',
  'FilterQuality',
  'BlendMode',
  'StackFit',
};

/// Types that support lerp (interpolation).
const lerpableTypes = {
  'double',
  'int',
  'num',
  'Color',
  'HSVColor',
  'HSLColor',
  'Offset',
  'Size',
  'Rect',
  'RRect',
  'Alignment',
  'FractionalOffset',
  'AlignmentGeometry',
  'EdgeInsets',
  'EdgeInsetsGeometry',
  'EdgeInsetsDirectional',
  'BorderRadius',
  'BorderRadiusGeometry',
  'BorderRadiusDirectional',
  'BorderSide',
  'Border',
  'BoxBorder',
  'ShapeBorder',
  'TextStyle',
  'StrutStyle',
  'BoxShadow',
  'Shadow',
  'BoxConstraints',
  'Constraints',
  'BoxDecoration',
  'ShapeDecoration',
  'Decoration',
  'LinearGradient',
  'RadialGradient',
  'SweepGradient',
  'Gradient',
  'Matrix4',
  'IconThemeData',
  'RelativeRect',
};

/// Types that snap (no interpolation).
const snappableTypes = {
  'bool',
  'String',
  'ImageProvider<Object>',
  'ImageProvider',
  'IconData',
  'TextScaler',
  'Locale',
  'TextHeightBehavior',
  // All enums are added dynamically
};

/// Raw list types that are NOT wrapped in Prop<>.
/// These use MixOps.mergeList instead of MixOps.merge.
const rawListTypes = {
  // fieldName: elementType
  'textDirectives': 'Directive<String>',
};

/// Field alias mappings for diagnostics and setters.
/// Key format: 'StylerName.fieldName'
class FieldAliasConfig {
  final String? diagnosticLabel;
  final String?
  setterName; // null means skip setter, empty string uses field name

  const FieldAliasConfig({this.diagnosticLabel, this.setterName});
}

const fieldAliasMap = {
  'TextStyler.textDirectives': FieldAliasConfig(
    diagnosticLabel: 'directives',
    setterName: null, // No setter - handled by custom methods
  ),
};
