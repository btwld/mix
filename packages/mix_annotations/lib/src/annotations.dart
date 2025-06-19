import 'generator_flags.dart';

/// Annotation for configuring generated methods and components for Spec classes.
///
/// [methods] specifies generated methods within the annotated class.
/// [components] specifies external generated code like utility classes or extensions.
class MixableSpec {
  final int methods;
  final int components;

  const MixableSpec({
    this.methods = GeneratedSpecMethods.all,
    this.components = GeneratedSpecComponents.all,
  });
}

/// An annotation class used to mark a constructor for code generation.
///
/// The `MixableConstructor` annotation is used to indicate that a constructor
/// should be included in the generated code. This allows for specific constructors
/// to be recognized by the code generator.
class MixableConstructor {
  /// Creates a new instance of `MixableConstructor`.
  ///
  /// Use this annotation on constructors that should be processed by the code generator.
  const MixableConstructor();
}

/// An annotation class used to mark a utility class for code generation.
///
/// The `MixableUtility` annotation is used to indicate that a class should be
/// treated as a utility class during code generation. Utility classes typically
/// provide helper methods and functionality that can be used by the generated code.
class MixableUtility {
  final int methods;

  /// Type will be used to create constructors for the same API as the reference type
  final Object? referenceType;

  /// Creates a new instance of `MixableUtility`.
  ///
  /// Use this annotation on classes that should be treated as utility classes
  /// by the code generator.
  const MixableUtility({
    this.methods = GeneratedUtilityMethods.all,
    this.referenceType,
  });
}

/// Annotation of `MixableDto` with the specified options.
///
/// Indicates the generator to generate code for this class.
///
/// The [mergeLists] parameter determines whether to merge lists based on
/// their position when mixing list properties. It defaults to `true`.
///
/// The [generateValueExtension] parameter specifies whether to generate
/// value extensions for the DTO. It defaults to `true`.
///
/// The [generateUtility] parameter specifies whether to generate a utility
/// class for the DTO. It defaults to `true`.
///
/// If the annotated class contains a merge method, it will not be generated
class MixableType {
  final bool mergeLists;
  final int components;

  const MixableType({
    this.components = GeneratedPropertyComponents.all,
    this.mergeLists = true,
  });
}

/// An annotation class used to specify a mixable property for code generation.
///
/// The `MixableField` annotation is used to mark a property as mixable
/// during code generation. It allows specifying an associated `MixableFieldType`
/// and a list of `MixableFieldUtility` instances that provide additional options for
/// code generation.
///
/// Example usage:
/// ```dart
/// @MixableField(
///   dto: MixableFieldType(type: BoxConstraintsDto),
///   utilities: [
///     MixableFieldUtility(
///       properties: [
///         (path: 'minWidth', alias: 'minWidth'),
///         (path: 'maxWidth', alias: 'maxWidth'),
///       ],
///     ),
///   ],
/// )
/// final BoxConstraints? constraints;
/// ```
class MixableField {
  /// The associated `MixableFieldType` for this property.
  ///
  /// This property represents the data transfer object (DTO) associated with
  /// the mixable property. It provides options for code generation, such as
  /// specifying the type of the generated field.
  final MixableFieldType? dto;

  /// The list of `MixableUtility` instances associated with this property.
  ///
  /// This property represents the utilities that provide additional options for
  /// code generation. Each utility can specify a set of properties with their
  /// corresponding paths and aliases.
  final List<MixableFieldUtility>? utilities;

  /// Determines whether the property can be linearly interpolated (lerped).
  ///
  /// If set to `false`, the property will be excluded from the lerp method,
  /// and the generated code will not include this property in the lerp implementation.
  /// If set to `true`, the property will be included in the lerp method.
  ///
  /// This flag affects the behavior of the generated `lerp` method:
  ///
  ///
  /// @override
  /// ExampleSpec lerp(ExampleSpec? other, double t) {
  ///   if (other == null) return _$this;
  ///
  ///   return ExampleSpec(
  ///     // When isLerpable is false:
  ///     nonLerpableParameter: other.nonLerpableParameter,
  ///     // When isLerpable is true:
  ///     lerpableParameter: lerpableParameter.lerp(other.lerpableParameter, t),
  ///   );
  /// }
  ///
  ///
  /// Setting `isLerpable` to `true` is particularly useful for properties
  /// that represent continuous values (e.g., numbers, colors, or sizes)
  /// which can be smoothly interpolated between two states.
  final bool isLerpable;

