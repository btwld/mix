/// Modifier mixin builder for generating the `_$XModifier` mixin.
///
/// Generates the full WidgetModifier, Spec, Diagnosticable, and Equatable
/// contract for `@MixableModifier` annotated classes.
library;

import 'modifier_mix_builder.dart';
import '../helpers/field_emitter.dart';
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

  /// Emits `==`, `hashCode`, `stringify`, and `getDiff` overrides that
  /// delegate to the shared Equatable helpers.
  String _buildEquatableSurface() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln('  bool operator ==(Object other) {');
    buffer.writeln('    return identical(this, other) ||');
    buffer.writeln('        other is $modifierName &&');
    buffer.writeln('            runtimeType == other.runtimeType &&');
    buffer.writeln('            propsEquals(props, other.props);');
    buffer.writeln('  }');
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln('  int get hashCode => propsHash(runtimeType, props);');
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln('  bool get stringify => true;');
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln('  Map<String, String> getDiff(Equatable other) {');
    buffer.writeln('    if (this == other) return const {};');
    buffer.writeln();
    buffer.writeln('    return propsDiff(props, other.props);');
    buffer.writeln('  }');

    return buffer.toString();
  }

  /// Emits Diagnosticable's concrete bodies because the mixin implements
  /// Diagnosticable rather than inheriting from it.
  String _buildDiagnosticableSurface() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln("  String toStringShort() => '\$runtimeType';");
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln(
      '  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>',
    );
    buffer.writeln(
      '      toDiagnosticsNode(style: DiagnosticsTreeStyle.singleLine)',
    );
    buffer.writeln('          .toString(minLevel: minLevel);');
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln(
      '  DiagnosticsNode toDiagnosticsNode({String? name, DiagnosticsTreeStyle? style}) =>',
    );
    buffer.writeln(
      '      DiagnosticableNode<Diagnosticable>(name: name, value: this, style: style);',
    );

    return buffer.toString();
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
    buffer.writeln(_buildEquatableSurface());
    buffer.writeln(_buildDiagnosticableSurface());
    buffer.writeln(_buildBuildContract());

    // debugFillProperties
    buffer.writeln(_buildDebugFillProperties());

    buffer.writeln('}');

    return buffer.toString();
  }
}
