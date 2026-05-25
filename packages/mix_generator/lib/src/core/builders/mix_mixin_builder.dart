/// Mix mixin builder for generating _$XMixin.
///
/// Generates abstract getters, merge(), resolve(), debugFillProperties(), and props methods.
library;

import '../models/annotation_config.dart';
import '../helpers/field_emitter.dart';
import '../models/mix_field_model.dart';

/// Builds the _$XMixin for a Mix class.
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

    buffer.writeln('  /// Resolves to [$resolveToType] using context.');
    buffer.writeln('  @override');
    buffer.writeln('  $resolveToType resolve(BuildContext context) {');
    buffer.writeln('    return $resolveToType(');

    _fieldEmitter().linesInto(buffer, (field) {
      final fieldName = field.declaredName;
      final name = field.name;
      if (hasDefaultValue) {
        // Use defaultValue for fields when resolved value is null
        return '      $name: MixOps.resolve(context, $fieldName) ?? defaultValue.$name,';
      }

      // No default value, just resolve
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

    // Build mixin declaration with appropriate constraints
    final constraints = ['Mix<$resolveToType>'];
    if (hasDefaultValue) {
      constraints.add('DefaultValue<$resolveToType>');
    }
    if (config.generateDebugFillProperties) {
      constraints.add('Diagnosticable');
    }

    buffer.writeln('mixin $generatedMixinName on ${constraints.join(', ')} {');

    // Generate abstract getters
    buffer.writeln(_buildAbstractGetters());

    // Generate merge
    if (config.generateMerge) {
      buffer.writeln(_buildMerge());
    }

    // Generate resolve
    if (config.generateResolve) {
      buffer.writeln(_buildResolve());
    }

    // Generate debugFillProperties
    if (config.generateDebugFillProperties) {
      buffer.writeln(_buildDebugFillProperties());
    }

    // Generate props
    if (config.generateProps) {
      buffer.writeln(_buildProps());
    }

    buffer.writeln('}');

    return buffer.toString();
  }
}
