/// Modifier mixin builder for generating _$XModifierMethods mixin.
///
/// Generates copyWith(), lerp(), debugFillProperties(), and props
/// for @MixableModifier annotated classes.
library;

import 'modifier_mix_builder.dart';

/// Builds the _$XModifierMethods mixin for a WidgetModifier class.
class ModifierMixinBuilder {
  final String modifierName;
  final List<ModifierFieldModel> fields;

  const ModifierMixinBuilder({
    required this.modifierName,
    required this.fields,
  });

  /// The mixin name (e.g., AlignModifier -> _$AlignModifierMethods).
  String get mixinName => '_\$${modifierName}Methods';

  String _buildAbstractGetters() {
    if (fields.isEmpty) return '';

    final buffer = StringBuffer();
    for (final field in fields) {
      buffer.writeln('  ${field.fullTypeName} get ${field.name};');
    }
    buffer.writeln();

    return buffer.toString();
  }

  String _buildCopyWith() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');

    if (fields.isEmpty) {
      buffer.writeln('  $modifierName copyWith() {');
      buffer.writeln('    return const $modifierName();');
      buffer.writeln('  }');

      return buffer.toString();
    }

    buffer.writeln('  $modifierName copyWith({');
    for (final field in fields) {
      final optionalType = field.isNullable
          ? field.fullTypeName
          : '${field.typeName}?';
      buffer.writeln('    $optionalType ${field.name},');
    }
    buffer.writeln('  }) {');
    buffer.writeln('    return $modifierName(');
    for (final field in fields) {
      if (field.isNamedParam) {
        buffer.writeln(
          '      ${field.name}: ${field.name} ?? this.${field.name},',
        );
      } else {
        buffer.writeln('      ${field.name} ?? this.${field.name},');
      }
    }
    buffer.writeln('    );');
    buffer.writeln('  }');

    return buffer.toString();
  }

  String _buildLerp() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln('  $modifierName lerp($modifierName? other, double t) {');
    buffer.writeln('    if (other == null) return this as $modifierName;');
    buffer.writeln();

    if (fields.isEmpty) {
      buffer.writeln('    return const $modifierName();');
      buffer.writeln('  }');

      return buffer.toString();
    }

    buffer.writeln('    return $modifierName(');
    for (final field in fields) {
      final lerpFn = field.isLerpable ? 'MixOps.lerp' : 'MixOps.lerpSnap';
      final nullAssert = field.isNullable ? '' : '!';
      if (field.isNamedParam) {
        buffer.writeln(
          '      ${field.name}: $lerpFn(${field.name}, other.${field.name}, t)$nullAssert,',
        );
      } else {
        buffer.writeln(
          '      $lerpFn(${field.name}, other.${field.name}, t)$nullAssert,',
        );
      }
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

    if (fields.length == 1) {
      final field = fields[0];
      final diagnosticCode = _getDiagnosticCode(field);
      buffer.writeln('    properties.add($diagnosticCode);');
    } else if (fields.length > 1) {
      buffer.writeln('    properties');
      for (int i = 0; i < fields.length; i++) {
        final field = fields[i];
        final diagnosticCode = _getDiagnosticCode(field);
        final separator = i == fields.length - 1 ? ';' : '';
        buffer.writeln('      ..add($diagnosticCode)$separator');
      }
    }

    buffer.writeln('  }');

    return buffer.toString();
  }

  String _getDiagnosticCode(ModifierFieldModel field) {
    final name = field.name;

    if (field.typeName == 'double') {
      return "DoubleProperty('$name', $name)";
    }
    if (field.typeName == 'int') {
      return "IntProperty('$name', $name)";
    }
    if (field.typeName == 'String') {
      return "StringProperty('$name', $name)";
    }
    if (field.typeName == 'Color') {
      return "ColorProperty('$name', $name)";
    }
    if (field.typeName == 'bool') {
      if (field.flagDescription != null) {
        return "FlagProperty('$name', value: $name, ifTrue: '${field.flagDescription}')";
      }

      return "DiagnosticsProperty('$name', $name)";
    }
    if (field.isEnum) {
      return "EnumProperty<${field.typeName}>('$name', $name)";
    }

    return "DiagnosticsProperty('$name', $name)";
  }

  String _buildProps() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.write('  List<Object?> get props => [');

    if (fields.isEmpty) {
      buffer.writeln('];');
    } else {
      final fieldNames = fields.map((f) => f.name).join(', ');
      buffer.writeln('$fieldNames];');
    }

    return buffer.toString();
  }

  /// Builds the complete mixin code.
  String build() {
    final buffer = StringBuffer();

    buffer.writeln(
      'mixin $mixinName on WidgetModifier<$modifierName>, Diagnosticable {',
    );

    // Abstract getters
    buffer.write(_buildAbstractGetters());

    // copyWith
    buffer.writeln(_buildCopyWith());

    // lerp
    buffer.writeln(_buildLerp());

    // debugFillProperties
    buffer.writeln(_buildDebugFillProperties());

    // props
    buffer.writeln(_buildProps());

    buffer.writeln('}');

    return buffer.toString();
  }
}