  /// Creates a new instance of `MixableField` with the specified options.
  ///
  /// The [dto] parameter specifies the data transfer object associated with this field.
  /// The [utilities] parameter provides a list of utility configurations for this field.
  /// The [isLerpable] parameter determines whether this field can be linearly interpolated,
  /// defaulting to `true`.
  const MixableField({this.dto, this.utilities, this.isLerpable = true});
}

/// An annotation class used to specify a mixable field DTO for code generation.
///
/// The `MixableFieldType` annotation is used to provide options for generating
/// a mixable field. It allows specifying the type of the generated field.
class MixableFieldType {
  /// The type of the generated field.
  ///
  /// This property represents the type that will be used for the generated
  /// field during code generation.
  final Object? type;

  /// Creates a new instance of `MixableFieldType` with the specified [type].
  const MixableFieldType({this.type});
}

/// A typedef representing a utility property for code generation.
///
/// The `MixableUtilityProps` typedef defines a utility property with a [path]
/// and an [alias]. It is used to specify the mapping between a property path
/// and its corresponding alias during code generation.
typedef MixableUtilityProps = ({String path, String alias});

/// An annotation class used to specify a mixable utility for code generation.
///
/// The `MixableUtility` annotation is used to provide additional options for
/// code generation. It allows specifying an alias, a type, and a list of
/// `MixableUtilityProps` instances that define the mapping between property
/// paths and their corresponding aliases.
///
/// Example usage:
/// ```dart
///  @MixableField(
///    utilities: MixableFieldUtility(
///      type: BoxDecoration,
///      properties: [
///        (path: 'color', alias: 'color'),
///        (path: 'border', alias: 'border'),
///        (path: 'borderRadius', alias: 'borderRadius'),
///      ],
/// );
/// final Decoration? decoration;
/// ```
class MixableFieldUtility {
  /// The alias for this utility.
  ///
  /// This property represents an alternative name or identifier for the
  /// utility during code generation.
  final String? alias;

  /// The type associated with this utility.
  ///
  /// This property represents the type that will be used for the utility
  /// during code generation.
  final Object? type;

  /// The list of `MixableUtilityProps` instances associated with this utility.
  ///
  /// This property represents the utility properties that define the mapping
  /// between property paths and their corresponding aliases during code
  /// generation.
  final List<MixableUtilityProps> properties;

  /// Creates a new instance of `MixableFieldUtility` with the specified options.
  ///
  /// The [alias] parameter provides an alternative name for this utility.
  /// The [type] parameter specifies the type associated with this utility.
  /// The [properties] parameter defines the mapping between property paths and aliases,
  /// defaulting to an empty list.
  const MixableFieldUtility({
    this.alias,
    this.type,
    this.properties = const [],
  });

  /// Returns the string representation of the type.
  ///
  /// If the type is a `String`, it is returned as is. Otherwise, the
  /// `toString()` method is called on the type.
  String? get typeAsString {
    return type is String ? type as String : type?.toString();
  }
}

/// An annotation class used to specify a mixable token for code generation.
///
/// The `MixableToken` annotation is used to mark a token for code generation.
/// It allows specifying the type, namespace, and extension generation options.
class MixableToken {
  /// The type of the token.
  final Object type;

  /// The namespace for the token.
  final String? namespace;

  /// Whether to generate a utility extension for this token.
  final bool utilityExtension;

  /// Whether to generate a context extension for this token.
  final bool contextExtension;

  /// Creates a new instance of `MixableToken` with the specified options.
  ///
  /// The [type] parameter specifies the type of the token.
  /// The [namespace] parameter provides a namespace for the token.
  /// The [utilityExtension] parameter determines whether to generate a utility extension,
  /// defaulting to `true`.
  /// The [contextExtension] parameter determines whether to generate a context extension,
  /// defaulting to `true`.
  const MixableToken(
    this.type, {
    this.namespace,
    this.utilityExtension = true,
    this.contextExtension = true,
  });
}

/// An annotation class used to specify a swatch color token for code generation.
///
/// The `MixableSwatchColorToken` annotation is used to configure a swatch color token
/// for code generation. It allows specifying the scale and default value.
class MixableSwatchColorToken {
  /// The scale of the swatch color.
  final int scale;

  /// The default value of the swatch color.
  final int defaultValue;

  /// Creates a new instance of `MixableSwatchColorToken` with the specified options.
  ///
  /// The [scale] parameter specifies the scale of the swatch color, defaulting to 3.
  /// The [defaultValue] parameter specifies the default value, defaulting to 1.
  const MixableSwatchColorToken({this.scale = 3, this.defaultValue = 1});
}
