/// Modifier Mix builder for generating ModifierMix classes.
///
/// Generates a full standalone class from `@MixableModifier` annotations.
library;

import '../curated/type_metadata.dart';
import '../helpers/field_emitter.dart';
import '../models/field_model.dart';

/// Kind of `Prop` wrapper to use for a modifier field.
enum PropWrapperKind {
  /// `Prop.maybe(value)` — for direct/enum types.
  maybe,

  /// `Prop.maybeMix(value)` — for types with a Mix counterpart.
  maybeMix,
}

/// Represents a field from a WidgetModifier for code generation.
///
/// Shared [FieldModel] metadata owns the field name, visible type, diagnostics,
/// and lerp decisions. This wrapper adds only modifier-specific constructor
/// facts and public `ModifierMix` parameter wrapping.
class ModifierFieldModel {
  /// Shared field metadata derived from the modifier field element.
  final FieldModel field;

  /// Whether this field is a named parameter in the modifier constructor.
  final bool isNamedParam;

  final PropWrapperKind? _propWrapperKind;
  final String? _mixTypeName;

  ModifierFieldModel({
    required String name,
    required String typeName,
    this.isNamedParam = true,
    bool isNullable = false,
    bool isLerpable = false,
    bool isEnum = false,
    DiagnosticKind? diagnosticKind,
    String? flagDescription,
    PropWrapperKind? propWrapperKind,
    String? mixTypeName,
  }) : field = FieldModel(
         name: name,
         typeName: typeName,
         isList: false,
         effectiveSpecType: '$typeName${isNullable ? '?' : ''}',
         isLerpable: isLerpable,
         diagnosticKind:
             diagnosticKind ??
             (isEnum ? .enumProperty : null) ??
             diagnosticKindFor(typeName, isList: false),
         flagDescription: flagDescription,
       ),
       _propWrapperKind = propWrapperKind,
       _mixTypeName = mixTypeName;

  const ModifierFieldModel.fromField({
    required this.field,
    this.isNamedParam = true,
    PropWrapperKind? propWrapperKind,
    String? mixTypeName,
  }) : _propWrapperKind = propWrapperKind,
       _mixTypeName = mixTypeName;

  /// The field name.
  String get name => field.name;

  /// The Dart type name of the field without nullability.
  String get typeName => field.typeName;

  /// The full type name including nullability suffix.
  String get fullTypeName => field.effectiveSpecType;

  /// Whether this field's type is nullable.
  bool get isNullable => fullTypeName.endsWith('?');

  /// Whether this field supports lerp interpolation.
  bool get isLerpable => field.isLerpable;

  /// The kind of Prop wrapper to use.
  PropWrapperKind get propWrapperKind {
    final explicit = _propWrapperKind;
    if (explicit != null) return explicit;

    return mixTypeName == null ? .maybe : .maybeMix;
  }

  /// The Mix type name (only set when propWrapperKind is maybeMix).
  String? get mixTypeName => _mixTypeName ?? mixTypeFor(typeName);

  /// The type used in the public constructor parameter.
  String get publicParamType {
    if (propWrapperKind == .maybeMix && mixTypeName != null) {
      return mixTypeName!;
    }

    return typeName;
  }

  /// The Prop factory call expression.
  String get propFactoryCall {
    switch (propWrapperKind) {
      case .maybeMix:
        return 'Prop.maybeMix($name)';
      case .maybe:
        return 'Prop.maybe($name)';
    }
  }
}

/// Builds a full ModifierMix class from modifier field models.
class ModifierMixBuilder {
  final String modifierName;
  final List<ModifierFieldModel> fields;

  const ModifierMixBuilder({required this.modifierName, required this.fields});

  FieldEmitter<ModifierFieldModel> _fieldEmitter() => .new(fields);

  String _buildFields() {
    if (fields.isEmpty) return '';

    final buffer = StringBuffer();
    for (final field in fields) {
      buffer.writeln('  final Prop<${field.typeName}>? ${field.name};');
    }
    buffer.writeln();

    return buffer.toString();
  }

  String _buildCreateConstructor() {
    if (fields.isEmpty) {
      return '  const $className.create();\n';
    }

    final buffer = StringBuffer();
    buffer.write('  const $className.create({');
    buffer.write(fields.map((f) => 'this.${f.name}').join(', '));
    buffer.writeln('});');

    return buffer.toString();
  }

  String _buildPublicConstructor() {
    if (fields.isEmpty) {
      return '  const $className() : this.create();\n';
    }

    final buffer = StringBuffer();

    // Constructor signature
    buffer.writeln('  $className({');
    for (final field in fields) {
      buffer.writeln('    ${field.publicParamType}? ${field.name},');
    }
    buffer.writeln('  }) : this.create(');

    // Prop wrapping
    for (final field in fields) {
      buffer.writeln('      ${field.name}: ${field.propFactoryCall},');
    }
    buffer.writeln('    );');

    return buffer.toString();
  }

  String _buildResolve() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln('  $modifierName resolve(BuildContext context) {');
    buffer.writeln('    return $modifierName(');

    for (final field in fields) {
      if (field.isNamedParam) {
        buffer.writeln(
          '      ${field.name}: MixOps.resolve(context, ${field.name}),',
        );
      } else {
        buffer.writeln('      MixOps.resolve(context, ${field.name}),');
      }
    }

    buffer.writeln('    );');
    buffer.writeln('  }');

    return buffer.toString();
  }

  String _buildMerge() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln('  $className merge($className? other) {');
    buffer.writeln('    if (other == null) return this;');
    buffer.writeln();
    buffer.writeln('    return $className.create(');

    for (final field in fields) {
      buffer.writeln(
        '      ${field.name}: MixOps.merge(${field.name}, other.${field.name}),',
      );
    }

    buffer.writeln('    );');
    buffer.writeln('  }');

    return buffer.toString();
  }

  String _buildDebugFillProperties() {
    return _fieldEmitter().debugFillProperties(
      callSuper: true,
      propertyCode: (field) =>
          "DiagnosticsProperty('${field.name}', ${field.name})",
    );
  }

  String _buildProps() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.write('  List<Object?> get props => [');

    if (fields.isEmpty) {
      buffer.writeln('];');
    } else {
      buffer.writeln();
      for (final field in fields) {
        buffer.writeln('    ${field.name},');
      }
      buffer.writeln('  ];');
    }

    return buffer.toString();
  }

  /// The generated class name (e.g., OpacityModifier -> OpacityModifierMix).
  String get className => '${modifierName}Mix';

  /// Builds the complete class code.
  String build() {
    final buffer = StringBuffer();

    buffer.writeln(
      'class $className extends ModifierMix<$modifierName> with Diagnosticable {',
    );

    // Fields
    buffer.write(_buildFields());

    // Constructors
    buffer.writeln(_buildCreateConstructor());
    buffer.writeln(_buildPublicConstructor());

    // Methods
    buffer.writeln(_buildResolve());
    buffer.writeln(_buildMerge());
    buffer.writeln(_buildDebugFillProperties());
    buffer.writeln(_buildProps());

    buffer.writeln('}');

    return buffer.toString();
  }
}
