/// Builder for generated `_$XMixin` code.
///
/// Emits abstract getters, `merge`, `resolve`, `debugFillProperties`, and
/// `props` members.
library;

import '../models/annotation_config.dart';
import '../helpers/field_emitter.dart';
import '../models/mix_field_model.dart';

/// Builds the `_$XMixin` for a Mix class.
class MixMixinBuilder {
  final String mixName;
  final String resolveToType;
  final List<MixFieldModel> fields;
  final MixableAnnotationConfig config;
  final bool hasDefaultValue;

  const MixMixinBuilder({
    required this.mixName,
    required this.resolveToType,
    required this.fields,
    required this.config,
    required this.hasDefaultValue,
  });

  FieldEmitter<MixFieldModel> _fieldEmitter() => .new(fields);

  String _buildAbstractGetters() {
    return _fieldEmitter().abstractGetters(
      typeCode: (field) => field.fieldTypeCode,
      getterName: (field) => field.declaredName,
    );
  }

  String _buildMerge() {
    final buffer = StringBuffer();

    buffer.writeln('  /// Merges with another [$mixName].');
    buffer.writeln('  @override');
    buffer.writeln('  $mixName merge($mixName? other) {');
    buffer.writeln('    return $mixName.create(');

    _fieldEmitter().linesInto(buffer, (field) {
      final fieldName = field.declaredName;
      final name = field.name;

      return '      $name: MixOps.merge($fieldName, other?.$fieldName),';
    });

    buffer.writeln('    );');
    buffer.writeln('  }');

    return buffer.toString();
  }

  String _buildResolve() {
    final buffer = StringBuffer();

    buffer.writeln('  /// Resolves to [$resolveToType] using [context].');
    buffer.writeln('  @override');
    buffer.writeln('  $resolveToType resolve(BuildContext context) {');
    buffer.writeln('    return $resolveToType(');

    _fieldEmitter().linesInto(buffer, (field) {
      final fieldName = field.declaredName;
      final name = field.name;
      if (hasDefaultValue) {
        // `DefaultValue<T>` supplies fallbacks for unresolved fields.
        return '      $name: MixOps.resolve(context, $fieldName) ?? defaultValue.$name,';
      }

      return '      $name: MixOps.resolve(context, $fieldName),';
    });

    buffer.writeln('    );');
    buffer.writeln('  }');

    return buffer.toString();
  }

  String _buildProps() {
    if (fields.isEmpty) {
      final buffer = StringBuffer();
      buffer.writeln('  @override');
      buffer.write('  List<Object?> get props => [');
      buffer.writeln('];');

      return buffer.toString();
    }

    return _fieldEmitter().multilineProps(
      propCode: (field) => field.declaredName,
    );
  }

  String _buildDebugFillProperties() {
    return _fieldEmitter().debugFillProperties(
      callSuper: true,
      propertyCode: (field) {
        return "DiagnosticsProperty('${field.name}', ${field.declaredName})";
      },
    );
  }

  /// The mixin name.
  String get generatedMixinName => '_\$${mixName}Mixin';

  /// Builds the complete mixin code.
  String build() {
    final buffer = StringBuffer();

    final constraints = ['Mix<$resolveToType>'];
    if (hasDefaultValue) {
      constraints.add('DefaultValue<$resolveToType>');
    }
    if (config.generateDebugFillProperties) {
      constraints.add('Diagnosticable');
    }

    buffer.writeln('mixin $generatedMixinName on ${constraints.join(', ')} {');

    buffer.writeln(_buildAbstractGetters());

    if (config.generateMerge) {
      buffer.writeln(_buildMerge());
    }

    if (config.generateResolve) {
      buffer.writeln(_buildResolve());
    }

    if (config.generateDebugFillProperties) {
      buffer.writeln(_buildDebugFillProperties());
    }

    if (config.generateProps) {
      buffer.writeln(_buildProps());
    }

    buffer.writeln('}');

    return buffer.toString();
  }
}
