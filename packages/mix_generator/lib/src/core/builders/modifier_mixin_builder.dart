/// Modifier mixin builder for generating the `_$XModifier` mixin.
///
/// Generates the full WidgetModifier, Spec, Diagnosticable, and Equatable
/// contract for `@MixableModifier` annotated classes.
library;

import 'modifier_mix_builder.dart';
import '../helpers/field_emitter.dart';
import '../helpers/generated_contract_emitter.dart';
import '../resolvers/diagnostic_resolver.dart';
import '../resolvers/lerp_resolver.dart';

/// Builds the `_$XModifier` mixin for a WidgetModifier class.
class ModifierMixinBuilder {
  final String modifierName;
  final List<ModifierFieldModel> fields;
  final bool generateLerp;

  const ModifierMixinBuilder({
    required this.modifierName,
    required this.fields,
    this.generateLerp = true,
  });

  FieldEmitter<ModifierFieldModel> _fieldEmitter() => .new(fields);

  String _buildAbstractGetters() {
    return _fieldEmitter().abstractGetters(
      typeCode: (field) => field.fullTypeName,
      getterName: (field) => field.name,
    );
  }

  String _buildTypeGetter() {
    final buffer = StringBuffer();
    buffer.writeln('  @override');
    buffer.writeln('  Type get type => $modifierName;');

    return buffer.toString();
  }

  String _buildBuildContract() {
    final buffer = StringBuffer();
    buffer.writeln('  @override');
    buffer.writeln('  Widget build(Widget child);');

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

    if (fields.isEmpty) {
      buffer.writeln('    return const $modifierName();');
      buffer.writeln('  }');

      return buffer.toString();
    }

    buffer.writeln('    return $modifierName(');
    for (final field in fields) {
      final lerpCode = generateLerpCode(field.field);
      if (field.isNamedParam) {
        buffer.writeln('      ${field.name}: $lerpCode,');
      } else {
        buffer.writeln('      $lerpCode,');
      }
    }
    buffer.writeln('    );');
    buffer.writeln('  }');

    return buffer.toString();
  }

  String _buildDebugFillProperties() {
    return _fieldEmitter().debugFillProperties(
      callSuper: false,
      propertyCode: (field) => generateSpecDiagnosticCode(field.field),
    );
  }

  String _buildProps() {
    return _fieldEmitter().inlineProps(propCode: (field) => field.name);
  }

  /// The mixin name (e.g., AlignModifier -> _$AlignModifier).
  String get mixinName => '_\$$modifierName';

  /// Builds the complete mixin code.
  String build() {
    final buffer = StringBuffer();

    buffer.writeln(
      'mixin $mixinName implements WidgetModifier<$modifierName>, Diagnosticable {',
    );

    // Abstract getters
    buffer.write(_buildAbstractGetters());
    buffer.writeln(_buildTypeGetter());

    // copyWith
    buffer.writeln(_buildCopyWith());

    // lerp (opt-out via @MixableModifier(lerp: false))
    if (generateLerp) {
      buffer.writeln(_buildLerp());
    }

    // props
    buffer.writeln(_buildProps());
    buffer.writeln(buildEquatableSurface(modifierName));
    buffer.writeln(buildDiagnosticableSurface());
    buffer.writeln(_buildBuildContract());

    // debugFillProperties
    buffer.writeln(_buildDebugFillProperties());

    buffer.writeln('}');

    return buffer.toString();
  }
}
