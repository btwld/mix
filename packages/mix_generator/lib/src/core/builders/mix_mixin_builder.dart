/// Mix mixin builder for generating _$XMixin.
///
/// Generates abstract getters, merge(), resolve(), debugFillProperties(), and props methods.
library;

import '../models/annotation_config.dart';
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

  String _buildAbstractGetters() {
    if (fields.isEmpty) return '';

    final buffer = StringBuffer();
    for (final field in fields) {
      final typeStr = field.dartType.getDisplayString();
      buffer.writeln('  $typeStr get ${field.declaredName};');
    }
    buffer.writeln();

    return buffer.toString();
  }

  String _buildMerge() {
    if (!config.generateMerge) return '';

    final buffer = StringBuffer();

    buffer.writeln('  /// Merges with another [$mixName].');
    buffer.writeln('  @override');
    buffer.writeln('  $mixName merge($mixName? other) {');
    buffer.writeln('    return $mixName.create(');

    // Field merge assignments
    for (final field in fields) {
      final fieldName = field.declaredName;
      final name = field.name;

      buffer.writeln(
        '      $name: MixOps.merge($fieldName, other?.$fieldName),',
      );
    }

    buffer.writeln('    );');
    buffer.writeln('  }');

    return buffer.toString();
  }

  String _buildResolve() {
    if (!config.generateResolve) return '';

    final buffer = StringBuffer();

    buffer.writeln('  /// Resolves to [$resolveToType] using context.');
    buffer.writeln('  @override');
    buffer.writeln('  $resolveToType resolve(BuildContext context) {');
    buffer.writeln('    return $resolveToType(');

    // Field resolve assignments
    for (final field in fields) {
      final fieldName = field.declaredName;
      final name = field.name;

      if (hasDefaultValue) {
        // Use defaultValue for fields when resolved value is null
        buffer.writeln(
          '      $name: MixOps.resolve(context, $fieldName) ?? defaultValue.$name,',
        );
      } else {
        // No default value, just resolve
        buffer.writeln('      $name: MixOps.resolve(context, $fieldName),');
      }
    }

    buffer.writeln('    );');
    buffer.writeln('  }');

    return buffer.toString();
  }

  String _buildProps() {
    if (!config.generateProps) return '';

    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.write('  List<Object?> get props => [');

    if (fields.isEmpty) {
      buffer.writeln('];');
    } else {
      buffer.writeln();
      for (final field in fields) {
        buffer.writeln('    ${field.declaredName},');
      }
      buffer.writeln('  ];');
    }

    return buffer.toString();
  }

  String _buildDebugFillProperties() {
    if (!config.generateDebugFillProperties) return '';

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
        final displayName = field.name;
        final fieldName = field.declaredName;
        final separator = i == fields.length - 1 ? ';' : '';
        buffer.writeln(
          "      ..add(DiagnosticsProperty('$displayName', $fieldName))$separator",
        );
      }
    }

    buffer.writeln('  }');

    return buffer.toString();
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
