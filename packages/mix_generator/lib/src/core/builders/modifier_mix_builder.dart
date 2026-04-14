/// Modifier Mix builder for generating ModifierMix classes.
///
/// Generates a full standalone class from @MixableModifier annotations.
library;

import '../registry/mix_type_registry.dart';

/// Represents a field from a WidgetModifier for code generation.
class ModifierFieldModel {
  /// The field name.
  final String name;

  /// The Dart type name of the field.
  final String typeName;

  /// The kind of Prop wrapper to use.
  final PropWrapperKind propWrapperKind;

  /// The Mix type name (only set when propWrapperKind is maybeMix).
  final String? mixTypeName;

  const ModifierFieldModel({
    required this.name,
    required this.typeName,
    required this.propWrapperKind,
    this.mixTypeName,
  });

  /// The type used in the public constructor parameter.
  String get publicParamType {
    if (propWrapperKind == PropWrapperKind.maybeMix && mixTypeName != null) {
      return mixTypeName!;
    }

    return typeName;
  }

  /// The Prop factory call expression.
  String get propFactoryCall {
    switch (propWrapperKind) {
      case PropWrapperKind.maybeMix:
        return 'Prop.maybeMix($name)';
      case PropWrapperKind.maybe:
        return 'Prop.maybe($name)';
      case PropWrapperKind.listMix:
      case PropWrapperKind.none:
        return 'Prop.maybe($name)';
    }
  }
}

/// Builds a full ModifierMix class from modifier field models.
class ModifierMixBuilder {
  final String modifierName;
  final List<ModifierFieldModel> fields;

  const ModifierMixBuilder({
    required this.modifierName,
    required this.fields,
  });

  /// The generated class name (e.g., OpacityModifier -> OpacityModifierMix).
  String get className => '${modifierName}Mix';

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
      return '  $className() : this.create();\n';
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
      buffer.writeln(
        '      ${field.name}: MixOps.resolve(context, ${field.name}),',
      );
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
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln(
      '  void debugFillProperties(DiagnosticPropertiesBuilder properties) {',
    );
    buffer.writeln('    super.debugFillProperties(properties);');

    if (fields.isNotEmpty) {
      buffer.writeln('    properties');
      for (int i = 0; i < fields.length; i++) {
        final field = fields[i];
        final separator = i == fields.length - 1 ? ';' : '';
        buffer.writeln(
          "      ..add(DiagnosticsProperty('${field.name}', ${field.name}))$separator",
        );
      }
    }

    buffer.writeln('  }');

    return buffer.toString();
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
